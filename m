Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F503CA539
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 20:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhGOSTg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 14:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhGOSTg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 14:19:36 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D603AC06175F;
        Thu, 15 Jul 2021 11:16:42 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id a5-20020a7bc1c50000b02901e3bbe0939bso4260417wmj.0;
        Thu, 15 Jul 2021 11:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hIqBSPwEW53VfV+l915hsYqACbolJA8LDuA5BhfVqYw=;
        b=YcFcfmmv9SKV1aThbk4i6mcNiHHptDeHRhr/U84aSzIeI8678wPrkiU0X3IS9VFYAu
         h4jlqUaKnkHls4AsbtgQXndv+iRWbJcWcNO178Ay1JdfyzHMglQx1yK37hz+amir6712
         zo/WO3o687syZXEGVrOW92dfsESmzVG6Ud8TYIpOGJGtd8o4q+TRi/BK5TPUFP/Z77p+
         Nix0HJnc++9qUejpPUUDr4t7D0J4KplK8TrSI808Klo0spOVz+I9JEeQ0YYCHV+KRuKk
         AjGiRP9IAi/6mqPpYY6VeCd/smfRCBs5jnqrDXjPs7gIvwZX89m+gkk23UjKQ77Hjez/
         4qXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hIqBSPwEW53VfV+l915hsYqACbolJA8LDuA5BhfVqYw=;
        b=ApozQ6GHhs/y1F0vlUmG2kx/B3O8ORmsUZRGuhLgBlhq3HvKEAKmpOx5/WM2FQZXCN
         TW+Vghe+y9YS89YiQUadl/20mXhk1zycAZJaNj+3JSZsapeMNx0hp97bUvvgVdkUeJtW
         fDLtkx6nUEBgrsqt5I1AAsamLnPL68+3bg5sQVpwg2tG0DhEg/udmbL2AU5hJ5w3cUbe
         cyFTSF058QSSi0WLD80oS7qBlejUCqBR+sNijLVkjBCJGB+u+Wd6dOl08OUUVbaj5r3A
         7a36RK+/z+SACIn5fyXXM1AcG1ML2tKesUJCeY8HyL+g1ynZ7gHzryFd9pXzuOhTz7G4
         JltA==
X-Gm-Message-State: AOAM530w08snTiIeZ/KDoZ6A/JmaSfur/1CgkblWHEU3GgQqYnbkZ2SN
        BSwzwpI0B84bbmir2Q9UTGzpH544hqaV1A==
X-Google-Smtp-Source: ABdhPJywwIlGNCmBdeehhqM4OEdPMpAymBjSgHIyefXXn0wCqf3itbPLaESEy/DypSHi6woPPvWrMw==
X-Received: by 2002:a1c:2782:: with SMTP id n124mr12177187wmn.114.1626373001402;
        Thu, 15 Jul 2021 11:16:41 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.177])
        by smtp.gmail.com with ESMTPSA id r16sm8935965wmg.11.2021.07.15.11.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 11:16:40 -0700 (PDT)
To:     syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
References: <000000000000690cd505c725e894@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
Message-ID: <532f6c4a-1066-a31a-bd14-3f5068365f50@gmail.com>
Date:   Thu, 15 Jul 2021 19:16:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000690cd505c725e894@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/21 10:15 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: task hung in io_sq_thread_park

The interesting part here is this:

[  282.599913][ T1620] task:iou-sqp-23145   state:D stack:28720 pid:23155 ppid:  8844 flags:0x00004004
[  282.609927][ T1620] Call Trace:
[  282.613711][ T1620]  __schedule+0x93a/0x26f0
[  282.618131][ T1620]  ? io_schedule_timeout+0x140/0x140
[  282.623446][ T1620]  ? lockdep_hardirqs_on+0x79/0x100
[  282.628789][ T1620]  ? _raw_spin_unlock_irqrestore+0x3d/0x70
[  282.634647][ T1620]  schedule+0xd3/0x270
[  282.638874][ T1620]  io_uring_cancel_generic+0x54d/0x890
[  282.644428][ T1620]  ? __io_uring_free+0x170/0x170
[  282.649361][ T1620]  ? lockdep_hardirqs_on+0x79/0x100
[  282.655639][ T1620]  ? finish_wait+0x270/0x270
[  282.660346][ T1620]  io_sq_thread+0xaac/0x1250
[  282.665096][ T1620]  ? io_uring_cancel_generic+0x890/0x890
[  282.670788][ T1620]  ? ret_from_fork+0x8/0x30
[  282.675295][ T1620]  ? finish_wait+0x270/0x270
[  282.679983][ T1620]  ? rwlock_bug.part.0+0x90/0x90
[  282.684958][ T1620]  ? _raw_spin_unlock_irq+0x1f/0x40
[  282.690155][ T1620]  ? io_uring_cancel_generic+0x890/0x890
[  282.696394][ T1620]  ret_from_fork+0x1f/0x30

So we have a dying SQPOLL task, which is stuck in cancellation.
Let's add some debug output and see if we have a request lost.

#syz test: https://github.com/isilence/linux.git syztest_sqpoll_hang 


> INFO: task kworker/u4:1:10 blocked for more than 143 seconds.
>       Not tainted 5.14.0-rc1-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:1    state:D stack:26320 pid:   10 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4683 [inline]
>  __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
>  schedule+0xd3/0x270 kernel/sched/core.c:6019
>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>  __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
>  io_sq_thread_park+0x79/0xd0 fs/io_uring.c:7314
>  io_ring_exit_work+0x15a/0x1600 fs/io_uring.c:8771
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> INFO: task iou-sqp-23145:23155 blocked for more than 143 seconds.
>       Not tainted 5.14.0-rc1-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-sqp-23145   state:D stack:28720 pid:23155 ppid:  8844 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4683 [inline]
>  __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
>  schedule+0xd3/0x270 kernel/sched/core.c:6019
>  io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9150
>  io_sq_thread+0xaac/0x1250 fs/io_uring.c:6916
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> Showing all locks held in the system:
> 3 locks held by kworker/u4:1/10:
>  #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
>  #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>  #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>  #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
>  #1: ffffc90000cf7db0 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
>  #2: ffff88803d708470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x79/0xd0 fs/io_uring.c:7314
> 1 lock held by khungtaskd/1620:
>  #0: ffffffff8b97b900 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
> 1 lock held by in:imklog/8316:
>  #0: ffff888022f82ff0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
> 1 lock held by iou-sqp-23145/23155:
>  #0: ffff88803d708470 (&sqd->lock){+.+.}-{3:3}, at: io_sqd_handle_event+0x2d6/0x350 fs/io_uring.c:6836
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 PID: 1620 Comm: khungtaskd Not tainted 5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
>  watchdog+0xd0a/0xfc0 kernel/hung_task.c:295
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 PID: 10540 Comm: kworker/u4:10 Not tainted 5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: phy8 ieee80211_iface_work
> RIP: 0010:write_comp_data kernel/kcov.c:218 [inline]
> RIP: 0010:__sanitizer_cov_trace_switch+0x65/0xf0 kernel/kcov.c:320
> Code: 10 31 c9 65 4c 8b 24 25 00 f0 01 00 4d 85 d2 74 6b 4c 89 e6 bf 03 00 00 00 4c 8b 4c 24 20 49 8b 6c c8 10 e8 2d ff ff ff 84 c0 <74> 47 49 8b 84 24 18 15 00 00 41 8b bc 24 14 15 00 00 48 8b 10 48
> RSP: 0018:ffffc9000bfa7030 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000016
> RDX: 0000000000000000 RSI: ffff88801c5d8000 RDI: 0000000000000003
> RBP: 0000000000000084 R08: ffffffff8aaa7a20 R09: ffffffff88878073
> R10: 0000000000000020 R11: 0000000000000003 R12: ffff88801c5d8000
> R13: dffffc0000000000 R14: ffff888053061087 R15: ffff888053061086
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f87cdfe4090 CR3: 000000002a61f000 CR4: 0000000000350ef0
> Call Trace:
>  _ieee802_11_parse_elems_crc+0x1e3/0x1f90 net/mac80211/util.c:1018
>  ieee802_11_parse_elems_crc+0x89e/0xfe0 net/mac80211/util.c:1478
>  ieee802_11_parse_elems net/mac80211/ieee80211_i.h:2186 [inline]
>  ieee80211_bss_info_update+0x463/0xb70 net/mac80211/scan.c:212
>  ieee80211_rx_bss_info net/mac80211/ibss.c:1126 [inline]
>  ieee80211_rx_mgmt_probe_beacon+0xcc6/0x17c0 net/mac80211/ibss.c:1615
>  ieee80211_ibss_rx_queued_mgmt+0xd30/0x1610 net/mac80211/ibss.c:1642
>  ieee80211_iface_process_skb net/mac80211/iface.c:1426 [inline]
>  ieee80211_iface_work+0x7f7/0xa40 net/mac80211/iface.c:1462
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> 
> Tested on:
> 
> commit:         1b48773f io_uring: fix io_drain_req()
> git tree:       git://git.kernel.dk/linux-block io_uring-5.14
> console output: https://syzkaller.appspot.com/x/log.txt?x=12040824300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
> dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
> compiler:       
> 

-- 
Pavel Begunkov
