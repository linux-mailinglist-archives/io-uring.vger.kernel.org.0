Return-Path: <io-uring+bounces-1996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B129E8D45BF
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 09:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13378B24264
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 07:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B433DAC18;
	Thu, 30 May 2024 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vve4jgoB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EC13DAC15;
	Thu, 30 May 2024 07:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717052838; cv=none; b=ECxOkycfTyikxoNm5bIoNudqNThgPDcECDv99bEH6yKiVDI5LtTv4cdLAYaqQGh/UmZlfDpyTIadXIOmyhTvU7LMz63g3GKxoQCC2auJO0tfNI4AHR0/XRtavP8aGFQaTsflVdSKU+jhPdQ+KSSBoHAhuWahdJxXgRC23f8Am7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717052838; c=relaxed/simple;
	bh=irwK6RXR5/05uj4nCr9bvcDr2hVyQVL8DLWyT3HVadU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JqcS5gTuRD/GZdIBkfmp9Cs8pzxX62x+JcBpjPcwI0NXCEI5p514qMce/zEwD4pcXWp2UTpe8eor3vpzBRle+Zudof/YGjxTcz5ALKaxLE/oDYJNesrmXC/uNLvxXpN77qf62NilT69FYUwPOmC/TWbSEjVq7ZWzaNgi+g7WOdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vve4jgoB; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-dfa46cedc5aso495663276.0;
        Thu, 30 May 2024 00:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717052835; x=1717657635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eK89R1a10KXaZlXiRp3RYmDCezJsnnWejIw7FUe/BKQ=;
        b=Vve4jgoBixnzVNpQxKEgAwCk6eBnuRYM69jfo6OAEP8hYwZQHY0na63A7IpbdbJmJ+
         vEl5GlXqvkoi1WioUR6N0MVwLWW/4reTl7iov7QCTOpPu/TBfOC9gq9AmIxP8ZFB1SYA
         Ek35xWaqgwOdF2rTXtzW7d4ngsT0Be9wHurdXK0I6qQRqFhun29LnA3gLe3PrRavvNhQ
         hkwBdmikQA26FvuycYDD9dC2+whfNYasdYJDUxWaP/QJVc/D8+wjXxCNIjrBrmK8+t5i
         37aSojyNDn5gQn86SFj0yu9u9skG1VW8QMcnQdJcvipUn3reYHivl+z3uCs73rGCgxO1
         Up+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717052835; x=1717657635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eK89R1a10KXaZlXiRp3RYmDCezJsnnWejIw7FUe/BKQ=;
        b=GbubR1s5kdaYheyib7oqNN0lrsMWi29g0nZeuCTxrwf4GV/HL9QGzVaaNpjwSz80rl
         eYd7HpCQleR5M6NZAf5k4ie/IeCSSQ3qzcqFTMQH6dtNJnzz6U0fFigkewKXMQJ0JoZ+
         NO7spi1WjMaO59HpMl+TiXlM2w1HStpkW0vfBwg+lmBbjhh3bx2K64u42C7h24jzKppd
         tRvfZi4dQ7u5N/+CltvfubLoclnVtVLo9b3gG3qXi98WL0Eu2Fmy6d84CwjHCfrDB6+q
         NzKiNeYgJ8xMFBk4lSeoH+KXu/B0HH9SXORmvTAEuC7vI2OB0DcroF9vUvfBbvLE596S
         NB1g==
X-Forwarded-Encrypted: i=1; AJvYcCWOjXA7AC+uUdDev9aB9CSvufV2yDVlmI1a1ZsSd8gyFj8zCQT8IJVHmOSzUodLJThlfO8x9qeOiEw26vYyp4DGJ8wu4ml4UuJNZWDN6TRNOn1AJaBswHEi8FTZ/XfvdIHsibV3C5bd
X-Gm-Message-State: AOJu0YzTXuhCp6uXbsCVg60/wRNC95yYvrR6PvM19f8cAnVHWNSuikeD
	ijqwOUh5ZqgdqVBjb0P69rT1/naVccOztSqM7rW77e1xdHNgbQK7Pt0Nq4Ed3EzBOaG8kZO7jbe
	dWab3Wc+631Jnt4+NtFYrFGniDqYnCkpO
X-Google-Smtp-Source: AGHT+IHmyG+8VCkRkeTpo+vYeetBzpXpaz2qupLpu11qXJFBUjAbUuH+5iB3CGLHbynm0kTloExXxM9MiDqhCECN/3g=
X-Received: by 2002:a25:8306:0:b0:df4:d29a:6897 with SMTP id
 3f1490d57ef6-dfa5a618102mr1288629276.35.1717052835418; Thu, 30 May 2024
 00:07:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
In-Reply-To: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 30 May 2024 10:07:03 +0300
Message-ID: <CAOQ4uxjsjrmHHXd8B5xaBjfPZTZtHrFsNUmAmjBVMK3+t9aR1w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	bernd.schubert@fastmail.fm, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024 at 9:01=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> From: Bernd Schubert <bschubert@ddn.com>
>
> This adds support for uring communication between kernel and
> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
> appraoch was taken from ublk.  The patches are in RFC state,
> some major changes are still to be expected.
>
> Motivation for these patches is all to increase fuse performance.
> In fuse-over-io-uring requests avoid core switching (application
> on core X, processing of fuse server on random core Y) and use
> shared memory between kernel and userspace to transfer data.
> Similar approaches have been taken by ZUFS and FUSE2, though
> not over io-uring, but through ioctl IOs
>
> https://lwn.net/Articles/756625/
> https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=
=3Dfuse2
>
> Avoiding cache line bouncing / numa systems was discussed
> between Amir and Miklos before and Miklos had posted
> part of the private discussion here
> https://lore.kernel.org/linux-fsdevel/CAJfpegtL3NXPNgK1kuJR8kLu3WkVC_ErBP=
RfToLEiA_0=3Dw3=3DhA@mail.gmail.com/
>
> This cache line bouncing should be addressed by these patches
> as well.
>
> I had also noticed waitq wake-up latencies in fuse before
> https://lore.kernel.org/lkml/9326bb76-680f-05f6-6f78-df6170afaa2c@fastmai=
l.fm/T/
>
> This spinning approach helped with performance (>40% improvement
> for file creates), but due to random server side thread/core utilization
> spinning cannot be well controlled in /dev/fuse mode.
> With fuse-over-io-uring requests are handled on the same core
> (sync requests) or on core+1 (large async requests) and performance
> improvements are achieved without spinning.
>
> Splice/zero-copy is not supported yet, Ming Lei is working
> on io-uring support for ublk_drv, but I think so far there
> is no final agreement on the approach to be taken yet.
> Fuse-over-io-uring runs significantly faster than reads/writes
> over /dev/fuse, even with splice enabled, so missing zc
> should not be a blocking issue.
>
> The patches have been tested with multiple xfstest runs in a VM
> (32 cores) with a kernel that has several debug options
> enabled (like KASAN and MSAN).
> For some tests xfstests reports that O_DIRECT is not supported,
> I need to investigate that. Interesting part is that exactly
> these tests fail in plain /dev/fuse posix mode. I had to disabled
> generic/650, which is enabling/disabling cpu cores - given ring
> threads are bound to cores issues with that are no totally
> unexpected, but then there (scheduler) kernel messages that
> core binding for these threads is removed - this needs
> to be further investigates.
> Nice effect in io-uring mode is that tests run faster (like
> generic/522 ~2400s /dev/fuse vs. ~1600s patched), though still
> slow as this is with ASAN/leak-detection/etc.
>
> The corresponding libfuse patches are on my uring branch,
> but need cleanup for submission - will happen during the next
> days.
> https://github.com/bsbernd/libfuse/tree/uring
>
> If it should make review easier, patches posted here are on
> this branch
> https://github.com/bsbernd/linux/tree/fuse-uring-for-6.9-rfc2
>
> TODO list for next RFC versions
> - Let the ring configure ioctl return information, like mmap/queue-buf si=
ze
> - Request kernel side address and len for a request - avoid calculation i=
n userspace?
> - multiple IO sizes per queue (avoiding a calculation in userspace is pro=
bably even
>   more important)
> - FUSE_INTERRUPT handling?
> - Logging (adds fields in the ioctl and also ring-request),
>   any mismatch between client and server is currently very hard to unders=
tand
>   through error codes
>
> Future work
> - notifications, probably on their own ring
> - zero copy
>
> I had run quite some benchmarks with linux-6.2 before LSFMMBPF2023,
> which, resulted in some tuning patches (at the end of the
> patch series).
>
> Some benchmark results
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> System used for the benchmark is a 32 core (HyperThreading enabled)
> Xeon E5-2650 system. I don't have local disks attached that could do
> >5GB/s IOs, for paged and dio results a patched version of passthrough-hp
> was used that bypasses final reads/writes.
>
> paged reads
> -----------
>             128K IO size                      1024K IO size
> jobs   /dev/fuse     uring    gain     /dev/fuse    uring   gain
>  1        1117        1921    1.72        1902       1942   1.02
>  2        2502        3527    1.41        3066       3260   1.06
>  4        5052        6125    1.21        5994       6097   1.02
>  8        6273       10855    1.73        7101      10491   1.48
> 16        6373       11320    1.78        7660      11419   1.49
> 24        6111        9015    1.48        7600       9029   1.19
> 32        5725        7968    1.39        6986       7961   1.14
>
> dio reads (1024K)
> -----------------
>
> jobs   /dev/fuse  uring   gain
> 1           2023   3998   2.42
> 2           3375   7950   2.83
> 4           3823   15022  3.58
> 8           7796   22591  2.77
> 16          8520   27864  3.27
> 24          8361   20617  2.55
> 32          8717   12971  1.55
>
> mmap reads (4K)
> ---------------
> (sequential, I probably should have made it random, sequential exposes
> a rather interesting/weird 'optimized' memcpy issue - sequential becomes
> reversed order 4K read)
> https://lore.kernel.org/linux-fsdevel/aae918da-833f-7ec5-ac8a-115d66d80d0=
e@fastmail.fm/
>
> jobs  /dev/fuse     uring    gain
> 1       130          323     2.49
> 2       219          538     2.46
> 4       503         1040     2.07
> 8       1472        2039     1.38
> 16      2191        3518     1.61
> 24      2453        4561     1.86
> 32      2178        5628     2.58
>
> (Results on request, setting MAP_HUGETLB much improves performance
> for both, io-uring mode then has a slight advantage only.)
>
> creates/s
> ----------
> threads /dev/fuse     uring   gain
> 1          3944       10121   2.57
> 2          8580       24524   2.86
> 4         16628       44426   2.67
> 8         46746       56716   1.21
> 16        79740      102966   1.29
> 20        80284      119502   1.49
>
> (the gain drop with >=3D8 cores needs to be investigated)

Hi Bernd,

Those are impressive results!

When approaching the FUSE uring feature from marketing POV,
I think that putting the emphasis on metadata operations is the
best approach.

Not the dio reads are not important (I know that is part of your use case),
but I imagine there are a lot more people out there waiting for
improvement in metadata operations overhead.

To me it helps to know what the current main pain points are
for people using FUSE filesystems wrt performance.

Although it may not be uptodate, the most comprehensive
study about FUSE performance overhead is this FAST17 paper:

https://www.usenix.org/system/files/conference/fast17/fast17-vangoor.pdf

In this paper, table 3 summarizes the different overheads observed
per workload. According to this table, the workloads that degrade
performance worse on an optimized passthrough fs over SSD are:
- many file creates
- many file deletes
- many small file reads
In all these workloads, it was millions of files over many directories.
The highest performance regression reported was -83% on many
small file creations.

The moral of this long story is that it would be nice to know
what performance improvement FUSE uring can aspire to.
This is especially relevant for people that would be interested
in combining the benefits of FUSE passthrough (for data) and
FUSE uring (for metadata).

What did passthrough_hp do in your patched version with creates?
Did it actually create the files?
In how many directories?
Maybe the directory inode lock impeded performance improvement
with >=3D8 threads?

>
> Remaining TODO list for RFCv3:
> --------------------------------
> 1) Let the ring configure ioctl return information,
> like mmap/queue-buf size
>
> Right now libfuse and kernel have lots of duplicated setup code
> and any kind of pointer/offset mismatch results in a non-working
> ring that is hard to debug - probably better when the kernel does
> the calculations and returns that to server side
>
> 2) In combination with 1, ring requests should retrieve their
> userspace address and length from kernel side instead of
> calculating it through the mmaped queue buffer on their own.
> (Introduction of FUSE_URING_BUF_ADDR_FETCH)
>
> 3) Add log buffer into the ioctl and ring-request
>
> This is to provide better error messages (instead of just
> errno)
>
> 3) Multiple IO sizes per queue
>
> Small IOs and metadata requests do not need large buffer sizes,
> we need multiple IO sizes per queue.
>
> 4) FUSE_INTERRUPT handling
>
> These are not handled yet, kernel side is probably not difficult
> anymore as ring entries take fuse requests through lists.
>
> Long term TODO:
> --------------
> Notifications through io-uring, maybe with a separated ring,
> but I'm not sure yet.

Is that going to improve performance in any real life workload?

Thanks,
Amir.

>
> Changes since RFCv1
> -------------------
> - No need to hold the task of the server side anymore.  Also no
>   ioctls/threads waiting for shutdown anymore.  Shutdown now more
>   works like the traditional fuse way.
> - Each queue clones the fuse and device release makes an  exception
>   for io-uring. Reason is that queued IORING_OP_URING_CMD
>   (through .uring_cmd) prevent a device release. I.e. a killed
>   server side typically triggers fuse_abort_conn(). This was the
>   reason for the async stop-monitor in v1 and reference on the daemon
>   task. However it was very racy and annotated immediately by Miklos.
> - In v1 the offset parameter to mmap was identifying the QID, in v2
>   server side is expected to send mmap from a core bound ring thread
>   in numa mode and numa node is taken through the core of that thread.
>   Kernel side of the mmap buffer is stored in an rbtree and assigned
>   to the right qid through an additional queue ioctl.
> - Release of IORING_OP_URING_CMD is done through lists now, instead
>   of iterating over the entire array of queues/entries and does not
>   depend on the entry state anymore (a bit of the state is still left
>   for sanity check).
> - Finding free ring queue entries is done through lists and not through
>   a bitmap anymore
> - Many other code changes and bug fixes
> - Performance tunings
>
> ---
> Bernd Schubert (19):
>       fuse: rename to fuse_dev_end_requests and make non-static
>       fuse: Move fuse_get_dev to header file
>       fuse: Move request bits
>       fuse: Add fuse-io-uring design documentation
>       fuse: Add a uring config ioctl
>       Add a vmalloc_node_user function
>       fuse uring: Add an mmap method
>       fuse: Add the queue configuration ioctl
>       fuse: {uring} Add a dev_release exception for fuse-over-io-uring
>       fuse: {uring} Handle SQEs - register commands
>       fuse: Add support to copy from/to the ring buffer
>       fuse: {uring} Add uring sqe commit and fetch support
>       fuse: {uring} Handle uring shutdown
>       fuse: {uring} Allow to queue to the ring
>       export __wake_on_current_cpu
>       fuse: {uring} Wake requests on the the current cpu
>       fuse: {uring} Send async requests to qid of core + 1
>       fuse: {uring} Set a min cpu offset io-size for reads/writes
>       fuse: {uring} Optimize async sends
>
>  Documentation/filesystems/fuse-io-uring.rst |  167 ++++
>  fs/fuse/Kconfig                             |   12 +
>  fs/fuse/Makefile                            |    1 +
>  fs/fuse/dev.c                               |  310 +++++--
>  fs/fuse/dev_uring.c                         | 1232 +++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h                       |  395 +++++++++
>  fs/fuse/file.c                              |   15 +-
>  fs/fuse/fuse_dev_i.h                        |   67 ++
>  fs/fuse/fuse_i.h                            |    9 +
>  fs/fuse/inode.c                             |    3 +
>  include/linux/vmalloc.h                     |    1 +
>  include/uapi/linux/fuse.h                   |  135 +++
>  kernel/sched/wait.c                         |    1 +
>  mm/nommu.c                                  |    6 +
>  mm/vmalloc.c                                |   41 +-
>  15 files changed, 2330 insertions(+), 65 deletions(-)
> ---
> base-commit: dd5a440a31fae6e459c0d6271dddd62825505361
> change-id: 20240529-fuse-uring-for-6-9-rfc2-out-f0a009005fdf
>
> Best regards,
> --
> Bernd Schubert <bschubert@ddn.com>
>

