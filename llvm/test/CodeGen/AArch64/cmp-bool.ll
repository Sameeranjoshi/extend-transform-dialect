; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 < %s | FileCheck %s

define void @bool_eq(i1 zeroext %a, i1 zeroext %b, ptr nocapture %c) nounwind {
; CHECK-LABEL: bool_eq:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    b.eq .LBB0_2
; CHECK-NEXT:  // %bb.1: // %if.end
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_2: // %if.then
; CHECK-NEXT:    br x2
entry:
  %0 = xor i1 %a, %b
  br i1 %0, label %if.end, label %if.then

if.then:
  tail call void %c() #1
  br label %if.end

if.end:
  ret void
}

define void @bool_ne(i1 zeroext %a, i1 zeroext %b, ptr nocapture %c) nounwind {
; CHECK-LABEL: bool_ne:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    b.eq .LBB1_2
; CHECK-NEXT:  // %bb.1: // %if.then
; CHECK-NEXT:    br x2
; CHECK-NEXT:  .LBB1_2: // %if.end
; CHECK-NEXT:    ret
entry:
  %cmp = xor i1 %a, %b
  br i1 %cmp, label %if.then, label %if.end

if.then:
  tail call void %c() #1
  br label %if.end

if.end:
  ret void
}
