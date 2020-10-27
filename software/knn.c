#include "system.h"
#include "periphs.h"
#include <iob-uart.h>
#include "iob_timer.h"
#include "iob_knn.h"
#include "random.h" //random generator for bare metal

//uncomment to use rand from C lib 
//#define cmwc_rand rand

#ifdef DEBUG //type make DEBUG=1 to print debug info
#define S 12  //random seed
#define N 10  //data set size
#define K 4   //number of neighbours (K)
#define C 4   //number data classes
#define M 4   //number samples to be classified
#else
#define S 12   
#define N 100000
#define K 10  
#define C 4  
#define M 100 
#endif

#define INFINITE ~0

//
//Data structures
//

//labeled dataset
struct datum {
  short x;
  short y;
  unsigned char label;
} data[N], x[M];

//neighbor info
struct neighbor {
  unsigned int idx; //index in dataset array
  unsigned int dist; //distance to test point
} neighbor[K];

//
//Functions
//

//square distance between 2 points a and b
unsigned int sq_dist( struct datum a, struct datum b) {
  short X = a.x-b.x;
  unsigned int X2=X*X;
  short Y = a.y-b.y;
  unsigned int Y2=Y*Y;
  return (X2 + Y2);
}

//insert element in ordered array of neighbours
void insert (struct neighbor element, unsigned int position) {
  for (int j=K-1; j>position; j--)
    neighbor[j] = neighbor[j-1];

  neighbor[position] = element;

}


///////////////////////////////////////////////////////////////////
int main() {

  unsigned long long elapsed;
  unsigned int elapsedu;

  //init uart and timer
  uart_init(UART_BASE, FREQ/BAUD);
  uart_printf("\nInit timer\n");
  uart_txwait();

  timer_init(TIMER_BASE);
  //read current timer count, compute elapsed time
  //elapsed  = timer_get_count();
  //elapsedu = timer_time_us();


  //int vote accumulator
  int votes_acc[C] = {0};

  //generate random seed 
  random_init(S);

  //init dataset
  for (int i=0; i<N; i++) {

    //init coordinates
    data[i].x = (short) cmwc_rand();
    data[i].y = (short) cmwc_rand();

    //init label
    data[i].label = (unsigned char) (cmwc_rand()%C);
  }

#ifdef DEBUG
  uart_printf("\n\n\nDATASET\n");
  uart_printf("Idx \tX \tY \tLabel\n");
  for (int i=0; i<N; i++)
    uart_printf("%d \t%d \t%d \t%d\n", i, data[i].x,  data[i].y, data[i].label);
#endif
  
  //init test points
  for (int k=0; k<M; k++) {
    x[k].x  = (short) cmwc_rand();
    x[k].y  = (short) cmwc_rand();
    //x[k].label will be calculated by the algorithm
  }

#ifdef DEBUG
  uart_printf("\n\nTEST POINTS\n");
  uart_printf("Idx \tX \tY\n");
  for (int k=0; k<M; k++)
    uart_printf("%d \t%d \t%d\n", k, x[k].x, x[k].y);
#endif
  
  //
  // PROCESS DATA
  //

  //start knn here
  
  for (int k=0; k<M; k++) { //for all test points
  //compute distances to dataset points

#ifdef DEBUG
    uart_printf("\n\nProcessing x[%d]:\n", k);
#endif

    //init all k neighbors infinite distance
    for (int j=0; j<K; j++)
      neighbor[j].dist = INFINITE;

#ifdef DEBUG
    uart_printf("Datum \tX \tY \tLabel \tDistance\n");
#endif
    for (int i=0; i<N; i++) { //for all dataset points
      //compute distance to x[k]
      unsigned int d = sq_dist(x[k], data[i]);

      //insert in ordered list
      for (int j=0; j<K; j++)
        if ( d < neighbor[j].dist ) {
          insert( (struct neighbor){i,d}, j);
          break;
        }

#ifdef DEBUG
      //dataset
      uart_printf("%d \t%d \t%d \t%d \t%d\n", i, data[i].x, data[i].y, data[i].label, d);
#endif

    }

    
    //classify test point

    //clear all votes
    int votes[C] = {0};
    int best_votation = 0;
    int best_voted = 0;

    //make neighbours vote
    for (int j=0; j<K; j++) { //for all neighbors
      if ( (++votes[data[neighbor[j].idx].label]) > best_votation ) {
        best_voted = data[neighbor[j].idx].label;
        best_votation = votes[best_voted];
      }
    }

    x[k].label = best_voted;

    votes_acc[best_voted]++;
    
#ifdef DEBUG
    uart_printf("\n\nNEIGHBORS of x[%d]=(%d, %d):\n", k, x[k].x, x[k].y);
    uart_printf("K \tIdx \tX \tY \tDist \t\tLabel\n");
    for (int j=0; j<K; j++)
      uart_printf("%d \t%d \t%d \t%d \t%d \t%d\n", j+1, neighbor[j].idx, data[neighbor[j].idx].x,  data[neighbor[j].idx].y, neighbor[j].dist,  data[neighbor[j].idx].label);
    
    uart_printf("\n\nCLASSIFICATION of x[%d]:\n", k);
    uart_printf("X \tY \tLabel\n");
    uart_printf("%d \t%d \t%d\n\n\n", x[k].x, x[k].y, x[k].label);

#endif

  } //all test points classified

  //stop knn here
  //read current timer count, compute elapsed time
  elapsedu = timer_time_us(TIMER_BASE);
  uart_printf("\nExecution time: %dus @%dMHz\n\n", elapsedu, FREQ/1000000);

  
  //print classification distribution to check for statistical bias
  for (int l=0; l<C; l++)
    uart_printf("%d ", votes_acc[l]);
  uart_printf("\n");
  
}


