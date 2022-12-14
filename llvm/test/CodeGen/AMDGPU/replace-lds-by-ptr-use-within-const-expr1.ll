; RUN: opt -S -mtriple=amdgcn--  -amdgpu-replace-lds-use-with-pointer -amdgpu-enable-lds-replace-with-pointer=true < %s | FileCheck %s

; DESCRIPTION:
;
; There is one lds global defined here, and this lds is used within a single non-kernel
; function, as an operand of nested constant expression, and this non-kernel function is
; reachable from kernel. Hence nested constant expression should to be converted into a
; series of instructons and pointer replacement should take place.
;

; Original LDS should exist.
; CHECK: @used_only_within_func = addrspace(3) global [4 x i32] undef, align 4
@used_only_within_func = addrspace(3) global [4 x i32] undef, align 4

; Pointers should be created.
; CHECK: @used_only_within_func.ptr = internal unnamed_addr addrspace(3) global i16 undef, align 2

; Pointer replacement code should be added.
define void @f0(i32 %x) {
; CHECK-LABEL: entry:
; CHECK:   %0 = load i16, ptr addrspace(3) @used_only_within_func.ptr, align 2
; CHECK:   %1 = getelementptr i8, ptr addrspace(3) null, i16 %0
; CHECK:   %2 = addrspacecast ptr addrspace(3) %1 to ptr
; CHECK:   %3 = ptrtoint ptr %2 to i64
; CHECK:   %4 = add i64 %3, %3
; CHECK:   %5 = inttoptr i64 %4 to ptr
; CHECK:   store i32 %x, ptr %5, align 4
; CHECK:   ret void
entry:
  store i32 %x, ptr inttoptr (i64 add (i64 ptrtoint (ptr addrspacecast (ptr addrspace(3) @used_only_within_func to ptr) to i64), i64 ptrtoint (ptr addrspacecast (ptr addrspace(3) @used_only_within_func to ptr) to i64)) to ptr), align 4
  ret void
}

; Pointer initialization code shoud be added
define amdgpu_kernel void @k0() {
; CHECK-LABEL: entry:
; CHECK:   %0 = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0)
; CHECK:   %1 = icmp eq i32 %0, 0
; CHECK:   br i1 %1, label %2, label %3
;
; CHECK-LABEL: 2:
; CHECK:   store i16 ptrtoint (ptr addrspace(3) @used_only_within_func to i16), ptr addrspace(3) @used_only_within_func.ptr, align 2
; CHECK:   br label %3
;
; CHECK-LABEL: 3:
; CHECK:   call void @llvm.amdgcn.wave.barrier()
; CHECK:   call void @f0(i32 0)
; CHECK:   ret void
entry:
  call void @f0(i32 0)
  ret void
}
