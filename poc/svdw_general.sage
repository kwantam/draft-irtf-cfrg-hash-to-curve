#!/usr/bin/env sage
# vim: syntax=python

def pos_neg(ll):
    for l in ll:
        yield l
        if -l != l:
            yield -l

def gen_svdw(p, a, b):
    F = GF(p)
    a = F(a)
    b = F(b)
    f = lambda x: F(x)^3 + a * F(x) + b

    u0 = None
    for u0_cand in pos_neg(range(1, 1000)):
        u0_cand = F(u0_cand)
        f0 = f(u0_cand)
        if f0 == 0:
            continue

        w0_sq_cand = -F(4 * a + 3 * u0_cand^2) / F(4 * f0)
        if w0_sq_cand == 0 or not w0_sq_cand.is_square():
            continue

        if not f(-u0_cand / F(2)).is_square() and not f(u0_cand).is_square():
            continue

        u0 = u0_cand
        w0 = w0_sq_cand.sqrt()
        break

    if u0 is None:
        raise ValueError("could not find acceptable u0")

    z = lambda t: -F(2 * t * f0 * w0) / F(1 + t^2 * f0)
    w = lambda t: F(w0 + t * z(t))
    y = lambda t: 1 / w(t)
    v = lambda t: z(t) - u0 / F(2)
    x1 = lambda t: v(t)
    x2 = lambda t: -u0 - v(t)
    x3 = lambda t: u0 + y(t)^2

    return (F, f, u0, w0, f0, x1, x2, x3)
