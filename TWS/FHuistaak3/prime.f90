! This program searches for the n'th prime, but not in the most efficient way...
program prime

!Lauren Devrieze

!Tijdsbesteding:

!Commando's

!Optimalisaties 

!	(0) Geen optimalisaties, maar wel enkele aanpassingen zodat programma met tijd werkt
!	en niet met hoeveel priemgetallen er gevraagd zijn.
!	pn = 3665144	n = 15

!	(1) real array useless wordt niet gebruikt dus deze moet niet opgesteld worden.


implicit none

real					:: start_time, stop_time
integer					:: n, i, j, k, nbChecks
integer, dimension(:,:),allocatable :: primeList	!no allocatable? 
logical					:: isPrime
real					:: useless(900)

call cpu_time(start_time)

!write(unit=*, fmt="(A)", advance="no") "Enter the value of n: " (0)
!read *, n

nbChecks = 0
allocate(primeList(3,100000))

primeList(1,1) = 2
write(unit=*, fmt="(A, I0, A, I0)") "Prime ", 1, ": ", primeList(1,1)

primeList(1,2)= 3

i = 3
k = 1
!do i = 2,n (0) 
  do
	primeList(1,i) = primeList(1,i-1)
    primeList(1,i) = primeList(1,i) + k
    useless(mod(i,900)) = cos(i+0.5)
    isPrime = .true.
    do j = 1,i-1
      nbChecks = nbChecks + 1
      primeList(3,j) = min(i,j)
      if (modulo(primeList(1,i), primeList(1,j)) == 0) then
        isPrime = .false.
      end if
    end do
    if (isPrime) then
	  call cpu_time(stop_time)
	  if(stop_time-start_time > 1) then
		print *, stop_time-start_time
		print *, "Biggest prime: " , primeList(1,i-1)
		print *, "Number of primes: ", i-1
		exit
	  end if
      write(unit=*, fmt="(A, I0, A, I0)") "Prime ", i, ": ", primeList(1,i)
	  i = i + 1
      !exit
	else
		k = k + 1
	end if
  end do
!end do

write(unit=*, fmt="(A, I0, A, I0, A, L, A)")  "! Prime ", i, " is ", primeList(1,i), ", check = ", .false., ", adjusted: " 

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