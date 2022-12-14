// RUN: %clang_cc1 -triple x86_64-pc-linux-gnu -fobjc-runtime=objfw -emit-llvm -o - %s | FileCheck %s

// Test the ObjFW runtime.

@interface Test0
+ (void) test;
@end
void test0(void) {
  [Test0 test];
}
// CHECK-LABEL:    define{{.*}} void @test0()
// CHECK:      [[T0:%.*]] = call ptr @objc_msg_lookup(ptr @_OBJC_CLASS_Test0,
// CHECK-NEXT: call void [[T0]](ptr noundef @_OBJC_CLASS_Test0, 
// CHECK-NEXT: ret void
