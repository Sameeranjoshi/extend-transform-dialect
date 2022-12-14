// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2 < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:        | llvm-objdump -d --mattr=+sve2 - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sve2 < %s \
// RUN:   | llvm-objdump -d --mattr=-sve2 - | FileCheck %s --check-prefix=CHECK-UNKNOWN

stnt1b z0.s, p0, [z1.s]
// CHECK-INST: stnt1b { z0.s }, p0, [z1.s]
// CHECK-ENCODING: [0x20,0x20,0x5f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e45f2020 <unknown>

stnt1b z31.s, p7, [z31.s, xzr]
// CHECK-INST: stnt1b { z31.s }, p7, [z31.s]
// CHECK-ENCODING: [0xff,0x3f,0x5f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e45f3fff <unknown>

stnt1b z31.s, p7, [z31.s, x0]
// CHECK-INST: stnt1b { z31.s }, p7, [z31.s, x0]
// CHECK-ENCODING: [0xff,0x3f,0x40,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e4403fff <unknown>

stnt1b z0.d, p0, [z1.d]
// CHECK-INST: stnt1b { z0.d }, p0, [z1.d]
// CHECK-ENCODING: [0x20,0x20,0x1f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e41f2020 <unknown>

stnt1b z31.d, p7, [z31.d, xzr]
// CHECK-INST: stnt1b { z31.d }, p7, [z31.d]
// CHECK-ENCODING: [0xff,0x3f,0x1f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e41f3fff <unknown>

stnt1b z31.d, p7, [z31.d, x0]
// CHECK-INST: stnt1b { z31.d }, p7, [z31.d, x0]
// CHECK-ENCODING: [0xff,0x3f,0x00,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e4003fff <unknown>

stnt1b { z0.s }, p0, [z1.s]
// CHECK-INST: stnt1b { z0.s }, p0, [z1.s]
// CHECK-ENCODING: [0x20,0x20,0x5f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e45f2020 <unknown>

stnt1b { z31.s }, p7, [z31.s, xzr]
// CHECK-INST: stnt1b { z31.s }, p7, [z31.s]
// CHECK-ENCODING: [0xff,0x3f,0x5f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e45f3fff <unknown>

stnt1b { z31.s }, p7, [z31.s, x0]
// CHECK-INST: stnt1b { z31.s }, p7, [z31.s, x0]
// CHECK-ENCODING: [0xff,0x3f,0x40,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e4403fff <unknown>

stnt1b { z0.d }, p0, [z1.d]
// CHECK-INST: stnt1b { z0.d }, p0, [z1.d]
// CHECK-ENCODING: [0x20,0x20,0x1f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e41f2020 <unknown>

stnt1b { z31.d }, p7, [z31.d, xzr]
// CHECK-INST: stnt1b { z31.d }, p7, [z31.d]
// CHECK-ENCODING: [0xff,0x3f,0x1f,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e41f3fff <unknown>

stnt1b { z31.d }, p7, [z31.d, x0]
// CHECK-INST: stnt1b { z31.d }, p7, [z31.d, x0]
// CHECK-ENCODING: [0xff,0x3f,0x00,0xe4]
// CHECK-ERROR: instruction requires: sve2
// CHECK-UNKNOWN: e4003fff <unknown>
