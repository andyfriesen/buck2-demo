
load(
    "@prelude//cxx:cxx_toolchain_types.bzl",
    "BinaryUtilitiesInfo",
    "CCompilerInfo",
    "CxxCompilerInfo",
    "CxxPlatformInfo",
    "CxxToolchainInfo",
    "LinkerInfo",
    "cxx_toolchain_infos",
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

load("@prelude//decls:core_rules.bzl", "http_archive")
load("@prelude//http_archive:http_archive.bzl", "http_archive_impl")

DEFAULT_MAKE_COMP_DB = "prelude//cxx/tools:make_comp_db"

# FIXME I couldn't figure out how to invoke the standard http_archive rule from this file.
_http_archive = rule(
    impl = http_archive_impl,
    attrs = http_archive.attrs,
)

TAR_PATH = "clang+llvm-16.0.0-x86_64-linux-gnu-ubuntu-18.04"

def _bin(src, name):
    f = "{}/bin/" + name
    return cmd_args(src, format = f)

def download_clang_dist(name, sha256, urls):
    archive_name = name + "-archive"
    # TODO: Figure out how to switch on the target OS.
    _http_archive(
        name = name,
        sha256 = sha256,
        urls = urls
    )

def _custom_clang_cxx_impl(ctx):
    src = cmd_args(ctx.attrs.distribution[DefaultInfo].default_outputs[0], format="{}/" + TAR_PATH)

    libcxx_options = [
        "-nostdlib++",
        "-nostdinc++",
        # cmd_args(src, format = "-isystem{}/include/c++/v1"),
        # cmd_args(src, format = "-isystem{}/include/x86_64-unknown-linux-gnu/c++/v1/"),
        # cmd_args(src, format = "-Wl,-rpath,{}/lib"),
    ]

    link_options = [
        "-fuse-ld=lld",
        # "-lc",
        # "-lc++",
        # "-stdlib=libc++",
        cmd_args(src, format = "-L/usr/lib"),
        cmd_args(src, format = "-L/usr/lib/x86_64-linux-gnu"),
        cmd_args(src, format = "-L{}/lib"),
        cmd_args(src, format = "-L{}/lib/x86_64-unknown-linux-gnu"),
    ]

    toolchain_infos = cxx_toolchain_infos(
        platform_name = "x86_64",
        header_mode = HeaderMode("symlink_tree_only"),
        c_compiler_info = CCompilerInfo(
            compiler = RunInfo(args = _bin(src, "clang")),
            compiler_type = "clang",
            compiler_flags = ctx.attrs.c_compiler_flags,
            preprocessor_flags = ctx.attrs.preprocessor_flags,
        ),
        cxx_compiler_info = CxxCompilerInfo(
            compiler = RunInfo(args = _bin(src, "clang++")),
            compiler_type = "clang",
            compiler_flags = libcxx_options + ctx.attrs.cxx_compiler_flags,
            preprocessor_flags = ctx.attrs.preprocessor_flags,
        ),
        linker_info = LinkerInfo(
            archiver = RunInfo(args = [_bin(src, "llvm-ar"), "rcs"]),
            archiver_type = "gnu",
            archiver_supports_argfiles = True,
            type = "gnu",
            binary_extension = "",
            generate_linker_maps = False,
            link_binaries_locally = True,
            link_libraries_locally = True,
            link_style = LinkStyle(ctx.attrs.link_style),
            link_weight = 1,
            linker = RunInfo(args = _bin(src, "clang++")),
            linker_flags = link_options + ctx.attrs.linker_flags,
            object_file_extension = "o",
            shlib_interfaces = "disabled",
            shared_library_name_format = "lib{}.so",
            shared_library_versioned_name_format = "lib{}.so.{}",
            static_library_extension = "a",
            use_archiver_flags = True,
            supports_pic = True,
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
    )

    return [DefaultInfo()] + toolchain_infos

custom_clang_cxx = rule(
    impl=_custom_clang_cxx_impl,
    attrs = {
        "distribution": attrs.exec_dep(providers=[DefaultInfo]),
        "make_comp_db": attrs.dep(providers = [RunInfo], default = DEFAULT_MAKE_COMP_DB),
        "c_compiler_flags": attrs.list(attrs.arg(), default = []),
        "cxx_compiler_flags": attrs.list(attrs.arg(), default = []),
        "preprocessor_flags": attrs.list(attrs.arg(), default = []),
        "linker_flags": attrs.list(attrs.arg(), default = []),
        "link_style": attrs.enum(LinkStyle.values(), default = "static"),
    },
    is_toolchain_rule = True
)
