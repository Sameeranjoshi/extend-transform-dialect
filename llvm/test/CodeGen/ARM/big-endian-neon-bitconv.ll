; RUN: llc < %s -mtriple armeb-eabi -mattr v7,neon -float-abi soft -o - | FileCheck %s
; RUN: llc < %s -mtriple armeb-eabi -mattr v7,neon -float-abi hard -o - | FileCheck %s -check-prefix CHECK-HARD

@v2i64 = global <2 x i64> zeroinitializer
@v2i32 = global <2 x i32> zeroinitializer
@v4i32 = global <4 x i32> zeroinitializer
@v4i16 = global <4 x i16> zeroinitializer
@v8i16 = global <8 x i16> zeroinitializer
@v8i8 = global <8 x i8> zeroinitializer
@v16i8 = global <16 x i8> zeroinitializer

@v2f32 = global <2 x float> zeroinitializer
@v2f64 = global <2 x double> zeroinitializer
@v4f32 = global <4 x float> zeroinitializer


; 64 bit conversions
define void @conv_i64_to_v8i8( i64 %val,  ptr %store ) {
; CHECK-LABEL: conv_i64_to_v8i8:
; CHECK: vrev64.8
  %v = bitcast i64 %val to <8 x i8>
  %w = load <8 x i8>, ptr @v8i8
  %a = add <8 x i8> %v, %w
  store <8 x i8> %a, ptr %store
  ret void
}

define void @conv_v8i8_to_i64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v8i8_to_i64:
; CHECK: vrev64.8
  %v = load <8 x i8>, ptr %load
  %w = load <8 x i8>, ptr @v8i8
  %a = add <8 x i8> %v, %w
  %f = bitcast <8 x i8> %a to i64
  call void @conv_i64_to_v8i8( i64 %f, ptr %store )
  ret void
}

define void @conv_i64_to_v4i16( i64 %val,  ptr %store ) {
; CHECK-LABEL: conv_i64_to_v4i16:
; CHECK: vrev64.16
  %v = bitcast i64 %val to <4 x i16>
  %w = load <4 x i16>, ptr @v4i16
  %a = add <4 x i16> %v, %w
  store <4 x i16> %a, ptr %store
  ret void
}

define void @conv_v4i16_to_i64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v4i16_to_i64:
; CHECK: vrev64.16
  %v = load <4 x i16>, ptr %load
  %w = load <4 x i16>, ptr @v4i16
  %a = add <4 x i16> %v, %w
  %f = bitcast <4 x i16> %a to i64
  call void @conv_i64_to_v4i16( i64 %f, ptr %store )
  ret void
}

define void @conv_i64_to_v2i32( i64 %val,  ptr %store ) {
; CHECK-LABEL: conv_i64_to_v2i32:
; CHECK: vrev64.32
  %v = bitcast i64 %val to <2 x i32>
  %w = load <2 x i32>, ptr @v2i32
  %a = add <2 x i32> %v, %w
  store <2 x i32> %a, ptr %store
  ret void
}

define void @conv_v2i32_to_i64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v2i32_to_i64:
; CHECK: vrev64.32
  %v = load <2 x i32>, ptr %load
  %w = load <2 x i32>, ptr @v2i32
  %a = add <2 x i32> %v, %w
  %f = bitcast <2 x i32> %a to i64
  call void @conv_i64_to_v2i32( i64 %f, ptr %store )
  ret void
}

define void @conv_i64_to_v2f32( i64 %val,  ptr %store ) {
; CHECK-LABEL: conv_i64_to_v2f32:
; CHECK: vrev64.32
  %v = bitcast i64 %val to <2 x float>
  %w = load <2 x float>, ptr @v2f32
  %a = fadd <2 x float> %v, %w
  store <2 x float> %a, ptr %store
  ret void
}

define void @conv_v2f32_to_i64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v2f32_to_i64:
; CHECK: vrev64.32
  %v = load <2 x float>, ptr %load
  %w = load <2 x float>, ptr @v2f32
  %a = fadd <2 x float> %v, %w
  %f = bitcast <2 x float> %a to i64
  call void @conv_i64_to_v2f32( i64 %f, ptr %store )
  ret void
}

define void @conv_f64_to_v8i8( double %val,  ptr %store ) {
; CHECK-LABEL: conv_f64_to_v8i8:
; CHECK: vrev64.8
  %v = bitcast double %val to <8 x i8>
  %w = load <8 x i8>, ptr @v8i8
  %a = add <8 x i8> %v, %w
  store <8 x i8> %a, ptr %store
  ret void
}

define void @conv_v8i8_to_f64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v8i8_to_f64:
; CHECK: vrev64.8
  %v = load <8 x i8>, ptr %load
  %w = load <8 x i8>, ptr @v8i8
  %a = add <8 x i8> %v, %w
  %f = bitcast <8 x i8> %a to double
  call void @conv_f64_to_v8i8( double %f, ptr %store )
  ret void
}

define void @conv_f64_to_v4i16( double %val,  ptr %store ) {
; CHECK-LABEL: conv_f64_to_v4i16:
; CHECK: vrev64.16
  %v = bitcast double %val to <4 x i16>
  %w = load <4 x i16>, ptr @v4i16
  %a = add <4 x i16> %v, %w
  store <4 x i16> %a, ptr %store
  ret void
}

define void @conv_v4i16_to_f64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v4i16_to_f64:
; CHECK: vrev64.16
  %v = load <4 x i16>, ptr %load
  %w = load <4 x i16>, ptr @v4i16
  %a = add <4 x i16> %v, %w
  %f = bitcast <4 x i16> %a to double
  call void @conv_f64_to_v4i16( double %f, ptr %store )
  ret void
}

define void @conv_f64_to_v2i32( double %val,  ptr %store ) {
; CHECK-LABEL: conv_f64_to_v2i32:
; CHECK: vrev64.32
  %v = bitcast double %val to <2 x i32>
  %w = load <2 x i32>, ptr @v2i32
  %a = add <2 x i32> %v, %w
  store <2 x i32> %a, ptr %store
  ret void
}

define void @conv_v2i32_to_f64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v2i32_to_f64:
; CHECK: vrev64.32
  %v = load <2 x i32>, ptr %load
  %w = load <2 x i32>, ptr @v2i32
  %a = add <2 x i32> %v, %w
  %f = bitcast <2 x i32> %a to double
  call void @conv_f64_to_v2i32( double %f, ptr %store )
  ret void
}

define void @conv_f64_to_v2f32( double %val,  ptr %store ) {
; CHECK-LABEL: conv_f64_to_v2f32:
; CHECK: vrev64.32
  %v = bitcast double %val to <2 x float>
  %w = load <2 x float>, ptr @v2f32
  %a = fadd <2 x float> %v, %w
  store <2 x float> %a, ptr %store
  ret void
}

define void @conv_v2f32_to_f64( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v2f32_to_f64:
; CHECK: vrev64.32
  %v = load <2 x float>, ptr %load
  %w = load <2 x float>, ptr @v2f32
  %a = fadd <2 x float> %v, %w
  %f = bitcast <2 x float> %a to double
  call void @conv_f64_to_v2f32( double %f, ptr %store )
  ret void
}

; 128 bit conversions


define void @conv_i128_to_v16i8( i128 %val,  ptr %store ) {
; CHECK-LABEL: conv_i128_to_v16i8:
; CHECK: vrev32.8
  %v = bitcast i128 %val to <16 x i8>
  %w = load  <16 x i8>,  ptr @v16i8
  %a = add <16 x i8> %v, %w
  store <16 x i8> %a, ptr %store
  ret void
}

define void @conv_v16i8_to_i128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v16i8_to_i128:
; CHECK: vrev32.8
  %v = load <16 x i8>, ptr %load
  %w = load <16 x i8>, ptr @v16i8
  %a = add <16 x i8> %v, %w
  %f = bitcast <16 x i8> %a to i128
  call void @conv_i128_to_v16i8( i128 %f, ptr %store )
  ret void
}

define void @conv_i128_to_v8i16( i128 %val,  ptr %store ) {
; CHECK-LABEL: conv_i128_to_v8i16:
; CHECK: vrev32.16
  %v = bitcast i128 %val to <8 x i16>
  %w = load  <8 x i16>,  ptr @v8i16
  %a = add <8 x i16> %v, %w
  store <8 x i16> %a, ptr %store
  ret void
}

define void @conv_v8i16_to_i128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v8i16_to_i128:
; CHECK: vrev32.16
  %v = load <8 x i16>, ptr %load
  %w = load <8 x i16>, ptr @v8i16
  %a = add <8 x i16> %v, %w
  %f = bitcast <8 x i16> %a to i128
  call void @conv_i128_to_v8i16( i128 %f, ptr %store )
  ret void
}

define void @conv_i128_to_v4i32( i128 %val,  ptr %store ) {
; CHECK-LABEL: conv_i128_to_v4i32:
; CHECK: vrev64.32
  %v = bitcast i128 %val to <4 x i32>
  %w = load <4 x i32>, ptr @v4i32
  %a = add <4 x i32> %v, %w
  store <4 x i32> %a, ptr %store
  ret void
}

define void @conv_v4i32_to_i128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v4i32_to_i128:
; CHECK: vrev64.32
  %v = load <4 x i32>, ptr %load
  %w = load <4 x i32>, ptr @v4i32
  %a = add <4 x i32> %v, %w
  %f = bitcast <4 x i32> %a to i128
  call void @conv_i128_to_v4i32( i128 %f, ptr %store )
  ret void
}

define void @conv_i128_to_v4f32( i128 %val,  ptr %store ) {
; CHECK-LABEL: conv_i128_to_v4f32:
; CHECK: vrev64.32
  %v = bitcast i128 %val to <4 x float>
  %w = load <4 x float>, ptr @v4f32
  %a = fadd <4 x float> %v, %w
  store <4 x float> %a, ptr %store
  ret void
}

define void @conv_v4f32_to_i128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v4f32_to_i128:
; CHECK: vrev64.32
  %v = load <4 x float>, ptr %load
  %w = load <4 x float>, ptr @v4f32
  %a = fadd <4 x float> %v, %w
  %f = bitcast <4 x float> %a to i128
  call void @conv_i128_to_v4f32( i128 %f, ptr %store )
  ret void
}

define void @conv_f128_to_v2f64( fp128 %val,  ptr %store ) {
; CHECK-LABEL: conv_f128_to_v2f64:
; CHECK: vrev64.32
  %v = bitcast fp128 %val to <2 x double>
  %w = load <2 x double>, ptr @v2f64
  %a = fadd <2 x double> %v, %w
  store <2 x double> %a, ptr %store
  ret void
}

define void @conv_v2f64_to_f128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v2f64_to_f128:
; CHECK: vrev64.32
  %v = load <2 x double>, ptr %load
  %w = load <2 x double>, ptr @v2f64
  %a = fadd <2 x double> %v, %w
  %f = bitcast <2 x double> %a to fp128
  call void @conv_f128_to_v2f64( fp128 %f, ptr %store )
  ret void
}

define void @conv_f128_to_v16i8( fp128 %val,  ptr %store ) {
; CHECK-LABEL: conv_f128_to_v16i8:
; CHECK: vrev32.8
  %v = bitcast fp128 %val to <16 x i8>
  %w = load  <16 x i8>,  ptr @v16i8
  %a = add <16 x i8> %v, %w
  store <16 x i8> %a, ptr %store
  ret void
}

define void @conv_v16i8_to_f128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v16i8_to_f128:
; CHECK: vrev32.8
  %v = load <16 x i8>, ptr %load
  %w = load <16 x i8>, ptr @v16i8
  %a = add <16 x i8> %v, %w
  %f = bitcast <16 x i8> %a to fp128
  call void @conv_f128_to_v16i8( fp128 %f, ptr %store )
  ret void
}

define void @conv_f128_to_v8i16( fp128 %val,  ptr %store ) {
; CHECK-LABEL: conv_f128_to_v8i16:
; CHECK: vrev32.16
  %v = bitcast fp128 %val to <8 x i16>
  %w = load  <8 x i16>,  ptr @v8i16
  %a = add <8 x i16> %v, %w
  store <8 x i16> %a, ptr %store
  ret void
}

define void @conv_v8i16_to_f128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v8i16_to_f128:
; CHECK: vrev32.16
  %v = load <8 x i16>, ptr %load
  %w = load <8 x i16>, ptr @v8i16
  %a = add <8 x i16> %v, %w
  %f = bitcast <8 x i16> %a to fp128
  call void @conv_f128_to_v8i16( fp128 %f, ptr %store )
  ret void
}

define void @conv_f128_to_v4f32( fp128 %val,  ptr %store ) {
; CHECK-LABEL: conv_f128_to_v4f32:
; CHECK: vrev64.32
  %v = bitcast fp128 %val to <4 x float>
  %w = load <4 x float>, ptr @v4f32
  %a = fadd <4 x float> %v, %w
  store <4 x float> %a, ptr %store
  ret void
}

define void @conv_v4f32_to_f128( ptr %load, ptr %store ) {
; CHECK-LABEL: conv_v4f32_to_f128:
; CHECK: vrev64.32
  %v = load <4 x float>, ptr %load
  %w = load <4 x float>, ptr @v4f32
  %a = fadd <4 x float> %v, %w
  %f = bitcast <4 x float> %a to fp128
  call void @conv_f128_to_v4f32( fp128 %f, ptr %store )
  ret void
}

define void @arg_v4i32( <4 x i32> %var, ptr %store ) {
; CHECK-LABEL: arg_v4i32:
; CHECK: vmov   [[REG2:d[0-9]+]], r3, r2
; CHECK: vmov   [[REG1:d[0-9]+]], r1, r0
; CHECK: vst1.64 {[[REG1]], [[REG2]]},
; CHECK-HARD-LABEL: arg_v4i32:
; CHECK-HARD-NOT: vmov
; CHECK-HARD: vst1.64 {d0, d1}
  store <4 x i32> %var, ptr %store
  ret void
}

define void @arg_v8i16( <8 x i16> %var, ptr %store ) {
; CHECK-LABEL: arg_v8i16:
; CHECK: vmov   [[REG2:d[0-9]+]], r3, r2
; CHECK: vmov   [[REG1:d[0-9]+]], r1, r0
; CHECK: vst1.64 {[[REG1]], [[REG2]]},
; CHECK-HARD-LABEL: arg_v8i16:
; CHECK-HARD-NOT: vmov
; CHECK-HARD: vst1.64 {d0, d1}
  store <8 x i16> %var, ptr %store
  ret void
}

define void @arg_v16i8( <16 x i8> %var, ptr %store ) {
; CHECK-LABEL: arg_v16i8:
; CHECK: vmov   [[REG2:d[0-9]+]], r3, r2
; CHECK: vmov   [[REG1:d[0-9]+]], r1, r0
; CHECK: vst1.64 {[[REG1]], [[REG2]]},
; CHECK-HARD-LABEL: arg_v16i8:
; CHECK-HARD-NOT: vmov
; CHECK-HARD: vst1.64 {d0, d1}
  store <16 x i8> %var, ptr %store
  ret void
}

