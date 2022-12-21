//===------------- TestDummy.cpp - Test slice related analisis ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Analysis/SliceAnalysis.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Dialect/Transform/IR/TransformInterfaces.h"
using namespace mlir;

namespace {

struct MyDummyOpAgonisticPass : public PassWrapper<MyDummyOpAgonisticPass, OperationPass<>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(MyDummyOpAgonisticPass)
  StringRef getArgument() const final { return "dummy-pass"; }
  StringRef getDescription() const final {
    return "Nothing useful";
  }
  void runOnOperation() override {
    // Get the current operation being operated on.
    Operation *op = getOperation();
    if (op){
      llvm::outs() << "\n PRINTING OPNAME : "<< op->getName() << "\n";
    } else{
        // Error management of pass.
         return signalPassFailure();
    }
  }
};
} // namespace

namespace mlir {
namespace test {
void registerDummyTestPass() {
  PassRegistration<MyDummyOpAgonisticPass>();
}
} // namespace test
} // namespace mlir

