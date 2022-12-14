; RUN: opt < %s -aa-pipeline=basic-aa -passes=gvn -S | FileCheck %s
;
; Check that section->word_ofs doesn't get reloaded in every iteration of the
; for loop.
;
; Code:
;
; typedef struct {
;   unsigned num_words;
;   unsigned word_ofs;
;   const unsigned *data;
; } section_t;
; 
; 
; void test2(const section_t * restrict section, unsigned * restrict dst) {;
;   while (section->data != NULL) {
;     const unsigned *src = section->data;
;     for (unsigned i=0; i < section->num_words; ++i) {
;       dst[section->word_ofs + i] = src[i];
;     }   
; 
;     ++section;
;   }
; }
; 

; CHECK-LABEL: for.body:
; CHECK-NOT: load i32, i32* %word_ofs

%struct.section_t = type { i32, i32, ptr }

define void @test2(ptr noalias nocapture readonly %section, ptr noalias nocapture %dst) {
entry:
  %data13 = getelementptr inbounds %struct.section_t, ptr %section, i32 0, i32 2
  %0 = load ptr, ptr %data13, align 4
  %cmp14 = icmp eq ptr %0, null
  br i1 %cmp14, label %while.end, label %for.cond.preheader

for.cond.preheader:                               ; preds = %entry, %for.end
  %1 = phi ptr [ %6, %for.end ], [ %0, %entry ]
  %section.addr.015 = phi ptr [ %incdec.ptr, %for.end ], [ %section, %entry ]
  %2 = load i32, ptr %section.addr.015, align 4
  %cmp211 = icmp eq i32 %2, 0
  br i1 %cmp211, label %for.end, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %for.cond.preheader
  %word_ofs = getelementptr inbounds %struct.section_t, ptr %section.addr.015, i32 0, i32 1
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %arrayidx.phi = phi ptr [ %1, %for.body.lr.ph ], [ %arrayidx.inc, %for.body ]
  %i.012 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %3 = load i32, ptr %arrayidx.phi, align 4
  %4 = load i32, ptr %word_ofs, align 4
  %add = add i32 %4, %i.012
  %arrayidx3 = getelementptr inbounds i32, ptr %dst, i32 %add
  store i32 %3, ptr %arrayidx3, align 4
  %inc = add i32 %i.012, 1
  %5 = load i32, ptr %section.addr.015, align 4
  %cmp2 = icmp ult i32 %inc, %5
  %arrayidx.inc = getelementptr i32, ptr %arrayidx.phi, i32 1
  br i1 %cmp2, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %for.cond.preheader
  %incdec.ptr = getelementptr inbounds %struct.section_t, ptr %section.addr.015, i32 1
  %data = getelementptr inbounds %struct.section_t, ptr %section.addr.015, i32 1, i32 2
  %6 = load ptr, ptr %data, align 4
  %cmp = icmp eq ptr %6, null
  br i1 %cmp, label %while.end, label %for.cond.preheader

while.end:                                        ; preds = %for.end, %entry
  ret void
}

