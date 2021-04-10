#include <stdio.h>
#include <unistd.h>
#include <time.h>


int main(int argc, char** argv) {
    // Print a time matching other calls to clock_gettime() in the bubble
    struct timespec tv;
    clock_gettime(CLOCK_MONOTONIC, &tv);
    time_t t = time(0);  

    fprintf(stderr, "%f\n", tv.tv_sec + (double)tv.tv_nsec / 1000000000.0);     
    char tmpBuf[255];   
    strftime(tmpBuf, 255, "%T", localtime(&t)); //format date and time. 
    fprintf(stderr, "%s\n", tmpBuf);
	return 0;
}
