lock:
        .zero   40
remaining_tickets:
        .word   10
.LC0:
        .string "Thread %d: Booking a ticket...\n"
.LC1:
        .string "Thread %d: Ticket booked successfully! Tickets remaining: %d\n"
.LC2:
        .string "Thread %d: No tickets available.\n"
book_ticket:
        addi    sp,sp,-48
        sd      ra,40(sp)
        sd      s0,32(sp)
        addi    s0,sp,48
        sd      a0,-40(s0)
        ld      a5,-40(s0)
        sd      a5,-24(s0)
        lui     a5,%hi(lock)
        addi    a0,a5,%lo(lock)
        call    pthread_mutex_lock
        lui     a5,%hi(remaining_tickets)
        lw      a5,%lo(remaining_tickets)(a5)
        ble     a5,zero,.L2
        ld      a5,-24(s0)
        lw      a5,0(a5)
        mv      a1,a5
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    printf
        li      a0,1
        call    sleep
        lui     a5,%hi(remaining_tickets)
        lw      a5,%lo(remaining_tickets)(a5)
        addiw   a5,a5,-1
        sext.w  a4,a5
        lui     a5,%hi(remaining_tickets)
        sw      a4,%lo(remaining_tickets)(a5)
        ld      a5,-24(s0)
        lw      a4,0(a5)
        lui     a5,%hi(remaining_tickets)
        lw      a5,%lo(remaining_tickets)(a5)
        mv      a2,a5
        mv      a1,a4
        lui     a5,%hi(.LC1)
        addi    a0,a5,%lo(.LC1)
        call    printf
        j       .L3
.L2:
        ld      a5,-24(s0)
        lw      a5,0(a5)
        mv      a1,a5
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    printf
.L3:
        lui     a5,%hi(lock)
        addi    a0,a5,%lo(lock)
        call    pthread_mutex_unlock
        li      a5,0
        mv      a0,a5
        ld      ra,40(sp)
        ld      s0,32(sp)
        addi    sp,sp,48
        jr      ra
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
        addi    sp,sp,-208
        sd      ra,200(sp)
        sd      s0,192(sp)
        sd      s1,184(sp)
        sd      s2,176(sp)
        sd      s3,168(sp)
        sd      s4,160(sp)
        sd      s5,152(sp)
        sd      s6,144(sp)
        sd      s7,136(sp)
        sd      s8,128(sp)
        sd      s9,120(sp)
        sd      s10,112(sp)
        sd      s11,104(sp)
        addi    s0,sp,208
        mv      a5,sp
        mv      s1,a5
        lui     a5,%hi(.LC3)
        addi    a0,a5,%lo(.LC3)
        call    printf
        addi    a5,s0,-156
        mv      a1,a5
        lui     a5,%hi(.LC4)
        addi    a0,a5,%lo(.LC4)
        call    __isoc99_scanf
        lw      a5,-156(s0)
        mv      a4,a5
        addi    a4,a4,-1
        sd      a4,-128(s0)
        mv      a4,a5
        sd      a4,-176(s0)
        sd      zero,-168(s0)
        ld      a4,-176(s0)
        srli    a4,a4,58
        ld      a3,-168(s0)
        slli    s9,a3,6
        or      s9,a4,s9
        ld      a4,-176(s0)
        slli    s8,a4,6
        mv      a4,a5
        sd      a4,-192(s0)
        sd      zero,-184(s0)
        ld      a4,-192(s0)
        srli    a4,a4,58
        ld      a3,-184(s0)
        slli    s7,a3,6
        or      s7,a4,s7
        ld      a4,-192(s0)
        slli    s6,a4,6
        slli    a5,a5,3
        addi    a5,a5,15
        srli    a5,a5,4
        slli    a5,a5,4
        sub     sp,sp,a5
        mv      a5,sp
        addi    a5,a5,7
        srli    a5,a5,3
        slli    a5,a5,3
        sd      a5,-136(s0)
        lw      a5,-156(s0)
        mv      a4,a5
        addi    a4,a4,-1
        sd      a4,-144(s0)
        mv      a4,a5
        sd      a4,-208(s0)
        sd      zero,-200(s0)
        ld      a4,-208(s0)
        srli    a4,a4,59
        ld      a3,-200(s0)
        slli    s5,a3,5
        or      s5,a4,s5
        ld      a4,-208(s0)
        slli    s4,a4,5
        mv      a4,a5
        mv      s10,a4
        li      s11,0
        srli    a4,s10,59
        slli    s3,s11,5
        or      s3,a4,s3
        slli    s2,s10,5
        slli    a5,a5,2
        addi    a5,a5,15
        srli    a5,a5,4
        slli    a5,a5,4
        sub     sp,sp,a5
        mv      a5,sp
        addi    a5,a5,3
        srli    a5,a5,2
        slli    a5,a5,2
        sd      a5,-152(s0)
        li      a1,0
        lui     a5,%hi(lock)
        addi    a0,a5,%lo(lock)
        call    pthread_mutex_init
        mv      a5,a0
        beq     a5,zero,.L6
        lui     a5,%hi(.LC5)
        addi    a0,a5,%lo(.LC5)
        call    puts
        li      a5,1
        j       .L7
.L6:
        sw      zero,-116(s0)
        j       .L8
.L10:
        lw      a5,-116(s0)
        addiw   a5,a5,1
        sext.w  a4,a5
        ld      a3,-152(s0)
        lw      a5,-116(s0)
        slli    a5,a5,2
        add     a5,a3,a5
        sw      a4,0(a5)
        lw      a5,-116(s0)
        slli    a5,a5,3
        ld      a4,-136(s0)
        add     a0,a4,a5
        lw      a5,-116(s0)
        slli    a5,a5,2
        ld      a4,-152(s0)
        add     a5,a4,a5
        mv      a3,a5
        lui     a5,%hi(book_ticket)
        addi    a2,a5,%lo(book_ticket)
        li      a1,0
        call    pthread_create
        mv      a5,a0
        beq     a5,zero,.L9
        lw      a5,-116(s0)
        addiw   a5,a5,1
        sext.w  a5,a5
        mv      a1,a5
        lui     a5,%hi(.LC6)
        addi    a0,a5,%lo(.LC6)
        call    printf
        li      a5,1
        j       .L7
.L9:
        lw      a5,-116(s0)
        addiw   a5,a5,1
        sw      a5,-116(s0)
.L8:
        lw      a5,-156(s0)
        lw      a4,-116(s0)
        sext.w  a4,a4
        blt     a4,a5,.L10
        sw      zero,-120(s0)
        j       .L11
.L12:
        ld      a4,-136(s0)
        lw      a5,-120(s0)
        slli    a5,a5,3
        add     a5,a4,a5
        ld      a5,0(a5)
        li      a1,0
        mv      a0,a5
        call    pthread_join
        lw      a5,-120(s0)
        addiw   a5,a5,1
        sw      a5,-120(s0)
.L11:
        lw      a5,-156(s0)
        lw      a4,-120(s0)
        sext.w  a4,a4
        blt     a4,a5,.L12
        lui     a5,%hi(lock)
        addi    a0,a5,%lo(lock)
        call    pthread_mutex_destroy
        lui     a5,%hi(remaining_tickets)
        lw      a5,%lo(remaining_tickets)(a5)
        mv      a1,a5
        lui     a5,%hi(.LC7)
        addi    a0,a5,%lo(.LC7)
        call    printf
        li      a5,0
.L7:
        mv      sp,s1
        mv      a0,a5
        addi    sp,s0,-208
        ld      ra,200(sp)
        ld      s0,192(sp)
        ld      s1,184(sp)
        ld      s2,176(sp)
        ld      s3,168(sp)
        ld      s4,160(sp)
        ld      s5,152(sp)
        ld      s6,144(sp)
        ld      s7,136(sp)
        ld      s8,128(sp)
        ld      s9,120(sp)
        ld      s10,112(sp)
        ld      s11,104(sp)
        addi    sp,sp,208
        jr      ra