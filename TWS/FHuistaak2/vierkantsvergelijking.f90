program vierkantsvergelijking

!

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
print '(f14.10,f14.10)', algoritme1dp(b,c)
print '(f14.10,f14.10)', algoritme2dp(b,c)
print '(f14.10,f14.10)', abs(algoritme1dp(b,c) - algoritme2dp(b,c))

b_sp = b
c_sp = c

print *, 'Resultaat algoritme 1 en 2 (enkele precisie)'
print '(f14.10,f14.10)', algoritme1(b_sp,c_sp)
print '(f14.10,f14.10)', algoritme2(b_sp,c_sp)
print '(f14.10,f14.10)', abs(algoritme1(b_sp,c_sp) - algoritme2(b_sp,c_sp))

contains

!Subroutine die numeriek constanten afprint
subroutine printPrecisie()
	integer, parameter :: p1 = max(sp,selected_real_kind(6,37))
	integer, parameter :: p2 = max(dp,selected_real_kind(15,307))
	integer, parameter :: p3 = max(qp,selected_real_kind(33,4931))
	real(p1) :: getal1 = 1.0
	real(p2) :: getal2 = 1.0
	real(p3) :: getal3 = 1.0
	print *, '                       single precision       double precision      quadruple precision ' 
	print *, 'Lengte mantisse:   '  ,	digits(fraction(getal1)), '         ',digits(fraction(getal2)),'       ',digits(fraction(getal3))	
	print *, 'Decimale precisie: '  , precision(getal1),'         ',precision(getal2),'       ',precision(getal3)
	print *, 'Minimale exponent: ' , exponent(tiny(getal1)), '          ' , exponent(tiny(getal2)) , '       ' , exponent(tiny(getal3))
	print *, 'Maximale exponent: ' , exponent(huge(getal1)), '          ' , exponent(huge(getal2)) , '       ' , exponent(huge(getal3))
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
	