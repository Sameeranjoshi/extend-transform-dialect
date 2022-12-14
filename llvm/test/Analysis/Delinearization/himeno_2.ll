; RUN: opt < %s -passes='print<delinearization>' -disable-output 2>&1 | FileCheck %s

; #define MR(mt,n,r,c,d)  mt->m[(n) * mt->mrows * mt->mcols * mt->mdeps + (r) * mt->mcols* mt->mdeps + (c) * mt->mdeps + (d)]
;
; struct Mat {
;   float* m;
;   int mnums;
;   int mrows;
;   int mcols;
;   int mdeps;
; };
;
; typedef struct Mat Matrix;
;
; void jacobi(int nn, Matrix* a, Matrix* p)
; {
;   long i, j, k, max,jmax,kmax;
;
;   p_rows_sub = p->mrows - 1;
;   p_cols_sub = p->mcols - 1;
;   p_deps_sub = p->mdeps - 1;
;
;     for(i = 1; i < p_rows_sub; i++)
;       for(j = 1; j < p_cols_sub; j++)
;         for(k = 1; k < p_deps_sub; k++)
;           MR(a,0,i,j,k) = i + j + k;
; }

; AddRec: {{{(4 + (4 * (sext i32 %a.deps to i64) * (1 + (sext i32 %a.cols to i64))) + %a.base),+,(4 * (sext i32 %a.deps to i64) * (sext i32 %a.cols to i64))}<%for.i>,+,(4 * (sext i32 %a.deps to i64))}<%for.j>,+,4}<%for.k>
; CHECK: Base offset: %a.base
; CHECK: ArrayDecl[UnknownSize][(sext i32 %a.cols to i64)][(sext i32 %a.deps to i64)] with elements of 4 bytes.
; CHECK: ArrayRef[{1,+,1}<nuw><nsw><%for.i>][{1,+,1}<nuw><nsw><%for.j>][{1,+,1}<nuw><nsw><%for.k>]

%struct.Mat = type { ptr, i32, i32, i32, i32 }

define void @jacobi(i32 %nn, ptr nocapture %a, ptr nocapture %p) nounwind uwtable {
entry:
  %p.rows.ptr = getelementptr inbounds %struct.Mat, ptr %p, i64 0, i32 2
  %p.rows = load i32, ptr %p.rows.ptr
  %p.rows.sub = add i32 %p.rows, -1
  %p.rows.sext = sext i32 %p.rows.sub to i64
  %p.cols.ptr = getelementptr inbounds %struct.Mat, ptr %p, i64 0, i32 3
  %p.cols = load i32, ptr %p.cols.ptr
  %p.cols.sub = add i32 %p.cols, -1
  %p.cols.sext = sext i32 %p.cols.sub to i64
  %p.deps.ptr = getelementptr inbounds %struct.Mat, ptr %p, i64 0, i32 4
  %p.deps = load i32, ptr %p.deps.ptr
  %p.deps.sub = add i32 %p.deps, -1
  %p.deps.sext = sext i32 %p.deps.sub to i64
  %a.cols.ptr = getelementptr inbounds %struct.Mat, ptr %a, i64 0, i32 3
  %a.cols = load i32, ptr %a.cols.ptr
  %a.cols.sext = sext i32 %a.cols to i64
  %a.deps.ptr = getelementptr inbounds %struct.Mat, ptr %a, i64 0, i32 4
  %a.deps = load i32, ptr %a.deps.ptr
  %a.deps.sext = sext i32 %a.deps to i64
  %a.base = load ptr, ptr %a, align 8
  br label %for.i

for.i:                                            ; preds = %for.i.inc, %entry
  %i = phi i64 [ %i.inc, %for.i.inc ], [ 1, %entry ]
  br label %for.j

for.j:                                            ; preds = %for.j.inc, %for.i
  %j = phi i64 [ %j.inc, %for.j.inc ], [ 1, %for.i ]
  br label %for.k

for.k:                                            ; preds = %for.k, %for.j
  %k = phi i64 [ 1, %for.j ], [ %k.inc, %for.k ]
  %tmp1 = mul nsw i64 %a.cols.sext, %i
  %tmp2 = add i64 %tmp1, %j
  %tmp3 = mul i64 %tmp2, %a.deps.sext
  %tmp4 = add nsw i64 %k, %tmp3
  %arrayidx = getelementptr inbounds float, ptr %a.base, i64 %tmp4
  store float 1.000000e+00, ptr %arrayidx
  %k.inc = add nsw i64 %k, 1
  %k.exitcond = icmp eq i64 %k.inc, %p.deps.sext
  br i1 %k.exitcond, label %for.j.inc, label %for.k

for.j.inc:                                        ; preds = %for.k
  %j.inc = add nsw i64 %j, 1
  %j.exitcond = icmp eq i64 %j.inc, %p.cols.sext
  br i1 %j.exitcond, label %for.i.inc, label %for.j

for.i.inc:                                        ; preds = %for.j.inc
  %i.inc = add nsw i64 %i, 1
  %i.exitcond = icmp eq i64 %i.inc, %p.rows.sext
  br i1 %i.exitcond, label %end, label %for.i

end:                                              ; preds = %for.i.inc
  ret void
}
