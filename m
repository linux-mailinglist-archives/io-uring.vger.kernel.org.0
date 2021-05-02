Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B561370B1C
	for <lists+io-uring@lfdr.de>; Sun,  2 May 2021 12:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhEBKh5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 06:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhEBKh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 06:37:57 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA495C06174A;
        Sun,  2 May 2021 03:37:04 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id t11-20020a05600c198bb02901476e13296aso1801743wmq.0;
        Sun, 02 May 2021 03:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TTLd8Zqi4crcDcgfyOWEZQUO902O4MDlqOP3AcIdY4k=;
        b=OLQftgsbpCLcxFVlaCWZ4A6xpfnDbvfYc59oBh0T02gQZSyFVFotsaftOFcrRlXvBz
         vCEUgQckxSEXGOP75chhiUpsdc2cdGkrkURgcJsUn9pNcUk6L2oxFuMBwRhbD161X5le
         KtJ1Nercj3yL4unOQLTttUMOZ9vG69bnEB/oiUSu/UsJNhJjL0z5Jt7YeEmh7wtenaZ5
         etpv1yxoIHKmLZbEjhg9CMSONCHfka/SMeM3grZa6gon1l3bCoccH9kUaZyd1Qu9kU3D
         dSvZnbSKGaUkZckGDwcnVxQaqPDJBd/EkvwzhRVFAtaD8pBUJfdQel2NXQzXawbv8O9x
         mq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TTLd8Zqi4crcDcgfyOWEZQUO902O4MDlqOP3AcIdY4k=;
        b=RTB+EE3d59YdjpZ7nb/f8sm23znClkc1QvXx+oPmoTuB4BA2PE8eCn+bAfH8591Atk
         ikRK5Kby2cj97dFpMr+oaLEHDZyv7YSgu5232rpizMnIYm7szb6iNqPYzyfFmc5v/lal
         5/NgUFAbg5rH0AWCht6fLn8lTW9ANVDa1iIYlFTk7aIZ6bGolyS+Hls7ZSgKhrYP2LMD
         OcHXJpxr5/VehX2cVuRqLd8Wm0jgZtiSWc+fcsNiYNv6pLj7mwr1BHrnl5jWnM8yYSti
         G3Z79Gs2LA7rUaqwyTCZDnrtiOqyCsaVi2Z1xUBhIzXX3U/3ZLsDGQazw46LEE3pRWKb
         +EVQ==
X-Gm-Message-State: AOAM530kURukkXNnleX9mlMsU7DV67RTVRCGPARsBHpv/Lmu2bCAsSlO
        q23niqLCly8aV37+fczh72zwsdvUByo=
X-Google-Smtp-Source: ABdhPJxCEYPAdyjO6EVR2p1kLOMV52zsH+2OyEmuJWMVY7T2+maYQCLdEq7bCoE6n9xY03/XzKoZGg==
X-Received: by 2002:a1c:b783:: with SMTP id h125mr26672847wmf.182.1619951823218;
        Sun, 02 May 2021 03:37:03 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.156])
        by smtp.gmail.com with ESMTPSA id w7sm1218031wru.51.2021.05.02.03.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 03:37:02 -0700 (PDT)
Subject: Re: KASAN: stack-out-of-bounds Read in iov_iter_revert
To:     Palash Oswal <oswalpalash@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <CAGyP=7exAVOC0Er5VzmwL=HLih-wpmyDijEPVjGzUEj3SCYENA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <4b2c435c-699b-b29f-6893-4beae6d004a9@gmail.com>
Date:   Sun, 2 May 2021 11:36:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7exAVOC0Er5VzmwL=HLih-wpmyDijEPVjGzUEj3SCYENA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/21 11:09 AM, Palash Oswal wrote:
> Hello,
> 
> My syzkaller instance discovered 'KASAN: stack-out-of-bounds Read in
> iov_iter_revert' bug on the v5.12 kernel (head
> 9f4ad9e425a1d3b6a34617b8ea226d56a119a717)

May be related to
http://mail.spinics.net/lists/io-uring/msg07874.html

Was it raw bdev I/O, or a normal filesystem?

> 
> ==================================================================
> Kernel Crash Console Logs:
> BUG: KASAN: stack-out-of-bounds in iov_iter_revert+0x158/0x510
> lib/iov_iter.c:1144
> Read of size 8 at addr ffffc90000d7fa08 by task syz-executor871/333
> 
> CPU: 0 PID: 333 Comm: syz-executor871 Not tainted 5.12.0 #16
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xe9/0x15b lib/dump_stack.c:120
>  print_address_description+0x81/0x3d0 mm/kasan/report.c:232
>  __kasan_report+0x170/0x1c0 mm/kasan/report.c:399
>  kasan_report+0x4f/0x70 mm/kasan/report.c:416
>  check_region_inline mm/kasan/generic.c:177 [inline]
>  __asan_load8+0x94/0xb0 mm/kasan/generic.c:253
>  iov_iter_revert+0x158/0x510 lib/iov_iter.c:1144
>  io_write fs/io_uring.c:3457 [inline]
>  io_issue_sqe+0x3ce8/0x6050 fs/io_uring.c:6061
>  __io_queue_sqe+0xcd/0x3a0 fs/io_uring.c:6322
>  io_queue_sqe+0x7a/0x180 fs/io_uring.c:6375
>  io_submit_sqe+0x813/0xa10 fs/io_uring.c:6546
>  io_submit_sqes+0x61c/0xad0 fs/io_uring.c:6660
>  __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
>  __se_sys_io_uring_enter+0x28f/0xce0 fs/io_uring.c:9182
>  __x64_sys_io_uring_enter+0x82/0xa0 fs/io_uring.c:9182
>  do_syscall_64+0x37/0x80 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x44a2ed
> Code: 28 c3 e8 06 2a 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcc8342468 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000044a2ed
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 00007ffcc8342480 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcc8342490
> R13: 0000000000000000 R14: 00000000004c1018 R15: 0000000000000000
> 
> 
> addr ffffc90000d7fa08 is located in stack of task syz-executor871/333
> at offset 1672 in frame:
>  io_issue_sqe+0x0/0x6050 include/linux/refcount.h:283
> 
> this frame has 17 objects:
>  [32, 48) 'up.i'
>  [64, 72) 'file.i667'
>  [96, 112) 'data.i6.i'
>  [128, 144) 'data.i.i'
>  [160, 288) '__io.i'
>  [320, 416) 'msg.i424'
>  [448, 464) 'iov.i425'
>  [480, 848) 'iomsg.i370'
>  [912, 1008) 'msg.i'
>  [1040, 1056) 'iov.i'
>  [1072, 1440) 'iomsg.i'
>  [1504, 1536) 'ipt.i'
>  [1568, 1576) 'iovec.i182'
>  [1600, 1640) '__iter.i183'
>  [1680, 1808) 'inline_vecs.i'
>  [1840, 1848) 'iovec.i'
>  [1872, 1912) '__iter.i'
> 
> Memory state around the buggy address:
>  ffffc90000d7f900: 00 00 00 00 f2 f2 f2 f2 f2 f2 f2 f2 00 00 00 00
>  ffffc90000d7f980: f2 f2 f2 f2 00 f2 f2 f2 00 00 00 00 00 f2 f2 f2
>> ffffc90000d7fa00: f2 f2 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>                       ^
>  ffffc90000d7fa80: 00 00 f2 f2 f2 f2 00 f2 f2 f2 00 00 00 00 00 f3
>  ffffc90000d7fb00: f3 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================
> 
> Syzkaller reproducer:
> # {Threaded:false Collide:false Repeat:false RepeatTimes:0 Procs:1
> Slowdown:1 Sandbox:none Fault:false FaultCall:-1 FaultNth:0 Leak:false
> NetInjection:false NetDevices:false NetReset:false Cgroups:false
> BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false
> VhciInjection:false Wifi:false IEEE802154:false Sysctl:false
> UseTmpDir:false HandleSegv:false Repro:false Trace:false}
> r0 = syz_io_uring_setup(0x2, &(0x7f0000000080)={0x0, 0x0, 0x0, 0x0,
> 0x0, 0x0, 0x0}, &(0x7f00000a0000)=nil, &(0x7f00000b0000)=nil,
> &(0x7f0000000100)=<r1=>0x0, &(0x7f0000000240)=<r2=>0x0)
> r3 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x4541, 0x0)
> syz_io_uring_submit(r1, r2, &(0x7f0000000000)=@IORING_OP_WRITE={0x17,
> 0x0, 0x0, @fd=r3, 0x0, 0x0, 0xfffffffffffffff4}, 0x20)
> io_uring_enter(r0, 0x1, 0x0, 0x0, 0x0, 0x0)
> 
> C reproducer:
> #define _GNU_SOURCE
> 
> #include <errno.h>
> #include <fcntl.h>
> #include <stdarg.h>
> #include <stdbool.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/mman.h>
> #include <sys/prctl.h>
> #include <sys/resource.h>
> #include <sys/syscall.h>
> #include <sys/wait.h>
> #include <unistd.h>
> 
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
>                                volatile long a2, volatile long a3,
>                                volatile long a4, volatile long a5)
> {
>     uint32_t entries = (uint32_t)a0;
>     struct io_uring_params* setup_params = (struct io_uring_params*)a1;
>     void* vma1 = (void*)a2;
>     void* vma2 = (void*)a3;
>     void** ring_ptr_out = (void**)a4;
>     void** sqes_ptr_out = (void**)a5;
>     uint32_t fd_io_uring = syscall(sys_io_uring_setup, entries, setup_params);
>     uint32_t sq_ring_sz =
>             setup_params->sq_off.array + setup_params->sq_entries *
> sizeof(uint32_t);
>     uint32_t cq_ring_sz = setup_params->cq_off.cqes +
>                           setup_params->cq_entries * SIZEOF_IO_URING_CQE;
>     uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
>     *ring_ptr_out = mmap(vma1, ring_sz, PROT_READ | PROT_WRITE,
>                          MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring,
>                          IORING_OFF_SQ_RING);
>     uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
>     *sqes_ptr_out =
>             mmap(vma2, sqes_sz, PROT_READ | PROT_WRITE,
>                  MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring,
> IORING_OFF_SQES);
>     return fd_io_uring;
> }
> 
> static long syz_io_uring_submit(volatile long a0, volatile long a1,
>                                 volatile long a2, volatile long a3)
> {
>     char* ring_ptr = (char*)a0;
>     char* sqes_ptr = (char*)a1;
>     char* sqe = (char*)a2;
>     uint32_t sqes_index = (uint32_t)a3;
>     uint32_t sq_ring_entries = *(uint32_t*)(ring_ptr + SQ_RING_ENTRIES_OFFSET);
>     uint32_t cq_ring_entries = *(uint32_t*)(ring_ptr + CQ_RING_ENTRIES_OFFSET);
>     uint32_t sq_array_off =
>             (CQ_CQES_OFFSET + cq_ring_entries * SIZEOF_IO_URING_CQE + 63) & ~63;
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
> #ifndef __NR_io_uring_enter
> #define __NR_io_uring_enter 426
> #endif
> 
> uint64_t r[4] = {0xffffffffffffffff, 0x0, 0x0, 0xffffffffffffffff};
> 
> void trigger_bug(void)
> {
>     intptr_t res = 0;
>     *(uint32_t*)0x20000084 = 0;
>     *(uint32_t*)0x20000088 = 0;
>     *(uint32_t*)0x2000008c = 0;
>     *(uint32_t*)0x20000090 = 0;
>     *(uint32_t*)0x20000098 = 0;
>     memset((void*)0x2000009c, 0, 12);
>     res = -1;
>     res = syz_io_uring_setup(2, 0x20000080, 0x200a0000, 0x200b0000, 0x20000100,
>                              0x20000240);
>     // res = 3
>     if (res != -1) {
>         r[0] = res; //3
>         r[1] = *(uint64_t*)0x20000100; // 0x0
>         r[2] = *(uint64_t*)0x20000240; // ./file
>     }
>     memcpy((void*)0x20000040, "./file0\000", 8);
>     res = syscall(__NR_openat, 0xffffff9c, 0x20000040ul, 0x4541ul, 0ul);
>     if (res != -1)
>         r[3] = res;
>     *(uint8_t*)0x20000000 = 0x17;
>     *(uint8_t*)0x20000001 = 0;
>     *(uint16_t*)0x20000002 = 0;
>     *(uint32_t*)0x20000004 = r[3];
>     *(uint64_t*)0x20000008 = 0;
>     *(uint64_t*)0x20000010 = 0;
>     *(uint32_t*)0x20000018 = 0xfffffff4;
>     *(uint32_t*)0x2000001c = 0;
>     *(uint64_t*)0x20000020 = 0;
>     *(uint16_t*)0x20000028 = 0;
>     *(uint16_t*)0x2000002a = 0;
>     syz_io_uring_submit(r[1], r[2], 0x20000000, 0x20);
>     syscall(__NR_io_uring_enter, r[0], 1, 0, 0ul, 0ul, 0ul);
> }
> int main(void)
> {
>     // Preparatory steps
>     struct rlimit rlim;
>     rlim.rlim_cur = rlim.rlim_max = 136 << 20;
>     setrlimit(RLIMIT_FSIZE, &rlim);
>     syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>     trigger_bug();
>     return 0;
> 
> }
> 
> Kernel build config :
> https://gist.github.com/oswalpalash/18e847d6e24e3452bc811526fd6f76bb
> 
> This issue has not yet been discovered by syzbot.
> When rlimit is not set, unroll is set to 0. But when rlimit is set,
> iov_iter_revert gets the input unroll = 2147479542 ( = MAX_RW_COUNT -
> i->count ) and the only warning check implemented in that function is
> if (WARN_ON(unroll > MAX_RW_COUNT))
>         return;
> 
> I'm still trying to understand this code better, but initially suspect
> the warning check needs to be re-done.
> 

-- 
Pavel Begunkov
