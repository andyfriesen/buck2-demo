# A list of available rules and their signatures can be found here: https://buck2.build/docs/generated/starlark/prelude/prelude.bzl

load(":weirdstuff.bzl", "tests")

tests(name = "tests")

python_library(
    name='json_to_csv_lib',
    srcs=['json_to_csv.py']
)

python_binary(
    name='json_to_csv',
    main_module='json_to_csv',
    deps=[':json_to_csv_lib']
)

genrule(
    name='hello_csv',
    out='hello.csv',
    srcs=['hello.json'],
    cmd='$(exe :json_to_csv) $SRCS $OUT'
)

cxx_binary(
    name="hello",
    srcs=["hello.cpp"],
    link_style='static'
)


http_archive(
    name = "clang-16-linux-archive",
    sha256 = "2b8a69798e8dddeb57a186ecac217a35ea45607cb2b3cf30014431cff4340ad1",
    urls = [
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.0/clang+llvm-16.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
    ]
)
