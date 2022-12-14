; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -passes=instcombine | FileCheck %s

target triple = "x86_64"

define double @pow_exp(double %x, double %y) {
; CHECK-LABEL: @pow_exp(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP:%.*]] = call fast double @llvm.exp.f64(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP]]
;
  %A = alloca i1
  %call = call fast double @exp(double %x) #1
  %pow = call fast double @llvm.pow.f64(double %call, double %y)
  %C1 = fcmp ule double %call, %pow
  store i1 %C1, ptr %A
  ret double %pow
}

declare double @exp(double)

declare double @llvm.pow.f64(double, double) #0

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { nounwind readnone }
