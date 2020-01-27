#!/bin/bash

echo '======== STRINGS WITHOUT CONSTANT INTEGER ========'

./firstconst 'wiktor' 'rotwik' 'abbab'

echo ''

echo '======== TEST HEXADECIMAL ========================'

./firstconst 'wiktor 123h'
./firstconst '321h wiktor'
./firstconst '0ah' '0Ah'
./firstconst '0h'
./firstconst 'wiktor 123abfh' 'WIKTOR 123ABFh' 'wiktor 123AbFh' '00112a32ah'
./firstconst 'lorem ipsum 0aBc1ABc2h'

echo ''

echo '======== TEST DECIMAL ============================'

./firstconst 'wiktor 123d' 'wiktor 123' '123' '2'

echo ''

echo '======== TEST OCTAL =============================='

./firstconst 'wiktor 123q' '321o wiktor' '7o' '7q' '129q wiktor 711q'

echo ''

echo '======== TEST BINARY ============================='

./firstconst 'wiktor 101b' '0101111b wiktor' '101b' '1b' '102b wiktor 02b 1000b'

echo ''

echo '======= Other tests ============================='
echo ''
echo 'Returns hexadecimal'
./firstconst '0101bh' '010121b ECOAR 123h'

echo ''
echo 'Returns decimal'
./firstconst '1231312abc' '01100313adad1231ff'

