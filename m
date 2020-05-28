Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6275A1E6935
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 20:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405743AbgE1SUw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 14:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405733AbgE1SUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 14:20:51 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DFCC08C5C6;
        Thu, 28 May 2020 11:20:50 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id o5so31081045iow.8;
        Thu, 28 May 2020 11:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=G+yj2HNxlB+MWzsxwnefhWDIuMOJPqCPvnYrTA2UP74=;
        b=gQ6SZyTuCCL92j3EnwabuwoHWaegMI/DNBHghuCxDt1/TMxewtH2VJiIZSBTBtAHmU
         cch7+RnrPUUpy1GkDPxyAHW0B4wK/hFD95V2MxkzDrRvFzXATbGpJzMk6jWU3gzEdILn
         QK0IU2GzJtOUIQvG7M7n0iZGqZC8HmsG2OpA/o6a9kzuVARaEuejU2mH9MxfXX5lxOGI
         NGevO4m2f8soBGDlQM+Unks6RjISfJTHh1KDUp84WZaHJinvLJOj+faLn5jfO9koTYd3
         zQRLJbZ1RsyjGfZiYKrOhs67fhJGEeTtUUfCjr3LtgN5LrDSlpUfsmRMtGxomQU4EVO3
         FT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=G+yj2HNxlB+MWzsxwnefhWDIuMOJPqCPvnYrTA2UP74=;
        b=K+Z7tu/eVkf7e3xI52A6+6Zps9t6x9cZ808HSz6xyF+bv9Rk/kP7mLAu9HWF6zVuyG
         dW+WOG4oKz0G0OjbTeLaAKVoXZhhroYjI2Risn3KEMEUvZfG81q2S2gDboBnAZvw5BAA
         Mkq1nIOQAy/J2ufZPvAUot/8cZcEFQevMcklRm5O+vT0rJbeQs+oAm4eX+B08X7gpY2Z
         J1lnoMZ25zY2ZbE4RocHoB+xR38ijxrA5NKvugZYndYe8jupmJBS92cZCrpfbWOfdcO1
         goS4o9x3hvmlZGgqci4CvNJblvVw64bCc4v22Vr36NniD6fY9NQwq4a9QO800gm1cxmQ
         Rh/A==
X-Gm-Message-State: AOAM532HfyGarl+Jx1tA5zpFAXOLHBWaL28zmGzXU6nClj+3hpU/tn5K
        YXhhFz8yeiGE0Dc8yrdIMvJIjdQf3Uy3F6+wS6NKb1XMwZg=
X-Google-Smtp-Source: ABdhPJytFm8GbsQY0HyRBAyEhNefgJfBXiHUoOeNvKTblmCf3RGMIIVmTCyiLN34onpzEN4yBSv0s5KanGgds8hh0TA=
X-Received: by 2002:a02:ca18:: with SMTP id i24mr3767660jak.70.1590690049510;
 Thu, 28 May 2020 11:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUWbGGXRaRt1yyXiFXR5y0NkMxzkWdnVrmADCbAajSdEmw@mail.gmail.com>
 <fd169130-6ac4-f135-d85f-56daa25c8c9f@kernel.dk>
In-Reply-To: <fd169130-6ac4-f135-d85f-56daa25c8c9f@kernel.dk>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 28 May 2020 20:20:50 +0200
Message-ID: <CA+icZUUnXYO9qX3PJTs=jJXT_1F_d8x5oUfuxkR_mViyfkFDOQ@mail.gmail.com>
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 28, 2020 at 7:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/28/20 11:12 AM, Sedat Dilek wrote:
> > On Thu, May 28, 2020 at 7:06 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 5/28/20 11:02 AM, Sedat Dilek wrote:
> >>> On Tue, May 26, 2020 at 10:59 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> We technically support this already through io_uring, but it's
> >>>> implemented with a thread backend to support cases where we would
> >>>> block. This isn't ideal.
> >>>>
> >>>> After a few prep patches, the core of this patchset is adding support
> >>>> for async callbacks on page unlock. With this primitive, we can simply
> >>>> retry the IO operation. With io_uring, this works a lot like poll based
> >>>> retry for files that support it. If a page is currently locked and
> >>>> needed, -EIOCBQUEUED is returned with a callback armed. The callers
> >>>> callback is responsible for restarting the operation.
> >>>>
> >>>> With this callback primitive, we can add support for
> >>>> generic_file_buffered_read(), which is what most file systems end up
> >>>> using for buffered reads. XFS/ext4/btrfs/bdev is wired up, but probably
> >>>> trivial to add more.
> >>>>
> >>>> The file flags support for this by setting FMODE_BUF_RASYNC, similar
> >>>> to what we do for FMODE_NOWAIT. Open to suggestions here if this is
> >>>> the preferred method or not.
> >>>>
> >>>> In terms of results, I wrote a small test app that randomly reads 4G
> >>>> of data in 4K chunks from a file hosted by ext4. The app uses a queue
> >>>> depth of 32. If you want to test yourself, you can just use buffered=1
> >>>> with ioengine=io_uring with fio. No application changes are needed to
> >>>> use the more optimized buffered async read.
> >>>>
> >>>> preadv for comparison:
> >>>>         real    1m13.821s
> >>>>         user    0m0.558s
> >>>>         sys     0m11.125s
> >>>>         CPU     ~13%
> >>>>
> >>>> Mainline:
> >>>>         real    0m12.054s
> >>>>         user    0m0.111s
> >>>>         sys     0m5.659s
> >>>>         CPU     ~32% + ~50% == ~82%
> >>>>
> >>>> This patchset:
> >>>>         real    0m9.283s
> >>>>         user    0m0.147s
> >>>>         sys     0m4.619s
> >>>>         CPU     ~52%
> >>>>
> >>>> The CPU numbers are just a rough estimate. For the mainline io_uring
> >>>> run, this includes the app itself and all the threads doing IO on its
> >>>> behalf (32% for the app, ~1.6% per worker and 32 of them). Context
> >>>> switch rate is much smaller with the patchset, since we only have the
> >>>> one task performing IO.
> >>>>
> >>>> Also ran a simple fio based test case, varying the queue depth from 1
> >>>> to 16, doubling every time:
> >>>>
> >>>> [buf-test]
> >>>> filename=/data/file
> >>>> direct=0
> >>>> ioengine=io_uring
> >>>> norandommap
> >>>> rw=randread
> >>>> bs=4k
> >>>> iodepth=${QD}
> >>>> randseed=89
> >>>> runtime=10s
> >>>>
> >>>> QD/Test         Patchset IOPS           Mainline IOPS
> >>>> 1               9046                    8294
> >>>> 2               19.8k                   18.9k
> >>>> 4               39.2k                   28.5k
> >>>> 8               64.4k                   31.4k
> >>>> 16              65.7k                   37.8k
> >>>>
> >>>> Outside of my usual environment, so this is just running on a virtualized
> >>>> NVMe device in qemu, using ext4 as the file system. NVMe isn't very
> >>>> efficient virtualized, so we run out of steam at ~65K which is why we
> >>>> flatline on the patched side (nvme_submit_cmd() eats ~75% of the test app
> >>>> CPU). Before that happens, it's a linear increase. Not shown is context
> >>>> switch rate, which is massively lower with the new code. The old thread
> >>>> offload adds a blocking thread per pending IO, so context rate quickly
> >>>> goes through the roof.
> >>>>
> >>>> The goal here is efficiency. Async thread offload adds latency, and
> >>>> it also adds noticable overhead on items such as adding pages to the
> >>>> page cache. By allowing proper async buffered read support, we don't
> >>>> have X threads hammering on the same inode page cache, we have just
> >>>> the single app actually doing IO.
> >>>>
> >>>> Been beating on this and it's solid for me, and I'm now pretty happy
> >>>> with how it all turned out. Not aware of any missing bits/pieces or
> >>>> code cleanups that need doing.
> >>>>
> >>>> Series can also be found here:
> >>>>
> >>>> https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.5
> >>>>
> >>>> or pull from:
> >>>>
> >>>> git://git.kernel.dk/linux-block async-buffered.5
> >>>>
> >>>
> >>> Hi Jens,
> >>>
> >>> I have pulled linux-block.git#async-buffered.5 on top of Linux v5.7-rc7.
> >>>
> >>> From first feelings:
> >>> The booting into the system (until sddm display-login-manager) took a
> >>> bit longer.
> >>> The same after login and booting into KDE/Plasma.
> >>
> >> There is no difference for "regular" use cases, only io_uring with
> >> buffered reads will behave differently. So I don't think you have longer
> >> boot times due to this.
> >>
> >>> I am building/linking with LLVM/Clang/LLD v10.0.1-rc1 on Debian/testing AMD64.
> >>>
> >>> Here I have an internal HDD (SATA) and my Debian-system is on an
> >>> external HDD connected via USB-3.0.
> >>> Primarily, I use Ext4-FS.
> >>>
> >>> As said above is the "emotional" side, but I need some technical instructions.
> >>>
> >>> How can I see Async Buffer Reads is active on a Ext4-FS-formatted partition?
> >>
> >> You can't see that. It'll always be available on ext4 with this series,
> >> and you can watch io_uring instances to see if anyone is using it.
> >>
> >
> > Thanks for answering my questions.
> >
> > How can I "watch io_uring instances"?
>
> You can enable io_uring tracing:
>
> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/io_uring_create/enable
> # tail /sys/kernel/debug/tracing/trace
>
> and see if you get any events for setup. Generally you can also look for
> the existence of io_wq_manager processes, these will exist for an
> io_uring instance.
>
> > FIO?
> > Debian has fio version 3.19-2 in its apt repositories.
> > Version OK?
>
> Yeah that should work.
>

I did:

# echo 1 > /sys/kernel/debug/tracing/events/io_uring/io_uring_create/enable
# cat /sys/kernel/debug/tracing/events/io_uring/io_uring_create/enable
1

# cat ./buf-test-dileks-min
[buf-test-dileks-min]
filename=/path/to/iso-image-file
buffered=1
ioengine=io_uring

# fio --showcmd ./buf-test-dileks-min
fio --name=buf-test-dileks-min --buffered=1 --ioengine=io_uring
--filename=filename=/path/to/iso-image-file

# fio ./buf-test-dileks-min

# ps -ef | egrep 'f[i]o|i[o]_wq'
root        6695    6066 24 20:13 pts/2    00:00:00 fio ./buf-test-dileks-min
root        6701    6695 22 20:13 ?        00:00:00 fio ./buf-test-dileks-min
root        6702       2  0 20:13 ?        00:00:00 [io_wq_manager]
root        6703       2  0 20:13 ?        00:00:00 [io_wqe_worker-0]

# LC_ALL=C tail -f /sys/kernel/debug/tracing/trace
...
# entries-in-buffer/entries-written: 16/16   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
...
             fio-6701  [001] ....  6775.117015: io_uring_create: ring
00000000ef052188, fd 5 sq size 1, cq size 2, flags 0

Looks like this works.

Thanks Jens.

- Sedat -
