book_ticket:
        sub     sp, sp, #32
        stp     x29, x30, [sp, #16]
        add     x29, sp, #16
        str     x0, [sp, #8]
        ldr     x8, [sp, #8]
        str     x8, [sp]
        adrp    x0, lock
        add     x0, x0, :lo12:lock
        bl      pthread_mutex_lock
        adrp    x8, remaining_tickets
        ldr     w8, [x8, :lo12:remaining_tickets]
        subs    w8, w8, #0
        b.le    .LBB0_2
        b       .LBB0_1
.LBB0_1:
        ldr     x8, [sp]
        ldr     w1, [x8]
        adrp    x0, .L.str
        add     x0, x0, :lo12:.L.str
        bl      printf
        mov     w0, #1
        bl      sleep
        adrp    x8, remaining_tickets
        ldr     w9, [x8, :lo12:remaining_tickets]
        subs    w9, w9, #1
        str     w9, [x8, :lo12:remaining_tickets]
        ldr     x9, [sp]
        ldr     w1, [x9]
        ldr     w2, [x8, :lo12:remaining_tickets]
        adrp    x0, .L.str.1
        add     x0, x0, :lo12:.L.str.1
        bl      printf
        b       .LBB0_3
.LBB0_2:
        ldr     x8, [sp]
        ldr     w1, [x8]
        adrp    x0, .L.str.2
        add     x0, x0, :lo12:.L.str.2
        bl      printf
        b       .LBB0_3
.LBB0_3:
        adrp    x0, lock
        add     x0, x0, :lo12:lock
        bl      pthread_mutex_unlock
        mov     x0, xzr
        ldp     x29, x30, [sp, #16]
        add     sp, sp, #32
        ret

main:
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        sub     sp, sp, #80
        stur    wzr, [x29, #-4]
        adrp    x0, .L.str.3
        add     x0, x0, :lo12:.L.str.3
        bl      printf
        adrp    x0, .L.str.4
        add     x0, x0, :lo12:.L.str.4
        sub     x1, x29, #8
        bl      __isoc99_scanf
        ldur    w8, [x29, #-8]
        mov     x9, sp
        stur    x9, [x29, #-16]
        lsl     x9, x8, #3
        add     x9, x9, #15
        and     x10, x9, #0xfffffffffffffff0
        mov     x9, sp
        subs    x9, x9, x10
        mov     sp, x9
        stur    x9, [x29, #-64]
        stur    x8, [x29, #-24]
        ldur    w8, [x29, #-8]
        lsl     x9, x8, #2
        add     x9, x9, #15
        and     x10, x9, #0xfffffffffffffff0
        mov     x9, sp
        subs    x9, x9, x10
        mov     sp, x9
        stur    x9, [x29, #-56]
        stur    x8, [x29, #-32]
        adrp    x0, lock
        add     x0, x0, :lo12:lock
        mov     x1, xzr
        bl      pthread_mutex_init
        cbz     w0, .LBB1_2
        b       .LBB1_1
.LBB1_1:
        adrp    x0, .L.str.5
        add     x0, x0, :lo12:.L.str.5
        bl      printf
        mov     w8, #1
        stur    w8, [x29, #-4]
        stur    w8, [x29, #-36]
        b       .LBB1_13
.LBB1_2:
        stur    wzr, [x29, #-40]
        b       .LBB1_3
.LBB1_3:
        ldur    w8, [x29, #-40]
        ldur    w9, [x29, #-8]
        subs    w8, w8, w9
        b.ge    .LBB1_8
        b       .LBB1_4
.LBB1_4:
        ldur    x8, [x29, #-56]
        ldur    x9, [x29, #-64]
        ldur    w10, [x29, #-40]
        add     w10, w10, #1
        ldursw  x11, [x29, #-40]
        str     w10, [x8, x11, lsl #2]
        ldursw  x10, [x29, #-40]
        add     x0, x9, x10, lsl #3
        ldursw  x9, [x29, #-40]
        add     x3, x8, x9, lsl #2
        mov     x1, xzr
        adrp    x2, book_ticket
        add     x2, x2, :lo12:book_ticket
        bl      pthread_create
        cbz     w0, .LBB1_6
        b       .LBB1_5
.LBB1_5:
        ldur    w8, [x29, #-40]
        mov     w9, #1
        stur    w9, [x29, #-68]
        add     w1, w8, #1
        adrp    x0, .L.str.6
        add     x0, x0, :lo12:.L.str.6
        bl      printf
        ldur    w8, [x29, #-68]
        stur    w8, [x29, #-4]
        stur    w8, [x29, #-36]
        b       .LBB1_13
.LBB1_6:
        b       .LBB1_7
.LBB1_7:
        ldur    w8, [x29, #-40]
        add     w8, w8, #1
        stur    w8, [x29, #-40]
        b       .LBB1_3
.LBB1_8:
        stur    wzr, [x29, #-44]
        b       .LBB1_9
.LBB1_9:
        ldur    w8, [x29, #-44]
        ldur    w9, [x29, #-8]
        subs    w8, w8, w9
        b.ge    .LBB1_12
        b       .LBB1_10
.LBB1_10:
        ldur    x8, [x29, #-64]
        ldursw  x9, [x29, #-44]
        ldr     x0, [x8, x9, lsl #3]
        mov     x1, xzr
        bl      pthread_join
        b       .LBB1_11
.LBB1_11:
        ldur    w8, [x29, #-44]
        add     w8, w8, #1
        stur    w8, [x29, #-44]
        b       .LBB1_9
.LBB1_12:
        adrp    x0, lock
        add     x0, x0, :lo12:lock
        bl      pthread_mutex_destroy
        adrp    x8, remaining_tickets
        ldr     w1, [x8, :lo12:remaining_tickets]
        adrp    x0, .L.str.7
        add     x0, x0, :lo12:.L.str.7
        bl      printf
        stur    wzr, [x29, #-4]
        mov     w8, #1
        stur    w8, [x29, #-36]
        b       .LBB1_13
.LBB1_13:
        ldur    x8, [x29, #-16]
        mov     sp, x8
        ldur    w0, [x29, #-4]
        mov     sp, x29
        ldp     x29, x30, [sp], #16
        ret

remaining_tickets:
        .word   10

lock:
        .zero   48

.L.str:
        .asciz  "Thread %d: Booking a ticket...\n"

.L.str.1:
        .asciz  "Thread %d: Ticket booked successfully! Tickets remaining: %d\n"

.L.str.2:
        .asciz  "Thread %d: No tickets available.\n"

.L.str.3:
        .asciz  "Enter number of users trying to book tickets: "

.L.str.4:
        .asciz  "%d"

.L.str.5:
        .asciz  "Mutex initialization failed!\n"

.L.str.6:
        .asciz  "Error creating thread %d\n"

.L.str.7:
        .asciz  "All threads completed. Final tickets remaining: %d\n"