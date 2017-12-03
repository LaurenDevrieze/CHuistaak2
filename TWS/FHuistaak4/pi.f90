program pi
!Lauren Devrieze

!Commando's: gfortran -I FM_files/ FM_files/*.o pi.f90

!Tijdsbesteding: x!!!! uur

!Bespreking: Als recusieve formule wordt: s_2k = sqrt((1.0-sqrt(1.0-s_k*s_k))/2.0)
!			 gebruikt. Om tot deze formule te komen wordt in figuur 1 pythagoras
!			 gebruikt voor de 2 rechthoekige driehoeken met de variabelen a en b.
!			 Als de waarden a en b weggewerkt worden door substitutie wordt de
!			 volgende formule bekomen.

!			 Bij enkele precisie zal de fout eerst kleiner worden tot ongeveer orde
!			 10^-6, dan zal de fout stijgen en bij stap 12 is de benadering van
!			 pi zelf 0. Dit komt omdat de berekende s_k zo klein zal zijn dat enkele
!			 precisie het getal niet meer goed kan voorstellen. s_k zal steeds fouter
!			 worden tot het uiteindelijk 0 wordt.

!			 Bij multiprecisie gebeurt dit niet en zal pi steeds beter benaderd worden
!			 zolang de nieuwe s_k kan voorgesteld worden met de precisie. Een reden om
!			 multiprecisie niet te gebruiken is hoe lang het duurt.
!			 Timings voor x!!!! stappen:
!			 enkele precisie:
!			 multiprecisie: 									!timing nog invullen
!			 Dit komt doordat eerst en vooral omdat multiprecisie meer cijfers gebruikt
!			 om berekeningen te doen dus dat ze daarom langer duren. Ook het feit dat het
!			 geen standaard type is dat in fortran zit zal vermoedelijk voor vertraging 
!			 zorgen. Als pi niet zo goed benadert hoeft te worden is het beter om enkele
!			 precisie te gebruiken. 

use fmzm

implicit none

real(8) :: start, start_fm, finish, finish_fm

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
  do i = 3,30
		s = sqrt((1.0-sqrt(1.0-s*s))/2.0)
		call fm_print(abs(2**(i)*s-pi))
	end do
end subroutine

subroutine calculatePi_fm()
  type(fm) :: s,pi
  integer :: i
  pi = to_fm(4.0*atan(to_fm(1.0)))
  s = sqrt(to_fm(2.0))/to_fm(2.0)
  do i = 3,30
		s = sqrt((to_fm(1.0)-sqrt(to_fm(1.0)-s*s))/to_fm(2.0))
		call fm_print(abs(2**(i)*s-pi))
  end do
end subroutine

end program
