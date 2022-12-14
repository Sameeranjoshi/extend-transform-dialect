; RUN: opt -passes='print<access-info>' -aa-pipeline='basic-aa' -disable-output < %s  2>&1 | FileCheck %s

; If the arrays don't alias this loop is safe with no memchecks:
;   for (i = 0; i < n; i++)
;    A[i] = A[i] * B[i] * C[i];

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.10.0"

; Check the loop-carried forward anti-dep between the load of A[i+1] and the
; store of A[i];

; CHECK: Memory dependences are safe{{$}}
; CHECK-NEXT: Dependences:
; CHECK-NEXT:   Forward:
; CHECK-NEXT:     %loadA_plus_2 = load i16, ptr %arrayidxA_plus_2, align 2 ->
; CHECK-NEXT:     store i16 %mul1, ptr %arrayidxA, align 2


define void @f(ptr noalias %a,
               ptr noalias %b,
               ptr noalias %c) {
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %ind = phi i64 [ 0, %entry ], [ %add, %for.body ]

  %add = add nuw nsw i64 %ind, 1

  %arrayidxA_plus_2 = getelementptr inbounds i16, ptr %a, i64 %add
  %loadA_plus_2 = load i16, ptr %arrayidxA_plus_2, align 2

  %arrayidxB = getelementptr inbounds i16, ptr %b, i64 %ind
  %loadB = load i16, ptr %arrayidxB, align 2

  %arrayidxC = getelementptr inbounds i16, ptr %c, i64 %ind
  %loadC = load i16, ptr %arrayidxC, align 2

  %mul = mul i16 %loadB, %loadA_plus_2
  %mul1 = mul i16 %mul, %loadC

  %arrayidxA = getelementptr inbounds i16, ptr %a, i64 %ind
  store i16 %mul1, ptr %arrayidxA, align 2

  %exitcond = icmp eq i64 %add, 20
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}
