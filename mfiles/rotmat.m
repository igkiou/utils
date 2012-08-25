function mat = rotmat(deg)

mat = [cos(deg2rad(deg)),sin(deg2rad(deg));-sin(deg2rad(deg)),cos(deg2rad(deg))];
