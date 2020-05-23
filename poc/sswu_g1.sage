# vim: syntax=python
import hashlib

from hash_to_field import hash_to_field, expand_message_xmd
from sagelib.svdw_generic import GenericSvdW
from sagelib.sswu_generic import GenericSSWU
from sagelib.iso_values import iso_bls12381g1

p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
F = GF(p)
a = 0x144698A3B8E9433D693A02C96D4982B0EA985383EE66A8D8E8981AEFD881AC98936F8DA0E0F97F5CF428082D584C1D
b = 0x12E2908D11688030018B12E8753EEE3B2016C1F0F24F4070A0B9C14FCEF35EF55A23215A316CEAA5D1CC48E98E172BE0
map = GenericSSWU(F, a, b)
iso_map = iso_bls12381g1()

Ell = EllipticCurve(F, [0, 4])

def check_m2c(u, xp, yp):
    P = Ell(xp, yp)
    Q = iso_map(map.E(*map.straight_line(F(u))))
    assert P == Q

def check_h2f(msg, dst, pseudo_random_bytes, t0, t1):
    prb2 = expand_message_xmd(msg, dst, 2 * 64, hashlib.sha256, 128)
    assert prb2 == pseudo_random_bytes
    t = hash_to_field(msg, 2, dst, p, 1, 64, expand_message_xmd, hashlib.sha256, 128)
    assert t == [[t0],[t1]]
