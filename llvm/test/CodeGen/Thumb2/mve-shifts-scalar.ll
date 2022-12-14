; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve %s --verify-machineinstrs -o - | FileCheck %s

define dso_local arm_aapcs_vfpcc void @sink_shl_i32(ptr nocapture readonly %in, ptr noalias nocapture %out, i32 %shift, i32 %N) {
; CHECK-LABEL: sink_shl_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB0_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vshl.u32 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #16
; CHECK-NEXT:    le lr, .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %shift, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i32, ptr %in, i32 %index
  %wide.load = load <4 x i32>, ptr %gep.in, align 4
  %res = shl <4 x i32> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i32, ptr %out, i32 %index
  store <4 x i32> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_shl_i16(ptr nocapture readonly %in, ptr noalias nocapture %out, i16 %shift, i32 %N) {
; CHECK-LABEL: sink_shl_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB1_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #8
; CHECK-NEXT:    vshl.u16 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #8
; CHECK-NEXT:    le lr, .LBB1_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <8 x i16> undef, i16 %shift, i32 0
  %broadcast.splat11 = shufflevector <8 x i16> %broadcast.splatinsert10, <8 x i16> undef, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i16, ptr %in, i32 %index
  %wide.load = load <8 x i16>, ptr %gep.in, align 4
  %res = shl <8 x i16> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i16, ptr %out, i32 %index
  store <8 x i16> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_shl_i8(ptr nocapture readonly %in, ptr noalias nocapture %out, i8 %shift, i32 %N) {
; CHECK-LABEL: sink_shl_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB2_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #4
; CHECK-NEXT:    vshl.u8 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #4
; CHECK-NEXT:    le lr, .LBB2_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <16 x i8> undef, i8 %shift, i32 0
  %broadcast.splat11 = shufflevector <16 x i8> %broadcast.splatinsert10, <16 x i8> undef, <16 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i8, ptr %in, i32 %index
  %wide.load = load <16 x i8>, ptr %gep.in, align 4
  %res = shl <16 x i8> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i8, ptr %out, i32 %index
  store <16 x i8> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_lshr_i32(ptr nocapture readonly %in, ptr noalias nocapture %out, i32 %shift, i32 %N) {
; CHECK-LABEL: sink_lshr_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB3_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vshl.u32 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #16
; CHECK-NEXT:    le lr, .LBB3_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %shift, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i32, ptr %in, i32 %index
  %wide.load = load <4 x i32>, ptr %gep.in, align 4
  %res = lshr <4 x i32> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i32, ptr %out, i32 %index
  store <4 x i32> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_lshr_i16(ptr nocapture readonly %in, ptr noalias nocapture %out, i16 %shift, i32 %N) {
; CHECK-LABEL: sink_lshr_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB4_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #8
; CHECK-NEXT:    vshl.u16 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #8
; CHECK-NEXT:    le lr, .LBB4_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <8 x i16> undef, i16 %shift, i32 0
  %broadcast.splat11 = shufflevector <8 x i16> %broadcast.splatinsert10, <8 x i16> undef, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i16, ptr %in, i32 %index
  %wide.load = load <8 x i16>, ptr %gep.in, align 4
  %res = lshr <8 x i16> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i16, ptr %out, i32 %index
  store <8 x i16> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_lshr_i8(ptr nocapture readonly %in, ptr noalias nocapture %out, i8 %shift, i32 %N) {
; CHECK-LABEL: sink_lshr_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB5_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #4
; CHECK-NEXT:    vshl.u8 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #4
; CHECK-NEXT:    le lr, .LBB5_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <16 x i8> undef, i8 %shift, i32 0
  %broadcast.splat11 = shufflevector <16 x i8> %broadcast.splatinsert10, <16 x i8> undef, <16 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i8, ptr %in, i32 %index
  %wide.load = load <16 x i8>, ptr %gep.in, align 4
  %res = lshr <16 x i8> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i8, ptr %out, i32 %index
  store <16 x i8> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_ashr_i32(ptr nocapture readonly %in, ptr noalias nocapture %out, i32 %shift, i32 %N) {
; CHECK-LABEL: sink_ashr_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB6_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vshl.s32 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #16
; CHECK-NEXT:    le lr, .LBB6_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <4 x i32> undef, i32 %shift, i32 0
  %broadcast.splat11 = shufflevector <4 x i32> %broadcast.splatinsert10, <4 x i32> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i32, ptr %in, i32 %index
  %wide.load = load <4 x i32>, ptr %gep.in, align 4
  %res = ashr <4 x i32> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i32, ptr %out, i32 %index
  store <4 x i32> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_ashr_i16(ptr nocapture readonly %in, ptr noalias nocapture %out, i16 %shift, i32 %N) {
; CHECK-LABEL: sink_ashr_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB7_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #8
; CHECK-NEXT:    vshl.s16 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #8
; CHECK-NEXT:    le lr, .LBB7_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <8 x i16> undef, i16 %shift, i32 0
  %broadcast.splat11 = shufflevector <8 x i16> %broadcast.splatinsert10, <8 x i16> undef, <8 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i16, ptr %in, i32 %index
  %wide.load = load <8 x i16>, ptr %gep.in, align 4
  %res = ashr <8 x i16> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i16, ptr %out, i32 %index
  store <8 x i16> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}

define dso_local arm_aapcs_vfpcc void @sink_ashr_i8(ptr nocapture readonly %in, ptr noalias nocapture %out, i8 %shift, i32 %N) {
; CHECK-LABEL: sink_ashr_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bic r3, r3, #3
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sub.w r12, r3, #4
; CHECK-NEXT:    movs r3, #1
; CHECK-NEXT:    add.w lr, r3, r12, lsr #2
; CHECK-NEXT:  .LBB8_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #4
; CHECK-NEXT:    vshl.s8 q0, r2
; CHECK-NEXT:    vstrb.8 q0, [r1], #4
; CHECK-NEXT:    le lr, .LBB8_1
; CHECK-NEXT:  @ %bb.2: @ %exit
; CHECK-NEXT:    pop {r7, pc}
entry:
  br label %vector.ph

vector.ph:
  %n.vec = and i32 %N, -4
  %broadcast.splatinsert10 = insertelement <16 x i8> undef, i8 %shift, i32 0
  %broadcast.splat11 = shufflevector <16 x i8> %broadcast.splatinsert10, <16 x i8> undef, <16 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %gep.in = getelementptr inbounds i8, ptr %in, i32 %index
  %wide.load = load <16 x i8>, ptr %gep.in, align 4
  %res = ashr <16 x i8> %wide.load, %broadcast.splat11
  %gep.out = getelementptr inbounds i8, ptr %out, i32 %index
  store <16 x i8> %res, ptr %gep.out, align 4
  %index.next = add i32 %index, 4
  %cmp = icmp eq i32 %index.next, %n.vec
  br i1 %cmp, label %exit, label %vector.body

exit:
  ret void
}
