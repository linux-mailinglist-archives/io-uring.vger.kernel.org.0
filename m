Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8543366795D
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 16:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjALPei (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 10:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240399AbjALPeF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 10:34:05 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BDB6144B
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 07:24:57 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id a7-20020a056e0208a700b0030ecfd5d4cdso1606942ilt.9
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 07:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tx8vies8TxyvxQ+rYNyjuUQwsIU5p8yX5/b5vwL2Gb4=;
        b=OJNx7BXGDsh+uim1qzW0NwgOjxDuaaas+6otJYlRG9I+b9pt6T3Ex3gUgd14CIx4eX
         ylm2LlEnc+K+ZvesAS7t9h1f4Hc8kAA4HvoRRL9vIj7dnSZOoViIVry7SVaKj7VBeLSJ
         5YRPfqrG0ycJk6Qg024E4AOBUw+aCjN/ubDS4BKTYzlx8Xz8XgT5E5hcFbJxrID2X0N1
         BSuiMt1hQeTDeQ8x1WmQOuJ6le8nW8tx52tDU9Yf/ONS7K93cVBg8cBVR9ubnN3J1yJW
         7E1mtQniY19Xr7t03MARvYYMsY6ks4OvBHCgi6moSjDNlx0GHauoLXZ5LqdF75lHQ2fk
         ig/A==
X-Gm-Message-State: AFqh2kpp9FxJVvEG6X0ntHKOGmG3IwRQtj1YYJgUZgTUmrmphM5l02It
        DwEeQUCBi3Y8iG5hhMQwzpg3dGpmAeq1ZahJkVzhlp+Yr4i8
X-Google-Smtp-Source: AMrXdXutKmf7G9Ql1E6hjDLR1jg7PvhGYaeUzTiuecAoj7mQEfpvwfTEzz+RSa25MG9DTlZS/zXjug+w2JtfQY5moL6xLUnyd7+p
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2a8:b0:38a:3f3c:8b0d with SMTP id
 d8-20020a05663802a800b0038a3f3c8b0dmr6941617jaq.181.1673537083025; Thu, 12
 Jan 2023 07:24:43 -0800 (PST)
Date:   Thu, 12 Jan 2023 07:24:43 -0800
In-Reply-To: <00000000000062f20e05f20e5b9e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a33e305f212b7f3@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_fallback_tw
From:   syzbot <syzbot+ebcc33c1e81093c9224f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14b3995a480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
dashboard link: https://syzkaller.appspot.com/bug?extid=ebcc33c1e81093c9224f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11613181480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101a000e480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ebcc33c1e81093c9224f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_fallback_tw+0x6d/0x119 io_uring/io_uring.c:1249
Read of size 8 at addr ffff88802b270448 by task syz-executor235/5078

CPU: 0 PID: 5078 Comm: syz-executor235 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xc0/0xf0 mm/kasan/report.c:517
 io_fallback_tw+0x6d/0x119 io_uring/io_uring.c:1249
 tctx_task_work.cold+0xf/0x2c io_uring/io_uring.c:1219
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb17/0x2a90 kernel/exit.c:867
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
 __do_sys_exit_group kernel/exit.c:1023 [inline]
 __se_sys_exit_group kernel/exit.c:1021 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f38f86551c9
Code: Unable to access opcode bytes at 0x7f38f865519f.
RSP: 002b:00007ffce433d688 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f38f86c9350 RCX: 00007f38f86551c9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f38f86c9350
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Allocated by task 5078:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:769 [inline]
 kmem_cache_alloc_bulk+0x3aa/0x730 mm/slub.c:4033
 __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
 io_alloc_req_refill io_uring/io_uring.h:348 [inline]
 io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
 __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 33:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
 io_req_caches_free+0x1a9/0x1e6 io_uring/io_uring.c:2737
 io_ring_exit_work+0x2e7/0xc80 io_uring/io_uring.c:2967
 process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
 worker_thread+0x669/0x1090 kernel/workqueue.c:2440
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff88802b2703c0
 which belongs to the cache io_kiocb of size 216
The buggy address is located 136 bytes inside of
 216-byte region [ffff88802b2703c0, ffff88802b270498)

The buggy address belongs to the physical page:
page:ffffea0000ac9c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2b270
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffff88801c4e3280 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 5078, tgid 5078 (syz-executor235), ts 57698640196, free_ts 57658994184
 prep_new_page mm/page_alloc.c:2549 [inline]
 get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
 __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __kmem_cache_alloc_bulk mm/slub.c:3951 [inline]
 kmem_cache_alloc_bulk+0x23d/0x730 mm/slub.c:4026
 __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
 io_alloc_req_refill io_uring/io_uring.h:348 [inline]
 io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
 __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1451 [inline]
 free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page_list+0x176/0xcd0 mm/page_alloc.c:3528
 release_pages+0xcb1/0x1330 mm/swap.c:1072
 tlb_batch_pages_flush+0xa8/0x1a0 mm/mmu_gather.c:97
 tlb_flush_mmu_free mm/mmu_gather.c:292 [inline]
 tlb_flush_mmu mm/mmu_gather.c:299 [inline]
 tlb_finish_mmu+0x14b/0x7e0 mm/mmu_gather.c:391
 exit_mmap+0x202/0x7c0 mm/mmap.c:3100
 __mmput+0x128/0x4c0 kernel/fork.c:1212
 mmput+0x60/0x70 kernel/fork.c:1234
 exec_mmap fs/exec.c:1034 [inline]
 begin_new_exec+0x1027/0x2f80 fs/exec.c:1293
 load_elf_binary+0x801/0x4ff0 fs/binfmt_elf.c:1001
 search_binary_handler fs/exec.c:1736 [inline]
 exec_binprm fs/exec.c:1778 [inline]
 bprm_execve fs/exec.c:1853 [inline]
 bprm_execve+0x7fd/0x1ae0 fs/exec.c:1809
 do_execveat_common+0x72c/0x880 fs/exec.c:1960
 do_execve fs/exec.c:2034 [inline]
 __do_sys_execve fs/exec.c:2110 [inline]
 __se_sys_execve fs/exec.c:2105 [inline]
 __x64_sys_execve+0x93/0xc0 fs/exec.c:2105
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88802b270300: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
 ffff88802b270380: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff88802b270400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff88802b270480: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802b270500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

