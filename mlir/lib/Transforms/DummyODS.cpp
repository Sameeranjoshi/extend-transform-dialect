//===- DummyODS.cpp - Dummy Pass using ODS framework    ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Transforms/Passes.h"

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Pass/Pass.h"

// The Passes.h file contains the declaration of this function
// We are including it here.
namespace mlir {
#define GEN_PASS_DEF_DUMMYODS
#include "mlir/Transforms/Passes.h.inc"
} // namespace mlir

using namespace mlir;

namespace {

// <classname>  = Is important should follow related files and naming
//                convention around
// <classname>Base = default name appended from the TableGen.
// The body uses some user input variables, and Statistics class variables.
struct DummyODS : public impl::DummyODSBase<DummyODS> {
  void runOnOperation() override {
     // Get the current operation being operated on.
    Operation *op = getOperation();
    if (op){
      // This is queried from the user input variable value.
      llvm::outs() << "\n User gave Simple=?" << Simple;
      llvm::outs() << "\n PRINTING OPNAME : "<< op->getName() << "\n";
      // This is the pass statistics variable which we declared using the ODS,
      // we need to take some action or apply some logic for collecting statistics
      // we do it here.
      ++captureStats;
    } else{
        // Error management of pass.
         return signalPassFailure();
    }
  }
};
} // namespace


// Expose pass to outside files/world.
// <CLASSNAME>Pass the coding convention appends `Pass` at end, be careful,
// don't use the classname containing Pass in it, I debugged for few hours.
std::unique_ptr<Pass> mlir::createDummyODSPass() {
  return std::make_unique<DummyODS>();
}