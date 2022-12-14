; RUN: llc %s -mtriple=riscv32 -o - | FileCheck %s

define i1 @no__mulodi4(i32 %a, i64 %b, ptr %c) {
; CHECK-LABEL: no__mulodi4
; CHECK-NOT: call __mulodi4@plt
; CHECK-NOT: call __multi3@plt
entry:
  %0 = sext i32 %a to i64
  %1 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %0, i64 %b)
  %2 = extractvalue { i64, i1 } %1, 1
  %3 = extractvalue { i64, i1 } %1, 0
  %4 = trunc i64 %3 to i32
  %5 = sext i32 %4 to i64
  %6 = icmp ne i64 %3, %5
  %7 = or i1 %2, %6
  store i32 %4, ptr %c, align 4
  ret i1 %7
}

declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64)
