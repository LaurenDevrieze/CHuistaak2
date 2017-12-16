! This program searches for the n'th prime, but not in the most efficient way...
program prime

!Lauren Devrieze

!Tijdsbesteding:

!Commando's

!Optimalisaties 

!	(1) useless, 2de dimensie primeList, overbodige printstatements, nbChecks verwijderen
!		pn = 65731 n = 6569

!	(2) j hoeft maar tot sqrt(i) te lopen en eenmaal isPrime vals is weten we zeker dat die i geen priem is dus kunnen
!		we uit de do lus springen
!		pn = 7741009 n = 523471

!	(3) Stappen van 2 ipv 1 nemen aangezien alle even getallen toch niet moeten meegerekend worden.
!		pn = 8336387 n = 560881


implicit none
real :: start_time,stop_time
integer					:: n, i, j, Jmax !nbChecks
integer, dimension(:), allocatable	:: primeList
logical				:: isPrime
!real					:: useless(900)

!write(unit=*, fmt="(A)", advance="no") "Enter the value of n: "
!read *, n

call cpu_time(start_time)

n = 4000000

!nbChecks = 0
allocate(primeList(n))


primeList(1) = 2
primeList(2) = 3
!write(unit=*, fmt="(A, I0, A, I0)") "Prime ", 1, ": ", primeList(1,1)
do i = 3,n
  primeList(i) = primeList(i-1) 
  do
    primeList(i) = primeList(i) + 2
    !useless(mod(i,900)) = cos(i+0.5)	(1)
    isPrime = .true.
    !do j = 1,i-1	!(2)
	 Jmax = ceiling(sqrt(real(primeList(i))))
	 do j = 1, i/2
      !nbChecks = nbChecks + 1	(1)
      !primeList(3,j) = min(i,j)	(1)
	  if(primeList(j) > Jmax) exit
      if (modulo(primeList(i), primeList(j)) == 0) then
        isPrime = .false.	
		exit	!(2)
      end if
    end do
    if (isPrime) then
	  if(i == 10000 .and. primeList(i) /= 104729) then
		print *, "Fout"
		call exit(1)
	  end if
	  call cpu_time(stop_time)
	  if(stop_time-start_time>1) then
		print *, "Biggest prime: " , primelist(i-1)
		print *, "what number of prime: " , i-1
		deallocate(primeList)
		call exit(0)
	  end if
      !write(unit=*, fmt="(A, I0, A, I0)") "Prime ", i, ": ", primeList(1,i) (1)
      exit
    end if
  end do
end do

!isPrime = true
!do i = 2, sqrt(real(n))
!	if(isPrime(i)) then
!		do j = i*i , n , i
!			isPrime(j) = .false.
!		end do
!	end if
!end do 
	

!write(unit=*, fmt="(A, I0, A, I0, A, L, A)")  "! Prime ", n, " is ", primeList(1,n), ", check = ", .false., ", adjusted: " 



end program prime