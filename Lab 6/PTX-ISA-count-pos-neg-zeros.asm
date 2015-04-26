;// Written in PTX ISA
;// Count the number of negative, positive, and zeros from an array
	.global .u32 x[20];
	.global .u32 pos = 0; 		// pos = 0
	.global .u32 neg = 0;	 	// neg= 0
	.global .u32 zeros = 0; 	// zeros= 0
	.global .u32 sum;
	.global .u32 i = 0; 		//i = 0
loop:
	setp.lt.u32 p, x[i], 0;		// p = (x[i] < 0)
@p	add.u32 neg, neg, 1;		// neg = neg + 1
	setp.gt.u32 p, x[i], 0; 		// p = (x[i] > 0)
@p	add.u32 pos, pos, 1;	 	// pos = pos + 1
	setp.eq.u32 p, x[i], 0; 		 // p = (x[i] == 0)
@p	add.u32 zeros, zeros, 1;	// zeros = zeros + 1
	add.u32 i, i, 1;			// i = i + 1
	setp.ne.u32 p, i, 20;		// p = (i != 20)
@p	bra loop;			// go to loop
	exit;
