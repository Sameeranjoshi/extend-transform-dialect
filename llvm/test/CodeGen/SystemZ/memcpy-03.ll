; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=z15 < %s -mtriple=s390x-linux-gnu | FileCheck %s
;
; Test memcpys of small constant lengths that should not be done with MVC.

declare void @llvm.memcpy.p0.p0.i64(ptr nocapture, ptr nocapture, i64, i1) nounwind

define void @fun16(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mvc 0(16,%r3), 0(%r2)
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 16, i1 false)
  ret void
}

define void @fun17(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun17:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lb %r0, 16(%r2)
; CHECK-NEXT:    stc %r0, 16(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 17, i1 false)
  ret void
}

define void @fun18(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun18:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lh %r0, 16(%r2)
; CHECK-NEXT:    sth %r0, 16(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 18, i1 false)
  ret void
}

define void @fun19(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun19:
; CHECK:       # %bb.0:
; CHECK-NEXT:    l %r0, 15(%r2)
; CHECK-NEXT:    st %r0, 15(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 19, i1 false)
  ret void
}

define void @fun20(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun20:
; CHECK:       # %bb.0:
; CHECK-NEXT:    l %r0, 16(%r2)
; CHECK-NEXT:    st %r0, 16(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 20, i1 false)
  ret void
}

define void @fun21(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun21:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lg %r0, 13(%r2)
; CHECK-NEXT:    stg %r0, 13(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 21, i1 false)
  ret void
}

define void @fun22(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun22:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lg %r0, 14(%r2)
; CHECK-NEXT:    stg %r0, 14(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 22, i1 false)
  ret void
}

define void @fun23(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun23:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lg %r0, 15(%r2)
; CHECK-NEXT:    stg %r0, 15(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 23, i1 false)
  ret void
}

define void @fun24(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun24:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lg %r0, 16(%r2)
; CHECK-NEXT:    stg %r0, 16(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 24, i1 false)
  ret void
}

define void @fun25(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun25:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 9(%r2)
; CHECK-NEXT:    vst %v0, 9(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 25, i1 false)
  ret void
}

define void @fun26(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun26:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 10(%r2)
; CHECK-NEXT:    vst %v0, 10(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 26, i1 false)
  ret void
}

define void @fun27(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun27:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 11(%r2)
; CHECK-NEXT:    vst %v0, 11(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 27, i1 false)
  ret void
}

define void @fun28(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun28:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 12(%r2)
; CHECK-NEXT:    vst %v0, 12(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 28, i1 false)
  ret void
}

define void @fun29(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun29:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 13(%r2)
; CHECK-NEXT:    vst %v0, 13(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 29, i1 false)
  ret void
}

define void @fun30(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun30:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 14(%r2)
; CHECK-NEXT:    vst %v0, 14(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 30, i1 false)
  ret void
}

define void @fun31(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun31:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 15(%r2)
; CHECK-NEXT:    vst %v0, 15(%r3)
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 31, i1 false)
  ret void
}

define void @fun32(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 16(%r2), 4
; CHECK-NEXT:    vst %v0, 16(%r3), 4
; CHECK-NEXT:    vl %v0, 0(%r2), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 32, i1 false)
  ret void
}

define void @fun33(ptr %Src, ptr %Dst, i8 %val) {
; CHECK-LABEL: fun33:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mvc 0(33,%r3), 0(%r2)
; CHECK-NEXT:    br %r14
  call void @llvm.memcpy.p0.p0.i64(ptr align 16 %Dst, ptr align 16 %Src, i64 33, i1 false)
  ret void
}

