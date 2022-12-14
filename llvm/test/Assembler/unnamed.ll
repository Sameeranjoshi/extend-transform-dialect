; RUN: llvm-as < %s | llvm-dis
; RUN: verify-uselistorder %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128"

module asm "this is an inline asm block"
module asm "this is another inline asm block"

%0 = type { %1, %2 }
%1 = type { i32 }
%2 = type { float, double }

@0 = global i32 0
@1 = global float 3.0
@2 = global ptr null
@3 = global x86_fp80 0xK4001E000000000000000

define float @foo(ptr %p) nounwind {
  %t = load %0, ptr %p                                ; <%0> [#uses=2]
  %s = extractvalue %0 %t, 1, 0                   ; <float> [#uses=1]
  %r = insertvalue %0 %t, double 2.000000e+00, 1, 1; <%0> [#uses=1]
  store %0 %r, ptr %p
  ret float %s
}

define float @bar(ptr %p) nounwind {
  store %0 { %1 { i32 4 }, %2 { float 4.000000e+00, double 2.000000e+01 } }, ptr %p
  ret float 7.000000e+00
}

define float @car(ptr %p) nounwind {
  store %0 { %1 undef, %2 { float undef, double 2.000000e+01 } }, ptr %p
  ret float undef
}

define float @dar(ptr %p) nounwind {
  store %0 { %1 zeroinitializer, %2 { float 0.000000e+00, double 2.000000e+01 } }, ptr %p
  ret float 0.000000e+00
}

define ptr @qqq() {
  ret ptr @0
}
define ptr @rrr() {
  ret ptr @1
}
define ptr @sss() {
  ret ptr @2
}
define ptr @nnn() {
  ret ptr @3
}
