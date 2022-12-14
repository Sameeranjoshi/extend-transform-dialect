; RUN: llc < %s -asm-verbose=false -wasm-disable-explicit-locals -wasm-keep-registers -fast-isel -fast-isel-abort=1 | FileCheck %s

; TODO: Merge this with offset.ll when fast-isel matches better.

target triple = "wasm32-unknown-unknown"

; CHECK-LABEL: store_i8_with_variable_gep_offset:
; CHECK: i32.add    $push[[L0:[0-9]+]]=, $0, $1{{$}}
; CHECK: i32.const  $push[[L1:[0-9]+]]=, 0{{$}}
; CHECK: i32.store8 0($pop[[L0]]), $pop[[L1]]{{$}}
define void @store_i8_with_variable_gep_offset(ptr %p, i32 %idx) {
  %s = getelementptr inbounds i8, ptr %p, i32 %idx
  store i8 0, ptr %s
  ret void
}

; CHECK-LABEL: store_i8_with_array_alloca_gep:
; CHECK: global.get  $push[[L0:[0-9]+]]=, __stack_pointer
; CHECK: i32.const   $push[[L1:[0-9]+]]=, 32{{$}}
; CHECK: i32.sub     $push[[L2:[0-9]+]]=, $pop[[L0]], $pop[[L1]]{{$}}
; CHECK: local.copy  $push[[L3:[0-9]+]]=, $pop[[L2]]
; CHECK: i32.add     $push[[L4:[0-9]+]]=, $pop[[L3]], $0{{$}}
; CHECK: i32.const   $push[[L5:[0-9]+]]=, 0{{$}}
; CHECK: i32.store8  0($pop[[L4]]), $pop[[L5]]{{$}}
define hidden void @store_i8_with_array_alloca_gep(i32 %idx) {
  %A = alloca [30 x i8], align 16
  %s = getelementptr inbounds [30 x i8], ptr %A, i32 0, i32 %idx
  store i8 0, ptr %s, align 1
  ret void
}

; CHECK-LABEL: store_i32_with_unfolded_gep_offset:
; CHECK: i32.const $push[[L0:[0-9]+]]=, 24{{$}}
; CHECK: i32.add   $push[[L1:[0-9]+]]=, $0, $pop[[L0]]{{$}}
; CHECK: i32.const $push[[L2:[0-9]+]]=, 0{{$}}
; CHECK: i32.store 0($pop[[L1]]), $pop[[L2]]{{$}}
define void @store_i32_with_unfolded_gep_offset(ptr %p) {
  %s = getelementptr i32, ptr %p, i32 6
  store i32 0, ptr %s
  ret void
}

; CHECK-LABEL: store_i32_with_folded_gep_offset:
; CHECK: i32.store 24($0), $pop{{[0-9]+$}}
define void @store_i32_with_folded_gep_offset(ptr %p) {
  %s = getelementptr inbounds i32, ptr %p, i32 6
  store i32 0, ptr %s
  ret void
}

; CHECK-LABEL: load_i32_with_folded_gep_offset:
; CHECK: i32.load  $push{{[0-9]+}}=, 24($0){{$}}
define i32 @load_i32_with_folded_gep_offset(ptr %p) {
  %s = getelementptr inbounds i32, ptr %p, i32 6
  %t = load i32, ptr %s
  ret i32 %t
}

; CHECK-LABEL: store_i64_with_unfolded_gep_offset:
; CHECK: i32.const $push[[L0:[0-9]+]]=, 24{{$}}
; CHECK: i32.add   $push[[L1:[0-9]+]]=, $0, $pop[[L0]]{{$}}
; CHECK: i64.const $push[[L2:[0-9]+]]=, 0{{$}}
; CHECK: i64.store 0($pop[[L1]]), $pop[[L2]]{{$}}
define void @store_i64_with_unfolded_gep_offset(ptr %p) {
  %s = getelementptr i64, ptr %p, i32 3
  store i64 0, ptr %s
  ret void
}

; CHECK-LABEL: store_i8_with_folded_gep_offset:
; CHECK: i32.store8 24($0), $pop{{[0-9]+$}}
define void @store_i8_with_folded_gep_offset(ptr %p) {
  %s = getelementptr inbounds i8, ptr %p, i32 24
  store i8 0, ptr %s
  ret void
}

; CHECK-LABEL: load_i8_u_with_folded_offset:
; CHECK: i32.load8_u $push{{[0-9]+}}=, 24($0){{$}}
define i32 @load_i8_u_with_folded_offset(ptr %p) {
  %q = ptrtoint ptr %p to i32
  %r = add nuw i32 %q, 24
  %s = inttoptr i32 %r to ptr
  %t = load i8, ptr %s
  %u = zext i8 %t to i32
  ret i32 %u
}

; TODO: this should be load8_s, need to fold sign-/zero-extend in fast-isel
; CHECK-LABEL: load_i8_s_with_folded_offset:
; CHECK: i32.load8_u $push{{[0-9]+}}=, 24($0){{$}}
define i32 @load_i8_s_with_folded_offset(ptr %p) {
  %q = ptrtoint ptr %p to i32
  %r = add nuw i32 %q, 24
  %s = inttoptr i32 %r to ptr
  %t = load i8, ptr %s
  %u = sext i8 %t to i32
  ret i32 %u
}
