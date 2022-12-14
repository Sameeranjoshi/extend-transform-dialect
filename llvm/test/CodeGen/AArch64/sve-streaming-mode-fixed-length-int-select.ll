; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -force-streaming-compatible-sve < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

define <4 x i8> @select_v4i8(<4 x i8> %op1, <4 x i8> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mov z2.h, w8
; CHECK-NEXT:    bic z1.d, z1.d, z2.d
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <4 x i8> %op1, <4 x i8> %op2
  ret <4 x i8> %sel
}

define <8 x i8> @select_v8i8(<8 x i8> %op1, <8 x i8> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mov z2.b, w8
; CHECK-NEXT:    bic z1.d, z1.d, z2.d
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <8 x i8> %op1, <8 x i8> %op2
  ret <8 x i8> %sel
}

define <16 x i8> @select_v16i8(<16 x i8> %op1, <16 x i8> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mov z2.b, w8
; CHECK-NEXT:    bic z1.d, z1.d, z2.d
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <16 x i8> %op1, <16 x i8> %op2
  ret <16 x i8> %sel
}

define void @select_v32i8(ptr %a, ptr %b, i1 %mask) #0 {
; CHECK-LABEL: select_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w2, #0x1
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    ldr q1, [x0, #16]
; CHECK-NEXT:    ldr q2, [x1]
; CHECK-NEXT:    ldr q3, [x1, #16]
; CHECK-NEXT:    mov z4.b, w8
; CHECK-NEXT:    bic z2.d, z2.d, z4.d
; CHECK-NEXT:    and z0.d, z0.d, z4.d
; CHECK-NEXT:    bic z3.d, z3.d, z4.d
; CHECK-NEXT:    and z1.d, z1.d, z4.d
; CHECK-NEXT:    orr z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z1.d, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load volatile <32 x i8>, ptr %a
  %op2 = load volatile <32 x i8>, ptr %b
  %sel = select i1 %mask, <32 x i8> %op1, <32 x i8> %op2
  store <32 x i8> %sel, ptr %a
  ret void
}

define <2 x i16> @select_v2i16(<2 x i16> %op1, <2 x i16> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mvn w9, w8
; CHECK-NEXT:    mov z2.s, w8
; CHECK-NEXT:    mov z3.s, w9
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    and z1.d, z1.d, z3.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <2 x i16> %op1, <2 x i16> %op2
  ret <2 x i16> %sel
}

define <4 x i16> @select_v4i16(<4 x i16> %op1, <4 x i16> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mov z2.h, w8
; CHECK-NEXT:    bic z1.d, z1.d, z2.d
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <4 x i16> %op1, <4 x i16> %op2
  ret <4 x i16> %sel
}

define <8 x i16> @select_v8i16(<8 x i16> %op1, <8 x i16> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mov z2.h, w8
; CHECK-NEXT:    bic z1.d, z1.d, z2.d
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <8 x i16> %op1, <8 x i16> %op2
  ret <8 x i16> %sel
}

define void @select_v16i16(ptr %a, ptr %b, i1 %mask) #0 {
; CHECK-LABEL: select_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w2, #0x1
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    ldr q1, [x0, #16]
; CHECK-NEXT:    ldr q2, [x1]
; CHECK-NEXT:    ldr q3, [x1, #16]
; CHECK-NEXT:    mov z4.h, w8
; CHECK-NEXT:    bic z2.d, z2.d, z4.d
; CHECK-NEXT:    and z0.d, z0.d, z4.d
; CHECK-NEXT:    bic z3.d, z3.d, z4.d
; CHECK-NEXT:    and z1.d, z1.d, z4.d
; CHECK-NEXT:    orr z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z1.d, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load volatile <16 x i16>, ptr %a
  %op2 = load volatile <16 x i16>, ptr %b
  %sel = select i1 %mask, <16 x i16> %op1, <16 x i16> %op2
  store <16 x i16> %sel, ptr %a
  ret void
}

define <2 x i32> @select_v2i32(<2 x i32> %op1, <2 x i32> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mvn w9, w8
; CHECK-NEXT:    mov z2.s, w8
; CHECK-NEXT:    mov z3.s, w9
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    and z1.d, z1.d, z3.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <2 x i32> %op1, <2 x i32> %op2
  ret <2 x i32> %sel
}

define <4 x i32> @select_v4i32(<4 x i32> %op1, <4 x i32> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    mvn w9, w8
; CHECK-NEXT:    mov z2.s, w8
; CHECK-NEXT:    mov z3.s, w9
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    and z1.d, z1.d, z3.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <4 x i32> %op1, <4 x i32> %op2
  ret <4 x i32> %sel
}

define void @select_v8i32(ptr %a, ptr %b, i1 %mask) #0 {
; CHECK-LABEL: select_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w2, #0x1
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    csetm w8, ne
; CHECK-NEXT:    ldr q1, [x0, #16]
; CHECK-NEXT:    mvn w9, w8
; CHECK-NEXT:    ldr q2, [x1]
; CHECK-NEXT:    ldr q3, [x1, #16]
; CHECK-NEXT:    mov z4.s, w8
; CHECK-NEXT:    mov z5.s, w9
; CHECK-NEXT:    and z1.d, z1.d, z4.d
; CHECK-NEXT:    and z0.d, z0.d, z4.d
; CHECK-NEXT:    and z2.d, z2.d, z5.d
; CHECK-NEXT:    and z3.d, z3.d, z5.d
; CHECK-NEXT:    orr z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z1.d, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load volatile <8 x i32>, ptr %a
  %op2 = load volatile <8 x i32>, ptr %b
  %sel = select i1 %mask, <8 x i32> %op1, <8 x i32> %op2
  store <8 x i32> %sel, ptr %a
  ret void
}

define <1 x i64> @select_v1i64(<1 x i64> %op1, <1 x i64> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    csetm x8, ne
; CHECK-NEXT:    mvn x9, x8
; CHECK-NEXT:    mov z2.d, x8
; CHECK-NEXT:    mov z3.d, x9
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    and z1.d, z1.d, z3.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <1 x i64> %op1, <1 x i64> %op2
  ret <1 x i64> %sel
}

define <2 x i64> @select_v2i64(<2 x i64> %op1, <2 x i64> %op2, i1 %mask) #0 {
; CHECK-LABEL: select_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    csetm x8, ne
; CHECK-NEXT:    mvn x9, x8
; CHECK-NEXT:    mov z2.d, x8
; CHECK-NEXT:    mov z3.d, x9
; CHECK-NEXT:    and z0.d, z0.d, z2.d
; CHECK-NEXT:    and z1.d, z1.d, z3.d
; CHECK-NEXT:    orr z0.d, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %sel = select i1 %mask, <2 x i64> %op1, <2 x i64> %op2
  ret <2 x i64> %sel
}

define void @select_v4i64(ptr %a, ptr %b, i1 %mask) #0 {
; CHECK-LABEL: select_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w2, #0x1
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    csetm x8, ne
; CHECK-NEXT:    ldr q1, [x0, #16]
; CHECK-NEXT:    mvn x9, x8
; CHECK-NEXT:    ldr q2, [x1]
; CHECK-NEXT:    ldr q3, [x1, #16]
; CHECK-NEXT:    mov z4.d, x8
; CHECK-NEXT:    mov z5.d, x9
; CHECK-NEXT:    and z1.d, z1.d, z4.d
; CHECK-NEXT:    and z0.d, z0.d, z4.d
; CHECK-NEXT:    and z2.d, z2.d, z5.d
; CHECK-NEXT:    and z3.d, z3.d, z5.d
; CHECK-NEXT:    orr z0.d, z0.d, z2.d
; CHECK-NEXT:    orr z1.d, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load volatile <4 x i64>, ptr %a
  %op2 = load volatile <4 x i64>, ptr %b
  %sel = select i1 %mask, <4 x i64> %op1, <4 x i64> %op2
  store <4 x i64> %sel, ptr %a
  ret void
}

attributes #0 = { "target-features"="+sve" }
