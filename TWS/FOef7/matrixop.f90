!   Implementation of several square matrix-matrix products

module matrixop
    implicit none
    integer, parameter :: dp = selected_real_kind(15,307)
contains
    !--------------------------------------------------------------------------
    ! 1. Three nested loops
    !
    ! NOTE: use the following convention for the indices
    !       i = row index of A
    !       j = column index of B
    !       k = column index of A
    !--------------------------------------------------------------------------
    subroutine a_maal_b_ijk(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
		integer :: i,j,k,Msize
		Msize = size(a,1)
		c = 0.0_dp
		do i = 1,Msize
			do j = 1,Msize
				do k = 1,Msize
					c(i,j) = c(i,j) + a(i,k)*b(k,j)
				end do
			end do
		end do
    end subroutine a_maal_b_ijk

    subroutine a_maal_b_ikj(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
		integer :: i,j,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do i = 1,Msize
			do k = 1,Msize
				do j = 1,Msize
					c(i,j) = c(i,j) + a(i,k)*b(k,j)
				end do
			end do
		end do
    end subroutine a_maal_b_ikj

    subroutine a_maal_b_jik(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do j = 1,Msize
			do i = 1,Msize
				do k = 1,Msize
					c(i,j) = c(i,j) + a(i,k)*b(k,j)
				end do
			end do
		end do
    end subroutine a_maal_b_jik

    subroutine a_maal_b_jki(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do j = 1,Msize
			do k = 1,Msize
				do i = 1,Msize
					c(i,j) = c(i,j) + a(i,k)*b(k,j)
				end do
			end do
		end do
    end subroutine a_maal_b_jki

    subroutine a_maal_b_kij(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do k = 1,Msize
			do i = 1,Msize
				do j = 1,Msize
					c(i,j) = c(i,j) + a(i,k)*b(k,j)
				end do
			end do
		end do
    end subroutine a_maal_b_kij
    
    subroutine a_maal_b_kji(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do k = 1,Msize
			do j = 1,Msize
				do i = 1,Msize
					c(i,j) = c(i,j) + a(i,k)*b(k,j)
				end do
			end do
		end do
    end subroutine a_maal_b_kji
    !--------------------------------------------------------------------------
    ! 2. Two nested loops with vector operations
		!nog probleem
    !--------------------------------------------------------------------------
    subroutine a_maal_b_ikj_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do i = 1,Msize
			do k = 1,Msize
				c(i,:) = c(i,:) + a(i,k)*b(k,:)
			end do
		end do
    end subroutine a_maal_b_ikj_vect

    subroutine a_maal_b_jki_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: j,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do j = 1,Msize
			do k = 1,Msize
				c(:,j) = c(:,j) + a(:,k)*b(k,j)
			end do
		end do
    end subroutine a_maal_b_jki_vect

    subroutine a_maal_b_kij_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do k = 1,Msize
			do i = 1,Msize
				c(i,:) = c(i,:) + a(i,k)*b(k,:)
			end do
		end do
    end subroutine a_maal_b_kij_vect

    subroutine a_maal_b_kji_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: j,k,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do k = 1,Msize
			do j = 1,Msize
				c(:,j) = c(:,j) + a(:,k)*b(k,j)
			end do
		end do
    end subroutine a_maal_b_kji_vect
    !--------------------------------------------------------------------------
    ! 3. Two nested loops with dot_product
    !--------------------------------------------------------------------------
    subroutine a_maal_b_ij_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: j,i,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do i = 1,Msize
			do j = 1,Msize
				c(i,j) = dot_product(a(i,:),b(:,j))
			end do
		end do
    end subroutine a_maal_b_ij_dot_product

    subroutine a_maal_b_ji_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: j,i,Msize
		Msize = size(a,1)
        c = 0.0_dp
		do j = 1,Msize
			do i = 1,Msize
				c(i,j) = dot_product(a(i,:),b(:,j))
			end do
		end do
    end subroutine a_maal_b_ji_dot_product
    !--------------------------------------------------------------------------
    ! 4. Two nested loops with dot_product and explicit transpose of matrix A
    !--------------------------------------------------------------------------
    subroutine a_maal_b_transp_ij_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
		real(kind=dp), dimension(:,:), allocatable :: a_tr
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: j,i,Msize
		Msize = size(a,1)
		allocate(a_tr(Msize,Msize))
		a_tr = transpose(a)
        c = 0.0_dp
		do i = 1,Msize
			do j = 1,Msize
				c(i,j) = dot_product(a_tr(:,i),b(:,j))
			end do
		end do
		deallocate(a_tr)
    end subroutine a_maal_b_transp_ij_dot_product

    subroutine a_maal_b_transp_ji_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
		real(kind=dp), dimension(:,:), allocatable :: a_tr
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: j,i,Msize
		Msize = size(a,1)
		allocate(a_tr(Msize,Msize))
		a_tr = transpose(a)
        c = 0.0_dp
		do j = 1,Msize
			do i = 1,Msize
				c(i,j) = dot_product(a_tr(:,i),b(:,j))
			end do
		end do
		deallocate(a_tr)
    end subroutine a_maal_b_transp_ji_dot_product
    !--------------------------------------------------------------------------
    ! 5. Using BLAS : Add library in linking phase
    !--------------------------------------------------------------------------
    subroutine a_maal_b_blas(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        c = 0.0_dp
		call dgemm('n','n', size(a,1), size(b,2),size(a,2),1.0_dp,a,size(a,1),b,size(a,2),0.0_dp,c,size(a,1))
    end subroutine a_maal_b_blas
   
    !--------------------------------------------------------------------------
    ! 6. In blocks
    !--------------------------------------------------------------------------
    subroutine a_maal_b_blocks(a, b, c, blocksize)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
		real(kind=dp), dimension(:,:),allocatable :: c_t
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer, intent(in) :: blocksize
		integer :: i,j,k, blocks, i_end, j_end, k_end,n
		c = 0.0_dp
		n = size(a,1)
		if(n <= blocksize) then
			call a_maal_b_matmul(a,b,c)
		else
			allocate(c_t(blocksize,blocksize))
			do j = 1,n, blocksize
				j_end = min(j+blocksize-1,n)
				do k = 1,n, blocksize
					k_end = min(k+blocksize-1,n)
					do i = 1,n, blocksize
						i_end = min(i+blocksize-1,n)
						call a_maal_b_matmul(a(i:i_end,k:k_end),b(k:k_end,j:j_end),c_t)
						c(i:i_end,j:j_end) = c(i:i_end,j:j_end) + c_t
					enddo
				enddo
			enddo
			deallocate(c_t)
		endif
    end subroutine a_maal_b_blocks
    !--------------------------------------------------------------------------
    ! 7. Intrinsic matmul function
    !--------------------------------------------------------------------------
    subroutine a_maal_b_matmul(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        c = matmul( a, b ) ! Already completed
    end subroutine a_maal_b_matmul

end module matrixop
