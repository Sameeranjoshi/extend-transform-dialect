; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals
; Test that the printf library call simplifier works correctly.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@hello_world = constant [13 x i8] c"hello world\0A\00"
@h = constant [2 x i8] c"h\00"
@percent_s = constant [4 x i8] c"%s\0A\00"
@format_str = constant [3 x i8] c"%s\00"
@charstr = constant [2 x i8] c"a\00"
@empty = constant [1 x i8] c"\00"

declare i32 @printf(ptr, ...)

; Check simplification of printf with void return type.

;.
; CHECK: @[[HELLO_WORLD:[a-zA-Z0-9_$"\\.-]+]] = constant [13 x i8] c"hello world\0A\00"
; CHECK: @[[H:[a-zA-Z0-9_$"\\.-]+]] = constant [2 x i8] c"h\00"
; CHECK: @[[PERCENT_S:[a-zA-Z0-9_$"\\.-]+]] = constant [4 x i8] c"%s\0A\00"
; CHECK: @[[FORMAT_STR:[a-zA-Z0-9_$"\\.-]+]] = constant [3 x i8] c"%s\00"
; CHECK: @[[CHARSTR:[a-zA-Z0-9_$"\\.-]+]] = constant [2 x i8] c"a\00"
; CHECK: @[[EMPTY:[a-zA-Z0-9_$"\\.-]+]] = constant [1 x i8] zeroinitializer
; CHECK: @[[STR:[a-zA-Z0-9_$"\\.-]+]] = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
; CHECK: @[[STR_1:[a-zA-Z0-9_$"\\.-]+]] = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
; CHECK: @[[STR_2:[a-zA-Z0-9_$"\\.-]+]] = private unnamed_addr constant [12 x i8] c"hello world\00", align 1
;.
define void @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    [[PUTCHAR:%.*]] = call i32 @putchar(i32 104)
; CHECK-NEXT:    ret void
;
  call i32 (ptr, ...) @printf(ptr @h)
  ret void
}

define void @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    [[PUTS:%.*]] = call i32 @puts(ptr nonnull dereferenceable(1) @str)
; CHECK-NEXT:    ret void
;
  call i32 (ptr, ...) @printf(ptr @hello_world)
  ret void
}

define void @test_simplify6() {
; CHECK-LABEL: @test_simplify6(
; CHECK-NEXT:    [[PUTS:%.*]] = call i32 @puts(ptr nonnull dereferenceable(1) @hello_world)
; CHECK-NEXT:    ret void
;
  call i32 (ptr, ...) @printf(ptr @percent_s, ptr @hello_world)
  ret void
}

define void @test_simplify7() {
; CHECK-LABEL: @test_simplify7(
; CHECK-NEXT:    [[PUTCHAR:%.*]] = call i32 @putchar(i32 97)
; CHECK-NEXT:    ret void
;
  call i32 (ptr, ...) @printf(ptr @format_str, ptr @charstr)
  ret void
}

; printf("%s", "") --> noop

define void @test_simplify8() {
; CHECK-LABEL: @test_simplify8(
; CHECK-NEXT:    ret void
;
  call i32 (ptr, ...) @printf(ptr @format_str, ptr @empty)
  ret void
}

; printf("%s", str"\n") --> puts(str)

define void @test_simplify9() {
; CHECK-LABEL: @test_simplify9(
; CHECK-NEXT:    [[PUTS:%.*]] = call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
; CHECK-NEXT:    ret void
;
  call i32 (ptr, ...) @printf(ptr @format_str, ptr @hello_world)
  ret void
}

; printf("%s", "", ...) --> noop
; printf("%s", "a", ...) --> putchar('a')
; printf("%s", str"\n", ...) --> puts(str)

define void @test_simplify10() {
; CHECK-LABEL: @test_simplify10(
; CHECK-NEXT:    [[PUTCHAR:%.*]] = call i32 @putchar(i32 97)
; CHECK-NEXT:    [[PUTS:%.*]] = call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
; CHECK-NEXT:    ret void
;
  call i32 (ptr, ...) @printf(ptr @format_str, ptr @empty, i32 42, double 0x40091EB860000000)
  call i32 (ptr, ...) @printf(ptr @format_str, ptr @charstr, i32 42, double 0x40091EB860000000)
  call i32 (ptr, ...) @printf(ptr @format_str, ptr @hello_world, i32 42, double 0x40091EB860000000)
  ret void
}
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { nofree nounwind }
;.
