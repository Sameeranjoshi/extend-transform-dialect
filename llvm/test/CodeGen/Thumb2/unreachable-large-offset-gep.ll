; RUN: llc -o - %s | FileCheck %s

; CHECK: .LBB0_1:
; CHECK: b .LBB0_1

target triple = "thumbv8m-unknown-linux-android"

define void @d(ptr %c) {
entry:
  br i1 false, label %f.exit, label %i.d

i.d:
  br label %i.d

f.exit:
  %0 = getelementptr i32, ptr %c, i32 57
  br label %if.g

if.g:
  store i32 0, ptr %0
  ret void
}
