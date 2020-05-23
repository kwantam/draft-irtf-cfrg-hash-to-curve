# vim: syntax=python
import hashlib

from hash_to_field import hash_to_field, expand_message_xmd, I2OSP
from sagelib.curves import EdwardsCurve
from sagelib.ell2_opt_5mod8 import map_to_curve_elligator2_edwards25519

p = 2^255 - 19
F = GF(p)
map = map_to_curve_elligator2_edwards25519

a = F(-1)       # a * v^2 + w^2 = 1 + d * v^2 * w^2
d = F(0x52036cee2b6ffe738cc740797779e89800700a4d4141d8ab75eb4dca135978a3)
E = EdwardsCurve(F, a, d)

def check_m2c(u, xp, yp):
    (xn, xd, yn, yd) = map(F(u))
    x = xn / xd
    y = yn / yd
    assert xp == x
    assert yp == y

def check_h2f(msg, dst, pseudo_random_bytes, t0, t1):
    prb2 = expand_message_xmd(msg, dst, 2 * 48, hashlib.sha256, 128)
    assert prb2 == pseudo_random_bytes
    t = hash_to_field(msg, 2, dst, p, 1, 48, expand_message_xmd, hashlib.sha256, 128)
    assert t == [[t0],[t1]]

def show_hex(v):
    vstr = "%64.64x" % int(v)
    for idx in range(0, len(vstr) // 2):
        print(",0x%s" % vstr[2 * idx : 2 * idx + 2], end="")

def show_h2c(msg, dst=b'RELIC'):
    ((t0,),(t1,)) = hash_to_field(msg, 2, dst, p, 1, 48, expand_message_xmd, hashlib.sha256, 128)
    (xn, xd, yn, yd) = map(F(t0))
    P1 = E(xn / xd, yn / yd)
    (xn, xd, yn, yd) = map(F(t1))
    P2 = E(xn / xd, yn / yd)
    (x, y, _) = 8 * (P1 + P2)
    print("{0x04", end="")
    show_hex(y)
    show_hex(x)
    print('}')
