program newton_raphson

use fmzm

implicit none

!Newton raphson
integer :: i
type(fm) :: a
type(fm) :: tol
type(fm) :: x
tol = to_fm('10e-30')
x = to_fm('0.9878')

call fm_set(70)

do i = 1, 100
	x = x - (x*x-a)/(2*x)
  call fm_print(abs(x-sqrt(a))/x)
	!print *, abs(x-sqrt(a))/x
	if(abs(x-sqrt(a))/x <= tol) exit
end do

end program
