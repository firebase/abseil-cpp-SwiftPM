// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "abseil",
  products: [
    .library(
      name: "abseil",
      targets: [
        "abseil",
      ]
    )
  ],

  targets: [
    .target(
      name: "abseil",
      path: ".",
      exclude: [
        // main functions
        "absl/base/c_header_test.c",
        "absl/hash/internal/print_hash_of.cc",
        "absl/random/internal/gaussian_distribution_gentables.cc",
        "absl/random/internal/randen_benchmarks.cc",
        // tests
        "absl/log/scoped_mock_log.cc",
        "absl/log/internal/test_helpers.cc",
        "absl/log/internal/test_matchers.cc",
        "absl/base/spinlock_test_common.cc",
        "absl/base/internal/exception_safety_testing.cc",
        "absl/random/benchmarks.cc",
        // .inc files
        "absl/debugging/internal/stacktrace_win32-inl.inc",
        "absl/debugging/internal/stacktrace_riscv-inl.inc",
        "absl/debugging/internal/stacktrace_generic-inl.inc",
        "absl/debugging/internal/stacktrace_unimplemented-inl.inc",
        "absl/debugging/internal/stacktrace_x86-inl.inc",
        "absl/debugging/internal/stacktrace_arm-inl.inc",
        "absl/debugging/internal/stacktrace_aarch64-inl.inc",
        "absl/debugging/internal/stacktrace_powerpc-inl.inc",
        "absl/debugging/internal/stacktrace_emscripten-inl.inc",
        "absl/debugging/symbolize_win32.inc",
        "absl/debugging/symbolize_emscripten.inc",
        "absl/debugging/symbolize_unimplemented.inc",
        "absl/debugging/symbolize_elf.inc",
        "absl/debugging/symbolize_darwin.inc",
        "absl/time/internal/get_current_time_chrono.inc",
        "absl/time/internal/get_current_time_posix.inc",
        "absl/numeric/int128_have_intrinsic.inc",
        "absl/numeric/int128_no_intrinsic.inc",
        "absl/log/log_basic_test_impl.inc",
        "absl/log/check_test_impl.inc",
        "absl/base/internal/spinlock_akaros.inc",
        "absl/base/internal/spinlock_linux.inc",
        "absl/base/internal/spinlock_posix.inc",
        "absl/base/internal/spinlock_win32.inc",
        // other files
        "absl/flags/flag_benchmark.lds",
        "absl/abseil.podspec.gen.py",
      ],
      sources: [
        "absl/"
      ],
      resources: [
        .copy("PrivacyInfo.xcprivacy"),
      ],
      publicHeadersPath: ".",
      cSettings: [
        .headerSearchPath("./"),
      ],
      linkerSettings: [
        .linkedFramework("CoreFoundation"),
      ]
    ),
    .testTarget(
      name: "build-test",
      dependencies: [
        "abseil",
      ],
      path: "SwiftPMTests/build-test"
    ),
  ],

  cxxLanguageStandard: .cxx17
)

