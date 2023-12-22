Return-Path: <io-uring+bounces-350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C12981C645
	for <lists+io-uring@lfdr.de>; Fri, 22 Dec 2023 09:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C61EDB21C41
	for <lists+io-uring@lfdr.de>; Fri, 22 Dec 2023 08:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36481C8CF;
	Fri, 22 Dec 2023 08:11:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B71C8C8
	for <io-uring@vger.kernel.org>; Fri, 22 Dec 2023 08:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-35fd42a187bso9748115ab.0
        for <io-uring@vger.kernel.org>; Fri, 22 Dec 2023 00:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703232682; x=1703837482;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ksai+zLjhGTsulZkcRN0MnHbqLm2ooBbGymZ16RsmE4=;
        b=FhbiSUbm2guMVlC0Kyk6EqUDEQaSpq/S5nh04m4M8ckEqwsgwkJVlrHvlGuehVi+ty
         iXj9QaVkSf4VyLyz5N+J8QTudiISjscJAVoFBCIUovLOQnYytlCeMEVUaxUmPCVgQMQ+
         VzpdHDORZM9/hpk08csc6rDQ3II9XZZg5tJy4Wp4uqdu9sASNZybdPrhm2Ar2VKMoR5C
         HfZ2OnP108G/I1NFqH0bpnpSrINr5l+y0+8gbAlWlRZayMKCTMkVcbC6cFYW1vHgxGqE
         RM+BatHH43FFJyiV/MD8nfuf7r0o7IMz108FK0w9bgVGJxVBX6Tz5Q3vvbuWFZ32EgIp
         OuvA==
X-Gm-Message-State: AOJu0Yx3Yy8LGQ9u/GZFaWkypISCwHz44OQO5WNBsWHJsUduOJ4rFhTM
	ZS1pLa+l4NrSr38a7a6TN6qyJG1jmXTkmsjImvtPGEvS7Ydb
X-Google-Smtp-Source: AGHT+IHm4vI5cGNid0dVo81tFxxdFzC//1MSNc5wPCXhH1phWDbIPa4Uao/Ku9i1xmh48VXvs7OpBOTJH7fI8oC0ALtb/wdFXNZS
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d190:0:b0:35f:d01c:4fc with SMTP id
 z16-20020a92d190000000b0035fd01c04fcmr56213ilz.2.1703232681932; Fri, 22 Dec
 2023 00:11:21 -0800 (PST)
Date: Fri, 22 Dec 2023 00:11:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9ff00060d14c256@google.com>
Subject: [syzbot] [mm?] [io-uring?] WARNING in get_pte_pfn
From: syzbot <syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0e389834672c Merge tag 'for-6.7-rc5-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1454824ee80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f21aff374937e60e
dashboard link: https://syzkaller.appspot.com/bug?extid=03fd9b3f71641f0ebf2d
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b4ef49e80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=118314d6e80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e58cd74e152a/disk-0e389834.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/45d17ccb34bc/vmlinux-0e389834.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b9b7105d4e08/bzImage-0e389834.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5066 at mm/vmscan.c:3242 get_pte_pfn+0x1b5/0x3f0 mm/vmscan.c:3242
Modules linked in:
CPU: 1 PID: 5066 Comm: syz-executor668 Not tainted 6.7.0-rc5-syzkaller-00270-g0e389834672c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023
RIP: 0010:get_pte_pfn+0x1b5/0x3f0 mm/vmscan.c:3242
Code: f3 74 2a e8 6d 78 cb ff 31 ff 48 b8 00 00 00 00 00 00 00 02 48 21 c5 48 89 ee e8 e6 73 cb ff 48 85 ed 74 4e e8 4c 78 cb ff 90 <0f> 0b 90 48 c7 c3 ff ff ff ff e8 3c 78 cb ff 48 b8 00 00 00 00 00
RSP: 0018:ffffc900041e6878 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000007891d RCX: ffffffff81bbf6e3
RDX: ffff88807d813b80 RSI: ffffffff81bbf684 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000200 R11: 0000000000000003 R12: 0000000000000200
R13: 1ffff9200083cd0f R14: 0000000000010b21 R15: 0000000020ffc000
FS:  0000555555f4d480(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005fbfa000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 lru_gen_look_around+0x70d/0x11a0 mm/vmscan.c:4001
 folio_referenced_one+0x5a2/0xf70 mm/rmap.c:843
 rmap_walk_anon+0x225/0x570 mm/rmap.c:2485
 rmap_walk mm/rmap.c:2562 [inline]
 rmap_walk mm/rmap.c:2557 [inline]
 folio_referenced+0x28a/0x4b0 mm/rmap.c:960
 folio_check_references mm/vmscan.c:829 [inline]
 shrink_folio_list+0x1ace/0x3f00 mm/vmscan.c:1160
 evict_folios+0x6e7/0x1b90 mm/vmscan.c:4499
 try_to_shrink_lruvec+0x638/0xa10 mm/vmscan.c:4704
 lru_gen_shrink_lruvec mm/vmscan.c:4849 [inline]
 shrink_lruvec+0x314/0x2990 mm/vmscan.c:5622
 shrink_node_memcgs mm/vmscan.c:5842 [inline]
 shrink_node+0x811/0x3710 mm/vmscan.c:5877
 shrink_zones mm/vmscan.c:6116 [inline]
 do_try_to_free_pages+0x36c/0x1940 mm/vmscan.c:6178
 try_to_free_mem_cgroup_pages+0x31a/0x770 mm/vmscan.c:6493
 try_charge_memcg+0x3d3/0x11f0 mm/memcontrol.c:2742
 obj_cgroup_charge_pages mm/memcontrol.c:3255 [inline]
 __memcg_kmem_charge_page+0xdd/0x2a0 mm/memcontrol.c:3281
 __alloc_pages+0x263/0x2420 mm/page_alloc.c:4585
 alloc_pages_mpol+0x258/0x5f0 mm/mempolicy.c:2133
 __get_free_pages+0xc/0x40 mm/page_alloc.c:4615
 io_mem_alloc+0x33/0x60 io_uring/io_uring.c:2789
 io_allocate_scq_urings io_uring/io_uring.c:3842 [inline]
 io_uring_create io_uring/io_uring.c:4019 [inline]
 io_uring_setup+0x13ed/0x2430 io_uring/io_uring.c:4131
 __do_sys_io_uring_setup io_uring/io_uring.c:4158 [inline]
 __se_sys_io_uring_setup io_uring/io_uring.c:4152 [inline]
 __x64_sys_io_uring_setup+0x98/0x140 io_uring/io_uring.c:4152
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0x40/0x110 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b
RIP: 0033:0x7f4b0e4778a9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 1a 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff814fe868 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f4b0e4778a9
RDX: 0000000020000700 RSI: 0000000020000640 RDI: 0000000000005a19
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000020000700
R10: 00007fff814fe8d0 R11: 0000000000000202 R12: 0000000020000640
R13: 0000000000000000 R14: 0000000000005a19 R15: 0000000020000700
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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

