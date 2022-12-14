; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv7-apple-ios -mcpu=cortex-a8 | FileCheck %s
; RUN: llc < %s -mtriple=thumbv8 | FileCheck -check-prefix=CHECK-V8 %s
; RUN: llc < %s -mtriple=thumbv7 -arm-restrict-it | FileCheck -check-prefix=CHECK-RESTRICT-IT %s

define i32 @t1(i32 %a, i32 %b, ptr %retaddr) {
; CHECK-LABEL: t1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ldr r3, LCPI0_0
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:  LPC0_0:
; CHECK-NEXT:    add r3, pc
; CHECK-NEXT:    str r3, [r2]
; CHECK-NEXT:    mov.w r2, #1
; CHECK-NEXT:    it eq
; CHECK-NEXT:    moveq.w r2, #-1
; CHECK-NEXT:  Ltmp0: @ Block address taken
; CHECK-NEXT:  @ %bb.1: @ %common.ret
; CHECK-NEXT:    adds r0, r1, r2
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.2:
; CHECK-NEXT:    .data_region
; CHECK-NEXT:  LCPI0_0:
; CHECK-NEXT:    .long Ltmp0-(LPC0_0+4)
; CHECK-NEXT:    .end_data_region
;
; CHECK-V8-LABEL: t1:
; CHECK-V8:       @ %bb.0:
; CHECK-V8-NEXT:    ldr r3, .LCPI0_0
; CHECK-V8-NEXT:    cmp r0, #0
; CHECK-V8-NEXT:    str r3, [r2]
; CHECK-V8-NEXT:    mov.w r2, #1
; CHECK-V8-NEXT:    it eq
; CHECK-V8-NEXT:    moveq.w r2, #-1
; CHECK-V8-NEXT:  .Ltmp0: @ Block address taken
; CHECK-V8-NEXT:  @ %bb.1: @ %common.ret
; CHECK-V8-NEXT:    adds r0, r1, r2
; CHECK-V8-NEXT:    bx lr
; CHECK-V8-NEXT:    .p2align 2
; CHECK-V8-NEXT:  @ %bb.2:
; CHECK-V8-NEXT:  .LCPI0_0:
; CHECK-V8-NEXT:    .long .Ltmp0
;
; CHECK-RESTRICT-IT-LABEL: t1:
; CHECK-RESTRICT-IT:       @ %bb.0:
; CHECK-RESTRICT-IT-NEXT:    ldr r3, .LCPI0_0
; CHECK-RESTRICT-IT-NEXT:    str r3, [r2]
; CHECK-RESTRICT-IT-NEXT:    movs r2, #1
; CHECK-RESTRICT-IT-NEXT:    cmp r0, #0
; CHECK-RESTRICT-IT-NEXT:    it eq
; CHECK-RESTRICT-IT-NEXT:    moveq.w r2, #-1
; CHECK-RESTRICT-IT-NEXT:  .Ltmp0: @ Block address taken
; CHECK-RESTRICT-IT-NEXT:  @ %bb.1: @ %common.ret
; CHECK-RESTRICT-IT-NEXT:    adds r0, r1, r2
; CHECK-RESTRICT-IT-NEXT:    bx lr
; CHECK-RESTRICT-IT-NEXT:    .p2align 2
; CHECK-RESTRICT-IT-NEXT:  @ %bb.2:
; CHECK-RESTRICT-IT-NEXT:  .LCPI0_0:
; CHECK-RESTRICT-IT-NEXT:    .long .Ltmp0
  store ptr blockaddress(@t1, %cond_true), ptr %retaddr
  %tmp2 = icmp eq i32 %a, 0
  br i1 %tmp2, label %cond_false, label %cond_true

cond_true:
  %tmp5 = add i32 %b, 1
  ret i32 %tmp5

cond_false:
  %tmp7 = add i32 %b, -1
  ret i32 %tmp7
}

define i32 @t2(i32 %a, i32 %b, i32 %c, i32 %d, ptr %retaddr) {
; CHECK-LABEL: t2:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    ldr.w r9, [sp]
; CHECK-NEXT:    add r0, r1
; CHECK-NEXT:    ldr.w r12, LCPI1_0
; CHECK-NEXT:    cmp r3, #3
; CHECK-NEXT:  LPC1_0:
; CHECK-NEXT:    add r12, pc
; CHECK-NEXT:    str.w r12, [r9]
; CHECK-NEXT:    it gt
; CHECK-NEXT:    bxgt lr
; CHECK-NEXT:  LBB1_1:
; CHECK-NEXT:    cmp r2, #10
; CHECK-NEXT:    ble LBB1_3
; CHECK-NEXT:  Ltmp1: @ Block address taken
; CHECK-NEXT:  @ %bb.2: @ %cond_true
; CHECK-NEXT:    add r0, r2
; CHECK-NEXT:    subs r0, r0, r3
; CHECK-NEXT:  LBB1_3: @ %common.ret
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.4:
; CHECK-NEXT:    .data_region
; CHECK-NEXT:  LCPI1_0:
; CHECK-NEXT:    .long Ltmp1-(LPC1_0+4)
; CHECK-NEXT:    .end_data_region
;
; CHECK-V8-LABEL: t2:
; CHECK-V8:       @ %bb.0:
; CHECK-V8-NEXT:    push {r7, lr}
; CHECK-V8-NEXT:    ldr.w r12, [sp, #8]
; CHECK-V8-NEXT:    add r0, r1
; CHECK-V8-NEXT:    ldr.w lr, .LCPI1_0
; CHECK-V8-NEXT:    cmp r3, #3
; CHECK-V8-NEXT:    str.w lr, [r12]
; CHECK-V8-NEXT:    it gt
; CHECK-V8-NEXT:    popgt {r7, pc}
; CHECK-V8-NEXT:  .LBB1_1:
; CHECK-V8-NEXT:    cmp r2, #10
; CHECK-V8-NEXT:    ble .LBB1_3
; CHECK-V8-NEXT:  .Ltmp1: @ Block address taken
; CHECK-V8-NEXT:  @ %bb.2: @ %cond_true
; CHECK-V8-NEXT:    add r0, r2
; CHECK-V8-NEXT:    subs r0, r0, r3
; CHECK-V8-NEXT:  .LBB1_3: @ %common.ret
; CHECK-V8-NEXT:    pop {r7, pc}
; CHECK-V8-NEXT:    .p2align 2
; CHECK-V8-NEXT:  @ %bb.4:
; CHECK-V8-NEXT:  .LCPI1_0:
; CHECK-V8-NEXT:    .long .Ltmp1
;
; CHECK-RESTRICT-IT-LABEL: t2:
; CHECK-RESTRICT-IT:       @ %bb.0:
; CHECK-RESTRICT-IT-NEXT:    push {r7, lr}
; CHECK-RESTRICT-IT-NEXT:    ldr.w r12, [sp, #8]
; CHECK-RESTRICT-IT-NEXT:    add r0, r1
; CHECK-RESTRICT-IT-NEXT:    ldr.w lr, .LCPI1_0
; CHECK-RESTRICT-IT-NEXT:    cmp r3, #3
; CHECK-RESTRICT-IT-NEXT:    str.w lr, [r12]
; CHECK-RESTRICT-IT-NEXT:    bgt .LBB1_3
; CHECK-RESTRICT-IT-NEXT:  @ %bb.1:
; CHECK-RESTRICT-IT-NEXT:    cmp r2, #10
; CHECK-RESTRICT-IT-NEXT:    ble .LBB1_3
; CHECK-RESTRICT-IT-NEXT:  .Ltmp1: @ Block address taken
; CHECK-RESTRICT-IT-NEXT:  @ %bb.2: @ %cond_true
; CHECK-RESTRICT-IT-NEXT:    add r0, r2
; CHECK-RESTRICT-IT-NEXT:    subs r0, r0, r3
; CHECK-RESTRICT-IT-NEXT:  .LBB1_3: @ %common.ret
; CHECK-RESTRICT-IT-NEXT:    pop {r7, pc}
; CHECK-RESTRICT-IT-NEXT:    .p2align 2
; CHECK-RESTRICT-IT-NEXT:  @ %bb.4:
; CHECK-RESTRICT-IT-NEXT:  .LCPI1_0:
; CHECK-RESTRICT-IT-NEXT:    .long .Ltmp1
  store ptr blockaddress(@t2, %cond_true), ptr %retaddr
  %tmp2 = icmp sgt i32 %c, 10
  %tmp5 = icmp slt i32 %d, 4
  %tmp8 = and i1 %tmp5, %tmp2
  %tmp13 = add i32 %b, %a
  br i1 %tmp8, label %cond_true, label %UnifiedReturnBlock

cond_true:
  %tmp15 = add i32 %tmp13, %c
  %tmp1821 = sub i32 %tmp15, %d
  ret i32 %tmp1821

UnifiedReturnBlock:
  ret i32 %tmp13
}

define hidden fastcc void @t3(ptr %retaddr, i1 %tst, ptr %p8) {
; CHECK-LABEL: t3:
; CHECK:       @ %bb.0: @ %bb
; CHECK-NEXT:    ldr r1, LCPI2_0
; CHECK-NEXT:  LPC2_0:
; CHECK-NEXT:    add r1, pc
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:  Ltmp2: @ Block address taken
; CHECK-NEXT:  @ %bb.1: @ %common.ret
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.2:
; CHECK-NEXT:    .data_region
; CHECK-NEXT:  LCPI2_0:
; CHECK-NEXT:    .long Ltmp2-(LPC2_0+4)
; CHECK-NEXT:    .end_data_region
;
; CHECK-V8-LABEL: t3:
; CHECK-V8:       @ %bb.0: @ %bb
; CHECK-V8-NEXT:    ldr r1, .LCPI2_0
; CHECK-V8-NEXT:    str r1, [r0]
; CHECK-V8-NEXT:  .Ltmp2: @ Block address taken
; CHECK-V8-NEXT:  @ %bb.1: @ %common.ret
; CHECK-V8-NEXT:    bx lr
; CHECK-V8-NEXT:    .p2align 2
; CHECK-V8-NEXT:  @ %bb.2:
; CHECK-V8-NEXT:  .LCPI2_0:
; CHECK-V8-NEXT:    .long .Ltmp2
;
; CHECK-RESTRICT-IT-LABEL: t3:
; CHECK-RESTRICT-IT:       @ %bb.0: @ %bb
; CHECK-RESTRICT-IT-NEXT:    ldr r1, .LCPI2_0
; CHECK-RESTRICT-IT-NEXT:    str r1, [r0]
; CHECK-RESTRICT-IT-NEXT:  .Ltmp2: @ Block address taken
; CHECK-RESTRICT-IT-NEXT:  @ %bb.1: @ %common.ret
; CHECK-RESTRICT-IT-NEXT:    bx lr
; CHECK-RESTRICT-IT-NEXT:    .p2align 2
; CHECK-RESTRICT-IT-NEXT:  @ %bb.2:
; CHECK-RESTRICT-IT-NEXT:  .LCPI2_0:
; CHECK-RESTRICT-IT-NEXT:    .long .Ltmp2
bb:
  store ptr blockaddress(@t3, %KBBlockZero_return_1), ptr %retaddr
  br i1 %tst, label %bb77, label %bb7.i

bb7.i:                                            ; preds = %bb35
  br label %bb2.i

KBBlockZero_return_1:                             ; preds = %KBBlockZero.exit
  ret void

KBBlockZero_return_0:                             ; preds = %KBBlockZero.exit
  ret void

bb77:                                             ; preds = %bb26, %bb12, %bb
  ret void

bb2.i:                                            ; preds = %bb6.i350, %bb7.i
  br i1 %tst, label %bb6.i350, label %KBBlockZero.exit

bb6.i350:                                         ; preds = %bb2.i
  br label %bb2.i

KBBlockZero.exit:                                 ; preds = %bb2.i
  indirectbr ptr %p8, [label %KBBlockZero_return_1, label %KBBlockZero_return_0]
}

@foo = global ptr null
define i32 @t4(i32 %x, ptr %p_foo) {
; CHECK-LABEL: t4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    cmp r0, #59
; CHECK-NEXT:    ittt gt
; CHECK-NEXT:    mvngt r0, #119
; CHECK-NEXT:    addgt r0, r4
; CHECK-NEXT:    popgt {r4, pc}
; CHECK-NEXT:  LBB3_1: @ %if.then
; CHECK-NEXT:    blx r1
; CHECK-NEXT:    mov.w r0, #-1
; CHECK-NEXT:    add r0, r4
; CHECK-NEXT:    pop {r4, pc}
;
; CHECK-V8-LABEL: t4:
; CHECK-V8:       @ %bb.0: @ %entry
; CHECK-V8-NEXT:    push {r4, lr}
; CHECK-V8-NEXT:    mov r4, r0
; CHECK-V8-NEXT:    cmp r0, #59
; CHECK-V8-NEXT:    bgt .LBB3_2
; CHECK-V8-NEXT:  @ %bb.1: @ %if.then
; CHECK-V8-NEXT:    blx r1
; CHECK-V8-NEXT:    mov.w r0, #-1
; CHECK-V8-NEXT:    add r0, r4
; CHECK-V8-NEXT:    pop {r4, pc}
; CHECK-V8-NEXT:  .LBB3_2:
; CHECK-V8-NEXT:    mvn r0, #119
; CHECK-V8-NEXT:    add r0, r4
; CHECK-V8-NEXT:    pop {r4, pc}
;
; CHECK-RESTRICT-IT-LABEL: t4:
; CHECK-RESTRICT-IT:       @ %bb.0: @ %entry
; CHECK-RESTRICT-IT-NEXT:    push {r4, lr}
; CHECK-RESTRICT-IT-NEXT:    mov r4, r0
; CHECK-RESTRICT-IT-NEXT:    cmp r0, #59
; CHECK-RESTRICT-IT-NEXT:    bgt .LBB3_2
; CHECK-RESTRICT-IT-NEXT:  @ %bb.1: @ %if.then
; CHECK-RESTRICT-IT-NEXT:    blx r1
; CHECK-RESTRICT-IT-NEXT:    mov.w r0, #-1
; CHECK-RESTRICT-IT-NEXT:    add r0, r4
; CHECK-RESTRICT-IT-NEXT:    pop {r4, pc}
; CHECK-RESTRICT-IT-NEXT:  .LBB3_2:
; CHECK-RESTRICT-IT-NEXT:    mvn r0, #119
; CHECK-RESTRICT-IT-NEXT:    add r0, r4
; CHECK-RESTRICT-IT-NEXT:    pop {r4, pc}
entry:
  %cmp = icmp slt i32 %x, 60
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %tmp.2 = call i32 %p_foo()
  %sub = add nsw i32 %x, -1
  br label %return

if.else:                                          ; preds = %entry
  %sub1 = add nsw i32 %x, -120
  br label %return

return:                                           ; preds = %if.end5, %if.then4, %if.then
  %retval.0 = phi i32 [ %sub, %if.then ], [ %sub1, %if.else ]
  ret i32 %retval.0
}

; If-converter was checking for the wrong predicate subsumes pattern when doing
; nested predicates.
; E.g., Let A be a basic block that flows conditionally into B and B be a
; predicated block.
; B can be predicated with A.BrToBPredicate into A iff B.Predicate is less
; "permissive" than A.BrToBPredicate, i.e., iff A.BrToBPredicate subsumes
; B.Predicate.

define i32 @wrapDistance(i32 %tx, i32 %sx, i32 %w) {
; CHECK-LABEL: wrapDistance:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r1, #59
; CHECK-NEXT:    itt le
; CHECK-NEXT:    suble r0, r2, #1
; CHECK-NEXT:    bxle lr
; CHECK-NEXT:  LBB4_1: @ %if.else
; CHECK-NEXT:    subs r2, #120
; CHECK-NEXT:    cmp r2, r1
; CHECK-NEXT:    bge LBB4_3
; CHECK-NEXT:  @ %bb.2: @ %if.else
; CHECK-NEXT:    cmp r0, #119
; CHECK-NEXT:    itt le
; CHECK-NEXT:    addle r0, r1, #1
; CHECK-NEXT:    bxle lr
; CHECK-NEXT:  LBB4_3: @ %if.end5
; CHECK-NEXT:    subs r0, r1, r0
; CHECK-NEXT:    bx lr
;
; CHECK-V8-LABEL: wrapDistance:
; CHECK-V8:       @ %bb.0: @ %entry
; CHECK-V8-NEXT:    cmp r1, #59
; CHECK-V8-NEXT:    itt le
; CHECK-V8-NEXT:    suble r0, r2, #1
; CHECK-V8-NEXT:    bxle lr
; CHECK-V8-NEXT:  .LBB4_1: @ %if.else
; CHECK-V8-NEXT:    subs r2, #120
; CHECK-V8-NEXT:    cmp r2, r1
; CHECK-V8-NEXT:    bge .LBB4_3
; CHECK-V8-NEXT:  @ %bb.2: @ %if.else
; CHECK-V8-NEXT:    cmp r0, #119
; CHECK-V8-NEXT:    itt le
; CHECK-V8-NEXT:    addle r0, r1, #1
; CHECK-V8-NEXT:    bxle lr
; CHECK-V8-NEXT:  .LBB4_3: @ %if.end5
; CHECK-V8-NEXT:    subs r0, r1, r0
; CHECK-V8-NEXT:    bx lr
;
; CHECK-RESTRICT-IT-LABEL: wrapDistance:
; CHECK-RESTRICT-IT:       @ %bb.0: @ %entry
; CHECK-RESTRICT-IT-NEXT:    cmp r1, #59
; CHECK-RESTRICT-IT-NEXT:    bgt .LBB4_2
; CHECK-RESTRICT-IT-NEXT:  @ %bb.1: @ %if.then
; CHECK-RESTRICT-IT-NEXT:    subs r0, r2, #1
; CHECK-RESTRICT-IT-NEXT:    bx lr
; CHECK-RESTRICT-IT-NEXT:  .LBB4_2: @ %if.else
; CHECK-RESTRICT-IT-NEXT:    subs r2, #120
; CHECK-RESTRICT-IT-NEXT:    cmp r2, r1
; CHECK-RESTRICT-IT-NEXT:    bge .LBB4_5
; CHECK-RESTRICT-IT-NEXT:  @ %bb.3: @ %if.else
; CHECK-RESTRICT-IT-NEXT:    cmp r0, #119
; CHECK-RESTRICT-IT-NEXT:    bgt .LBB4_5
; CHECK-RESTRICT-IT-NEXT:  @ %bb.4: @ %if.then4
; CHECK-RESTRICT-IT-NEXT:    adds r0, r1, #1
; CHECK-RESTRICT-IT-NEXT:    bx lr
; CHECK-RESTRICT-IT-NEXT:  .LBB4_5: @ %if.end5
; CHECK-RESTRICT-IT-NEXT:    subs r0, r1, r0
; CHECK-RESTRICT-IT-NEXT:    bx lr
entry:
  %cmp = icmp slt i32 %sx, 60
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %sub = add nsw i32 %w, -1
  br label %return

if.else:                                          ; preds = %entry
  %sub1 = add nsw i32 %w, -120
  %cmp2 = icmp slt i32 %sub1, %sx
  %cmp3 = icmp slt i32 %tx, 120
  %or.cond = and i1 %cmp2, %cmp3
  br i1 %or.cond, label %if.then4, label %if.end5

if.then4:                                         ; preds = %if.else
  %add = add nsw i32 %sx, 1
  br label %return

if.end5:                                          ; preds = %if.else
  %sub6 = sub nsw i32 %sx, %tx
  br label %return

return:                                           ; preds = %if.end5, %if.then4, %if.then
  %retval.0 = phi i32 [ %sub, %if.then ], [ %add, %if.then4 ], [ %sub6, %if.end5 ]
  ret i32 %retval.0
}
