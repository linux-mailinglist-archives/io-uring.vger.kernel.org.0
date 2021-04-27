Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCC336C114
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 10:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhD0IiY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 04:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbhD0IiX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 04:38:23 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE3DC061574;
        Tue, 27 Apr 2021 01:37:40 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n3-20020a05600c4f83b02901425630b2c2so639539wmq.1;
        Tue, 27 Apr 2021 01:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uhZAjnkgZe0IyevzC12l8X0Gsc2y2ya0X/xDEI6Oyos=;
        b=aoiScOITAHsawvctlUCKQQ2A87lu+tOw0OQc1m1jKV8PeDsrRQaAefy9usA0FdhmX2
         5cFiGo2f73SBWquOBoU24M2E9r2eYgFYeqGpSw5JENrY/qpGMCXoFtx1Xj0h1u5kkD3z
         KrnaHOBRdC3w13zYCh4B3ojn/7ABuRGIDDNa2OH6nuAw3wwWJEc3mrKRqIsN8KolTChr
         K8JOF+CuJ5cfwwiSrs6J6eMmJpqWHlDNqAFZDjOSMaHJw+m4S+ExNmc2leM5yaDXVn7w
         zc8IMh4/D/8C7Kxx27gSA86l7Bre6jlM2dDPnCQpejE5VHbTxyhp9PsLW9YkLIDOKDkJ
         uwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uhZAjnkgZe0IyevzC12l8X0Gsc2y2ya0X/xDEI6Oyos=;
        b=E1KZ+nS8J8HpNzeiU5IWuzNfN4MOSag3mMzjRk+O222fjtDwyizl3KAmMvO/I8wHIl
         1SbfV9FDwZdRkRL6WauezVAocS3XsbpfSsZrB92orTpQL3UruMshk56YOLxmd6KFGZPk
         WnIdq+IyiZ0Y84eBb6r6uiblwsF3ZxjZxHmgDh8E1y+Xx/l14xuMmPjXd7Va50Qrkl2w
         gNXHLAVmxyFzLDm0fcRojrzmr332rXYeKEfuU0NmqclVw7UlucJwAc6SGq6SxZ2GYmwq
         idbgRZGtYPL1CflqH0sNh1rvksxGucz4u5xx5CV9LTR7zlE7Mpa0QAQsABCogbeDIVX3
         d81Q==
X-Gm-Message-State: AOAM533WIpmwbL6ID1x/eu05B0uT4pJndRs17+M5SXVFJrC+G7vq0OID
        aQ6q2YIzpdvDKqkpiI9eoMQ=
X-Google-Smtp-Source: ABdhPJyg8PW1BOuHDDYcb+60qBjMJHi/H+NFCDqRPdWqYwUkmF6QH30wlFpl6c62LzW6BIaPKg8HCg==
X-Received: by 2002:a1c:a5c1:: with SMTP id o184mr12507488wme.106.1619512659443;
        Tue, 27 Apr 2021 01:37:39 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id b202sm1810286wmb.5.2021.04.27.01.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 01:37:38 -0700 (PDT)
Subject: Re: KASAN: null-ptr-deref Write in io_uring_cancel_sqpoll
To:     Palash Oswal <oswalpalash@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
References: <00000000000022ebeb05bc39f582@google.com>
 <e939af11-7ce8-46af-8c76-651add0ae56bn@googlegroups.com>
 <CACT4Y+aPRCZcLvkuWgK=A_rR0PqdEAM+xssWU4N7hNRSm9=mSA@mail.gmail.com>
 <CAGyP=7fBRPc+qH9UvhGhid9j-B2PeYhQ4bbde_Vg72Mnx9z75Q@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <dba3f0a9-cb5d-a162-b696-864295259581@gmail.com>
Date:   Tue, 27 Apr 2021 09:37:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAGyP=7fBRPc+qH9UvhGhid9j-B2PeYhQ4bbde_Vg72Mnx9z75Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/27/21 8:05 AM, Palash Oswal wrote:
>> +kernel lists and syzbot email
>> (almost nobody is reading syzkaller-bugs@ itself)
> Thanks Dmitry. I used "reply-all" in the google groups UI, and I
> didn't check the cc list before hitting send :/
> 
> I have made progress on this bug. I applied a diff (to print some
> debug values) on the v5.12 fs/io_uring.c code and got a fairly
> consistent reproducer on a non-kvm based qemu VM (had to slow down the
> rate of syscalls processed for this to trigger early).
> 
> My initial speculation was very wrong. And the real issue seems to be
> that current->io_uring is unset when io_uring_cancel_sqpoll is called.
> 
> Adding the c reproducer here:
> #define _GNU_SOURCE
> 
> #include <endian.h>
> #include <signal.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/mman.h>
> #include <sys/stat.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <time.h>
> #include <sys/wait.h>
> 
> #define sys_io_uring_setup 425
> #define WAIT_FLAGS __WALL
> 
> static unsigned long long procid;
> 
> static void sleep_ms(uint64_t ms)
> {
>     usleep(ms * 1000);
> }
> 
> 
> static void kill_and_wait(int pid, int* status)
> {
>     kill(-pid, SIGKILL);
>     kill(pid, SIGKILL);
>     for (int i = 0; i < 100; i++) {
>         if (waitpid(-1, status, WNOHANG | __WALL) == pid)
>             return;
>         usleep(1000);
>     }
>     while (waitpid(-1, status, __WALL) != pid) {
>     }
> }
> 
> static void execute_one(void) {
>     *(uint32_t*)0x20000084 = 0x850e;
>     *(uint32_t*)0x20000088 = 2;
>     *(uint32_t*)0x2000008c = 2;
>     *(uint32_t*)0x20000090 = 0x1b4;
>     *(uint32_t*)0x20000098 = -1;
>     memset((void*)0x2000009c, 0, 12);
>     syscall(sys_io_uring_setup, 0x329b, 0x20000080);
> }
> 
> static uint64_t current_time_ms(void)
> {
>     struct timespec ts;
>     if (clock_gettime(CLOCK_MONOTONIC, &ts))
>         exit(1);
>     return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
> }
> 
> 
> static void loop(void)
> {
>     int iter = 0;
>     for (;; iter++) {
>         int pid = fork();
>         if (pid < 0)
>             exit(1);
>         if (pid == 0) {
>             execute_one();
>             exit(0);
>         }
>         int status = 0;
>         uint64_t start = current_time_ms();
>         for (;;) {
>             if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
>                 break;
>             sleep_ms(1);
>             kill_and_wait(pid, &status);
>             break;
>         }
>     }
> }
> 
> 
> 
> 
> int main(void)
> {
>     syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>     for (procid = 0; procid < 8; procid++) {
>         if (fork() == 0) {
>             loop();
>         }
>     }
>     sleep(1000000);
>     return 0;
> }
> Some debug console logs:
> [   58.455071] ctx is 39386608
> [   58.455415] io_uring_cancel_sqpoll called with ctx :39386080
> [   58.455913] ctx->sq_data is 00000000c9f086d5
> [   58.456146] current is 000000005e7bf8a0
> [   58.456346] current->io_uring is :0000000000000000
> [   58.457244] ==================================================================
> [   58.457663] BUG: KASAN: null-ptr-deref in io_uring_cancel_sqpoll+0x341/0x4b0
> [   58.458214] Write of size 4 at addr 0000000000000060 by task
> iou-sqp-1857/1860
> [   58.458699]
> [   58.459061] CPU: 1 PID: 1860 Comm: iou-sqp-1857 Not tainted 5.12.0+ #83
> [   58.459522] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.14.0-1 04/01/2014
> [   58.460065] Call Trace:
> [   58.460402]  dump_stack+0xe9/0x168
> [   58.460749]  ? io_uring_cancel_sqpoll+0x341/0x4b0
> [   58.460846]  __kasan_report+0x166/0x1c0
> [   58.460846]  ? io_uring_cancel_sqpoll+0x341/0x4b0
> [   58.460846]  kasan_report+0x4f/0x70
> [   58.460846]  kasan_check_range+0x2f3/0x340
> [   58.460846]  __kasan_check_write+0x14/0x20
> [   58.460846]  io_uring_cancel_sqpoll+0x341/0x4b0
> [   58.460846]  ? io_sq_thread_unpark+0xd0/0xd0
> [   58.460846]  ? init_wait_entry+0xe0/0xe0
> [   58.460846]  io_sq_thread+0x1a0d/0x1c50
> [   58.460846]  ? io_rsrc_put_work+0x380/0x380
> [   58.460846]  ? init_wait_entry+0xe0/0xe0
> [   58.460846]  ? _raw_spin_lock_irq+0xa5/0x180
> [   58.460846]  ? _raw_spin_lock_irqsave+0x190/0x190
> [   58.460846]  ? calculate_sigpending+0x6b/0xa0
> [   58.460846]  ? io_rsrc_put_work+0x380/0x380
> [   58.460846]  ret_from_fork+0x22/0x30
> 
> I'm going to look further into why this is happening.

io_sq_offload_create() {
    ...
    ret = io_uring_alloc_task_context(tsk, ctx);
    wake_up_new_task(tsk);
    if (ret)
        goto err;
}

Shouldn't happen unless offload create has failed. Just add
a return in *cancel_sqpoll() for this case. It's failing
so no requests has been submitted and no cancellation is needed.

-- 
Pavel Begunkov
