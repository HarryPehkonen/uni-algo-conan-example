#include <iostream>
#include <string>
#include <iomanip>

// Include uni-algo headers for header-only mode
#include "uni_algo/all.h"

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
    std::cout << "=== uni-algo Header-Only Example ===" << std::endl;
    std::cout << std::endl;
    
    // Test Unicode conversion functionality that works in header-only mode
    std::cout << "Demonstrating uni-algo features available in header-only mode:" << std::endl;
    std::cout << std::endl;
    
    // 1. UTF-8 to UTF-16 conversion
    std::string utf8_text = "Hello 世界! 🌍";
    std::cout << "1. UTF-8 to UTF-16 conversion:" << std::endl;
    print_hex_string(utf8_text, "UTF-8 input");
    
    std::u16string utf16_result = una::utf8to16u(utf8_text);
    std::cout << "UTF-16 output: ";
    for (size_t i = 0; i < utf16_result.size(); ++i) {
        if (i > 0) std::cout << " ";
        std::cout << "0x" << std::hex << std::setw(4) << std::setfill('0') << utf16_result[i];
    }
    std::cout << std::dec << std::endl << std::endl;
    
    // 2. UTF-16 back to UTF-8
    std::cout << "2. UTF-16 back to UTF-8 conversion:" << std::endl;
    std::string utf8_roundtrip = una::utf16to8(utf16_result);
    print_hex_string(utf8_roundtrip, "Round-trip result");
    std::cout << "Match original: " << (utf8_text == utf8_roundtrip ? "✓ Yes" : "✗ No") << std::endl;
    std::cout << std::endl;
    
    // 3. Code point validation and basic analysis
    std::cout << "3. Code point validation:" << std::endl;
    std::string mixed_text = "A🌍中";
    print_hex_string(mixed_text, "Mixed text");
    
    auto utf8_view = mixed_text | una::views::utf8;
    std::cout << "Code points: ";
    for (auto codepoint : utf8_view) {
        std::cout << "U+" << std::hex << std::uppercase << codepoint << " ";
    }
    std::cout << std::dec << std::endl;
    std::cout << std::endl;
    
    // 4. UTF-32 string handling
    std::cout << "4. UTF-32 string creation and conversion:" << std::endl;
    std::u32string utf32_text = U"Hello 世界!";
    std::cout << "UTF-32 code points: ";
    for (auto codepoint : utf32_text) {
        std::cout << "U+" << std::hex << std::uppercase << codepoint << " ";
    }
    std::cout << std::dec << std::endl;
    
    std::string utf8_converted = una::utf32to8(utf32_text);
    print_hex_string(utf8_converted, "Converted to UTF-8");
    std::cout << std::endl;
    
    // Document the limitation
    std::cout << "=== Header-Only Mode Limitations ===" << std::endl;
    std::cout << "✓ Available: UTF conversions, range views, code point iteration" << std::endl;
    std::cout << "✗ NOT available: Unicode property checking (is_whitespace, etc.)" << std::endl;
    std::cout << "✗ NOT available: Advanced Unicode normalization" << std::endl;
    std::cout << "✗ NOT available: Case conversion (requires Unicode data)" << std::endl;
    std::cout << "✗ NOT available: Locale-aware operations" << std::endl;
    std::cout << std::endl;
    std::cout << "For advanced Unicode operations like proper whitespace trimming," << std::endl;
    std::cout << "use the static or shared library configurations." << std::endl;
    std::cout << std::endl;
    
    // Show configuration info
    std::cout << "=== Build Configuration ===" << std::endl;
    std::cout << "Configuration: Header-only library" << std::endl;
    
    return 0;
}