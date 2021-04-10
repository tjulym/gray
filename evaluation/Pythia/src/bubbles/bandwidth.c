/**
 * Author: Yunqi Zhang
 * Email: yunqi@umich.edu
 *
 * Original Bubble by: Jason Mars (mars.ninja@gmail.com)
 */

#include <stdio.h>
#include <stdlib.h>

#define MASK 0xd0000001u
#define RAND (lfsr = (lfsr >> 1) ^ (unsigned int)(0 - (lfsr & 1u) & MASK))
#define FOOTPRINT 16777216

char* data_chunk;

int main (int argc, char* argv[]) {
  register unsigned lfsr;
  lfsr = time(0);
  data_chunk = (char*) malloc (FOOTPRINT * sizeof(char));
  char* first_chunk  = data_chunk;
  char* second_chunk = data_chunk + FOOTPRINT / 2;
  int i;

  while (1) {
    for (i = 0; i < FOOTPRINT / 2; i += 64) {
      first_chunk[i] = second_chunk[i] + 1;
    }
    for (i = 0; i < FOOTPRINT / 2; i += 64) {
      second_chunk[i] = first_chunk[i] + 1;
    }
  }
  return 0;
}
