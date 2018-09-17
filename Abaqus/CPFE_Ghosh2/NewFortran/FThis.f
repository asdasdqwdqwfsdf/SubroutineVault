      SUBROUTINE UMAT(stress,statev,ddsdde,sse,spd,scd,
     1 rpl, ddsddt, drplde, drpldt,
     2 stran,dstran,time,dtime,temp,dtemp,predef,dpred,cmname,
     3 ndi,nshr,ntens,nstatv,props,nprops,coords,drot,pnewdt,
     4 celent,dfgrd0,dfgrd1,noel,npt,layer,kspt,kstep,kinc)
	 
      include 'aba_param.inc'
c
#include <SMAAspUserSubroutines.hdr>
      CHARACTER*8 CMNAME
c      EXTERNAL F
      real*8:: Statev
      dimension stress(ntens),statev(nstatv),
     1 ddsdde(ntens,ntens),ddsddt(ntens),drplde(ntens),
     2 stran(ntens),dstran(ntens),time(2),predef(1),dpred(1),
     3 props(nprops),coords(3),drot(3,3),dfgrd0(3,3),dfgrd1(3,3)
	 
      include 'DeclareParameterSlipsO.f'
      
      INTEGER:: ISLIPS, I, J, NDUM1, NA, NB, ICOR, ISL
      real*8 :: TAU(18), TAUPE(12), TAUSE(12), TAUCB(12)
      real*8 :: SLIP_T(54), IBURG, CFP(3,3)	  
      real*8 :: RhoP(18),RhoF(18),RhoM(18),RhoSSD(18)
      real*8 :: TauPass(18), TauCut(18), V0(18)
      real*8 :: H(12), RhoCSD(12), TAUC(18) 
      real*8 :: Vs(18) , GammaDot(18) , TauEff(18), SSDDot(18)
      real*8 :: DStress(6) , KCURLLOCAL(6)
      real*8 :: MXSLIP=1.0e-3
      real*8 :: ORI_ROT(3,3), SPIN_TENSOR(3,3)
      real*8:: dFP(9), dRhoS(18),dRhoET(18),dRhoEN(18)
      real*8:: FWORDMORON
c ------------------------------------------------	  
C
C     CALCULATE VELOCITY GRADIENT FROM DEFORMATION GRADIENT.
C     REFERENCE: Li & al. Acta Mater. 52 (2004) 4859-4875
C     
      real*8,parameter  :: zero=1.0e-16,xgauss = 0.577350269189626
      real*8,parameter  :: xweight = 1.0
      integer, parameter :: TOTALELEMENTNUM=100
c  1728 853200
      Real*8:: FTINV(3,3),STRATE(3,3),VELGRD(3,3),AUX1(3,3),ONEMAT(3,3)
      PARAMETER (ONE=1.0D0,TWO=2.0D0,THREE=3.0D0,SIX=6.0D0)
c      DATA NEWTON,TOLER/10,1.D-6/
      Real*8:: gausscoords(3,8)
      real*8 :: kgausscoords, kFp, kcurlFp, kDGA, kX
      real*8:: xnat(20,3),xnat8(8,3),gauss(8,3), DGA(18)
      real*8:: svars(144)
	  
      INTEGER:: PLASTICFLAG
c XDANGER
      COMMON/UMPS/kgausscoords(TOTALELEMENTNUM,8,3),
     1 kFp(TOTALELEMENTNUM,8, 9),
     1 kcurlFp(TOTALELEMENTNUM, 8, 9), 
     1 kDGA(TOTALELEMENTNUM, 8, 9),
     1 kX(TOTALELEMENTNUM, 8, 9)
c -------------------------------------------------
c Initialisation

	  
      IF (KINC.LE.1) THEN
       DO ISLIPS=1,nstatv
          STATEV(ISLIPS)=0.0
       END DO

       NDUM1=0
       DO I=1,3
       DO J=1,3
          NDUM1=NDUM1+1
          ORI_ROT(I,J)=PROPS(NDUM1)
       END DO
       END DO
	   
       DO ISLIPS=1,18
          STATEV(ISLIPS+108)=PROPS(ISLIPS+9)
       END DO

c ---- S_SCHMID
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_S0(1:3,ISLIPS),STATEV(NA:NB))
       END DO
       DO ISLIPS=1,6
        NDUM1=(ISLIPS+11)*3
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,CUBIC_S0(1:3,ISLIPS),STATEV(NA:NB))
       END DO

c ---- N_SCHMID
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3+54
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_N0(1:3,ISLIPS),STATEV(NA:NB))
       END DO
       DO ISLIPS=1,6
        NDUM1=(ISLIPS+11)*3+54
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,CUBIC_N0(1:3,ISLIPS),STATEV(NA:NB))
       END DO	
	   
c ---- S_PE
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3+184
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_SPE0(1:3,ISLIPS),STATEV(NA:NB))
       END DO
c ---- N_PE
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3+220
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_NPE0(1:3,ISLIPS),STATEV(NA:NB))
       END DO

c ---- S_SE
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3+256
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_SSE0(1:3,ISLIPS),STATEV(NA:NB))
       END DO
c ---- N_SE
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3+292
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_NSE0(1:3,ISLIPS),STATEV(NA:NB))
       END DO	   
	   
c ---- S_CB
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3+328
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_SCB0(1:3,ISLIPS),STATEV(NA:NB))
       END DO
c ---- N_CB
       DO ISLIPS=1,12
        NDUM1=(ISLIPS-1)*3+364
        NA=NDUM1+1
        NB=NDUM1+3		        
        call ROTATE_Vec(ORI_ROT,FCC_NCB0(1:3,ISLIPS),STATEV(NA:NB))
       END DO	      
c ---- Rotate STIFFNESS TENSOR
        call ROTATE_COMTEN(ORI_ROT,PROPS(28:48),STATEV(164:184))

c--- Do Stuff
       STATEV(401)=1.0
       STATEV(405)=1.0
       STATEV(409)=1.0

c XDANGER
c       DO ISLIPS=1,18
c        STATEV(409+ISLIPS)=(1.0e9)*(1.0e-12)
c        STATEV(429+ISLIPS)=(1.0e9)*(1.0e-12)
c        STATEV(447+ISLIPS)=(1.0e9)*(1.0e-12) 
c       END DO	 
       DO ISLIPS=1,18
        STATEV(409+ISLIPS)= 0.0
        STATEV(429+ISLIPS)= 0.0
        STATEV(447+ISLIPS)= 0.0
       END DO	 
c      DO ISLIPS=1,6
c        STATEV(271+ISLIPS)=0.0
c        STATEV(289+ISLIPS)=0.0
c        STATEV(307+ISLIPS)=0.0   
c       END DO	
	   


      IF (KSTEP.LE.1) THEN
        call MutexLock( 3 )      ! lock Mutex #2      
      ! use original co-ordinates X     
        do i =1,3
          kgausscoords(noel,npt,i) = coords(i)
          statev(480+I) = coords(i)
        end do

        if	(npt == 8) THEN	
        DO kint =1,8 
          DO i=1,3         
           gausscoords(i,kint) = kgausscoords(noel,kint,i)                          
          END DO 
         END DO	  
        end if
        kfP(noel,npt,1)=1.0
        kfP(noel,npt,5)=1.0
        kfP(noel,npt,9)=1.0
        call MutexUnlock( 3 )   ! unlock Mutex #2
      ELSE
        call MutexLock( 3 )      ! lock Mutex #2      
      ! use original co-ordinates X     
        do i =1,3
          kgausscoords(noel,npt,i) = statev(480+I)
        end do
        DO kint =1,8 
          DO i=1,3         
           gausscoords(i,kint) = kgausscoords(noel,kint,i)                          
          END DO 
         END DO	  
	  
        kfP(noel,npt,1)=1.0
        kfP(noel,npt,5)=1.0
        kfP(noel,npt,9)=1.0
        call MutexUnlock( 3 )   ! unlock Mutex #2
      ENDIF	  
	  
      ENDIF
c ---
      DO i=1, 9
         STATEV(770+I) = kcurlFp(noel,npt,i)
      END DO	
	  
C XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


C XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
c --------------------------------
C Calculate som common values
      IF (npt == 8 ) THEN ! update curl Fp	 
      INCLUDE 'kgauss2.f'     
      xnat8 = xnat(1:8,:) 		  
c ---------------------------
         DO kint =1,8        
             DO i=1,9          
                 svars(i + 18*(kint-1)) = 0.0		 
             END DO
         END DO	  
       svars(   1 )=   1.00168894230775     
       svars(   2 )= -4.367406225334836E-019
       svars(   3 )=  3.642920309857558E-020
       svars(   4 )= -8.698496561446528E-020
       svars(   5 )=  0.996630419844280     
       svars(   6 )= -1.148707946645798E-020
       svars(   7 )=  3.457327773001572E-020
       svars(   8 )=  4.779935736863440E-020
       svars(   9 )=   1.00168894230775     
       svars(  19 )=   1.00168894230775     
       svars(  20 )=  1.738758857668812E-019
       svars(  21 )=  3.457327773001572E-020
       svars(  22 )= -8.698496561446528E-020
       svars(  23 )=  0.996630419844280     
       svars(  24 )= -6.589749465511214E-021
       svars(  25 )=  3.457327773001572E-020
       svars(  26 )=  4.482044221181302E-020
       svars(  27 )=   1.00168894230775     
       svars(  37 )=   1.00168894230775     
       svars(  38 )= -7.583439870741832E-019
       svars(  39 )=  4.151920006271557E-020
       svars(  40 )= -6.746862424499425E-020
       svars(  41 )=  0.996630419844280     
       svars(  42 )= -4.034802469796552E-020
       svars(  43 )=  2.354322733132434E-020
       svars(  44 )=  1.079473314471735E-019
       svars(  45 )=   1.00168894230775     
       svars(  55 )=   1.00168894230775     
       svars(  56 )=  1.350470347921469E-019
       svars(  57 )=  2.354322733132434E-020
       svars(  58 )= -6.746862424499425E-020
       svars(  59 )=  0.996630419844280     
       svars(  60 )=  3.570441772386774E-021
       svars(  61 )=  2.354322733132434E-020
       svars(  62 )=  6.858472900367286E-020
       svars(  63 )=   1.00168894230775     
       svars(  73 )=   1.00168894230775     
       svars(  74 )= -2.248118123696042E-019
       svars(  75 )=  2.115734842884869E-020
       svars(  76 )= -8.698496561446528E-020
       svars(  77 )=  0.996630419844280     
       svars(  78 )= -2.758883419489638E-020
       svars(  79 )=  3.457327773001572E-020
       svars(  80 )=  5.461690612533097E-020
       svars(  81 )=   1.00168894230775     
       svars(  91 )=   1.00168894230775     
       svars(  92 )=  1.738758857668812E-019
       svars(  93 )=  3.457327773001572E-020
       svars(  94 )= -8.698496561446528E-020
       svars(  95 )=  0.996630419844280     
       svars(  96 )= -6.589749465511214E-021
       svars(  97 )=  3.457327773001572E-020
       svars(  98 )=  4.482044221181302E-020
       svars(  99 )=   1.00168894230775     
       svars( 109 )=   1.00168894230775     
       svars( 110 )= -9.462191036105157E-019
       svars( 111 )= -9.016713697741803E-022
       svars( 112 )= -8.698496561446528E-020
       svars( 113 )=  0.996630419844280     
       svars( 114 )= -3.525827613228095E-020
       svars( 115 )=  3.457327773001572E-020
       svars( 116 )=  4.698232682959014E-020
       svars( 117 )=   1.00168894230775     
       svars( 127 )=   1.00162897108488     
       svars( 128 )=  1.738967094423529E-019
       svars( 129 )=  3.457120782422306E-020
       svars( 130 )= -8.697975781537819E-020
       svars( 131 )=  0.996749778019433     
       svars( 132 )= -6.589354936514069E-021
       svars( 133 )=  3.457120782422306E-020
       svars( 134 )=  4.482580998514745E-020
       svars( 135 )=   1.00162897108488 
C          DO kint =1,8        
C              DO i=1,9          
C                  kX(noel,kint,1) = 1.00862	
C                  kX(noel,kint,2) = 0.0	
C                  kX(noel,kint,3) = 0.0	
C                  kX(noel,kint,4) = 0.0	
C                  kX(noel,kint,5) = 0.982986	
C                  kX(noel,kint,6) = 0.0	
C                  kX(noel,kint,7) = 0.0
C                  kX(noel,kint,8) = 0.0	
C                  kX(noel,kint,9) = 1.00862					 
C              END DO
C          END DO	  
  	  
C          DO kint =1,8        
C              DO i=1,9          
C                  svars(i + 18*(kint-1)) = kX(noel,kint,i)		 
C              END DO
C          END DO	  
	  
      CALL kcurl(svars,xnat8,gauss,gausscoords)

      call MutexLock( 5 )      ! lock Mutex #1 

      DO J =1, 8
          DO i=1, 9
              kcurlFp(noel,J,i) = svars(9+i + 18*(J-1))
              kDGA(noel,J,i) = svars(9+i + 18*(J-1))

              STATEV(600+(10*J)+I) = svars(9+i + 18*(J-1))
              STATEV(500+(10*J)+I) = svars(i + 18*(J-1))
          END DO
      END DO
      call MutexUnlock( 5 )      ! lock Mutex #1 

      END IF

c ----------
      call MutexLock( 6 )      ! lock Mutex #1 
      DO i=1,9                                                      
          kFp(noel,npt,i)= statev(400+i)
      END DO
      call MutexUnlock( 6 )      ! lock Mutex #1 
c --------------------------------------
      DO ISLIPS=1,6
       IF ((ABS(DStress(ISLIPS)).GT.5.0e1)) THEN
         PNEWDT=0.5
       END IF	   
      END DO		

      DO ISLIPS=1,18
       IF ((ABS(DGA(ISLIPS)).GT.1.0e-3)) THEN
         PNEWDT=0.5
       END IF	   
      END DO	  
	  
c -------------------------------------------------
       CALL UMATTEMPLATE(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,
     1 RPL,DDSDDT,DRPLDE,DRPLDT,
     2 STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     3 NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT,
     4 CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,JSTEP,KINC)	 
	 
      return
      end subroutine UMAT
	  
c --------------------
      include 'uexternaldb.f'
      include 'UMAT_TemplateTest.f'
      include 'StiffnessTensorTools.f'
      include 'RotateSlipSystems.f'

      include 'CalculateTauS.f'
      include 'GetRhoPFMGNDWeak.f'
      include 'GetTauSlips.f'
      include 'GetCSDHTauC.f' 
      include 'GetGammaDot.f'
      include 'GetRhoSSDEvolve.f'
      include 'VectorProjections.f'
	  
      include 'GetDSTRESS2FP.f'	
      include 'GetDDSDDEN.f'
	  
      include 'VectorCurl.f'	  	  
      include 'kshapes.f'
      include 'kCalcGND.f'
      include 'utils.f'
      include 'utilsX.f'
      include 'kcurlJ.f'
      include 'ksvd2.f'