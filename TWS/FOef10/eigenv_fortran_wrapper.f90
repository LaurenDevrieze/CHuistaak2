subroutine f_eig(mptr, n, eigvr, eigvi) bind(c, name='fortran_eig')
	use,intrinsic :: iso_c_binding, only: c_double, c_int
	use, intrinsic :: iso_fortran_env
	implicit none
	integer(c_int) :: n, info
	real(c_double), dimension(*):: mptr
	real(c_double), dimension(*) :: eigvr,eigvi
	real(c_double), dimension(3*n) :: work 
	real(c_double), dimension(:,:), allocatable :: matrix
	real(c_double), dimension(n) :: VL,VR
	subroutine av(mptr, n, x, y) bind(c,name='avc')
		use,intrinsic :: iso_c_binding, only: c_double, c_int
		use, intrinsic :: iso_fortran_env
		implicit none
		real(c_double), dimension(*):: mptr
		integer(c_int) :: n
		real(c_double), dimension(*) :: x,y
	end subroutine
	do i = 1, n
			matrix(:,i) = 
		end do 
	allocate(matrix(n,n))
	call random_number(matrix)
	call DGEEV('N','N',n,matrix,n,eigvr,eigvi,VL,1,VR,1,work,3*n,info)
	deallocate(matrix)
end subroutine

	
