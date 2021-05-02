Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0E6370F6E
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 00:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhEBWNc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 18:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhEBWNc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 18:13:32 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF31BC06174A;
        Sun,  2 May 2021 15:12:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id s82so2231624wmf.3;
        Sun, 02 May 2021 15:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3aoRAaNfu1Pak0UTkml6eTDZM+4315AjVkhpNl7pJzg=;
        b=jkOxtdr58ysGTkNg1UB50FEjPoVa1BIhOY9/VgREnkY1zm6usc56LXCOgxkM+vNLU9
         083kBbXigXWD5e901k/ZIzFJzFFqXR8LFul9SmGUX91NjZZZk4k5lOC1r47IYgDxlnuv
         ItPy/fR1XJKkm2DYUFuNhJeJ+V3Xc1VsLJf32kib0A6X1xDicoeO/gZin3nJ/kWFOUyF
         jOcad3gzD/cBK0oZoRDmFT3ROXcEDfBUXEFsHO2Zh4sBKaWZSoBX1lcelfLYkuiuF3Ta
         lnB3fhEzKJvKCSW7U+bRicS84SZR5u1P0WqAhYt92dqMxZQ6m3Qf49mOk+xjYHU4G8Md
         Wtkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3aoRAaNfu1Pak0UTkml6eTDZM+4315AjVkhpNl7pJzg=;
        b=dx0QS/OMZ9DNj90r8Oibmd1DiIEuzUgbM3qW+x1BP01AUIa4pCgsrYmgb6oCOs5ZE8
         TOt/LNTnJ3jKgemnNrd6OjwbKw8qin0TI3eYkC/h5pjO3Ks1lWbyJ+bvmaWZgVRWf+GN
         95xDL9KIwHhoa/vUO5WnbGu2WxKolwvub7gP9E2MDl/MiectdXpT3DqX+ksiW2z4xAb8
         WZbtXKXs8MVbY/W8axj0JbZ0+lTxcH1007VShdoMBhaFCarc67ISWgori6OqgjHDx969
         E0HvYjiLaxuEsymDFc9bbGsSUctbiSOqmxtfkwWNI3sekxIlAwdJOLGNlmwVzCOkOz/S
         RfMw==
X-Gm-Message-State: AOAM531Z85whkfu2Pm6KDIvtVwsB3tlzsBE2U1Jn66oCUv22Vg4JUfz8
        uAlVnCSG4XfoQpJDJt1BP5I=
X-Google-Smtp-Source: ABdhPJyjR29eXQ/jcFGZA7K9J3N0ojT8zv0g7ivanLKp2pLZprScUO2+xjgHE8fbTrloyufHDwOVKw==
X-Received: by 2002:a1c:f302:: with SMTP id q2mr29357518wmq.85.1619993557268;
        Sun, 02 May 2021 15:12:37 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id d6sm9995933wrr.77.2021.05.02.15.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 15:12:36 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Palash Oswal <oswalpalash@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
References: <0000000000000c97e505bdd1d60e@google.com>
 <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com>
 <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d5844c03-fa61-d256-be0d-b40446414299@gmail.com>
Date:   Sun, 2 May 2021 23:12:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 3:21 PM, Palash Oswal wrote:
> On Thursday, March 18, 2021 at 9:40:21 PM UTC+5:30 syzbot wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit: 0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
>> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12dde5aed00000
>> kernel config: https://syzkaller.appspot.com/x/.config?x=81c0b708b31626cc
>> dashboard link: https://syzkaller.appspot.com/bug?extid=11bf59db879676f59e52
>> userspace arch: riscv64
>> CC: [asml.s...@gmail.com ax...@kernel.dk io-u...@vger.kernel.org linux-...@vger.kernel.org]
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+11bf59...@syzkaller.appspotmail.com
>>
>> INFO: task iou-sqp-4867:4871 blocked for more than 430 seconds.
>> Not tainted 5.12.0-rc2-syzkaller-00467-g0d7588ab9ef9 #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:iou-sqp-4867 state:D stack: 0 pid: 4871 ppid: 4259 flags:0x00000004
>> Call Trace:
>> [<ffffffe003bc3252>] context_switch kernel/sched/core.c:4324 [inline]
>> [<ffffffe003bc3252>] __schedule+0x478/0xdec kernel/sched/core.c:5075
>> [<ffffffe003bc3c2a>] schedule+0x64/0x166 kernel/sched/core.c:5154
>> [<ffffffe0004b80ee>] io_uring_cancel_sqpoll+0x1de/0x294 fs/io_uring.c:8858
>> [<ffffffe0004c19cc>] io_sq_thread+0x548/0xe58 fs/io_uring.c:6750
>> [<ffffffe000005570>] ret_from_exception+0x0/0x14

The test might be very useful. Would you send a patch to
liburing? Or mind the repro being taken as a test?


>>
>> Showing all locks held in the system:
>> 3 locks held by kworker/u4:0/7:
>> 3 locks held by kworker/1:0/19:
>> 1 lock held by khungtaskd/1556:
>> #0: ffffffe00592b5e8 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x32/0x1fa kernel/locking/lockdep.c:6329
>> 1 lock held by klogd/3947:
>> 2 locks held by getty/4142:
>> #0: ffffffe00f1aa098 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x48 drivers/tty/tty_ldsem.c:340
>> #1: ffffffd010b6f2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x9ac/0xb08 drivers/tty/n_tty.c:2178
>> 2 locks held by kworker/0:1/4375:
>>
>> =============================================
>>
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzk...@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> Attaching a C reproducer for this bug:
> 
> #define _GNU_SOURCE
> 
> #include <fcntl.h>
> #include <signal.h>
> #include <stdint.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <sys/wait.h>
> #include <time.h>
> #include <unistd.h>
> 
> static uint64_t current_time_ms(void)
> {
>     struct timespec ts;
>     if (clock_gettime(CLOCK_MONOTONIC, &ts))
>         exit(1);
>     return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
> }
> 
> #define SIZEOF_IO_URING_SQE 64
> #define SIZEOF_IO_URING_CQE 16
> #define SQ_TAIL_OFFSET 64
> #define SQ_RING_MASK_OFFSET 256
> #define SQ_RING_ENTRIES_OFFSET 264
> #define CQ_RING_ENTRIES_OFFSET 268
> #define CQ_CQES_OFFSET 320
> 
> struct io_sqring_offsets {
>     uint32_t head;
>     uint32_t tail;
>     uint32_t ring_mask;
>     uint32_t ring_entries;
>     uint32_t flags;
>     uint32_t dropped;
>     uint32_t array;
>     uint32_t resv1;
>     uint64_t resv2;
> };
> 
> struct io_cqring_offsets {
>     uint32_t head;
>     uint32_t tail;
>     uint32_t ring_mask;
>     uint32_t ring_entries;
>     uint32_t overflow;
>     uint32_t cqes;
>     uint64_t resv[2];
> };
> 
> struct io_uring_params {
>     uint32_t sq_entries;
>     uint32_t cq_entries;
>     uint32_t flags;
>     uint32_t sq_thread_cpu;
>     uint32_t sq_thread_idle;
>     uint32_t features;
>     uint32_t resv[4];
>     struct io_sqring_offsets sq_off;
>     struct io_cqring_offsets cq_off;
> };
> 
> #define IORING_OFF_SQ_RING 0
> #define IORING_OFF_SQES 0x10000000ULL
> 
> #define sys_io_uring_setup 425
> static long syz_io_uring_setup(volatile long a0, volatile long a1,
> volatile long a2, volatile long a3, volatile long a4, volatile long
> a5)
> {
>     uint32_t entries = (uint32_t)a0;
>     struct io_uring_params* setup_params = (struct io_uring_params*)a1;
>     void* vma1 = (void*)a2;
>     void* vma2 = (void*)a3;
>     void** ring_ptr_out = (void**)a4;
>     void** sqes_ptr_out = (void**)a5;
>     uint32_t fd_io_uring = syscall(sys_io_uring_setup, entries, setup_params);
>     uint32_t sq_ring_sz = setup_params->sq_off.array +
> setup_params->sq_entries * sizeof(uint32_t);
>     uint32_t cq_ring_sz = setup_params->cq_off.cqes +
> setup_params->cq_entries * SIZEOF_IO_URING_CQE;
>     uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
>     *ring_ptr_out = mmap(vma1, ring_sz, PROT_READ | PROT_WRITE,
> MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring,
> IORING_OFF_SQ_RING);
>     uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
>     *sqes_ptr_out = mmap(vma2, sqes_sz, PROT_READ | PROT_WRITE,
> MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQES);
>     return fd_io_uring;
> }
> 
> static long syz_io_uring_submit(volatile long a0, volatile long a1,
> volatile long a2, volatile long a3)
> {
>     char* ring_ptr = (char*)a0;
>     char* sqes_ptr = (char*)a1;
>     char* sqe = (char*)a2;
>     uint32_t sqes_index = (uint32_t)a3;
>     uint32_t sq_ring_entries = *(uint32_t*)(ring_ptr + SQ_RING_ENTRIES_OFFSET);
>     uint32_t cq_ring_entries = *(uint32_t*)(ring_ptr + CQ_RING_ENTRIES_OFFSET);
>     uint32_t sq_array_off = (CQ_CQES_OFFSET + cq_ring_entries *
> SIZEOF_IO_URING_CQE + 63) & ~63;
>     if (sq_ring_entries)
>         sqes_index %= sq_ring_entries;
>     char* sqe_dest = sqes_ptr + sqes_index * SIZEOF_IO_URING_SQE;
>     memcpy(sqe_dest, sqe, SIZEOF_IO_URING_SQE);
>     uint32_t sq_ring_mask = *(uint32_t*)(ring_ptr + SQ_RING_MASK_OFFSET);
>     uint32_t* sq_tail_ptr = (uint32_t*)(ring_ptr + SQ_TAIL_OFFSET);
>     uint32_t sq_tail = *sq_tail_ptr & sq_ring_mask;
>     uint32_t sq_tail_next = *sq_tail_ptr + 1;
>     uint32_t* sq_array = (uint32_t*)(ring_ptr + sq_array_off);
>     *(sq_array + sq_tail) = sqes_index;
>     __atomic_store_n(sq_tail_ptr, sq_tail_next, __ATOMIC_RELEASE);
>     return 0;
> }
> 
> static void kill_and_wait(int pid, int* status)
> {
>     kill(-pid, SIGKILL);
>     kill(pid, SIGKILL);
>     while (waitpid(-1, status, __WALL) != pid) {
>     }
> }
> 
> #define WAIT_FLAGS __WALL
> 
> uint64_t r[3] = {0xffffffffffffffff, 0x0, 0x0};
> 
> void trigger_bug(void)
> {
>     intptr_t res = 0;
>     *(uint32_t*)0x20000204 = 0;
>     *(uint32_t*)0x20000208 = 2;
>     *(uint32_t*)0x2000020c = 0;
>     *(uint32_t*)0x20000210 = 0;
>     *(uint32_t*)0x20000218 = -1;
>     memset((void*)0x2000021c, 0, 12);
>     res = -1;
>     res = syz_io_uring_setup(0x7987, 0x20000200, 0x20400000,
> 0x20ffd000, 0x200000c0, 0x200001c0);
>     if (res != -1) {
>         r[0] = res;
>         r[1] = *(uint64_t*)0x200000c0;
>         r[2] = *(uint64_t*)0x200001c0;
>     }
>     *(uint8_t*)0x20000180 = 0xb;
>     *(uint8_t*)0x20000181 = 1;
>     *(uint16_t*)0x20000182 = 0;
>     *(uint32_t*)0x20000184 = 0;
>     *(uint64_t*)0x20000188 = 4;
>     *(uint64_t*)0x20000190 = 0x20000140;
>     *(uint64_t*)0x20000140 = 0x77359400;
>     *(uint64_t*)0x20000148 = 0;
>     *(uint32_t*)0x20000198 = 1;
>     *(uint32_t*)0x2000019c = 0;
>     *(uint64_t*)0x200001a0 = 0;
>     *(uint16_t*)0x200001a8 = 0;
>     *(uint16_t*)0x200001aa = 0;
>     memset((void*)0x200001ac, 0, 20);
>     syz_io_uring_submit(r[1], r[2], 0x20000180, 1);
>     *(uint32_t*)0x20000544 = 0;
>     *(uint32_t*)0x20000548 = 0x36;
>     *(uint32_t*)0x2000054c = 0;
>     *(uint32_t*)0x20000550 = 0;
>     *(uint32_t*)0x20000558 = r[0];
>     memset((void*)0x2000055c, 0, 12);
>     syz_io_uring_setup(0x4bf1, 0x20000540, 0x20ffd000, 0x20ffc000, 0, 0);
> 
> }
> int main(void)
> {
>     syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>     int pid = fork();
>     if (pid < 0)
>         exit(1);
>     if (pid == 0) {
>         trigger_bug();
>         exit(0);
>     }
>     int status = 0;
>     uint64_t start = current_time_ms();
>     for (;;) {
>         if (current_time_ms() - start < 1000) {
>             continue;
>         }
>         kill_and_wait(pid, &status);
>         break;
>     }
>     return 0;
> }
> 

-- 
Pavel Begunkov
