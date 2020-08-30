Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CA8256B44
	for <lists+io-uring@lfdr.de>; Sun, 30 Aug 2020 05:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgH3DcW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Aug 2020 23:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728613AbgH3DcV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Aug 2020 23:32:21 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA93DC061573
        for <io-uring@vger.kernel.org>; Sat, 29 Aug 2020 20:32:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id d26so4171062ejr.1
        for <io-uring@vger.kernel.org>; Sat, 29 Aug 2020 20:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=UCb3etR8DtVlOyjLPV4mA7Y/lhLJMa3iUivHnGmPw5o=;
        b=Ud1KngTKWRPJUFQnIF+07PQFt9sqWzo9aCykBWZ+hhMZzHpnOanPdLRvgS0bUgktQy
         3Armo3lHiydmtC4ZQsFII4m3VYUByiHFZZdycvODaCXcsvUKic78caUci3hXJrs3wyHy
         6+49KhbFAeM+HgmZ5n+tLb60BU+hIiFOPKxB1gsRbyppjwcMQP/bkKtBobTzodxzEaaO
         tQL56q0y+7a/Yx7gz2T/Ohqnoynbs2zCfI+YnTKn1YPuQaf6VF2bpiMZ6XBQMYY3Pag+
         rQBFVjDQFkYh6XnH01iwasCz+4m2BbdxkZSUzHEhToODSQePr8UUtJdUqQXgWS3AjKOg
         9yNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=UCb3etR8DtVlOyjLPV4mA7Y/lhLJMa3iUivHnGmPw5o=;
        b=um1Mwp/GtTbPGReaMaVm089tn1krBscRQaCkr553k8n6TjIVOfEsmYlRuwyeq5Ed07
         aIWcog/x1wX7+TAkfpJljF+HvzUwWqhg7GXsMCU41p2P4y3W4Quoteb8XXYuXL6u9HpI
         PfALvcHiscXqdLJPZOmlY+htaLF4655w6kvGTLihQSeNGsh3tPxx0AHFVaHW7EkcbA9y
         ZjFjhymQZlsEypAOeNB6ub3z17yDfD0ryTIrg3dFTNLXHhBOtOw0P//6aHnvbzn5arLK
         X5mT7qn9jFc7Gk025IUEvNl9cwm2s9l/Si1Gp6zRqP35jxT3t2FRONsDGulKYBvnO1dx
         0KAw==
X-Gm-Message-State: AOAM532pAKbu/9k9vJKSbPcxDypur0EM423g91VCGe5TG4Zqkjtl/FHV
        U1fg23pRzCS59b0xU7CqkBKN83OH2EyINTdrOyMucVwS5bpzvAhm
X-Google-Smtp-Source: ABdhPJxgB8WPEWiUFcCJqNcTbqnVBpCCU1rxL0GvVLbvuF0KaqzdRYNcdDhMtpwAuektt6BBYPRwZs9zos86gjcf/Bw=
X-Received: by 2002:a17:906:234b:: with SMTP id m11mr5959698eja.403.1598758338736;
 Sat, 29 Aug 2020 20:32:18 -0700 (PDT)
MIME-Version: 1.0
From:   Shuveb Hussain <shuveb@gmail.com>
Date:   Sun, 30 Aug 2020 09:02:07 +0530
Message-ID: <CAF=AFaLzf=B28CXt0qJ0z7wXfRosqLPYQYtC-DrVogA0J_5AKw@mail.gmail.com>
Subject: Unclear documentation about IORING_OP_READ
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

I'm coming up the the man page for io_uring(7) and I noticed that the
existing man page or other available documentation does not make it
clear about offset (off in the SQE) being a mandatory parameter for
the following operations:
IORING_OP_READ
IORING_OP_WRITE
IORING_OP_READV
IORING_OP_WRITEV

Regular UNIX developers will expect subsequent read/write operations
on the same file descriptor to remember the file offset for files that
continue to be open. Is this the intended behavior or is it just that
it is not documented? If it is the latter, I'll clearly call it out in
the documentation.

In the included program, removing the "offset" variable causes the
program to behave abnormally, proving that read/write operations
executed via io_uring do not honor current file offsets for open file
descriptors. Please clarify.

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <sys/mman.h>
#include <sys/uio.h>
#include <linux/fs.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

/* If your compilation fails because the header file below is missing,
* your kernel is probably too old to support io_uring.
* */
#include <linux/io_uring.h>

#define QUEUE_DEPTH 1
#define BLOCK_SZ    1024

/* This is x86 specific */
#define read_barrier()  __asm__ __volatile__("":::"memory")
#define write_barrier() __asm__ __volatile__("":::"memory")

int ring_fd;
unsigned *sring_tail, *sring_mask, *sring_array,
            *cring_head, *cring_tail, *cring_mask;
struct io_uring_sqe *sqes;
struct io_uring_cqe *cqes;
char buff[BLOCK_SZ];
off_t offset;

/*
* This code is written in the days when io_uring-related system calls are not
* part of standard C libraries. So, we roll our own system call wrapper
* functions.
* */

int io_uring_setup(unsigned entries, struct io_uring_params *p)
{
    return (int) syscall(__NR_io_uring_setup, entries, p);
}

int io_uring_enter(int ring_fd, unsigned int to_submit,
                   unsigned int min_complete, unsigned int flags)
{
    return (int) syscall(__NR_io_uring_enter, ring_fd, to_submit, min_complete,
                         flags, NULL, 0);
}

int app_setup_uring() {
    struct io_uring_params p;
    void *sq_ptr, *cq_ptr;

    /*
    * We need to pass in the io_uring_params structure to the io_uring_setup()
    * call zeroed out. We could set any flags if we need to, but for this
    * example, we don't.
    * */
    memset(&p, 0, sizeof(p));
    ring_fd = io_uring_setup(QUEUE_DEPTH, &p);
    if (ring_fd < 0) {
        perror("io_uring_setup");
        return 1;
    }

    /*
    * io_uring communication happens via 2 shared kernel-user space
ring buffers,
    * which can be jointly mapped with a single mmap() call in recent kernels.
    * While the completion queue is directly manipulated, the submission queue
    * has an indirection array in between. We map that in as well.
    * */

    int sring_sz = p.sq_off.array + p.sq_entries * sizeof(unsigned);
    int cring_sz = p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe);

    /* In kernel version 5.4 and above, it is possible to map the submission and
    * completion buffers with a single mmap() call. Rather than check for kernel
    * versions, the recommended way is to just check the features field of the
    * io_uring_params structure, which is a bit mask. If the
    * IORING_FEAT_SINGLE_MMAP is set, then we can do away with the second mmap()
    * call to map the completion ring.
    * */
    if (p.features & IORING_FEAT_SINGLE_MMAP) {
        if (cring_sz > sring_sz) {
            sring_sz = cring_sz;
        }
        cring_sz = sring_sz;
    }

    /* Map in the submission and completion queue ring buffers.
    * Older kernels only map in the submission queue, though.
    * */
    sq_ptr = mmap(0, sring_sz, PROT_READ | PROT_WRITE,
                  MAP_SHARED | MAP_POPULATE,
                  ring_fd, IORING_OFF_SQ_RING);
    if (sq_ptr == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    if (p.features & IORING_FEAT_SINGLE_MMAP) {
        cq_ptr = sq_ptr;
    } else {
        /* Map in the completion queue ring buffer in older kernels
separately */
        cq_ptr = mmap(0, cring_sz, PROT_READ | PROT_WRITE,
                      MAP_SHARED | MAP_POPULATE,
                      ring_fd, IORING_OFF_CQ_RING);
        if (cq_ptr == MAP_FAILED) {
            perror("mmap");
            return 1;
        }
    }
    /* Save useful fields in a global app_io_sq_ring struct for later
    * easy reference */
    sring_tail = sq_ptr + p.sq_off.tail;
    sring_mask = sq_ptr + p.sq_off.ring_mask;
    sring_array = sq_ptr + p.sq_off.array;

    /* Map in the submission queue entries array */
    sqes = mmap(0, p.sq_entries * sizeof(struct io_uring_sqe),
                   PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
                   ring_fd, IORING_OFF_SQES);
    if (sqes == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    /* Save useful fields in a global app_io_cq_ring struct for later
    * easy reference */
    cring_head = cq_ptr + p.cq_off.head;
    cring_tail = cq_ptr + p.cq_off.tail;
    cring_mask = cq_ptr + p.cq_off.ring_mask;
    cqes = cq_ptr + p.cq_off.cqes;

    return 0;
}

/*
* Read from completion queue.
* In this function, we read completion events from the completion queue, get
* the data buffer that will have the file data and print it to the console.
* */

int read_from_cq() {
    struct io_uring_cqe *cqe;
    unsigned head, reaped = 0;

    head = *cring_head;
    read_barrier();
    /*
    * Remember, this is a ring buffer. If head == tail, it means that the
    * buffer is empty.
    * */
    if (head == *cring_tail)
        return -1;

    /* Get the entry */
    cqe = &cqes[head & (*cring_mask)];
    if (cqe->res < 0)
        fprintf(stderr, "Error: %s\n", strerror(abs(cqe->res)));

    head++;

    *cring_head = head;
    write_barrier();

    return cqe->res;
}
/*
* Submit a read or a write request to the submission queue.
* */

int submit_to_sq(int fd, int op) {
    unsigned index, tail;

    /* Add our submission queue entry to the tail of the SQE ring buffer */
    tail = *sring_tail;
    read_barrier();
    index = tail & *sring_mask;
    struct io_uring_sqe *sqe = &sqes[index];
    /* Fill in the parameters required for the read or write operation */
    sqe->opcode = op;
    sqe->fd = fd;
    sqe->addr = (unsigned long) buff;
    if (op == IORING_OP_READ) {
        memset(buff, 0, sizeof(buff));
        sqe->len = BLOCK_SZ;
    }
    else {
        sqe->len = strlen(buff);
    }
    sqe->off = offset;

    sring_array[index] = index;
    tail++;

    /* Update the tail so the kernel can see it. */
    write_barrier();
    *sring_tail = tail;
    write_barrier();

    /*
    * Tell the kernel we have submitted events with the io_uring_enter() system
    * call. We also pass in the IOURING_ENTER_GETEVENTS flag which causes the
    * io_uring_enter() call to wait until min_complete events (the 3rd param)
    * complete.
    * */
    int ret =  io_uring_enter(ring_fd, 1,1,
                              IORING_ENTER_GETEVENTS);
    if(ret < 0) {
        perror("io_uring_enter");
        return -1;
    }

    return ret;
}

int main(int argc, char *argv[]) {
    int res;

    if(app_setup_uring()) {
        fprintf(stderr, "Unable to setup uring!\n");
        return 1;
    }

    while (1) {
        /* Initiate read from stdin and wait for it to complete */
        submit_to_sq(STDIN_FILENO, IORING_OP_READ);
        /* Read completion queue entry */
        res = read_from_cq();
        if (res > 0) {
            /* Read successful. Write to stdout. */
            submit_to_sq(STDOUT_FILENO, IORING_OP_WRITE);
            read_from_cq();
        } else if (res == 0) {
            /* reached EOF */
            break;
        }
        else if (res < 0) {
            /* Error reading file */
            fprintf(stderr, "Error: %s\n", strerror(abs(res)));
            break;
        }
        offset += res;
    }

    return 0;
}

Thanks!
-- 
Shuveb Hussain
