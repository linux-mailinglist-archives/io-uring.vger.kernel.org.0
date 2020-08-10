Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4342409D7
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 17:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgHJPgV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 11:36:21 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49236 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgHJPgS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 11:36:18 -0400
Received: by mail-io1-f70.google.com with SMTP id c1so3780990ioh.16
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vZw9RbfxaQ9aaX5fp2x2dWUjGcoH4rsgQ56zPcM+UN8=;
        b=gmNs8MdGPsi3/V/wDjYu7qDj7sHsb99MIfvk6OkQltZ6RsAab9+66XmiLf7gybOK19
         PD6W0l0lOP+roO9WR8G++q7FU/LvIGqYQPZbk91/2uSG9bY6OQuy8fsCfxWTj6m42wy6
         PEagga79iIwXZnx306oPGOqdXqg+LLT9wIVdHrd/D5J3tWOfyjoly+7pYRjOZbtC6IzR
         1L0hJYil3UYNos7TYSzGciGQGnQZrr9gvHlRIUU+TR1Djyk4qOsrWFBSMYfA37kKzcBF
         5rNnKjfW2X6tJNMf+ziWH7IU5piJh+BA1m7R0Wg9H7/+7izdkrSp+nwkjiEuUBX5Cbpi
         5Gpw==
X-Gm-Message-State: AOAM5333owHwDAmmoSw4JLJcz2f/fEikwRDjec9PURGOKoFNBMC4K3f+
        nfj09olGwt3gHoKU3Fp2sQAhkyF5laf9xh997rv/UDDiFXhY
X-Google-Smtp-Source: ABdhPJz4BEuyUlRkLLENFQWlyJ8VgZPOIftgvZgvRSY3OgPxyEGs87e9uMIb0DQqMTIpSVw7C/Y9CRqCfG6WgTReE4lc2bCcGQ7t
MIME-Version: 1.0
X-Received: by 2002:a5d:924c:: with SMTP id e12mr18077837iol.28.1597073778088;
 Mon, 10 Aug 2020 08:36:18 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:36:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000391eaf05ac87b74d@google.com>
Subject: INFO: task hung in io_uring_flush
From:   syzbot <syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9420f1ce Merge tag 'pinctrl-v5.9-1' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1637701c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=72cf85e4237850c8
dashboard link: https://syzkaller.appspot.com/bug?extid=6338dcebf269a590b668
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141dde52900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b196aa900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com

INFO: task syz-executor672:7284 blocked for more than 143 seconds.
      Not tainted 5.8.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor672 D28360  7284   6846 0x80004000
Call Trace:
 context_switch kernel/sched/core.c:3778 [inline]
 __schedule+0x8e5/0x21e0 kernel/sched/core.c:4527
 schedule+0xd0/0x2a0 kernel/sched/core.c:4602
 io_uring_cancel_files fs/io_uring.c:7897 [inline]
 io_uring_flush+0x740/0xa90 fs/io_uring.c:7914
 filp_close+0xb4/0x170 fs/open.c:1282
 close_files fs/file.c:401 [inline]
 put_files_struct fs/file.c:429 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:426
 exit_files+0x7e/0xa0 fs/file.c:458
 do_exit+0xb43/0x29f0 kernel/exit.c:801
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440938
Code: Bad RIP value.
RSP: 002b:00007ffc0e913ed8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000440938
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004c01d0 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d21a0 R14: 0000000000000000 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/1161:
 #0: ffffffff89bd62c0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5825
1 lock held by in:imklog/6515:
 #0: ffff8880a5ca6930 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1161 Comm: khungtaskd Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd7d/0x1000 kernel/hung_task.c:295
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 3889 Comm: systemd-journal Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:66
Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
RSP: 0018:ffffc90005277d08 EFLAGS: 00010246
RAX: 00000000000c1e00 RBX: 0000000000000cc0 RCX: 00000000000006c0
RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff88809de8b540
RBP: ffff8880aa240900 R08: ffff88809de8ac00 R09: ffff88809de8ac00
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000286
R13: 0000000000000cc0 R14: ffff8880aa240900 R15: ffff88809de8ac00
FS:  00007fa07185e8c0(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa06ec13000 CR3: 00000000927ab000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 slab_alloc mm/slab.c:3310 [inline]
 kmem_cache_alloc+0x2e0/0x3a0 mm/slab.c:3482
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags include/linux/audit.h:320 [inline]
 getname+0x8e/0xd0 fs/namei.c:209
 do_sys_openat2+0xf5/0x420 fs/open.c:1168
 do_sys_open fs/open.c:1190 [inline]
 __do_sys_open fs/open.c:1198 [inline]
 __se_sys_open fs/open.c:1194 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1194
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fa070dee840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007ffe015fba28 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007ffe015fbd30 RCX: 00007fa070dee840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 00005605a9deabc0
RBP: 000000000000000d R08: 0000000000000000 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00005605a9ddd060 R14: 00007ffe015fbcf0 R15: 00005605a9deac10


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
