program kennismaking
!Lauren Devrieze
!1ste fase master in wiskundige ingenieurstechnieken

!Gecompileerd met gfortran, nagfor en ifort

!$ gfortran -o kennismaking kennismaking.f90

!BESPREKING PROGRAMMA

	!Recursieve functie 

		!Als 8 decimalen gebruikt wordt zullen de berekende faculteiten plots negatief
		!worden, dit komt omdat 8 decimalen niet genoeg zijn om de grotere getallen voor 
		!te stellen, er treed dus overflow op 
		!14 decimalen zijn genoeg om de grotere getallen voor te stellen. Het zal positief 			
		!blijven tot en met n = 29
		!De verschillende compilers hebben geen invloed op de output, behalve in opmaak van
		!de output gegevens. Moest voor de soort integers niet decimalen, maar bytes
		!gekozen worden, zou er vermoedelijk verschil zijn omdat de definitie wat 'kind'
		!betekent verschillend kan zijn bij verschillende compilers.

	!Print subroutine

		!Om alle strings voor te stellen wordt algemeen gebruik gemaakt van:
		!print '(an)', trim(string)
		!De string wordt eerst getrimd zodat geen witruimte na de 40 karakters komt
		!De n wordt dan gebruikt om witruimte vooraan toe te voegen
		!Bij case(i) zal de string niet getrimd worden omdat de karakters specifiek op
		!index geselecteerd worden en zo geen witruimte achteraan zal zijn.
		!Ook wordt er steeds 80 cijfers afgedrukt om duidelijk te kunnen controleren dat
		!de uitlijning correct is

	!Elemental functie graycode(n)
		
		!Opeenvolgende getallen van deze reeks verschillen steeds maar 1 bit. Door de bits
		!steeds op te schuiven en een exclusieve or te gebruiken is het logisch dat steeds 			
		!1 bit zal verschillen


!OUTPUT PROGRAMMA (met gfortran)

! Testen DubbeleFaculteit met 8 decimalen precisie
!           0
!           1
!           1
!           1
!           2
!           3
!           8
!          15
!          48
!         105
!         384
!         945
!        3840
!       10395
!       46080
!      135135
!      645120
!     2027025
!    10321920
!    34459425
!   185794560
!   654729075
!  -579076096
!   864408687
!   145227776
! -1593436679
!  -809500672
! -1181211311
!   427819008
! -1827934325
!  -905969664
! -1470487873
! Testen DubbeleFaculteit met 14 decimalen precisie
!                    0
!                    1
!                    1
!                    1
!                    2
!                    3
!                    8
!                   15
!                   48
!                  105
!                  384
!                  945
!                 3840
!                10395
!                46080
!               135135
!               645120
!              2027025
!             10321920
!             34459425
!            185794560
!            654729075
!           3715891200
!          13749310575
!          81749606400
!         316234143225
!        1961990553600
!        7905853580625
!       51011754393600
!      213458046676875
!     1428329123020800
!     6190283353629375
!12345678901234567890123456789012345678901234567890123456789012345678901234567890
!Dit is huistaak nummer 1 van het vak TWS
!12345678901234567890123456789012345678901234567890123456789012345678901234567890
!                                        Dit is huistaak nummer 1 van het vak TWS
!12345678901234567890123456789012345678901234567890123456789012345678901234567890
!                    Dit is huistaak nummer 1 van het vak TWS
!12345678901234567890123456789012345678901234567890123456789012345678901234567890
!                    er 1 van het vak TWSDit is huistaak numm

!Testen functie graycode met scalar
!           1
!           3
!           2
!           6
!           7
!           5
!           4
!          12
!          13
!          15
!          14
!          10
!          11
!           9
!           8
!          24
!          25
!          27
!          26
!          30
! Testen functie graycode met vector
!           1           3           2           6           7           5           4          12          13          15          14          10          11           9           8          24          25          27          26          30
! Testen functie graycode met matrix
!           1           3           2           6           7           5           4          12          13          15          14          10          11           9           8          24          25          27          26          30


implicit none

!Variablen declareren
integer, parameter :: int8 = selected_int_kind (8)
integer, parameter :: int14 = selected_int_kind (14)
integer(kind=int8) :: i1
integer(kind=int14) :: i2
integer :: i,j
integer :: k(20) = (/ (i, i=1,20) /)
integer, dimension(4,5) :: l = reshape((/ &
	1, 2, 3, 4, 5, &
	6, 7, 8, 9, 10, &
	11, 12, 13, 14, 15, &
	16, 17, 18, 19, 20 /), shape(l))

!Testen DubbeleFaculteit functie
print *, 'Testen DubbeleFaculteit met 8 decimalen precisie'
do i1 = -2,29
	print *,DubbeleFaculteit1(i1)
enddo

print *, 'Testen DubbeleFaculteit met 14 decimalen precisie'
do i2 = -2,29
	print *,DubbeleFaculteit2(i2)
enddo

!Testen Karakter subroutine
call Karakter('l')
call Karakter('r')
call Karakter('c')
call Karakter('i')

!Testen graycode functie
print *, 'Testen functie graycode met scalar'
do j = 1,20
	print *, graycode(j)
enddo

print *, 'Testen functie graycode met vector'
print *, graycode(k)

print *, 'Testen functie graycode met matrix'
print *, graycode(l)

contains

!Recursieve functie die de dubbele faculteit berekent van 8 decimalen precisie n 
integer(kind=int8) recursive function DubbeleFaculteit1(n) result(result1)
	integer(kind=int8),intent(in) :: n
	select case(n)
		case(:-2)
			result1 = 0
		case(0,-1)
			result1 = 1
		case default
			result1 = n*DubbeleFaculteit1(n-2)
	end select
end function

!Recursieve functie die de dubbele faculteit berekent van 14 decimalen precisie n 
integer(kind=int14) recursive function DubbeleFaculteit2(n) result(result1)
	integer(kind=int14),intent(in) :: n
	select case(n)
		case(:-2)
			result1 = 0
		case(0,-1)
			result1 = 1
		case default
			result1 = n*DubbeleFaculteit2(n-2)
	end select
end function  

!Subroutine die een vaste string op een bepaalde manier afprint
subroutine Karakter(letter)
	character(1) :: letter
	character(10) :: numbers(8) = '1234567890'
	character(50) :: string = 'Dit is huistaak nummer 1 van het vak TWS'
	print '(8a10)', numbers
	select case(letter)
		case('l')
			print '(a40)', trim(string)
		case('r')
			print '(a80)', trim(string)
		case('c')
			print '(a60)', trim(string)
		case('i')
			print '(a40,a20)', string(21:40), string(:20)
	end select
end subroutine


integer elemental function graycode(n) result(result2)
	integer, intent(in) :: n
	result2 = ieor(n,ishft(n,-1))
end function

end program
