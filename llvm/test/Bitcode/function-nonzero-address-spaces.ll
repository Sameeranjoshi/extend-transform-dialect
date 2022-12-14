; Verify that we accept calls to variables in the program AS:
; RUN: llvm-as -data-layout "P40" %s -o - | llvm-dis - | FileCheck %s
; CHECK: target datalayout = "P40"

; We should get a sensible error for a non-program address call:
; RUN: not llvm-as -data-layout "P39" %s -o /dev/null 2>&1 | FileCheck %s -check-prefix ERR-AS39
; ERR-AS39: error: '%fnptr' defined with type 'ptr addrspace(40)' but expected 'ptr addrspace(39)'

; And also if we don't set a custom program address space:
; RUN: not llvm-as %s -o /dev/null 2>&1 | FileCheck %s -check-prefix ERR-AS0
; ERR-AS0: error: '%fnptr' defined with type 'ptr addrspace(40)' but expected 'ptr'

define void @f_named(i16 %n, ptr addrspace(40) %f) addrspace(40) {
entry:
  %f.addr = alloca ptr addrspace(40), align 1
  store ptr addrspace(40) %f, ptr %f.addr
  %fnptr = load ptr addrspace(40), ptr %f.addr
  call void %fnptr(i16 8)
  ret void
}

define void @f_numbered(i16 %n, ptr addrspace(40) %f) addrspace(40){
entry:
  %f.addr = alloca ptr addrspace(40), align 1
  store ptr addrspace(40) %f, ptr %f.addr
  %0 = load ptr addrspace(40), ptr %f.addr
  call void %0(i16 8)
  ret void
}
