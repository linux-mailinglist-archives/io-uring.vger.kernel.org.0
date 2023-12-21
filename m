Return-Path: <io-uring+bounces-340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7BA881B488
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 11:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07E971C233C4
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 10:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A4D6A013;
	Thu, 21 Dec 2023 10:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Umbk7IX3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF9B6A029;
	Thu, 21 Dec 2023 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3bb7376957eso454762b6e.1;
        Thu, 21 Dec 2023 02:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703156315; x=1703761115; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=31QSY6Ad828ZC5dwczDw26yr6rSk4396NaizMRkH6ME=;
        b=Umbk7IX3TsRy8Fy9GXPf92Mb8kxcDJTD+AMFfCvsbLSaUOP6f3N0x+RZpFqlaR1CsD
         d2AJV9v6c51onuF/ZriRAiLl3s5x5/9hJrwCuNo5TazUdbH2sjwiaq1NdDLOdd8JjIdV
         7HzRj+JsPmbFHdcHi40s96JsXHCf7Z8iJjg91djYNNBCyJPKnWWDD4hCC6U/hEaYwLnq
         yXTKTi9RaqrUZNUC2VkupFl+9WHhQ3M1lJTyIhEzK2G+Wf9kQVtYM2d9BuPIL2eEy0y/
         VPa5jkylCTadptSCZIOF0NuLKlvaaZcpj6b6fXhDwDvD2b5329Ks5gi0VLbNBfZ4yY4J
         0H+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703156315; x=1703761115;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=31QSY6Ad828ZC5dwczDw26yr6rSk4396NaizMRkH6ME=;
        b=TDulno8yE96bH12g/K8rP6NOt8AVGC4a5qkcq01+oqUjJTBmCM+DkhP4tUgjRvt1a8
         1EKLZe4SAe+SSIg6jY1LhGfW3nMgMe+m1M9OMGDWtJx28UTgJ+FmRr9Uz1bHwjG+S9R5
         N3BMgJ8YLMaWAyg1tKV9ynM0T7MhzEZs3qzu+Hjz7vAVwdRdyxdj6ea5AaoyOqMaH1jA
         OjxL9ziIK4uz2w7eO/tB/WBn6W54IJhfiiJD0IJwsul6wb3YzsVlaLSowGfIK9UVz13U
         bGl+GXX+lu3p/8YufajdjnFebfCzRubKJ1cqQZSLSJTznAF71JpVrrQwa9XgSzN4OIwB
         jXPQ==
X-Gm-Message-State: AOJu0YxgTBU3+51uD+CJfTP1esjxoRJ9xxOuaigTp2FBBHOZuALdnsbu
	BMEMrnLGChPuva1R6f+/ocg3QDoRUtTpuf9K35Y=
X-Google-Smtp-Source: AGHT+IEwwewAvB3CSZ02cyLCVmPmGQ/DQmQB0UzTYkcFu/L5l9DjX10NgzHEZuSnNb4BqKw8juR6MwOCR4YGG7zTz7Y=
X-Received: by 2002:a05:6808:21a6:b0:3b9:e87b:d963 with SMTP id
 be38-20020a05680821a600b003b9e87bd963mr27966835oib.85.1703156315316; Thu, 21
 Dec 2023 02:58:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: xingwei lee <xrivendell7@gmail.com>
Date: Thu, 21 Dec 2023 18:58:24 +0800
Message-ID: <CABOYnLzhrQ25C_vjthTZZhZCjQrL-HC4=MKmYG0CyoG6hKpbnw@mail.gmail.com>
Subject: KMSAN: uninit-value in io_rw_fail
To: axboe@kernel.dk, syzbot+12dde80bf174ac8ae285@syzkaller.appspotmail.com
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	glider@google.com
Content-Type: text/plain; charset="UTF-8"

Hello I found a bug in io_uring and comfirmed at the latest upstream
mainine linux.
TITLE: KMSAN: uninit-value in io_rw_fail
and I find this bug maybe existed in the
https://syzkaller.appspot.com/bug?extid=12dde80bf174ac8ae285 but do
not have a stable reproducer.
However, I generate a stable reproducer and comfirmed in the latest mainline.

If you fix this issue, please add the following tag to the commit:
Reported-by: xingwei lee <xrivendell7@gmail.com>

kernel: mainline a4aebe936554dac6a91e5d091179c934f8325708
kernel config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=4a65fa9f077ead01
with KMSAN enabled
compiler: Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40


=* repro.c =*
#define _GNU_SOURCE

#include <dirent.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#ifndef __NR_io_uring_enter
#define __NR_io_uring_enter 426
#endif
#ifndef __NR_io_uring_setup
#define __NR_io_uring_setup 425
#endif

static void sleep_ms(uint64_t ms) { usleep(ms * 1000); }

static uint64_t current_time_ms(void) {
 struct timespec ts;
 if (clock_gettime(CLOCK_MONOTONIC, &ts)) exit(1);
 return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static bool write_file(const char* file, const char* what, ...) {
 char buf[1024];
 va_list args;
 va_start(args, what);
 vsnprintf(buf, sizeof(buf), what, args);
 va_end(args);
 buf[sizeof(buf) - 1] = 0;
 int len = strlen(buf);
 int fd = open(file, O_WRONLY | O_CLOEXEC);
 if (fd == -1) return false;
 if (write(fd, buf, len) != len) {
   int err = errno;
   close(fd);
   errno = err;
   return false;
 }
 close(fd);
 return true;
}

#define SIZEOF_IO_URING_SQE 64
#define SIZEOF_IO_URING_CQE 16
#define SQ_HEAD_OFFSET 0
#define SQ_TAIL_OFFSET 64
#define SQ_RING_MASK_OFFSET 256
#define SQ_RING_ENTRIES_OFFSET 264
#define SQ_FLAGS_OFFSET 276
#define SQ_DROPPED_OFFSET 272
#define CQ_HEAD_OFFSET 128
#define CQ_TAIL_OFFSET 192
#define CQ_RING_MASK_OFFSET 260
#define CQ_RING_ENTRIES_OFFSET 268
#define CQ_RING_OVERFLOW_OFFSET 284
#define CQ_FLAGS_OFFSET 280
#define CQ_CQES_OFFSET 320

struct io_sqring_offsets {
 uint32_t head;
 uint32_t tail;
 uint32_t ring_mask;
 uint32_t ring_entries;
 uint32_t flags;
 uint32_t dropped;
 uint32_t array;
 uint32_t resv1;
 uint64_t resv2;
};

struct io_cqring_offsets {
 uint32_t head;
 uint32_t tail;
 uint32_t ring_mask;
 uint32_t ring_entries;
 uint32_t overflow;
 uint32_t cqes;
 uint64_t resv[2];
};

struct io_uring_params {
 uint32_t sq_entries;
 uint32_t cq_entries;
 uint32_t flags;
 uint32_t sq_thread_cpu;
 uint32_t sq_thread_idle;
 uint32_t features;
 uint32_t resv[4];
 struct io_sqring_offsets sq_off;
 struct io_cqring_offsets cq_off;
};

#define IORING_OFF_SQ_RING 0
#define IORING_OFF_SQES 0x10000000ULL

static long syz_io_uring_setup(volatile long a0, volatile long a1,
                              volatile long a2, volatile long a3) {
 uint32_t entries = (uint32_t)a0;
 struct io_uring_params* setup_params = (struct io_uring_params*)a1;
 void** ring_ptr_out = (void**)a2;
 void** sqes_ptr_out = (void**)a3;
 uint32_t fd_io_uring = syscall(__NR_io_uring_setup, entries, setup_params);
 uint32_t sq_ring_sz =
     setup_params->sq_off.array + setup_params->sq_entries * sizeof(uint32_t);
 uint32_t cq_ring_sz = setup_params->cq_off.cqes +
                       setup_params->cq_entries * SIZEOF_IO_URING_CQE;
 uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
 *ring_ptr_out =
     mmap(0, ring_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
          fd_io_uring, IORING_OFF_SQ_RING);
 uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
 *sqes_ptr_out = mmap(0, sqes_sz, PROT_READ | PROT_WRITE,
                      MAP_SHARED | MAP_POPULATE, fd_io_uring, IORING_OFF_SQES);
 uint32_t* array =
     (uint32_t*)((uintptr_t)*ring_ptr_out + setup_params->sq_off.array);
 for (uint32_t index = 0; index < entries; index++) array[index] = index;
 return fd_io_uring;
}

static long syz_io_uring_submit(volatile long a0, volatile long a1,
                               volatile long a2) {
 char* ring_ptr = (char*)a0;
 char* sqes_ptr = (char*)a1;
 char* sqe = (char*)a2;
 uint32_t sq_ring_mask = *(uint32_t*)(ring_ptr + SQ_RING_MASK_OFFSET);
 uint32_t* sq_tail_ptr = (uint32_t*)(ring_ptr + SQ_TAIL_OFFSET);
 uint32_t sq_tail = *sq_tail_ptr & sq_ring_mask;
 char* sqe_dest = sqes_ptr + sq_tail * SIZEOF_IO_URING_SQE;
 memcpy(sqe_dest, sqe, SIZEOF_IO_URING_SQE);
 uint32_t sq_tail_next = *sq_tail_ptr + 1;
 __atomic_store_n(sq_tail_ptr, sq_tail_next, __ATOMIC_RELEASE);
 return 0;
}

static void kill_and_wait(int pid, int* status) {
 kill(-pid, SIGKILL);
 kill(pid, SIGKILL);
 for (int i = 0; i < 100; i++) {
   if (waitpid(-1, status, WNOHANG | __WALL) == pid) return;
   usleep(1000);
 }
 DIR* dir = opendir("/sys/fs/fuse/connections");
 if (dir) {
   for (;;) {
     struct dirent* ent = readdir(dir);
     if (!ent) break;
     if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
       continue;
     char abort[300];
     snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort",
              ent->d_name);
     int fd = open(abort, O_WRONLY);
     if (fd == -1) {
       continue;
     }
     if (write(fd, abort, 1) < 0) {
     }
     close(fd);
   }
   closedir(dir);
 } else {
 }
 while (waitpid(-1, status, __WALL) != pid) {
 }
}

static void setup_test() {
 prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
 setpgrp();
 write_file("/proc/self/oom_score_adj", "1000");
}

static void execute_one(void);

#define WAIT_FLAGS __WALL

static void loop(void) {
 int iter = 0;
 for (;; iter++) {
   int pid = fork();
   if (pid < 0) exit(1);
   if (pid == 0) {
     setup_test();
     execute_one();
     exit(0);
   }
   int status = 0;
   uint64_t start = current_time_ms();
   for (;;) {
     if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid) break;
     sleep_ms(1);
     if (current_time_ms() - start < 5000) continue;
     kill_and_wait(pid, &status);
     break;
   }
 }
}

uint64_t r[3] = {0xffffffffffffffff, 0x0, 0x0};

void execute_one(void) {
 intptr_t res = 0;
 *(uint32_t*)0x200001c4 = 0;
 *(uint32_t*)0x200001c8 = 0x10100;
 *(uint32_t*)0x200001cc = 0;
 *(uint32_t*)0x200001d0 = 0;
 *(uint32_t*)0x200001d8 = -1;
 memset((void*)0x200001dc, 0, 12);
 res = -1;
 res = syz_io_uring_setup(/*entries=*/0x24f7, /*params=*/0x200001c0,
                          /*ring_ptr=*/0x20000040, /*sqes_ptr=*/0x20000100);
 if (res != -1) {
   r[0] = res;
   r[1] = *(uint64_t*)0x20000040;
   r[2] = *(uint64_t*)0x20000100;
 }
 *(uint8_t*)0x20000740 = 2;
 *(uint8_t*)0x20000741 = 0x10;
 *(uint16_t*)0x20000742 = 0;
 *(uint32_t*)0x20000744 = 0;
 *(uint64_t*)0x20000748 = 0;
 *(uint64_t*)0x20000750 = 0;
 *(uint32_t*)0x20000758 = 0xfffffe08;
 *(uint32_t*)0x2000075c = 0;
 *(uint64_t*)0x20000760 = 0;
 *(uint16_t*)0x20000768 = 0;
 *(uint16_t*)0x2000076a = 0;
 memset((void*)0x2000076c, 0, 20);
 syz_io_uring_submit(/*ring_ptr=*/r[1], /*sqes_ptr=*/r[2], /*sqe=*/0x20000740);
 syscall(__NR_io_uring_enter, /*fd=*/r[0], /*to_submit=*/0x2d3e,
         /*min_complete=*/0, /*flags=*/0ul, /*sigmask=*/0ul, /*size=*/0ul);
}
int main(void) {
 syscall(__NR_mmap, /*addr=*/0x1ffff000ul, /*len=*/0x1000ul, /*prot=*/0ul,
         /*flags=*/0x32ul, /*fd=*/-1, /*offset=*/0ul);
 syscall(__NR_mmap, /*addr=*/0x20000000ul, /*len=*/0x1000000ul, /*prot=*/7ul,
         /*flags=*/0x32ul, /*fd=*/-1, /*offset=*/0ul);
 syscall(__NR_mmap, /*addr=*/0x21000000ul, /*len=*/0x1000ul, /*prot=*/0ul,
         /*flags=*/0x32ul, /*fd=*/-1, /*offset=*/0ul);
 loop();
 return 0;
}


=* repro.txt =*
r0 = syz_io_uring_setup(0x24f7, &(0x7f00000001c0)={0x0, 0x0, 0x10100},
&(0x7f0000000040)=<r1=>0x0, &(0x7f0000000100)=<r2=>0x0)
syz_io_uring_submit(r1, r2, &(0x7f0000000740)=@IORING_OP_WRITEV={0x2,
0x10, 0x0, @fd_index, 0x0, 0x0, 0xfffffffffffffe08})
io_uring_enter(r0, 0x2d3e, 0x0, 0x0, 0x0, 0x0)


Please also see:
https://gist.github.com/xrivendell7/0adf878b11e3a71676e1dc696e1c9398
I hope it helps.
Thanks!

Best regards.
xingwei Lee

