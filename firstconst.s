;Created by Wiktor Lazarski - 22/01/2020

    section .text
    global firstconst

firstconst:
;============ PROLOG ====================
    push    ebp
    mov     ebp, esp
    push    ebx
    push    edi
 
;============ BODY ======================
    mov     eax, [ebp+8]

;Step 1 : Finding first substring of digits
find_uint:
    mov     dl, [eax]
    test    dl, dl
    jz      uint_not_found

    inc     eax
;is_digit() == true
    cmp     dl, '9'
    jg      find_uint
    cmp     dl, '0'
    jge     first_digit
    jmp     find_uint

first_digit:
    mov     ebx, eax
    dec     eax             ;restore eax so that it points to the first digit
    
find_last_digit:
    mov     dl, [ebx]
    inc     ebx

    cmp     dl, '9'
    jg      check_suffix
    cmp     dl, '0'
    jge     find_last_digit

;Step 2 : Check suffix and determine the conversion algorithm
check_suffix:   
    dec     ebx             ;restore ebx so that it points to the last digit    
    mov     dh, dl          ;store current char after sequence of digits

;is_hexadecimal == true
    cmp     dh, 'h'
    je      convert_hexadecimal
    cmp     dh, 'f'
    jg      is_octal
    cmp     dh, 'a'
    jl      is_octal
;can be a hexadecimal value because letter after sequence is in range [a-f]
    mov     ecx, ebx
    inc     ecx
find_next_hex_digit:
    mov     dl, [ecx]
    inc     ecx
;end_of_str() == true
    test    dl, dl
    jz      is_octal
    cmp     dl, 'f'
    jg      check_if_digit
    cmp     dl, 'a'
    jge     find_next_hex_digit     ;in range [a-f]

check_if_digit:
    cmp     dl, '9'
    jg      check_hex_suffix        ;is_hex_digit() == false goto checking new suffix
    cmp     dl, '0'
    jge     find_next_hex_digit     ;is in range [0-9] so goto checking next character   

check_hex_suffix:
    cmp     dl, 'h'
    je      swap_addresses_of_hex

is_octal:
;is_octal() == true  
    cmp     dh, 'q'
    je      convert_octal
    cmp     dh, 'o'
    je      convert_octal

;is_binary() == true
    cmp     dh, 'b'
    je      convert_binary  

;the previous systems where not identified therefore it must be decimal
    jmp     convert_decimal
    
;Step 3 : Convert string to integer using proper algorithm
swap_addresses_of_hex:  ;after procceding in finding hex digits we ned to chang end ptr but not always
    dec     ecx
    mov     ebx, ecx
convert_hexadecimal:
    mov     ecx, eax    ;ecx holds begging and ebx end
    xor     eax, eax
    xor     edx, edx
convert_hex:
    mov     dl, [ecx]
;is_small_char() to determine if I need to substract '0' or 'a' from character to convert it to int
    cmp     dl, '9'
    jg      small_char

    sub     dl, '0'
    jmp     continue_hex_convertion

small_char:
    sub     dl, 'a'
    add     dl, 10

continue_hex_convertion:
    add     eax, edx
    inc     ecx
    cmp     ebx, ecx    ;checks if end of convertion process
    je      epilog
    sal     eax, 4
    jmp     convert_hex

convert_decimal:
    mov     ecx, eax    ;ecx holds begging and ebx end
    xor     eax, eax
    mov     edi, 10     ;holds base of system for multiplication
    xor     edx, edx
convert_dec:
    mov     dl, [ecx]
    sub     dl, '0'
    add     eax, edx
    inc     ecx
    cmp     ebx, ecx    ;checks if end of convertion process
    je      epilog
    mul     edi
    jmp     convert_dec

convert_octal:
    mov     ecx, eax    ;ecx holds begging and ebx end
    mov     edi, eax    ;preserve pointer to first in case of an error
    xor     eax, eax
    xor     edx, edx
convert_oct:
    mov     dl, [ecx]
    cmp     dl, '8'
    jge     restart_process

    sub     dl, '0'
    add     eax, edx
    inc     ecx
    cmp     ebx, ecx    ;checks if end of convertion process
    je      epilog
    sal     eax, 3
    jmp     convert_oct

convert_binary:
    mov     ecx, eax    ;ecx holds begging and ebx end
    mov     edi, eax    ;preserve pointer to first in case of an error
    xor     eax, eax
    xor     edx, edx
convert_bin:
    mov     dl, [ecx]
    cmp     dl, '2'
    jge     restart_process

    sub     dl, '0'
    add     eax, edx
    inc     ecx
    cmp     ebx, ecx    ;checks if end of convertion process
    je      epilog
    sal     eax, 1
    jmp     convert_bin

restart_process: ;if digit in binary or octal does not fit to system restart process
    mov     eax, edi
    jmp     convert_decimal

uint_not_found:         ;returns 0 if string does not contain any integer
    mov     eax, 0

epilog:
;============ EPILOG ====================
    pop     edi
    pop     ebx
    pop     ebp
    ret