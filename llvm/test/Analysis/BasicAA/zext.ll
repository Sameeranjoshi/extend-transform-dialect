; RUN: opt < %s -aa-pipeline=basic-aa -passes=aa-eval -print-all-alias-modref-info -disable-output 2>&1 | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; CHECK-LABEL: test_with_zext
; CHECK:  NoAlias: i8* %a, i8* %b

define void @test_with_zext() {
  %1 = tail call ptr @malloc(i64 120)
  %a = getelementptr inbounds i8, ptr %1, i64 8
  %2 = getelementptr inbounds i8, ptr %1, i64 16
  %3 = zext i32 3 to i64
  %b = getelementptr inbounds i8, ptr %2, i64 %3
  load i8, ptr %a
  load i8, ptr %b
  ret void
}

; CHECK-LABEL: test_with_lshr
; CHECK:  NoAlias: i8* %a, i8* %b

define void @test_with_lshr(i64 %i) {
  %1 = tail call ptr @malloc(i64 120)
  %a = getelementptr inbounds i8, ptr %1, i64 8
  %2 = getelementptr inbounds i8, ptr %1, i64 16
  %3 = lshr i64 %i, 2
  %b = getelementptr inbounds i8, ptr %2, i64 %3
  load i8, ptr %a
  load i8, ptr %b
  ret void
}

; CHECK-LABEL: test_with_lshr_different_sizes
; CHECK:  NoAlias: i8* %m1, i16* %m2.idx

define void @test_with_lshr_different_sizes(i64 %i) {
  %m0 = tail call ptr @malloc(i64 120)
  %m1 = getelementptr inbounds i8, ptr %m0, i64 1
  load i8, ptr %m1
  %m2 = getelementptr inbounds i8, ptr %m0, i64 2
  %idx = lshr i64 %i, 2
  %m2.idx = getelementptr inbounds i16, ptr %m2, i64 %idx
  load i16, ptr %m2.idx
  ret void
}

; CHECK-LABEL: test_with_a_loop
; CHECK:  NoAlias: i8* %a, i8* %b

define void @test_with_a_loop(ptr %mem) {
  br label %for.loop

for.loop:
  %i = phi i32 [ 0, %0 ], [ %i.plus1, %for.loop ]
  %a = getelementptr inbounds i8, ptr %mem, i64 8
  load i8, ptr %a
  %a.plus1 = getelementptr inbounds i8, ptr %mem, i64 16
  %i.64 = zext i32 %i to i64
  %b = getelementptr inbounds i8, ptr %a.plus1, i64 %i.64
  load i8, ptr %b
  %i.plus1 = add nuw nsw i32 %i, 1
  %cmp = icmp eq i32 %i.plus1, 10
  br i1 %cmp, label %for.loop.exit, label %for.loop

for.loop.exit:
  ret void
}

; CHECK-LABEL: test_with_varying_base_pointer_in_loop
; CHECK:  NoAlias: i8* %a, i8* %b

define void @test_with_varying_base_pointer_in_loop(ptr %mem.orig) {
  br label %for.loop

for.loop:
  %mem = phi ptr [ %mem.orig, %0 ], [ %mem.plus1, %for.loop ]
  %i = phi i32 [ 0, %0 ], [ %i.plus1, %for.loop ]
  %a = getelementptr inbounds i8, ptr %mem, i64 8
  load i8, ptr %a
  %a.plus1 = getelementptr inbounds i8, ptr %mem, i64 16
  %i.64 = zext i32 %i to i64
  %b = getelementptr inbounds i8, ptr %a.plus1, i64 %i.64
  load i8, ptr %b
  %i.plus1 = add nuw nsw i32 %i, 1
  %mem.plus1 = getelementptr inbounds i8, ptr %mem, i64 8
  %cmp = icmp eq i32 %i.plus1, 10
  br i1 %cmp, label %for.loop.exit, label %for.loop

for.loop.exit:
  ret void
}

; CHECK-LABEL: test_sign_extension
; CHECK:  MayAlias: i8* %a, i64* %b.i8

define void @test_sign_extension(i32 %p) {
  %1 = tail call ptr @malloc(i64 120)
  %p.64 = zext i32 %p to i64
  %a = getelementptr inbounds i8, ptr %1, i64 %p.64
  load i8, ptr %a
  %p.minus1 = add i32 %p, -1
  %p.minus1.64 = zext i32 %p.minus1 to i64
  %b.i8 = getelementptr inbounds i8, ptr %1, i64 %p.minus1.64
  load i64, ptr %b.i8
  ret void
}

; CHECK-LABEL: test_fe_tools
; CHECK:  MayAlias: i32* %a, i32* %b

define void @test_fe_tools(ptr %values) {
  br label %reorder

for.loop:
  %i = phi i32 [ 0, %reorder ], [ %i.next, %for.loop ]
  %idxprom = zext i32 %i to i64
  %b = getelementptr inbounds [8 x i32], ptr %values, i64 0, i64 %idxprom
  load i32, ptr %b
  %i.next = add nuw nsw i32 %i, 1
  %cmp = icmp eq i32 %i.next, 10
  br i1 %cmp, label %for.loop.exit, label %for.loop

reorder:
  %a = getelementptr inbounds [8 x i32], ptr %values, i64 0, i64 1
  load i32, ptr %a
  br label %for.loop

for.loop.exit:
  ret void
}

@b = global i32 0, align 4
@d = global i32 0, align 4

; CHECK-LABEL: test_spec2006
; CHECK:  MayAlias: ptr* %x, ptr* %y

define void @test_spec2006() {
  %h = alloca [1 x [2 x ptr]], align 16
  %d.val = load i32, ptr @d, align 4
  %d.promoted = sext i32 %d.val to i64
  %1 = icmp slt i32 %d.val, 2
  br i1 %1, label %.lr.ph, label %bb3

.lr.ph:                                           ; preds = %0
  br label %bb2

bb2:
  %i = phi i32 [ %d.val, %.lr.ph ], [ %i.plus1, %bb2 ]
  %i.promoted = sext i32 %i to i64
  %x = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 %d.promoted, i64 %i.promoted
  load ptr, ptr %x
  %i.plus1 = add nsw i32 %i, 1
  %cmp = icmp slt i32 %i.plus1, 2
  br i1 %cmp, label %bb2, label %bb3

bb3:
  %y = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 0, i64 1
  load ptr, ptr %y
  ret void
}

; CHECK-LABEL: test_modulo_analysis_easy_case
; CHECK:  NoAlias: ptr* %x, ptr* %y

define void @test_modulo_analysis_easy_case(i64 %i) {
  %h = alloca [1 x [2 x ptr]], align 16
  %x = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 %i, i64 0
  %y = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 0, i64 1
  load ptr, ptr %x
  load ptr, ptr %y
  ret void
}

; CHECK-LABEL: test_modulo_analysis_in_loop
; CHECK:  NoAlias: ptr* %x, ptr* %y

define void @test_modulo_analysis_in_loop() {
  %h = alloca [1 x [2 x ptr]], align 16
  br label %for.loop

for.loop:
  %i = phi i32 [ 0, %0 ], [ %i.plus1, %for.loop ]
  %i.promoted = sext i32 %i to i64
  %x = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 %i.promoted, i64 0
  %y = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 0, i64 1
  load ptr, ptr %x
  load ptr, ptr %y
  %i.plus1 = add nsw i32 %i, 1
  %cmp = icmp slt i32 %i.plus1, 2
  br i1 %cmp, label %for.loop, label %for.loop.exit

for.loop.exit:
  ret void
}

; CHECK-LABEL: test_modulo_analysis_with_global
; CHECK:  MayAlias: ptr* %x, ptr* %y

define void @test_modulo_analysis_with_global() {
  %h = alloca [1 x [2 x ptr]], align 16
  %b = load i32, ptr @b, align 4
  %b.promoted = sext i32 %b to i64
  br label %for.loop

for.loop:
  %i = phi i32 [ 0, %0 ], [ %i.plus1, %for.loop ]
  %i.promoted = sext i32 %i to i64
  %x = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 %i.promoted, i64 %b.promoted
  %y = getelementptr inbounds [1 x [2 x ptr]], ptr %h, i64 0, i64 0, i64 1
  load ptr, ptr %x
  load ptr, ptr %y
  %i.plus1 = add nsw i32 %i, 1
  %cmp = icmp slt i32 %i.plus1, 2
  br i1 %cmp, label %for.loop, label %for.loop.exit

for.loop.exit:
  ret void
}

; CHECK-LABEL: test_const_eval
; CHECK: NoAlias: i8* %a, i8* %b
define void @test_const_eval(ptr %ptr, i64 %offset) {
  %a = getelementptr inbounds i8, ptr %ptr, i64 %offset
  %a.dup = getelementptr inbounds i8, ptr %ptr, i64 %offset
  %three = zext i32 3 to i64
  %b = getelementptr inbounds i8, ptr %a.dup, i64 %three
  load i8, ptr %a
  load i8, ptr %b
  ret void
}

; CHECK-LABEL: test_const_eval_scaled
; CHECK: MustAlias: i8* %a, i8* %b
define void @test_const_eval_scaled(ptr %ptr) {
  %three = zext i32 3 to i64
  %six = mul i64 %three, 2
  %a = getelementptr inbounds i8, ptr %ptr, i64 %six
  %b = getelementptr inbounds i8, ptr %ptr, i64 6
  load i8, ptr %a
  load i8, ptr %b
  ret void
}

; CHECK-LABEL: Function: foo
; CHECK: MustAlias:    float* %arrayidx, float* %arrayidx4.84
define float @foo(ptr %A, float %rend, ptr %wayar)  {
entry:
  %x0 = load i32, ptr %A, align 4
  %conv = sext i32 %x0 to i64
  %mul = shl nsw i64 %conv, 3
  %call = tail call ptr @malloc(i64 %mul)

  %sub = add nsw i32 %x0, -1
  %idxprom = sext i32 %sub to i64
  %arrayidx = getelementptr inbounds float, ptr %call, i64 %idxprom
  store float %rend, ptr %arrayidx, align 8

  %indvars.iv76.83 = add nsw i64 %conv, -1
  %arrayidx4.84 = getelementptr inbounds float, ptr %call, i64 %indvars.iv76.83
  %x4 = load float, ptr %arrayidx4.84, align 8

  ret float %x4
}

; CHECK-LABEL: Function: test_shl_nuw_zext
; CHECK: MustAlias: i8* %p.1, i8* %p.2
define void @test_shl_nuw_zext(ptr %p, i32 %x) {
  %shl = shl nuw i32 %x, 1
  %shl.ext = zext i32 %shl to i64
  %ext = zext i32 %x to i64
  %ext.shl = shl nuw i64 %ext, 1
  %p.1 = getelementptr i8, ptr %p, i64 %shl.ext
  %p.2 = getelementptr i8, ptr %p, i64 %ext.shl
  load i8, ptr %p.1
  load i8, ptr %p.2
  ret void
}

; CHECK-LABEL: Function: test_shl_nsw_sext
; CHECK: MustAlias: i8* %p.1, i8* %p.2
define void @test_shl_nsw_sext(ptr %p, i32 %x) {
  %shl = shl nsw i32 %x, 1
  %shl.ext = sext i32 %shl to i64
  %ext = sext i32 %x to i64
  %ext.shl = shl nsw i64 %ext, 1
  %p.1 = getelementptr i8, ptr %p, i64 %shl.ext
  %p.2 = getelementptr i8, ptr %p, i64 %ext.shl
  load i8, ptr %p.1
  load i8, ptr %p.2
  ret void
}

; CHECK-LABEL: Function: test_implicit_sext
; CHECK: MayAlias: i8* %p.1, i8* %p.2
define void @test_implicit_sext(ptr %p, i32 %x) {
  %add = add i32 %x, 1
  %ext = sext i32 %x to i64
  %ext.add = add i64 %ext, 1
  %p.1 = getelementptr i8, ptr %p, i32 %add
  %p.2 = getelementptr i8, ptr %p, i64 %ext.add
  load i8, ptr %p.1
  load i8, ptr %p.2
  ret void
}

; CHECK-LABEL: Function: test_partial_decomposition
; CHECK: MustAlias: i8* %p.1, i8* %p.2
define void @test_partial_decomposition(ptr %p, i32 %x) {
  %add = add i32 %x, 1
  %add.1 = add nsw i32 %add, 1
  %add.2 = add nsw i32 %add, 1
  %p.1 = getelementptr i8, ptr %p, i32 %add.1
  %p.2 = getelementptr i8, ptr %p, i32 %add.2
  load i8, ptr %p.1
  load i8, ptr %p.2
  ret void
}

; Function Attrs: nounwind
declare noalias ptr @malloc(i64)
