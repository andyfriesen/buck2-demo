# A list of available rules and their signatures can be found here: https://buck2.build/docs/generated/starlark/prelude/prelude.bzl

load('//rules:json_to_csv.bzl', 'json_to_csv')

json_to_csv(
    name="hello_csv",
    script="./json_to_csv.py",
    src="hello.json",
    out="hello.csv"
)

genrule(
    name = "hello_world",
    out = "out.txt",
    cmd = "echo BUILT BY BUCK2> $OUT",
)

cxx_binary(
    name="hello",
    srcs=["hello.cpp"],
    link_style='static'
)