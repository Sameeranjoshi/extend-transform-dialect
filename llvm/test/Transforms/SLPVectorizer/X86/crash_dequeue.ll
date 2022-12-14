; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer,dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"
%"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731" = type { double*, double*, double*, double** }

; Function Attrs: nounwind ssp uwtable
define void @_ZSt6uniqueISt15_Deque_iteratorIdRdPdEET_S4_S4_(%"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* %__first, %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* nocapture %__last) {
; CHECK-LABEL: @_ZSt6uniqueISt15_Deque_iteratorIdRdPdEET_S4_S4_(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[_M_CUR2_I_I:%.*]] = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* [[__FIRST:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[TMP0:%.*]] = load double*, double** [[_M_CUR2_I_I]], align 8
; CHECK-NEXT:    [[_M_FIRST3_I_I:%.*]] = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* [[__FIRST]], i64 0, i32 1
; CHECK-NEXT:    [[_M_CUR2_I_I81:%.*]] = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* [[__LAST:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = load double*, double** [[_M_CUR2_I_I81]], align 8
; CHECK-NEXT:    [[_M_FIRST3_I_I83:%.*]] = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* [[__LAST]], i64 0, i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = load double*, double** [[_M_FIRST3_I_I83]], align 8
; CHECK-NEXT:    br i1 undef, label [[_ZST13ADJACENT_FINDIST15_DEQUE_ITERATORIDRDPDEET_S4_S4__EXIT:%.*]], label [[WHILE_COND_I_PREHEADER:%.*]]
; CHECK:       while.cond.i.preheader:
; CHECK-NEXT:    br label [[WHILE_COND_I:%.*]]
; CHECK:       while.cond.i:
; CHECK-NEXT:    br i1 undef, label [[_ZST13ADJACENT_FINDIST15_DEQUE_ITERATORIDRDPDEET_S4_S4__EXIT]], label [[WHILE_BODY_I:%.*]]
; CHECK:       while.body.i:
; CHECK-NEXT:    br i1 undef, label [[_ZST13ADJACENT_FINDIST15_DEQUE_ITERATORIDRDPDEET_S4_S4__EXIT]], label [[WHILE_COND_I]]
; CHECK:       _ZSt13adjacent_findISt15_Deque_iteratorIdRdPdEET_S4_S4_.exit:
; CHECK-NEXT:    [[TMP3:%.*]] = phi double* [ [[TMP2]], [[ENTRY:%.*]] ], [ [[TMP2]], [[WHILE_COND_I]] ], [ undef, [[WHILE_BODY_I]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = phi double* [ [[TMP0]], [[ENTRY]] ], [ [[TMP1]], [[WHILE_COND_I]] ], [ undef, [[WHILE_BODY_I]] ]
; CHECK-NEXT:    store double* [[TMP4]], double** [[_M_CUR2_I_I]], align 8
; CHECK-NEXT:    store double* [[TMP3]], double** [[_M_FIRST3_I_I]], align 8
; CHECK-NEXT:    br i1 undef, label [[IF_THEN_I55:%.*]], label [[WHILE_COND:%.*]]
; CHECK:       if.then.i55:
; CHECK-NEXT:    br label [[WHILE_COND]]
; CHECK:       while.cond:
; CHECK-NEXT:    br label [[WHILE_COND]]
;
entry:
  %_M_cur2.i.i = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* %__first, i64 0, i32 0
  %0 = load double*, double** %_M_cur2.i.i, align 8
  %_M_first3.i.i = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* %__first, i64 0, i32 1
  %_M_cur2.i.i81 = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* %__last, i64 0, i32 0
  %1 = load double*, double** %_M_cur2.i.i81, align 8
  %_M_first3.i.i83 = getelementptr inbounds %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731", %"struct.std::_Deque_iterator.4.157.174.208.259.276.344.731"* %__last, i64 0, i32 1
  %2 = load double*, double** %_M_first3.i.i83, align 8
  br i1 undef, label %_ZSt13adjacent_findISt15_Deque_iteratorIdRdPdEET_S4_S4_.exit, label %while.cond.i.preheader

while.cond.i.preheader:                           ; preds = %entry
  br label %while.cond.i

while.cond.i:                                     ; preds = %while.body.i, %while.cond.i.preheader
  br i1 undef, label %_ZSt13adjacent_findISt15_Deque_iteratorIdRdPdEET_S4_S4_.exit, label %while.body.i

while.body.i:                                     ; preds = %while.cond.i
  br i1 undef, label %_ZSt13adjacent_findISt15_Deque_iteratorIdRdPdEET_S4_S4_.exit, label %while.cond.i

_ZSt13adjacent_findISt15_Deque_iteratorIdRdPdEET_S4_S4_.exit: ; preds = %while.body.i, %while.cond.i, %entry
  %3 = phi double* [ %2, %entry ], [ %2, %while.cond.i ], [ undef, %while.body.i ]
  %4 = phi double* [ %0, %entry ], [ %1, %while.cond.i ], [ undef, %while.body.i ]
  store double* %4, double** %_M_cur2.i.i, align 8
  store double* %3, double** %_M_first3.i.i, align 8
  br i1 undef, label %if.then.i55, label %while.cond

if.then.i55:                                      ; preds = %_ZSt13adjacent_findISt15_Deque_iteratorIdRdPdEET_S4_S4_.exit
  br label %while.cond

while.cond:                                       ; preds = %while.cond, %if.then.i55, %_ZSt13adjacent_findISt15_Deque_iteratorIdRdPdEET_S4_S4_.exit
  br label %while.cond
}
