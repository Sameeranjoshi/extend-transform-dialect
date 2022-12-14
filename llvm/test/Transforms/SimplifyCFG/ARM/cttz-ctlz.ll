; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=simplifycfg -simplifycfg-require-and-preserve-domtree=1 -mtriple=arm -mattr=+v6t2 < %s | FileCheck %s

define i32 @ctlz(i32 %A) {
; CHECK-LABEL: @ctlz(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[A:%.*]], 0
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @llvm.ctlz.i32(i32 [[A]], i1 true)
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[TOBOOL]], i32 32, i32 [[TMP0]]
; CHECK-NEXT:    ret i32 [[SPEC_SELECT]]
;
entry:
  %tobool = icmp eq i32 %A, 0
  br i1 %tobool, label %cond.end, label %cond.true

cond.true:
  %0 = tail call i32 @llvm.ctlz.i32(i32 %A, i1 true)
  br label %cond.end

cond.end:
  %cond = phi i32 [ %0, %cond.true ], [ 32, %entry ]
  ret i32 %cond
}

define i32 @cttz(i32 %A) {
; CHECK-LABEL: @cttz(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[A:%.*]], 0
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @llvm.cttz.i32(i32 [[A]], i1 true)
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[TOBOOL]], i32 32, i32 [[TMP0]]
; CHECK-NEXT:    ret i32 [[SPEC_SELECT]]
;
entry:
  %tobool = icmp eq i32 %A, 0
  br i1 %tobool, label %cond.end, label %cond.true

cond.true:
  %0 = tail call i32 @llvm.cttz.i32(i32 %A, i1 true)
  br label %cond.end

cond.end:
  %cond = phi i32 [ %0, %cond.true ], [ 32, %entry ]
  ret i32 %cond
}

declare i32 @llvm.ctlz.i32(i32, i1)
declare i32 @llvm.cttz.i32(i32, i1)

