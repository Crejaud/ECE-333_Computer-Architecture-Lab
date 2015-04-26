;// Written in PTX ISA
;// Takes an unsigned integer value in r62 and store values into each of eight registers r0, r2, ... r14 as follows:
;// r(2*i) = 2^i * r62
	.global .u32 r[] = { 0, 2, 4, 6, 8, 10, 12, 14 };
	.reg .u32 %r62;
	.global .u32 i = 0; // i = 0
	.global .u32 k = 1; // k holds 2^i
start:
	mul.wide.u32 k, k, 2;  	// k = 2^i
	setp.eq.u32 p, i, 0;	// p = (i == 0)
@p	add.u32 k, 0, 1; 	// k = 1
	mul.wide.u32 r[i], k, %r62;	// r[i] = 2^i*r62
	add.u32 i, i, 1;		// i++
	setp.lt.u32 p, i, 8;	// p = (i < 8)
@p	bra start;		// if i<8, go to bra
	exit;
