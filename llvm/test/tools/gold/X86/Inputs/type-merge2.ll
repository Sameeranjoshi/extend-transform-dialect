target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%zed = type { i16 }
define void @bar(ptr %this)  {
  store ptr %this, ptr null
  ret void
}
