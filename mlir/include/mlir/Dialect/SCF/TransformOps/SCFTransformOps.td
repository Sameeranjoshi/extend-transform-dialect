//===- SCFTransformOps.td - SCF (loop) transformation ops --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef SCF_TRANSFORM_OPS
#define SCF_TRANSFORM_OPS

include "mlir/Dialect/Transform/IR/TransformDialect.td"
include "mlir/Dialect/Transform/IR/TransformEffects.td"
include "mlir/Dialect/Transform/IR/TransformInterfaces.td"
include "mlir/Dialect/Transform/IR/TransformTypes.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/OpBase.td"

def Transform_ScfForOp : Transform_ConcreteOpType<"scf.for">;

def GetParentForOp : Op<Transform_Dialect, "loop.get_parent_for",
    [NavigationTransformOpTrait, MemoryEffectsOpInterface,
     DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Gets a handle to the parent 'for' loop of the given operation";
  let description = [{
    Produces a handle to the n-th (default 1) parent `scf.for` or `affine.for`
    (when the affine flag is true) loop for each Payload IR operation
    associated with the operand. Fails if such a loop cannot be found. The list
    of operations associated with the handle contains parent operations in the
    same order as the list associated with the operand, except for operations
    that are parents to more than one input which are only present once.
  }];

  let arguments =
    (ins TransformTypeInterface:$target,
         DefaultValuedAttr<ConfinedAttr<I64Attr, [IntPositive]>,
                           "1">:$num_loops,
         DefaultValuedAttr<BoolAttr, "false">:$affine);
  let results = (outs TransformTypeInterface : $parent);

  let assemblyFormat =
    "$target attr-dict `:` functional-type(operands, results)";
}

def GetChildForOp : Op<Transform_Dialect, "loop.get_child_for", 
  [ NavigationTransformOpTrait, MemoryEffectsOpInterface, 
    DeclareOpInterfaceMethods<TransformOpInterface>]> {
  
  let summary = "This operation gets the child for loop and works only on scf dialect.";
  let description = [{
    # This is markdown definition of the operation of the dialect.
    The aim is just to test and play with writing a simple dialect in the transform dialect 
    targetting the SCF dialect specifically mimicing the `loop.get_parent_for` and trying to get the 
    opposite version of it with getting the handle to child for loop.
    This activity helps to understand the end-to-end flow of adding a new operation in Transform dialect.
  }];
  
  // This wants me to give 2 things
  // input argument and attribute
  // 1. decide names.
  // 2. decide their types

  let arguments = (ins 
                  TransformTypeInterface:$target // target is the name, 
                  // No argument for this Op.
                  );
  let results = (outs TransformTypeInterface:$child); // Note this returns the child loop
  // Did not understand how to write but move on for now.
  let assemblyFormat =
    "$target attr-dict `:` functional-type(operands, results)";
  // BOol vars

  // Custom things
}

def LoopOutlineOp : Op<Transform_Dialect, "loop.outline",
    [FunctionalStyleTransformOpTrait, MemoryEffectsOpInterface,
     DeclareOpInterfaceMethods<TransformOpInterface>]> {
  let summary = "Outlines a loop into a named function";
  let description = [{
     Moves the loop into a separate function with the specified name and
     replaces the loop in the Payload IR with a call to that function. Takes
     care of forwarding values that are used in the loop as function arguments.
     If the operand is associated with more than one loop, each loop will be
     outlined into a separate function. The provided name is used as a _base_
     for forming actual function names following SymbolTable auto-renaming
     scheme to avoid duplicate symbols. Expects that all ops in the Payload IR
     have a SymbolTable ancestor (typically true because of the top-level
     module). Returns the handle to the list of outlined functions in the same
     order as the operand handle.
  }];

  // Note that despite the name of the transform operation and related utility
  // functions, the actual implementation does not require the operation to be
  // a loop.
  let arguments = (ins TransformTypeInterface:$target,
                   StrAttr:$func_name);
  let results = (outs TransformTypeInterface:$transformed);

  let assemblyFormat =
    "$target attr-dict `:` functional-type(operands, results)";
}

def LoopPeelOp : Op<Transform_Dialect, "loop.peel",
    [FunctionalStyleTransformOpTrait, MemoryEffectsOpInterface,
     TransformOpInterface, TransformEachOpTrait]> {
  let summary = "Peels the last iteration of the loop";
  let description = [{
     Updates the given loop so that its step evenly divides its range and puts
     the remaining iteration into a separate loop or a conditional.

     In the absence of sufficient static information, this op may peel a loop,
     even if the step always divides the range evenly at runtime.

     #### Return modes

     This operation ignores non-scf::ForOp ops and drops them in the return.

     This operation always succeeds and returns the scf::ForOp with the
     postcondition: "the loop trip count is divisible by the step".
     This operation may return the same unmodified loop handle when peeling did
     not modify the IR (i.e. the loop trip count was already divisible).

     Note that even though the Payload IR modification may be performed
     in-place, this operation consumes the operand handle and produces a new
     one.

     TODO: Return both the peeled loop and the remainder loop.
  }];

  let arguments =
      (ins Transform_ScfForOp:$target,
           DefaultValuedAttr<BoolAttr, "false">:$fail_if_already_divisible);
  // TODO: Return both the peeled loop and the remainder loop.
  let results = (outs TransformTypeInterface:$transformed);

  let assemblyFormat =
    "$target attr-dict `:` functional-type(operands, results)";

  let extraClassDeclaration = [{
    ::mlir::DiagnosedSilenceableFailure applyToOne(
        ::mlir::scf::ForOp target,
        ::llvm::SmallVector<::mlir::Operation *> &results,
        ::mlir::transform::TransformState &state);
  }];
}

def LoopPipelineOp : Op<Transform_Dialect, "loop.pipeline",
    [FunctionalStyleTransformOpTrait, MemoryEffectsOpInterface,
     TransformOpInterface, TransformEachOpTrait]> {
  let summary = "Applies software pipelining to the loop";
  let description = [{
    Transforms the given loops one by one to achieve software pipelining for
    each of them. That is, performs some amount of reads from memory before the
    loop rather than inside the loop, the same amount of writes into memory
    after the loop, and updates each iteration to read the data for a following
    iteration rather than the current one.

    The amount is specified by the attributes.

    The values read and about to be stored are transferred as loop iteration
    arguments. Currently supports memref and vector transfer operations as
    memory reads/writes.

    #### Return modes

    This operation ignores non-scf::For ops and drops them in the return.
    If all the operations referred to by the `target` PDLOperation pipeline
    properly, the transform succeeds. Otherwise the transform silently fails.
    The return handle points to only the subset of successfully produced
    pipelined loops, which can be empty.
  }];

  let arguments = (ins Transform_ScfForOp:$target,
                   DefaultValuedAttr<I64Attr, "1">:$iteration_interval,
                   DefaultValuedAttr<I64Attr, "10">:$read_latency);
  let results = (outs TransformTypeInterface:$transformed);

  let assemblyFormat =
    "$target attr-dict `:` functional-type(operands, results)";

  let extraClassDeclaration = [{
    ::mlir::DiagnosedSilenceableFailure applyToOne(
        ::mlir::scf::ForOp target,
        ::llvm::SmallVector<::mlir::Operation *> &results,
        ::mlir::transform::TransformState &state);
  }];
}

def LoopUnrollOp : Op<Transform_Dialect, "loop.unroll",
    [FunctionalStyleTransformOpTrait, MemoryEffectsOpInterface,
     TransformOpInterface, TransformEachOpTrait]> {
  let summary = "Unrolls the given loop with the given unroll factor";
  let description = [{
    Unrolls each loop associated with the given handle to have up to the given
    number of loop body copies per iteration. If the unroll factor is larger
    than the loop trip count, the latter is used as the unroll factor instead.

    #### Return modes

    This operation ignores non-scf::For, non-affine::For ops and drops them in
    the return.  If all the operations referred to by the `target` PDLOperation
    unroll properly, the transform succeeds. Otherwise the transform silently
    fails.

    Does not return handles as the operation may result in the loop being
    removed after a full unrolling.
  }];

  let arguments = (ins TransformTypeInterface:$target,
                       ConfinedAttr<I64Attr, [IntPositive]>:$factor);

  let assemblyFormat = "$target attr-dict `:` type($target)";

  let extraClassDeclaration = [{
    ::mlir::DiagnosedSilenceableFailure applyToOne(
        ::mlir::Operation *target,
        ::llvm::SmallVector<::mlir::Operation *> &results,
        ::mlir::transform::TransformState &state);
  }];
}
/*
    [DeclareOpInterfaceMethods<MemoryEffectsOpInterface>,
     DeclareOpInterfaceMethods<TransformOpInterface>]> {

       [FunctionalStyleTransformOpTrait, MemoryEffectsOpInterface,
     TransformOpInterface, TransformEachOpTrait]> {
*/

/*def LoopInterchangeOp : Op<Transform_Dialect, "loop.interchange",
    [ NavigationTransformOpTrait, MemoryEffectsOpInterface, 
    DeclareOpInterfaceMethods<TransformOpInterface>]> {

//def LoopInterchangeOp : Op<Transform_Dialect, "loop.interchange",
 //   [FunctionalStyleTransformOpTrait, MemoryEffectsOpInterface,
   // TransformOpInterface]> {
  
  let summary = "This operation does loop interchange on scf dialect at very naive level.";
  let description = [{
    # Code without applying interchange.
    ```
    scf.for %i = 0 to %n step %1{
      scf.for %j = 0 to %m step %1 {

      }
    }
    ```
    `Applying transform.interchange %outer %inner`

    # Code after applying interchange.
    ```
    scf.for %j = 0 to %m step %1{
      scf.for %i = 0 to %n step %1 {

      }
    }
    ```

    The code is naive version.
    1. No dependence checks.
    2. Simple rectangular loops.
    3. Loops should be nested perfectly.
    4. %inner and %outer should be from the same loop nest and can't be from 2 different loop nests.
    5. As of now only on 2 loop levels, not thinking from `n` loop nest perspective.

  }];

  let arguments = (ins 
                  Transform_ScfForOp:$loop_one_handle,  // 1st loop
                  Transform_ScfForOp:$loop_two_handle  // 2nd loop
                  // No attributes for this Op.
                  );

  let assemblyFormat = "$loop_one_handle $loop_two_handle attr-dict `:` type($loop_one_handle) `,` type($loop_two_handle)";                  
/*
  let extraClassDeclaration = [{
    ::mlir::DiagnosedSilenceableFailure applyOnTwoLoops(
        ::mlir::scf::ForOp loop_one_handle,
        ::mlir::scf::ForOp loop_two_handle,
        ::llvm::SmallVector<::mlir::Operation *> &results,
        ::mlir::transform::TransformState &state);
  }];*/
}*/
#endif // SCF_TRANSFORM_OPS
