Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB1679EA4
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 17:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbjAXQ35 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Jan 2023 11:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbjAXQ3v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Jan 2023 11:29:51 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C18959D3
        for <io-uring@vger.kernel.org>; Tue, 24 Jan 2023 08:29:47 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hw16so40423775ejc.10
        for <io-uring@vger.kernel.org>; Tue, 24 Jan 2023 08:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BOTYemAdqciiYIvAqJE2GsTaqj5FuuO8ZTKcaekuk6M=;
        b=RuATYPMe1mCqWxlvPqCHDER7+kVtKUI+JIrDt43qJiD0THXUgWMffDPQlpUhbBDtVj
         ekd+or4fJfbWSWxzXtD7KGptV8+wQOKUbiVR0/2i3C2j2Lf/PVhGH0QP8ckwLjbnSYTj
         3u+aF23pkd2SEZFEjRz2uqeBksVizdklbX9AQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BOTYemAdqciiYIvAqJE2GsTaqj5FuuO8ZTKcaekuk6M=;
        b=XsBk4xqIrkqf2OF1+SBgoHpUacmuyI8rB5g8sZ7awox+TGrEFi7l9yNIQI8NFj7HV4
         baAkrHWIpKGnUI9v37Xs/OlmmrdGJ9R0jn5opWJvk56qA/li/hLvbKBTzgcjkFpOrnQu
         x4jp4Q3tdWYHt8BI17aOlTfImhcWNP64nbLERnbh5I1CkP5pWA050Gmj0Ssgc8qUyX1C
         hE+Jw+YmDOqyUGdgr9+/qdNdvOMK/4zniFkmQOcLW36UgMh3wUYQNRjRVk7pDVz5bX7b
         xD4IhIhBD3kVioVbAGdh/lsq/zImyZEk+7/WdT9ocqbxXBoQH66XTCnA//+AfOK8Li0E
         Zp+g==
X-Gm-Message-State: AFqh2krXkunGLjLVeCN00mnn0G1+gqCxtm1fitDTOhHmBAdSP71YgYzN
        O6CtwCI8O0HYhBKwXS1nFoBNjlvYSmriOh9oG88V9g==
X-Google-Smtp-Source: AMrXdXucss0qGqNGdTo8WigLjsv5u9qE4+RJ9x3z/jYYFnG3BCPhoYVnjt7Dmi0xU6rO4SEElM2pw6Qp/DEoe8Uq+8A=
X-Received: by 2002:a17:907:9620:b0:7c1:10b4:4741 with SMTP id
 gb32-20020a170907962000b007c110b44741mr2881422ejc.8.1674577786060; Tue, 24
 Jan 2023 08:29:46 -0800 (PST)
MIME-Version: 1.0
References: <000000000000bac7df05f260d220@google.com>
In-Reply-To: <000000000000bac7df05f260d220@google.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 24 Jan 2023 17:29:35 +0100
Message-ID: <CAJfpegteWVfJ8CLATjhk7==iLmqyZT_ao8Hs2JaNKdbgceXZYw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in fuse_dev_poll
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+d3b704fabd7f02206294@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Forwarding, since it looks like io_uring is the culprit: vfs_poll() is
called by io_poll_check_events() on an already released file.

Thanks,
Miklos

On Mon, 16 Jan 2023 at 13:35, syzbot
<syzbot+d3b704fabd7f02206294@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1485ee86480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=d3b704fabd7f02206294
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d3b704fabd7f02206294@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in fuse_dev_poll+0x1fe/0x240 fs/fuse/dev.c:2066
> Read of size 8 at addr ffff8880185fc500 by task syz-executor.4/7813
>
> CPU: 0 PID: 7813 Comm: syz-executor.4 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:306 [inline]
>  print_report+0x15e/0x45d mm/kasan/report.c:417
>  kasan_report+0xc0/0xf0 mm/kasan/report.c:517
>  fuse_dev_poll+0x1fe/0x240 fs/fuse/dev.c:2066
>  vfs_poll include/linux/poll.h:88 [inline]
>  io_poll_check_events io_uring/poll.c:279 [inline]
>  io_poll_task_func+0x3a6/0x1220 io_uring/poll.c:327
>  handle_tw_list+0xa8/0x460 io_uring/io_uring.c:1169
>  tctx_task_work+0x12e/0x530 io_uring/io_uring.c:1224
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  get_signal+0x1c7/0x24f0 kernel/signal.c:2635
>  arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>  exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f5c53a8c0c9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5c5481c218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007f5c53babf88 RCX: 00007f5c53a8c0c9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f5c53babf88
> RBP: 00007f5c53babf80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5c53babf8c
> R13: 00007fff46acb32f R14: 00007f5c5481c300 R15: 0000000000022000
>  </TASK>
>
> Allocated by task 7813:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:330 [inline]
>  __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:380
>  kmalloc include/linux/slab.h:580 [inline]
>  kzalloc include/linux/slab.h:720 [inline]
>  fuse_dev_alloc+0x48/0x270 fs/fuse/inode.c:1336
>  fuse_dev_alloc_install fs/fuse/inode.c:1366 [inline]
>  fuse_fill_super_common+0x472/0x10b0 fs/fuse/inode.c:1558
>  fuse_fill_super+0x1fb/0x2e0 fs/fuse/inode.c:1641
>  vfs_get_super+0xea/0x280 fs/super.c:1128
>  fuse_get_tree+0x277/0x640 fs/fuse/inode.c:1716
>  vfs_get_tree+0x8d/0x2f0 fs/super.c:1489
>  do_new_mount fs/namespace.c:3145 [inline]
>  path_mount+0x132a/0x1e20 fs/namespace.c:3475
>  do_mount fs/namespace.c:3488 [inline]
>  __do_sys_mount fs/namespace.c:3697 [inline]
>  __se_sys_mount fs/namespace.c:3674 [inline]
>  __x64_sys_mount+0x283/0x300 fs/namespace.c:3674
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Freed by task 7807:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:162 [inline]
>  slab_free_hook mm/slub.c:1781 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
>  slab_free mm/slub.c:3787 [inline]
>  __kmem_cache_free+0xaf/0x2d0 mm/slub.c:3800
>  fuse_dev_release+0x2ac/0x3f0 fs/fuse/dev.c:2220
>  __fput+0x27c/0xa90 fs/file_table.c:321
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Last potentially related work creation:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
>  kvfree_call_rcu+0x70/0xad0 kernel/rcu/tree.c:3315
>  kernfs_unlink_open_file+0x3a4/0x4a0 fs/kernfs/file.c:633
>  kernfs_fop_release+0xeb/0x1e0 fs/kernfs/file.c:805
>  __fput+0x27c/0xa90 fs/file_table.c:321
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
>  kvfree_call_rcu+0x70/0xad0 kernel/rcu/tree.c:3315
>  kernfs_unlink_open_file+0x3a4/0x4a0 fs/kernfs/file.c:633
>  kernfs_fop_release+0xeb/0x1e0 fs/kernfs/file.c:805
>  __fput+0x27c/0xa90 fs/file_table.c:321
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x210/0x240 kernel/entry/common.c:204
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>  syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> The buggy address belongs to the object at ffff8880185fc500
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 0 bytes inside of
>  128-byte region [ffff8880185fc500, ffff8880185fc580)
>
> The buggy address belongs to the physical page:
> page:ffffea0000617f00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880185fc700 pfn:0x185fc
> anon flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000000200 ffff8880124418c0 0000000000000000 dead000000000001
> raw: ffff8880185fc700 000000008010000e 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112cc0(GFP_USER|__GFP_NOWARN|__GFP_NORETRY), pid 5935, tgid 5934 (syz-executor.0), ts 311717359180, free_ts 231319442393
>  prep_new_page mm/page_alloc.c:2549 [inline]
>  get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
>  __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
>  alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
>  alloc_slab_page mm/slub.c:1851 [inline]
>  allocate_slab+0x25f/0x350 mm/slub.c:1998
>  new_slab mm/slub.c:2051 [inline]
>  ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
>  __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
>  __slab_alloc_node mm/slub.c:3345 [inline]
>  slab_alloc_node mm/slub.c:3442 [inline]
>  __kmem_cache_alloc_node+0x136/0x330 mm/slub.c:3491
>  __do_kmalloc_node mm/slab_common.c:966 [inline]
>  __kmalloc_node_track_caller+0x4b/0xc0 mm/slab_common.c:987
>  kmemdup+0x2c/0x60 mm/util.c:130
>  kmemdup include/linux/fortify-string.h:702 [inline]
>  mpls_dev_sysctl_register+0xaa/0x2d0 net/mpls/af_mpls.c:1406
>  mpls_add_dev net/mpls/af_mpls.c:1472 [inline]
>  mpls_dev_notify+0x46d/0x990 net/mpls/af_mpls.c:1612
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
>  call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
>  call_netdevice_notifiers net/core/dev.c:1996 [inline]
>  register_netdevice+0xfb4/0x1640 net/core/dev.c:10078
>  __ip_tunnel_create+0x398/0x570 net/ipv4/ip_tunnel.c:267
>  ip_tunnel_init_net+0x1f9/0x5a0 net/ipv4/ip_tunnel.c:1073
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1451 [inline]
>  free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
>  free_unref_page_prepare mm/page_alloc.c:3387 [inline]
>  free_unref_page+0x1d/0x490 mm/page_alloc.c:3482
>  qlink_free mm/kasan/quarantine.c:168 [inline]
>  qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>  kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
>  __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:302
>  kasan_slab_alloc include/linux/kasan.h:186 [inline]
>  slab_post_alloc_hook mm/slab.h:769 [inline]
>  slab_alloc_node mm/slub.c:3452 [inline]
>  slab_alloc mm/slub.c:3460 [inline]
>  __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
>  kmem_cache_alloc+0x175/0x320 mm/slub.c:3476
>  vm_area_alloc+0x20/0x100 kernel/fork.c:458
>  mmap_region+0x44c/0x1e50 mm/mmap.c:2605
>  do_mmap+0x831/0xf60 mm/mmap.c:1411
>  vm_mmap_pgoff+0x1af/0x280 mm/util.c:542
>  ksys_mmap_pgoff+0x41f/0x5a0 mm/mmap.c:1457
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Memory state around the buggy address:
>  ffff8880185fc400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff8880185fc480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff8880185fc500: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff8880185fc580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8880185fc600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
