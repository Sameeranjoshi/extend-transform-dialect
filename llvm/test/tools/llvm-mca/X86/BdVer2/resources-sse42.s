# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -instruction-tables < %s | FileCheck %s

crc32b      %al, %ecx
crc32b      (%rax), %ecx

crc32l      %eax, %ecx
crc32l      (%rax), %ecx

crc32w      %ax, %ecx
crc32w      (%rax), %ecx

crc32b      %al, %rcx
crc32b      (%rax), %rcx

crc32q      %rax, %rcx
crc32q      (%rax), %rcx

pcmpestri   $1, %xmm0, %xmm2
pcmpestri   $1, (%rax), %xmm2

pcmpestrm   $1, %xmm0, %xmm2
pcmpestrm   $1, (%rax), %xmm2

pcmpistri   $1, %xmm0, %xmm2
pcmpistri   $1, (%rax), %xmm2

pcmpistrm   $1, %xmm0, %xmm2
pcmpistrm   $1, (%rax), %xmm2

pcmpgtq     %xmm0, %xmm2
pcmpgtq     (%rax), %xmm2

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  3      2     2.00                        crc32b	%al, %ecx
# CHECK-NEXT:  3      6     2.00    *                   crc32b	(%rax), %ecx
# CHECK-NEXT:  7      6     6.00                        crc32l	%eax, %ecx
# CHECK-NEXT:  3      6     2.00    *                   crc32l	(%rax), %ecx
# CHECK-NEXT:  5      5     5.00                        crc32w	%ax, %ecx
# CHECK-NEXT:  3      6     2.00    *                   crc32w	(%rax), %ecx
# CHECK-NEXT:  3      2     2.00                        crc32b	%al, %rcx
# CHECK-NEXT:  3      6     2.00    *                   crc32b	(%rax), %rcx
# CHECK-NEXT:  11     10    8.50                        crc32q	%rax, %rcx
# CHECK-NEXT:  3      6     2.00    *                   crc32q	(%rax), %rcx
# CHECK-NEXT:  27     14    10.00                       pcmpestri	$1, %xmm0, %xmm2
# CHECK-NEXT:  28     19    11.50   *                   pcmpestri	$1, (%rax), %xmm2
# CHECK-NEXT:  27     10    10.00                       pcmpestrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  28     15    11.50   *                   pcmpestrm	$1, (%rax), %xmm2
# CHECK-NEXT:  7      11    3.00                        pcmpistri	$1, %xmm0, %xmm2
# CHECK-NEXT:  8      16    3.00    *                   pcmpistri	$1, (%rax), %xmm2
# CHECK-NEXT:  7      7     4.00                        pcmpistrm	$1, %xmm0, %xmm2
# CHECK-NEXT:  9      12    4.00    *                   pcmpistrm	$1, (%rax), %xmm2
# CHECK-NEXT:  1      2     0.50                        pcmpgtq	%xmm0, %xmm2
# CHECK-NEXT:  1      7     1.50    *                   pcmpgtq	(%rax), %xmm2

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT: 55.00  55.00   -      -      -     41.50  33.50   -     16.00  16.00  21.00  21.00   -      -      -     8.00   1.00   1.00    -     35.00  35.00   -     40.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -     2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     crc32b	%al, %ecx
# CHECK-NEXT: 1.50   1.50    -      -      -     2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -     1.50   1.50    -      -     crc32b	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -     6.00   6.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     crc32l	%eax, %ecx
# CHECK-NEXT: 1.50   1.50    -      -      -     2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -     1.50   1.50    -      -     crc32l	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -     5.00   5.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     crc32w	%ax, %ecx
# CHECK-NEXT: 1.50   1.50    -      -      -     2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -     1.50   1.50    -      -     crc32w	(%rax), %ecx
# CHECK-NEXT:  -      -      -      -      -     2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     crc32b	%al, %rcx
# CHECK-NEXT: 1.50   1.50    -      -      -     2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -     1.50   1.50    -      -     crc32b	(%rax), %rcx
# CHECK-NEXT:  -      -      -      -      -     8.50   8.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     crc32q	%rax, %rcx
# CHECK-NEXT: 1.50   1.50    -      -      -     2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -     1.50   1.50    -      -     crc32q	(%rax), %rcx
# CHECK-NEXT: 10.00  10.00   -      -      -     1.00    -      -     0.50   0.50   5.00   5.00    -      -      -     1.00    -      -      -     5.00   5.00    -     10.00  pcmpestri	$1, %xmm0, %xmm2
# CHECK-NEXT: 11.50  11.50   -      -      -     1.00    -      -     0.50   0.50   5.00   5.00    -      -      -     1.00    -      -      -     6.50   6.50    -     10.00  pcmpestri	$1, (%rax), %xmm2
# CHECK-NEXT: 10.00  10.00   -      -      -     1.00    -      -     0.50   0.50   5.00   5.00    -      -      -     1.00    -      -      -     5.00   5.00    -     10.00  pcmpestrm	$1, %xmm0, %xmm2
# CHECK-NEXT: 11.50  11.50   -      -      -     1.00    -      -     0.50   0.50   5.00   5.00    -      -      -     1.00    -      -      -     6.50   6.50    -     10.00  pcmpestrm	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     3.00   3.00    -      -      -      -      -     1.00    -      -      -      -      -      -      -     pcmpistri	$1, %xmm0, %xmm2
# CHECK-NEXT: 1.50   1.50    -      -      -     1.00    -      -     3.00   3.00    -      -      -      -      -     1.00    -      -      -     1.50   1.50    -      -     pcmpistri	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -     1.00    -      -     4.00   4.00    -      -      -      -      -     1.00    -      -      -      -      -      -      -     pcmpistrm	$1, %xmm0, %xmm2
# CHECK-NEXT: 1.50   1.50    -      -      -     1.00    -      -     4.00   4.00    -      -      -      -      -     1.00    -      -      -     1.50   1.50    -      -     pcmpistrm	$1, (%rax), %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -      -      -      -      -     pcmpgtq	%xmm0, %xmm2
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -      -      -     0.50   0.50    -      -      -      -     0.50   0.50    -     1.50   1.50    -      -     pcmpgtq	(%rax), %xmm2
