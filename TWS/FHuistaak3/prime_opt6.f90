! This program searches for the n'th prime, but not in the most efficient way...
program prime

!Lauren Devrieze

!Tijdsbesteding:

!Commando's

!Optimalisaties 

!	(0) Geen optimalisaties, maar wel enkele aanpassingen zodat programma met tijd werkt
!	en niet met hoeveel priemgetallen er gevraagd zijn.
!	pn = 139562831	n = 8554

!	(1) real array useless wordt niet gebruikt dus deze moet niet opgesteld worden,
!	 analoog voor nbChecks
!	pn = 139662251	n = 8557

!	(2) prime list hoeft maar 1 dimensie

!	(3) Hoeft enkel maar een print statement op het einde van het programma

!	(4) variabele isPrime verwijderen

!	(5) stappen van 2 nemen aangzien even getallen geen priem kunnen zijn.
!		pn = 263083 n = 23073

!	(6)	Met index i en k werken ipv steeds elementen uit primelist te halen
!		pn = 372901 n = 31743




implicit none

real					:: start_time, stop_time
integer					:: i, j, k, primeMax !n , nbChecks	(1)
!integer, dimension(:,:),allocatable :: primeList	(2)
integer, dimension(:),allocatable :: primeList	
!logical					:: isPrime
!real					:: useless(900)	(1)

call cpu_time(start_time)

!write(unit=*, fmt="(A)", advance="no") "Enter the value of n: " (0)
!read *, n

!nbChecks = 0	(1)
!allocate(primeList(3,100000))	(2)
allocate(primeList(400000))

primeList(1) = 2
!write(unit=*, fmt="(A, I0, A, I0)") "Prime ", 1, ": ", primeList(1) (3)

primeMax = 400000000

k = 2
!do i = 2,n (0)

 
primeloop: do i = 3, primeMax , 2	!(5)
	!primeList(i) = primeList(i-1)	(6)
    !primeList(i) = primeList(i) + k	(6)
    !useless(mod(i,900)) = cos(i+0.5)	(1)
    !isPrime = .true. (4)
    do j = 2,i-1 !(6)
      !nbChecks = nbChecks + 1	(1)
      !primeList(3,j) = min(i,j)	(2)
      !if (modulo(primeList(i), primeList(j)) == 0) then (6)
	  if(mod(i,j)==0) then
		cycle primeloop
        !isPrime = .false. (4)
      end if
	 !if (ceiling(sqrt(real(primeList(i)))) + 1 > primeList(j)) exit
    end do
	primeList(k) = i
	if(i == 10000 .and. i /= 104729) then 
		print *, "Fout"
		call exit(1)
	end if
    !if (isPrime) then (4)
	  call cpu_time(stop_time)
	  if(stop_time-start_time > 1) then
		print *, "Biggest prime: " , primeList(k-1)
		print *, "Number of primes: ", k-1
		exit
	  end if
	  !print *, primeList(1)
      !write(unit=*, fmt="(A, I0, A, I0)") "Prime ", i, ": ", primeList(i)	(3)
	  k = k + 1
      !exit	(0)
		
	!end if (4)
  end do primeloop
!end do	(0)

!write(unit=*, fmt="(A, I0, A, I0, A, L, A)")  "! Prime ", i, " is ", primeList(i), ", check = ", .false., ", adjusted: " 

deallocate(primeList)

!primelist(1) = 2
!i = 2
!k = 1
!primeloop: do
!  primelist(i) = primelist(i-1)+k
!  isPrime= .true.
!  do j = 1, i-1
!	if (modulo(primeList(i), primeList(j)) == 0) then
!		k++
!		cycle primeloop
!	endif
!  end do
!  call cpu_time(stop_time)
!  if(stop_time-start_time>1) then
!	print *, "Biggest prime: " , primelist(i-1)
!	prtin *, "what number of prime: " , i-1
!  end if
!  k = 1
!  i++
  
		
end program