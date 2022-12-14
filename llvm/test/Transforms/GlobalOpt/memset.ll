; RUN: opt -S -passes=globalopt < %s | FileCheck %s

; CHECK-NOT: internal

; Both globals are write only, delete them.

@G0 = internal global [58 x i8] c"asdlfkajsdlfkajsd;lfkajds;lfkjasd;flkajsd;lkfja;sdlkfjasd\00"         ; <ptr> [#uses=1]
@G1 = internal global [4 x i32] [ i32 1, i32 2, i32 3, i32 4 ]          ; <ptr> [#uses=1]

define void @foo() {
  %Blah = alloca [58 x i8]
  call void @llvm.memcpy.p0.p0.i32(ptr @G1, ptr %Blah, i32 16, i1 false)
  call void @llvm.memset.p0.i32(ptr @G0, i8 17, i32 58, i1 false)
  ret void
}

@G0_as1 = internal addrspace(1) global [58 x i8] c"asdlfkajsdlfkajsd;lfkajds;lfkjasd;flkajsd;lkfja;sdlkfjasd\00"         ; <ptr> [#uses=1]
@G1_as1 = internal addrspace(1) global [4 x i32] [ i32 1, i32 2, i32 3, i32 4 ]          ; <ptr> [#uses=1]

define void @foo_as1() {
  %Blah = alloca [58 x i8]
  call void @llvm.memcpy.p0.p0.i32(ptr addrspacecast (ptr addrspace(1) @G1_as1 to ptr), ptr %Blah, i32 16, i1 false)
  call void @llvm.memset.p1.i32(ptr addrspace(1) @G0_as1, i8 17, i32 58, i1 false)
  ret void
}

declare void @llvm.memcpy.p0.p0.i32(ptr nocapture, ptr nocapture, i32, i1) nounwind
declare void @llvm.memset.p0.i32(ptr nocapture, i8, i32, i1) nounwind
declare void @llvm.memset.p1.i32(ptr addrspace(1) nocapture, i8, i32, i1) nounwind
