
#include <iostream>

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

#pragma omp parallel shared(x) private(tmp) 
  {
#   pragma omp for reduction(+:x) nowait
    for(i=1; i< 100; i++){
      tmp=work1(i);
      x=x+tmp;
    }

    y = x;
  }/* end parallel*/
  std::cout << y << "\n";
}
