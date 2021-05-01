Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692723705A5
	for <lists+io-uring@lfdr.de>; Sat,  1 May 2021 06:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhEAEw5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 May 2021 00:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhEAEw5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 May 2021 00:52:57 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3720C06174A;
        Fri, 30 Apr 2021 21:52:07 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b23so188823lfv.8;
        Fri, 30 Apr 2021 21:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vrGeP9e14X9gN9RYm8/sWfyFJWljHE0tNCWuifsHvuo=;
        b=X/m27RVWBPaaK/SbKhDP2FrVnf7+h3gI7ZWisEEJ6atPEmSK53cJBlYpi5II5NtJYA
         mHuFZv0fn3xcCyV5kHymvGZ8rQjuvuXcWsftQdCNhh1pkpODTA3W8/219GiKaiHKnvtC
         d3lo4DvPH3OrPydazgpeMj6i1o/EbwYz7Ke5AV3eIOkVVM3LYmhUbkNBjrH+aJ1RIZaa
         qf3fdgyEBmJ5B2OIAPQC7Gq676eKz9Od7UrDmaIanQCuTWarSPcRfPFMxagHgfBcUeF0
         nYr7WXjOOAAt9+FeYAT3+L6MAfIfyOGH6joNuuFTgguNTCHw/nfb8sR1AyJKEiH1b8zb
         vrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vrGeP9e14X9gN9RYm8/sWfyFJWljHE0tNCWuifsHvuo=;
        b=fIFUyyZkhmtwGOsCEfa5HkzAZ97at8DNPMuabODSLARIcFlwuNCxmE00CJFTZUAYxt
         roFKLYMs8ytKM/c0asoSf8fHkXKXmvTJQCu2mLxUS1mqcGTSuqwruPMJfLtJtYDF2xJS
         KrCxSaHFTen0Hs9BjPNtr+BriIDi8np8btp+rYI51NmcLys5bTMSIkuolJ2hnuYsW3qL
         fpMc4WYtXEMCjNBicGicM+ezZhZcS6WABiGw2bm3DVgPbeykgq0fcmaBDQ9b9RWGX7ln
         82/K1jFoQtuPCsFkcYP9MKSUxO+aG3oFZF9EzQlYsNoJEEZbjToDQEh4TsK82XfBr0NW
         8bhQ==
X-Gm-Message-State: AOAM533XDlVQ7ZkM1on+jzCPUr5FWN6rg+tDEGCVo+Y9cWcVzVqox8zQ
        Mzi/hNImre+bSzu/eVWUxGlUcRv1mepkzU2kcKa+w6xoJs7G7TvW
X-Google-Smtp-Source: ABdhPJxpDnn3sVfv4xw+tsmWF7rCRSZDDdwl8bq/rtRWdjzcogtbXi9KbMTUnYU5aJ9+Mjekudz9TH2LBru6MiXPHNY=
X-Received: by 2002:a05:6512:20d0:: with SMTP id u16mr5413344lfr.391.1619844726168;
 Fri, 30 Apr 2021 21:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000000c97e505bdd1d60e@google.com> <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com> <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <a6ce21f4-04e7-f34c-8cfc-f8158f7fe163@gmail.com> <CAGyP=7czG1nmzpM5T784iBdApVL14hGoAfw-nhS=tNH5t9C79g@mail.gmail.com>
 <d350afac-eef2-c33f-e435-fe0ec7ffd1cf@gmail.com> <9a7c2040-e26f-1c59-b7e9-25784d5b854e@gmail.com>
In-Reply-To: <9a7c2040-e26f-1c59-b7e9-25784d5b854e@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Sat, 1 May 2021 10:21:55 +0530
Message-ID: <CAGyP=7dFy3t72P9GQ8a-gxO6oYojqh0PnTS0zvMGidu6Q+cNZw@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, May 1, 2021 at 2:35 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 4/30/21 7:34 PM, Pavel Begunkov wrote:
> > On 4/30/21 4:02 PM, Palash Oswal wrote:
> >> On Fri, Apr 30, 2021 at 8:03 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>>
> >>> On 4/30/21 3:21 PM, Palash Oswal wrote:
> >>>> On Thursday, March 18, 2021 at 9:40:21 PM UTC+5:30 syzbot wrote:
> >>>>>
> >>>>> Hello,
> >>>>>
> >>>>> syzbot found the following issue on:
> >>>>>
> >>>>> HEAD commit: 0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> >>>>> git tree: git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> >>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12dde5aed00000
> >>>>> kernel config: https://syzkaller.appspot.com/x/.config?x=81c0b708b31626cc
> >>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=11bf59db879676f59e52
> >>>>> userspace arch: riscv64
> >>>>> CC: [asml.s...@gmail.com ax...@kernel.dk io-u...@vger.kernel.org linux-...@vger.kernel.org]
> >>>>>
> >>>>> Unfortunately, I don't have any reproducer for this issue yet.
> >>>
> >>> There was so many fixes in 5.12 after this revision, including sqpoll
> >>> cancellation related... Can you try something more up-to-date? Like
> >>> released 5.12 or for-next
> >>>
> >>
> >> The reproducer works for 5.12.
> >>
> >> I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
> >> commit on for-next tree
> >> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
> >> and the reproducer fails.
> >
> > Can't reproduce. Does it hang as in the original's report dmesg?
> > Can you paste logs?
>
> and `uname -r` if you could


root@syzkaller:~# echo 30 > /proc/sys/kernel/hung_task_timeout_secs
root@syzkaller:~# uname -a
Linux syzkaller 5.12.0 #112 SMP Sat May 1 10:13:41 IST 2021 x86_64 GNU/Linux
root@syzkaller:~# ./repro
[   70.412424] repro[365]: segfault at 0 ip 0000556d88201005 sp
00007ffc7ddf2cd0 error 6 in repro[556d8]
[   70.417215] Code: cc 8b 75 c0 48 8b 45 e8 41 b9 00 00 00 00 41 89
d0 b9 11 80 00 00 ba 03 00 00 00 48
[  121.593305] INFO: task iou-sqp-365:366 blocked for more than 30 seconds.
[  121.594448]       Not tainted 5.12.0 #112
[  121.595072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  121.596250] task:iou-sqp-365     state:D stack:    0 pid:  366
ppid:   364 flags:0x00004004
[  121.597514] Call Trace:
[  121.598019]  __schedule+0xb1d/0x1130
[  121.598774]  ? __sched_text_start+0x8/0x8
[  121.599580]  ? io_wq_worker_sleeping+0x145/0x500
[  121.600442]  schedule+0x131/0x1c0
[  121.600902]  io_uring_cancel_sqpoll+0x288/0x350
[  121.601571]  ? io_sq_thread_unpark+0xd0/0xd0
[  121.602410]  ? mutex_lock+0xbb/0x130
[  121.603027]  ? init_wait_entry+0xe0/0xe0
[  121.603573]  ? wait_for_completion_killable_timeout+0x20/0x20
[  121.604454]  io_sq_thread+0x174c/0x18c0
[  121.605014]  ? io_rsrc_put_work+0x380/0x380
[  121.605652]  ? init_wait_entry+0xe0/0xe0
[  121.606428]  ? _raw_spin_lock_irq+0xa5/0x180
[  121.607262]  ? _raw_spin_lock_irqsave+0x190/0x190
[  121.608005]  ? calculate_sigpending+0x6b/0xa0
[  121.608636]  ? io_rsrc_put_work+0x380/0x380
[  121.609301]  ret_from_fork+0x22/0x30


root@syzkaller:~# ps
  PID TTY          TIME CMD
  294 ttyS0    00:00:00 login
  357 ttyS0    00:00:00 bash
  365 ttyS0    00:00:00 repro
  370 ttyS0    00:00:00 ps
root@syzkaller:~# kill -9 365
root@syzkaller:~# [  305.888970] INFO: task iou-sqp-365:366 blocked
for more than 215 seconds.
[  305.893275]       Not tainted 5.12.0 #112
[  305.895507] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  305.899685] task:iou-sqp-365     state:D stack:    0 pid:  366
ppid:     1 flags:0x00004004
[  305.904071] Call Trace:
[  305.905616]  __schedule+0xb1d/0x1130
[  305.907660]  ? __sched_text_start+0x8/0x8
[  305.910314]  ? io_wq_worker_sleeping+0x145/0x500
[  305.913328]  schedule+0x131/0x1c0
[  305.914562]  io_uring_cancel_sqpoll+0x288/0x350
[  305.916513]  ? io_sq_thread_unpark+0xd0/0xd0
[  305.918346]  ? mutex_lock+0xbb/0x130
[  305.919616]  ? init_wait_entry+0xe0/0xe0
[  305.920896]  ? wait_for_completion_killable_timeout+0x20/0x20
[  305.922805]  io_sq_thread+0x174c/0x18c0
[  305.923876]  ? io_rsrc_put_work+0x380/0x380
[  305.924748]  ? init_wait_entry+0xe0/0xe0
[  305.925523]  ? _raw_spin_lock_irq+0xa5/0x180
[  305.926353]  ? _raw_spin_lock_irqsave+0x190/0x190
[  305.927436]  ? calculate_sigpending+0x6b/0xa0
[  305.928266]  ? io_rsrc_put_work+0x380/0x380
[  305.929104]  ret_from_fork+0x22/0x30

The trace from my syzkaller instance:

Syzkaller hit 'INFO: task hung in io_uring_cancel_sqpoll' bug.

syz-executor198[307]: segfault at 0 ip 00000000004020f3 sp
00007ffd21853620 error 6 in syz-executor198379463[401000+96000]
Code: 89 d8 8d 34 90 8b 45 04 ba 03 00 00 00 c1 e0 04 03 45 64 39 c6
48 0f 42 f0 45 31 c9 e8 96 8a 04 00 8b 75 00 41 89 d8 4c 89 ef <49> 89
06 41 b9 00 00 00 10 b9 11 80 00 00 ba 03 00 00 00 c1 e6 06
INFO: task iou-sqp-307:308 blocked for more than 120 seconds.
      Not tainted 5.12.0 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-sqp-307     state:D stack:    0 pid:  308 ppid:   306 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4322 [inline]
 __schedule+0x75f/0xa10 kernel/sched/core.c:5073
 schedule+0xb7/0x110 kernel/sched/core.c:5152
 io_uring_cancel_sqpoll+0x1c6/0x290 fs/io_uring.c:9018
 io_sq_thread+0xf8c/0x1080 fs/io_uring.c:6836
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
