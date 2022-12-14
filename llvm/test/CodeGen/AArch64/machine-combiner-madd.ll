; Test all AArch64 subarches with scheduling models.
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=a64fx      < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=cortex-a57 < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=cortex-a72 < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=cortex-a73 < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=cyclone    < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=exynos-m3  < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=kryo       < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=thunderx2t99 < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=thunderx3t110 < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-linux-gnu -mcpu=tsv110 < %s | FileCheck %s

; Make sure that inst-combine fuses the multiply add in the addressing mode of
; the load.

; CHECK-LABEL: fun:
; CHECK-NOT: mul
; CHECK:     madd
; CHECK-NOT: mul

%class.D = type { %class.basic_string.base, [4 x i8] }
%class.basic_string.base = type <{ i64, i64, i32 }>
@a = global ptr zeroinitializer, align 8
declare void @llvm.memcpy.p0.p0.i64(ptr nocapture writeonly, ptr nocapture readonly, i64, i1)
define internal void @fun() section ".text.startup" {
entry:
  %tmp.i.i = alloca %class.D, align 8
  br label %loop
loop:
  %conv11.i.i = phi i64 [ 0, %entry ], [ %inc.i.i, %loop ]
  %i = phi i64 [ undef, %entry ], [ %inc.i.i, %loop ]
  %x = load ptr, ptr @a, align 8
  %arrayidx.i.i.i = getelementptr inbounds %class.D, ptr %x, i64 %conv11.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 nonnull %tmp.i.i, ptr align 8 %arrayidx.i.i.i, i64 24, i1 false)
  %inc.i.i = add i64 %i, 1
  %cmp.i.i = icmp slt i64 %inc.i.i, 0
  br i1 %cmp.i.i, label %loop, label %exit
exit:
  ret void
}
