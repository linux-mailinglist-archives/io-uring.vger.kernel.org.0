Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14233710FE
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 06:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhECEmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 00:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhECEmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 00:42:42 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E56C06174A;
        Sun,  2 May 2021 21:41:48 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2so6237393lft.4;
        Sun, 02 May 2021 21:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qo2BsYbsMhgjSCd6k5aYFeXWyFkz8QXbNT/3uoIXeFM=;
        b=gjRF6T5NJ65eN0A5IEdIL3N8xOOk+JePSpak4E+pxJKEa5Bq7CY9N7Pk5opQrpmd5R
         O1mgcaatULcYYzb+QpzwU0Hpt/wzSla/bqcetXHBniIKp+B39/obcuw4R9eaw0K72Gll
         RnWBTpTgVDPGGfA7ABprmQkyI7I8qT2T16zAYD1KAKvqpKU07AsPscCGe0ToM/pmLxso
         l+kbYNdV6Z59SzTLUOBHYM8bFH5pMXhVBDqJ1WcO4vuHjSmNCZsVrv4mpAkyz64Fcv5m
         2FDWoC4u2S9QiCo89EQNZyYc2SI+QyNoJkvZ/vAjxXiC0MjLySVImj42IL5oIxI7bsgS
         bvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qo2BsYbsMhgjSCd6k5aYFeXWyFkz8QXbNT/3uoIXeFM=;
        b=iZNfk/Eq0ViGrWHswDCRpyYP9jDGpFopSTlFLbHIcBs27g5wnyb2xcpyhYw5qOvHky
         RoDT33HAjJNGhLti5u8LatEgVFMoDUqoxrBSSfmt1WJGalTVl1BcJsiTXBcSd7WC3cnU
         vK1b/APo6t01QJAgXoLUFEalALjGHsb84ZVHQ5N9g0LCA3iwQP8Zs++hG1D7NcqwpuX7
         pLzcMvX+ys2EfQqxby16OJpA7x48q2JtFsTP1GSEIHQGO7R146IBWTsOHCLRSeBjxD1H
         mkUPtrgvh7OCyqEaWYHto5jHmBCOs2tPoTDqgWHNLSdbn/oIta38uTohPhi2gqSZyvi3
         V37Q==
X-Gm-Message-State: AOAM530irg/hCXtG14em79q/xdNYDXkYoT2f8V8c5VJZSJdQ39xGq26U
        pX8pw9MZfC9pVUPoosVxbekUN0NbDnhncnaEnb0=
X-Google-Smtp-Source: ABdhPJxpawZ91RWcoeAfOt+phHtMS8jxBcBB1mAJWcSD/YQZminjIEt4r4QBTT/qcrn8KWiKKn9BU6wSlPLNghdYZUc=
X-Received: by 2002:ac2:50c2:: with SMTP id h2mr3872158lfm.499.1620016907066;
 Sun, 02 May 2021 21:41:47 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000c97e505bdd1d60e@google.com> <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com> <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <d5844c03-fa61-d256-be0d-b40446414299@gmail.com>
In-Reply-To: <d5844c03-fa61-d256-be0d-b40446414299@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Mon, 3 May 2021 10:11:35 +0530
Message-ID: <CAGyP=7e-3QtS-Z3KoAyFAbvm4y+9=725WR_+PyADYDi8HYxMXA@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 3:42 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 4/30/21 3:21 PM, Palash Oswal wrote:
> > On Thursday, March 18, 2021 at 9:40:21 PM UTC+5:30 syzbot wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit: 0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> >> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=12dde5aed00000
> >> kernel config: https://syzkaller.appspot.com/x/.config?x=81c0b708b31626cc
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=11bf59db879676f59e52
> >> userspace arch: riscv64
> >> CC: [asml.s...@gmail.com ax...@kernel.dk io-u...@vger.kernel.org linux-...@vger.kernel.org]
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+11bf59...@syzkaller.appspotmail.com
> >>
> >> INFO: task iou-sqp-4867:4871 blocked for more than 430 seconds.
> >> Not tainted 5.12.0-rc2-syzkaller-00467-g0d7588ab9ef9 #0
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> task:iou-sqp-4867 state:D stack: 0 pid: 4871 ppid: 4259 flags:0x00000004
> >> Call Trace:
> >> [<ffffffe003bc3252>] context_switch kernel/sched/core.c:4324 [inline]
> >> [<ffffffe003bc3252>] __schedule+0x478/0xdec kernel/sched/core.c:5075
> >> [<ffffffe003bc3c2a>] schedule+0x64/0x166 kernel/sched/core.c:5154
> >> [<ffffffe0004b80ee>] io_uring_cancel_sqpoll+0x1de/0x294 fs/io_uring.c:8858
> >> [<ffffffe0004c19cc>] io_sq_thread+0x548/0xe58 fs/io_uring.c:6750
> >> [<ffffffe000005570>] ret_from_exception+0x0/0x14
>
> The test might be very useful. Would you send a patch to
> liburing? Or mind the repro being taken as a test?
>
>

Pavel,

I'm working on a PR for liburing with this test. Do you know how I can
address this behavior?

root@syzkaller:~/liburing/test# ./runtests.sh sqpoll-cancel-hang
Running test sqp[   15.310997] Running test sqpoll-cancel-hang:
oll-cancel-hang:
[   15.333348] sqpoll-cancel-h[305]: segfault at 0 ip 000055ad00e265e3 sp]
[   15.334940] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03 46
All tests passed

root@syzkaller:~/liburing/test# ./sqpoll-cancel-hang
[   13.572639] sqpoll-cancel-h[298]: segfault at 0 ip 00005634c4a455e3 sp]
[   13.576506] Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03 46
[   23.350459] random: crng init done
[   23.352837] random: 7 urandom warning(s) missed due to ratelimiting
[  243.090865] INFO: task iou-sqp-298:299 blocked for more than 120 secon.
[  243.095187]       Not tainted 5.12.0 #142
[  243.099800] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable.
[  243.105928] task:iou-sqp-298     state:D stack:    0 pid:  299 ppid:  4
[  243.111044] Call Trace:
[  243.112855]  __schedule+0xb1d/0x1130
[  243.115549]  ? __sched_text_start+0x8/0x8
[  243.118328]  ? io_wq_worker_sleeping+0x145/0x500
[  243.121790]  schedule+0x131/0x1c0
[  243.123698]  io_uring_cancel_sqpoll+0x288/0x350
[  243.125977]  ? io_sq_thread_unpark+0xd0/0xd0
[  243.128966]  ? mutex_lock+0xbb/0x130
[  243.132572]  ? init_wait_entry+0xe0/0xe0
[  243.135429]  ? wait_for_completion_killable_timeout+0x20/0x20
[  243.138303]  io_sq_thread+0x174c/0x18c0
[  243.140162]  ? io_rsrc_put_work+0x380/0x380
[  243.141613]  ? init_wait_entry+0xe0/0xe0
[  243.143686]  ? _raw_spin_lock_irq+0xa5/0x180
[  243.145619]  ? _raw_spin_lock_irqsave+0x190/0x190
[  243.147671]  ? calculate_sigpending+0x6b/0xa0
[  243.149036]  ? io_rsrc_put_work+0x380/0x380
[  243.150694]  ret_from_fork+0x22/0x30

Palash
