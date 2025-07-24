#include <iostream>
#include <filesystem>

int main(){
    std::filesystem::path current_path = std::filesystem::current_path();
    std::cout << "Current directory: " << current_path << std::endl;
    return 0;
}
