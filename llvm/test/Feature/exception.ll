; RUN: llvm-as < %s | llvm-dis > %t1.ll
; RUN: llvm-as %t1.ll -o - | llvm-dis > %t2.ll
; RUN: diff %t1.ll %t2.ll

@_ZTIc = external constant ptr
@_ZTId = external constant ptr
@_ZTIPKc = external constant ptr

define void @_Z3barv() uwtable optsize ssp personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %try.cont unwind label %lpad

try.cont:                                         ; preds = %entry, %invoke.cont4
  ret void

lpad:                                             ; preds = %entry
  %exn = landingpad {ptr, i32}
            cleanup
            catch ptr @_ZTIc
            filter [2 x ptr] [ptr @_ZTIPKc, ptr @_ZTId]
  resume { ptr, i32 } %exn
}

declare void @_Z3quxv() optsize

declare i32 @__gxx_personality_v0(...)

define void @cleanupret0() personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %exit unwind label %pad
pad:
  %cp = cleanuppad within none [i7 4]
  cleanupret from %cp unwind to caller
exit:
  ret void
}

; forward ref by name
define void @cleanupret1() personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %exit unwind label %pad
cleanup:
  cleanupret from %cp unwind to caller
pad:
  %cp = cleanuppad within none []
  br label %cleanup
exit:
  ret void
}

; forward ref by ID
define void @cleanupret2() personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %exit unwind label %pad
cleanup:
  cleanupret from %0 unwind to caller
pad:
  %0 = cleanuppad within none []
  br label %cleanup
exit:
  ret void
}

define void @catchret0() personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %exit unwind label %pad
pad:
  %cs1 = catchswitch within none [label %catch] unwind to caller
catch:
  %cp = catchpad within %cs1 [i7 4]
  catchret from %cp to label %exit
exit:
  ret void
}

; forward ref by name
define void @catchret1() personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %exit unwind label %pad
catchret:
  catchret from %cp to label %exit
pad:
  %cs1 = catchswitch within none [label %catch] unwind to caller
catch:
  %cp = catchpad within %cs1 [i7 4]
  br label %catchret
exit:
  ret void
}

; forward ref by ID
define void @catchret2() personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %exit unwind label %pad
catchret:
  catchret from %0 to label %exit
pad:
  %cs1 = catchswitch within none [label %catch] unwind to caller
catch:
  %0 = catchpad within %cs1 [i7 4]
  br label %catchret
exit:
  ret void
}

define i8 @catchpad() personality ptr @__gxx_personality_v0 {
entry:
  invoke void @_Z3quxv() optsize
          to label %exit unwind label %bb2
bb2:
  %cs1 = catchswitch within none [label %catch] unwind to caller
catch:
  catchpad within %cs1 [i7 4]
  br label %exit
exit:
  ret i8 0
}

define void @cleanuppad() personality ptr @__gxx_personality_v0 {
entry:
  br label %try.cont

try.cont:
  invoke void @_Z3quxv() optsize
          to label %try.cont unwind label %bb
bb:
  cleanuppad within none [i7 4]
  ret void
}
