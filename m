Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574B666896C
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 03:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbjAMCMa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 21:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjAMCM2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 21:12:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A255D699;
        Thu, 12 Jan 2023 18:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FFA7B81FAF;
        Fri, 13 Jan 2023 02:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93264C433D2;
        Fri, 13 Jan 2023 02:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673575944;
        bh=LyPN/s4UCWxT8ePa9W/Dzn2y5PenK0kXY4nUUio/g6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NPzyNgPmJpe5FlmknJ2+IimAup9s5ZZ+iopQyJ1syzkHHXOQ5jGICmJJzLMisJOyJ
         czvLOq2tCYlKu5EbyFuhGJE+qPtw2PwAQJbtZbKm60O45xiOfSg92nc5XXmOj8OdFy
         s9HcJF7Hm3OkbRvw07viwlisARaWHpa179sT7G16VrCNpoPDVOuNOJX9F6t+1jQ485
         LpyA8gQu0ZMEat62ONYonsgRPtu6QEn8oy33Ha1IyFxyIa1EXoRlqw8L1ooARrzs1Z
         /01bdAGtdjWt1f3oO3FCBnfBL1fM4/mmQUV6Lqq2v12VOnITghaF6Hs0HgOkPUcR5V
         eNs5jDjMY4tEg==
Date:   Thu, 12 Jan 2023 18:12:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     syzbot <syzbot+8317cc9c082c19d576a0@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk
Subject: Re: [io_uring] KASAN: use-after-free Read in signalfd_cleanup
Message-ID: <Y8C+BXazOBbxTufZ@sol.localdomain>
References: <000000000000f4b96605f20e5e2f@google.com>
 <000000000000651be505f218ce8b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000651be505f218ce8b@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Over to the io_uring maintainers and list, based on the reproducer...:

    r0 = signalfd4(0xffffffffffffffff, &(0x7f00000000c0), 0x8, 0x0)
    r1 = syz_io_uring_setup(0x87, &(0x7f0000000180), &(0x7f0000ffc000/0x3000)=nil, &(0x7f00006d4000/0x1000)=nil, &(0x7f0000000000)=<r2=>0x0, &(0x7f0000000040)=<r3=>0x0)
    pipe(&(0x7f0000000080)={0xffffffffffffffff, <r4=>0xffffffffffffffff})
    write$binfmt_misc(r4, &(0x7f0000000000)=ANY=[], 0xfffffecc)
    syz_io_uring_submit(r2, r3, &(0x7f0000002240)=@IORING_OP_POLL_ADD={0x6, 0x0, 0x0, @fd=r0}, 0x0)
    io_uring_enter(r1, 0x450c, 0x0, 0x0, 0x0, 0x0)

On Thu, Jan 12, 2023 at 02:40:39PM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=10a992a1480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=8317cc9c082c19d576a0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f672ee480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1357774a480000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8317cc9c082c19d576a0@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650 kernel/sched/wait.c:100
> Read of size 8 at addr ffff88801d1508f0 by task syz-executor378/5077
> 
> CPU: 0 PID: 5077 Comm: syz-executor378 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:306 [inline]
>  print_report+0x15e/0x45d mm/kasan/report.c:417
>  kasan_report+0xc0/0xf0 mm/kasan/report.c:517
>  __wake_up_common+0x637/0x650 kernel/sched/wait.c:100
>  __wake_up_common_lock+0xd4/0x140 kernel/sched/wait.c:138
>  __wake_up kernel/sched/wait.c:160 [inline]
>  __wake_up_pollfree+0x1d/0x60 kernel/sched/wait.c:246
>  wake_up_pollfree include/linux/wait.h:271 [inline]
>  signalfd_cleanup+0x46/0x60 fs/signalfd.c:38
>  __cleanup_sighand kernel/fork.c:1688 [inline]
>  __cleanup_sighand+0x76/0xb0 kernel/fork.c:1685
>  __exit_signal kernel/exit.c:209 [inline]
>  release_task+0xbfa/0x1870 kernel/exit.c:255
>  wait_task_zombie kernel/exit.c:1198 [inline]
>  wait_consider_task+0x306d/0x3ce0 kernel/exit.c:1425
>  do_wait_thread kernel/exit.c:1488 [inline]
>  do_wait+0x7cd/0xd90 kernel/exit.c:1605
>  kernel_wait4+0x150/0x260 kernel/exit.c:1768
>  __do_sys_wait4+0x13f/0x150 kernel/exit.c:1796
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7facd1d06656
> Code: 0f 1f 40 00 31 c9 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 14 48 89 74 24
> RSP: 002b:00007ffc250fbf98 EFLAGS: 00000246
>  ORIG_RAX: 000000000000003d
> RAX: ffffffffffffffda RBX: 00007ffc250fc050 RCX: 00007facd1d06656
> RDX: 0000000040000001 RSI: 00007ffc250fbfcc RDI: 00000000ffffffff
> RBP: 00007ffc250fbfcc R08: 000000000000003d R09: 00007ffc251bb080
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000f4240
> R13: 0000000000000002 R14: 00007ffc250fc020 R15: 00007ffc250fc010
>  </TASK>
> 
> Allocated by task 5081:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
>  kasan_slab_alloc include/linux/kasan.h:186 [inline]
>  slab_post_alloc_hook mm/slab.h:769 [inline]
>  kmem_cache_alloc_bulk+0x3aa/0x730 mm/slub.c:4033
>  __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
>  io_alloc_req_refill io_uring/io_uring.h:348 [inline]
>  io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
>  __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 33:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:162 [inline]
>  slab_free_hook mm/slub.c:1781 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
>  slab_free mm/slub.c:3787 [inline]
>  kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
>  io_req_caches_free+0x1a9/0x1e6 io_uring/io_uring.c:2737
>  io_ring_exit_work+0x2e7/0xc80 io_uring/io_uring.c:2967
>  process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2440
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> The buggy address belongs to the object at ffff88801d1508c0
>  which belongs to the cache io_kiocb of size 216
> The buggy address is located 48 bytes inside of
>  216-byte region [ffff88801d1508c0, ffff88801d150998)
> 
> The buggy address belongs to the physical page:
> page:ffffea0000745400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1d150
> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000000200 ffff88801beb7780 dead000000000122 0000000000000000
> raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 5081, tgid 5079 (syz-executor378), ts 61182579448, free_ts 52418879084
>  prep_new_page mm/page_alloc.c:2549 [inline]
>  get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
>  __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
>  alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
>  alloc_slab_page mm/slub.c:1851 [inline]
>  allocate_slab+0x25f/0x350 mm/slub.c:1998
>  new_slab mm/slub.c:2051 [inline]
>  ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
>  __kmem_cache_alloc_bulk mm/slub.c:3951 [inline]
>  kmem_cache_alloc_bulk+0x23d/0x730 mm/slub.c:4026
>  __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
>  io_alloc_req_refill io_uring/io_uring.h:348 [inline]
>  io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
>  __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1451 [inline]
>  free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
>  free_unref_page_prepare mm/page_alloc.c:3387 [inline]
>  free_unref_page+0x1d/0x490 mm/page_alloc.c:3482
>  __folio_put_small mm/swap.c:106 [inline]
>  __folio_put+0xc5/0x140 mm/swap.c:129
>  folio_put include/linux/mm.h:1203 [inline]
>  put_page include/linux/mm.h:1272 [inline]
>  anon_pipe_buf_release+0x3fb/0x4c0 fs/pipe.c:138
>  pipe_buf_release include/linux/pipe_fs_i.h:183 [inline]
>  pipe_read+0x614/0x1110 fs/pipe.c:324
>  call_read_iter include/linux/fs.h:1846 [inline]
>  new_sync_read fs/read_write.c:389 [inline]
>  vfs_read+0x7fa/0x930 fs/read_write.c:470
>  ksys_read+0x1ec/0x250 fs/read_write.c:613
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Memory state around the buggy address:
>  ffff88801d150780: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88801d150800: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
> >ffff88801d150880: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>                                                              ^
>  ffff88801d150900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88801d150980: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000651be505f218ce8b%40google.com.
