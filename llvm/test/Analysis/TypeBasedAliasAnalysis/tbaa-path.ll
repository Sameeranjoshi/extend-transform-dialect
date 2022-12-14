; RUN: opt < %s -aa-pipeline=tbaa,basic-aa -passes=aa-eval -evaluate-aa-metadata -print-no-aliases -print-may-aliases -disable-output 2>&1 | FileCheck %s
; RUN: opt < %s -aa-pipeline=tbaa,basic-aa -passes=gvn -S | FileCheck %s --check-prefix=OPT
; Generated from clang/test/CodeGen/tbaa.cpp with "-O1 -struct-path-tbaa -disable-llvm-optzns".

%struct.StructA = type { i16, i32, i16, i32 }
%struct.StructB = type { i16, %struct.StructA, i32 }
%struct.StructS = type { i16, i32 }
%struct.StructS2 = type { i16, i32 }
%struct.StructC = type { i16, %struct.StructB, i32 }
%struct.StructD = type { i16, %struct.StructB, i32, i8 }

define i32 @_Z1gPjP7StructAy(ptr %s, ptr %A, i64 %count) #0 {
entry:
; Access to ptr and &(A->f32).
; CHECK: Function
; CHECK: MayAlias:   store i32 4, ptr %f32, align 4, !tbaa !8 <->   store i32 1, ptr %0, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; OPT: %[[RET:.*]] = load i32, ptr
; OPT: ret i32 %[[RET]]
  %s.addr = alloca ptr, align 8
  %A.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %s, ptr %s.addr, align 8, !tbaa !0
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %s.addr, align 8, !tbaa !0
  store i32 1, ptr %0, align 4, !tbaa !6
  %1 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructA, ptr %1, i32 0, i32 1
  store i32 4, ptr %f32, align 4, !tbaa !8
  %2 = load ptr, ptr %s.addr, align 8, !tbaa !0
  %3 = load i32, ptr %2, align 4, !tbaa !6
  ret i32 %3
}

define i32 @_Z2g2PjP7StructAy(ptr %s, ptr %A, i64 %count) #0 {
entry:
; Access to ptr and &(A->f16).
; CHECK: Function
; CHECK: NoAlias:   store i16 4, ptr %1, align 2, !tbaa !8 <->   store i32 1, ptr %0, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i16 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %s.addr = alloca ptr, align 8
  %A.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %s, ptr %s.addr, align 8, !tbaa !0
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %s.addr, align 8, !tbaa !0
  store i32 1, ptr %0, align 4, !tbaa !6
  %1 = load ptr, ptr %A.addr, align 8, !tbaa !0
  store i16 4, ptr %1, align 2, !tbaa !11
  %2 = load ptr, ptr %s.addr, align 8, !tbaa !0
  %3 = load i32, ptr %2, align 4, !tbaa !6
  ret i32 %3
}

define i32 @_Z2g3P7StructAP7StructBy(ptr %A, ptr %B, i64 %count) #0 {
entry:
; Access to &(A->f32) and &(B->a.f32).
; CHECK: Function
; CHECK: MayAlias:   store i32 4, ptr %f321, align 4, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; OPT: %[[RET:.*]] = load i32, ptr
; OPT: ret i32 %[[RET]]
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store ptr %B, ptr %B.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructA, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !8
  %1 = load ptr, ptr %B.addr, align 8, !tbaa !0
  %a = getelementptr inbounds %struct.StructB, ptr %1, i32 0, i32 1
  %f321 = getelementptr inbounds %struct.StructA, ptr %a, i32 0, i32 1
  store i32 4, ptr %f321, align 4, !tbaa !12
  %2 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f322 = getelementptr inbounds %struct.StructA, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f322, align 4, !tbaa !8
  ret i32 %3
}

define i32 @_Z2g4P7StructAP7StructBy(ptr %A, ptr %B, i64 %count) #0 {
entry:
; Access to &(A->f32) and &(B->a.f16).
; CHECK: Function
; CHECK: NoAlias:   store i16 4, ptr %a, align 2, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i16 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store ptr %B, ptr %B.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructA, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !8
  %1 = load ptr, ptr %B.addr, align 8, !tbaa !0
  %a = getelementptr inbounds %struct.StructB, ptr %1, i32 0, i32 1
  store i16 4, ptr %a, align 2, !tbaa !14
  %2 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f321 = getelementptr inbounds %struct.StructA, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f321, align 4, !tbaa !8
  ret i32 %3
}

define i32 @_Z2g5P7StructAP7StructBy(ptr %A, ptr %B, i64 %count) #0 {
entry:
; Access to &(A->f32) and &(B->f32).
; CHECK: Function
; CHECK: NoAlias:   store i32 4, ptr %f321, align 4, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store ptr %B, ptr %B.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructA, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !8
  %1 = load ptr, ptr %B.addr, align 8, !tbaa !0
  %f321 = getelementptr inbounds %struct.StructB, ptr %1, i32 0, i32 2
  store i32 4, ptr %f321, align 4, !tbaa !15
  %2 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f322 = getelementptr inbounds %struct.StructA, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f322, align 4, !tbaa !8
  ret i32 %3
}

define i32 @_Z2g6P7StructAP7StructBy(ptr %A, ptr %B, i64 %count) #0 {
entry:
; Access to &(A->f32) and &(B->a.f32_2).
; CHECK: Function
; CHECK: NoAlias:   store i32 4, ptr %f32_2, align 4, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %A.addr = alloca ptr, align 8
  %B.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store ptr %B, ptr %B.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructA, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !8
  %1 = load ptr, ptr %B.addr, align 8, !tbaa !0
  %a = getelementptr inbounds %struct.StructB, ptr %1, i32 0, i32 1
  %f32_2 = getelementptr inbounds %struct.StructA, ptr %a, i32 0, i32 3
  store i32 4, ptr %f32_2, align 4, !tbaa !16
  %2 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f321 = getelementptr inbounds %struct.StructA, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f321, align 4, !tbaa !8
  ret i32 %3
}

define i32 @_Z2g7P7StructAP7StructSy(ptr %A, ptr %S, i64 %count) #0 {
entry:
; Access to &(A->f32) and &(S->f32).
; CHECK: Function
; CHECK: NoAlias:   store i32 4, ptr %f321, align 4, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %A.addr = alloca ptr, align 8
  %S.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store ptr %S, ptr %S.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructA, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !8
  %1 = load ptr, ptr %S.addr, align 8, !tbaa !0
  %f321 = getelementptr inbounds %struct.StructS, ptr %1, i32 0, i32 1
  store i32 4, ptr %f321, align 4, !tbaa !17
  %2 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f322 = getelementptr inbounds %struct.StructA, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f322, align 4, !tbaa !8
  ret i32 %3
}

define i32 @_Z2g8P7StructAP7StructSy(ptr %A, ptr %S, i64 %count) #0 {
entry:
; Access to &(A->f32) and &(S->f16).
; CHECK: Function
; CHECK: NoAlias:   store i16 4, ptr %1, align 2, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i16 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %A.addr = alloca ptr, align 8
  %S.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %A, ptr %A.addr, align 8, !tbaa !0
  store ptr %S, ptr %S.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructA, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !8
  %1 = load ptr, ptr %S.addr, align 8, !tbaa !0
  store i16 4, ptr %1, align 2, !tbaa !19
  %2 = load ptr, ptr %A.addr, align 8, !tbaa !0
  %f321 = getelementptr inbounds %struct.StructA, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f321, align 4, !tbaa !8
  ret i32 %3
}

define i32 @_Z2g9P7StructSP8StructS2y(ptr %S, ptr %S2, i64 %count) #0 {
entry:
; Access to &(S->f32) and &(S2->f32).
; CHECK: Function
; CHECK: NoAlias:   store i32 4, ptr %f321, align 4, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %S.addr = alloca ptr, align 8
  %S2.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %S, ptr %S.addr, align 8, !tbaa !0
  store ptr %S2, ptr %S2.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %S.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructS, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !17
  %1 = load ptr, ptr %S2.addr, align 8, !tbaa !0
  %f321 = getelementptr inbounds %struct.StructS2, ptr %1, i32 0, i32 1
  store i32 4, ptr %f321, align 4, !tbaa !20
  %2 = load ptr, ptr %S.addr, align 8, !tbaa !0
  %f322 = getelementptr inbounds %struct.StructS, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f322, align 4, !tbaa !17
  ret i32 %3
}

define i32 @_Z3g10P7StructSP8StructS2y(ptr %S, ptr %S2, i64 %count) #0 {
entry:
; Access to &(S->f32) and &(S2->f16).
; CHECK: Function
; CHECK: NoAlias:   store i16 4, ptr %1, align 2, !tbaa !10 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i16 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %S.addr = alloca ptr, align 8
  %S2.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %S, ptr %S.addr, align 8, !tbaa !0
  store ptr %S2, ptr %S2.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %S.addr, align 8, !tbaa !0
  %f32 = getelementptr inbounds %struct.StructS, ptr %0, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !17
  %1 = load ptr, ptr %S2.addr, align 8, !tbaa !0
  store i16 4, ptr %1, align 2, !tbaa !22
  %2 = load ptr, ptr %S.addr, align 8, !tbaa !0
  %f321 = getelementptr inbounds %struct.StructS, ptr %2, i32 0, i32 1
  %3 = load i32, ptr %f321, align 4, !tbaa !17
  ret i32 %3
}

define i32 @_Z3g11P7StructCP7StructDy(ptr %C, ptr %D, i64 %count) #0 {
entry:
; Access to &(C->b.a.f32) and &(D->b.a.f32).
; CHECK: Function
; CHECK: NoAlias:   store i32 4, ptr %f323, align 4, !tbaa !12 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; Remove a load and propagate the value from store.
; OPT: ret i32 1
  %C.addr = alloca ptr, align 8
  %D.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  store ptr %C, ptr %C.addr, align 8, !tbaa !0
  store ptr %D, ptr %D.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %C.addr, align 8, !tbaa !0
  %b = getelementptr inbounds %struct.StructC, ptr %0, i32 0, i32 1
  %a = getelementptr inbounds %struct.StructB, ptr %b, i32 0, i32 1
  %f32 = getelementptr inbounds %struct.StructA, ptr %a, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !23
  %1 = load ptr, ptr %D.addr, align 8, !tbaa !0
  %b1 = getelementptr inbounds %struct.StructD, ptr %1, i32 0, i32 1
  %a2 = getelementptr inbounds %struct.StructB, ptr %b1, i32 0, i32 1
  %f323 = getelementptr inbounds %struct.StructA, ptr %a2, i32 0, i32 1
  store i32 4, ptr %f323, align 4, !tbaa !25
  %2 = load ptr, ptr %C.addr, align 8, !tbaa !0
  %b4 = getelementptr inbounds %struct.StructC, ptr %2, i32 0, i32 1
  %a5 = getelementptr inbounds %struct.StructB, ptr %b4, i32 0, i32 1
  %f326 = getelementptr inbounds %struct.StructA, ptr %a5, i32 0, i32 1
  %3 = load i32, ptr %f326, align 4, !tbaa !23
  ret i32 %3
}

define i32 @_Z3g12P7StructCP7StructDy(ptr %C, ptr %D, i64 %count) #0 {
entry:
; Access to &(b1->a.f32) and &(b2->a.f32).
; CHECK: Function
; CHECK: MayAlias:   store i32 4, ptr %f325, align 4, !tbaa !6 <->   store i32 1, ptr %f32, align 4, !tbaa !6
; OPT: define
; OPT: store i32 1
; OPT: store i32 4
; OPT: %[[RET:.*]] = load i32, ptr
; OPT: ret i32 %[[RET]]
  %C.addr = alloca ptr, align 8
  %D.addr = alloca ptr, align 8
  %count.addr = alloca i64, align 8
  %b1 = alloca ptr, align 8
  %b2 = alloca ptr, align 8
  store ptr %C, ptr %C.addr, align 8, !tbaa !0
  store ptr %D, ptr %D.addr, align 8, !tbaa !0
  store i64 %count, ptr %count.addr, align 8, !tbaa !4
  %0 = load ptr, ptr %C.addr, align 8, !tbaa !0
  %b = getelementptr inbounds %struct.StructC, ptr %0, i32 0, i32 1
  store ptr %b, ptr %b1, align 8, !tbaa !0
  %1 = load ptr, ptr %D.addr, align 8, !tbaa !0
  %b3 = getelementptr inbounds %struct.StructD, ptr %1, i32 0, i32 1
  store ptr %b3, ptr %b2, align 8, !tbaa !0
  %2 = load ptr, ptr %b1, align 8, !tbaa !0
  %a = getelementptr inbounds %struct.StructB, ptr %2, i32 0, i32 1
  %f32 = getelementptr inbounds %struct.StructA, ptr %a, i32 0, i32 1
  store i32 1, ptr %f32, align 4, !tbaa !12
  %3 = load ptr, ptr %b2, align 8, !tbaa !0
  %a4 = getelementptr inbounds %struct.StructB, ptr %3, i32 0, i32 1
  %f325 = getelementptr inbounds %struct.StructA, ptr %a4, i32 0, i32 1
  store i32 4, ptr %f325, align 4, !tbaa !12
  %4 = load ptr, ptr %b1, align 8, !tbaa !0
  %a6 = getelementptr inbounds %struct.StructB, ptr %4, i32 0, i32 1
  %f327 = getelementptr inbounds %struct.StructA, ptr %a6, i32 0, i32 1
  %5 = load i32, ptr %f327, align 4, !tbaa !12
  ret i32 %5
}

attributes #0 = { nounwind "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }

!0 = !{!1, !1, i64 0}
!1 = !{!"any pointer", !2}
!2 = !{!"omnipotent char", !3}
!3 = !{!"Simple C/C++ TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"long long", !2}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !2}
!8 = !{!9, !7, i64 4}
!9 = !{!"_ZTS7StructA", !10, i64 0, !7, i64 4, !10, i64 8, !7, i64 12}
!10 = !{!"short", !2}
!11 = !{!9, !10, i64 0}
!12 = !{!13, !7, i64 8}
!13 = !{!"_ZTS7StructB", !10, i64 0, !9, i64 4, !7, i64 20}
!14 = !{!13, !10, i64 4}
!15 = !{!13, !7, i64 20}
!16 = !{!13, !7, i64 16}
!17 = !{!18, !7, i64 4}
!18 = !{!"_ZTS7StructS", !10, i64 0, !7, i64 4}
!19 = !{!18, !10, i64 0}
!20 = !{!21, !7, i64 4}
!21 = !{!"_ZTS8StructS2", !10, i64 0, !7, i64 4}
!22 = !{!21, !10, i64 0}
!23 = !{!24, !7, i64 12}
!24 = !{!"_ZTS7StructC", !10, i64 0, !13, i64 4, !7, i64 28}
!25 = !{!26, !7, i64 12}
!26 = !{!"_ZTS7StructD", !10, i64 0, !13, i64 4, !7, i64 28, !2, i64 32}
