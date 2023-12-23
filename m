Return-Path: <io-uring+bounces-355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0BDB81D210
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 05:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86E78284474
	for <lists+io-uring@lfdr.de>; Sat, 23 Dec 2023 04:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA51110F4;
	Sat, 23 Dec 2023 04:02:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7520D1110
	for <io-uring@vger.kernel.org>; Sat, 23 Dec 2023 04:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7b7fa6cba91so271909539f.1
        for <io-uring@vger.kernel.org>; Fri, 22 Dec 2023 20:02:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703304122; x=1703908922;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n62JQkWrXb19Weo263bbCAgIHWlV+cRk8wtKDHp9PuI=;
        b=Wt+f/1mquqy83LKSn2MrAQyfI5LaGYW4LZGeWVLwv6M8VYLODyBpwZ1DOGYD02M+qg
         GU/LpZrzEem/UcBQRpfq37jHmStX7ijJYtBoUUtVdIeuq0dGBzwapLxnBxmDBKJY+Gvz
         3zCOoDc/8xBrA5b/HlXWq4vITtwJccm7sLuiSwM6yKSi1J86Rj9vWOJQJiS5gbpWGBOc
         bQqH0avMkip3gDXgZu6Hr5XLy5R5mzcD/4+LYWVCQXKfZ6bq3/uPLlAITDhE6qBpgSE3
         7obDarzoko82n/41nJnYT9dAbg7djwgopVRuofeu2+AHZ4nPCDe9TAjCImDz5pP4xZtV
         GhpA==
X-Gm-Message-State: AOJu0Yw/3yjAPXNOtO5KtxBFP9HB5HdslNmfkCU0Tp2JBFl+d/Ngw4mc
	1panTWVlTB4TrEoFSlmLK3xRIw6x9f4HSVHCDoNbGq7nZ/wy
X-Google-Smtp-Source: AGHT+IHC89YKVAFZB3Q/TaFj9CgFTHxIO+3qKakY927csoLvm3v1Fo/We0UftITz9ZPPQZqXA3pycCtK5YQYAEXKDgkMDTtg939M
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16cf:b0:35f:d5ea:8a86 with SMTP id
 15-20020a056e0216cf00b0035fd5ea8a86mr244977ilx.5.1703304122722; Fri, 22 Dec
 2023 20:02:02 -0800 (PST)
Date: Fri, 22 Dec 2023 20:02:02 -0800
In-Reply-To: <ZYZUarJep8b746Et@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002df02e060d25657b@google.com>
Subject: Re: [syzbot] [mm?] [io-uring?] WARNING in get_pte_pfn
From: syzbot <syzbot+03fd9b3f71641f0ebf2d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in get_pte_pfn

ioctx_table 0000000000000000
owner ffff8880208f3b80 exe_file ffff88801a7ff180
notifier_subscriptions 0000000000000000
numa_next_scan 4294946352 numa_scan_offset 0 numa_scan_seq 0
tlb_flush_pending 0
def_flags: 0x0()
------------[ cut here ]------------
kernel BUG at mm/vmscan.c:3248!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5911 Comm: syz-executor.0 Not tainted 6.7.0-rc6-syzkaller-00248-g5254c0cbc92d-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/17/2023
RIP: 0010:get_pte_pfn+0x3ec/0x450 mm/vmscan.c:3248
Code: ef e8 48 27 0a 00 49 8d 7d 10 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 80 3c 02 00 75 5a 49 8b 7d 10 e8 c5 29 0a 00 90 <0f> 0b 4c 89 ef e8 fa 0f 22 00 e9 dc fc ff ff 48 c7 c7 80 43 19 8f
RSP: 0018:ffffc9000bb4e868 EFLAGS: 00010286
RAX: 0000000000000331 RBX: ffffea0001fb0240 RCX: ffffffff816a6559
RDX: 0000000000000000 RSI: ffffffff816aea02 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000200
R13: ffff88807ba95e00 R14: 1ffff92001769d0e R15: 0000000000010b22
FS:  00007ff14dc496c0(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000076e1e000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 lru_gen_look_around+0x743/0x11f0 mm/vmscan.c:4008
 folio_referenced_one+0x5a2/0xf70 mm/rmap.c:843
 rmap_walk_anon+0x225/0x570 mm/rmap.c:2485
 rmap_walk mm/rmap.c:2562 [inline]
 rmap_walk mm/rmap.c:2557 [inline]
 folio_referenced+0x28a/0x4b0 mm/rmap.c:960
 folio_check_references mm/vmscan.c:829 [inline]
 shrink_folio_list+0x1ace/0x3f00 mm/vmscan.c:1160
 evict_folios+0x6e7/0x1b90 mm/vmscan.c:4506
 try_to_shrink_lruvec+0x638/0xa10 mm/vmscan.c:4711
 lru_gen_shrink_lruvec mm/vmscan.c:4856 [inline]
 shrink_lruvec+0x314/0x2990 mm/vmscan.c:5629
 shrink_node_memcgs mm/vmscan.c:5849 [inline]
 shrink_node+0x811/0x3710 mm/vmscan.c:5884
 shrink_zones mm/vmscan.c:6123 [inline]
 do_try_to_free_pages+0x36c/0x1940 mm/vmscan.c:6185
 try_to_free_mem_cgroup_pages+0x31a/0x770 mm/vmscan.c:6500
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
RIP: 0033:0x7ff14ce7cba9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff14dc49058 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007ff14cf9bf80 RCX: 00007ff14ce7cba9
RDX: 0000000020000700 RSI: 0000000020000640 RDI: 0000000000005a19
RBP: 00007ff14cec847a R08: 0000000000000000 R09: 0000000020000700
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000020000640
R13: 0000000000000000 R14: 0000000000005a19 R15: 0000000020000700
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:get_pte_pfn+0x3ec/0x450 mm/vmscan.c:3248
Code: ef e8 48 27 0a 00 49 8d 7d 10 b8 ff ff 37 00 48 89 fa 48 c1 e0 2a 48 c1 ea 03 80 3c 02 00 75 5a 49 8b 7d 10 e8 c5 29 0a 00 90 <0f> 0b 4c 89 ef e8 fa 0f 22 00 e9 dc fc ff ff 48 c7 c7 80 43 19 8f
RSP: 0018:ffffc9000bb4e868 EFLAGS: 00010286
RAX: 0000000000000331 RBX: ffffea0001fb0240 RCX: ffffffff816a6559
RDX: 0000000000000000 RSI: ffffffff816aea02 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000200
R13: ffff88807ba95e00 R14: 1ffff92001769d0e R15: 0000000000010b22
FS:  00007ff14dc496c0(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000076e1e000 CR4: 0000000000350ef0


Tested on:

commit:         5254c0cb Merge tag 'block-6.7-2023-12-22' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1709d481e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=314e9ad033a7d3a7
dashboard link: https://syzkaller.appspot.com/bug?extid=03fd9b3f71641f0ebf2d
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1120ad76e80000


