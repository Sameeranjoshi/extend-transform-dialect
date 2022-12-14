; RUN: opt -passes='print<access-info>' -disable-output  < %s 2>&1 | FileCheck %s

; Analyze this loop:
;   for (i = 0; i < n; i++)
;    A[i + 1] = A[i] * B[i] * C[i];

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; CHECK: for.body:
; CHECK: Has convergent operation in loop
; CHECK: Report: cannot add control dependency to convergent operation
; CHECK-NEXT: Dependences:
; CHECK-NEXT:   Backward:
; CHECK-NEXT:     %loadA = load i16, ptr %arrayidxA, align 2 ->
; CHECK-NEXT:     store i16 %mul1, ptr %arrayidxA_plus_2, align 2
; CHECK: Run-time memory checks:
; CHECK-NEXT: 0:
; CHECK-NEXT: Comparing group
; CHECK-NEXT:   %arrayidxA = getelementptr inbounds i16, ptr %a, i64 %storemerge3
; CHECK-NEXT:   %arrayidxA_plus_2 = getelementptr inbounds i16, ptr %a, i64 %add
; CHECK-NEXT: Against group
; CHECK-NEXT:   %arrayidxB = getelementptr inbounds i16, ptr %b, i64 %storemerge3
; CHECK-NEXT: 1:
; CHECK-NEXT: Comparing group
; CHECK-NEXT:   %arrayidxA = getelementptr inbounds i16, ptr %a, i64 %storemerge3
; CHECK-NEXT:   %arrayidxA_plus_2 = getelementptr inbounds i16, ptr %a, i64 %add
; CHECK-NEXT: Against group
; CHECK-NEXT:   %arrayidxC = getelementptr inbounds i16, ptr %c, i64 %storemerge3

@B = common global ptr null, align 8
@A = common global ptr null, align 8
@C = common global ptr null, align 8

define void @f() #1 {
entry:
  %a = load ptr, ptr @A, align 8
  %b = load ptr, ptr @B, align 8
  %c = load ptr, ptr @C, align 8
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %storemerge3 = phi i64 [ 0, %entry ], [ %add, %for.body ]

  %arrayidxA = getelementptr inbounds i16, ptr %a, i64 %storemerge3
  %loadA = load i16, ptr %arrayidxA, align 2

  %arrayidxB = getelementptr inbounds i16, ptr %b, i64 %storemerge3
  %loadB = load i16, ptr %arrayidxB, align 2

  %arrayidxC = getelementptr inbounds i16, ptr %c, i64 %storemerge3
  %loadC = load i16, ptr %arrayidxC, align 2

  call void @llvm.convergent()

  %mul = mul i16 %loadB, %loadA
  %mul1 = mul i16 %mul, %loadC

  %add = add nuw nsw i64 %storemerge3, 1
  %arrayidxA_plus_2 = getelementptr inbounds i16, ptr %a, i64 %add
  store i16 %mul1, ptr %arrayidxA_plus_2, align 2

  %exitcond = icmp eq i64 %add, 20
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}

declare void @llvm.convergent() #0

attributes #0 = { nounwind readnone convergent }
attributes #1 = { nounwind convergent }
