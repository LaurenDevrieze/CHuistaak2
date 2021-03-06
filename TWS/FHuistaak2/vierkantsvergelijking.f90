program vierkantsvergelijking
!Lauren Devrieze

!Tijdsbesteding: 7-8h

!Commando's : 	gfortran -o vierkantsvgl vierkantsvergelijking.f90
!					=> Ook vervangen door ifort en nagfor
!				echo -e "-767.0 17.0" | ./vierkantvgl

!OUTPUT GFORTRAN EN IFORT

!                        single precision       double precision      quadruple precision
! Lengte mantisse:             24                    53                 113
! Decimale precisie:            6                    15                  33
! Minimale exponent:         -125                  -1021              -16381
! Maximale exponent:          128                   1024               16384
!Machine precisie:       1.1920928955E-07     2.2204460493E-16     1.9259299444E-34
! Kind getal:                   4                     8                  16

!OUTPUT NAGFOR

!                        single precision       double precision      quadruple precision
! Lengte mantisse:             24                    53                 106
! Decimale precisie:            6                    15                  31
! Minimale exponent:         -125                  -1021              -968
! Maximale exponent:          128                   1024               1023
!Machine precisie:       1.1920928955E-07     2.2204460493E-16     2.4651903288E-32
! Kind getal:                   1                     2                  3

!BESPREKING PRECISIE WAARDEN

	!Bij gfortran en ifort hebben alle constantes dezelfde waarde en deze komen ongeveer overeen met de juiste
	! waarden. Bij deze compilers wordt kind voorgesteld door aantal bytes.
	!Bij nagfor zijn er enkele niet logische waarden bij de quadruple precisie, maar de 2 andere precisies komen
	! wel overeen met de andere waarden. Bij deze compiler wordt ook de kind sequentieel voorgesteld.

!OUTPUT ALGORITMES (GFORTRAN)

! Resultaat algoritme 1 en 2 (dubbele precisie)
!766.9778442383  0.0221557617
!766.9778350831  0.0221649169
! Resultaat algoritme 1 en 2 (enkele precisie)
!766.9778442383  0.0221557617
!766.9778442383  0.0221649166


!BESPREKING ALGORITMES

	!Als we naar de output kijken zien we eerst en vooral dat vooral bij kleine waarden voor nulpunten
	! er een verschil is tussen de 2 algoritmes
	!Om duidelijk weer te geven welk algoritme het best is nemen we de volgende waarden: b = 999.99999 en c = 0.01
	!Deze veelterm heeft 1000 en 0.00001 als nulpunt
	
	!Resultaat algoritme 1 en 2 (enkele precisie)
	!1000.0000000000   0.0000305176		=> Algoritme1
	!1000.0000000000   0.0000100000		=> Algoritme2
	
	!Het is duidelijk dat algoritme 2 veel nauwkeuriger is als er een groot en een klein nulpunt is. Dit komt
	! doordat b/2 ongeveer gelijk zal zijn met de discriminant omdat c zo klein is.
	
	!Een voorbeeld waarbij algoritme 1 beter is, is bij volgende waarden: b en c = 0, dus 0 als nulpunt
	
	!Resultaat algoritme 1 en 2 (enkele precisie)
	!0.0000000000  -0.0000000000
	!-0.0000000000            NaN
	
	!Bij algoritme 2 wordt er gedeeld door het 1ste nulpunt wat in dit geval 0 is waardoor als 2de nulpunt NaN
	! verkregen wordt.
	
	!Dit is natuurlijk echter een specifiek geval. Algemeen gezien zal algoritme 2 het best zijn omdat het
	! algoritme vermijdt dat ongeveer even grote waarden van elkaar afgetrokken worden.

implicit none

!Variabelen declareren
integer, parameter :: sp = 4
integer, parameter :: dp = 8
integer, parameter :: qp = 16
real(dp) :: b, c
real(dp), dimension(2) :: x
real(sp) :: b_sp, c_sp
real(sp), dimension(2) :: x_sp

read(*,*) b, c

call printPrecisie

print *, 'Resultaat algoritme 1 en 2 (dubbele precisie)'
print '(f15.10,f15.10)', algoritme1dp(b,c)
print '(f15.10,f15.10)', algoritme2dp(b,c)

b_sp = b
c_sp = c

print *, 'Resultaat algoritme 1 en 2 (enkele precisie)'
print '(f15.10,f15.10)', algoritme1(b_sp,c_sp)
print '(f15.10,f15.10)', algoritme2(b_sp,c_sp)

contains

!Subroutine die numeriek constanten afprint
subroutine printPrecisie()
	integer, parameter :: p1 = min(sp,selected_real_kind(6,37))
	integer, parameter :: p2 = min(dp,selected_real_kind(15,307))
	integer, parameter :: p3 = abs(min(qp,selected_real_kind(33,4931)))
	real(p1) :: getal1 = 1.0
	real(P2) :: getal2 = 1.0
	real(p3) :: getal3 = 1.0
	print *, '                       single precision       double precision      quadruple precision ' 
	print *,'Lengte mantisse:   ',digits(fraction(getal1)),'         ',digits(fraction(getal2)),'       ',digits(fraction(getal3))	
	print *,'Decimale precisie: '  , precision(getal1),'         ',precision(getal2),'       ',precision(getal3)
	print *,'Minimale exponent: ' , exponent(tiny(getal1)), '          ' , exponent(tiny(getal2)) , '       ' , exponent(tiny(getal3))
	print *,'Maximale exponent: ' , exponent(huge(getal1)), '          ' , exponent(huge(getal2)) , '       ' , exponent(huge(getal3))
	print '(a,es16.10,a5,es16.10,a5,es16.10)' , 'Machine precisie:       ' ,epsilon(getal1),' ',epsilon(getal2),' ',epsilon(getal3)
	print *, 'Kind getal:        ' ,  kind(getal1), '         ' , kind(getal2) , '       ' , kind(getal3)
end subroutine
		
function algoritme1dp(b,c) result(x)
	real(dp), intent(in) :: b, c
	real(dp), dimension(2) :: x(2)
	real :: d
	d = sqrt((b/2)*(b/2)-c)
	x = [-(b/2) + d, -(b/2) - d]  
end function

function algoritme2dp(b,c) result(x)
	real(dp), intent(in) :: b, c
	real(dp), dimension(2) :: x(2)
	real(dp) :: d
	d = sqrt((b/2)*(b/2)-c)
	x(1) = sign(1.0_dp,-b)*(abs(b/2) + d)
	x(2) = c/x(1)
end function

function algoritme1(b,c) result(x)
	real, intent(in) :: b, c
	real, dimension(2) :: x(2)
	real :: d
	d = sqrt((b/2)*(b/2)-c)
	x = [-(b/2) + d, -(b/2) - d]  
end function

function algoritme2(b,c) result(x)
	real, intent(in) :: b, c
	real, dimension(2) :: x(2)
	real :: d
	d = sqrt((b/2)*(b/2)-c)
	x(1) = sign(1.0,-b)*(abs(b/2) + d)
	x(2) = c/x(1)
end function

end program
	