; RUN: opt -passes=inline %s -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv7m-arm-none-eabi"

; CHECK-LABEL: void @doCalls
define void @doCalls(ptr nocapture %p1, ptr nocapture %p2, i32 %n) #0 {
entry:
  %div = lshr i32 %n, 1
; CHECK: call void @LoopCall
  tail call void @LoopCall(ptr %p1, ptr %p2, i32 %div) #0

  %div2 = lshr i32 %n, 2
; CHECK: call void @LoopCall
  tail call void @LoopCall(ptr %p1, ptr %p2, i32 %div2) #0

; CHECK-NOT: call void @LoopCall
  tail call void @LoopCall(ptr %p2, ptr %p1, i32 0) #0

; CHECK-NOT: call void @LoopCall_internal
  tail call void @LoopCall_internal(ptr %p1, ptr %p2, i32 %div2) #0

  %div3 = lshr i32 %n, 4
; CHECK-NOT: call void @SimpleCall
  tail call void @SimpleCall(ptr %p2, ptr %p1, i32 %div3) #0
  ret void
}

; CHECK-LABEL: define void @LoopCall
define void @LoopCall(ptr nocapture %dest, ptr nocapture readonly %source, i32 %num) #0 {
entry:
  %c = icmp ne i32 %num, 0
  br i1 %c, label %while.cond, label %while.end

while.cond:                                       ; preds = %while.body, %entry
  %num.addr.0 = phi i32 [ %num, %entry ], [ %dec, %while.body ]
  %p_dest.0 = phi ptr [ %dest, %entry ], [ %incdec.ptr2, %while.body ]
  %p_source.0 = phi ptr [ %source, %entry ], [ %incdec.ptr, %while.body ]
  %cmp = icmp eq i32 %num.addr.0, 0
  br i1 %cmp, label %while.end, label %while.body

while.body:                                       ; preds = %while.cond
  %incdec.ptr = getelementptr inbounds i8, ptr %p_source.0, i32 1
  %0 = load i8, ptr %p_source.0, align 1
  %1 = trunc i32 %num.addr.0 to i8
  %conv1 = add i8 %0, %1
  %incdec.ptr2 = getelementptr inbounds i8, ptr %p_dest.0, i32 1
  store i8 %conv1, ptr %p_dest.0, align 1
  %dec = add i32 %num.addr.0, -1
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; CHECK-LABEL-NOT: define void @LoopCall_internal
define internal void @LoopCall_internal(ptr nocapture %dest, ptr nocapture readonly %source, i32 %num) #0 {
entry:
  %c = icmp ne i32 %num, 0
  br i1 %c, label %while.cond, label %while.end

while.cond:                                       ; preds = %while.body, %entry
  %num.addr.0 = phi i32 [ %num, %entry ], [ %dec, %while.body ]
  %p_dest.0 = phi ptr [ %dest, %entry ], [ %incdec.ptr2, %while.body ]
  %p_source.0 = phi ptr [ %source, %entry ], [ %incdec.ptr, %while.body ]
  %cmp = icmp eq i32 %num.addr.0, 0
  br i1 %cmp, label %while.end, label %while.body

while.body:                                       ; preds = %while.cond
  %incdec.ptr = getelementptr inbounds i8, ptr %p_source.0, i32 1
  %0 = load i8, ptr %p_source.0, align 1
  %1 = trunc i32 %num.addr.0 to i8
  %conv1 = add i8 %0, %1
  %incdec.ptr2 = getelementptr inbounds i8, ptr %p_dest.0, i32 1
  store i8 %conv1, ptr %p_dest.0, align 1
  %dec = add i32 %num.addr.0, -1
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; CHECK-LABEL: define void @SimpleCall
define void @SimpleCall(ptr nocapture %dest, ptr nocapture readonly %source, i32 %num) #0 {
entry:
  %arrayidx = getelementptr inbounds i8, ptr %source, i32 %num
  %0 = load i8, ptr %arrayidx, align 1
  %1 = xor i8 %0, 127
  %arrayidx2 = getelementptr inbounds i8, ptr %dest, i32 %num
  store i8 %1, ptr %arrayidx2, align 1
  ret void
}

attributes #0 = { minsize optsize }

