program parallel_cholesky
!Lauren Devrieze

!Commando's: gfortran -o parallel parallel_cholesky.f90
!			 mpirun -n p parallel
!				met p aantal processen

!Tijdsbesteding: x!!! uur

!Bespreking: Om te controleren of de processen wel parallel lopen checken
!			 de print statements. Deze zijn niet in de verwachte volgorde
!			 moesten de processen sequentieel lopen.

use mpi

implicit none

integer, parameter :: N = 10
real, parameter :: pi = 4*atan(1.0)
complex, dimension(:,:), allocatable :: H, L
complex, dimension(:), allocatable :: matlin
real :: b,c, som
integer :: f ,i ,j, info, error, id, tag, status, p
logical :: juist, alJuist

call mpi_init(error)

allocate(H(N,N))
allocate(L(N,N))
allocate(matlin(N*(N+1)/2))

!Genereer H
do i = 1,N
	do j = 1,N
		call random_number(b)
		call random_number(c)
		H(i,j) = sqrt(-2*log(b))*exp(2*pi*cmplx(0.0,1.0)*c)
	end do
end do	
H = H*transpose(conjg(H))

!Plaats H in een array met 1 dimensie om the cholesky compositie 
!te kunnen uitvoeren
f = 1
do j = 1,N
	do i = j,N
		matlin(f) = H(i,j)
		f = f + 1
	end do
end do

!Voer de cholesky decompositie uit
call cpptrf('L',N,matlin,info)

!Plaats de resultaten in een benedendriehoek matrix L
f = 1
do j = 1,N
	do i = j,N
		L(i,j) = matlin(f)
		f = f + 1
	end do
end do

!Bereken de som van de elementen strikt boven de diagonaal van L
som = 0
do j = 2,N
	do i = 1,j-1
		som = som + L(i,j) 
	end do
end do

!Check of L juist is
H = L*transpose(conjg(L))

!Print voor ieder proces informatie af.
call mpi_comm_rank(mpi_comm_world,id,error)
print *, 'proces: ' , id, 'met eerste element H:', H(1,1) , 'en som boven de diagonaal van L: ' , som
if(id == 1) then
	alJuist = juist
	call mpi_comm_size(mpi_comm_world,p,error)
	do i = 2,p
		call MPI_Recv(juist,1,MPI_LOGICAL,i,tag,MPI_COMM_WORLD, error )
		if(.not. juist) alJuist = .false.
	end
	if(alJuist) then
		print *, 'Proces ' , id , ': alle processen geven een juist resultaat.'
	else
		print *, 'Proces ' , id , ': er zijn processen die geen juist resultaat geven.'
	endif
else
	call MPI_Send(juist,1,MPI_LOGICAL,1,tag,MPI_COMM_WORLD, error )
endif

call MPI_Finalize(error)

end program