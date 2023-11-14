#include <stdio.h>
#include <stdlib.h>

// Function to convert Unicode to UTF-8
char* unicodeToUTF8(const wchar_t* unicode) {
    int len = 0;
    int i = 0;

    // Calculate the length of the UTF-8 string
    while (unicode[i] != L'\0') {
        if (unicode[i] <= 0x007F) {
            len += 1;
        } else if (unicode[i] <= 0x07FF) {
            len += 2;
        } else if (unicode[i] <= 0xFFFF) {
            len += 3;
        } else {
            len += 4;
        }
        i++;
    }

    // Allocate memory for the UTF-8 string
    char* utf8 = (char*)malloc((len + 1) * sizeof(char));
    utf8[len] = '\0';

    // Convert each Unicode character to UTF-8
    i = 0;
    int j = 0;
    while (unicode[i] != L'\0') {
        if (unicode[i] <= 0x007F) {
            utf8[j++] = (char)unicode[i++];
        } else if (unicode[i] <= 0x07FF) {
            utf8[j++] = (char)(((unicode[i] >> 6) & 0x1F) | 0xC0);
            utf8[j++] = (char)((unicode[i] & 0x3F) | 0x80);
            i++;
        } else if (unicode[i] <= 0xFFFF) {
            utf8[j++] = (char)(((unicode[i] >> 12) & 0x0F) | 0xE0);
            utf8[j++] = (char)(((unicode[i] >> 6) & 0x3F) | 0x80);
            utf8[j++] = (char)((unicode[i] & 0x3F) | 0x80);
            i++;
        } else {
            utf8[j++] = (char)(((unicode[i] >> 18) & 0x07) | 0xF0);
            utf8[j++] = (char)(((unicode[i] >> 12) & 0x3F) | 0x80);
            utf8[j++] = (char)(((unicode[i] >> 6) & 0x3F) | 0x80);
            utf8[j++] = (char)((unicode[i] & 0x3F) | 0x80);
            i++;
        }
    }

    return utf8;
}

int main() {
    // Test the function
    wchar_t unicode[] = L"鄨氤窄顮鞶臣镧痔燔褿传沂脥翙殨冤偧涘澏鑀躲鳽畠芤覌仞纒伹賟输挣缝堢恈樸诖片";
    char* utf8 = unicodeToUTF8(unicode);
    printf("%s\n", utf8);

    free(utf8);
    return 0;
}