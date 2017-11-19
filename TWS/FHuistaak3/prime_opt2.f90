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




implicit none

real					:: start_time, stop_time
integer					:: n, i, j, k !nbChecks	(1)
!integer, dimension(:,:),allocatable :: primeList	(2)
integer, dimension(:),allocatable :: primeList	
logical					:: isPrime
!real					:: useless(900)	(1)

call cpu_time(start_time)

!write(unit=*, fmt="(A)", advance="no") "Enter the value of n: " (0)
!read *, n

!nbChecks = 0	(1)
!allocate(primeList(3,100000))	(2)
allocate(primeList(100000))

primeList(1) = 2
write(unit=*, fmt="(A, I0, A, I0)") "Prime ", 1, ": ", primeList(1) 

i = 2
k = 1
!do i = 2,n (0) 
  do
	primeList(i) = primeList(i-1)
    primeList(i) = primeList(i) + k
    !useless(mod(i,900)) = cos(i+0.5)	(1)
    isPrime = .true.
    do j = 1,i-1
      !nbChecks = nbChecks + 1	(1)
      !primeList(3,j) = min(i,j)	(2)
      if (modulo(primeList(i), primeList(j)) == 0) then
        isPrime = .false.
      end if
    end do
    if (isPrime) then
	  if(i == 10000 .and. primeList(i) /= 104729) then 
		print *, "Fout"
		call exit(1)
	end if
	  call cpu_time(stop_time)
	  if(stop_time-start_time > 1) then
		print *, "Biggest prime: " , primeList(i-1)
		print *, "Number of primes: ", i-1
		exit
	  end if
      write(unit=*, fmt="(A, I0, A, I0)") "Prime ", i, ": ", primeList(i)	
	  i = i + 1
      !exit	(0)
	else
		k = k + 1
	end if
  end do
!end do	(0)

write(unit=*, fmt="(A, I0, A, I0, A, L, A)")  "! Prime ", i, " is ", primeList(i), ", check = ", .false., ", adjusted: " 

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
  
		
end program prime