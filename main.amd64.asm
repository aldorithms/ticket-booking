lock:
        .zero   40
remaining_tickets:
        .long   10
.LC0:
        .string "Thread %d: Booking a ticket...\n"
.LC1:
        .string "Thread %d: Ticket booked successfully! Tickets remaining: %d\n"
.LC2:
        .string "Thread %d: No tickets available.\n"
book_ticket:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     QWORD PTR [rbp-24], rdi
        mov     rax, QWORD PTR [rbp-24]
        mov     QWORD PTR [rbp-8], rax
        mov     edi, OFFSET FLAT:lock
        call    pthread_mutex_lock
        mov     eax, DWORD PTR remaining_tickets[rip]
        test    eax, eax
        jle     .L2
        mov     rax, QWORD PTR [rbp-8]
        mov     eax, DWORD PTR [rax]
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     edi, 1
        call    sleep
        mov     eax, DWORD PTR remaining_tickets[rip]
        sub     eax, 1
        mov     DWORD PTR remaining_tickets[rip], eax
        mov     edx, DWORD PTR remaining_tickets[rip]
        mov     rax, QWORD PTR [rbp-8]
        mov     eax, DWORD PTR [rax]
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC1
        mov     eax, 0
        call    printf
        jmp     .L3
.L2:
        mov     rax, QWORD PTR [rbp-8]
        mov     eax, DWORD PTR [rax]
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC2
        mov     eax, 0
        call    printf
.L3:
        mov     edi, OFFSET FLAT:lock
        call    pthread_mutex_unlock
        mov     eax, 0
        leave
        ret
.LC3:
        .string "Enter number of users trying to book tickets: "
.LC4:
        .string "%d"
.LC5:
        .string "Mutex initialization failed!"
.LC6:
        .string "Error creating thread %d\n"
.LC7:
        .string "All threads completed. Final tickets remaining: %d\n"
main:
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 56
        mov     rax, rsp
        mov     rbx, rax
        mov     edi, OFFSET FLAT:.LC3
        mov     eax, 0
        call    printf
        lea     rax, [rbp-60]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:.LC4
        mov     eax, 0
        call    __isoc99_scanf
        mov     eax, DWORD PTR [rbp-60]
        movsx   rdx, eax
        sub     rdx, 1
        mov     QWORD PTR [rbp-32], rdx
        cdqe
        lea     rdx, [0+rax*8]
        mov     eax, 16
        sub     rax, 1
        add     rax, rdx
        mov     ecx, 16
        mov     edx, 0
        div     rcx
        imul    rax, rax, 16
        sub     rsp, rax
        mov     rax, rsp
        add     rax, 7
        shr     rax, 3
        sal     rax, 3
        mov     QWORD PTR [rbp-40], rax
        mov     eax, DWORD PTR [rbp-60]
        movsx   rdx, eax
        sub     rdx, 1
        mov     QWORD PTR [rbp-48], rdx
        cdqe
        lea     rdx, [0+rax*4]
        mov     eax, 16
        sub     rax, 1
        add     rax, rdx
        mov     esi, 16
        mov     edx, 0
        div     rsi
        imul    rax, rax, 16
        sub     rsp, rax
        mov     rax, rsp
        add     rax, 3
        shr     rax, 2
        sal     rax, 2
        mov     QWORD PTR [rbp-56], rax
        mov     esi, 0
        mov     edi, OFFSET FLAT:lock
        call    pthread_mutex_init
        test    eax, eax
        je      .L6
        mov     edi, OFFSET FLAT:.LC5
        call    puts
        mov     eax, 1
        jmp     .L7
.L6:
        mov     DWORD PTR [rbp-20], 0
        jmp     .L8
.L10:
        mov     eax, DWORD PTR [rbp-20]
        lea     ecx, [rax+1]
        mov     rax, QWORD PTR [rbp-56]
        mov     edx, DWORD PTR [rbp-20]
        movsx   rdx, edx
        mov     DWORD PTR [rax+rdx*4], ecx
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-56]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        lea     rcx, [0+rax*8]
        mov     rax, QWORD PTR [rbp-40]
        add     rax, rcx
        mov     rcx, rdx
        mov     edx, OFFSET FLAT:book_ticket
        mov     esi, 0
        mov     rdi, rax
        call    pthread_create
        test    eax, eax
        je      .L9
        mov     eax, DWORD PTR [rbp-20]
        add     eax, 1
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC6
        mov     eax, 0
        call    printf
        mov     eax, 1
        jmp     .L7
.L9:
        add     DWORD PTR [rbp-20], 1
.L8:
        mov     eax, DWORD PTR [rbp-60]
        cmp     DWORD PTR [rbp-20], eax
        jl      .L10
        mov     DWORD PTR [rbp-24], 0
        jmp     .L11
.L12:
        mov     rax, QWORD PTR [rbp-40]
        mov     edx, DWORD PTR [rbp-24]
        movsx   rdx, edx
        mov     rax, QWORD PTR [rax+rdx*8]
        mov     esi, 0
        mov     rdi, rax
        call    pthread_join
        add     DWORD PTR [rbp-24], 1
.L11:
        mov     eax, DWORD PTR [rbp-60]
        cmp     DWORD PTR [rbp-24], eax
        jl      .L12
        mov     edi, OFFSET FLAT:lock
        call    pthread_mutex_destroy
        mov     eax, DWORD PTR remaining_tickets[rip]
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC7
        mov     eax, 0
        call    printf
        mov     eax, 0
.L7:
        mov     rsp, rbx
        mov     rbx, QWORD PTR [rbp-8]
        leave
        ret