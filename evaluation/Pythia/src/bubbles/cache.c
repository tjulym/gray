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
#define FOOTPRINT 32768

char* data_chunk;

int main (int argc, char* argv[]) {
  register unsigned lfsr;
  lfsr = time(0);
  data_chunk = (char*) malloc (FOOTPRINT * sizeof(char));
  while (1) {
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
    data_chunk[RAND % FOOTPRINT]++; data_chunk[RAND % FOOTPRINT]++;
  }
  return 0;
}
