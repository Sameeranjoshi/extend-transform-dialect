; RUN: opt -aa-pipeline=basic-aa -passes=gvn -S < %s | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:32:32-f32:32:32-f64:32:32-v64:32:64-v128:32:128-a0:0:32-n32"

; BasicAA should prove that these calls don't interfere, since they are
; IntrArgReadMem and have noalias pointers.

; CHECK:      define <8 x i16> @test0(ptr noalias %p, ptr noalias %q, <8 x i16> %y, <8 x i1> %m, <8 x i16> %pt) {
; CHECK-NEXT: entry:
; CHECK-NEXT:   %a = call <8 x i16> @llvm.masked.load.v8i16.p0(ptr %p, i32 16, <8 x i1> %m, <8 x i16> %pt) [[ATTR:#[0-9]+]]
; CHECK-NEXT:   call void @llvm.masked.store.v8i16.p0(<8 x i16> %y, ptr %q, i32 16, <8 x i1> %m)
; CHECK-NEXT:   %c = add <8 x i16> %a, %a
define <8 x i16> @test0(ptr noalias %p, ptr noalias %q, <8 x i16> %y, <8 x i1> %m, <8 x i16> %pt) {
entry:
  %a = call <8 x i16> @llvm.masked.load.v8i16.p0(ptr %p, i32 16, <8 x i1> %m, <8 x i16> %pt) nounwind
  call void @llvm.masked.store.v8i16.p0(<8 x i16> %y, ptr %q, i32 16, <8 x i1> %m)
  %b = call <8 x i16> @llvm.masked.load.v8i16.p0(ptr %p, i32 16, <8 x i1> %m, <8 x i16> %pt) nounwind
  %c = add <8 x i16> %a, %b
  ret <8 x i16> %c
}

declare <8 x i16> @llvm.masked.load.v8i16.p0(ptr, i32, <8 x i1>, <8 x i16>) nounwind readonly
declare void @llvm.masked.store.v8i16.p0(<8 x i16>, ptr, i32, <8 x i1>) nounwind

; CHECK: attributes #0 = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
; CHECK: attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }
; CHECK: attributes [[ATTR]] = { nounwind }
