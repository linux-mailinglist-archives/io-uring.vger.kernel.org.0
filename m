Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2360624048D
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 12:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgHJKPK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 06:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgHJKPI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 06:15:08 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A043EC061786
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 03:15:07 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id j187so7756517qke.11
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 03:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oBmB3EWWRv6a5eBxGHSSBQbsq/iVBNL2r/xZBYPtbQo=;
        b=cZugscalhx+HXPkmPcPwIDtrDw/Tqc/F6cgWWI18ZiBNnDdiWCAtShLd2qmXIslxCo
         DUxBe5MFzPcg2KpIOY4Je2EbioNp1N1617GFNiqbK+ix1KuB452JQgshVFM7NqEGM/BI
         dM+OokrJZsl4y+P/7x+7NeDGP1BZf9tDYC2lZ0szQjBC6Gehq/ItpAbk2tijXCmFdQhI
         Zu7guKgD1Zw4XNmS1ygW2Ln0GPJgErsT8+5eoD0r4aUopP7PnT9q2PKynk+mHhhLPxhR
         c4hGUxBAjQhOQ8XDT/lgrMM4oEpRjOeAonFu4RmTcFnyXscMCpc06LWpCyg6sA0Ookrg
         kuxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oBmB3EWWRv6a5eBxGHSSBQbsq/iVBNL2r/xZBYPtbQo=;
        b=b6K1szRTQvAnzvvBAzJG3YSHbLeghjNsynLuDc1cKsneFQJy5pxTH7liVNuSxggoFX
         tBnrzhBvSyKD3sIiZi4QZgVZjbtPFDZyRuZKmm4tbBerW1/cTa446nDf5ILhl26D99cn
         cd70bFW45KVYR4R72or3k+GuHg1pp8FN0vJdM5frcnEkpXj4tbVaYzTVdOdyIQQ0OWLp
         P09F0pwcApOlJlzuxkmng2Ip5BZDQNIg6DUuX2Pa9vqMOEpN2jlXVy07sghj2Nn0VHMf
         yVoIMj86LU8k5xH49Hu8wWnMScep6Ij/Zdnrakiq7zKL7/cZuAq2y8OHSWlUNRkjNjEy
         CQcQ==
X-Gm-Message-State: AOAM533bsw24OHkvvVCX4q/Cc+UH2XstOrifwbhxH873R5z2hNhvY87a
        xwhXiEXsDF4tGXCZ6LvAZTk87B3ZDucjYcNRTGXdG55Fakk=
X-Google-Smtp-Source: ABdhPJz4WV3qPhqoWUHd+jmKKcy1Ie7w5QYLlZzMW0jrlzZ4lbWS1nL7W0nsnSynmrfxnBP/oTT6ABM+7cL+Hi3FaU8=
X-Received: by 2002:a05:620a:c07:: with SMTP id l7mr26181880qki.250.1597054506250;
 Mon, 10 Aug 2020 03:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000038399005ac82fef7@google.com>
In-Reply-To: <00000000000038399005ac82fef7@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 10 Aug 2020 12:14:54 +0200
Message-ID: <CACT4Y+ZczKDZHjBk1NsAP=z_6Df3tn4+Y-SDOSMhaXEEgXtXAA@mail.gmail.com>
Subject: Re: KCSAN: data-race in __io_cqring_fill_event / io_uring_poll
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Marco Elver <elver@google.com>,
        Necip Fazil Yildiran <necip@google.com>,
        syzbot <syzbot+3020eb77f81ef0772fbe@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 10, 2020 at 11:58 AM syzbot
<syzbot+3020eb77f81ef0772fbe@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    86cfccb6 Merge tag 'dlm-5.9' of git://git.kernel.org/pub/s..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=171cf11a900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3757fa75ecfde8e0
> dashboard link: https://syzkaller.appspot.com/bug?extid=3020eb77f81ef0772fbe
> compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3020eb77f81ef0772fbe@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KCSAN: data-race in __io_cqring_fill_event / io_uring_poll
>
> write to 0xffff8880a04325c0 of 4 bytes by task 12088 on cpu 1:
>  io_get_cqring fs/io_uring.c:1282 [inline]
>  __io_cqring_fill_event+0x116/0x430 fs/io_uring.c:1386
>  io_cqring_add_event fs/io_uring.c:1420 [inline]
>  __io_req_complete+0xdb/0x1b0 fs/io_uring.c:1458
>  io_complete_rw_common fs/io_uring.c:2208 [inline]
>  __io_complete_rw+0x2c9/0x2e0 fs/io_uring.c:2289
>  kiocb_done fs/io_uring.c:2533 [inline]
>  io_write fs/io_uring.c:3199 [inline]
>  io_issue_sqe+0x4fb1/0x7140 fs/io_uring.c:5530
>  io_wq_submit_work+0x23e/0x340 fs/io_uring.c:5775
>  io_worker_handle_work+0xa69/0xcf0 fs/io-wq.c:527
>  io_wqe_worker+0x1f2/0x860 fs/io-wq.c:569
>  kthread+0x20d/0x230 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> read to 0xffff8880a04325c0 of 4 bytes by task 12086 on cpu 0:
>  io_cqring_events fs/io_uring.c:1937 [inline]
>  io_uring_poll+0x105/0x140 fs/io_uring.c:7751
>  vfs_poll include/linux/poll.h:90 [inline]
>  __io_arm_poll_handler+0x176/0x3f0 fs/io_uring.c:4735
>  io_arm_poll_handler+0x293/0x5c0 fs/io_uring.c:4792
>  __io_queue_sqe+0x413/0x760 fs/io_uring.c:5988
>  io_queue_sqe+0x81/0x2b0 fs/io_uring.c:6060
>  io_submit_sqe+0x333/0x560 fs/io_uring.c:6130
>  io_submit_sqes+0x8c6/0xfc0 fs/io_uring.c:6327
>  __do_sys_io_uring_enter fs/io_uring.c:8036 [inline]
>  __se_sys_io_uring_enter+0x1c2/0x720 fs/io_uring.c:7995
>  __x64_sys_io_uring_enter+0x74/0x80 fs/io_uring.c:7995
>  do_syscall_64+0x39/0x80 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 12086 Comm: syz-executor.5 Not tainted 5.8.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> ==================================================================
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

Hi Jens,

I wonder if this read of cached_cq_tail needs READ_ONCE as all
concurrent access seems to be marked in io_uring.c overall.

I also have a concern for a potential bad scenario around
cached_cq_tail. I've seen it in other queues. I don't see that it can
happen in io_uring, but from a very brief look at the code io_uring
may be susceptible, so I thought it's better to ask.
The failure is around ordering of reads of head/tail when deciding if
the queue is empty or not.
Consider: initially queue is empty head==tail==0.
One thread adds an element and sets tail=1 and wakes poller.
Now, before the poller wakes, several threads push/pop from the queue
incrementing both head and tail, maybe also waking poller. But at no
point in time the queue is empty.
Now poller wakes and reads, say, tail=1 (at the time when head=0 and
tail=1 so the queue is not empty) and then reads head=1 (at the time
when head=1 and tail=3 so the queue is not empty again). But now the
poller looks at head==tail==1 and decides that the queue is empty.
This may lead to a missed epoll event and a deadlock.
This can be resolved by acquiring a consistent snapshot of head/tail in poller.
Is there anything that prevents such a scenario in io_uring? Or it's
not an issue for some other reason?
