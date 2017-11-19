program intHist

implicit none

integer, dimension(3) :: sel
integer, dimension(9) :: v
v = (/6,2,3,1,3,0,3,1,2/)
call integer_hist(v)
sel = (/1,2,10/)
write (unit =*,fmt="(A11,3I4 )") "De getallen" , sel
call integer_hist(v,sel)
write(unit=*,fmt="(A11,3I4)") "komen resp." , sel , " keer voor"

contains

subroutine integer_hist(v,sel)
	integer, dimension(:), allocatable :: c
	integer, dimension(:), intent(in) :: v
	integer :: i,j,k
	logical, dimension(:), allocatable :: changed
	integer, dimension(:), intent(inout), optional :: sel
	allocate(c(0:maxval(v)))
	if(present(sel)) then
		allocate(changed(size(sel)))
		changed = .false.
	end if
	c = 0
	do i = 1, size(v)
		c(v(i)) = c(v(i)) + 1
		if(present(sel)) then
			if(any(sel == v(i))) then
				if(all(v(i+1:size(v)) /= v(i))) then
					do j = 1 , size(sel)
						if(sel(j) == v(i)) then
							sel(j) = c(v(i))
							changed(j) = .true.
						end if
					end do
				end if
			end if
		else
			if(all(v(i+1:size(v)) /= v(i))) then
				print *, c(v(i)) , " keer" , v(i)
			end if
		end if
	end do
	if(present(sel)) then
		if(any(changed .neqv. .true.)) then
			do k = 1,size(sel)
				if(changed(k) .eqv. .false.) then
					sel(k) = 0
				end if
			end do
		end if
		deallocate(changed)
	end if
		
	deallocate(c)

	
end subroutine

end program