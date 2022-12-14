; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=RV32 %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=RV64 %s

define signext i16 @func(ptr %a, ptr %b) {
; RV32-LABEL: func:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lh a0, 0(a0)
; RV32-NEXT:    bltz a0, .LBB0_3
; RV32-NEXT:  # %bb.1: # %.LBB0_1
; RV32-NEXT:    beqz a1, .LBB0_3
; RV32-NEXT:  # %bb.2: # %.LBB0_2
; RV32-NEXT:    ret
; RV32-NEXT:  .LBB0_3: # %return
; RV32-NEXT:    li a0, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: func:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lh a0, 0(a0)
; RV64-NEXT:    bltz a0, .LBB0_3
; RV64-NEXT:  # %bb.1: # %.LBB0_1
; RV64-NEXT:    beqz a1, .LBB0_3
; RV64-NEXT:  # %bb.2: # %.LBB0_2
; RV64-NEXT:    ret
; RV64-NEXT:  .LBB0_3: # %return
; RV64-NEXT:    li a0, 0
; RV64-NEXT:    ret
entry:
  %0 = load i16, ptr %a
  %cmp = icmp sgt i16 %0, -1
  %tobool.not = icmp eq ptr %b, null
  br i1 %cmp, label %.LBB0_1, label %return

.LBB0_1:
  br i1 %tobool.not, label %return, label %.LBB0_2

.LBB0_2:
  ret i16 %0

return:
  ret i16 0
}
