; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=mips64el-linux-gnu -mcpu=mips64r6 -mattr=+msa,+fp64 < %s | FileCheck %s --check-prefixes=MIPSEL64R6
; RUN: llc -mtriple=mipsel-linux-gnu -mcpu=mips32r5 -mattr=+msa,+fp64 < %s | FileCheck %s --check-prefixes=MIPSEL32R5

declare <2 x i64> @llvm.mips.slli.d(<2 x i64>, i32)
declare <2 x i64> @llvm.mips.srli.d(<2 x i64>, i32)

declare <4 x i32> @llvm.mips.slli.w(<4 x i32>, i32)
declare <4 x i32> @llvm.mips.srli.w(<4 x i32>, i32)

; do not fold (shl (srl x, c1), c2) -> (and (srl x, (sub c1, c2), MASK) if C1 < C2
; MASK_TYPE1 = C2-C1 0s | 1s | ends with C1 0s
define void @avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i64(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i64:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.d $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.d $w0, $w0, 52
; MIPSEL64R6-NEXT:    slli.d $w0, $w0, 51
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.d $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i64:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.d $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.d $w0, $w0, 52
; MIPSEL32R5-NEXT:    slli.d $w0, $w0, 51
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.d $w0, 0($5)
entry:
  %0 = load <2 x i64>, ptr %a
  %1 = tail call <2 x i64> @llvm.mips.srli.d(<2 x i64> %0, i32 52)
  %2 = tail call <2 x i64> @llvm.mips.slli.d(<2 x i64> %1, i32 51)
  store <2 x i64> %2, ptr %b
  ret void
}

; do not fold (shl (srl x, c1), c2) -> (and (srl x, (sub c1, c2), MASK) if C1 < C2
define void @avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i64_long(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i64_long:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.d $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.d $w0, $w0, 6
; MIPSEL64R6-NEXT:    slli.d $w0, $w0, 4
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.d $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i64_long:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.d $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.d $w0, $w0, 6
; MIPSEL32R5-NEXT:    slli.d $w0, $w0, 4
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.d $w0, 0($5)
entry:
  %0 = load <2 x i64>, ptr %a
  %1 = tail call <2 x i64> @llvm.mips.srli.d(<2 x i64> %0, i32 6)
  %2 = tail call <2 x i64> @llvm.mips.slli.d(<2 x i64> %1, i32 4)
  store <2 x i64> %2, ptr %b
  ret void
}

; do not fold (shl (srl x, c1), c2) -> (and (shl x, (sub c1, c2), MASK) if C1 >= C2
; MASK_TYPE2 = 1s | C1 zeros
define void @avoid_to_combine_shifts_to_shift_plus_and_mask_type2_i32(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type2_i32:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.d $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.d $w0, $w0, 4
; MIPSEL64R6-NEXT:    slli.d $w0, $w0, 6
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.d $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type2_i32:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.d $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.d $w0, $w0, 4
; MIPSEL32R5-NEXT:    slli.d $w0, $w0, 6
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.d $w0, 0($5)
entry:
  %0 = load <2 x i64>, ptr %a
  %1 = tail call <2 x i64> @llvm.mips.srli.d(<2 x i64> %0, i32 4)
  %2 = tail call <2 x i64> @llvm.mips.slli.d(<2 x i64> %1, i32 6)
  store <2 x i64> %2, ptr %b
  ret void
}

; do not fold (shl (srl x, c1), c2) -> (and (srl x, (sub c1, c2), MASK) if C1 < C2
define void @avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i32_long(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i32_long:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.w $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.w $w0, $w0, 7
; MIPSEL64R6-NEXT:    slli.w $w0, $w0, 3
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.w $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_shift_plus_and_mask_type1_i32_long:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.w $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.w $w0, $w0, 7
; MIPSEL32R5-NEXT:    slli.w $w0, $w0, 3
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.w $w0, 0($5)
entry:
  %0 = load <4 x i32>, ptr %a
  %1 = tail call <4 x i32> @llvm.mips.srli.w(<4 x i32> %0, i32 7)
  %2 = tail call <4 x i32> @llvm.mips.slli.w(<4 x i32> %1, i32 3)
  store <4 x i32> %2, ptr %b
  ret void
}

; do not fold (shl (sra x, c1), c1) -> (and x, (shl -1, c1))
define void @avoid_to_combine_shifts_to_and_mask_type2_i64_long(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_and_mask_type2_i64_long:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.d $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.d $w0, $w0, 38
; MIPSEL64R6-NEXT:    slli.d $w0, $w0, 38
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.d $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_and_mask_type2_i64_long:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.d $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.d $w0, $w0, 38
; MIPSEL32R5-NEXT:    slli.d $w0, $w0, 38
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.d $w0, 0($5)
entry:
  %0 = load <2 x i64>, ptr %a
  %1 = tail call <2 x i64> @llvm.mips.srli.d(<2 x i64> %0, i32 38)
  %2 = tail call <2 x i64> @llvm.mips.slli.d(<2 x i64> %1, i32 38)
  store <2 x i64> %2, ptr %b
  ret void
}

; do not fold (shl (sra x, c1), c1) -> (and x, (shl -1, c1))
define void @avoid_to_combine_shifts_to_and_mask_type2_i64(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_and_mask_type2_i64:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.d $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.d $w0, $w0, 3
; MIPSEL64R6-NEXT:    slli.d $w0, $w0, 3
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.d $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_and_mask_type2_i64:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.d $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.d $w0, $w0, 3
; MIPSEL32R5-NEXT:    slli.d $w0, $w0, 3
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.d $w0, 0($5)
entry:
  %0 = load <2 x i64>, ptr %a
  %1 = tail call <2 x i64> @llvm.mips.srli.d(<2 x i64> %0, i32 3)
  %2 = tail call <2 x i64> @llvm.mips.slli.d(<2 x i64> %1, i32 3)
  store <2 x i64> %2, ptr %b
  ret void
}

; do not fold (shl (sra x, c1), c1) -> (and x, (shl -1, c1))
define void @avoid_to_combine_shifts_to_and_mask_type1_long_i32_a(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_and_mask_type1_long_i32_a:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.w $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.w $w0, $w0, 5
; MIPSEL64R6-NEXT:    slli.w $w0, $w0, 5
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.w $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_and_mask_type1_long_i32_a:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.w $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.w $w0, $w0, 5
; MIPSEL32R5-NEXT:    slli.w $w0, $w0, 5
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.w $w0, 0($5)
entry:
  %0 = load <4 x i32>, ptr %a
  %1 = tail call <4 x i32> @llvm.mips.srli.w(<4 x i32> %0, i32 5)
  %2 = tail call <4 x i32> @llvm.mips.slli.w(<4 x i32> %1, i32 5)
  store <4 x i32> %2, ptr %b
  ret void
}

; do not fold (shl (sra x, c1), c1) -> (and x, (shl -1, c1))
define void @avoid_to_combine_shifts_to_and_mask_type1_long_i32_b(ptr %a, ptr %b) {
; MIPSEL64R6-LABEL: avoid_to_combine_shifts_to_and_mask_type1_long_i32_b:
; MIPSEL64R6:       # %bb.0: # %entry
; MIPSEL64R6-NEXT:    ld.w $w0, 0($4)
; MIPSEL64R6-NEXT:    srli.w $w0, $w0, 30
; MIPSEL64R6-NEXT:    slli.w $w0, $w0, 30
; MIPSEL64R6-NEXT:    jr $ra
; MIPSEL64R6-NEXT:    st.w $w0, 0($5)
;
; MIPSEL32R5-LABEL: avoid_to_combine_shifts_to_and_mask_type1_long_i32_b:
; MIPSEL32R5:       # %bb.0: # %entry
; MIPSEL32R5-NEXT:    ld.w $w0, 0($4)
; MIPSEL32R5-NEXT:    srli.w $w0, $w0, 30
; MIPSEL32R5-NEXT:    slli.w $w0, $w0, 30
; MIPSEL32R5-NEXT:    jr $ra
; MIPSEL32R5-NEXT:    st.w $w0, 0($5)
entry:
  %0 = load <4 x i32>, ptr %a
  %1 = tail call <4 x i32> @llvm.mips.srli.w(<4 x i32> %0, i32 30)
  %2 = tail call <4 x i32> @llvm.mips.slli.w(<4 x i32> %1, i32 30)
  store <4 x i32> %2, ptr %b
  ret void
}
