Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB212880C
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 09:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLUH6L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 02:58:11 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:47937 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLUH6L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 02:58:11 -0500
Received: by mail-il1-f198.google.com with SMTP id x69so9563575ill.14
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 23:58:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q1pJKh2rDwjRaiH1vujbGmFDVl4vWxAHJQsThER25tQ=;
        b=K6V1EIsF9U195tB7wVyf92m5d8wVsk0hluPzhA/LJpRXSk/57rutdOzT7jgnGn6iOx
         bOa2YaWaxxeX2LwJ4lMrGztmEoj5mBmTuK7ZQmwdCtQfq5kVLKNenrWIjQp6eJFfLA3B
         RZjL2Tg/olgq0+mpbZ5Ue5tOEcgCPeV/eymaMWfp7HXBuoHgETwFQGuCXsCpgV7T/WU+
         By24SFc0ukbU804U8gH8T4HJmNXQ0pg3bY7hbbkFsLZHJgQ/DGjHdJaFwbH9fTGbkFH1
         PLY+ktkejj0+eZXIdg0Nh2YrRwMuuRx8/lBPiWntUgybFMBV66dJkJtSvkwBFscDV9T4
         EjQA==
X-Gm-Message-State: APjAAAVwhzC7XdeukEachYy5qjDq9fBKWShIajzxiwYPBmWGRaHcgPzJ
        HckJlFb9rTWIIHhRP3I8jaxMxdU/EQx0fJrH7D05WITMM+MI
X-Google-Smtp-Source: APXvYqwo2Ss/zArnppj7dFI2mwhQqCNotYIAaBO8RzsubepJNRzmNmgtEbnNHP63QTkicufQzkKD/7ZWs4tIBJDsVAWPNc6F9Kf5
MIME-Version: 1.0
X-Received: by 2002:a5d:8b04:: with SMTP id k4mr13164730ion.229.1576915088931;
 Fri, 20 Dec 2019 23:58:08 -0800 (PST)
Date:   Fri, 20 Dec 2019 23:58:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b7853a059a3227b4@google.com>
Subject: KASAN: use-after-free Read in io_wq_flush (2)
From:   syzbot <syzbot+8e7705a7ae1bdce77c07@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ddd09fc Add linux-next specific files for 20191220
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12e1823ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f183b01c3088afc6
dashboard link: https://syzkaller.appspot.com/bug?extid=8e7705a7ae1bdce77c07
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8e7705a7ae1bdce77c07@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_wq_flush+0x1f7/0x210 fs/io-wq.c:1009
Read of size 8 at addr ffff8880a8453d00 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted  
5.5.0-rc2-next-20191220-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events io_ring_file_ref_switch
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
  io_wq_flush+0x1f7/0x210 fs/io-wq.c:1009
  io_destruct_skb+0x8e/0xc0 fs/io_uring.c:4668
  skb_release_head_state+0xeb/0x260 net/core/skbuff.c:652
  skb_release_all+0x16/0x60 net/core/skbuff.c:663
  __kfree_skb net/core/skbuff.c:679 [inline]
  kfree_skb net/core/skbuff.c:697 [inline]
  kfree_skb+0x101/0x420 net/core/skbuff.c:691
  io_ring_file_put fs/io_uring.c:4836 [inline]
  io_ring_file_ref_switch+0x68a/0xac0 fs/io_uring.c:4881
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9937:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
  kmalloc include/linux/slab.h:555 [inline]
  kzalloc include/linux/slab.h:669 [inline]
  io_wq_create+0x52/0xa40 fs/io-wq.c:1024
  io_sq_offload_start fs/io_uring.c:5244 [inline]
  io_uring_create fs/io_uring.c:6002 [inline]
  io_uring_setup+0xf4a/0x2080 fs/io_uring.c:6062
  __do_sys_io_uring_setup fs/io_uring.c:6075 [inline]
  __se_sys_io_uring_setup fs/io_uring.c:6072 [inline]
  __x64_sys_io_uring_setup+0x54/0x80 fs/io_uring.c:6072
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9935:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  kasan_set_free_info mm/kasan/common.c:335 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  io_wq_destroy+0x2ce/0x3c0 fs/io-wq.c:1116
  io_finish_async+0x128/0x1b0 fs/io_uring.c:4657
  io_ring_ctx_free fs/io_uring.c:5569 [inline]
  io_ring_ctx_wait_and_kill+0x330/0x9a0 fs/io_uring.c:5644
  io_uring_release+0x42/0x50 fs/io_uring.c:5652
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a8453d00
  which belongs to the cache kmalloc-192 of size 192
The buggy address is located 0 bytes inside of
  192-byte region [ffff8880a8453d00, ffff8880a8453dc0)
The buggy address belongs to the page:
page:ffffea0002a114c0 refcount:1 mapcount:0 mapping:ffff8880aa400000  
index:0x0
raw: 00fffe0000000200 ffffea0002644808 ffffea0002482f08 ffff8880aa400000
raw: 0000000000000000 ffff8880a8453000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a8453c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8880a8453c80: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a8453d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff8880a8453d80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff8880a8453e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
