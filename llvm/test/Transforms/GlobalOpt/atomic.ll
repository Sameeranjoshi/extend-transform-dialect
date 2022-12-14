; RUN: opt -passes=globalopt < %s -S -o - | FileCheck %s

@GV1 = internal global i64 1, align 8
@GV2 = internal global i32 0, align 4

; CHECK-NOT: @GV1 =
; CHECK: @GV2 = internal unnamed_addr global i32 0, align 4

define void @test1() {
entry:
  %0 = load atomic i8, ptr @GV1 acquire, align 8
  ret void
}

; PR17163
define void @test2a() {
entry:
  store atomic i32 10, ptr @GV2 seq_cst, align 4
  ret void
}
define i32 @test2b() {
entry:
  %atomic-load = load atomic i32, ptr @GV2 seq_cst, align 4
  ret i32 %atomic-load
}


define i64 @test3() {
; CHECK-LABEL: @test3
; CHECK: ret i64 1

  %val = load atomic i64, ptr @GV1 acquire, align 8
  ret i64 %val
}
