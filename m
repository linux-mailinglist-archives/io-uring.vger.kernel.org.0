Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942303C9B33
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 11:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhGOJSF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 05:18:05 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:39782 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhGOJSE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 05:18:04 -0400
Received: by mail-il1-f197.google.com with SMTP id g14-20020a926b0e0000b02901bb2deb9d71so2888015ilc.6
        for <io-uring@vger.kernel.org>; Thu, 15 Jul 2021 02:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JLjJihMlHnsYuGox5nm+OcQejYVamIZ+rYpuha60Zps=;
        b=Xq/bS6++FzW36Ij+EtdgcJJ5icCvjlJj0MfJsdlFnbsC68No8n5GGyl1kQz7yeaHFw
         6CZWSSl+z3OPT00dq4iIgtllyl+LhwOH89PUt/o8uv0/b+JACbpiOgShKN62NDn7S7Yv
         C3WLPo50T+PY6sHPLz2W5c+YkfplvlXUSblUp+NEFJ9bSgpStoCL/rQAnjn1rk9J+dCM
         zldDjMAki6ZNGiitRtG0x8EWwV/POk2WaEa2PNKjpX3U7rkgyq7cEkRYVALRTFKRXiFo
         cXUJZH4ql8Fy8WlHfqdp2AjiK+MpaCT9QFxLaDoWkqz4DzU+kP6sWjgnocNB8JaWNcsb
         7Yuw==
X-Gm-Message-State: AOAM530rRJcym9F3YXzfeljPjAXwWsOT6dNq3B93yFM0tujJBeKPFUoW
        ePQCa2DmkkY7beUanYElwiNdvCXZmHfxKpmWu60kZe9xwaMS
X-Google-Smtp-Source: ABdhPJzgwn90CTTaI2LMN7TsOpDvnKLfuzubj1OabkTHzS2MBqGfVkELGn33dyoFhXNt2hnZs3XRyUhaGbWcjJ4mW1ivsjMnSdwl
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3291:: with SMTP id f17mr3082308jav.143.1626340510467;
 Thu, 15 Jul 2021 02:15:10 -0700 (PDT)
Date:   Thu, 15 Jul 2021 02:15:10 -0700
In-Reply-To: <9c692289-0d4b-a462-99b3-37f3c6521d84@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000690cd505c725e894@google.com>
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
From:   syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_sq_thread_park

INFO: task kworker/u4:1:10 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:1    state:D stack:26320 pid:   10 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
 __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
 __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
 io_sq_thread_park+0x79/0xd0 fs/io_uring.c:7314
 io_ring_exit_work+0x15a/0x1600 fs/io_uring.c:8771
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task iou-sqp-23145:23155 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-sqp-23145   state:D stack:28720 pid:23155 ppid:  8844 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9150
 io_sq_thread+0xaac/0x1250 fs/io_uring.c:6916
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Showing all locks held in the system:
3 locks held by kworker/u4:1/10:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
 #1: ffffc90000cf7db0 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
 #2: ffff88803d708470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x79/0xd0 fs/io_uring.c:7314
1 lock held by khungtaskd/1620:
 #0: ffffffff8b97b900 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by in:imklog/8316:
 #0: ffff888022f82ff0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
1 lock held by iou-sqp-23145/23155:
 #0: ffff88803d708470 (&sqd->lock){+.+.}-{3:3}, at: io_sqd_handle_event+0x2d6/0x350 fs/io_uring.c:6836

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1620 Comm: khungtaskd Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xd0a/0xfc0 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 10540 Comm: kworker/u4:10 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy8 ieee80211_iface_work
RIP: 0010:write_comp_data kernel/kcov.c:218 [inline]
RIP: 0010:__sanitizer_cov_trace_switch+0x65/0xf0 kernel/kcov.c:320
Code: 10 31 c9 65 4c 8b 24 25 00 f0 01 00 4d 85 d2 74 6b 4c 89 e6 bf 03 00 00 00 4c 8b 4c 24 20 49 8b 6c c8 10 e8 2d ff ff ff 84 c0 <74> 47 49 8b 84 24 18 15 00 00 41 8b bc 24 14 15 00 00 48 8b 10 48
RSP: 0018:ffffc9000bfa7030 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000016
RDX: 0000000000000000 RSI: ffff88801c5d8000 RDI: 0000000000000003
RBP: 0000000000000084 R08: ffffffff8aaa7a20 R09: ffffffff88878073
R10: 0000000000000020 R11: 0000000000000003 R12: ffff88801c5d8000
R13: dffffc0000000000 R14: ffff888053061087 R15: ffff888053061086
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f87cdfe4090 CR3: 000000002a61f000 CR4: 0000000000350ef0
Call Trace:
 _ieee802_11_parse_elems_crc+0x1e3/0x1f90 net/mac80211/util.c:1018
 ieee802_11_parse_elems_crc+0x89e/0xfe0 net/mac80211/util.c:1478
 ieee802_11_parse_elems net/mac80211/ieee80211_i.h:2186 [inline]
 ieee80211_bss_info_update+0x463/0xb70 net/mac80211/scan.c:212
 ieee80211_rx_bss_info net/mac80211/ibss.c:1126 [inline]
 ieee80211_rx_mgmt_probe_beacon+0xcc6/0x17c0 net/mac80211/ibss.c:1615
 ieee80211_ibss_rx_queued_mgmt+0xd30/0x1610 net/mac80211/ibss.c:1642
 ieee80211_iface_process_skb net/mac80211/iface.c:1426 [inline]
 ieee80211_iface_work+0x7f7/0xa40 net/mac80211/iface.c:1462
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


Tested on:

commit:         1b48773f io_uring: fix io_drain_req()
git tree:       git://git.kernel.dk/linux-block io_uring-5.14
console output: https://syzkaller.appspot.com/x/log.txt?x=12040824300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
compiler:       

