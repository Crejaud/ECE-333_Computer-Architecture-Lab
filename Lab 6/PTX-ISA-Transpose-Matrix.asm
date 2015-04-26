.global .u32 Matrix_A[5][5] = [1, 2, 3, 4, 5; 6, 7, 8, 9, 10; 11, 12, 13, 14, 15; 16, 17, 18, 19, 20; 21, 22, 23, 24, 25]
.global .u32 Matrix_B[5][5];
.global .u32 i = 0; 		// i = 0
.global .u32 j;			// declare j
.global .u32 temp1, temp2	// temp1, temp2 used to hold elements of matrices
forloop1:
	add .u32 j, 0, 0	;		// j = 0
	forloop2:
		add .u32 Matrix_B[j][i], Matrix_A[i][j], 0;	// Matrix_B[j][i] = Matrix_A[i][j]
		add .u32 j, j, 1;				// j++
		setp.lt .u32 p, j, 5;				// p = (j < 5)
@p		bra forloop2;					// jump back to forloop2 if p is true
	add .u32 i, i, 1;		// i++
	setp.lt .u32 p, i, 5;		// p = (i < 5)
@p	bra forloop1;

// Matrix_B now holds transpose of Matrix_A

add .u32 i, 0, 0				// i = 0
forloop3:
	add .u32 j, 0, 0;		// j = 0
	forloop4:
		add .u32 Matrix_A[i][j], Matrix_B[i][j], 0;	// Matrix_A[i][j] = Matrix_B[i][j]
		add .u32 j, j, 1;				// j++
		setp.lt .u32 p, j, 5;				// p = (j < 5)
@p		bra forloop4;
	add .u32 i, i, 1;		// i++
	setp.lt .u32 p, i, 5;		// p = (i < 5)
@p	bra forloop3;
	exit;		

