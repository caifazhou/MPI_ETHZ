
#include <stdio.h>

#ifdef _OPENMP
#include <omp.h>
#endif

double work1(int a){
  return a+1;
}

double work2(double a, int b){
  return a+b;
}

int main(void){
  double x,y,tmp;
  int i;

#pragma omp parallel shared(x)
  {
#   pragma omp for reduction(+:x)
    for(i=1; i< 100; i++){
      //tmp=work1(i);
      x=x+work1(i);
    }
	# pragma omp critical
    y = x;
  }/* end parallel*/
  printf("%g\n",y);
}
