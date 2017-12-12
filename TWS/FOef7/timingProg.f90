program timingProg
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
    integer :: k, N, blocksize, numberMethod
    real, dimension, allocatable :: flops
    integer, dimension(:), allocatable :: seed
    real(kind=dp), dimension(:,:), allocatable :: a, b, c

    ! Request the N and blocksize
    write(unit=*, fmt="(A)", advance="no") "Enter the value for N: "
    read *, N
    write(unit=*, fmt="(A)", advance="no") "Enter the blocksize of the sub-blocks: "
    read *, blocksize
	write(unit=*, fmt="(A)", advance="no") "Enter which method needs to be timed: "
	read *, numberMethod

    ! Make sure we use the same pseudo-random numbers each time by initializing
    ! the seed to a certain value.
    call random_seed(size=k)
    allocate(seed(k))
    seed = N
    call random_seed(put=seed)

    ! Allocate the matrices and one reference matrix
    allocate(a(N,N), b(N,N), c(N,N))
	allocate(flops(N))
    call random_number(a)
    call random_number(b)

    ! Kies een van de timings om te doen
    
	select case(numberMethod)
    ! 1. Nested loop
	! De methodes JKI en KJI zijn ongeveer evensnel. Dit komt omdat in de binnenste loop alle rijen overlopen worden en sindsdien
	! matrices in Fortran kolomsgewijs opgeslagen worden, liggen de gebruikte elementen steeds naast elkaar.
	case(1)
		do i = 1,N,10
			flops(i) = 2*i*i*i
		enddo
		call do_timing(a_maal_b_jki)
    
    ! 2. Nested loop with vector operations
	! Analoog als bij de vorige methode is JKI en KJI de 2 snelste om dezelfde reden als bij de vorige methode, de opslag van de 
	! matrix
	case(2)
		do i = 1,N,10
			flops(i) = 2*i*i*i
		enddo
		call do_timing(a_maal_b_jki_vect)
    
    ! 3. Nested loop with dot_product
	! Bij het dot product is ij het snelst, dit is omdat
	case(3)
		do i = 1,N,10
			flops(i) = i*i*i
		enddo
		call do_timing(a_maal_b_transp_ji_dot_product) !nog aanpassen klopt niet
    
    ! 4. Using BLAS
    case(4)
		do i = 1,N,10
			flops(i) = 2*i*i
		enddo
		call do_timing(a_maal_b_blas)
    
    ! 5. In blocks
	case(5)
		call do_timing(method_blocks=a_maal_b_blocks )
    
    ! 6. Intrinsic matmul function
	case(6)
		call do_timing(a_maal_b_matmul )
    end select
	
    ! Clean up
    deallocate(a, b, c)

contains

    subroutine do_timing(method, method_blocks )
        procedure(a_maal_b_interface), optional :: method
        procedure(a_maal_b_blocks_interface), optional :: method_blocks
        real :: t1, t2, time
		integer :: i,j
		time = 0
        ! Do the timing
		do i = 1,N,10
			do j = 1,5
				if( present(method) ) then
					call cpu_time(t1)
					call method( a(1:i,1:i), b(1:i,1:i), c(1:i,1:i) )
					call cpu_time(t2)
					time = time + t2-t1
				else
					call cpu_time(t1)
					call method_blocks( a(1:i,1:i), b(1:i,1:i), c(1:i,1:i), blocksize)
					call cpu_time(t2)
					time = time + t2-t1
				end if
			enddo
			print *, i , ' ' , flops/((time/5)*10**6) 
		enddo
    end subroutine do_timing

end program timingProg