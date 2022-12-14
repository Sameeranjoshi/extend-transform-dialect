; RUN: llc -verify-machineinstrs -mcpu=ppc64 -O0 -fast-isel=false < %s | FileCheck %s

; This tests receiving and re-passing parameters consisting of structures
; of size 3, 5, 6, and 7.  They are to be found/placed right-adjusted in
; the parameter registers.

target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v128:128:128-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

%struct.S3 = type { [3 x i8] }
%struct.S5 = type { [5 x i8] }
%struct.S6 = type { [6 x i8] }
%struct.S7 = type { [7 x i8] }

define void @test(ptr byval(%struct.S3) %s3, ptr byval(%struct.S5) %s5, ptr byval(%struct.S6) %s6, ptr byval(%struct.S7) %s7) nounwind {
entry:
  call void @check(ptr byval(%struct.S3) %s3, ptr byval(%struct.S5) %s5, ptr byval(%struct.S6) %s6, ptr byval(%struct.S7) %s7)
  ret void
}

; CHECK-LABEL: test
; CHECK:     stb 6, 191(1)
; CHECK:     rldicl 7, 6, 56, 8
; CHECK:     sth 7, 189(1)
; CHECK:     rldicl 6, 6, 40, 24
; CHECK:     stw 6, 185(1)
; CHECK:     sth 5, 182(1)
; CHECK:     rldicl 5, 5, 48, 16
; CHECK:     stw 5, 178(1)
; CHECK:     stb 4, 175(1)
; CHECK:     rldicl 4, 4, 56, 8
; CHECK:     stw 4, 171(1)
; CHECK:     stb 3, 167(1)
; CHECK:     rldicl 3, 3, 56, 8
; CHECK:     sth 3, 165(1)
; CHECK-DAG: lbz {{[0-9]+}}, 167(1)
; CHECK-DAG: lhz {{[0-9]+}}, 165(1)
; CHECK-DAG: stb {{[0-9]+}}, 55(1)
; CHECK-DAG: sth {{[0-9]+}}, 53(1)
; CHECK-DAG: lbz {{[0-9]+}}, 175(1)
; CHECK-DAG: lwz {{[0-9]+}}, 171(1)
; CHECK-DAG: stb {{[0-9]+}}, 63(1)
; CHECK-DAG: stw {{[0-9]+}}, 59(1)
; CHECK-DAG: lhz {{[0-9]+}}, 182(1)
; CHECK-DAG: lwz {{[0-9]+}}, 178(1)
; CHECK-DAG: sth {{[0-9]+}}, 70(1)
; CHECK-DAG: stw {{[0-9]+}}, 66(1)
; CHECK-DAG: lwz {{[0-9]+}}, 188(1)
; CHECK-DAG: lwz {{[0-9]+}}, 185(1)
; CHECK-DAG: stw {{[0-9]+}}, 76(1)
; CHECK-DAG: stw {{[0-9]+}}, 73(1)
; CHECK-DAG: ld 6, 72(1)
; CHECK-DAG: ld 5, 64(1)
; CHECK-DAG: ld 4, 56(1)
; CHECK-DAG: ld 3, 48(1)

declare void @check(ptr byval(%struct.S3), ptr byval(%struct.S5), ptr byval(%struct.S6), ptr byval(%struct.S7))
