// RUN: llvm-mc -triple i686-unknown-unknown -x86-asm-syntax=intel -output-asm-variant=1 --show-encoding %s | FileCheck %s

// CHECK:      aadd dword ptr [esp + 8*esi + 268435456], ebx
// CHECK: encoding: [0x0f,0x38,0xfc,0x9c,0xf4,0x00,0x00,0x00,0x10]
               aadd dword ptr [esp + 8*esi + 268435456], ebx

// CHECK:      aadd dword ptr [edi + 4*eax + 291], ebx
// CHECK: encoding: [0x0f,0x38,0xfc,0x9c,0x87,0x23,0x01,0x00,0x00]
               aadd dword ptr [edi + 4*eax + 291], ebx

// CHECK:      aadd dword ptr [eax], ebx
// CHECK: encoding: [0x0f,0x38,0xfc,0x18]
               aadd dword ptr [eax], ebx

// CHECK:      aadd dword ptr [2*ebp - 512], ebx
// CHECK: encoding: [0x0f,0x38,0xfc,0x1c,0x6d,0x00,0xfe,0xff,0xff]
               aadd dword ptr [2*ebp - 512], ebx

// CHECK:      aadd dword ptr [ecx + 2032], ebx
// CHECK: encoding: [0x0f,0x38,0xfc,0x99,0xf0,0x07,0x00,0x00]
               aadd dword ptr [ecx + 2032], ebx

// CHECK:      aadd dword ptr [edx - 2048], ebx
// CHECK: encoding: [0x0f,0x38,0xfc,0x9a,0x00,0xf8,0xff,0xff]
               aadd dword ptr [edx - 2048], ebx

// CHECK:      aand dword ptr [esp + 8*esi + 268435456], ebx
// CHECK: encoding: [0x66,0x0f,0x38,0xfc,0x9c,0xf4,0x00,0x00,0x00,0x10]
               aand dword ptr [esp + 8*esi + 268435456], ebx

// CHECK:      aand dword ptr [edi + 4*eax + 291], ebx
// CHECK: encoding: [0x66,0x0f,0x38,0xfc,0x9c,0x87,0x23,0x01,0x00,0x00]
               aand dword ptr [edi + 4*eax + 291], ebx

// CHECK:      aand dword ptr [eax], ebx
// CHECK: encoding: [0x66,0x0f,0x38,0xfc,0x18]
               aand dword ptr [eax], ebx

// CHECK:      aand dword ptr [2*ebp - 512], ebx
// CHECK: encoding: [0x66,0x0f,0x38,0xfc,0x1c,0x6d,0x00,0xfe,0xff,0xff]
               aand dword ptr [2*ebp - 512], ebx

// CHECK:      aand dword ptr [ecx + 2032], ebx
// CHECK: encoding: [0x66,0x0f,0x38,0xfc,0x99,0xf0,0x07,0x00,0x00]
               aand dword ptr [ecx + 2032], ebx

// CHECK:      aand dword ptr [edx - 2048], ebx
// CHECK: encoding: [0x66,0x0f,0x38,0xfc,0x9a,0x00,0xf8,0xff,0xff]
               aand dword ptr [edx - 2048], ebx

// CHECK:      aor dword ptr [esp + 8*esi + 268435456], ebx
// CHECK: encoding: [0xf2,0x0f,0x38,0xfc,0x9c,0xf4,0x00,0x00,0x00,0x10]
               aor dword ptr [esp + 8*esi + 268435456], ebx

// CHECK:      aor dword ptr [edi + 4*eax + 291], ebx
// CHECK: encoding: [0xf2,0x0f,0x38,0xfc,0x9c,0x87,0x23,0x01,0x00,0x00]
               aor dword ptr [edi + 4*eax + 291], ebx

// CHECK:      aor dword ptr [eax], ebx
// CHECK: encoding: [0xf2,0x0f,0x38,0xfc,0x18]
               aor dword ptr [eax], ebx

// CHECK:      aor dword ptr [2*ebp - 512], ebx
// CHECK: encoding: [0xf2,0x0f,0x38,0xfc,0x1c,0x6d,0x00,0xfe,0xff,0xff]
               aor dword ptr [2*ebp - 512], ebx

// CHECK:      aor dword ptr [ecx + 2032], ebx
// CHECK: encoding: [0xf2,0x0f,0x38,0xfc,0x99,0xf0,0x07,0x00,0x00]
               aor dword ptr [ecx + 2032], ebx

// CHECK:      aor dword ptr [edx - 2048], ebx
// CHECK: encoding: [0xf2,0x0f,0x38,0xfc,0x9a,0x00,0xf8,0xff,0xff]
               aor dword ptr [edx - 2048], ebx

// CHECK:      axor dword ptr [esp + 8*esi + 268435456], ebx
// CHECK: encoding: [0xf3,0x0f,0x38,0xfc,0x9c,0xf4,0x00,0x00,0x00,0x10]
               axor dword ptr [esp + 8*esi + 268435456], ebx

// CHECK:      axor dword ptr [edi + 4*eax + 291], ebx
// CHECK: encoding: [0xf3,0x0f,0x38,0xfc,0x9c,0x87,0x23,0x01,0x00,0x00]
               axor dword ptr [edi + 4*eax + 291], ebx

// CHECK:      axor dword ptr [eax], ebx
// CHECK: encoding: [0xf3,0x0f,0x38,0xfc,0x18]
               axor dword ptr [eax], ebx

// CHECK:      axor dword ptr [2*ebp - 512], ebx
// CHECK: encoding: [0xf3,0x0f,0x38,0xfc,0x1c,0x6d,0x00,0xfe,0xff,0xff]
               axor dword ptr [2*ebp - 512], ebx

// CHECK:      axor dword ptr [ecx + 2032], ebx
// CHECK: encoding: [0xf3,0x0f,0x38,0xfc,0x99,0xf0,0x07,0x00,0x00]
               axor dword ptr [ecx + 2032], ebx

// CHECK:      axor dword ptr [edx - 2048], ebx
// CHECK: encoding: [0xf3,0x0f,0x38,0xfc,0x9a,0x00,0xf8,0xff,0xff]
               axor dword ptr [edx - 2048], ebx
