#include <stdio.h>

factorial() {
  int i, n, fact = 1;

  printf("\nEnter a number: ");
  scanf("%d", &n);

  for (i = 1; i <= n; i++) {
    fact *= i;
  }

  printf("Factorial of %d is %d", n, fact);
  //return 0;
}
