; RUN: llc < %s -mtriple=thumbv7-none-linux-gnueabi
; PR4681

	%struct.FILE = type { i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i32, i32, i32, i16, i8, [1 x i8], ptr, i64, ptr, ptr, ptr, ptr, i32, i32, [40 x i8] }
	%struct._IO_marker = type { ptr, ptr, i32 }
@.str2 = external constant [30 x i8], align 1		; <ptr> [#uses=1]

define i32 @__mf_heuristic_check(i32 %ptr, i32 %ptr_high) nounwind {
entry:
	br i1 undef, label %bb1, label %bb

bb:		; preds = %entry
	unreachable

bb1:		; preds = %entry
	br i1 undef, label %bb9, label %bb2

bb2:		; preds = %bb1
	%0 = call ptr @llvm.frameaddress(i32 0)		; <ptr> [#uses=1]
	%1 = call  i32 (ptr, ptr, ...) @fprintf(ptr noalias undef, ptr noalias @.str2, ptr %0, ptr null) nounwind		; <i32> [#uses=0]
	unreachable

bb9:		; preds = %bb1
	ret i32 undef
}

declare ptr @llvm.frameaddress(i32) nounwind readnone

declare i32 @fprintf(ptr noalias nocapture, ptr noalias nocapture, ...) nounwind
