
txn_tables.h: build_txn_tables.py
	python3 build_txn_tables.py en.json jp.json -o txn_tables.h

hello: hello.cpp
	clang++-15 -std=c++17 hello.cpp -o hello

.PHONY: clean
clean:
	rm hello txn_tables.h

.PHONY: all
all: txn_tables.h hello
