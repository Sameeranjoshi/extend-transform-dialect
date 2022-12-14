; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-- -mcpu=fiji -data-layout=A5 -passes=amdgpu-promote-alloca < %s | FileCheck -check-prefix=OPT %s

define i64 @test_pointer_array(i64 %v) {
; OPT-LABEL: @test_pointer_array(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[A:%.*]] = alloca [3 x ptr], align 16, addrspace(5)
; OPT-NEXT:    [[TMP1:%.*]] = load <3 x ptr>, ptr addrspace(5) [[A]], align 32
; OPT-NEXT:    [[TMP2:%.*]] = inttoptr i64 [[V:%.*]] to ptr
; OPT-NEXT:    [[TMP3:%.*]] = insertelement <3 x ptr> [[TMP1]], ptr [[TMP2]], i32 0
; OPT-NEXT:    store <3 x ptr> [[TMP3]], ptr addrspace(5) [[A]], align 32
; OPT-NEXT:    [[TMP5:%.*]] = load <3 x ptr>, ptr addrspace(5) [[A]], align 32
; OPT-NEXT:    [[TMP6:%.*]] = extractelement <3 x ptr> [[TMP5]], i32 0
; OPT-NEXT:    [[TMP7:%.*]] = ptrtoint ptr [[TMP6]] to i64
; OPT-NEXT:    ret i64 [[TMP7]]
;
entry:
  %a = alloca [3 x ptr], align 16, addrspace(5)
  store i64 %v, ptr addrspace(5) %a, align 16
  %ld = load i64, ptr addrspace(5) %a, align 16
  ret i64 %ld
}
