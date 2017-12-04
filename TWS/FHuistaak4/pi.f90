program pi
!Lauren Devrieze

!Commando's: gfortran -I FM_files/ FM_files/*.o -o pi pi.f90

!Tijdsbesteding: 3.5 uur

!Bespreking: Als recusieve formule wordt: s_2k = sqrt((1.0-sqrt(1.0-s_k*s_k))/2.0)
!			 gebruikt. Om tot deze formule te komen wordt in figuur 1 pythagoras
!			 gebruikt voor de 2 rechthoekige driehoeken met de variabelen a en b.
!			 Als de waarden a en b weggewerkt worden door substitutie wordt de
!			 volgende formule bekomen.

!			 Bij enkele precisie zal de fout eerst kleiner worden tot ongeveer orde
!			 10^-5, dan zal de fout stijgen en bij stap 12 is de benadering van
!			 pi zelf 0. Dit komt omdat de berekende s_k zo klein zal zijn dat enkele
!			 precisie het getal niet meer goed kan voorstellen. s_k zal steeds fouter
!			 worden tot het uiteindelijk 0 wordt.

!			 Bij multiprecisie gebeurt dit niet en zal pi steeds beter benaderd worden
!			 zolang de nieuwe s_k kan voorgesteld worden met de precisie. Een reden om
!			 multiprecisie niet te gebruiken is hoe lang het duurt.
!			 Timings voor 10⁵ stappen:
!			 enkele precisie: 8.00000038E-03
!		     multiprecisie: 0.208000004
!			 Dit komt doordat eerst en vooral omdat multiprecisie meer cijfers gebruikt
!			 om berekeningen te doen dus dat ze daarom langer duren. Ook het feit dat het
!			 geen standaard type is dat in fortran zit zal vermoedelijk voor vertraging 
!			 zorgen. Als pi niet zo goed benadert hoeft te worden is het beter om enkele
!			 precisie te gebruiken. 

!Output:
! Enkele precisie:
!       8.0125244455882105650143383279502884197169399375106M-2
!       2.0148189859934840025143383279502884197169399375106M-2
!       5.0465186410627697126433832795028841971693993751058M-3
!       1.2592395120344494001433832795028841971693993751058M-3
!       3.0699570710280877514338327950288419716939937510582M-4
!       7.3822336741480650143383279502884197169399375105821M-5
!       3.8472016388991815014338327950288419716939937510582M-4
!       8.5863272612473028735661672049711580283060062489418M-4
!       8.5863272612473028735661672049711580283060062489418M-4
!       2.0685044927052464662356616720497115802830600624894M-2
!       2.0685044927052464662356616720497115802830600624894M-2
!       3.1316557725007155877514338327950288419716939937511M-1
!       3.1415926535897932384626433832795028841971693993751M+0
!       3.1415926535897932384626433832795028841971693993751M+0
!       3.1415926535897932384626433832795028841971693993751M+0
!       3.1415926535897932384626433832795028841971693993751M+0
!       3.1415926535897932384626433832795028841971693993751M+0
!       3.1415926535897932384626433832795028841971693993751M+0
! timing:    0.00000000    
! Meervoudige precisie:
!       8.0125194669075064634963511036311950106412899490089M-2
!       2.0147501331740952890085487647147029354103515343829M-2
!       5.0441630438539746483853388429638166407958580150877M-3
!       1.2614966350403261455248589478127520534661657269189M-3
!       3.1540265702037040062361249128847581750613672531669M-4
!       7.8852445492162134128323822680576261855583882177811M-5
!       1.9713222701854326843273008741454663531604870745190M-5
!       4.9283126335378337891205775841447978885408002625343M-6
!       1.2320785932644646716195386689284496067492889250233M-6
!       3.0801967549612226738912213295389196332372390201293M-7
!       7.7004920572781037291041627574465116120943967839810M-8
!       1.9251230249367165119651711590243137228626647249200M-8
!       4.8128075689775354140023258084994033974687851972100M-9
!       1.2032018926591178622215389998585141552006847377800M-9
!       3.0080047319070034110576288073659336184945007061000M-10
!       7.5200118299295139998422451545509879552262971990000M-11
!       1.8800029574925038419730769505651884024382022340000M-11
!       4.7000073937375879436905349527612051418231684500000M-12
! timing:    0.00000000 

use fmzm

implicit none

real :: start, finish

call fm_set(50)

call cpu_time(start)
print *, 'Enkele precisie:'
call calculatePi()
call cpu_time(finish)
print *, 'timing: ' , finish-start

call cpu_time(start)
print *, 'Meervoudige precisie:'
call calculatePi_fm()
call cpu_time(finish)
print *, 'timing: ' , finish-start

contains

subroutine calculatePi()
	real :: s
  type(fm) :: pi
  integer :: i
  pi = to_fm(4.0*atan(to_fm(1.0)))
  s = sqrt(2.0)/2.0
  do i = 3,20
		s = sqrt((1.0-sqrt(1.0-s*s))/2.0)
		!print de fout
		call fm_print(abs(2**(i)*s-pi))
  end do
end subroutine

subroutine calculatePi_fm()
  type(fm) :: s,pi
  integer :: i
  pi = to_fm(4.0*atan(to_fm(1.0)))
  s = sqrt(to_fm(2.0))/to_fm(2.0)
  do i = 3,20
		s = sqrt((to_fm(1.0)-sqrt(to_fm(1.0)-s*s))/to_fm(2.0))
		!print de fout
		call fm_print(abs(2**(i)*s-pi))
  end do
end subroutine

end program
