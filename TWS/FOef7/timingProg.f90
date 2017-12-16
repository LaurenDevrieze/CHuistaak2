program timingProg
!Lauren Devrieze

! Tijdsbesteding: 5-6 uur

! Commando's: ifort -o timing matrixop.f90 timingProg.90 -lblas
!	Na het uitproberen van verschillende compilers en optimalisatie vlaggen bleek ifort het best te zijn dus wordt deze compiler
!	gebruikt bij alle testen.

! Bespreking: 
!	Om te bepalen welke methode het best is zal in dit geval vooral naar snelheid gekeken worden. Natuurlijk zijn er nog andere
!	prioriteiten die in hfdst 3 vermeld staan. Correctheid is de belangrijkste hier. Bij de implementatie van de verschillende
!	werd al gestest op deze factor. Hoeveel geheugen er gebruikt wordt zal ook een rol spelen. Vooral bij de bloksgewijze vermenigvuldiging
!	heeft de grootte van de cache invloed op welke blokgroote er nodig is.

!	Het aantal Mflop/s dat de computer die voor de testen gebruikt werd kan bereiken is 16610 Mflop/s. Dit is heel wat hoger dan
!	de verkregen waarden in de figuur, maar dat is normaal aangezien de processor nog taken op de achtergrond uitvoert 

!	Om de figuur te plotten werd data gebruikt voor N = 50 tot 1000 met stappen van 10.
!	In de figuur is duidelijk te zien dat het aantal Mflop/s naar beneden zal gaan. Dit is logisch want hoe groter de matrix wordt
!	hoe meer tijd zal moeten gespendeert worden aan geheugen verplaatsen. Het product met lussen en vectoren is ongeveer gelijk aan
!	elkaar want de complexiteit voor deze methodes is namelijk allebei van orde O(2N^3). Het dot_product is lager want de complexiteit
!	is lager en de transpose moet ook nog opgesteld worden voor deze methode. 
!	De blas routine is zeer laag omdat de complexiteit van deze methode van O(2*n^2) wat nog een orde lager is dan alle andere methodes.
!	De overige 2 methodes staan niet vermeldt in de grafiek omdat de hoeveelheid Mflop niet gekend is voor de routine matmul en dat daardoor
!	de complexiteit van de block vermenigvuldiging ook niet geweten is.

!	Een variant die nog sneller zou kunnen zijn is een aanpassing van bloksgewijze vermenigvuldiging. Hierbij wordt een variable blokgrootte gebruikt
!	In het begin wordt aan de hand van de cache de maximale blokgrootte genomen en als het eerste blok c_11 uitgerekend wordt zal de blokgrootte 
!	kleiner worden zodat c_11 in de cache kan blijven.
	
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
    integer :: k, N, blocksize, numberMethod, i
    real, dimension(:), allocatable :: flops
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
	! De snelste methodes JKI en KJI zijn ongeveer evensnel. Dit komt omdat in de binnenste loop alle rijen overlopen worden en omdat
	! matrices in Fortran kolomsgewijs opgeslagen worden, liggen de gebruikte elementen steeds naast elkaar.
	! Voor de compiler ifort is dit verschil praktish onbestaande, maar voor andere compilers is er wel een verschil. Dus om flexibel te
	! zijn wordt deze methode gebruikt.
	case(1)
		do i = 50,N,10
			flops(i) = 2*i*i*i
		enddo
		call do_timing(a_maal_b_jki)
    
    ! 2. Nested loop with vector operations
	! Analoog als bij de vorige methode is JKI en KJI de 2 snelste om dezelfde reden als bij de vorige methode, de opslag van de 
	! matrix
	case(2)
		do i = 50,N,10
			flops(i) = 2*i*i*i
		enddo
		call do_timing(a_maal_b_jki_vect)
    
    ! 3. Nested loop with dot_product
	! Bij het dot product is transpose ji het snelst, dit is omdat de transpose van a ervoor zorgt dat het dot_product van 2 kolommen
	! zal genomen worden en dus hetzelfde voordeel er zal zijn als bij de eerder methodes, namelijk de kolomsgewijze opslag van Fortran.
	case(3)
		do i = 50,N,10
			flops(i) = i*i*i
		enddo
		call do_timing(a_maal_b_transp_ji_dot_product)
    
    ! 4. Using BLAS
    case(4)
		do i = 50,N,10
			flops(i) = 2*i*i
		enddo
		call do_timing(a_maal_b_blas)
    
    ! 5. In blocks
	! Omdat de cache 6 MB groot kan in theorie de ideale grootte van een blok 886x886 zijn als met dubbele precisie gewerkt wordt. 
	! De routine die gebruikt wordt voor het vermenigvuldigen maakt wel nog uit, als deze zeer inefficient is zal het voordeel
	! van met blokken te werken teniet gedaan worden.
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
		do i = 50,N,10
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
			print *, i , ' ' , flops(i)/((time/5)*10**6) 
		enddo
    end subroutine do_timing

end program timingProg