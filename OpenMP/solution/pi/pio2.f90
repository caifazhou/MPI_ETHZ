program compute_pi
implicit none 

! times using cpu_time
real t0,t1
!--unused-- use omp_lib 
!$ integer omp_get_num_threads 
!$ double precision omp_get_wtime
!$ double precision wt0,wt1   

integer i,num_threads
integer, parameter        :: n=10000000
real(kind=8) w,x,sum,sum0,pi,f,a

! function to integrate
f(a)=4.0_8/(1.0_8+a*a)

!$omp parallel
!$omp single
!$  write (*,*) 'OpenMP-parallel with',omp_get_num_threads(),'threads'
!$omp end single
!$omp end parallel

!$ wt0=omp_get_wtime() 
call cpu_time(t0)

! calculate pi = integral [0..1] 4/(1+x**2) dx
w=1.0_8/n
sum=0.0_8
!$OMP PARALLEL PRIVATE(x,sum0,num_threads), SHARED(w,sum)
sum0=0.0_8 
num_threads=1
!$ num_threads=omp_get_num_threads()
!$OMP DO SCHEDULE(STATIC,(n-1)/num_threads+1)
do i=1,n
   x=w*(i-0.5_8)
   sum0=sum0+f(x)
enddo
!$OMP END DO
!$OMP DO ORDERED SCHEDULE(STATIC,1)
do i=1,num_threads
!$OMP ORDERED
   sum=sum+sum0
!$OMP END ORDERED
enddo 
!$OMP END DO
!$OMP END PARALLEL
pi=w*sum

call cpu_time(t1)
!$ wt1=omp_get_wtime() 

write (*,'(/,a,1pg24.16)')   'computed pi = ', pi
write (*,'(/,a,1pg12.4)')    'cpu_time:     ', t1-t0
!$ write (*,'(/,a,1pg12.4)') 'omp_get_wtime:', wt1-wt0
stop
end program compute_pi