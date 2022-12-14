; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=armebv7 -target-abi apcs -o - %s | FileCheck %s

@vec6_p = external global <6 x i16>

define i32 @vec_to_int() {
; CHECK-LABEL: vec_to_int:
; CHECK:       @ %bb.0: @ %bb.0
; CHECK-NEXT:    push {r4}
; CHECK-NEXT:    sub sp, sp, #28
; CHECK-NEXT:    movw r0, :lower16:vec6_p
; CHECK-NEXT:    movt r0, :upper16:vec6_p
; CHECK-NEXT:    vld1.8 {d16}, [r0]!
; CHECK-NEXT:    ldr r0, [r0]
; CHECK-NEXT:    @ implicit-def: $d17
; CHECK-NEXT:    vmov.32 d17[0], r0
; CHECK-NEXT:    vrev32.16 d18, d17
; CHECK-NEXT:    vrev16.8 d16, d16
; CHECK-NEXT:    @ kill: def $d16 killed $d16 def $q8
; CHECK-NEXT:    vmov.f64 d17, d18
; CHECK-NEXT:    vstmia sp, {d16, d17} @ 16-byte Spill
; CHECK-NEXT:    b .LBB0_1
; CHECK-NEXT:  .LBB0_1: @ %bb.1
; CHECK-NEXT:    vldmia sp, {d16, d17} @ 16-byte Reload
; CHECK-NEXT:    vrev32.16 q8, q8
; CHECK-NEXT:    vmov.f64 d16, d17
; CHECK-NEXT:    vmov.32 r0, d16[0]
; CHECK-NEXT:    add sp, sp, #28
; CHECK-NEXT:    pop {r4}
; CHECK-NEXT:    bx lr
bb.0:
  %vec6 = load <6 x i16>, ptr @vec6_p, align 1
  br label %bb.1

bb.1:
  %0 = bitcast <6 x i16> %vec6 to i96
  %1 = trunc i96 %0 to i32
  ret i32 %1
}

define i16 @int_to_vec(i80 %in) {
; CHECK-LABEL: int_to_vec:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    @ kill: def $r2 killed $r1
; CHECK-NEXT:    @ kill: def $r2 killed $r0
; CHECK-NEXT:    lsl r0, r0, #16
; CHECK-NEXT:    orr r0, r0, r1, lsr #16
; CHECK-NEXT:    @ implicit-def: $d18
; CHECK-NEXT:    vmov.32 d18[0], r0
; CHECK-NEXT:    @ implicit-def: $q8
; CHECK-NEXT:    vmov.f64 d16, d18
; CHECK-NEXT:    vrev32.16 q8, q8
; CHECK-NEXT:    @ kill: def $d16 killed $d16 killed $q8
; CHECK-NEXT:    vmov.u16 r0, d16[0]
; CHECK-NEXT:    bx lr
  %vec = bitcast i80 %in to <5 x i16>
  %e0 = extractelement <5 x i16> %vec, i32 0
  ret i16 %e0
}
