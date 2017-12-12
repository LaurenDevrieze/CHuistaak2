program timingProg

!   Tests of several square matrix-matrix products

program dmr
    use matrixop
    implicit none
    !--------------------------------------------------------------------------
    ! Abstract interfaces
    !
    ! NOTE: this simplifies the timings.
    !--------------------------------------------------------------------------
    abstract interface
        subroutine a_maal_b_interface(a, b, c)
            import dp
            real(kind=dp), dimension(:,:), intent(in)  :: a, b
            real(kind=dp), dimension(:,:), intent(out) :: c
        end subroutine a_maal_b_interface
        subroutine a_maal_b_blocks_interface(a,b,c,blocksize)
            import dp
            real(kind=dp), dimension(:,:), intent(in)  :: a, b
            real(kind=dp), dimension(:,:), intent(out) :: c
            integer, intent(in) :: blocksize
        end subroutine a_maal_b_blocks_interface
    end interface
    
    !--------------------------------------------------------------------------
    ! Main timing program
    !--------------------------------------------------------------------------
    integer :: k, N, blocksize, idx_i, idx_j
    real :: flops
    real :: dummy_i, dummy_j
    integer, dimension(:), allocatable :: seed
    real(kind=dp), dimension(:,:), allocatable :: a, b, c
    real(kind=dp), dimension(:,:), allocatable :: c_matmul

    ! Request the N and blocksize
    write(unit=*, fmt="(A)", advance="no") "Enter the value for N: "
    read *, N
    write(unit=*, fmt="(A)", advance="no") "Enter the blocksize of the sub-blocks: "
    read *, blocksize

    ! Make sure we use the same pseudo-random numbers each time by initializing
    ! the seed to a certain value.
    call random_seed(size=k)
    allocate(seed(k))
    seed = N
    call random_seed(put=seed)

    ! Allocate the matrices and one reference matrix
    allocate(a(N,N), b(N,N), c(N,N), c_matmul(N,N))
    call random_number(a)
    call random_number(b)
    call a_maal_b_matmul(a,b,c_matmul) ! Reference value

    ! Start the timings
    
    ! 1. Three nested loops
    call do_timing(a_maal_b_ijk ) !nog methode aanpassen
    
    ! 2. Two nested loops with vector operations
    call do_timing( "IKJ, J VECT", a_maal_b_ikj_vect ) !nog aanpassen
    
    ! 3. Two nested loops with dot_product
    call do_timing( "IJ DOT_PRODUCT", a_maal_b_ij_dot_product ) !nog aanpassen
    
    ! 5. Using BLAS
    call do_timing(a_maal_b_blas )
    
    ! 6. In blocks
    call do_timing(method_blocks=a_maal_b_blocks )
    
    ! 7. Intrinsic matmul function
    call do_timing(a_maal_b_matmul )
    
    ! Clean up
    deallocate(a, b, c, c_matmul)

contains

    subroutine do_timing(method, method_blocks )
        procedure(a_maal_b_interface), optional :: method
        procedure(a_maal_b_blocks_interface), optional :: method_blocks
        real :: t1, t2, time
		integer :: i
		time = 0
        ! Do the timing
		do i = 1,N
			do j = 1,10
				if( present(method) ) then
					call cpu_time(t1)
					call method( a, b, c )
					call cpu_time(t2)
					time = time + t2-t1
				else
					call cpu_time(t1)
					call method_blocks( a, b, c, blocksize)
					call cpu_time(t2)
					time = time + t2-t1
				end if
			enddo
			print *, i , ' ' , time/10 
		enddo
    end subroutine do_timing

end program timingProg