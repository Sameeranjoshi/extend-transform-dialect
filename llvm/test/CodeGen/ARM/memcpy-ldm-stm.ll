; RUN: llc -mtriple=thumbv6m-eabi -verify-machineinstrs %s -o - | \
; RUN:    FileCheck %s --check-prefix=CHECK --check-prefix=CHECKV6
; RUN: llc -mtriple=thumbv6m-eabi -O=0 -verify-machineinstrs %s -o - | \
; RUN:    FileCheck %s --check-prefix=CHECK --check-prefix=CHECKV6
; RUN: llc -mtriple=thumbv7a-eabi -mattr=-neon -verify-machineinstrs %s -o - | \
; RUN:    FileCheck %s --check-prefix=CHECK --check-prefix=CHECKV7
; RUN: llc -mtriple=armv7a-eabi -mattr=-neon -verify-machineinstrs %s -o - | \
; RUN:    FileCheck %s --check-prefix=CHECK --check-prefix=CHECKV7

@d = external global [64 x i32]
@s = external global [64 x i32]

; Function Attrs: nounwind
define void @t1() #0 {
entry:
; CHECK-LABEL: t1:
; CHECKV6: ldr [[LB:r[0-7]]],
; CHECKV6-NEXT: ldr [[SB:r[0-7]]],
; We use '[rl0-9]+' to allow 'r0'..'r12', 'lr'
; CHECKV7: movt [[LB:[rl0-9]+]], :upper16:d
; CHECKV7-NEXT: movt [[SB:[rl0-9]+]], :upper16:s
; CHECK-NEXT: ldm{{(\.w)?}} [[LB]]!,
; CHECK-NEXT: stm{{(\.w)?}} [[SB]]!,
; Think of the monstrosity '[[[LB]]]' as '[ [[LB]] ]' without the spaces.
; CHECK-NEXT: ldrb{{(\.w)?}} {{.*}}, [[[LB]]]
; CHECK-NEXT: strb{{(\.w)?}} {{.*}}, [[[SB]]]
    tail call void @llvm.memcpy.p0.p0.i32(ptr align 4 @s, ptr align 4 @d, i32 17, i1 false)
    ret void
}

; Function Attrs: nounwind
define void @t2() #0 {
entry:
; CHECK-LABEL: t2:
; CHECKV6: ldr [[LB:r[0-7]]],
; CHECKV6-NEXT: ldr [[SB:r[0-7]]],
; CHECKV6-NEXT: ldm{{(\.w)?}} [[LB]]!,
; CHECKV6-NEXT: stm{{(\.w)?}} [[SB]]!,
; CHECKV6-DAG: ldrh{{(\.w)?}} {{.*}}, [[[LB]]]
; CHECKV6-DAG: ldrb{{(\.w)?}} {{.*}}, [[[LB]], #2]
; CHECKV6-DAG: strb{{(\.w)?}} {{.*}}, [[[SB]], #2]
; CHECKV6-DAG: strh{{(\.w)?}} {{.*}}, [[[SB]]]
; CHECKV7: movt [[LB:[rl0-9]+]], :upper16:d
; CHECKV7-NEXT: movt [[SB:[rl0-9]+]], :upper16:s
; CHECKV7: ldr{{(\.w)?}} {{.*}}, [[[LB]], #11]
; CHECKV7-NEXT: str{{(\.w)?}} {{.*}}, [[[SB]], #11]
    tail call void @llvm.memcpy.p0.p0.i32(ptr align 4 @s, ptr align 4 @d, i32 15, i1 false)
    ret void
}

; PR23768
%struct.T = type { i8, i64, i8 }

@copy = external global %struct.T, align 8
@etest = external global %struct.T, align 8

define void @t3() {
  call void @llvm.memcpy.p0.p0.i32(
     ptr align 8 @copy,
     ptr align 8 @etest,
     i32 24, i1 false)
  call void @llvm.memcpy.p0.p0.i32(
     ptr align 8 @copy,
     ptr align 8 @etest,
     i32 24, i1 false)
  ret void
}

%struct.S = type { [12 x i32] }

; CHECK-LABEL: test3
define void @test3(ptr %d, ptr %s) #0 {
  tail call void @llvm.memcpy.p0.p0.i32(ptr align 4 %d, ptr align 4 %s, i32 48, i1 false)
; 3 ldm/stm pairs in v6; 2 in v7
; CHECK: ldm{{(\.w)?}} {{[rl0-9]+!?}}, [[REGLIST1:{.*}]]
; CHECK: stm{{(\.w)?}} {{[rl0-9]+!?}}, [[REGLIST1]]
; CHECK: ldm{{(\.w)?}} {{[rl0-9]+!?}}, [[REGLIST2:{.*}]]
; CHECK: stm{{(\.w)?}} {{[rl0-9]+!?}}, [[REGLIST2]]
; CHECKV6: ldm {{r[0-7]!?}}, [[REGLIST3:{.*}]]
; CHECKV6: stm {{r[0-7]!?}}, [[REGLIST3]]
; CHECKV7-NOT: ldm
; CHECKV7-NOT: stm
  %arrayidx = getelementptr inbounds %struct.S, ptr %s, i32 0, i32 0, i32 1
  tail call void @g(ptr %arrayidx) #3
  ret void
}

declare void @g(ptr)

; Set "frame-pointer"="all" to increase register pressure
attributes #0 = { "frame-pointer"="all" }

; Function Attrs: nounwind
declare void @llvm.memcpy.p0.p0.i32(ptr nocapture, ptr nocapture readonly, i32, i1) #1
