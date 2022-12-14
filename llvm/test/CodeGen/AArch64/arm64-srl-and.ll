; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -O3 < %s | FileCheck %s

; This used to miscompile:
; The 16-bit -1 should not become 32-bit -1 (sub w8, w8, #1).

@g = global i16 0, align 4
define i32 @srl_and()  {
; CHECK-LABEL: srl_and:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    adrp x8, :got:g
; CHECK-NEXT:    mov w9, #50
; CHECK-NEXT:    ldr x8, [x8, :got_lo12:g]
; CHECK-NEXT:    ldrh w8, [x8]
; CHECK-NEXT:    eor w8, w8, w9
; CHECK-NEXT:    mov w9, #65535
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    and w0, w8, w8, lsr #16
; CHECK-NEXT:    ret
entry:
  %0 = load i16, ptr @g, align 4
  %1 = xor i16 %0, 50
  %tobool = icmp ne i16 %1, 0
  %lor.ext = zext i1 %tobool to i32
  %sub = add i16 %1, -1

  %srl = zext i16 %sub to i32
  %and = and i32 %srl, %lor.ext

  ret i32 %and
}
