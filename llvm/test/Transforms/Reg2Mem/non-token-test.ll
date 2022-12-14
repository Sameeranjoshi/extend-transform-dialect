; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=reg2mem -S < %s | FileCheck %s

%opaque = type opaque

declare %opaque @ret_opaque()
declare void @pass_opaque(%opaque)

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:    %"reg2mem alloca point" = bitcast i32 0 to i32
; CHECK-NEXT:    [[X:%.*]] = call [[OPAQUE:%.*]] @ret_opaque()
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    call void @pass_opaque([[OPAQUE]] [[X]])
; CHECK-NEXT:    ret void
;
  %x = call %opaque @ret_opaque()
  br label %next

next:
  call void @pass_opaque(%opaque %x)
  ret void
}
