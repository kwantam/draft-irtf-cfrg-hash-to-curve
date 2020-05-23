#!/usr/bin/python

import hashlib
from hash_to_field import expand_message_xmd

test1 = ("abc", "", 16)
test2 = ("abcdbcdecdefdefgefghfghighijhi", "jkijkljklmklmnlmnomnopnopq", 37)
test3 = ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", 57)
test4 = ("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmn", "hijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu", 75)

for h in (hashlib.sha224, hashlib.sha256, hashlib.sha384, hashlib.sha512):
    print("uint8_t result_xmd_%s[4][75] = {" % h().name)
    for t in (test1, test2, test3, test4):
        expect = expand_message_xmd(t[0], t[1], t[2], h, 0)
        print("    {" + ",".join( "0x%02X" % b for b in expect ), end="")
        if t[2] < 75:
            print("," + ",".join( "0x00" for _ in range(0, 75 - t[2]) ), end="")
        print("},")
    print("};")
