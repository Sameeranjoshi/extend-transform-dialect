; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --no-generate-body-for-unused-prefixes
; RUN: llc -mtriple=riscv64 --relocation-model=pic < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 --relocation-model=static < %s | FileCheck %s

@global_ext = external global i32
@global_int = internal global i32 0
declare void @func()

define ptr @global_addr() #0 {
; CHECK-LABEL: global_addr:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .Lpcrel_hi0:
; CHECK-NEXT:    auipc a0, %got_pcrel_hi(global_ext)
; CHECK-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi0)(a0)
; CHECK-NEXT:    ret
  ret ptr @global_ext
}

define i32 @global_load() #0 {
; CHECK-LABEL: global_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .Lpcrel_hi1:
; CHECK-NEXT:    auipc a0, %got_pcrel_hi(global_ext)
; CHECK-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi1)(a0)
; CHECK-NEXT:    lw a0, 0(a0)
; CHECK-NEXT:    ret
  %load = load i32, ptr @global_ext
  ret i32 %load
}

define void @global_store() #0 {
; CHECK-LABEL: global_store:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .Lpcrel_hi2:
; CHECK-NEXT:    auipc a0, %got_pcrel_hi(global_ext)
; CHECK-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi2)(a0)
; CHECK-NEXT:    sw zero, 0(a0)
; CHECK-NEXT:    ret
  store i32 0, ptr @global_ext
  ret void
}

define ptr @global_int_addr() #0 {
; CHECK-LABEL: global_int_addr:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .Lpcrel_hi3:
; CHECK-NEXT:    auipc a0, %got_pcrel_hi(global_int)
; CHECK-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi3)(a0)
; CHECK-NEXT:    ret
  ret ptr @global_int
}

define i32 @global_int_load() #0 {
; CHECK-LABEL: global_int_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .Lpcrel_hi4:
; CHECK-NEXT:    auipc a0, %got_pcrel_hi(global_int)
; CHECK-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi4)(a0)
; CHECK-NEXT:    lw a0, 0(a0)
; CHECK-NEXT:    ret
  %load = load i32, ptr @global_int
  ret i32 %load
}

define void @global_int_store() #0 {
; CHECK-LABEL: global_int_store:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .Lpcrel_hi5:
; CHECK-NEXT:    auipc a0, %got_pcrel_hi(global_int)
; CHECK-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi5)(a0)
; CHECK-NEXT:    sw zero, 0(a0)
; CHECK-NEXT:    ret
  store i32 0, ptr @global_int
  ret void
}

define ptr @func_addr() #0 {
; CHECK-LABEL: func_addr:
; CHECK:       # %bb.0:
; CHECK-NEXT:  .Lpcrel_hi6:
; CHECK-NEXT:    auipc a0, %got_pcrel_hi(func)
; CHECK-NEXT:    ld a0, %pcrel_lo(.Lpcrel_hi6)(a0)
; CHECK-NEXT:    ret
  ret ptr @func
}

attributes #0 = { "target-features"="+tagged-globals" }
