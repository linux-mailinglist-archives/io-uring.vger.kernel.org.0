Return-Path: <io-uring+bounces-5594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CC09FA0AF
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 13:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C6711882742
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 12:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4711A8406;
	Sat, 21 Dec 2024 12:48:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EB41F2C33
	for <io-uring@vger.kernel.org>; Sat, 21 Dec 2024 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734785304; cv=none; b=fY28nGFQFawIS0iXdBPx6JoZ4xw2Je1O7BOmTqZ7VWxwCSVo+Pbi84vUcBZqsGoQdSPG7fBoNTczlJtfTSHS8my2ogLJx2kGyClsV6rC4gz9traoMusPsdxi6uIgDfKAFb7tl1EP3UMC2SQKhzJ/JycCMw1LO4z4bSHzSXh925s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734785304; c=relaxed/simple;
	bh=6Gm3F54zW1FyrGPu8ZS0ghjalLljUCp3clO76b8D37k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rueDRZNvc+yh3clQ2NJPuVgkNYWhHYPhvIKguRoRkVt1dEatr2sXEqoYE1EZFS6gdZkcxCxNIZq2Y+P6BOsf8Kgm4daZZdQeF+rxojoBslVaACRCop1S7zaMecxvzRQtza7KyLgp85sz8bVkxH/YVjVR9aSBUncOH3zT76PMwVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a9c9b37244so50286085ab.1
        for <io-uring@vger.kernel.org>; Sat, 21 Dec 2024 04:48:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734785301; x=1735390101;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FZsdCBieHfh2wEyE4VCnYio0ehMIJO+a5z5xUcd76kc=;
        b=spI537QmoDwh5J5SZm6V6cBy/vjsaT5qmw2DtKmQeIpWAjAKokvHk2t9bCDli23kFU
         ApOCgDwi2qPNCKsZTSOZwlFXdisgJJtul9erhSvk3abehJ9J5eIpIJ+P8ymi9u9eO/9Q
         NUpNjffi5u5t+26iqD+7VqoxQ8LDIkiqfugAQzBPS06+rn9OhvQ58Nrv1Bu19EpuKl3J
         YYRtK48JjZlAkve9xXde+1D/7HTR5vQ8aOqxeFvz/eA24xy/9C+AS4DxhAlYQzVQ/wtr
         rXQmeB+pu2bdp1t1MzQAz4B+qC0nUX9IYquI9HQmaDr7/COVJ3aBk7gPGYh1DhTxEsFo
         pctA==
X-Forwarded-Encrypted: i=1; AJvYcCXTG+0jQTRgXoJ74I9KeY3aoHJr9uQ4hYKVo4PTw2q4eRHT3iKsk75e/okJNR/hQ0ozBG7HpYerxg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvxPzIAsiL3XQTSVR6my115aUw7eFTlk8i1CaxRwGyO07+VTgT
	VQF20GJK9BuxKifAyumjBNUVAv9h5S14rXHgiLojrZg0n2x3rpQPnn08h8T+iAhlEyG+o/VMn1a
	tatJfYnOaCaDQSZ4nEkiI74fHPXcYj094yCj39s4G2BH8kyZylEpgF+Y=
X-Google-Smtp-Source: AGHT+IHyuv1s94WmnX2JbPsYbvNmgBMgLYV05TY9syZrS47iOMSAsfsN1PEFSoXKEfVKcmlmQqSlxND8T4PmHziSfAP4jvE9VB7T
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c6:b0:3a7:956c:61a4 with SMTP id
 e9e14a558f8ab-3c2d2681c55mr65100535ab.10.1734785301772; Sat, 21 Dec 2024
 04:48:21 -0800 (PST)
Date: Sat, 21 Dec 2024 04:48:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6766b915.050a0220.25abdd.012e.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] [io-uring?] INFO: task hung in hugetlbfs_zero_partial_page
From: syzbot <syzbot+1c6e77303b6fae1f5957@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk, 
	hughd@google.com, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mike.kravetz@oracle.com, 
	muchun.song@linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f44d154d6e3d Merge tag 'soc-fixes-6.13' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117e4744580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=1c6e77303b6fae1f5957
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f8a7e8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8be4151807d/disk-f44d154d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a5f22853d301/vmlinux-f44d154d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d7a4a78964e0/bzImage-f44d154d.xz

The issue was bisected to:

commit 72e315f7a750281b4410ac30d8930f735459e72d
Author: Hugh Dickins <hughd@google.com>
Date:   Tue Oct 3 09:27:47 2023 +0000

    mempolicy: mmap_lock is not needed while migrating folios

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=154877e8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=174877e8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=134877e8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1c6e77303b6fae1f5957@syzkaller.appspotmail.com
Fixes: 72e315f7a750 ("mempolicy: mmap_lock is not needed while migrating folios")

INFO: task syz.3.1803:9905 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc3-syzkaller-00017-gf44d154d6e3d #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.1803      state:D stack:22160 pid:9905  tgid:9904  ppid:5954   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x1850/0x4c30 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 io_schedule+0x8d/0x110 kernel/sched/core.c:7681
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1308
 __folio_lock mm/filemap.c:1646 [inline]
 folio_lock include/linux/pagemap.h:1151 [inline]
 __filemap_get_folio+0x14c/0x940 mm/filemap.c:1899
 filemap_lock_folio include/linux/pagemap.h:788 [inline]
 filemap_lock_hugetlb_folio include/linux/hugetlb.h:789 [inline]
 hugetlbfs_zero_partial_page+0xb0/0x590 fs/hugetlbfs/inode.c:661
 hugetlbfs_punch_hole fs/hugetlbfs/inode.c:715 [inline]
 hugetlbfs_fallocate+0xbdd/0x11a0 fs/hugetlbfs/inode.c:748
 vfs_fallocate+0x56b/0x6e0 fs/open.c:327
 madvise_remove mm/madvise.c:1020 [inline]
 madvise_vma_behavior mm/madvise.c:1255 [inline]
 madvise_walk_vmas mm/madvise.c:1497 [inline]
 do_madvise+0x23c1/0x4d10 mm/madvise.c:1684
 __do_sys_madvise mm/madvise.c:1700 [inline]
 __se_sys_madvise mm/madvise.c:1698 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:1698
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa4fef85d19
RSP: 002b:00007fa4ffdff038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fa4ff175fa0 RCX: 00007fa4fef85d19
RDX: 0000000000000009 RSI: 0000000000600002 RDI: 0000000020000000
RBP: 00007fa4ff001a20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fa4ff175fa0 R15: 00007ffd7e368038
 </TASK>
INFO: task syz.3.1803:9910 blocked for more than 144 seconds.
      Not tainted 6.13.0-rc3-syzkaller-00017-gf44d154d6e3d #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.1803      state:D stack:27120 pid:9910  tgid:9904  ppid:5954   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x1850/0x4c30 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6905
 rwsem_down_read_slowpath kernel/locking/rwsem.c:1084 [inline]
 __down_read_common kernel/locking/rwsem.c:1248 [inline]
 __down_read kernel/locking/rwsem.c:1261 [inline]
 down_read+0x705/0xa40 kernel/locking/rwsem.c:1526
 i_mmap_lock_read include/linux/fs.h:529 [inline]
 rmap_walk_file+0x69c/0x780 mm/rmap.c:2694
 remove_migration_ptes mm/migrate.c:373 [inline]
 unmap_and_move_huge_page mm/migrate.c:1526 [inline]
 migrate_hugetlbs mm/migrate.c:1648 [inline]
 migrate_pages+0xd26/0x3380 mm/migrate.c:2046
 do_mbind mm/mempolicy.c:1394 [inline]
 kernel_mbind mm/mempolicy.c:1537 [inline]
 __do_sys_mbind mm/mempolicy.c:1611 [inline]
 __se_sys_mbind+0x145b/0x18d0 mm/mempolicy.c:1607
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa4fef85d19
RSP: 002b:00007fa4ffdab038 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 00007fa4ff176080 RCX: 00007fa4fef85d19
RDX: 0000000000000000 RSI: 0000000000800000 RDI: 0000000020001000
RBP: 00007fa4ff001a20 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007fa4ff176080 R15: 00007ffd7e368038
 </TASK>

Showing all locks held in the system:
4 locks held by kworker/u8:1/12:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
1 lock held by udevd/5197:
1 lock held by dhcpcd/5491:
 #0: ffffffff8fcb2888 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:128 [inline]
 #0: ffffffff8fcb2888 (rtnl_mutex){+.+.}-{4:4}, at: devinet_ioctl+0x31a/0x1ac0 net/ipv4/devinet.c:1129
2 locks held by getty/5586:
 #0: ffff8880313710a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fd62f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by kworker/0:3/5810:
 #0: ffff8880b863e8d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
 #1: ffff8880b8628948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x41d/0x7a0 kernel/sched/psi.c:987
3 locks held by kworker/u8:8/6048:
 #0: ffff88801ac81148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac81148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900046d7d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900046d7d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffffffff8fcb2888 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:281
3 locks held by syz.3.1803/9905:
 #0: ffff8881436e6420 (sb_writers#13){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #0: ffff8881436e6420 (sb_writers#13){.+.+}-{0:0}, at: vfs_fallocate+0x4fe/0x6e0 fs/open.c:326
 #1: ffff888024d19078 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff888024d19078 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: hugetlbfs_punch_hole fs/hugetlbfs/inode.c:690 [inline]
 #1: ffff888024d19078 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: hugetlbfs_fallocate+0x407/0x11a0 fs/hugetlbfs/inode.c:748
 #2: ffff888024d19348 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:509 [inline]
 #2: ffff888024d19348 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hugetlbfs_punch_hole fs/hugetlbfs/inode.c:698 [inline]
 #2: ffff888024d19348 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hugetlbfs_fallocate+0x4cd/0x11a0 fs/hugetlbfs/inode.c:748
1 lock held by syz.3.1803/9910:
 #0: ffff888024d19348 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mmap_lock_read include/linux/fs.h:529 [inline]
 #0: ffff888024d19348 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: rmap_walk_file+0x69c/0x780 mm/rmap.c:2694
1 lock held by syz.6.2635/11669:
 #0: ffff888077021858 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mmap_lock_read include/linux/fs.h:529 [inline]
 #0: ffff888077021858 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: rmap_walk_file+0x69c/0x780 mm/rmap.c:2694
3 locks held by syz.6.2635/11677:
 #0: ffff8881436e6420 (sb_writers#13){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #0: ffff8881436e6420 (sb_writers#13){.+.+}-{0:0}, at: vfs_fallocate+0x4fe/0x6e0 fs/open.c:326
 #1: ffff888077021588 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff888077021588 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: hugetlbfs_punch_hole fs/hugetlbfs/inode.c:690 [inline]
 #1: ffff888077021588 (&sb->s_type->i_mutex_key#21){+.+.}-{4:4}, at: hugetlbfs_fallocate+0x407/0x11a0 fs/hugetlbfs/inode.c:748
 #2: ffff888077021858 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: i_mmap_lock_write include/linux/fs.h:509 [inline]
 #2: ffff888077021858 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hugetlbfs_punch_hole fs/hugetlbfs/inode.c:698 [inline]
 #2: ffff888077021858 (&hugetlbfs_i_mmap_rwsem_key){++++}-{4:4}, at: hugetlbfs_fallocate+0x4cd/0x11a0 fs/hugetlbfs/inode.c:748
2 locks held by syz-executor/21337:
 #0: ffffffff8f45c1e0 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8f45c1e0 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8f45c1e0 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x22/0x250 net/core/rtnetlink.c:555
 #1: ffffffff8fcb2888 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #1: ffffffff8fcb2888 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:326 [inline]
 #1: ffffffff8fcb2888 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xbcb/0x2150 net/core/rtnetlink.c:4010
1 lock held by syz.5.7438/22297:
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc3-syzkaller-00017-gf44d154d6e3d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:234 [inline]
 watchdog+0xff6/0x1040 kernel/hung_task.c:397
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5197 Comm: udevd Not tainted 6.13.0-rc3-syzkaller-00017-gf44d154d6e3d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
RIP: 0010:validate_chain+0x15/0x5920 kernel/locking/lockdep.c:3860
Code: 02 4d 0a 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 e4 e0 <48> 81 ec c0 02 00 00 49 89 ce 89 54 24 58 48 89 bc 24 80 00 00 00
RSP: 0018:ffffc90004827700 EFLAGS: 00000086
RAX: 1ffffffff2783629 RBX: ffffffff93c1b148 RCX: 58cce5e7c8d5ebdc
RDX: 0000000000000001 RSI: ffff88807d7a64e0 RDI: ffff88807d7a5a00
RBP: ffffc90004827740 R08: ffffffff942a1887 R09: 1ffffffff2854310
R10: dffffc0000000000 R11: fffffbfff2854311 R12: ffff88807d7a5a00
R13: ffff88807d7a5a00 R14: 1ffff1100faf4ca0 R15: 0000000000000001
FS:  00007f2066ba4c80(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6e7cffdf98 CR3: 000000007c9ba000 CR4: 0000000000350ef0
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 __d_lookup+0x81/0x7b0 fs/dcache.c:2331
 lookup_fast+0x74/0x4a0 fs/namei.c:1749
 walk_component fs/namei.c:2108 [inline]
 link_path_walk+0x672/0xea0 fs/namei.c:2477
 path_lookupat+0xa9/0x450 fs/namei.c:2633
 filename_lookup+0x2a3/0x670 fs/namei.c:2663
 do_readlinkat+0xf0/0x3a0 fs/stat.c:562
 __do_sys_readlink fs/stat.c:599 [inline]
 __se_sys_readlink fs/stat.c:596 [inline]
 __x64_sys_readlink+0x7f/0x90 fs/stat.c:596
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2066717d47
Code: 73 01 c3 48 8b 0d e1 90 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 59 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b1 90 0d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffd34177f68 EFLAGS: 00000246 ORIG_RAX: 0000000000000059
RAX: ffffffffffffffda RBX: 00007ffd34177f78 RCX: 00007f2066717d47
RDX: 0000000000000400 RSI: 00007ffd34177f78 RDI: 00007ffd34178458
RBP: 0000000000000400 R08: 000055cbc6b605a4 R09: 0000000000000000
R10: 0000000000000812 R11: 0000000000000246 R12: 00007ffd34178458
R13: 00007ffd341783c8 R14: 000055cbc6b4c910 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

