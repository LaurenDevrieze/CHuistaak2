program intHist

!Lauren Devrieze

!Tijdsbesteding: 3,5 uur

!Commando's: gfortran -o int_hist intHist.f90

!Bespreking:

!	Om zo weinig mogelijk expliciete do-lussen te gebruiken, worden de intrinsieke functies any() en all() gebruikt.
!	Hiermee kan terwijl de do-lus v overloopt gechecked worden of er nog bepaalde elementen later in de lus zullen terug
!	komen en of de bepaalde v(i) ook een element van sel is.
!	Omdat expliciete do-lussen vermeden worden zal voor integer_hist(v) het "a keer b" print statement niet geordend zijn
!	van klein naar groot, maar geordend op wanneer ze laatst voorkomen in v

!Speciale situaties

!	(1) Om te zorgen dat waarden in sel die niet in v zitten als 0 weergegeven worden, wordt er een logica variabele
!	'changed' bijgehouden. Op het einde van de subroutine worden de onverandered waarden van sel op nul gezet

!	(2) Hele grote waarden voor de maximale waarde van v worden geweigerd en er wordt een melding afgeprint. Voor dit
!	geval werd gekozen om als maximale waarde een waarde van 10**6 te nemen.

!	(3) Voor negatieve waarden in v werkt de subroutine ook aangezien c wordt gealloceerd met indexen van de minimum 
!	waarde tot de maximum waarde

implicit none

integer, dimension(3) :: sel
integer, dimension(9) :: v, s
integer, dimension(22) :: r
integer, dimension(4) :: selr
integer :: i

v = (/6,2,3,1,3,0,3,1,2/)
call integer_hist(v)

!(1)
sel = (/1,2,10/)
write (unit =*,fmt="(A11,3I4 )") "De getallen" , sel
call integer_hist(v,sel) 	
write(unit=*,fmt="(A11,3I4)") "komen resp." , sel , " keer voor"

do i = 1, size(r)
	r(i) = int(rand(0)*(9+1-1))+1
end do
selr = (/2,3,5,7/)
write (unit =*,fmt="(A11,4I4 )") "De getallen" , selr
call integer_hist(r,selr)
write(unit=*,fmt="(A11,4I4)") "komen resp." , selr , " keer voor"

!(3)
s = (/6,2,3,1,3,0,-3,1,2/)
call integer_hist(s)

!(2)
s = (/6,2,3,1,3,0,10**6+1,1,2/)
call integer_hist(s)

contains

subroutine integer_hist(v,sel)
	integer, dimension(:), allocatable :: c
	integer, dimension(:), intent(in) :: v
	integer :: i,j,k
	logical, dimension(:), allocatable :: changed
	integer, dimension(:), intent(inout), optional :: sel
	if(maxval(v) <= 10**6) then
		allocate(c(minval(v):maxval(v)))
	else
		print *, "Values in array too large"
		call exit(1)
	end if
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