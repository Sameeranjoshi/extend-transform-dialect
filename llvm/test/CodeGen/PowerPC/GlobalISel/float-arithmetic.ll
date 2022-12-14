; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -global-isel -o - \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names < %s | FileCheck %s

define float @float_add(float %a, float %b) {
; CHECK-LABEL: float_add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsaddsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %add = fadd float %a, %b
  ret float %add
}

define double @double_add(double %a, double %b) {
; CHECK-LABEL: double_add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsadddp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %add = fadd double %a, %b
  ret double %add
}

define float @float_sub(float %a, float %b) {
; CHECK-LABEL: float_sub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xssubsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %sub = fsub float %a, %b
  ret float %sub
}

define float @float_mul(float %a, float %b) {
; CHECK-LABEL: float_mul:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsmulsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %mul = fmul float %a, %b
  ret float %mul
}

define float @float_div(float %a, float %b) {
; CHECK-LABEL: float_div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsdivsp f1, f1, f2
; CHECK-NEXT:    blr
entry:
  %div = fdiv float %a, %b
  ret float %div
}
