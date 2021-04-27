Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33B36BFBB
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 09:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhD0HG0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 03:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhD0HGS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 03:06:18 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784ABC06175F;
        Tue, 27 Apr 2021 00:05:34 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id z23so20523997lji.4;
        Tue, 27 Apr 2021 00:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDHuq6cKvw3UBA//AzKnWt1sxYQoNAnBwsBQK/T1M9U=;
        b=DOB3ARQCSqStyJ0EDKG1D0WdzeKunnvDdLpowdqw/8aeEI+vHt496CqbQPy0eTNOZ/
         FOBDGKMH+w5R3aNT1wtcFZ7pL5imwknr+QLAl6OfUNNjM80WSgNUFEQ7IMKXXDUxLCD4
         0guMwLz8vtag7hQIFACRZVMEAWnRAQWNxwuIHeKmr9pMHgguG2NybN4e+OM5qFSZUCdO
         o6JbPvnMViO/2a/KGfx/3yyjcn/N667DFpC0BQlAlsF0ESq7LRZaBp2b6UBqwmnjSgxA
         qQkDs/b3kr4NC6SZX+Ak3xaa/33n0N2+nYTC/4Kmmi9cKOjviXROx73wlKdgMixg2V6u
         mtbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDHuq6cKvw3UBA//AzKnWt1sxYQoNAnBwsBQK/T1M9U=;
        b=INnEmgc1OUgiiZnx7q0oj/GULL53CN7e9zc8AK05Ee3ur/oi4BvvLDsuDeTO/sbuNM
         jrzP6H0j//4FHVa8k+XtisT2vzJ9ZNAnZmuJ2iWwyBRsPHoZNH8CnetH91B1AL09gSM8
         XMWEm6VoD4FQYPvoqMgDQpUnMGUQ2Eo/oLCNMCgw+pO81cgZqidYIJkavJZvfdU3dYh5
         laXRXLtAvc0E9pvLVH3N0KwAn0IEsug6WwR+I9EnhDygc6qSz1siLLKUaddRvgTbNEAQ
         XIWQjtzVnC2DIoKaFOjYzncrzndjadIOx6KAsZmXNNmxlETY8lIEBvAs2h4BBKuG8Iya
         5MYA==
X-Gm-Message-State: AOAM531zHVQEDW9wcZ5M8+wVHwyjjFLgrzdxc52VrtDQeKJoyp6F11lR
        fpSisTdLxNglGY0yxxyuWynfrLh9g9m1k18upqwY+U70Hf406A==
X-Google-Smtp-Source: ABdhPJyIo8NznBHHo+INm3FJ0dI24+1LaY+YMbSEwpdgBrX0yeS4c+NStaYIoJ3Xoqn1Na6a97oxO13ze4qrIlTcoss=
X-Received: by 2002:a2e:b5b5:: with SMTP id f21mr15760684ljn.340.1619507132866;
 Tue, 27 Apr 2021 00:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000022ebeb05bc39f582@google.com> <e939af11-7ce8-46af-8c76-651add0ae56bn@googlegroups.com>
 <CACT4Y+aPRCZcLvkuWgK=A_rR0PqdEAM+xssWU4N7hNRSm9=mSA@mail.gmail.com>
In-Reply-To: <CACT4Y+aPRCZcLvkuWgK=A_rR0PqdEAM+xssWU4N7hNRSm9=mSA@mail.gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Tue, 27 Apr 2021 12:35:21 +0530
Message-ID: <CAGyP=7fBRPc+qH9UvhGhid9j-B2PeYhQ4bbde_Vg72Mnx9z75Q@mail.gmail.com>
Subject: Re: KASAN: null-ptr-deref Write in io_uring_cancel_sqpoll
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +kernel lists and syzbot email
> (almost nobody is reading syzkaller-bugs@ itself)
Thanks Dmitry. I used "reply-all" in the google groups UI, and I
didn't check the cc list before hitting send :/

I have made progress on this bug. I applied a diff (to print some
debug values) on the v5.12 fs/io_uring.c code and got a fairly
consistent reproducer on a non-kvm based qemu VM (had to slow down the
rate of syscalls processed for this to trigger early).

My initial speculation was very wrong. And the real issue seems to be
that current->io_uring is unset when io_uring_cancel_sqpoll is called.

Adding the c reproducer here:
#define _GNU_SOURCE

#include <endian.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>
#include <sys/wait.h>

#define sys_io_uring_setup 425
#define WAIT_FLAGS __WALL

static unsigned long long procid;

static void sleep_ms(uint64_t ms)
{
    usleep(ms * 1000);
}


static void kill_and_wait(int pid, int* status)
{
    kill(-pid, SIGKILL);
    kill(pid, SIGKILL);
    for (int i = 0; i < 100; i++) {
        if (waitpid(-1, status, WNOHANG | __WALL) == pid)
            return;
        usleep(1000);
    }
    while (waitpid(-1, status, __WALL) != pid) {
    }
}

static void execute_one(void) {
    *(uint32_t*)0x20000084 = 0x850e;
    *(uint32_t*)0x20000088 = 2;
    *(uint32_t*)0x2000008c = 2;
    *(uint32_t*)0x20000090 = 0x1b4;
    *(uint32_t*)0x20000098 = -1;
    memset((void*)0x2000009c, 0, 12);
    syscall(sys_io_uring_setup, 0x329b, 0x20000080);
}

static uint64_t current_time_ms(void)
{
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts))
        exit(1);
    return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}


static void loop(void)
{
    int iter = 0;
    for (;; iter++) {
        int pid = fork();
        if (pid < 0)
            exit(1);
        if (pid == 0) {
            execute_one();
            exit(0);
        }
        int status = 0;
        uint64_t start = current_time_ms();
        for (;;) {
            if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
                break;
            sleep_ms(1);
            kill_and_wait(pid, &status);
            break;
        }
    }
}




int main(void)
{
    syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
    for (procid = 0; procid < 8; procid++) {
        if (fork() == 0) {
            loop();
        }
    }
    sleep(1000000);
    return 0;
}


Changes to the kernel on v5.12:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index dff34975d86b..beff12baaebf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6758,6 +6758,7 @@ static int io_sq_thread(void *data)
        io_run_task_work_head(&sqd->park_task_work);

        while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
+               pr_info("In the loop, need to stop");
                int ret;
                bool cap_entries, sqt_spin, needs_sched;

@@ -6831,7 +6832,7 @@ static int io_sq_thread(void *data)
                io_run_task_work_head(&sqd->park_task_work);
                timeout = jiffies + sqd->sq_thread_idle;
        }
-
+       printk("ctx is %d",&ctx);
        list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
                io_uring_cancel_sqpoll(ctx);
        sqd->thread = NULL;
@@ -7171,6 +7172,7 @@ static void io_sq_thread_stop(struct io_sq_data *sqd)
        WARN_ON_ONCE(sqd->thread == current);

        mutex_lock(&sqd->lock);
+       pr_info("Setting Doom bit");
        set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
        if (sqd->thread)
                wake_up_process(sqd->thread);
@@ -8994,7 +8996,11 @@ void __io_uring_files_cancel(struct files_struct *files)
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 {
        struct io_sq_data *sqd = ctx->sq_data;
+       printk("io_uring_cancel_sqpoll called with ctx :%d\n",&ctx);
+       printk("ctx->sq_data is %p \n",ctx->sq_data);
        struct io_uring_task *tctx = current->io_uring;
+       printk("current is %p\n", current);
+       printk("current->io_uring is :%p\n",current->io_uring);
        s64 inflight;
        DEFINE_WAIT(wait);

@@ -9548,7 +9554,6 @@ static int io_uring_create(unsigned entries,
struct io_uring_params *p,
        ret = io_allocate_scq_urings(ctx, p);
        if (ret)
                goto err;
-
        ret = io_sq_offload_create(ctx, p);
        if (ret)
                goto err;


Some debug console logs:
[   58.455071] ctx is 39386608
[   58.455415] io_uring_cancel_sqpoll called with ctx :39386080
[   58.455913] ctx->sq_data is 00000000c9f086d5
[   58.456146] current is 000000005e7bf8a0
[   58.456346] current->io_uring is :0000000000000000
[   58.457244] ==================================================================
[   58.457663] BUG: KASAN: null-ptr-deref in io_uring_cancel_sqpoll+0x341/0x4b0
[   58.458214] Write of size 4 at addr 0000000000000060 by task
iou-sqp-1857/1860
[   58.458699]
[   58.459061] CPU: 1 PID: 1860 Comm: iou-sqp-1857 Not tainted 5.12.0+ #83
[   58.459522] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.14.0-1 04/01/2014
[   58.460065] Call Trace:
[   58.460402]  dump_stack+0xe9/0x168
[   58.460749]  ? io_uring_cancel_sqpoll+0x341/0x4b0
[   58.460846]  __kasan_report+0x166/0x1c0
[   58.460846]  ? io_uring_cancel_sqpoll+0x341/0x4b0
[   58.460846]  kasan_report+0x4f/0x70
[   58.460846]  kasan_check_range+0x2f3/0x340
[   58.460846]  __kasan_check_write+0x14/0x20
[   58.460846]  io_uring_cancel_sqpoll+0x341/0x4b0
[   58.460846]  ? io_sq_thread_unpark+0xd0/0xd0
[   58.460846]  ? init_wait_entry+0xe0/0xe0
[   58.460846]  io_sq_thread+0x1a0d/0x1c50
[   58.460846]  ? io_rsrc_put_work+0x380/0x380
[   58.460846]  ? init_wait_entry+0xe0/0xe0
[   58.460846]  ? _raw_spin_lock_irq+0xa5/0x180
[   58.460846]  ? _raw_spin_lock_irqsave+0x190/0x190
[   58.460846]  ? calculate_sigpending+0x6b/0xa0
[   58.460846]  ? io_rsrc_put_work+0x380/0x380
[   58.460846]  ret_from_fork+0x22/0x30

I'm going to look further into why this is happening.
