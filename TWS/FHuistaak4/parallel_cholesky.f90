program parallel_cholesky

use mpi

implicit none

integer, parameter :: N = 10
real, parameter :: pi = 4*atan(1.0)
complex, dimension(:,:), allocatable :: H, L
complex, dimension(:), allocatable :: matlin
real :: b,c
integer :: f,i,j,info, error, id

call mpi_init(error)

allocate(H(N,N))
allocate(L(N,N))
allocate(matlin(N*(N+1)/2))

do i = 1,N
	do j = 1,N
		call random_number(b)
		call random_number(c)
		H(i,j) = sqrt(-2*log(b))*exp(2*pi*cmplx(0.0,1.0)*c)
	end do
end do
	
H = H*transpose(conjg(H))

f = 1
do j = 1,N
	do i = j,N
		matlin(f) = H(i,j)
		f = f + 1
	end do
end do

call cpptrf('L',N,matlin,info)

f = 1
do j = 1,N
	do i = j,N
		L(i,j) = matlin(f)
		f = f + 1
	end do
end do

call mpi_comm_rank(mpi_comm_world,id,error)
print *, 'proces: ' , id
print *, 'Eerste element H: ' , H(1,1)

call MPI_Finalize(error)

end program