program pi

use fmzm

implicit none

real :: start, start_fm, finish, finish_fm

call fm_set(50)

call cpu_time(start)
print *, 'Enkele precisie:'
call calculatePi()
call cpu_time(finish)
print *, 'timing: ' , finish-start

call cpu_time(start_fm)
print *, 'Meervoudige precisie:'
call calculatePi_fm()
call cpu_time(finish_fm)
print *, 'timing: ' , finish_fm-start_fm

contains

subroutine calculatePi()
	real :: s
  type(fm) :: pi
  integer :: i
  pi = to_fm(4.0*atan(to_fm(1.0)))
  s = sqrt(2.0)/2.0
  do i = 3,25
		s = sqrt((1.0-sqrt(1.0-s*s))/2.0)
		print *, 2**(i)*s
		print *, 'Error: '
		call fm_print(abs(2**(i)*s-pi))
		print *, ' '
	end do
end subroutine

subroutine calculatePi_fm()
	type(fm) :: s,pi
  integer :: i
  pi = to_fm(4.0*atan(to_fm(1.0)))
  s = sqrt(to_fm(2.0))/to_fm(2.0)
  do i = 3,25
		s = sqrt((to_fm(1.0)-sqrt(to_fm(1.0)-s*s))/to_fm(2.0))
		call fm_print(2**(i)*s)
		print *, 'Error: ' 
		call fm_print(abs(2**(i)*s-pi))
		print *, ' '
	end do
end subroutine

end program
