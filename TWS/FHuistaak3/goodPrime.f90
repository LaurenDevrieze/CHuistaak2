
program goodPrime

implicit none

real			:: start_time, stop_time
integer			:: i, k, j
integer, dimension(:), allocatable :: primeList

allocate(primeList(400000))

primeList(1) = 2
i = 2
k = 1
primeloop: do
  primeList(i) = primeList(i-1)+k
  do j = 1, i-1
	if (modulo(primeList(i), primeList(j)) == 0) then
		k = k + 1
		cycle primeloop
	endif
  end do
  call cpu_time(stop_time)
  if(stop_time-start_time>1) then
	print *, "Biggest prime: " , primelist(i-1)
	print *, "what number of prime: " , i-1
	call exit()
  end if
  k = 1
  i = i + 1
end do primeloop

deallocate(primeList)

end program 
 