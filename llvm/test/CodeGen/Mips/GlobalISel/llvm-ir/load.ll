; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel  -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32

define i32 @load_i32(ptr %ptr) {
; MIPS32-LABEL: load_i32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lw $2, 0($4)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load i32, ptr %ptr
  ret i32 %0
}

define i64 @load_i64(ptr %ptr) {
; MIPS32-LABEL: load_i64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lw $2, 0($4)
; MIPS32-NEXT:    lw $3, 4($4)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load i64, ptr %ptr
  ret i64 %0
}

define void @load_ambiguous_i64_in_fpr(ptr %i64_ptr_a, ptr %i64_ptr_b) {
; MIPS32-LABEL: load_ambiguous_i64_in_fpr:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ldc1 $f0, 0($4)
; MIPS32-NEXT:    sdc1 $f0, 0($5)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load i64, ptr %i64_ptr_a
  store i64 %0, ptr %i64_ptr_b
  ret void
}

define float @load_float(ptr %ptr) {
; MIPS32-LABEL: load_float:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lwc1 $f0, 0($4)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load float, ptr %ptr
  ret float %0
}

define void @load_ambiguous_float_in_gpr(ptr %float_ptr_a, ptr %float_ptr_b) {
; MIPS32-LABEL: load_ambiguous_float_in_gpr:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lw $1, 0($4)
; MIPS32-NEXT:    sw $1, 0($5)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load float, ptr %float_ptr_a
  store float %0, ptr %float_ptr_b
  ret void
}

define double @load_double(ptr %ptr) {
; MIPS32-LABEL: load_double:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ldc1 $f0, 0($4)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load double, ptr %ptr
  ret double %0
}
