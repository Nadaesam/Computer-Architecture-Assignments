#include <stdio.h>

int main() {
    double n;
    scanf("%lf", &n);
   double res = 0;
    for (double i = 1; i <= n; ++i) {
     res +=(i + (1 / (i * i)));
    }
    printf("res = %lf", res);
    return 0;
}
