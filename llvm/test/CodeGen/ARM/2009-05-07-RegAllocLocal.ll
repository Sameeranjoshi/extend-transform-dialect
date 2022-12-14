; RUN: llc < %s -mtriple=armv5-unknown-linux-gnueabi -O0 -regalloc=fast
; PR4100
@.str = external constant [30 x i8]		; <ptr> [#uses=1]

define i16 @fn16(i16 %arg0.0, <2 x i16> %arg1, i16 %arg2.0) nounwind {
entry:
	store <2 x i16> %arg1, ptr null
	%0 = call i32 (ptr, ...) @printf(ptr @.str, i32 0) nounwind		; <i32> [#uses=0]
	ret i16 0
}

declare i32 @printf(ptr, ...) nounwind
