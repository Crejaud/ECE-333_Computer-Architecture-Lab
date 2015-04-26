.global .f32 pi = 0; 		// pi = 0
.global .f32 %r1;	 	// r1 = n (assume)
.global .f32 partial = 0; 	// partial= 0
.global .f32 k = 1;		// k = 1
.global .f32 numerator = -1;	// numerator = 1
forloop:
	mul.f32 numerator, numerator, -1;	# numerator *= -1
	add.f32 partial, k, k;		// partial = 2k
	sub.f32 partial, partial, 1;	// partial = 2k-1
	div.f32 partial, numerator, partial;	// partial = numerator/(2k-1)
	add.f32 pi, pi, partial;			// pi += partial
	add.f32 k, k, 1;		// k++
	setp.lte.f32 p, k, n;		// p = (k <= n)
@p	bra forloop;
	mul.f32 pi, pi, 4;		// pi *= 4
	exit;
