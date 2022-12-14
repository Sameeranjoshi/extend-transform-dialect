; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='function(loop-unroll)' -unroll-count=8 -S %s | FileCheck %s

; Make sure non-SCEVable types are handled properly when invalidating SCEV
; dispositions.
define void @test(i32 %shift, ptr %dst, <8 x i32> %broadcast.splat) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc <8 x i32> [[BROADCAST_SPLAT:%.*]] to <8 x i16>
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST:%.*]], align 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[SHIFT:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[OUTER_HEADER_1:%.*]], label [[EXIT:%.*]]
; CHECK:       outer.header.1:
; CHECK-NEXT:    br label [[INNER_1:%.*]]
; CHECK:       inner.1:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST]], align 2
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp eq i32 [[SHIFT]], 0
; CHECK-NEXT:    br i1 [[CMP_1]], label [[OUTER_HEADER_2:%.*]], label [[EXIT]]
; CHECK:       outer.header.2:
; CHECK-NEXT:    br label [[INNER_2:%.*]]
; CHECK:       inner.2:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST]], align 2
; CHECK-NEXT:    [[CMP_2:%.*]] = icmp eq i32 [[SHIFT]], 0
; CHECK-NEXT:    br i1 [[CMP_2]], label [[OUTER_HEADER_3:%.*]], label [[EXIT]]
; CHECK:       outer.header.3:
; CHECK-NEXT:    br label [[INNER_3:%.*]]
; CHECK:       inner.3:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST]], align 2
; CHECK-NEXT:    [[CMP_3:%.*]] = icmp eq i32 [[SHIFT]], 0
; CHECK-NEXT:    br i1 [[CMP_3]], label [[OUTER_HEADER_4:%.*]], label [[EXIT]]
; CHECK:       outer.header.4:
; CHECK-NEXT:    br label [[INNER_4:%.*]]
; CHECK:       inner.4:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST]], align 2
; CHECK-NEXT:    [[CMP_4:%.*]] = icmp eq i32 [[SHIFT]], 0
; CHECK-NEXT:    br i1 [[CMP_4]], label [[OUTER_HEADER_5:%.*]], label [[EXIT]]
; CHECK:       outer.header.5:
; CHECK-NEXT:    br label [[INNER_5:%.*]]
; CHECK:       inner.5:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST]], align 2
; CHECK-NEXT:    [[CMP_5:%.*]] = icmp eq i32 [[SHIFT]], 0
; CHECK-NEXT:    br i1 [[CMP_5]], label [[OUTER_HEADER_6:%.*]], label [[EXIT]]
; CHECK:       outer.header.6:
; CHECK-NEXT:    br label [[INNER_6:%.*]]
; CHECK:       inner.6:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST]], align 2
; CHECK-NEXT:    [[CMP_6:%.*]] = icmp eq i32 [[SHIFT]], 0
; CHECK-NEXT:    br i1 [[CMP_6]], label [[OUTER_HEADER_7:%.*]], label [[EXIT]]
; CHECK:       outer.header.7:
; CHECK-NEXT:    br label [[INNER_7:%.*]]
; CHECK:       inner.7:
; CHECK-NEXT:    store <8 x i16> [[TMP0]], ptr [[DST]], align 2
; CHECK-NEXT:    [[CMP_7:%.*]] = icmp eq i32 [[SHIFT]], 0
; CHECK-NEXT:    br i1 [[CMP_7]], label [[OUTER_HEADER]], label [[EXIT]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %outer.header

outer.header:
  br label %inner

inner:
  %0 = trunc <8 x i32> %broadcast.splat to <8 x i16>
  store <8 x i16> %0, ptr %dst, align 2
  br i1 true, label %outer.latch, label %inner

outer.latch:
  %cmp = icmp eq i32 %shift, 0
  br i1 %cmp, label %outer.header, label %exit

exit:
  ret void
}
