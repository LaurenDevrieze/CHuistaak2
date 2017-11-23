program hello_world

use mpi

implicit none

character(32) :: string = "Hello world from process "
integer :: error,p,id

call mpi_init(error)

call mpi_comm_size(mpl_comm_world,p,error)

do i = 1, p
	call mpi_comm_rank(mpi_comm_world,id,error)
	if(id == 1) print *, "Number of processes: ", p
	print *, string , id

call mpi_finalize(error) 

end program
