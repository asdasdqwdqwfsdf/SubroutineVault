      subroutine InitialiseUMAT(
     1 PROPS, STATEV, 
     1 NPROPS, NSTATV,
     1 KSTEP, KINC, NOEL, NPT,
     1 ROTM, COORDS
     1 )
	  
      IMPLICIT NONE    
      INTEGER, PARAMETER :: NDIR = 3 
      include 'UserParameters.f'   
      
      INTEGER, INTENT(IN) :: NPROPS, NSTATV
      INTEGER, INTENT(IN) :: KSTEP, KINC, NOEL, NPT
      REAL*8, INTENT(IN) :: PROPS(NPROPS), COORDS(3)
      REAL*8, INTENT(INOUT) :: STATEV(NSTATV)

      REAL*8, INTENT(OUT) :: ROTM(NDIR,NDIR)
 
      INTEGER :: I,J,K, NN
      
      REAL*8 :: kgausscoords, kFp, kcurlFp      
      COMMON/UMPS/kgausscoords(TOTALELEMENTNUM,8,3),
     1 kFp(TOTALELEMENTNUM,8, 9),
     1 kcurlFp(TOTALELEMENTNUM, 8, 9)
     
c ==============================================
      IF ((KSTEP.LE.1).AND.(KINC.LE.1)) THEN
        
        DO I = 1, NSTATV
            STATEV(I) = 0.0
        END DO
c ---
        DO I = 1, NDIR
            DO J = 1, NDIR
              NN = J + (I-1)*NDIR
              STATEV(NN) = PROPS(NN)
            END DO
        END DO
c ---
        STATEV(10) = 1.0
        STATEV(14) = 1.0    
        STATEV(18) = 1.0     
        
      END IF
     
c ==============================================
      IF (KINC.LE.1) THEN
c ---
        DO I = 1, NDIR
            DO J = 1, NDIR
              NN = J + (I-1)*NDIR
              ROTM(I,J) = STATEV(NN)
            END DO
        END DO
c ---

        CALL MUTEXLOCK(1)
            DO I = 1,9
                kFp(NOEL, NPT, I) = STATEV(9+I)
            END DO
        CALL MUTEXUNLOCK(1)

c -------      
      END IF

c ==============================================
      IF ((KSTEP.LE.1).AND.(KINC.LE.1)) THEN       
        DO I = 1,9
            STATEV(18+I) = 0.0
        END DO
        CALL MUTEXLOCK(2)
            DO i =1,3
            kgausscoords(noel,npt,i) = coords(i)
            STATEV(135+I) = coords(i)
            END DO
        CALL MUTEXUNLOCK(2)        
        
        DO I= 28,45
          STATEV(I) = 0.005
        END DO
        
      ELSE 
        DO I = 1,9
            STATEV(18+I) = kcurlFp(NOEL, NPT, I)
        END DO  
        CALL MUTEXLOCK(2)
            DO i =1,3
            kgausscoords(noel,npt,i) = STATEV(135+I)
            END DO
        CALL MUTEXUNLOCK(2)  
      END IF


        

      RETURN
      END 