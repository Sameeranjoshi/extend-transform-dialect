; This test checks experimental Emscripten-specific `generaldynamic` TLS support. See `tls-local-exec.ll` for non-Emscripten targets (since it lowers all TLS to `localexec`).
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory,atomics | FileCheck %s --check-prefixes=CHECK,TLS
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory,atomics -fast-isel | FileCheck %s --check-prefixes=CHECK,TLS
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=-bulk-memory,atomics | FileCheck %s --check-prefixes=CHECK,NO-TLS
target triple = "wasm32-unknown-emscripten"

; CHECK-LABEL: address_of_tls:
; CHECK-NEXT: .functype  address_of_tls () -> (i32)
define i32 @address_of_tls() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls
  ; NO-TLS-NEXT: return
  ret i32 ptrtoint(ptr @tls to i32)
}

; CHECK-LABEL: address_of_tls_external:
; CHECK-NEXT: .functype  address_of_tls_external () -> (i32)
define i32 @address_of_tls_external() {
  ; TLS-DAG: global.get tls_external@GOT@TLS
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls_external
  ; NO-TLS-NEXT: return
  ret i32 ptrtoint(ptr @tls_external to i32)
}

; CHECK-LABEL: ptr_to_tls:
; CHECK-NEXT: .functype ptr_to_tls () -> (i32)
define ptr @ptr_to_tls() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls
  ; NO-TLS-NEXT: return
  ret ptr @tls
}

; CHECK-LABEL: ptr_to_tls_external:
; CHECK-NEXT: .functype ptr_to_tls_external () -> (i32)
define ptr @ptr_to_tls_external() {
  ; TLS-DAG: global.get tls_external@GOT@TLS
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls_external
  ; NO-TLS-NEXT: return
  ret ptr @tls_external
}

; CHECK-LABEL: tls_load:
; CHECK-NEXT: .functype tls_load () -> (i32)
define i32 @tls_load() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: i32.load 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.load tls
  ; NO-TLS-NEXT: return
  %tmp = load i32, ptr @tls, align 4
  ret i32 %tmp
}

; CHECK-LABEL: tls_load_external:
; CHECK-NEXT: .functype tls_load_external () -> (i32)
define i32 @tls_load_external() {
  ; TLS-DAG: global.get tls_external@GOT@TLS
  ; TLS-NEXT: i32.load 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.load tls_external
  ; NO-TLS-NEXT: return
  %tmp = load i32, ptr @tls_external, align 4
  ret i32 %tmp
}

; CHECK-LABEL: tls_store:
; CHECK-NEXT: .functype tls_store (i32) -> ()
define void @tls_store(i32 %x) {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: i32.store 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.store tls
  ; NO-TLS-NEXT: return
  store i32 %x, ptr @tls, align 4
  ret void
}

; CHECK-LABEL: tls_store_external:
; CHECK-NEXT: .functype tls_store_external (i32) -> ()
define void @tls_store_external(i32 %x) {
  ; TLS-DAG: global.get tls_external@GOT@TLS
  ; TLS-NEXT: i32.store 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.store tls_external
  ; NO-TLS-NEXT: return
  store i32 %x, ptr @tls_external, align 4
  ret void
}

; CHECK-LABEL: tls_size:
; CHECK-NEXT: .functype tls_size () -> (i32)
define i32 @tls_size() {
; CHECK-NEXT: global.get __tls_size
; CHECK-NEXT: return
  %1 = call i32 @llvm.wasm.tls.size.i32()
  ret i32 %1
}

; CHECK-LABEL: tls_align:
; CHECK-NEXT: .functype tls_align () -> (i32)
define i32 @tls_align() {
; CHECK-NEXT: global.get __tls_align
; CHECK-NEXT: return
  %1 = call i32 @llvm.wasm.tls.align.i32()
  ret i32 %1
}

; CHECK-LABEL: tls_base:
; CHECK-NEXT: .functype tls_base () -> (i32)
define ptr @tls_base() {
; CHECK-NEXT: global.get __tls_base
; CHECK-NEXT: return
  %1 = call ptr @llvm.wasm.tls.base()
  ret ptr %1
}

; CHECK-LABEL: tls_base_write:
; CHECK-NEXT: .functype tls_base_write (i32) -> ()
define void @tls_base_write(ptr %output) {
; CHECK-NEXT: global.get __tls_base
; CHECK-NEXT: i32.store 0
; CHECK-NEXT: return
  %1 = call ptr @llvm.wasm.tls.base()
  store ptr %1, ptr %output
  ret void
}

; CHECK: .type tls,@object
; TLS-NEXT: .section .tbss.tls,"T",@
; NO-TLS-NEXT: .section .bss.tls,"",@
; CHECK-NEXT: .p2align 2
; CHECK-NEXT: tls:
; CHECK-NEXT: .int32 0
@tls = internal thread_local global i32 0

@tls_external = external thread_local global i32, align 4

declare i32 @llvm.wasm.tls.size.i32()
declare i32 @llvm.wasm.tls.align.i32()
declare ptr @llvm.wasm.tls.base()
