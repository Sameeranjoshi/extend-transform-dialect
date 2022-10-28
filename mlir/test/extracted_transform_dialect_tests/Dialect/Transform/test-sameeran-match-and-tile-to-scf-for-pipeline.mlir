// RUN: mlir-opt %s --test-transform-dialect-interpreter -allow-unregistered-dialect --split-input-file --verify-diagnostics



//func.func @static_pad_tile_evenly_0_3(%input_tensor: tensor<7x9xf32>,
//                             %output_tensor: tensor<14x15xf32>,
//                             %pad_value: f32) -> tensor<14x15xf32> {
//  %0 = tensor.pad %input_tensor low[0, 0] high[7, 6] {
//    ^bb0(%arg1: index, %arg2: index):
//      tensor.yield %pad_value : f32
//    } : tensor<7x9xf32> to tensor<14x15xf32>
//  return %0 : tensor<14x15xf32>
//}

// Try simple tensor 2D to tile_to_scf_for
//func.func @tile_to_scf_for_2d_matrix(%input_tensor: tensor<3x3xf32>) -> () {
//  %array_a = arith.constant dense<[[1.000000e+00, 2.000000e+00, 3.000000e+00], [4.000000e+00, 5.000000e+00, 6.000000e+00], [7.000000e+00, 8.000000e+00, 9.000000e+00]]> : tensor<3x3xf32>
//  return
//  //return %array_a : tensor<3x3xf32>
//}
//
//transform.sequence failures(propagate) {
//  ^bb0(%arg1: !pdl.operation):
//    %0 = transform.structured.match ops{["arith.constant"]} in %arg1
////    %loop:3 = transform.structured.tile_to_scf_for %0 [2, 3]
//    transform.structured.tile_to_scf_for %0 [1, 1, 1]
//}



func.func @dynamic_pad_tensor_3_4(%input_tensor: tensor<1x1xf32>,
                         %pad_value: f32) -> tensor<2x2xf32> {
  %0 = tensor.pad %input_tensor low[0, 0] high[1, 1] {
    ^bb0(%arg1: index, %arg2: index):
      tensor.yield %pad_value : f32
    } : tensor<1x1xf32> to tensor<2x2xf32>
  return %0 : tensor<2x2xf32>
}

transform.sequence failures(propagate) {
  ^bb0(%arg1: !pdl.operation):
    %0 = transform.structured.match ops{["tensor.pad"]} in %arg1
    %1, %loops:2 = transform.structured.tile_to_scf_for %0 [2, 2]
}

