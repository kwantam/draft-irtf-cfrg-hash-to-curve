from sagelib.svdw_generic import GenericSvdW
p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
F = GF(p)
map = GenericSvdW(F, 0, 4)

def check_point(u, xp, yp):
    P = map.E(xp, yp)
    Q = map.E(*map.straight_line(F(u)))
    try:
        assert P == Q or P == -Q
    except:
        map.c3 = -map.c3
        Q = map.E(*map.straight_line(F(u)))
        assert P == Q or P == -Q
