; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=tahiti < %s | FileCheck -check-prefixes=GCN,GFX6 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx803 < %s | FileCheck -check-prefixes=GCN,GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; FIXME: Test should be redundant with constant-address-space-32bit.ll

; It's important to check with gfx8 and gfx9 to check access through global and flat.

; Custom lowering needs to swap out the MMO address space
define amdgpu_ps float @load_constant32bit_vgpr_offset(i32 %arg) {
; GFX6-LABEL: load_constant32bit_vgpr_offset:
; GFX6:       ; %bb.0: ; %entry
; GFX6-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX6-NEXT:    s_mov_b32 s2, 0
; GFX6-NEXT:    v_mov_b32_e32 v1, 0
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_mov_b64 s[0:1], 0
; GFX6-NEXT:    buffer_load_dword v0, v[0:1], s[0:3], 0 addr64
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: load_constant32bit_vgpr_offset:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX8-NEXT:    v_mov_b32_e32 v1, 0
; GFX8-NEXT:    flat_load_dword v0, v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: load_constant32bit_vgpr_offset:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    global_load_dword v0, v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
entry:
  %gep = getelementptr <{ [4294967295 x float] }>, ptr addrspace(6) null, i32 0, i32 0, i32 %arg
  %load = load float, ptr addrspace(6) %gep, align 4
  ret float %load
}

define amdgpu_ps i32 @load_constant32bit_sgpr_offset(i32 inreg %arg) {
; GCN-LABEL: load_constant32bit_sgpr_offset:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_lshl_b32 s0, s0, 2
; GCN-NEXT:    s_mov_b32 s1, 0
; GCN-NEXT:    s_load_dword s0, s[0:1], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
entry:
  %gep = getelementptr <{ [4294967295 x i32] }>, ptr addrspace(6) null, i32 0, i32 0, i32 %arg
  %load = load i32, ptr addrspace(6) %gep, align 4
  ret i32 %load
}

; This gets split during regbankselect
define amdgpu_ps <8 x float> @load_constant32bit_vgpr_v8f32(ptr addrspace(6) %arg) {
; GFX6-LABEL: load_constant32bit_vgpr_v8f32:
; GFX6:       ; %bb.0: ; %entry
; GFX6-NEXT:    v_mov_b32_e32 v4, v0
; GFX6-NEXT:    s_mov_b32 s2, 0
; GFX6-NEXT:    v_mov_b32_e32 v5, 0
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_mov_b64 s[0:1], 0
; GFX6-NEXT:    buffer_load_dwordx4 v[0:3], v[4:5], s[0:3], 0 addr64
; GFX6-NEXT:    buffer_load_dwordx4 v[4:7], v[4:5], s[0:3], 0 addr64 offset:16
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: load_constant32bit_vgpr_v8f32:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    v_mov_b32_e32 v4, v0
; GFX8-NEXT:    v_mov_b32_e32 v5, 0
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[4:5]
; GFX8-NEXT:    v_add_u32_e32 v4, vcc, 16, v4
; GFX8-NEXT:    v_addc_u32_e64 v5, s[0:1], 0, 0, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[4:7], v[4:5]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: load_constant32bit_vgpr_v8f32:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    v_mov_b32_e32 v8, v0
; GFX9-NEXT:    v_mov_b32_e32 v9, 0
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[8:9], off
; GFX9-NEXT:    global_load_dwordx4 v[4:7], v[8:9], off offset:16
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
entry:
  %load = load <8 x float>, ptr addrspace(6) %arg, align 32
  ret <8 x float> %load
}
