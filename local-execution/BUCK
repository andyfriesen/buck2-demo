
python_library(
    name="build_txn_tables_library",
    srcs=["build_txn_tables.py"],
)

python_binary(
    name="build_txn_tables",
    main_module="build_txn_tables",
    deps=[":build_txn_tables_library"]
)

genrule(
    name="txn_tables_h",
    srcs=["en.json", "jp.json"],
    out="txn_tables.h",
    cmd='$(exe :build_txn_tables) $SRCS -o $OUT',
    remote=False
)

cxx_binary(
    name="hello",
    headers=[":txn_tables_h"],
    srcs=["hello.cpp"],
    link_style='static'
)
