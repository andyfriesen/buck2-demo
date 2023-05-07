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