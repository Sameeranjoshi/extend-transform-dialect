// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sme2 2>&1 < %s | FileCheck %s

// --------------------------------------------------------------------------//
// Invalid tile

bmopa za8.s, p0/m, p0/m, z0.s, z0.s
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid operand for instruction
// CHECK-NEXT: bmopa za8.s, p0/m, p0/m, z0.s, z0.s
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

// --------------------------------------------------------------------------//
// Invalid predicate

bmopa za0.s, p0/z, p0/m, z0.s, z0.s
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid operand for instruction
// CHECK-NEXT: bmopa za0.s, p0/z, p0/m, z0.s, z0.s
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

bmopa za0.s, p15/m, p0/m, z0.s, z0.s
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid restricted predicate register, expected p0..p7 (without element suffix)
// CHECK-NEXT: bmopa za0.s, p15/m, p0/m, z0.s, z0.s
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

// --------------------------------------------------------------------------//
// Invalid suffixes

bmopa za0.d, p0/z, p0/m, z0.d, z0.d
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid matrix operand, expected za[0-3].s
// CHECK-NEXT: bmopa za0.d, p0/z, p0/m, z0.d, z0.d
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

bmopa za0.s, p0/m, p0/m, z0.s, z0.d
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: za0.s, p0/m, p0/m, z0.s, z0.d
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
