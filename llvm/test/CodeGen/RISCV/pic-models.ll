; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -relocation-model=static < %s \
; RUN:     | FileCheck -check-prefix=RV32-STATIC %s
; RUN: llc -mtriple=riscv32 -relocation-model=pic < %s \
; RUN:     | FileCheck -check-prefix=RV32-PIC %s
; RUN: llc -mtriple=riscv64 -relocation-model=static < %s \
; RUN:     | FileCheck -check-prefix=RV64-STATIC %s
; RUN: llc -mtriple=riscv64 -relocation-model=pic < %s \
; RUN:     | FileCheck -check-prefix=RV64-PIC %s

; Check basic lowering of PIC addressing.
; TODO: Check other relocation models?

@external_var = external global i32
@internal_var = internal global i32 42


; external address

define ptr @f1() nounwind {
; RV32-STATIC-LABEL: f1:
; RV32-STATIC:       # %bb.0: # %entry
; RV32-STATIC-NEXT:    lui a0, %hi(external_var)
; RV32-STATIC-NEXT:    addi a0, a0, %lo(external_var)
; RV32-STATIC-NEXT:    ret
;
; RV32-PIC-LABEL: f1:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:  .Lpcrel_hi0:
; RV32-PIC-NEXT:    auipc a0, %got_pcrel_hi(external_var)
; RV32-PIC-NEXT:    lw a0, %pcrel_lo(.Lpcrel_hi0)(a0)
; RV32-PIC-NEXT:    ret
;
; RV64-STATIC-LABEL: f1:
; RV64-STATIC:       # %bb.0: # %entry
; RV64-STATIC-NEXT:    lui a0, %hi(external_var)
; RV64-STATIC-NEXT:    addi a0, a0, %lo(external_var)
; RV64-STATIC-NEXT:    ret
;
; RV64-PIC-LABEL: f1:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:  .Lpcrel_hi0:
; RV64-PIC-NEXT:    auipc a0, %got_pcrel_hi(external_var)
; RV64-PIC-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi0)(a0)
; RV64-PIC-NEXT:    ret
entry:
  ret ptr @external_var
}


; internal address

define ptr @f2() nounwind {
; RV32-STATIC-LABEL: f2:
; RV32-STATIC:       # %bb.0: # %entry
; RV32-STATIC-NEXT:    lui a0, %hi(internal_var)
; RV32-STATIC-NEXT:    addi a0, a0, %lo(internal_var)
; RV32-STATIC-NEXT:    ret
;
; RV32-PIC-LABEL: f2:
; RV32-PIC:       # %bb.0: # %entry
; RV32-PIC-NEXT:  .Lpcrel_hi1:
; RV32-PIC-NEXT:    auipc a0, %pcrel_hi(internal_var)
; RV32-PIC-NEXT:    addi a0, a0, %pcrel_lo(.Lpcrel_hi1)
; RV32-PIC-NEXT:    ret
;
; RV64-STATIC-LABEL: f2:
; RV64-STATIC:       # %bb.0: # %entry
; RV64-STATIC-NEXT:    lui a0, %hi(internal_var)
; RV64-STATIC-NEXT:    addi a0, a0, %lo(internal_var)
; RV64-STATIC-NEXT:    ret
;
; RV64-PIC-LABEL: f2:
; RV64-PIC:       # %bb.0: # %entry
; RV64-PIC-NEXT:  .Lpcrel_hi1:
; RV64-PIC-NEXT:    auipc a0, %pcrel_hi(internal_var)
; RV64-PIC-NEXT:    addi a0, a0, %pcrel_lo(.Lpcrel_hi1)
; RV64-PIC-NEXT:    ret
entry:
  ret ptr @internal_var
}
