#!/bin/bash
BUDDY_OPT := ../../build/bin/buddy-opt
MLIR_OPT := ../../llvm/build/bin/mlir-opt
MLIR_TRANSLATE := ../../llvm/build/bin/mlir-translate
MLIR_CPU_RUNNER := ../../llvm/build/bin/mlir-cpu-runner
LLC := ../../llvm/build/bin/llc
OPT_FLAG := -O0

ifeq ($(shell uname),Linux)
MLIR_RUNNER_UTILS := ../../llvm/build/lib/libmlir_runner_utils.so
MLIR_C_RUNNER_UTILS := ../../llvm/build/lib/libmlir_c_runner_utils.so
MLIR_ASYNC_RUNTIME := ../../llvm/build/lib/libmlir_async_runtime.so
MTRIPLE := x86_64-unknown-linux-gnu
else ifeq ($(shell uname),Darwin)
MLIR_RUNNER_UTILS := ../../llvm/build/lib/libmlir_runner_utils.dylib
MLIR_C_RUNNER_UTILS := ../../llvm/build/lib/libmlir_c_runner_utils.dylib
MLIR_ASYNC_RUNTIME := ./../llvm/build/lib/libmlir_async_runtime.dylib
MTRIPLE := x86_64-apple-darwin
endif

memref-oob-global-lower:
	@${MLIR_OPT} ./memref-oob-global.mlir \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts \
		-o ./log.mlir

memref-oob-global-translate:
	@${MLIR_OPT} ./memref-oob-global.mlir \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_TRANSLATE} --mlir-to-llvmir -o log.ll

memref-oob-global-run:
	@${MLIR_OPT} ./memref-oob-global.mlir --lower-affine  \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_CPU_RUNNER} ${OPT_FLAG} -e main -entry-point-result=i32 \
		-shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}

memref-oob-alloca-lower:
	@${MLIR_OPT} ./memref-oob-alloca.mlir \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts \
		-o ./log.mlir

memref-oob-alloca-translate:
	@${MLIR_OPT} ./memref-oob-alloca.mlir \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_TRANSLATE} --mlir-to-llvmir -o log.ll

memref-oob-alloca-run:
	@${MLIR_OPT} ./memref-oob-alloca.mlir --lower-affine  \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_CPU_RUNNER} ${OPT_FLAG} -e main -entry-point-result=i32 \
		-shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}

memref-oob-alloc-lower:
	@${MLIR_OPT} ./memref-oob-alloc.mlir \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts \
		-o ./log.mlir

memref-oob-alloc-translate:
	@${MLIR_OPT} ./memref-oob-alloc.mlir \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_TRANSLATE} --mlir-to-llvmir -o log.ll

memref-oob-alloc-run:
	@${MLIR_OPT} ./memref-oob-alloc.mlir --lower-affine  \
		-convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm  \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_CPU_RUNNER} ${OPT_FLAG} -e main -entry-point-result=i32 \
		-shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}
