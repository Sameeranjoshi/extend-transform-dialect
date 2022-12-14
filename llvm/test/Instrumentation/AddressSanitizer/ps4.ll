; RUN: opt < %s -passes=asan -S -mtriple=x86_64-scei-ps4 | FileCheck %s
; RUN: opt < %s -passes=asan -S -mtriple=x86_64-sie-ps5 | FileCheck %s

define i32 @read_4_bytes(ptr %a) sanitize_address {
entry:
  %tmp1 = load i32, ptr %a, align 4
  ret i32 %tmp1
}

; CHECK: @read_4_bytes
; CHECK-NOT: ret
; Check for ASAN's Offset on the PS4/PS5 (2^40 or 0x10000000000)
; CHECK: lshr {{.*}} 3
; CHECK-NEXT: {{1099511627776}}
; CHECK: ret
