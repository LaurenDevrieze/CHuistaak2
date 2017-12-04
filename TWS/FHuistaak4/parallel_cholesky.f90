program parallel_cholesky
!Lauren Devrieze

!Commando's: gfortran -o parallel parallel_cholesky.f90 -llapack
!			 mpirun -n p parallel
!				met p aantal processen

!Tijdsbesteding: 3 uur

!Bespreking: Om te controleren of de processen wel parallel lopen checken we
!			 de print statements. Deze zijn niet in de verwachte volgorde
!			 moesten de processen sequentieel lopen en bij iedere uitvoering
!			 is de volgorde anders. Het print statement dat aangeeft of de processen
!			 juist zijn wordt laatst weergegeven omdat ieder proces de info moet
!			 sturen naar proces 0 voor dit kan afgeprint worden.

!			 Om een random nummer voor de parallele processen te generen werdt een stuk
!			 code gebruikt van: https://www.linuxquestions.org/questions/programming-9/fortran-90-how-do-i-use-random_number-and-random_seed-913870/
!			 dit geeft soms nog dezelfde getallen voor verschillende processen omdat
!			 ze rond dezelfde tijd uitgevoerd worden.

!Voorbeeld output:
! proces:           3 met eerste element H: (  11.8205795    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           5 met eerste element H: (  11.8205795    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           0 met eerste element H: (  11.8205795    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           1 met eerste element H: (  96.8949814    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           4 met eerste element H: (  96.8949814    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           2 met eerste element H: (  96.8949814    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           7 met eerste element H: (  15.5243406    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           8 met eerste element H: (  15.5243406    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           6 met eerste element H: (  1.79431629    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! proces:           9 met eerste element H: (  19.5601711    ,  0.00000000    ) en som boven de diagonaal van L:    0.00000000    
! Proces           0 : alle processen geven een juist resultaat.

 
use mpi

implicit none

integer, parameter :: N = 10
real, parameter :: pi = 4*atan(1.0)
complex, dimension(:,:), allocatable :: H, L
complex, dimension(:), allocatable :: matlin
real :: b,c, som
integer :: f ,i ,j, info, error, id, tag, status(mpi_status_size), p,m
logical :: juist, alJuist
integer, dimension(8) :: value
integer, dimension(:), allocatable :: seed

call mpi_init(error)

allocate(H(N,N))
allocate(L(N,N))
allocate(matlin(N*(N+1)/2))

!Genereer H
do i = 1,N
	do j = 1,N
		call date_and_time(values = value)
		call random_seed(size = m)
  		allocate(seed(m))
		seed(:) = value(8)
		call random_seed(put=seed)
		call random_number(b)
		call date_and_time(values = value)
		seed(:) = value(8)
		call random_seed(put=seed)
		call random_number(c)
		deallocate(seed)
		H(i,j) = sqrt(-2*log(b))*exp(2*pi*cmplx(0.0,1.0)*c)
	end do
end do	
H = matmul(H,transpose(conjg(H)))

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
L = matmul(L,transpose(conjg(L)))
juist = .false.
if(maxval(abs(H-L)) < 0.00001) then
	juist = .true.
endif


!Print voor ieder proces informatie af.
call mpi_comm_rank(mpi_comm_world,id,error)
print *, 'proces:' , id, 'met eerste element H:', H(1,1) , 'en som boven de diagonaal van L: ' , som
if(id .ne. 0) then
	call MPI_Send(juist,1,MPI_LOGICAL,0,id,MPI_COMM_WORLD, error )	
else
	alJuist = juist
	call mpi_comm_size(mpi_comm_world,p,error)
	do i = 1,p-1
		call mpi_recv(juist,1,MPI_LOGICAL,i,i,MPI_COMM_WORLD, status,error )
		if(.not. juist) alJuist = .false.
	end do
	if(alJuist) then
		print *, 'Proces' , id , ': alle processen geven een juist resultaat.'
	else
		print *, 'Proces' , id , ': er zijn processen die geen juist resultaat geven.'
	endif	
endif

call MPI_Finalize(error)

end program
