; RUN: llc -verify-machineinstrs -O2 -mcpu=pwr8 -mtriple=powerpc64le-unknown-unknown < %s | FileCheck %s

; Function Attrs: norecurse nounwind
define void @test1(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr nocapture readnone %c, i32 signext %n) #0 {

; CHECK-LABEL: test1

entry:
  %idxprom = sext i32 %n to i64
  %arrayidx = getelementptr inbounds i32, ptr %b, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4, !tbaa !1
  %conv = sitofp i32 %0 to float
  %mul = fmul float %conv, 0x4002916880000000
  %arrayidx2 = getelementptr inbounds float, ptr %a, i64 %idxprom
  store float %mul, ptr %arrayidx2, align 4, !tbaa !5
  ret void

; CHECK-NOT: mtvsrwa
; CHECK-NOT: mtfprwa
; CHECK: lfiwax [[REG:[0-9]+]], {{.*}}
; CHECK-NOT: mtvsrwa
; CHECK-NOT: mtfprwa
; CHECK: xscvsxdsp {{.*}}, [[REG]]
; CHECK-NOT: mtvsrwa
; CHECK-NOT: mtfprwa
; CHECK: blr

}

; Function Attrs: norecurse nounwind readonly
define float @test2(ptr nocapture readonly %b) #0 {

; CHECK-LABEL: test2

entry:
  %0 = load i32, ptr %b, align 4, !tbaa !1
  %conv = sitofp i32 %0 to float
  %mul = fmul float %conv, 0x40030A3D80000000
  ret float %mul

; CHECK-NOT: mtvsrwa
; CHECK-NOT: mtfprwa
; CHECK: lfiwax [[REG:[0-9]+]], {{.*}}
; CHECK-NOT: mtvsrwa
; CHECK-NOT: mtfprwa
; CHECK: xscvsxdsp {{.*}}, [[REG]]
; CHECK-NOT: mtvsrwa
; CHECK-NOT: mtfprwa
; CHECK: blr

}

; Function Attrs: norecurse nounwind
define void @test3(ptr noalias nocapture %a, ptr noalias nocapture readonly %b, ptr noalias nocapture %c, i32 signext %n) #0 {

; CHECK-LABEL: test3

entry:
  %idxprom = sext i32 %n to i64
  %arrayidx = getelementptr inbounds i32, ptr %b, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4, !tbaa !1
  %conv = sitofp i32 %0 to float
  %mul = fmul float %conv, 0x4002916880000000
  %arrayidx2 = getelementptr inbounds float, ptr %a, i64 %idxprom
  store float %mul, ptr %arrayidx2, align 4, !tbaa !5
  %arrayidx6 = getelementptr inbounds i32, ptr %c, i64 %idxprom
  %1 = load i32, ptr %arrayidx6, align 4, !tbaa !1
  %add = add nsw i32 %1, %0
  store i32 %add, ptr %arrayidx6, align 4, !tbaa !1
  ret void

; CHECK: mtfprwa
; CHECK: blr

}

!0 = !{!"clang version 3.9.0"}
!1 = !{!2, !2, i64 0}
!2 = !{!"int", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C++ TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"float", !3, i64 0}
