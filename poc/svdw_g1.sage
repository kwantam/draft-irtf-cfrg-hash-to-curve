# vim: syntax=python
import hashlib

from hash_to_field import hash_to_field, expand_message_xmd
from sagelib.svdw_generic import GenericSvdW

p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
F = GF(p)
a = 0
b = 4
map = GenericSvdW(F, a, b)

def check_m2c(u, xp, yp):
    P = map.E(xp, yp)
    Q = map.E(*map.straight_line(F(u)))
    assert P == Q

def check_h2f(msg, dst, pseudo_random_bytes, t0, t1):
    prb2 = expand_message_xmd(msg, dst, 2 * 64, hashlib.sha256, 128)
    assert prb2 == pseudo_random_bytes
    t = hash_to_field(msg, 2, dst, p, 1, 64, expand_message_xmd, hashlib.sha256, 128)
    assert t == [[t0],[t1]]
