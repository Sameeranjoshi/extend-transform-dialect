; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm-eabi -mattr=+neon,+fp16 %s -o - | FileCheck %s

define <2 x i32> @vcvt_f32tos32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_f32tos32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.s32.f32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x float>, ptr %A
	%tmp2 = fptosi <2 x float> %tmp1 to <2 x i32>
	ret <2 x i32> %tmp2
}

define <2 x i32> @vcvt_f32tou32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_f32tou32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.u32.f32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x float>, ptr %A
	%tmp2 = fptoui <2 x float> %tmp1 to <2 x i32>
	ret <2 x i32> %tmp2
}

define <2 x float> @vcvt_s32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_s32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.f32.s32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, ptr %A
	%tmp2 = sitofp <2 x i32> %tmp1 to <2 x float>
	ret <2 x float> %tmp2
}

define <2 x float> @vcvt_u32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_u32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.f32.u32 d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, ptr %A
	%tmp2 = uitofp <2 x i32> %tmp1 to <2 x float>
	ret <2 x float> %tmp2
}

define <4 x i32> @vcvtQ_f32tos32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_f32tos32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.s32.f32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x float>, ptr %A
	%tmp2 = fptosi <4 x float> %tmp1 to <4 x i32>
	ret <4 x i32> %tmp2
}

define <4 x i32> @vcvtQ_f32tou32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_f32tou32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.u32.f32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x float>, ptr %A
	%tmp2 = fptoui <4 x float> %tmp1 to <4 x i32>
	ret <4 x i32> %tmp2
}

define <4 x float> @vcvtQ_s32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_s32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.f32.s32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i32>, ptr %A
	%tmp2 = sitofp <4 x i32> %tmp1 to <4 x float>
	ret <4 x float> %tmp2
}

define <4 x float> @vcvtQ_u32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_u32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.f32.u32 q8, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i32>, ptr %A
	%tmp2 = uitofp <4 x i32> %tmp1 to <4 x float>
	ret <4 x float> %tmp2
}

define <2 x i32> @vcvt_n_f32tos32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_n_f32tos32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.s32.f32 d16, d16, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x float>, ptr %A
	%tmp2 = call <2 x i32> @llvm.arm.neon.vcvtfp2fxs.v2i32.v2f32(<2 x float> %tmp1, i32 1)
	ret <2 x i32> %tmp2
}

define <2 x i32> @vcvt_n_f32tou32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_n_f32tou32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.u32.f32 d16, d16, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x float>, ptr %A
	%tmp2 = call <2 x i32> @llvm.arm.neon.vcvtfp2fxu.v2i32.v2f32(<2 x float> %tmp1, i32 1)
	ret <2 x i32> %tmp2
}

define <2 x float> @vcvt_n_s32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_n_s32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.f32.s32 d16, d16, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, ptr %A
	%tmp2 = call <2 x float> @llvm.arm.neon.vcvtfxs2fp.v2f32.v2i32(<2 x i32> %tmp1, i32 1)
	ret <2 x float> %tmp2
}

define <2 x float> @vcvt_n_u32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_n_u32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.f32.u32 d16, d16, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <2 x i32>, ptr %A
	%tmp2 = call <2 x float> @llvm.arm.neon.vcvtfxu2fp.v2f32.v2i32(<2 x i32> %tmp1, i32 1)
	ret <2 x float> %tmp2
}

declare <2 x i32> @llvm.arm.neon.vcvtfp2fxs.v2i32.v2f32(<2 x float>, i32) nounwind readnone
declare <2 x i32> @llvm.arm.neon.vcvtfp2fxu.v2i32.v2f32(<2 x float>, i32) nounwind readnone
declare <2 x float> @llvm.arm.neon.vcvtfxs2fp.v2f32.v2i32(<2 x i32>, i32) nounwind readnone
declare <2 x float> @llvm.arm.neon.vcvtfxu2fp.v2f32.v2i32(<2 x i32>, i32) nounwind readnone

define <4 x i32> @vcvtQ_n_f32tos32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_n_f32tos32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.s32.f32 q8, q8, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x float>, ptr %A
	%tmp2 = call <4 x i32> @llvm.arm.neon.vcvtfp2fxs.v4i32.v4f32(<4 x float> %tmp1, i32 1)
	ret <4 x i32> %tmp2
}

define <4 x i32> @vcvtQ_n_f32tou32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_n_f32tou32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.u32.f32 q8, q8, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x float>, ptr %A
	%tmp2 = call <4 x i32> @llvm.arm.neon.vcvtfp2fxu.v4i32.v4f32(<4 x float> %tmp1, i32 1)
	ret <4 x i32> %tmp2
}

define <4 x float> @vcvtQ_n_s32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_n_s32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.f32.s32 q8, q8, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i32>, ptr %A
	%tmp2 = call <4 x float> @llvm.arm.neon.vcvtfxs2fp.v4f32.v4i32(<4 x i32> %tmp1, i32 1)
	ret <4 x float> %tmp2
}

define <4 x float> @vcvtQ_n_u32tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvtQ_n_u32tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.f32.u32 q8, q8, #1
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i32>, ptr %A
	%tmp2 = call <4 x float> @llvm.arm.neon.vcvtfxu2fp.v4f32.v4i32(<4 x i32> %tmp1, i32 1)
	ret <4 x float> %tmp2
}

declare <4 x i32> @llvm.arm.neon.vcvtfp2fxs.v4i32.v4f32(<4 x float>, i32) nounwind readnone
declare <4 x i32> @llvm.arm.neon.vcvtfp2fxu.v4i32.v4f32(<4 x float>, i32) nounwind readnone
declare <4 x float> @llvm.arm.neon.vcvtfxs2fp.v4f32.v4i32(<4 x i32>, i32) nounwind readnone
declare <4 x float> @llvm.arm.neon.vcvtfxu2fp.v4f32.v4i32(<4 x i32>, i32) nounwind readnone

define <4 x float> @vcvt_f16tof32(ptr %A) nounwind {
; CHECK-LABEL: vcvt_f16tof32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vcvt.f32.f16 q8, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x i16>, ptr %A
	%tmp2 = call <4 x float> @llvm.arm.neon.vcvthf2fp(<4 x i16> %tmp1)
	ret <4 x float> %tmp2
}

define <4 x i16> @vcvt_f32tof16(ptr %A) nounwind {
; CHECK-LABEL: vcvt_f32tof16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vcvt.f16.f32 d16, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr
	%tmp1 = load <4 x float>, ptr %A
	%tmp2 = call <4 x i16> @llvm.arm.neon.vcvtfp2hf(<4 x float> %tmp1)
	ret <4 x i16> %tmp2
}

declare <4 x float> @llvm.arm.neon.vcvthf2fp(<4 x i16>) nounwind readnone
declare <4 x i16> @llvm.arm.neon.vcvtfp2hf(<4 x float>) nounwind readnone


define <4 x i16> @fix_float_to_i16(<4 x float> %in) {
; CHECK-LABEL: fix_float_to_i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d17, r2, r3
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vcvt.u32.f32 q8, q8, #1
; CHECK-NEXT:    vmovn.i32 d16, q8
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr

  %scale = fmul <4 x float> %in, <float 2.0, float 2.0, float 2.0, float 2.0>
  %conv = fptoui <4 x float> %scale to <4 x i16>
  ret <4 x i16> %conv
}

define <2 x i64> @fix_float_to_i64(<2 x float> %in) {
; CHECK-LABEL: fix_float_to_i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r11, lr}
; CHECK-NEXT:    push {r4, r5, r11, lr}
; CHECK-NEXT:    .vsave {d8}
; CHECK-NEXT:    vpush {d8}
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vadd.f32 d8, d16, d16
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    bl __aeabi_f2ulz
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    mov r5, r1
; CHECK-NEXT:    bl __aeabi_f2ulz
; CHECK-NEXT:    mov r2, r0
; CHECK-NEXT:    mov r3, r1
; CHECK-NEXT:    mov r0, r4
; CHECK-NEXT:    mov r1, r5
; CHECK-NEXT:    vpop {d8}
; CHECK-NEXT:    pop {r4, r5, r11, lr}
; CHECK-NEXT:    mov pc, lr

  %scale = fmul <2 x float> %in, <float 2.0, float 2.0>
  %conv = fptoui <2 x float> %scale to <2 x i64>
  ret <2 x i64> %conv
}

define <4 x i16> @fix_double_to_i16(<4 x double> %in) {
; CHECK-LABEL: fix_double_to_i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d18, r0, r1
; CHECK-NEXT:    mov r12, sp
; CHECK-NEXT:    vld1.64 {d16, d17}, [r12]
; CHECK-NEXT:    vmov d19, r2, r3
; CHECK-NEXT:    vadd.f64 d18, d18, d18
; CHECK-NEXT:    vcvt.s32.f64 s0, d18
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vadd.f64 d20, d16, d16
; CHECK-NEXT:    vadd.f64 d16, d17, d17
; CHECK-NEXT:    vcvt.s32.f64 s2, d20
; CHECK-NEXT:    vcvt.s32.f64 s6, d16
; CHECK-NEXT:    vmov.32 d16[0], r0
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vadd.f64 d19, d19, d19
; CHECK-NEXT:    vcvt.s32.f64 s4, d19
; CHECK-NEXT:    vmov.32 d17[0], r0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.32 d16[1], r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.32 d17[1], r0
; CHECK-NEXT:    vuzp.16 d16, d17
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    mov pc, lr

  %scale = fmul <4 x double> %in, <double 2.0, double 2.0, double 2.0, double 2.0>
  %conv = fptoui <4 x double> %scale to <4 x i16>
  ret <4 x i16> %conv
}

define <2 x i64> @fix_double_to_i64(<2 x double> %in) {
; CHECK-LABEL: fix_double_to_i64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r4, r5, r11, lr}
; CHECK-NEXT:    push {r4, r5, r11, lr}
; CHECK-NEXT:    .vsave {d8}
; CHECK-NEXT:    vpush {d8}
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vadd.f64 d16, d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov d16, r2, r3
; CHECK-NEXT:    vadd.f64 d8, d16, d16
; CHECK-NEXT:    bl __aeabi_d2ulz
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    mov r5, r1
; CHECK-NEXT:    vmov r0, r1, d8
; CHECK-NEXT:    bl __aeabi_d2ulz
; CHECK-NEXT:    mov r2, r0
; CHECK-NEXT:    mov r3, r1
; CHECK-NEXT:    mov r0, r4
; CHECK-NEXT:    mov r1, r5
; CHECK-NEXT:    vpop {d8}
; CHECK-NEXT:    pop {r4, r5, r11, lr}
; CHECK-NEXT:    mov pc, lr
  %scale = fmul <2 x double> %in, <double 2.0, double 2.0>
  %conv = fptoui <2 x double> %scale to <2 x i64>
  ret <2 x i64> %conv
}

define i32 @multi_sint(double %c, ptr nocapture %p, ptr nocapture %q) {
; CHECK-LABEL: multi_sint:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vcvt.s32.f64 s0, d16
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vstr s0, [r2]
; CHECK-NEXT:    vstr s0, [r3]
; CHECK-NEXT:    mov pc, lr
  %conv = fptosi double %c to i32
  store i32 %conv, ptr %p, align 4
  store i32 %conv, ptr %q, align 4
  ret i32 %conv
}

define i32 @multi_uint(double %c, ptr nocapture %p, ptr nocapture %q) {
; CHECK-LABEL: multi_uint:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vcvt.u32.f64 s0, d16
; CHECK-NEXT:    vmov r0, s0
; CHECK-NEXT:    vstr s0, [r2]
; CHECK-NEXT:    vstr s0, [r3]
; CHECK-NEXT:    mov pc, lr
  %conv = fptoui double %c to i32
  store i32 %conv, ptr %p, align 4
  store i32 %conv, ptr %q, align 4
  ret i32 %conv
}

define void @double_to_sint_store(double %c, ptr nocapture %p) {
; CHECK-LABEL: double_to_sint_store:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vcvt.s32.f64 s0, d16
; CHECK-NEXT:    vstr s0, [r2]
; CHECK-NEXT:    mov pc, lr
  %conv = fptosi double %c to i32
  store i32 %conv, ptr %p, align 4
  ret void
}

define void @double_to_uint_store(double %c, ptr nocapture %p) {
; CHECK-LABEL: double_to_uint_store:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r0, r1
; CHECK-NEXT:    vcvt.u32.f64 s0, d16
; CHECK-NEXT:    vstr s0, [r2]
; CHECK-NEXT:    mov pc, lr
  %conv = fptoui double %c to i32
  store i32 %conv, ptr %p, align 4
  ret void
}

define void @float_to_sint_store(float %c, ptr nocapture %p) {
; CHECK-LABEL: float_to_sint_store:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    vcvt.s32.f32 s0, s0
; CHECK-NEXT:    vstr s0, [r1]
; CHECK-NEXT:    mov pc, lr
  %conv = fptosi float %c to i32
  store i32 %conv, ptr %p, align 4
  ret void
}

define void @float_to_uint_store(float %c, ptr nocapture %p) {
; CHECK-LABEL: float_to_uint_store:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov s0, r0
; CHECK-NEXT:    vcvt.u32.f32 s0, s0
; CHECK-NEXT:    vstr s0, [r1]
; CHECK-NEXT:    mov pc, lr
  %conv = fptoui float %c to i32
  store i32 %conv, ptr %p, align 4
  ret void
}
