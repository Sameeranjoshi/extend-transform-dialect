; RUN: llvm-link %s -S -o - | FileCheck %s

@g1 = global ptr @f2
; CHECK-DAG: @g1 = global ptr @f2

@p1 = global i8 42
; CHECK-DAG: @p1 = global i8 42

@p2 = internal global i8 43
; CHECK-DAG: @p2 = internal global i8 43

define void @f1() prologue ptr @p1 {
  ret void
}
; CHECK-DAG: define void @f1() prologue ptr @p1 {

define internal void @f2() prologue ptr @p2 {
  ret void
}

; CHECK-DAG: define internal void @f2() prologue ptr @p2 {
