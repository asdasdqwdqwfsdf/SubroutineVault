      REAL*8, PARAMETER:: FCC_S0(3,12)=reshape([
     1  0.0000,1.0000,-1.0000,
     1  -1.0000,0.0000,1.0000,
     1  1.0000,-1.0000,0.0000,
     1  -1.0000,0.0000,-1.0000,
     1  1.0000,1.0000,0.0000,
     1  0.0000,-1.0000,1.0000,
     1  0.0000,1.0000,1.0000,
     1  -1.0000,-1.0000,0.0000,
     1  1.0000,0.0000,-1.0000,
     1  0.0000,-1.0000,-1.0000,
     1  1.0000,0.0000,1.0000,
     1  -1.0000,1.0000,0.0000
     1  ], [3,12])
	 
      REAL*8, PARAMETER:: FCC_N0(3,12)=reshape([
     1  1.0000,1.0000,1.0000,
     1  1.0000,1.0000,1.0000,
     1  1.0000,1.0000,1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  -1.0000,-1.0000,1.0000,
     1  -1.0000,-1.0000,1.0000,
     1  -1.0000,-1.0000,1.0000
     1  ], [3,12])

C ==============================================================================
      REAL*8, PARAMETER:: FCC_SPE0(3,12)=reshape([
     1  -2.0000,1.0000,1.0000,
     1  1.0000,-2.0000,1.0000,
     1  1.0000,1.0000,-2.0000,
     1  1.0000,2.0000,-1.0000,
     1  1.0000,-1.0000,2.0000,
     1  -2.0000,-1.0000,-1.0000,
     1  2.0000,1.0000,-1.0000,
     1  -1.0000,1.0000,2.0000,
     1  -1.0000,-2.0000,-1.0000,
     1  2.0000,-1.0000,1.0000,
     1  -1.0000,2.0000,1.0000,
     1  -1.0000,-1.0000,-2.0000
     1  ], [3,12])
	 
      REAL*8, PARAMETER:: FCC_NPE0(3,12)=reshape([
     1  1.0000,1.0000,1.0000,
     1  1.0000,1.0000,1.0000,
     1  1.0000,1.0000,1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  -1.0000,-1.0000,1.0000,
     1  -1.0000,-1.0000,1.0000,
     1  -1.0000,-1.0000,1.0000
     1  ], [3,12])


C ==============================================================================
      REAL*8, PARAMETER:: FCC_SSE0(3,12)=reshape([
     1  -2.0000,-1.0000,-1.0000,
     1  -1.0000,-2.0000,-1.0000,
     1  -1.0000,-1.0000,-2.0000,
     1  -1.0000,2.0000,1.0000,
     1  -1.0000,1.0000,2.0000,
     1  -2.0000,1.0000,1.0000,
     1  2.0000,-1.0000,1.0000,
     1  1.0000,-1.0000,2.0000,
     1  1.0000,-2.0000,1.0000,
     1  2.0000,1.0000,-1.0000,
     1  1.0000,2.0000,-1.0000,
     1  1.0000,1.0000,-2.0000
     1  ], [3,12])
	 
      REAL*8, PARAMETER:: FCC_NSE0(3,12)=reshape([
     1  1.0000,-1.0000,-1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  -1.0000,-1.0000,1.0000,
     1  -1.0000,-1.0000,1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  1.0000,1.0000,1.0000,
     1  -1.0000,-1.0000,1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  1.0000,1.0000,1.0000,
     1  -1.0000,1.0000,-1.0000,
     1  1.0000,-1.0000,-1.0000,
     1  1.0000,1.0000,1.0000
     1  ], [3,12])

C ==============================================================================
      REAL*8, PARAMETER:: FCC_SCB0(3,12)=reshape([
     1  0.0000,1.0000,-1.0000,
     1 -1.0000,0.0000,1.0000,
     1 1.0000,-1.0000,0.0000,
     1 -1.0000,0.0000,-1.0000,
     1 1.0000,1.0000,0.0000,
     1 0.0000,-1.0000,1.0000,
     1 0.0000,1.0000,1.0000,
     1 -1.0000,-1.0000,0.0000,
     1 1.0000,0.0000,-1.0000,
     1 0.0000,-1.0000,-1.0000,
     1 1.0000,0.0000,1.0000,
     1 -1.0000,1.0000,0.0000
     1  ], [3,12])
	 
      REAL*8, PARAMETER:: FCC_NCB0(3,12)=reshape([
     1  1.0000,0.0000,0.0000,
     1  0.0000,1.0000,0.0000,
     1  0.0000,0.0000,1.0000,
     1  0.0000,-1.0000,0.0000,
     1  0.0000,0.0000,-1.0000,
     1  1.0000,0.0000,0.0000,
     1  -1.0000,0.0000,0.0000,
     1  0.0000,1.0000,0.0000,
     1  0.0000,0.0000,-1.0000,
     1  -1.0000,0.0000,0.0000,
     1  0.0000,-1.0000,0.0000,
     1  0.0000,0.0000,1.0000
     1  ], [3,12])

C ==============================================================================
      REAL*8, PARAMETER:: CUBIC_S0(3,6)=reshape([
     1  0.0000,1.0000,1.0000,
     1  0.0000,1.0000,-1.0000,
     1  1.0000,0.0000,1.0000,
     1  1.0000,0.0000,-1.0000,
     1  1.0000,1.0000,0.0000,
     1  1.0000,-1.0000,0.0000	 
     1  ], [3,6])
	 
      REAL*8, PARAMETER:: CUBIC_N0(3,6)=reshape([
     1  1.0000,0.0000,0.0000,
     1  1.0000,0.0000,0.0000,
     1  0.0000,1.0000,0.0000,
     1  0.0000,1.0000,0.0000,
     1  0.0000,0.0000,1.0000,
     1  0.0000,0.0000,1.0000
     1  ], [3,6])

C ==============================================================================
      REAL*8, PARAMETER:: FCC_T0(3,12)=reshape([
     1  2.0000,-1.0000,-1.0000,
     1  -1.0000,2.0000,-1.0000,
     1  -1.0000,-1.0000,2.0000,
     1  -1.0000,-2.0000,1.0000,
     1  -1.0000,1.0000,-2.0000,
     1  2.0000,1.0000,1.0000,
     1  -2.0000,-1.0000,1.0000,
     1  1.0000,-1.0000,-2.0000,
     1  1.0000,2.0000,1.0000,
     1  -2.0000,1.0000,-1.0000,
     1  1.0000,-2.0000,-1.0000,
     1  1.0000,1.0000,2.0000
     1  ], [3,12])


C ==============================================================================
      REAL*8, PARAMETER:: CUBIC_T0(3,6)=reshape([
     1  0.0000,1.0000,-1.0000,
     1  0.0000,-1.0000,-1.0000,
     1  -1.0000,0.0000,1.0000,
     1  1.0000,-0.0000,1.0000,
     1  1.0000,-1.0000,0.0000,
     1  -1.0000,-1.0000,0.0000
     1  ], [3,6])
