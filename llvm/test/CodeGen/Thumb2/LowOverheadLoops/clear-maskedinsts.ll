; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=thumbv8.1m.main -mattr=+mve.fp -mve-tail-predication -tail-predication=enabled %s -S -o - | FileCheck %s

define hidden i32 @_Z4loopPiPjiS0_i(ptr noalias nocapture readonly %s1, ptr noalias nocapture readonly %s2, i32 %x, ptr noalias nocapture %d, i32 %n) {
; CHECK-LABEL: @_Z4loopPiPjiS0_i(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP63:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP63]], label [[FOR_BODY_LR_PH:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.body.lr.ph:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[N_RND_UP77:%.*]] = add nuw i32 [[N]], 3
; CHECK-NEXT:    [[N_VEC79:%.*]] = and i32 [[N_RND_UP77]], -4
; CHECK-NEXT:    [[TRIP_COUNT_MINUS_183:%.*]] = add nsw i32 [[N]], -1
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[N_VEC79]], -4
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[TMP0]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i32 [[TMP1]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw i32 [[TMP1]], 1
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[VECTOR_BODY75_PREHEADER:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.body75.preheader:
; CHECK-NEXT:    [[START1:%.*]] = call i32 @llvm.start.loop.iterations.i32(i32 [[TMP2]])
; CHECK-NEXT:    br label [[VECTOR_BODY75:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT71:%.*]] = insertelement <4 x i32> undef, i32 [[X]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT72:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT71]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[START2:%.*]] = call i32 @llvm.start.loop.iterations.i32(i32 [[TMP3]])
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[LSR_IV9:%.*]] = phi ptr [ [[SCEVGEP10:%.*]], [[VECTOR_BODY]] ], [ [[D:%.*]], [[VECTOR_PH]] ]
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = phi i32 [ [[START2]], [[VECTOR_PH]] ], [ [[TMP10:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = phi i32 [ [[N]], [[VECTOR_PH]] ], [ [[TMP9:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> undef, i32 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <4 x i32> [[BROADCAST_SPLAT]], <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <4 x i32> undef, i32 [[TRIP_COUNT_MINUS_183]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <4 x i32> [[TMP6]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = call <4 x i1> @llvm.arm.mve.vctp32(i32 [[TMP5]])
; CHECK-NEXT:    [[TMP9]] = sub i32 [[TMP5]], 4
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0(<4 x i32> [[BROADCAST_SPLAT72]], ptr [[LSR_IV9]], i32 4, <4 x i1> [[TMP8]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[SCEVGEP10]] = getelementptr i32, ptr [[LSR_IV9]], i32 4
; CHECK-NEXT:    [[TMP10]] = call i32 @llvm.loop.decrement.reg.i32(i32 [[TMP4]], i32 1)
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ne i32 [[TMP10]], 0
; CHECK-NEXT:    br i1 [[TMP11]], label [[VECTOR_BODY]], label [[FOR_COND_CLEANUP]]
; CHECK:       vector.body75:
; CHECK-NEXT:    [[LSR_IV6:%.*]] = phi ptr [ [[S1:%.*]], [[VECTOR_BODY75_PREHEADER]] ], [ [[SCEVGEP7:%.*]], [[VECTOR_BODY75]] ]
; CHECK-NEXT:    [[LSR_IV3:%.*]] = phi ptr [ [[S2:%.*]], [[VECTOR_BODY75_PREHEADER]] ], [ [[SCEVGEP4:%.*]], [[VECTOR_BODY75]] ]
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi ptr [ [[D]], [[VECTOR_BODY75_PREHEADER]] ], [ [[SCEVGEP:%.*]], [[VECTOR_BODY75]] ]
; CHECK-NEXT:    [[INDEX80:%.*]] = phi i32 [ [[INDEX_NEXT81:%.*]], [[VECTOR_BODY75]] ], [ 0, [[VECTOR_BODY75_PREHEADER]] ]
; CHECK-NEXT:    [[TMP12:%.*]] = phi i32 [ [[START1]], [[VECTOR_BODY75_PREHEADER]] ], [ [[TMP17:%.*]], [[VECTOR_BODY75]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT84:%.*]] = insertelement <4 x i32> undef, i32 [[INDEX80]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT85:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT84]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION86:%.*]] = add <4 x i32> [[BROADCAST_SPLAT85]], <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP13:%.*]] = insertelement <4 x i32> undef, i32 [[TRIP_COUNT_MINUS_183]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x i32> [[TMP13]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = icmp ule <4 x i32> [[INDUCTION86]], [[TMP14]]
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr [[LSR_IV6]], i32 4, <4 x i1> [[TMP15]], <4 x i32> undef)
; CHECK-NEXT:    [[WIDE_MASKED_LOAD89:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr [[LSR_IV3]], i32 4, <4 x i1> [[TMP15]], <4 x i32> undef)
; CHECK-NEXT:    [[TMP16:%.*]] = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> [[WIDE_MASKED_LOAD89]], <4 x i32> [[WIDE_MASKED_LOAD]])
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0(<4 x i32> [[TMP16]], ptr [[LSR_IV]], i32 4, <4 x i1> [[TMP15]])
; CHECK-NEXT:    [[INDEX_NEXT81]] = add i32 [[INDEX80]], 4
; CHECK-NEXT:    [[SCEVGEP]] = getelementptr i32, ptr [[LSR_IV]], i32 4
; CHECK-NEXT:    [[SCEVGEP4]] = getelementptr i32, ptr [[LSR_IV3]], i32 4
; CHECK-NEXT:    [[SCEVGEP7]] = getelementptr i32, ptr [[LSR_IV6]], i32 4
; CHECK-NEXT:    [[TMP17]] = call i32 @llvm.loop.decrement.reg.i32(i32 [[TMP12]], i32 1)
; CHECK-NEXT:    [[TMP18:%.*]] = icmp ne i32 [[TMP17]], 0
; CHECK-NEXT:    br i1 [[TMP18]], label [[VECTOR_BODY75]], label [[FOR_COND_CLEANUP]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret i32 0
;
entry:
  %cmp63 = icmp sgt i32 %n, 0
  br i1 %cmp63, label %for.body.lr.ph, label %for.cond.cleanup

for.body.lr.ph:                                   ; preds = %entry
  %tobool = icmp eq i32 %x, 0
  %n.rnd.up77 = add nuw i32 %n, 3
  %n.vec79 = and i32 %n.rnd.up77, -4
  %trip.count.minus.183 = add nsw i32 %n, -1
  %0 = add i32 %n.vec79, -4
  %1 = lshr i32 %0, 2
  %2 = add nuw nsw i32 %1, 1
  %3 = add nuw nsw i32 %1, 1
  br i1 %tobool, label %vector.body75.preheader, label %vector.ph

vector.body75.preheader:                          ; preds = %for.body.lr.ph
  %start1 = call i32 @llvm.start.loop.iterations.i32(i32 %2)
  br label %vector.body75

vector.ph:                                        ; preds = %for.body.lr.ph
  %broadcast.splatinsert71 = insertelement <4 x i32> undef, i32 %x, i32 0
  %broadcast.splat72 = shufflevector <4 x i32> %broadcast.splatinsert71, <4 x i32> undef, <4 x i32> zeroinitializer
  %start2 = call i32 @llvm.start.loop.iterations.i32(i32 %3)
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %lsr.iv9 = phi ptr [ %scevgep10, %vector.body ], [ %d, %vector.ph ]
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %4 = phi i32 [ %start2, %vector.ph ], [ %8, %vector.body ]
  %broadcast.splatinsert = insertelement <4 x i32> undef, i32 %index, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction = add <4 x i32> %broadcast.splat, <i32 0, i32 1, i32 2, i32 3>
  %5 = insertelement <4 x i32> undef, i32 %trip.count.minus.183, i32 0
  %6 = shufflevector <4 x i32> %5, <4 x i32> undef, <4 x i32> zeroinitializer
  %7 = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 %index, i32 %n)
  call void @llvm.masked.store.v4i32.p0(<4 x i32> %broadcast.splat72, ptr %lsr.iv9, i32 4, <4 x i1> %7)
  %index.next = add i32 %index, 4
  %scevgep10 = getelementptr i32, ptr %lsr.iv9, i32 4
  %8 = call i32 @llvm.loop.decrement.reg.i32(i32 %4, i32 1)
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %vector.body, label %for.cond.cleanup

vector.body75:                                    ; preds = %vector.body75, %vector.body75.preheader
  %lsr.iv6 = phi ptr [ %s1, %vector.body75.preheader ], [ %scevgep7, %vector.body75 ]
  %lsr.iv3 = phi ptr [ %s2, %vector.body75.preheader ], [ %scevgep4, %vector.body75 ]
  %lsr.iv = phi ptr [ %d, %vector.body75.preheader ], [ %scevgep, %vector.body75 ]
  %index80 = phi i32 [ %index.next81, %vector.body75 ], [ 0, %vector.body75.preheader ]
  %10 = phi i32 [ %start1, %vector.body75.preheader ], [ %15, %vector.body75 ]
  %broadcast.splatinsert84 = insertelement <4 x i32> undef, i32 %index80, i32 0
  %broadcast.splat85 = shufflevector <4 x i32> %broadcast.splatinsert84, <4 x i32> undef, <4 x i32> zeroinitializer
  %induction86 = add <4 x i32> %broadcast.splat85, <i32 0, i32 1, i32 2, i32 3>
  %11 = insertelement <4 x i32> undef, i32 %trip.count.minus.183, i32 0
  %12 = shufflevector <4 x i32> %11, <4 x i32> undef, <4 x i32> zeroinitializer
  %13 = icmp ule <4 x i32> %induction86, %12
  %wide.masked.load = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %lsr.iv6, i32 4, <4 x i1> %13, <4 x i32> undef)
  %wide.masked.load89 = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr %lsr.iv3, i32 4, <4 x i1> %13, <4 x i32> undef)
  %14 = call <4 x i32> @llvm.usub.sat.v4i32(<4 x i32> %wide.masked.load89, <4 x i32> %wide.masked.load)
  call void @llvm.masked.store.v4i32.p0(<4 x i32> %14, ptr %lsr.iv, i32 4, <4 x i1> %13)
  %index.next81 = add i32 %index80, 4
  %scevgep = getelementptr i32, ptr %lsr.iv, i32 4
  %scevgep4 = getelementptr i32, ptr %lsr.iv3, i32 4
  %scevgep7 = getelementptr i32, ptr %lsr.iv6, i32 4
  %15 = call i32 @llvm.loop.decrement.reg.i32(i32 %10, i32 1)
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %vector.body75, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %vector.body, %vector.body75, %entry
  ret i32 0
}
declare void @llvm.masked.store.v4i32.p0(<4 x i32>, ptr, i32 immarg, <4 x i1>)
declare <4 x i32> @llvm.masked.load.v4i32.p0(ptr, i32 immarg, <4 x i1>, <4 x i32>)
declare <4 x i32> @llvm.usub.sat.v4i32(<4 x i32>, <4 x i32>)
declare i32 @llvm.start.loop.iterations.i32(i32)
declare i32 @llvm.loop.decrement.reg.i32(i32, i32)

declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <8 x i1> @llvm.get.active.lane.mask.v8i1.i32(i32, i32)
declare <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32, i32)
