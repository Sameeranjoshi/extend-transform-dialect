; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -enable-arm-maskedgatscat=false -verify-machineinstrs %s -o - | FileCheck %s

define void @_Z4loopPxS_iS_i(ptr %d) {
; CHECK-LABEL: _Z4loopPxS_iS_i:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    vmov r1, s2
; CHECK-NEXT:    vmov r2, s0
; CHECK-NEXT:    rsbs r1, r1, #0
; CHECK-NEXT:    rsbs r2, r2, #0
; CHECK-NEXT:    sxth r1, r1
; CHECK-NEXT:    sxth r2, r2
; CHECK-NEXT:    asr.w r12, r1, #31
; CHECK-NEXT:    asrs r3, r2, #31
; CHECK-NEXT:    strd r2, r3, [r0]
; CHECK-NEXT:    strd r1, r12, [r0, #8]
; CHECK-NEXT:    bx lr
entry:
  %wide.load = load <2 x i64>, ptr undef, align 8
  %0 = trunc <2 x i64> %wide.load to <2 x i32>
  %1 = shl <2 x i32> %0, <i32 16, i32 16>
  %2 = ashr exact <2 x i32> %1, <i32 16, i32 16>
  %3 = sub <2 x i32> %2, %0
  %4 = and <2 x i32> %3, <i32 7, i32 7>
  %5 = shl <2 x i32> %2, %4
  %6 = extractelement <2 x i32> %5, i32 0
  %7 = zext i32 %6 to i64
  %8 = select i1 false, i64 %7, i64 undef
  %9 = trunc i64 %8 to i16
  %10 = sub i16 0, %9
  %11 = sext i16 %10 to i64
  %12 = getelementptr inbounds i64, ptr %d, i64 undef
  store i64 %11, ptr %12, align 8
  %13 = extractelement <2 x i32> %5, i32 1
  %14 = zext i32 %13 to i64
  %15 = select i1 false, i64 %14, i64 undef
  %16 = trunc i64 %15 to i16
  %17 = sub i16 0, %16
  %18 = sext i16 %17 to i64
  %19 = or i32 0, 1
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds i64, ptr %d, i64 %20
  store i64 %18, ptr %21, align 8
  ret void
}
