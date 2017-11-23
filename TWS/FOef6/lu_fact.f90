program lu_fact

implicit none

real, dimension(3,3) :: A,B,L,U,F
integer, dimension(3) :: IPIV
integer :: info,i

call random_number(A)
B = A
L = 0
U = 0

call sgetrf(3,3,A,3,IPIV,info)

U(1,1:3) = A(1,1:3)
U(2,2:3) = A(2,2:3)
U(3,3) = A(3,3)
L(2:3,1) = A(2:3,1)
L(3,2) = A(3,2)
L(1,1) = 1
L(2,2) = 1
L(3,3) = 1

F = L*U  

call slaswp(3,F,3,1,3,IPIV,1)

print *,"B-C", abs(B-F)

do i = 1,3
	print *, L(i,3)
end do 
!print *, "L: " , L
!print *, "U: " , U
!print *, "IPIV: " , IPIV
!print *, "info: " , info

end program
