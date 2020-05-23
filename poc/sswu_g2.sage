# vim: syntax=python
import hashlib

from hash_to_field import hash_to_field, expand_message_xmd
from sagelib.svdw_generic import GenericSvdW
from sagelib.sswu_generic import GenericSSWU
from sagelib.iso_values import iso_bls12381g2

iso_map = iso_bls12381g2()
p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
F2 = iso_map.domain().base_field()
X = F2.gen()
a = 240 * X
b = 1012 * (1 + X)
map = GenericSSWU(F2, a, b)

Ell = EllipticCurve(F2, [0, 4 * (1 + X)])

def check_m2c(u0, u1, xp0, xp1, yp0, yp1):
    xp = xp0 + X * xp1
    yp = yp0 + X * yp1
    u = u0 + X * u1
    P = Ell(xp, yp)
    Q = iso_map(map.E(*map.straight_line(u)))
    assert P == Q

def check_h2f(msg, dst, pseudo_random_bytes, t00, t01, t10, t11):
    prb2 = expand_message_xmd(msg, dst, 4 * 64, hashlib.sha256, 128)
    assert prb2 == pseudo_random_bytes
    t = hash_to_field(msg, 2, dst, p, 2, 64, expand_message_xmd, hashlib.sha256, 128)
    assert t == [[t00, t01],[t10, t11]]
