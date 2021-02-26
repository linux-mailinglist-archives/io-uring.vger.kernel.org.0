Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948F53260C5
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 11:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhBZKBh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 05:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhBZKA3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 05:00:29 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF98C06178A
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 01:58:45 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id c1so6270139qtc.1
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 01:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5jmMbj7Ow/N9z7RkJCmSrhNtjr4vvX5JGWV3DFuiePM=;
        b=pb9twG3HjmaQH5cl0YuzQRdzJquXKnmCvvin3GBJ4K48g7WEMbTLhLvsFZnGJ2Y07q
         VZKZmjZau7qp5DmtyeP7wKzb5esU9EtobkjqoCaW2ocSt9u7cwa0Ms/pgesJIVt6Cp7O
         FR55PnHSgN/yT+6RILDhv52GBO2ps0XJYJtpiHJHMgafVi7xzgKTPB3LBCFq0UF/6aH8
         FB5ToSSgx4wTHysvdzsKsVwFJaajpSJnbMEK3/fPwsEpXGlCu8UsG9jdK5t04/W5Y2uw
         pQ5fMw0Svh7b7p/g4j7NIqNlrvYKesAb7u2zf17QKGPQ0cXEkJV5w5Eh4huKsjy1NKAc
         FHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5jmMbj7Ow/N9z7RkJCmSrhNtjr4vvX5JGWV3DFuiePM=;
        b=VJdqtrn8rejQgdAKDMkJ6xMqie5/xa1o+3/oTmiWdVWY8tjvJAuQb4tCT8kxAUa/Dt
         ofFW0phyG1kHVahEhLNNJj6E2krcNuVCiGU5vhTrsn/AzEZjuPCG6ZvHd8lOptT9j2Gi
         zbcde4hFUSDpapcwJXLD7jQcNaEeA354kSdVeSAoG+eEJDmbNoMbI9oz9RhOowSweETJ
         inpuR20XfVJLnTnzNwx4trBUT92ccngiGIPd/havO67YciZ23qy0EKIn9qMv7W3Ylvpc
         +WnxOEWsJpubMgDU84B6Y9onEehKLZ2pdYSve7Iw6hjpt76hCwJH2QEdzvmyhuIs+HOy
         Fkyw==
X-Gm-Message-State: AOAM530rg3sPC6AVixo/Ev5iVlW5qLrQ5JbEmdf5Nn83Kr3gi6MxWWrT
        Ww9ZT4lWRk1bei0cW1FbnTxmkeMezNpmhROlxYhCtQ==
X-Google-Smtp-Source: ABdhPJzr/nnLhZ3W+Q8uFW3csw7pQrugRV7/C0yjW6uzavyTGsWAcW+jPCvAnslM6oYD3QTYy5FEFjQ4dN/yvvU1Tls=
X-Received: by 2002:ac8:6c3c:: with SMTP id k28mr1923851qtu.290.1614333524212;
 Fri, 26 Feb 2021 01:58:44 -0800 (PST)
MIME-Version: 1.0
References: <0000000000000427db05bc3a2be3@google.com>
In-Reply-To: <0000000000000427db05bc3a2be3@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 26 Feb 2021 10:58:33 +0100
Message-ID: <CACT4Y+bcco9QYhuOFfJx+Ur_Q4Cq5S41abps-GVK6+QymEaQ+w@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in __cpuhp_state_remove_instance
To:     syzbot <syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, qais.yousef@arm.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 26, 2021 at 10:48 AM syzbot
<syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    d01f2f7e Add linux-next specific files for 20210226
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1750e9b0d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
> dashboard link: https://syzkaller.appspot.com/bug?extid=38769495e847cea2dcca
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com

looks like an issue in io_uring
+io_uring maintainers

> ==================================================================
> BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:835 [inline]
> BUG: KASAN: use-after-free in hlist_del include/linux/list.h:852 [inline]
> BUG: KASAN: use-after-free in __cpuhp_state_remove_instance+0x58b/0x5b0 kernel/cpu.c:2002
> Read of size 8 at addr ffff88801582fb98 by task syz-executor.5/15523
>
> CPU: 1 PID: 15523 Comm: syz-executor.5 Not tainted 5.11.0-next-20210226-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xfa/0x151 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
>  __kasan_report mm/kasan/report.c:399 [inline]
>  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
>  __hlist_del include/linux/list.h:835 [inline]
>  hlist_del include/linux/list.h:852 [inline]
>  __cpuhp_state_remove_instance+0x58b/0x5b0 kernel/cpu.c:2002
>  cpuhp_state_remove_instance_nocalls include/linux/cpuhotplug.h:407 [inline]
>  io_wq_create+0x6ca/0xbf0 fs/io-wq.c:1056
>  io_init_wq_offload fs/io_uring.c:7792 [inline]
>  io_uring_alloc_task_context+0x1bf/0x6a0 fs/io_uring.c:7811
>  io_uring_add_task_file+0x261/0x350 fs/io_uring.c:8773
>  io_uring_install_fd fs/io_uring.c:9381 [inline]
>  io_uring_create fs/io_uring.c:9532 [inline]
>  io_uring_setup+0x14c7/0x2be0 fs/io_uring.c:9571
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x465ef9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7ba953b108 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 000000000056c0b0 RCX: 0000000000465ef9
> RDX: 0000000020ffb000 RSI: 0000000020000080 RDI: 00000000000050bb
> RBP: 0000000020000080 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000020000000 R11: 0000000000000202 R12: 0000000000000000
> R13: 0000000020ffb000 R14: 0000000020000000 R15: 0000000020ee7000
>
> Allocated by task 15523:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:427 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:506 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:465 [inline]
>  __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
>  kmalloc include/linux/slab.h:554 [inline]
>  kzalloc include/linux/slab.h:684 [inline]
>  io_wq_create+0xc0/0xbf0 fs/io-wq.c:1002
>  io_init_wq_offload fs/io_uring.c:7792 [inline]
>  io_uring_alloc_task_context+0x1bf/0x6a0 fs/io_uring.c:7811
>  io_uring_add_task_file+0x261/0x350 fs/io_uring.c:8773
>  io_uring_install_fd fs/io_uring.c:9381 [inline]
>  io_uring_create fs/io_uring.c:9532 [inline]
>  io_uring_setup+0x14c7/0x2be0 fs/io_uring.c:9571
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Freed by task 15523:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
>  ____kasan_slab_free mm/kasan/common.c:360 [inline]
>  ____kasan_slab_free mm/kasan/common.c:325 [inline]
>  __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
>  kasan_slab_free include/linux/kasan.h:199 [inline]
>  slab_free_hook mm/slub.c:1562 [inline]
>  slab_free_freelist_hook+0x72/0x1b0 mm/slub.c:1600
>  slab_free mm/slub.c:3161 [inline]
>  kfree+0xe5/0x7b0 mm/slub.c:4213
>  io_wq_destroy fs/io-wq.c:1091 [inline]
>  io_wq_put+0x4d0/0x6d0 fs/io-wq.c:1098
>  io_wq_create+0x92d/0xbf0 fs/io-wq.c:1053
>  io_init_wq_offload fs/io_uring.c:7792 [inline]
>  io_uring_alloc_task_context+0x1bf/0x6a0 fs/io_uring.c:7811
>  io_uring_add_task_file+0x261/0x350 fs/io_uring.c:8773
>  io_uring_install_fd fs/io_uring.c:9381 [inline]
>  io_uring_create fs/io_uring.c:9532 [inline]
>  io_uring_setup+0x14c7/0x2be0 fs/io_uring.c:9571
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  insert_work+0x48/0x370 kernel/workqueue.c:1331
>  __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
>  queue_work_on+0xae/0xc0 kernel/workqueue.c:1524
>  queue_work include/linux/workqueue.h:507 [inline]
>  netdevice_queue_work drivers/infiniband/core/roce_gid_mgmt.c:658 [inline]
>  netdevice_event+0x3aa/0x720 drivers/infiniband/core/roce_gid_mgmt.c:801
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2063
>  call_netdevice_notifiers_extack net/core/dev.c:2075 [inline]
>  call_netdevice_notifiers net/core/dev.c:2089 [inline]
>  unregister_netdevice_many+0x942/0x1760 net/core/dev.c:10905
>  default_device_exit_batch+0x2fa/0x3c0 net/core/dev.c:11425
>  ops_exit_list+0x10d/0x160 net/core/net_namespace.c:178
>  cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  insert_work+0x48/0x370 kernel/workqueue.c:1331
>  __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
>  queue_work_on+0xae/0xc0 kernel/workqueue.c:1524
>  queue_work include/linux/workqueue.h:507 [inline]
>  call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:433
>  kobject_uevent_env+0xf9f/0x1680 lib/kobject_uevent.c:617
>  rx_queue_add_kobject net/core/net-sysfs.c:1020 [inline]
>  net_rx_queue_update_kobjects+0xee/0x450 net/core/net-sysfs.c:1060
>  register_queue_kobjects net/core/net-sysfs.c:1742 [inline]
>  netdev_register_kobject+0x275/0x430 net/core/net-sysfs.c:1990
>  register_netdevice+0xd33/0x14a0 net/core/dev.c:10178
>  __ip_tunnel_create+0x398/0x5c0 net/ipv4/ip_tunnel.c:267
>  ip_tunnel_init_net+0x330/0x9c0 net/ipv4/ip_tunnel.c:1061
>  vti_init_net+0x2a/0x360 net/ipv4/ip_vti.c:501
>  ops_init+0xaf/0x470 net/core/net_namespace.c:140
>  setup_net+0x40f/0xa30 net/core/net_namespace.c:333
>  copy_net_ns+0x31e/0x760 net/core/net_namespace.c:474
>  create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
>  copy_namespaces+0x385/0x440 kernel/nsproxy.c:178
>  copy_process+0x2ab5/0x6fd0 kernel/fork.c:2100
>  kernel_clone+0xe7/0xab0 kernel/fork.c:2462
>  __do_sys_clone+0xc8/0x110 kernel/fork.c:2579
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff88801582fb00
>  which belongs to the cache kmalloc-192 of size 192
> The buggy address is located 152 bytes inside of
>  192-byte region [ffff88801582fb00, ffff88801582fbc0)
> The buggy address belongs to the page:
> page:000000007dcd9156 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1582f
> flags: 0xfff00000000200(slab)
> raw: 00fff00000000200 ffffea000071b7c0 0000000400000004 ffff888010841a00
> raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff88801582fa80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff88801582fb00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88801582fb80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                             ^
>  ffff88801582fc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88801582fc80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000000427db05bc3a2be3%40google.com.
