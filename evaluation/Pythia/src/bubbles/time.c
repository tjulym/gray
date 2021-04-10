#include <stdio.h>
#include <unistd.h>
#include <time.h>


int main(int argc, char** argv) {
    // Print a time matching other calls to clock_gettime() in the bubble
    struct timespec tv;
    clock_gettime(CLOCK_MONOTONIC, &tv);
    fprintf(stderr, "%f\n", tv.tv_sec + (double)tv.tv_nsec / 1000000000.0);
	return 0;
}
