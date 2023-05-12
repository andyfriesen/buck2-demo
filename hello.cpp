#include <iostream>

#include <string_view>
#include <string>

#include "txn_tables.h"

std::string lang;

int main(int argc, char** argv) {
    if (argc > 1) {
        if (std::string_view(argv[1]) == "en")
            lang = "en";
        else if (std::string_view(argv[1]) == "jp")
            lang = "jp";
    }

    if (lang == "en") {
        std::cout << en::hello << std::endl;
        std::cout << en::goodbye << std::endl;
    } else if (lang == "jp") {
        std::cout << jp::hello << std::endl;
        std::cout << jp::goodbye << std::endl;
    } else {
        std::cout << "Hello World!" << std::endl;
    }

    return 0;
}
