Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC1E14FE68
	for <lists+io-uring@lfdr.de>; Sun,  2 Feb 2020 17:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgBBQ4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 Feb 2020 11:56:23 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53439 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbgBBQ4X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 Feb 2020 11:56:23 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 211032104A;
        Sun,  2 Feb 2020 11:56:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 02 Feb 2020 11:56:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=tJyWD58bSoukTxe0ppGCVH19RBbTqo7BGE1Xt4J1N/Y=; b=ga55RPXb
        LxTuTdSpgsr+kPEhXgSRPgp+HaXukLOaNTM77AXjfdicZnaHRhblBBGw2WUTgoAD
        1xDL75oI+I0m8SamLKyV3U6DbS5rtgquzPLoX5FERliUrsPpcBNdb2kFyKH+df8Z
        hu1XRcvxcXxp3Jp3jYNP6lxSt76sQsQzbMdzAyGfT2cSFlZLNM9ZTQPyzgH4kCTY
        cGUFaT2gBgu7F07RRg2E2mRquvcWvJYoZDOMJKiS7MweHUBKF6pSqywynILX15Ci
        C0uKsYewu7dzCjeCRFzNWveLIAeYGfwZaOFrCOQpUq5bZp//Qy9ROxxQYNefP63L
        wAkqDXPeCZmyig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=tJyWD58bSoukTxe0ppGCVH19RBbTq
        o7BGE1Xt4J1N/Y=; b=m1Lz52LQPswI1KYSQXgkXcy8cETHIVe9+2t1aejJo9KDw
        NGsUtf2UIx0F82vFTZPhg8Vlpa6e6YjtEBcq3DKIP07wYFKHx90Xxc9botCI7oML
        kev4t2BYLQPVl+vem1FVHcQ+/ka4cba75HFrIqDGalQgffpSnMmIdBSGeL4YbavR
        LT6GP+wKTJjleTXD6w5FfZBXTcbmE9Ucur+M7lPnKw6lWQULiO9/TSG96rVBEi5X
        MIB/PDwauH5aLYB3QkopX65QtqEUkQitu2Y3JIbiocC8GKJ1uvJob0Yjp+nP2hQ6
        18Sq36cHz7jmlKqzgKGrn6N0AX+b2hRA+bCdPmb0g==
X-ME-Sender: <xms:Nf82Xt4hG2RBWER6hHteI-tRkG0aOUP0vpvSWzfOUZnQKnfjry00lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgeehgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheptehnughrvghsucfh
    rhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppedvuddvrd
    ejiedrvdehfedrudejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:Nf82XlRkGbFLbnFlwLHxa2UNNvAThuyzow4WqhUGXr_mOiUejVz76g>
    <xmx:Nf82XlNr5NJE9GDy-_kWkT0CzTNvsyTIjFbUcEUMd7_DnI6H8g-4Yg>
    <xmx:Nf82XjpXzNhO1dqTsUmRtnG90Fv5CoAaWq9yxkuHyqf1dx9hB-X2cA>
    <xmx:Nv82XmcJy20HZXRY1yt8udhUHKiQbDdk-z2jiEqVhwolBA67Q3r4Kg>
Received: from intern.anarazel.de (unknown [212.76.253.171])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5355A328005D;
        Sun,  2 Feb 2020 11:56:21 -0500 (EST)
Date:   Sun, 2 Feb 2020 08:56:19 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: liburing's eventfd test reliably oopses on 5.6-94f2630b1897
Message-ID: <20200202165619.etu4s7lpfi24nwrw@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Updated to linus' current master (with just one perf build fix applied
on top) for reasons unrelated to uring, got the oops below when running
the uring tests. It's sufficient to just run the eventfd test.

[ 4085.054332] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[ 4085.054336] rcu: 	8-...0: (0 ticks this GP) idle=346/1/0x4000000000000000 softirq=81543/81543 fqs=14982 
[ 4085.054371] rcu: 	14-...0: (1 GPs behind) idle=46e/1/0x4000000000000000 softirq=78025/78025 fqs=14982 
[ 4085.054373] 	(detected by 0, t=60002 jiffies, g=246209, q=21702)
[ 4085.054375] Sending NMI from CPU 0 to CPUs 8:
[ 4085.055377] NMI backtrace for cpu 8
[ 4085.055378] CPU: 8 PID: 14268 Comm: eventfd Not tainted 5.5.0-andres-06886-g050b83aa3110-dirty #20
[ 4085.055378] Hardware name: LENOVO 20QVS0FP00/20QVS0FP00, BIOS N2OET41W (1.28 ) 11/25/2019
[ 4085.055378] RIP: 0010:queued_spin_lock_slowpath+0x42/0x1a0
[ 4085.055379] Code: 41 f0 0f ba 2f 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 e4 09 d0 a9 00 01 ff ff 75 1b 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 c3 f6 c4 01 75 04 c6 47
[ 4085.055380] RSP: 0018:ffffc900050abb98 EFLAGS: 00000002
[ 4085.055381] RAX: 00000000003c0101 RBX: ffff888804459080 RCX: 0000000000000000
[ 4085.055381] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888804459088
[ 4085.055381] RBP: ffff888804459088 R08: ffffffff8245dfa0 R09: 0000000000000000
[ 4085.055382] R10: ffff88880bf4dcd8 R11: ffff88881c7ab638 R12: 0000000000000046
[ 4085.055382] R13: ffff888804459088 R14: 0000000000000046 R15: ffff88880f41a000
[ 4085.055383] FS:  00007f2383091500(0000) GS:ffff88881c600000(0000) knlGS:0000000000000000
[ 4085.055383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4085.055383] CR2: 00007f2382f0cb90 CR3: 0000000803216002 CR4: 00000000003606e0
[ 4085.055384] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4085.055384] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4085.055384] Call Trace:
[ 4085.055385]  _raw_spin_lock_irqsave+0x33/0x40
[ 4085.055385]  eventfd_signal+0x1d/0x70
[ 4085.055385]  io_poll_wake+0x1ec/0x360
[ 4085.055386]  ? __switch_to_asm+0x40/0x70
[ 4085.055386]  ? __switch_to_asm+0x34/0x70
[ 4085.055386]  __wake_up_common+0x7a/0x140
[ 4085.055386]  eventfd_signal+0x57/0x70
[ 4085.055387]  io_issue_sqe+0x580/0xf80
[ 4085.055387]  ? io_submit_sqes+0x425/0xb10
[ 4085.055387]  ? io_import_iovec+0x220/0x220
[ 4085.055388]  ? rw_copy_check_uvector+0x4b/0x100
[ 4085.055388]  io_queue_sqe+0x2d2/0x790
[ 4085.055388]  ? io_read_prep+0x89/0xc0
[ 4085.055388]  ? _cond_resched+0x19/0x30
[ 4085.055389]  io_submit_sqes+0x839/0xb10
[ 4085.055389]  ? trace_hardirqs_on+0x2c/0xd0
[ 4085.055389]  ? __io_uring_register+0x199/0xe00
[ 4085.055390]  ? alloc_file_pseudo+0xa3/0x110
[ 4085.055390]  __x64_sys_io_uring_enter+0x253/0x350
[ 4085.055390]  do_syscall_64+0x50/0x140
[ 4085.055390]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4085.055391] RIP: 0033:0x7f2382fc50a9
[ 4085.055392] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b7 3d 0c 00 f7 d8 64 89 01 48
[ 4085.055392] RSP: 002b:00007ffd259b6f88 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
[ 4085.055393] RAX: ffffffffffffffda RBX: 00007ffd259b7060 RCX: 00007f2382fc50a9
[ 4085.055393] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
[ 4085.055393] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000008
[ 4085.055394] R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000004
[ 4085.055394] R13: 00007ffd259b6fc0 R14: 0000000000000000 R15: 0000000000000000
[ 4085.055396] Sending NMI from CPU 0 to CPUs 14:
[ 4085.056412] NMI backtrace for cpu 14
[ 4085.056412] CPU: 14 PID: 14270 Comm: io_wqe_worker-0 Not tainted 5.5.0-andres-06886-g050b83aa3110-dirty #20
[ 4085.056413] Hardware name: LENOVO 20QVS0FP00/20QVS0FP00, BIOS N2OET41W (1.28 ) 11/25/2019
[ 4085.056413] RIP: 0010:queued_spin_lock_slowpath+0x118/0x1a0
[ 4085.056414] Code: 74 f2 eb f6 41 83 c0 01 c1 e1 10 41 c1 e0 12 44 09 c1 89 c8 c1 e8 10 66 87 47 02 89 c6 c1 e6 10 85 f6 75 3c 31 f6 eb 02 f3 90 <8b> 07 66 85 c0 75 f7 41 89 c0 66 45 31 c0 41 39 c8 74 64 48 85 f6
[ 4085.056414] RSP: 0018:ffffc900050c3bd0 EFLAGS: 00000002
[ 4085.056415] RAX: 00000000003c0101 RBX: ffff888804459080 RCX: 00000000003c0000
[ 4085.056430] RDX: ffff88881c7ac200 RSI: 0000000000000000 RDI: ffff888804459088
[ 4085.056431] RBP: ffff888804459088 R08: 00000000003c0000 R09: 0000000000000000
[ 4085.056431] R10: 00007ffd259b6fd0 R11: 0000000000105931 R12: 00007ffd259b6fc8
[ 4085.056431] R13: ffff888814fbb800 R14: ffff88880bf4dc40 R15: 0000000000000008
[ 4085.056432] FS:  0000000000000000(0000) GS:ffff88881c780000(0000) knlGS:0000000000000000
[ 4085.056432] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4085.056433] CR2: 00007f4e7499b000 CR3: 0000000803216002 CR4: 00000000003606e0
[ 4085.056433] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4085.056433] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4085.056434] Call Trace:
[ 4085.056434]  eventfd_read+0x78/0x210
[ 4085.056434]  ? wake_up_q+0xa0/0xa0
[ 4085.056434]  loop_rw_iter.part.0+0x40/0x110
[ 4085.056435]  io_read+0x228/0x280
[ 4085.056435]  ? __switch_to_asm+0x40/0x70
[ 4085.056435]  ? __switch_to_asm+0x34/0x70
[ 4085.056435]  ? __switch_to_asm+0x40/0x70
[ 4085.056436]  ? __switch_to_asm+0x34/0x70
[ 4085.056436]  ? __switch_to_asm+0x40/0x70
[ 4085.056436]  ? __switch_to_asm+0x34/0x70
[ 4085.056436]  ? __switch_to_asm+0x40/0x70
[ 4085.056437]  ? __switch_to_asm+0x34/0x70
[ 4085.056437]  ? __switch_to_asm+0x40/0x70
[ 4085.056437]  ? __switch_to_asm+0x34/0x70
[ 4085.056437]  ? __switch_to_asm+0x40/0x70
[ 4085.056438]  ? __switch_to_asm+0x34/0x70
[ 4085.056438]  ? __switch_to_asm+0x40/0x70
[ 4085.056438]  ? __switch_to_asm+0x34/0x70
[ 4085.056438]  ? __switch_to_asm+0x40/0x70
[ 4085.056438]  ? __switch_to_asm+0x34/0x70
[ 4085.056439]  ? __switch_to_asm+0x40/0x70
[ 4085.056439]  ? finish_task_switch+0x74/0x240
[ 4085.056439]  io_issue_sqe+0x562/0xf80
[ 4085.056455]  ? trace_hardirqs_off+0x27/0xd0
[ 4085.056455]  ? switch_mm+0x41/0x50
[ 4085.056456]  io_wq_submit_work+0x73/0x220
[ 4085.056456]  io_worker_handle_work+0x1f1/0x4b0
[ 4085.056456]  io_wqe_worker+0x27a/0x350
[ 4085.056456]  kthread+0xfb/0x130
[ 4085.056457]  ? io_wqe_enqueue+0xf0/0xf0
[ 4085.056457]  ? kthread_park+0x90/0x90
[ 4085.056457]  ret_from_fork+0x24/0x50
[ 4265.059294] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[ 4265.059298] rcu: 	8-...0: (0 ticks this GP) idle=346/1/0x4000000000000000 softirq=81543/81543 fqs=59754 
[ 4265.059300] rcu: 	14-...0: (1 GPs behind) idle=46e/1/0x4000000000000000 softirq=78025/78025 fqs=59754 
[ 4265.059334] 	(detected by 0, t=240007 jiffies, g=246209, q=55199)
[ 4265.059337] Sending NMI from CPU 0 to CPUs 8:
[ 4265.060339] NMI backtrace for cpu 8
[ 4265.060339] CPU: 8 PID: 14268 Comm: eventfd Not tainted 5.5.0-andres-06886-g050b83aa3110-dirty #20
[ 4265.060340] Hardware name: LENOVO 20QVS0FP00/20QVS0FP00, BIOS N2OET41W (1.28 ) 11/25/2019
[ 4265.060340] RIP: 0010:queued_spin_lock_slowpath+0x42/0x1a0
[ 4265.060341] Code: 41 f0 0f ba 2f 08 0f 92 c0 0f b6 c0 c1 e0 08 89 c2 8b 07 30 e4 09 d0 a9 00 01 ff ff 75 1b 85 c0 74 0e 8b 07 84 c0 74 08 f3 90 <8b> 07 84 c0 75 f8 b8 01 00 00 00 66 89 07 c3 f6 c4 01 75 04 c6 47
[ 4265.060342] RSP: 0018:ffffc900050abb98 EFLAGS: 00000002
[ 4265.060343] RAX: 00000000003c0101 RBX: ffff888804459080 RCX: 0000000000000000
[ 4265.060343] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888804459088
[ 4265.060343] RBP: ffff888804459088 R08: ffffffff8245dfa0 R09: 0000000000000000
[ 4265.060344] R10: ffff88880bf4dcd8 R11: ffff88881c7ab638 R12: 0000000000000046
[ 4265.060344] R13: ffff888804459088 R14: 0000000000000046 R15: ffff88880f41a000
[ 4265.060345] FS:  00007f2383091500(0000) GS:ffff88881c600000(0000) knlGS:0000000000000000
[ 4265.060345] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4265.060346] CR2: 00007f2382f0cb90 CR3: 0000000803216002 CR4: 00000000003606e0
[ 4265.060346] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4265.060347] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4265.060347] Call Trace:
[ 4265.060347]  _raw_spin_lock_irqsave+0x33/0x40
[ 4265.060347]  eventfd_signal+0x1d/0x70
[ 4265.060348]  io_poll_wake+0x1ec/0x360
[ 4265.060348]  ? __switch_to_asm+0x40/0x70
[ 4265.060348]  ? __switch_to_asm+0x34/0x70
[ 4265.060349]  __wake_up_common+0x7a/0x140
[ 4265.060349]  eventfd_signal+0x57/0x70
[ 4265.060349]  io_issue_sqe+0x580/0xf80
[ 4265.060350]  ? io_submit_sqes+0x425/0xb10
[ 4265.060350]  ? io_import_iovec+0x220/0x220
[ 4265.060350]  ? rw_copy_check_uvector+0x4b/0x100
[ 4265.060351]  io_queue_sqe+0x2d2/0x790
[ 4265.060351]  ? io_read_prep+0x89/0xc0
[ 4265.060351]  ? _cond_resched+0x19/0x30
[ 4265.060352]  io_submit_sqes+0x839/0xb10
[ 4265.060352]  ? trace_hardirqs_on+0x2c/0xd0
[ 4265.060352]  ? __io_uring_register+0x199/0xe00
[ 4265.060353]  ? alloc_file_pseudo+0xa3/0x110
[ 4265.060353]  __x64_sys_io_uring_enter+0x253/0x350
[ 4265.060353]  do_syscall_64+0x50/0x140
[ 4265.060354]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 4265.060354] RIP: 0033:0x7f2382fc50a9
[ 4265.060355] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b7 3d 0c 00 f7 d8 64 89 01 48
[ 4265.060355] RSP: 002b:00007ffd259b6f88 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
[ 4265.060356] RAX: ffffffffffffffda RBX: 00007ffd259b7060 RCX: 00007f2382fc50a9
[ 4265.060357] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
[ 4265.060357] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000008
[ 4265.060358] R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000004
[ 4265.060358] R13: 00007ffd259b6fc0 R14: 0000000000000000 R15: 0000000000000000
[ 4265.060360] Sending NMI from CPU 0 to CPUs 14:
[ 4265.061378] NMI backtrace for cpu 14
[ 4265.061378] CPU: 14 PID: 14270 Comm: io_wqe_worker-0 Not tainted 5.5.0-andres-06886-g050b83aa3110-dirty #20
[ 4265.061379] Hardware name: LENOVO 20QVS0FP00/20QVS0FP00, BIOS N2OET41W (1.28 ) 11/25/2019
[ 4265.061379] RIP: 0010:queued_spin_lock_slowpath+0x118/0x1a0
[ 4265.061380] Code: 74 f2 eb f6 41 83 c0 01 c1 e1 10 41 c1 e0 12 44 09 c1 89 c8 c1 e8 10 66 87 47 02 89 c6 c1 e6 10 85 f6 75 3c 31 f6 eb 02 f3 90 <8b> 07 66 85 c0 75 f7 41 89 c0 66 45 31 c0 41 39 c8 74 64 48 85 f6
[ 4265.061380] RSP: 0018:ffffc900050c3bd0 EFLAGS: 00000002
[ 4265.061381] RAX: 00000000003c0101 RBX: ffff888804459080 RCX: 00000000003c0000
[ 4265.061381] RDX: ffff88881c7ac200 RSI: 0000000000000000 RDI: ffff888804459088
[ 4265.061382] RBP: ffff888804459088 R08: 00000000003c0000 R09: 0000000000000000
[ 4265.061382] R10: 00007ffd259b6fd0 R11: 0000000000105931 R12: 00007ffd259b6fc8
[ 4265.061383] R13: ffff888814fbb800 R14: ffff88880bf4dc40 R15: 0000000000000008
[ 4265.061383] FS:  0000000000000000(0000) GS:ffff88881c780000(0000) knlGS:0000000000000000
[ 4265.061383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4265.061384] CR2: 00007f4e7499b000 CR3: 0000000803216002 CR4: 00000000003606e0
[ 4265.061384] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4265.061385] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4265.061385] Call Trace:
[ 4265.061385]  eventfd_read+0x78/0x210
[ 4265.061385]  ? wake_up_q+0xa0/0xa0
[ 4265.061386]  loop_rw_iter.part.0+0x40/0x110
[ 4265.061386]  io_read+0x228/0x280
[ 4265.061386]  ? __switch_to_asm+0x40/0x70
[ 4265.061387]  ? __switch_to_asm+0x34/0x70
[ 4265.061387]  ? __switch_to_asm+0x40/0x70
[ 4265.061387]  ? __switch_to_asm+0x34/0x70
[ 4265.061388]  ? __switch_to_asm+0x40/0x70
[ 4265.061388]  ? __switch_to_asm+0x34/0x70
[ 4265.061388]  ? __switch_to_asm+0x40/0x70
[ 4265.061388]  ? __switch_to_asm+0x34/0x70
[ 4265.061389]  ? __switch_to_asm+0x40/0x70
[ 4265.061389]  ? __switch_to_asm+0x34/0x70
[ 4265.061389]  ? __switch_to_asm+0x40/0x70
[ 4265.061389]  ? __switch_to_asm+0x34/0x70
[ 4265.061390]  ? __switch_to_asm+0x40/0x70
[ 4265.061390]  ? __switch_to_asm+0x34/0x70
[ 4265.061390]  ? __switch_to_asm+0x40/0x70
[ 4265.061391]  ? __switch_to_asm+0x34/0x70
[ 4265.061391]  ? __switch_to_asm+0x40/0x70
[ 4265.061391]  ? finish_task_switch+0x74/0x240
[ 4265.061391]  io_issue_sqe+0x562/0xf80
[ 4265.061392]  ? trace_hardirqs_off+0x27/0xd0
[ 4265.061392]  ? switch_mm+0x41/0x50
[ 4265.061392]  io_wq_submit_work+0x73/0x220
[ 4265.061393]  io_worker_handle_work+0x1f1/0x4b0
[ 4265.061412]  io_wqe_worker+0x27a/0x350
[ 4265.061412]  kthread+0xfb/0x130
[ 4265.061412]  ? io_wqe_enqueue+0xf0/0xf0
[ 4265.061413]  ? kthread_park+0x90/0x90
[ 4265.061413]  ret_from_fork+0x24/0x50

Greetings,

Andres Freund
