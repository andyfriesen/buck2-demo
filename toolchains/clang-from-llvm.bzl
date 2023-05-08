
load(
    "@prelude//cxx:cxx_toolchain_types.bzl",
    "BinaryUtilitiesInfo",
    "CCompilerInfo",
    "CxxCompilerInfo",
    "CxxPlatformInfo",
    "CxxToolchainInfo",
    "LinkerInfo",
)
load(
    "@prelude//cxx:headers.bzl",
    "HeaderMode",
)
load(
    "@prelude//cxx:linker.bzl",
    "is_pdb_generated",
)
load(
    "@prelude//linking:link_info.bzl",
    "LinkStyle",
)

load("@prelude//http_archive:http_archive.bzl", "http_archive_impl")

DEFAULT_MAKE_COMP_DB = "prelude//cxx/tools:make_comp_db"

# _http_archive = rule(
#     impl = http_archive,
#     attrs = {
#         "sha256": attrs.string(default = ""),
#         "urls": attrs.list(attrs.string(), default = []),
#     },
# )

def _bin(src, name):
    f = "{}/clang+llvm-16.0.0-x86_64-linux-gnu-ubuntu-18.04/bin/" + name
    return cmd_args(src, format = f)

def _custom_clang_cxx_impl(ctx):
    src = ctx.attrs.distribution[DefaultInfo].default_outputs[0]
    # dst = ctx.actions.declare_output("clang")

    # ctx.actions.run(['ln', '-srf', src, dst.as_output()], category = "cp_compiler")

    return [
        DefaultInfo(),
        CxxToolchainInfo(
            c_compiler_info = CCompilerInfo(
                compiler = RunInfo(args = _bin(src, "clang")),
                compiler_type = "clang",
            ),
            cxx_compiler_info = CxxCompilerInfo(
                compiler = RunInfo(args = _bin(src, "clang++")),
                compiler_type = "clang",
                compiler_flags = ctx.attrs.cxx_compiler_flags,
            ),
            linker_info = LinkerInfo(
                archiver = RunInfo(args = _bin(src, "llvm-ar")),
                archiver_type = "gnu",
                archiver_supports_argfiles = True,
                type = "gnu",
                binary_extension = "",
                generate_linker_maps = False,
                link_binaries_locally = False,
                link_libraries_locally = False,
                link_style = LinkStyle(ctx.attrs.link_style),
                link_weight = 1,
                linker = RunInfo(args = _bin(src, "lld")),
                linker_flags = ctx.attrs.linker_flags,
                object_file_extension = "o",
                shlib_interfaces = "disabled",
                shared_library_name_format = "lib{}.so",
                shared_library_versioned_name_format = "lib{}.so.{}",
                static_library_extension = "a",
                use_archiver_flags = True,
            ),
            binary_utilities_info = BinaryUtilitiesInfo(
                bolt_msdk = None,
                dwp = None,
                nm = RunInfo(args = _bin(src, "llvm-nm")),
                objcopy = RunInfo(args = _bin(src, "llvm-objcopy")),
                ranlib = RunInfo(args = _bin(src, "llvm-ranlib")),
                strip = RunInfo(args = _bin(src, "llvm-strip")),
            ),
            mk_comp_db = ctx.attrs.make_comp_db,
            bolt_enabled = False,
        ),
        CxxPlatformInfo(name = "x86_64"),
    ]

custom_clang_cxx = rule(
    impl=_custom_clang_cxx_impl,
    attrs = {
        "distribution": attrs.exec_dep(providers=[DefaultInfo]),
        "make_comp_db": attrs.dep(providers = [RunInfo], default = DEFAULT_MAKE_COMP_DB),
        "cxx_compiler_flags": attrs.list(attrs.arg(), default = []),
        "linker_flags": attrs.list(attrs.arg(), default = []),
        "link_style": attrs.enum(LinkStyle.values(), default = "static"),
    },
    is_toolchain_rule = True
)
