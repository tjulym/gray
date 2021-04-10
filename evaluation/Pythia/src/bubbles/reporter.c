/**
 * Author: Yunqi Zhang
 * Email: yunqi@umich.edu
 *
 * Original Bubble by: Jason Mars (mars.ninja@gmail.com)
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MASK 0xd0000001u
#define RAND (lfsr = (lfsr >> 1) ^ (unsigned int)(0 - (lfsr & 1u) & MASK))
#define CACHE_LINE_SIZE 64
#ifndef FOOTPRINT
#define FOOTPRINT (20*1024*1024)
#endif

char* data_chunk;

int main (int argc, char* argv[]) {
  register unsigned lfsr;
  lfsr = time(NULL);
  int i;

  data_chunk = (char*)malloc(FOOTPRINT * sizeof(char));
  
  time_t time_limit;
  if (argc >= 2) {
    time_limit = atoi(argv[1]);
  } else {
    time_limit = 0;
  }
 
  // Print PID for background killing purposes
  printf("%d\n", getpid());
  fflush(stdout);
 
  time_t start_time = time(NULL);

  while (time_limit == 0 || time(NULL) - start_time <= time_limit) {
    char* first_chunk  = data_chunk;
    char* second_chunk = data_chunk + (FOOTPRINT >> 1);
//    char* third_chunk = data_chunk + (FOOTPRINT >> 1);
    char* fourth_chunk = data_chunk + 3 * (FOOTPRINT >> 2);
/*    char* first_chunk  = data_chunk;
    char* second_chunk = data_chunk + FOOTPRINT/8;
    char* third_chunk = data_chunk + FOOTPRINT/4;
    char* fourth_chunk = data_chunk + 3*FOOTPRINT/8;
    char* fifth_chunk = data_chunk + FOOTPRINT/2;
    char* sixth_chunk = data_chunk + 5*FOOTPRINT/8;
    char* seventh_chunk = data_chunk + 3*FOOTPRINT/8;
    char* eighth_chunk = data_chunk + 7*FOOTPRINT/8;*/


    for (i = 0; i < (FOOTPRINT >> 1); i += CACHE_LINE_SIZE) {
      //data_chunk[RAND % FOOTPRINT]++;
      first_chunk[i]++;
      second_chunk[i]++;
//      data_chunk[RAND % FOOTPRINT]++;
//      third_chunk[i]++;
//      fourth_chunk[i]++;
    /*  fifth_chunk[i]++;
      sixth_chunk[i]++;
      seventh_chunk[i]++;
      eighth_chunk[i]++;*/
    }
  }
  return 0;
}
