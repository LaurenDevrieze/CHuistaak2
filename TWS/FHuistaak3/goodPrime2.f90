program goodPrime

implicit none

real			:: start_time, stop_time
integer			:: i, k, j, maxJ
integer, dimension(:), allocatable :: primeList

call cpu_time(start_time)

allocate(primeList(400000))

primeList(1) = 2

k = 2
primeloop: do i = 3,4000000,2
  maxJ = Ceiling(sqrt(real(i)))
  do j = 2, maxJ
	if (mod(i, j) == 0) then
		!print *, i
		cycle primeloop
	endif
  end do
  if(k == 10000 .and. i /= 104729) then
	print *, "Fout"
	call exit(1)
  end if
  primeList(k) = i
  call cpu_time(stop_time)
  if(stop_time-start_time>1) then
	print *, "Biggest prime: " , primelist(k-1)
	print *, "what number of prime: " , k-1
	exit
  end if
  k = k + 1
end do primeloop

print *, primeList(3)
print *, primeList(4)
print *, primeList(5)
print *, "einde"

deallocate(primeList)

end program 