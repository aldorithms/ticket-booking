#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

// Define the total number of tickets available
#define TOTAL_TICKETS 10

// Mutex to synchronize access to ticket data
pthread_mutex_t lock;

// Global variable to store the remaining tickets
int remaining_tickets = TOTAL_TICKETS;

// Function to simulate ticket booking
void* book_ticket(void* arg) {
    int* thread_id = (int*)arg;
    pthread_mutex_lock(&lock);  // Lock the critical section

    if (remaining_tickets > 0) {
        printf("Thread %d: Booking a ticket...\n", *thread_id);
        sleep(1);  // Simulate some delay in booking
        remaining_tickets--;
        printf("Thread %d: Ticket booked successfully! Tickets remaining: %d\n", *thread_id, remaining_tickets);
    } else {
        printf("Thread %d: No tickets available.\n", *thread_id);
    }

    pthread_mutex_unlock(&lock);  // Unlock the critical section
    return NULL;
}

int main() {
    // Number of users trying to book tickets
    int num_threads;
    printf("Enter number of users trying to book tickets: ");
    scanf("%d", &num_threads);

    // Allocate memory to store thread IDs
    pthread_t threads[num_threads];
    int thread_ids[num_threads];

    // Initialize the mutex lock
    if (pthread_mutex_init(&lock, NULL) != 0) {
        printf("Mutex initialization failed!\n");
        return 1;
    }

    // Create threads for each user trying to book a ticket
    for (int i = 0; i < num_threads; i++) {
        thread_ids[i] = i + 1;
        if (pthread_create(&threads[i], NULL, book_ticket, &thread_ids[i]) != 0) {
            printf("Error creating thread %d\n", i + 1);
            return 1;
        }
    }

    // Wait for all threads to complete
    for (int i = 0; i < num_threads; i++) {
        pthread_join(threads[i], NULL);
    }

    // Destroy the mutex lock
    pthread_mutex_destroy(&lock);

    // Display the final number of tickets remaining
    printf("All threads completed. Final tickets remaining: %d\n", remaining_tickets);

    return 0;
}
