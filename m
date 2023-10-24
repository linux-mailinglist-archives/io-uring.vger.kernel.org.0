Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DAE7D44AB
	for <lists+io-uring@lfdr.de>; Tue, 24 Oct 2023 03:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjJXBMa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Oct 2023 21:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjJXBMa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Oct 2023 21:12:30 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFCEE8
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 18:12:27 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3b2d9ac9926so2674169b6e.2
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 18:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698109947; x=1698714747; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i19dNL387EHarULoiwvYkhsMJkYUTQDqMA+r1AyQVYk=;
        b=auKulWPN1zYFR9e7tFCdVjpqkSLXE/ux/6Tb9aGgn6B3Ge8/WB4dsY7CvTteFMmFAh
         CAc17E1dPoNs9+7AqBwXymuzkSDLbhaHVPGYh2PSVP3acmC87XdQ/Ne2iNTH8t71/cjS
         rXDYF6scZDl1F0wshO8NRo/k9vKsA2Tu0I0YBVUX1Id1Hb0wQpu9XaRzJic6nDq6I+aF
         7/0TDBO5gWwQ2xgGY9uN0hFxVVzRVdSn1PHbY8FpPht/4mvxwABytEPvhuy8aykT1oe8
         OryA4CFR7YJKpXWi4wX7zI8il5wCbK2Qi5NCfO1dV+qwGrz1XTBb5hyw0V9FV4bqKKQ8
         hokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698109947; x=1698714747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i19dNL387EHarULoiwvYkhsMJkYUTQDqMA+r1AyQVYk=;
        b=rrImQghcDFt+vNa/ih5M3h/fsYLbX+6OQn4YSoJxvLYPQJ46SjbwSU3bGgl5bxn9mx
         PvY6EprpyyGdwVZxb/TW2FbF18R7AxExgDo6DVqPWeo6K2PGuROOuHZYT20lVP/q2E6K
         zMuxN71raY0FXTEE5Gw41fSabs+lcE5CqRsj7UMmxN2x8BUhtKA7aF+G25j3S2iaAs/6
         ACrt9CduRYOARol0/n2n6SW9GhvlWPZ4IcikQWg6c/nBRtNJdVP0x+iCfqchFY+BSTrF
         XFEplT+Zr42ZNwpcPx2vGzlRyRTxsb7mpVYHgZXX4whSX9a8JAju0bhrp04ZIwOrTVZl
         vzrQ==
X-Gm-Message-State: AOJu0Yz6ytrkJzOghZfNFdr96fGfM++pJpoq+1YTpfyfmsaHmYgppNGF
        VFhpgA/Xi3E4qNgJT2OzdcHbzQ==
X-Google-Smtp-Source: AGHT+IELxuNbh4ViaFGaaBDuDIdC0BRWNEXeQMZjZ4q5+hPRszCZ+5ELnmiNMDJ6NmnlXf+xSZohTQ==
X-Received: by 2002:a54:408f:0:b0:3b2:e0f0:e53d with SMTP id i15-20020a54408f000000b003b2e0f0e53dmr12162830oii.37.1698109947033;
        Mon, 23 Oct 2023 18:12:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id x190-20020a6263c7000000b006b5b46e4098sm7040318pfb.169.2023.10.23.18.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 18:12:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qv5y3-0036UX-1X;
        Tue, 24 Oct 2023 12:12:23 +1100
Date:   Tue, 24 Oct 2023 12:12:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        Ricardo =?iso-8859-1?Q?Ca=F1uelo?= 
        <ricardo.canuelo@collabora.com>, gustavo.padovan@collabora.com,
        zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: task hung in ext4_fallocate #2
Message-ID: <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[cc Jens, io-uring]

On Tue, Oct 17, 2023 at 07:50:09PM -0700, Andres Freund wrote:
> Hi,
> 
> On 2023-10-17 20:43:35 -0400, Theodore Ts'o wrote:
> > On Mon, Oct 16, 2023 at 08:37:25PM -0700, Andres Freund wrote:
> > > I just was able to reproduce the issue, after upgrading to 6.6-rc6 - this time
> > > it took ~55min of high load (io_uring using branch of postgres, running a
> > > write heavy transactional workload concurrently with concurrent bulk data
> > > load) to trigger the issue.
> > >
> > > For now I have left the system running, in case there's something you would
> > > like me to check while the system is hung.
> > >
> > > The first hanging task that I observed:
> > >
> > > cat /proc/57606/stack
> > > [<0>] inode_dio_wait+0xd5/0x100
> > > [<0>] ext4_fallocate+0x12f/0x1040
> > > [<0>] vfs_fallocate+0x135/0x360
> > > [<0>] __x64_sys_fallocate+0x42/0x70
> > > [<0>] do_syscall_64+0x38/0x80
> > > [<0>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >
> > This stack trace is from some process (presumably postgres) trying to
> > do a fallocate() system call:
> 
> Yes, it's indeed postgres.
> 
> 
> > > [ 3194.579297] INFO: task iou-wrk-58004:58874 blocked for more than 122 seconds.
> > > [ 3194.579304]       Not tainted 6.6.0-rc6-andres-00001-g01edcfe38260 #77
> > > [ 3194.579310] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > [ 3194.579314] task:iou-wrk-58004   state:D stack:0     pid:58874 ppid:52606  flags:0x00004000
> > > [ 3194.579325] Call Trace:
> > > [ 3194.579329]  <TASK>
> > > [ 3194.579334]  __schedule+0x388/0x13e0
> > > [ 3194.579349]  schedule+0x5f/0xe0
> > > [ 3194.579361]  schedule_preempt_disabled+0x15/0x20
> > > [ 3194.579374]  rwsem_down_read_slowpath+0x26e/0x4c0
> > > [ 3194.579385]  down_read+0x44/0xa0
> > > [ 3194.579393]  ext4_file_write_iter+0x432/0xa80
> > > [ 3194.579407]  io_write+0x129/0x420
> >
> > This could potentially be a interesting stack trace; but this is where
> > we really need to map the stack address to line numbers.  Is that
> > something you could do?
> 
> Converting the above with scripts/decode_stacktrace.sh yields:
> 
> __schedule (kernel/sched/core.c:5382 kernel/sched/core.c:6695)
> schedule (./arch/x86/include/asm/preempt.h:85 (discriminator 13) kernel/sched/core.c:6772 (discriminator 13))
> schedule_preempt_disabled (./arch/x86/include/asm/preempt.h:80 (discriminator 10) kernel/sched/core.c:6831 (discriminator 10))
> rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073 (discriminator 4))
> down_read (./arch/x86/include/asm/preempt.h:95 kernel/locking/rwsem.c:1257 kernel/locking/rwsem.c:1263 kernel/locking/rwsem.c:1522)
> ext4_file_write_iter (./include/linux/fs.h:1073 fs/ext4/file.c:57 fs/ext4/file.c:564 fs/ext4/file.c:715)
> io_write (./include/linux/fs.h:1956 io_uring/rw.c:926)
> 
> But I'm not sure that that stacktrace is quite right (e.g. what's
> ./include/linux/fs.h:1073 doing in this stacktrace?). But with an optimized
> build it's a bit hard to tell what's an optimization artifact and what's an
> off stack trace...
> 
> 
> I had the idea to look at the stacks (via /proc/$pid/stack) for all postgres
> processes and the associated io-uring threads, and then to deduplicate them.
> 
> 22x:
> ext4_file_write_iter (./include/linux/fs.h:1073 fs/ext4/file.c:57 fs/ext4/file.c:564 fs/ext4/file.c:715)
> io_write (./include/linux/fs.h:1956 io_uring/rw.c:926)
> io_issue_sqe (io_uring/io_uring.c:1878)
> io_wq_submit_work (io_uring/io_uring.c:1960)
> io_worker_handle_work (io_uring/io-wq.c:596)
> io_wq_worker (io_uring/io-wq.c:258 io_uring/io-wq.c:648)
> ret_from_fork (arch/x86/kernel/process.c:147)
> ret_from_fork_asm (arch/x86/entry/entry_64.S:312)

io_uring does some interesting stuff with IO completion and iomap
now - IIRC IOCB_DIO_CALLER_COMP is new 6.6-rc1 functionality. This
flag is set by io_write() to tell the iomap IO completion handler
that the caller will the IO completion, avoiding a context switch
to run the completion in a kworker thread.

It's not until the caller runs iocb->dio_complete() that
inode_dio_end() is called to drop the i_dio_count. This happens when
io_uring gets completion notification from iomap via
iocb->ki_complete(iocb, 0);

It then requires the io_uring layer to process the completion
and call iocb->dio_complete() before the inode->i_dio_count is
dropped and inode_dio_wait() will complete.

So what I suspect here is that we have a situation where the worker
that would run the completion is blocked on the inode rwsem because
this isn't a IOCB_NOWAIT IO and the fallocate call holds the rwsem
exclusive and is waiting on inode_dio_wait() to return.

Cc Jens, because I'm not sure this is actually an ext4 problem - I
can't see why XFS won't have the same issue w.r.t.
truncate/fallocate and IOCB_DIO_CALLER_COMP delaying the
inode_dio_end() until whenever the io_uring code can get around to
processing the delayed completion....

-Dave.

> 
> 8x:
> __do_sys_io_uring_enter (io_uring/io_uring.c:2553 (discriminator 1) io_uring/io_uring.c:2622 (discriminator 1) io_uring/io_uring.c:3706 (discriminator 1))
> do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> 
> 2x:
> io_wq_worker (./arch/x86/include/asm/current.h:41 (discriminator 5) io_uring/io-wq.c:668 (discriminator 5))
> ret_from_fork (arch/x86/kernel/process.c:147)
> ret_from_fork_asm (arch/x86/entry/entry_64.S:312)
> 
> 2x:
> futex_wait_queue (./arch/x86/include/asm/current.h:41 (discriminator 5) kernel/futex/waitwake.c:357 (discriminator 5))
> futex_wait (kernel/futex/waitwake.c:660)
> do_futex (kernel/futex/syscalls.c:106 (discriminator 1))
> __x64_sys_futex (kernel/futex/syscalls.c:183 kernel/futex/syscalls.c:164 kernel/futex/syscalls.c:164)
> do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> 
> 1x:
> do_epoll_wait (fs/eventpoll.c:1921 (discriminator 1) fs/eventpoll.c:2318 (discriminator 1))
> __x64_sys_epoll_wait (fs/eventpoll.c:2325)
> do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> 
> 1x:
> inode_dio_wait (./arch/x86/include/asm/atomic.h:23 ./include/linux/atomic/atomic-arch-fallback.h:444 ./include/linux/atomic/atomic-instrumented.h:33 fs/inode.c:2429 fs/inode.c:2446)
> ext4_fallocate (fs/ext4/extents.c:4752)
> vfs_fallocate (fs/open.c:324)
> __x64_sys_fallocate (./include/linux/file.h:45 fs/open.c:348 fs/open.c:355 fs/open.c:353 fs/open.c:353)
> do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> 
> 
> 
> 
> > > Once I hear that you don't want me to test something out on the running
> > > system, I think a sensible next step could be to compile with lockdep and see
> > > if that finds a problem?
> >
> > That's certainly a possibiity.  But also please make sure that you can
> > compile with with debugging information enabled so that we can get
> > reliable line numbers.  I use:
> >
> > CONFIG_DEBUG_INFO=y
> > CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
> > CONFIG_DEBUG_INFO_REDUCED=y
> 
> The kernel from above had debug info enabled, albeit forced to dwarf4 (IIRC I
> ran into issues with pahole not understanding all of dwarf5):
> 
> $ zgrep DEBUG_INFO /proc/config.gz
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_INFO_NONE is not set
> # CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
> CONFIG_DEBUG_INFO_DWARF4=y
> # CONFIG_DEBUG_INFO_DWARF5 is not set
> # CONFIG_DEBUG_INFO_REDUCED is not set
> CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
> # CONFIG_DEBUG_INFO_COMPRESSED_ZLIB is not set
> # CONFIG_DEBUG_INFO_COMPRESSED_ZSTD is not set
> # CONFIG_DEBUG_INFO_SPLIT is not set
> CONFIG_DEBUG_INFO_BTF=y
> CONFIG_DEBUG_INFO_BTF_MODULES=y
> 
> I switched it to CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y and am rebuilding
> with lockdep enabled. Curious to see how long it'll take to trigger the
> problem with it enabled...
> 
> Greetings,
> 
> Andres Freund
> 

-- 
Dave Chinner
david@fromorbit.com
