Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C549557C21F
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 04:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiGUCKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 22:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiGUCKi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 22:10:38 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B76824BC5;
        Wed, 20 Jul 2022 19:10:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id os14so720541ejb.4;
        Wed, 20 Jul 2022 19:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=uEOHu+xKykAxWq5tYkrOEq+maV+Jh/3IC5GxwTANRrY=;
        b=HShmJ87V4PLj0iz7+qOJynPobLfslfT1bcMYD1eZaypvvg/IuVQBkc4bqWru2hk0cU
         DKU9jYXddxnEW1W2wfCZ9luuQnkiYTvZSFvJlKpPCbwUalmNH9Qa8K4gePghprveFEse
         FB+n6+c8wdSWuVTukZxFBDjz9NyzBy+nKckW7yD/UvnSttg2WrcfmOGUkpFQcU7CmrEn
         PUv4Xwob2yEdnpjQ6fwoiKXd7NMqOH691kLmBBjwtWjmMSoDM1+JMwKfPuklNe/U1oym
         toamVen3QuHwp+FNlpIOnpKKVYhiDJMVIYlrmlJtLWgonRh4jquhmXCzTIn9+a8g+tul
         UUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=uEOHu+xKykAxWq5tYkrOEq+maV+Jh/3IC5GxwTANRrY=;
        b=S8ZXYTYJ0X8tyTkI+zvZh0bUlym/AEQx6anHocgLrSm6fFDN5euFrocVIJoApSetiO
         h01862gaHJxS8mKN5WodBjdQ5oTEnI1YBRdiqX37i8hAEIGdvCaLy3JXZ0+JJvreZRQC
         tMXJHfYgg6cdrdi7NloQE9rvCipfntv9Z9nvdq22AebLrmGe6wDZcM90/QZEuHCs4kNx
         BKp6IPnreqMjcJnZmJPSsQE+TGVa6K4HPfGwLUgEBS6nQeRwCGwsmi4lNAnnjV0RBLxn
         GxFyVdvBr3/Lv9SczwKksDuVgwIbzUITGXKxYx/dW/BjsPj/wgD/0TND4SzVRfZK7eRs
         B84w==
X-Gm-Message-State: AJIora8SXMvugWkZL+EUulJmSWLNR1KYncwOrqCjRAcl93QTWUP2c3zQ
        CD0BOiZ4k+0EnjOmcJ8tELNgm7F1vsZ/erYKUx4=
X-Google-Smtp-Source: AGRyM1trvP0aFypq7ADOK60yqn5uERjZcj8ii4jHy0TY8128YU10J5jiLzZlqeElddXTuryQovv1/EBAOSghoodGQwM=
X-Received: by 2002:a17:907:271b:b0:72b:64f0:e508 with SMTP id
 w27-20020a170907271b00b0072b64f0e508mr39283523ejk.275.1658369434807; Wed, 20
 Jul 2022 19:10:34 -0700 (PDT)
MIME-Version: 1.0
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Wed, 20 Jul 2022 19:10:23 -0700
Message-ID: <CANX2M5bXKw1NaHdHNVqssUUaBCs8aBpmzRNVEYEvV0n44P7ioA@mail.gmail.com>
Subject: KASAN: invalid-free in __io_uring_register
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
Content-Type: multipart/mixed; boundary="00000000000011b8bd05e447396c"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--00000000000011b8bd05e447396c
Content-Type: text/plain; charset="UTF-8"

Hi,

We would like to report the following bug which has been found by our
modified version of syzkaller.

======================================================
description: KASAN: invalid-free in __io_uring_register
affected file: fs/io_uring.c
kernel version: 5.19-rc6
kernel commit: 32346491ddf24599decca06190ebca03ff9de7f8
git tree: upstream
kernel config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=cd73026ceaed1402
crash reproducer: attached
======================================================
Crash log:
======================================================
BUG: KASAN: double-free or invalid-free in io_register_pbuf_ring
fs/io_uring.c:12975 [inline]
BUG: KASAN: double-free or invalid-free in
__io_uring_register+0x16aa/0x19d0 fs/io_uring.c:13151

CPU: 1 PID: 16619 Comm: syz-executor.4 Tainted: G           OE
5.19.0-rc6-g2eae0556bb9d #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:313 [inline]
 print_report.cold+0xe5/0x659 mm/kasan/report.c:429
 kasan_report_invalid_free+0x5c/0x160 mm/kasan/report.c:458
 ____kasan_slab_free mm/kasan/common.c:351 [inline]
 __kasan_slab_free+0x182/0x1a0 mm/kasan/common.c:379
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1754 [inline]
 slab_free_freelist_hook mm/slub.c:1780 [inline]
 slab_free mm/slub.c:3536 [inline]
 kfree+0xec/0x4b0 mm/slub.c:4584
 io_register_pbuf_ring fs/io_uring.c:12975 [inline]
 __io_uring_register+0x16aa/0x19d0 fs/io_uring.c:13151
 __do_sys_io_uring_register fs/io_uring.c:13187 [inline]
 __se_sys_io_uring_register fs/io_uring.c:13167 [inline]
 __x64_sys_io_uring_register+0x2f2/0x650 fs/io_uring.c:13167
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f7aa1a8d4ed
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7aa2b31be8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f7aa1babf60 RCX: 00007f7aa1a8d4ed
RDX: 0000000020000000 RSI: 0000000000000016 RDI: 0000000000000006
RBP: 00007f7aa1af92e1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff95597e6f R14: 00007f7aa1babf60 R15: 00007f7aa2b31d80
 </TASK>

Allocated by task 16619:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:39
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:441 [inline]
 ____kasan_kmalloc mm/kasan/common.c:526 [inline]
 ____kasan_kmalloc mm/kasan/common.c:479 [inline]
 __kasan_kmalloc+0xb5/0xe0 mm/kasan/common.c:535
 kasan_kmalloc include/linux/kasan.h:234 [inline]
 __kmalloc+0x1c9/0x4c0 mm/slub.c:4446
 kcalloc include/linux/slab.h:671 [inline]
 io_init_bl_list.isra.0+0x24/0x102 fs/io_uring.c:5703
 io_register_pbuf_ring fs/io_uring.c:12955 [inline]
 __io_uring_register.cold+0xd/0x10b5 fs/io_uring.c:13151
 __do_sys_io_uring_register fs/io_uring.c:13187 [inline]
 __se_sys_io_uring_register fs/io_uring.c:13167 [inline]
 __x64_sys_io_uring_register+0x2f2/0x650 fs/io_uring.c:13167
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:39
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:356
 call_rcu kernel/rcu/tree.c:3126 [inline]
 call_rcu+0x99/0x740 kernel/rcu/tree.c:3101
 netlink_release+0xe42/0x1cb0 net/netlink/af_netlink.c:815
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xe0/0x1a0 kernel/task_work.c:177
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x253/0x260 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:39
 __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:356
 call_rcu kernel/rcu/tree.c:3126 [inline]
 call_rcu+0x99/0x740 kernel/rcu/tree.c:3101
 netlink_release+0xe42/0x1cb0 net/netlink/af_netlink.c:815
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xe0/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb1e/0x2dd0 kernel/exit.c:797
 do_group_exit+0xd2/0x2f0 kernel/exit.c:927
 get_signal+0x2842/0x2870 kernel/signal.c:2857
 arch_do_signal_or_restart+0x82/0x2270 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x174/0x260 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 ret_from_fork+0x15/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff88815f2b7000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 256 bytes inside of
 2048-byte region [ffff88815f2b7000, ffff88815f2b7800)

The buggy address belongs to the physical page:
page:ffffea00057cac00 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x15f2b0
head:ffffea00057cac00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x17ff00000010200(slab|head|node=0|zone=2|lastcpupid=0x7ff)
raw: 017ff00000010200 dead000000000100 dead000000000122 ffff888100042000
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0xd2a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 6687, tgid 6687 (syz-executor.3), ts 55285345771, free_ts
54261940067
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook mm/page_alloc.c:2449 [inline]
 prep_new_page+0x297/0x330 mm/page_alloc.c:2456
 get_page_from_freelist+0x2142/0x3c80 mm/page_alloc.c:4198
 __alloc_pages+0x321/0x710 mm/page_alloc.c:5426
 alloc_pages+0x119/0x250 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1824 [inline]
 allocate_slab mm/slub.c:1969 [inline]
 new_slab+0x2a9/0x3f0 mm/slub.c:2029
 ___slab_alloc+0xd5a/0x1140 mm/slub.c:3031
 __slab_alloc.isra.0+0x4d/0xa0 mm/slub.c:3118
 slab_alloc_node mm/slub.c:3209 [inline]
 __kmalloc_node_track_caller+0x321/0x440 mm/slub.c:4979
 kmalloc_reserve+0x32/0xd0 net/core/skbuff.c:354
 __alloc_skb+0x11f/0x370 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1426 [inline]
 nlmsg_new include/net/netlink.h:953 [inline]
 inet6_ifinfo_notify+0x72/0x150 net/ipv6/addrconf.c:6039
 addrconf_notify+0x49b/0x1bb0 net/ipv6/addrconf.c:3653
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info net/core/dev.c:1945 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1930
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 __dev_notify_flags+0x121/0x2c0 net/core/dev.c:8571
 dev_change_flags+0x112/0x170 net/core/dev.c:8609
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1371 [inline]
 free_pcp_prepare+0x51f/0xd00 mm/page_alloc.c:1421
 free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 free_unref_page+0x19/0x5b0 mm/page_alloc.c:3438
 __vunmap+0x6ff/0xaa0 mm/vmalloc.c:2665
 __vfree+0x3c/0xd0 mm/vmalloc.c:2713
 vfree+0x5a/0x90 mm/vmalloc.c:2744
 kcov_put kernel/kcov.c:421 [inline]
 kcov_put+0x26/0x40 kernel/kcov.c:417
 kcov_close+0xc/0x10 kernel/kcov.c:517
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xe0/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb1e/0x2dd0 kernel/exit.c:797
 do_group_exit+0xd2/0x2f0 kernel/exit.c:927
 __do_sys_exit_group kernel/exit.c:938 [inline]
 __se_sys_exit_group kernel/exit.c:936 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:936
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Memory state around the buggy address:
 ffff88815f2b7000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88815f2b7080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88815f2b7100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                   ^
 ffff88815f2b7180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88815f2b7200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

-- 
Thanks and Regards,

Dipanjan

--00000000000011b8bd05e447396c
Content-Type: application/octet-stream; name="repro.syz"
Content-Disposition: attachment; filename="repro.syz"
Content-Transfer-Encoding: base64
Content-ID: <f_l5ue9jt91>
X-Attachment-Id: f_l5ue9jt91

c2V0c29ja29wdCRwYWNrZXRfcnhfcmluZygweGZmZmZmZmZmZmZmZmZmZmYsIDB4MTA3LCAweDUs
ICYoMHg3ZjAwMDAwMDAwMDApPUByZXE9ezB4MCwgMHgyLCAweDgsIDB4OH0sIDB4MTApCnIwID0g
aW9fdXJpbmdfc2V0dXAoMHgxMjI0LCAmKDB4N2YwMDAwMDAwMjgwKSkKcjEgPSBpb191cmluZ19z
ZXR1cCgweDEyMjQsICYoMHg3ZjAwMDAwMDAyODApKQpyMiA9IGlvX3VyaW5nX3JlZ2lzdGVyJElP
UklOR19SRUdJU1RFUl9QRVJTT05BTElUWShyMSwgMHg5LCAweDAsIDB4MCkKaW9fdXJpbmdfcmVn
aXN0ZXIkSU9SSU5HX1VOUkVHSVNURVJfUEVSU09OQUxJVFkocjAsIDB4MTYsIDB4MjAwMDAwMDAs
IHIyKQo=
--00000000000011b8bd05e447396c
Content-Type: text/x-csrc; charset="US-ASCII"; name="repro.c"
Content-Disposition: attachment; filename="repro.c"
Content-Transfer-Encoding: base64
Content-ID: <f_l5ue9jsl0>
X-Attachment-Id: f_l5ue9jsl0

Ly8gYXV0b2dlbmVyYXRlZCBieSBzeXprYWxsZXIgKGh0dHBzOi8vZ2l0aHViLmNvbS9nb29nbGUv
c3l6a2FsbGVyKQoKI2RlZmluZSBfR05VX1NPVVJDRSAKCiNpbmNsdWRlIDxlbmRpYW4uaD4KI2lu
Y2x1ZGUgPHN0ZGludC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgoj
aW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvc3lzY2FsbC5oPgojaW5jbHVkZSA8c3lz
L3R5cGVzLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCiNpZm5kZWYgX19OUl9pb191cmluZ19yZWdp
c3RlcgojZGVmaW5lIF9fTlJfaW9fdXJpbmdfcmVnaXN0ZXIgNDI3CiNlbmRpZgojaWZuZGVmIF9f
TlJfaW9fdXJpbmdfc2V0dXAKI2RlZmluZSBfX05SX2lvX3VyaW5nX3NldHVwIDQyNQojZW5kaWYK
CnVpbnQ2NF90IHJbM10gPSB7MHhmZmZmZmZmZmZmZmZmZmZmLCAweGZmZmZmZmZmZmZmZmZmZmYs
IDB4MH07CgppbnQgbWFpbih2b2lkKQp7CgkJc3lzY2FsbChfX05SX21tYXAsIDB4MWZmZmYwMDB1
bCwgMHgxMDAwdWwsIDB1bCwgMHgzMnVsLCAtMSwgMHVsKTsKCXN5c2NhbGwoX19OUl9tbWFwLCAw
eDIwMDAwMDAwdWwsIDB4MTAwMDAwMHVsLCA3dWwsIDB4MzJ1bCwgLTEsIDB1bCk7CglzeXNjYWxs
KF9fTlJfbW1hcCwgMHgyMTAwMDAwMHVsLCAweDEwMDB1bCwgMHVsLCAweDMydWwsIC0xLCAwdWwp
OwoJCQkJaW50cHRyX3QgcmVzID0gMDsKKih1aW50MzJfdCopMHgyMDAwMDAwMCA9IDA7CioodWlu
dDMyX3QqKTB4MjAwMDAwMDQgPSAyOwoqKHVpbnQzMl90KikweDIwMDAwMDA4ID0gODsKKih1aW50
MzJfdCopMHgyMDAwMDAwYyA9IDg7CglzeXNjYWxsKF9fTlJfc2V0c29ja29wdCwgLTEsIDB4MTA3
LCA1LCAweDIwMDAwMDAwdWwsIDB4MTB1bCk7CioodWludDMyX3QqKTB4MjAwMDAyODQgPSAwOwoq
KHVpbnQzMl90KikweDIwMDAwMjg4ID0gMDsKKih1aW50MzJfdCopMHgyMDAwMDI4YyA9IDA7Cioo
dWludDMyX3QqKTB4MjAwMDAyOTAgPSAwOwoqKHVpbnQzMl90KikweDIwMDAwMjk4ID0gLTE7Cm1l
bXNldCgodm9pZCopMHgyMDAwMDI5YywgMCwgMTIpOwoJcmVzID0gc3lzY2FsbChfX05SX2lvX3Vy
aW5nX3NldHVwLCAweDEyMjQsIDB4MjAwMDAyODB1bCk7CglpZiAocmVzICE9IC0xKQoJCXJbMF0g
PSByZXM7CioodWludDMyX3QqKTB4MjAwMDAyODQgPSAwOwoqKHVpbnQzMl90KikweDIwMDAwMjg4
ID0gMDsKKih1aW50MzJfdCopMHgyMDAwMDI4YyA9IDA7CioodWludDMyX3QqKTB4MjAwMDAyOTAg
PSAwOwoqKHVpbnQzMl90KikweDIwMDAwMjk4ID0gLTE7Cm1lbXNldCgodm9pZCopMHgyMDAwMDI5
YywgMCwgMTIpOwoJcmVzID0gc3lzY2FsbChfX05SX2lvX3VyaW5nX3NldHVwLCAweDEyMjQsIDB4
MjAwMDAyODB1bCk7CglpZiAocmVzICE9IC0xKQoJCXJbMV0gPSByZXM7CglyZXMgPSBzeXNjYWxs
KF9fTlJfaW9fdXJpbmdfcmVnaXN0ZXIsIHJbMV0sIDl1bCwgMHVsLCAwdWwpOwoJaWYgKHJlcyAh
PSAtMSkKCQlyWzJdID0gcmVzOwoJc3lzY2FsbChfX05SX2lvX3VyaW5nX3JlZ2lzdGVyLCByWzBd
LCAweDE2dWwsIDB4MjAwMDAwMDB1bCwgclsyXSk7CglyZXR1cm4gMDsKfQo=
--00000000000011b8bd05e447396c--
