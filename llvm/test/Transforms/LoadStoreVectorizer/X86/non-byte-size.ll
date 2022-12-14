; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=load-store-vectorizer -S -mtriple=x86_64-unknown-linux-gnu | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa -passes='function(load-store-vectorizer)' -S -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

%rec = type { i32, i28 }

; We currently do not optimize this scenario.
; But we verify that we no longer crash when compiling this.
define void @test1(%rec* %out, %rec* %in) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[IN1:%.*]] = getelementptr [[REC:%.*]], %rec* [[IN:%.*]], i16 0, i32 0
; CHECK-NEXT:    [[IN2:%.*]] = getelementptr [[REC]], %rec* [[IN]], i16 0, i32 1
; CHECK-NEXT:    [[VAL1:%.*]] = load i32, i32* [[IN1]], align 8
; CHECK-NEXT:    [[VAL2:%.*]] = load i28, i28* [[IN2]]
; CHECK-NEXT:    [[OUT1:%.*]] = getelementptr [[REC]], %rec* [[OUT:%.*]], i16 0, i32 0
; CHECK-NEXT:    [[OUT2:%.*]] = getelementptr [[REC]], %rec* [[OUT]], i16 0, i32 1
; CHECK-NEXT:    store i32 [[VAL1]], i32* [[OUT1]], align 8
; CHECK-NEXT:    store i28 [[VAL2]], i28* [[OUT2]]
; CHECK-NEXT:    ret void
;
  %in1 = getelementptr %rec, %rec* %in, i16 0, i32 0
  %in2 = getelementptr %rec, %rec* %in, i16 0, i32 1
  %val1 = load i32, i32* %in1, align 8
  %val2 = load i28, i28* %in2
  %out1 = getelementptr %rec, %rec* %out, i16 0, i32 0
  %out2 = getelementptr %rec, %rec* %out, i16 0, i32 1
  store i32 %val1, i32* %out1, align 8
  store i28 %val2, i28* %out2
  ret void
}

