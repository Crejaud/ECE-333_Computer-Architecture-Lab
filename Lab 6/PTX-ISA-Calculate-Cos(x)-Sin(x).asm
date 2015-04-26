	.global .f32 x;			// Assume x has already been registered
	.global .f32 cos = 0;		// sos(x) = 0 initially
	.global .f32 sin = 0;		// sin(x) = 0 initially
	.global .u32 i = 0; 		// i = 0
	.global .f32 cosFlag = 1;	// cosFlag = 1
	.global .f32 sinFlag = 1;	// sinFlag = 1
	.global .f32 partial;		// partial = num/denom
	.global .f32 numer = 1;	// numerator = 1
	.global .f32 denom = 1;	// denominator = 1
	.global .u32 flag = 1;		// flag = 0
	.global .f32 denom2;		// denom2 = denom + 1
forloop:
	setp.eq .u32 p, i, 1;		// p = (i==1)
@p	add .f32 denom, 1, 0;		// denom = 1
	div .f32 partial, numer, denom;	// partial = num/denom
	setp.eq .u32 p, flag, 1;		// p = (flag==1)
@p	mul .f32 partial, partial, cosFlag;	// partial *= cosFlag
@p	add .f32 cos, cos, partial;		// cos += partial
@p	mul .f32 cosFlag, cosFlag, -1;		// cosFlag *= -1
	setp.eq .u32 p, flag, -1;	// p = (flag==-1)
@p	mul .f32 partial, partial, sinFlag;	// partial *= sinFlag
@p	add .f32 sin, sin, partial;		// sin += partial
@p	mul .f32 sinFlag, sinFlag, -1;		// sinFlag *= -1
	mul .f32 numer, numer, x;		// numer *= x
	add .f32 denom2, denom, 1;		// denom2 = denom + 1
	mul .f32 denom, denom, denom2;	// denom *= denom+1
	mul .u32 flag, flag, -1;		// flag *= -1
	add .u32 i, i, 1;			// i++
	setp.lt .u32 p, i, 8;		// p = (i<8)
@p	bra forloop;
	exit;

