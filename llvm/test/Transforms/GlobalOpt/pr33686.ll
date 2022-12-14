; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=globalopt %s | FileCheck %s

@glob = external global i16, align 1

define void @beth() {
; CHECK-LABEL: @beth(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  ret void

notreachable:
  %patatino = select i1 undef, ptr @glob, ptr %patatino
  br label %notreachable
}
