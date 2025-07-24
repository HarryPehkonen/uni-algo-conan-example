#include <iostream>
#include <string>
#include <iomanip>
#include <vector>
#include <algorithm>

// Include uni-algo headers based on configuration
#ifdef UNI_ALGO_HEADER_ONLY
    #include "uni_algo/all.h"
#else
    #include "uni_algo/all.h"
#endif

void print_hex_string(const std::string& str, const std::string& label) {
    std::cout << label << ": \"" << str << "\" (";
    for (size_t i = 0; i < str.size(); ++i) {
        if (i > 0) std::cout << " ";
        std::cout << "0x" << std::hex << std::setw(2) << std::setfill('0') 
                  << (static_cast<unsigned char>(str[i]) & 0xFF);
    }
    std::cout << std::dec << ")" << std::endl;
}

int main() {
    std::cout << "=== uni-algo Unicode Whitespace Trimming Example ===" << std::endl;
    std::cout << std::endl;
    
    // Test string with various Unicode whitespace characters
    // Regular space (U+0020), non-breaking space (U+00A0), em space (U+2003), 
    // thin space (U+2009), ideographic space (U+3000)
    std::string test_text = "   \u00A0\u2003Hello\u2009World\u3000\u00A0   ";
    
    std::cout << "Original text with various Unicode whitespace:" << std::endl;
    print_hex_string(test_text, "Input");
    std::cout << std::endl;
    
    // Demonstrate why regular C++ string trimming fails with Unicode
    std::cout << "Standard C++ approach (only trims ASCII spaces):" << std::endl;
    std::string cpp_trimmed = test_text;
    
    // Trim leading ASCII spaces
    size_t start = cpp_trimmed.find_first_not_of(" \t\n\r\f\v");
    if (start != std::string::npos) {
        cpp_trimmed = cpp_trimmed.substr(start);
    } else {
        cpp_trimmed.clear();
    }
    
    // Trim trailing ASCII spaces
    size_t end = cpp_trimmed.find_last_not_of(" \t\n\r\f\v");
    if (end != std::string::npos) {
        cpp_trimmed = cpp_trimmed.substr(0, end + 1);
    }
    
    print_hex_string(cpp_trimmed, "C++ result");
    std::cout << "Notice: Unicode whitespace characters remain!" << std::endl;
    std::cout << std::endl;
    
    // Now use uni-algo for proper Unicode whitespace trimming
    std::cout << "uni-algo Unicode-aware approach:" << std::endl;
    
    // Use uni-algo range views with Unicode-aware whitespace detection
    auto utf8_view = test_text | una::views::utf8;
    
    // Find first non-whitespace character using uni-algo's Unicode properties
    auto begin_it = std::find_if_not(utf8_view.begin(), utf8_view.end(), 
                                     [](char32_t cp) { return una::codepoint::is_whitespace(cp); });
    
    // Find last non-whitespace character  
    auto end_it = utf8_view.end();
    if (begin_it != end_it) {
        auto reverse_it = std::find_if_not(std::make_reverse_iterator(end_it), 
                                          std::make_reverse_iterator(begin_it),
                                          [](char32_t cp) { return una::codepoint::is_whitespace(cp); });
        end_it = reverse_it.base();
    }
    
    // Convert the trimmed range back to UTF-8 string
    std::u32string temp_u32;
    for (auto it = begin_it; it != end_it; ++it) {
        temp_u32.push_back(*it);
    }
    std::string unicode_trimmed = una::utf32to8(temp_u32);
    
    print_hex_string(unicode_trimmed, "uni-algo result");
    std::cout << "Perfect! All Unicode whitespace properly removed." << std::endl;
    std::cout << std::endl;
    
    // Show configuration info
    std::cout << "=== Build Configuration ===" << std::endl;
    #ifdef UNI_ALGO_HEADER_ONLY
        std::cout << "Configuration: Header-only library" << std::endl;
    #else
        std::cout << "Configuration: Compiled library (static/shared)" << std::endl;
    #endif
    
    return 0;
}