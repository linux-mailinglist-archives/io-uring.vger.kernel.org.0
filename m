Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDEB57C1E8
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 03:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiGUBlq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 21:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGUBlp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 21:41:45 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC08E75398;
        Wed, 20 Jul 2022 18:41:43 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ez10so545247ejc.13;
        Wed, 20 Jul 2022 18:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=pUrCXbfhcBUz3EJjqmeyCg+nUyFVTAVtvr4LlHASwxs=;
        b=J/Qyham62xa7tKomkR/ur1B7Kg9kpHOLSorf2CfFLzXvWqLd2mH9pwq2IXXtk7Mngw
         Jm3QtXg+6JFS8zZkgQMfIbjBEW8o2vIfcT3zFfFKYXC79meSRZJSGFxqv4I7BmFV6sub
         0AliuMohSnZ35/t0gJf3mHD0SPCdmWwAouMOxDts1g4sm+tNO3JnGLN0ybOTKiqw3jyJ
         JJ7gc/9YVDy15INPlS2pe8IEYUkchFXjDSiUFeMv8nNYtT0/WpzmdqFMs7YHw2lUZ537
         Cm0MrrP+k8cTOYEP8E2DiXAO1teEt6wgQjE7IO51hwcUxcVeU8JvCmZU8BWBWP4KiRKe
         wAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=pUrCXbfhcBUz3EJjqmeyCg+nUyFVTAVtvr4LlHASwxs=;
        b=dq67tjOEgBRwLijy6RppoI1sTkpxcVnKGNTWTgERAA1b1AmwnJboQZWLMCj3hGoUq/
         h0QFiiqLEIoCTXvguePnFx6SCRBpiohi0kyP3zMOKvbRdQoP+whDT2xKb5UngRRv2DKZ
         F0uM0jv78MJh4AcbufiwxZfFso0+8TCZN3FBKszK6BGW6eOcPpdXEvaQ1fDarsN0xLy5
         Bcxf00fMb3OCqr9etti3WTpWilcqXUZN6f1d9Av+U8sMTWS2yj2rVXNED+l7eGCL3Zpz
         IYRNo/o5PThPXk8G8cbckiB2qqzaowb0ooho68UbFcqpuU9PivDBRzPGBSHXZdRlIOet
         DHcQ==
X-Gm-Message-State: AJIora/wH85wPdT31YTW9aoTZd5jbxEpaN6Q4cpUX60mofj/cQ5a86Sf
        xkQMa9iDKnPj3HSMs+DPBbvuvwTDzMyYNyWxc0PcNPHd22khE3FE
X-Google-Smtp-Source: AGRyM1tHr5WCqslOl3nG5TB9B+x5ZpiUQVu6yTE4V1GjKAr5p/ac3Po4Bwc2kTZfzjRh9NuPHRAAtT53B6dO0eepZgI=
X-Received: by 2002:a17:907:a05b:b0:72b:33f9:f927 with SMTP id
 gz27-20020a170907a05b00b0072b33f9f927mr38427301ejc.707.1658367702525; Wed, 20
 Jul 2022 18:41:42 -0700 (PDT)
MIME-Version: 1.0
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Wed, 20 Jul 2022 18:41:31 -0700
Message-ID: <CANX2M5YiZBXU3L6iwnaLs-HHJXRvrxM8mhPDiMDF9Y9sAvOHUA@mail.gmail.com>
Subject: KASAN: use-after-free Read in __io_remove_buffers
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
Content-Type: multipart/mixed; boundary="000000000000d1298b05e446d1cb"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000d1298b05e446d1cb
Content-Type: text/plain; charset="UTF-8"

Hi,

We would like to report the following bug which has been found by our
modified version of syzkaller.

======================================================
description: KASAN: use-after-free Read in __io_remove_buffers
affected file: fs/io_uring.c
kernel version: 5.19-rc6
kernel commit: 32346491ddf24599decca06190ebca03ff9de7f8
git tree: upstream
kernel config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=cd73026ceaed1402
crash reproducer: attached
======================================================
Crash log:
======================================================
BUG: KASAN: use-after-free in __io_remove_buffers.isra.0+0x401/0x530
fs/io_uring.c:5540
Read of size 2 at addr ffff88812e562012 by task kworker/u4:9/3708

CPU: 0 PID: 3708 Comm: kworker/u4:9 Tainted: G           OE
5.19.0-rc6-g2eae0556bb9d #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:313 [inline]
 print_report.cold+0xe5/0x659 mm/kasan/report.c:429
 kasan_report+0x8a/0x1b0 mm/kasan/report.c:491
 __io_remove_buffers.isra.0+0x401/0x530 fs/io_uring.c:5540
 io_destroy_buffers fs/io_uring.c:11077 [inline]
 io_ring_ctx_free fs/io_uring.c:11159 [inline]
 io_ring_exit_work+0x9a2/0xf4b fs/io_uring.c:11338
 process_one_work+0x9cc/0x1650 kernel/workqueue.c:2289
 worker_thread+0x623/0x1070 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>

Allocated by task 10568:
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

Freed by task 10568:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:39
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:378
 ____kasan_slab_free mm/kasan/common.c:371 [inline]
 ____kasan_slab_free mm/kasan/common.c:329 [inline]
 __kasan_slab_free+0x12b/0x1a0 mm/kasan/common.c:379
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
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

The buggy address belongs to the object at ffff88812e562000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 18 bytes inside of
 2048-byte region [ffff88812e562000, ffff88812e562800)

The buggy address belongs to the physical page:
page:ffffea0004b95800 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x12e560
head:ffffea0004b95800 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x17ff00000010200(slab|head|node=0|zone=2|lastcpupid=0x7ff)
raw: 017ff00000010200 ffffea0005da9600 dead000000000002 ffff888100042000
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask
0xd28c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 6706, tgid 6706 (syz-executor.4), ts 116920478716, free_ts 0
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
 pskb_expand_head+0x148/0x1060 net/core/skbuff.c:1695
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1301
 netlink_broadcast+0x5b/0xd00 net/netlink/af_netlink.c:1497
 nlmsg_multicast include/net/netlink.h:1033 [inline]
 nlmsg_notify+0x8f/0x280 net/netlink/af_netlink.c:2544
 rtnl_notify net/core/rtnetlink.c:767 [inline]
 rtmsg_ifinfo_send net/core/rtnetlink.c:3928 [inline]
 rtmsg_ifinfo_event.part.0+0xb6/0xe0 net/core/rtnetlink.c:3943
 rtmsg_ifinfo_event net/core/rtnetlink.c:6147 [inline]
 rtnetlink_event+0x11e/0x150 net/core/rtnetlink.c:6140
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88812e561f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88812e561f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88812e562000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff88812e562080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88812e562100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

-- 
Thanks and Regards,

Dipanjan

--000000000000d1298b05e446d1cb
Content-Type: text/x-csrc; charset="US-ASCII"; name="repro.c"
Content-Disposition: attachment; filename="repro.c"
Content-Transfer-Encoding: base64
Content-ID: <f_l5ud7b450>
X-Attachment-Id: f_l5ud7b450

Ly8gYXV0b2dlbmVyYXRlZCBieSBzeXprYWxsZXIgKGh0dHBzOi8vZ2l0aHViLmNvbS9nb29nbGUv
c3l6a2FsbGVyKQoKI2RlZmluZSBfR05VX1NPVVJDRSAKCiNpbmNsdWRlIDxkaXJlbnQuaD4KI2lu
Y2x1ZGUgPGVuZGlhbi5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNp
bmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzZXRqbXAuaD4KI2luY2x1ZGUgPHNpZ25hbC5o
PgojaW5jbHVkZSA8c3RkYXJnLmg+CiNpbmNsdWRlIDxzdGRib29sLmg+CiNpbmNsdWRlIDxzdGRp
bnQuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0
cmluZy5oPgojaW5jbHVkZSA8c3lzL3ByY3RsLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5j
bHVkZSA8c3lzL3N5c2NhbGwuaD4KI2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3lz
L3dhaXQuaD4KI2luY2x1ZGUgPHRpbWUuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoKI2luY2x1ZGUg
PGxpbnV4L2Z1dGV4Lmg+CgojaWZuZGVmIF9fTlJfaW9fdXJpbmdfcmVnaXN0ZXIKI2RlZmluZSBf
X05SX2lvX3VyaW5nX3JlZ2lzdGVyIDQyNwojZW5kaWYKI2lmbmRlZiBfX05SX2lvX3VyaW5nX3Nl
dHVwCiNkZWZpbmUgX19OUl9pb191cmluZ19zZXR1cCA0MjUKI2VuZGlmCgpzdGF0aWMgX190aHJl
YWQgaW50IGNsb25lX29uZ29pbmc7CnN0YXRpYyBfX3RocmVhZCBpbnQgc2tpcF9zZWd2OwpzdGF0
aWMgX190aHJlYWQgam1wX2J1ZiBzZWd2X2VudjsKCnN0YXRpYyB2b2lkIHNlZ3ZfaGFuZGxlcihp
bnQgc2lnLCBzaWdpbmZvX3QqIGluZm8sIHZvaWQqIGN0eCkKewoJaWYgKF9fYXRvbWljX2xvYWRf
bigmY2xvbmVfb25nb2luZywgX19BVE9NSUNfUkVMQVhFRCkgIT0gMCkgewoJCWV4aXQoc2lnKTsK
CX0KCXVpbnRwdHJfdCBhZGRyID0gKHVpbnRwdHJfdClpbmZvLT5zaV9hZGRyOwoJY29uc3QgdWlu
dHB0cl90IHByb2dfc3RhcnQgPSAxIDw8IDIwOwoJY29uc3QgdWludHB0cl90IHByb2dfZW5kID0g
MTAwIDw8IDIwOwoJaW50IHNraXAgPSBfX2F0b21pY19sb2FkX24oJnNraXBfc2VndiwgX19BVE9N
SUNfUkVMQVhFRCkgIT0gMDsKCWludCB2YWxpZCA9IGFkZHIgPCBwcm9nX3N0YXJ0IHx8IGFkZHIg
PiBwcm9nX2VuZDsKCWlmIChza2lwICYmIHZhbGlkKSB7CgkJX2xvbmdqbXAoc2Vndl9lbnYsIDEp
OwoJfQoJZXhpdChzaWcpOwp9CgpzdGF0aWMgdm9pZCBpbnN0YWxsX3NlZ3ZfaGFuZGxlcih2b2lk
KQp7CglzdHJ1Y3Qgc2lnYWN0aW9uIHNhOwoJbWVtc2V0KCZzYSwgMCwgc2l6ZW9mKHNhKSk7Cglz
YS5zYV9oYW5kbGVyID0gU0lHX0lHTjsKCXN5c2NhbGwoU1lTX3J0X3NpZ2FjdGlvbiwgMHgyMCwg
JnNhLCBOVUxMLCA4KTsKCXN5c2NhbGwoU1lTX3J0X3NpZ2FjdGlvbiwgMHgyMSwgJnNhLCBOVUxM
LCA4KTsKCW1lbXNldCgmc2EsIDAsIHNpemVvZihzYSkpOwoJc2Euc2Ffc2lnYWN0aW9uID0gc2Vn
dl9oYW5kbGVyOwoJc2Euc2FfZmxhZ3MgPSBTQV9OT0RFRkVSIHwgU0FfU0lHSU5GTzsKCXNpZ2Fj
dGlvbihTSUdTRUdWLCAmc2EsIE5VTEwpOwoJc2lnYWN0aW9uKFNJR0JVUywgJnNhLCBOVUxMKTsK
fQoKI2RlZmluZSBOT05GQUlMSU5HKC4uLikgKHsgaW50IG9rID0gMTsgX19hdG9taWNfZmV0Y2hf
YWRkKCZza2lwX3NlZ3YsIDEsIF9fQVRPTUlDX1NFUV9DU1QpOyBpZiAoX3NldGptcChzZWd2X2Vu
dikgPT0gMCkgeyBfX1ZBX0FSR1NfXzsgfSBlbHNlIG9rID0gMDsgX19hdG9taWNfZmV0Y2hfc3Vi
KCZza2lwX3NlZ3YsIDEsIF9fQVRPTUlDX1NFUV9DU1QpOyBvazsgfSkKCnN0YXRpYyB2b2lkIHNs
ZWVwX21zKHVpbnQ2NF90IG1zKQp7Cgl1c2xlZXAobXMgKiAxMDAwKTsKfQoKc3RhdGljIHVpbnQ2
NF90IGN1cnJlbnRfdGltZV9tcyh2b2lkKQp7CglzdHJ1Y3QgdGltZXNwZWMgdHM7CglpZiAoY2xv
Y2tfZ2V0dGltZShDTE9DS19NT05PVE9OSUMsICZ0cykpCglleGl0KDEpOwoJcmV0dXJuICh1aW50
NjRfdCl0cy50dl9zZWMgKiAxMDAwICsgKHVpbnQ2NF90KXRzLnR2X25zZWMgLyAxMDAwMDAwOwp9
CgpzdGF0aWMgdm9pZCB0aHJlYWRfc3RhcnQodm9pZCogKCpmbikodm9pZCopLCB2b2lkKiBhcmcp
CnsKCXB0aHJlYWRfdCB0aDsKCXB0aHJlYWRfYXR0cl90IGF0dHI7CglwdGhyZWFkX2F0dHJfaW5p
dCgmYXR0cik7CglwdGhyZWFkX2F0dHJfc2V0c3RhY2tzaXplKCZhdHRyLCAxMjggPDwgMTApOwoJ
aW50IGkgPSAwOwoJZm9yICg7IGkgPCAxMDA7IGkrKykgewoJCWlmIChwdGhyZWFkX2NyZWF0ZSgm
dGgsICZhdHRyLCBmbiwgYXJnKSA9PSAwKSB7CgkJCXB0aHJlYWRfYXR0cl9kZXN0cm95KCZhdHRy
KTsKCQkJcmV0dXJuOwoJCX0KCQlpZiAoZXJybm8gPT0gRUFHQUlOKSB7CgkJCXVzbGVlcCg1MCk7
CgkJCWNvbnRpbnVlOwoJCX0KCQlicmVhazsKCX0KCWV4aXQoMSk7Cn0KCnR5cGVkZWYgc3RydWN0
IHsKCWludCBzdGF0ZTsKfSBldmVudF90OwoKc3RhdGljIHZvaWQgZXZlbnRfaW5pdChldmVudF90
KiBldikKewoJZXYtPnN0YXRlID0gMDsKfQoKc3RhdGljIHZvaWQgZXZlbnRfcmVzZXQoZXZlbnRf
dCogZXYpCnsKCWV2LT5zdGF0ZSA9IDA7Cn0KCnN0YXRpYyB2b2lkIGV2ZW50X3NldChldmVudF90
KiBldikKewoJaWYgKGV2LT5zdGF0ZSkKCWV4aXQoMSk7CglfX2F0b21pY19zdG9yZV9uKCZldi0+
c3RhdGUsIDEsIF9fQVRPTUlDX1JFTEVBU0UpOwoJc3lzY2FsbChTWVNfZnV0ZXgsICZldi0+c3Rh
dGUsIEZVVEVYX1dBS0UgfCBGVVRFWF9QUklWQVRFX0ZMQUcsIDEwMDAwMDApOwp9CgpzdGF0aWMg
dm9pZCBldmVudF93YWl0KGV2ZW50X3QqIGV2KQp7Cgl3aGlsZSAoIV9fYXRvbWljX2xvYWRfbigm
ZXYtPnN0YXRlLCBfX0FUT01JQ19BQ1FVSVJFKSkKCQlzeXNjYWxsKFNZU19mdXRleCwgJmV2LT5z
dGF0ZSwgRlVURVhfV0FJVCB8IEZVVEVYX1BSSVZBVEVfRkxBRywgMCwgMCk7Cn0KCnN0YXRpYyBp
bnQgZXZlbnRfaXNzZXQoZXZlbnRfdCogZXYpCnsKCXJldHVybiBfX2F0b21pY19sb2FkX24oJmV2
LT5zdGF0ZSwgX19BVE9NSUNfQUNRVUlSRSk7Cn0KCnN0YXRpYyBpbnQgZXZlbnRfdGltZWR3YWl0
KGV2ZW50X3QqIGV2LCB1aW50NjRfdCB0aW1lb3V0KQp7Cgl1aW50NjRfdCBzdGFydCA9IGN1cnJl
bnRfdGltZV9tcygpOwoJdWludDY0X3Qgbm93ID0gc3RhcnQ7Cglmb3IgKDs7KSB7CgkJdWludDY0
X3QgcmVtYWluID0gdGltZW91dCAtIChub3cgLSBzdGFydCk7CgkJc3RydWN0IHRpbWVzcGVjIHRz
OwoJCXRzLnR2X3NlYyA9IHJlbWFpbiAvIDEwMDA7CgkJdHMudHZfbnNlYyA9IChyZW1haW4gJSAx
MDAwKSAqIDEwMDAgKiAxMDAwOwoJCXN5c2NhbGwoU1lTX2Z1dGV4LCAmZXYtPnN0YXRlLCBGVVRF
WF9XQUlUIHwgRlVURVhfUFJJVkFURV9GTEFHLCAwLCAmdHMpOwoJCWlmIChfX2F0b21pY19sb2Fk
X24oJmV2LT5zdGF0ZSwgX19BVE9NSUNfQUNRVUlSRSkpCgkJCXJldHVybiAxOwoJCW5vdyA9IGN1
cnJlbnRfdGltZV9tcygpOwoJCWlmIChub3cgLSBzdGFydCA+IHRpbWVvdXQpCgkJCXJldHVybiAw
OwoJfQp9CgpzdGF0aWMgYm9vbCB3cml0ZV9maWxlKGNvbnN0IGNoYXIqIGZpbGUsIGNvbnN0IGNo
YXIqIHdoYXQsIC4uLikKewoJY2hhciBidWZbMTAyNF07Cgl2YV9saXN0IGFyZ3M7Cgl2YV9zdGFy
dChhcmdzLCB3aGF0KTsKCXZzbnByaW50ZihidWYsIHNpemVvZihidWYpLCB3aGF0LCBhcmdzKTsK
CXZhX2VuZChhcmdzKTsKCWJ1ZltzaXplb2YoYnVmKSAtIDFdID0gMDsKCWludCBsZW4gPSBzdHJs
ZW4oYnVmKTsKCWludCBmZCA9IG9wZW4oZmlsZSwgT19XUk9OTFkgfCBPX0NMT0VYRUMpOwoJaWYg
KGZkID09IC0xKQoJCXJldHVybiBmYWxzZTsKCWlmICh3cml0ZShmZCwgYnVmLCBsZW4pICE9IGxl
bikgewoJCWludCBlcnIgPSBlcnJubzsKCQljbG9zZShmZCk7CgkJZXJybm8gPSBlcnI7CgkJcmV0
dXJuIGZhbHNlOwoJfQoJY2xvc2UoZmQpOwoJcmV0dXJuIHRydWU7Cn0KCiNkZWZpbmUgU0laRU9G
X0lPX1VSSU5HX1NRRSA2NAojZGVmaW5lIFNJWkVPRl9JT19VUklOR19DUUUgMTYKI2RlZmluZSBT
UV9IRUFEX09GRlNFVCAwCiNkZWZpbmUgU1FfVEFJTF9PRkZTRVQgNjQKI2RlZmluZSBTUV9SSU5H
X01BU0tfT0ZGU0VUIDI1NgojZGVmaW5lIFNRX1JJTkdfRU5UUklFU19PRkZTRVQgMjY0CiNkZWZp
bmUgU1FfRkxBR1NfT0ZGU0VUIDI3NgojZGVmaW5lIFNRX0RST1BQRURfT0ZGU0VUIDI3MgojZGVm
aW5lIENRX0hFQURfT0ZGU0VUIDEyOAojZGVmaW5lIENRX1RBSUxfT0ZGU0VUIDE5MgojZGVmaW5l
IENRX1JJTkdfTUFTS19PRkZTRVQgMjYwCiNkZWZpbmUgQ1FfUklOR19FTlRSSUVTX09GRlNFVCAy
NjgKI2RlZmluZSBDUV9SSU5HX09WRVJGTE9XX09GRlNFVCAyODQKI2RlZmluZSBDUV9GTEFHU19P
RkZTRVQgMjgwCiNkZWZpbmUgQ1FfQ1FFU19PRkZTRVQgMzIwCgpzdGF0aWMgbG9uZyBzeXpfaW9f
dXJpbmdfc3VibWl0KHZvbGF0aWxlIGxvbmcgYTAsIHZvbGF0aWxlIGxvbmcgYTEsIHZvbGF0aWxl
IGxvbmcgYTIsIHZvbGF0aWxlIGxvbmcgYTMpCnsKCWNoYXIqIHJpbmdfcHRyID0gKGNoYXIqKWEw
OwoJY2hhciogc3Flc19wdHIgPSAoY2hhciopYTE7CgljaGFyKiBzcWUgPSAoY2hhciopYTI7Cgl1
aW50MzJfdCBzcWVzX2luZGV4ID0gKHVpbnQzMl90KWEzOwoJdWludDMyX3Qgc3FfcmluZ19lbnRy
aWVzID0gKih1aW50MzJfdCopKHJpbmdfcHRyICsgU1FfUklOR19FTlRSSUVTX09GRlNFVCk7Cgl1
aW50MzJfdCBjcV9yaW5nX2VudHJpZXMgPSAqKHVpbnQzMl90KikocmluZ19wdHIgKyBDUV9SSU5H
X0VOVFJJRVNfT0ZGU0VUKTsKCXVpbnQzMl90IHNxX2FycmF5X29mZiA9IChDUV9DUUVTX09GRlNF
VCArIGNxX3JpbmdfZW50cmllcyAqIFNJWkVPRl9JT19VUklOR19DUUUgKyA2MykgJiB+NjM7Cglp
ZiAoc3FfcmluZ19lbnRyaWVzKQoJCXNxZXNfaW5kZXggJT0gc3FfcmluZ19lbnRyaWVzOwoJY2hh
ciogc3FlX2Rlc3QgPSBzcWVzX3B0ciArIHNxZXNfaW5kZXggKiBTSVpFT0ZfSU9fVVJJTkdfU1FF
OwoJbWVtY3B5KHNxZV9kZXN0LCBzcWUsIFNJWkVPRl9JT19VUklOR19TUUUpOwoJdWludDMyX3Qg
c3FfcmluZ19tYXNrID0gKih1aW50MzJfdCopKHJpbmdfcHRyICsgU1FfUklOR19NQVNLX09GRlNF
VCk7Cgl1aW50MzJfdCogc3FfdGFpbF9wdHIgPSAodWludDMyX3QqKShyaW5nX3B0ciArIFNRX1RB
SUxfT0ZGU0VUKTsKCXVpbnQzMl90IHNxX3RhaWwgPSAqc3FfdGFpbF9wdHIgJiBzcV9yaW5nX21h
c2s7Cgl1aW50MzJfdCBzcV90YWlsX25leHQgPSAqc3FfdGFpbF9wdHIgKyAxOwoJdWludDMyX3Qq
IHNxX2FycmF5ID0gKHVpbnQzMl90KikocmluZ19wdHIgKyBzcV9hcnJheV9vZmYpOwoJKihzcV9h
cnJheSArIHNxX3RhaWwpID0gc3Flc19pbmRleDsKCV9fYXRvbWljX3N0b3JlX24oc3FfdGFpbF9w
dHIsIHNxX3RhaWxfbmV4dCwgX19BVE9NSUNfUkVMRUFTRSk7CglyZXR1cm4gMDsKfQoKc3RhdGlj
IHZvaWQga2lsbF9hbmRfd2FpdChpbnQgcGlkLCBpbnQqIHN0YXR1cykKewoJa2lsbCgtcGlkLCBT
SUdLSUxMKTsKCWtpbGwocGlkLCBTSUdLSUxMKTsKCWZvciAoaW50IGkgPSAwOyBpIDwgMTAwOyBp
KyspIHsKCQlpZiAod2FpdHBpZCgtMSwgc3RhdHVzLCBXTk9IQU5HIHwgX19XQUxMKSA9PSBwaWQp
CgkJCXJldHVybjsKCQl1c2xlZXAoMTAwMCk7Cgl9CglESVIqIGRpciA9IG9wZW5kaXIoIi9zeXMv
ZnMvZnVzZS9jb25uZWN0aW9ucyIpOwoJaWYgKGRpcikgewoJCWZvciAoOzspIHsKCQkJc3RydWN0
IGRpcmVudCogZW50ID0gcmVhZGRpcihkaXIpOwoJCQlpZiAoIWVudCkKCQkJCWJyZWFrOwoJCQlp
ZiAoc3RyY21wKGVudC0+ZF9uYW1lLCAiLiIpID09IDAgfHwgc3RyY21wKGVudC0+ZF9uYW1lLCAi
Li4iKSA9PSAwKQoJCQkJY29udGludWU7CgkJCWNoYXIgYWJvcnRbMzAwXTsKCQkJc25wcmludGYo
YWJvcnQsIHNpemVvZihhYm9ydCksICIvc3lzL2ZzL2Z1c2UvY29ubmVjdGlvbnMvJXMvYWJvcnQi
LCBlbnQtPmRfbmFtZSk7CgkJCWludCBmZCA9IG9wZW4oYWJvcnQsIE9fV1JPTkxZKTsKCQkJaWYg
KGZkID09IC0xKSB7CgkJCQljb250aW51ZTsKCQkJfQoJCQlpZiAod3JpdGUoZmQsIGFib3J0LCAx
KSA8IDApIHsKCQkJfQoJCQljbG9zZShmZCk7CgkJfQoJCWNsb3NlZGlyKGRpcik7Cgl9IGVsc2Ug
ewoJfQoJd2hpbGUgKHdhaXRwaWQoLTEsIHN0YXR1cywgX19XQUxMKSAhPSBwaWQpIHsKCX0KfQoK
c3RhdGljIHZvaWQgc2V0dXBfdGVzdCgpCnsKCXByY3RsKFBSX1NFVF9QREVBVEhTSUcsIFNJR0tJ
TEwsIDAsIDAsIDApOwoJc2V0cGdycCgpOwoJd3JpdGVfZmlsZSgiL3Byb2Mvc2VsZi9vb21fc2Nv
cmVfYWRqIiwgIjEwMDAiKTsKfQoKc3RydWN0IHRocmVhZF90IHsKCWludCBjcmVhdGVkLCBjYWxs
OwoJZXZlbnRfdCByZWFkeSwgZG9uZTsKfTsKCnN0YXRpYyBzdHJ1Y3QgdGhyZWFkX3QgdGhyZWFk
c1sxNl07CnN0YXRpYyB2b2lkIGV4ZWN1dGVfY2FsbChpbnQgY2FsbCk7CnN0YXRpYyBpbnQgcnVu
bmluZzsKCnN0YXRpYyB2b2lkKiB0aHIodm9pZCogYXJnKQp7CglzdHJ1Y3QgdGhyZWFkX3QqIHRo
ID0gKHN0cnVjdCB0aHJlYWRfdCopYXJnOwoJZm9yICg7OykgewoJCWV2ZW50X3dhaXQoJnRoLT5y
ZWFkeSk7CgkJZXZlbnRfcmVzZXQoJnRoLT5yZWFkeSk7CgkJZXhlY3V0ZV9jYWxsKHRoLT5jYWxs
KTsKCQlfX2F0b21pY19mZXRjaF9zdWIoJnJ1bm5pbmcsIDEsIF9fQVRPTUlDX1JFTEFYRUQpOwoJ
CWV2ZW50X3NldCgmdGgtPmRvbmUpOwoJfQoJcmV0dXJuIDA7Cn0KCnN0YXRpYyB2b2lkIGV4ZWN1
dGVfb25lKHZvaWQpCnsKCWludCBpLCBjYWxsLCB0aHJlYWQ7Cglmb3IgKGNhbGwgPSAwOyBjYWxs
IDwgNTsgY2FsbCsrKSB7CgkJZm9yICh0aHJlYWQgPSAwOyB0aHJlYWQgPCAoaW50KShzaXplb2Yo
dGhyZWFkcykgLyBzaXplb2YodGhyZWFkc1swXSkpOyB0aHJlYWQrKykgewoJCQlzdHJ1Y3QgdGhy
ZWFkX3QqIHRoID0gJnRocmVhZHNbdGhyZWFkXTsKCQkJaWYgKCF0aC0+Y3JlYXRlZCkgewoJCQkJ
dGgtPmNyZWF0ZWQgPSAxOwoJCQkJZXZlbnRfaW5pdCgmdGgtPnJlYWR5KTsKCQkJCWV2ZW50X2lu
aXQoJnRoLT5kb25lKTsKCQkJCWV2ZW50X3NldCgmdGgtPmRvbmUpOwoJCQkJdGhyZWFkX3N0YXJ0
KHRociwgdGgpOwoJCQl9CgkJCWlmICghZXZlbnRfaXNzZXQoJnRoLT5kb25lKSkKCQkJCWNvbnRp
bnVlOwoJCQlldmVudF9yZXNldCgmdGgtPmRvbmUpOwoJCQl0aC0+Y2FsbCA9IGNhbGw7CgkJCV9f
YXRvbWljX2ZldGNoX2FkZCgmcnVubmluZywgMSwgX19BVE9NSUNfUkVMQVhFRCk7CgkJCWV2ZW50
X3NldCgmdGgtPnJlYWR5KTsKCQkJaWYgKGNhbGwgPT0gMykKCQkJCWJyZWFrOwoJCQlldmVudF90
aW1lZHdhaXQoJnRoLT5kb25lLCA1MCk7CgkJCWJyZWFrOwoJCX0KCX0KCWZvciAoaSA9IDA7IGkg
PCAxMDAgJiYgX19hdG9taWNfbG9hZF9uKCZydW5uaW5nLCBfX0FUT01JQ19SRUxBWEVEKTsgaSsr
KQoJCXNsZWVwX21zKDEpOwp9CgpzdGF0aWMgdm9pZCBleGVjdXRlX29uZSh2b2lkKTsKCiNkZWZp
bmUgV0FJVF9GTEFHUyBfX1dBTEwKCnN0YXRpYyB2b2lkIGxvb3Aodm9pZCkKewoJaW50IGl0ZXIg
PSAwOwoJZm9yICg7OyBpdGVyKyspIHsKCQlpbnQgcGlkID0gZm9yaygpOwoJCWlmIChwaWQgPCAw
KQoJZXhpdCgxKTsKCQlpZiAocGlkID09IDApIHsKCQkJc2V0dXBfdGVzdCgpOwoJCQlleGVjdXRl
X29uZSgpOwoJCQlleGl0KDApOwoJCX0KCQlpbnQgc3RhdHVzID0gMDsKCQl1aW50NjRfdCBzdGFy
dCA9IGN1cnJlbnRfdGltZV9tcygpOwoJCWZvciAoOzspIHsKCQkJaWYgKHdhaXRwaWQoLTEsICZz
dGF0dXMsIFdOT0hBTkcgfCBXQUlUX0ZMQUdTKSA9PSBwaWQpCgkJCQlicmVhazsKCQkJc2xlZXBf
bXMoMSk7CgkJCWlmIChjdXJyZW50X3RpbWVfbXMoKSAtIHN0YXJ0IDwgNTAwMCkKCQkJCWNvbnRp
bnVlOwoJCQlraWxsX2FuZF93YWl0KHBpZCwgJnN0YXR1cyk7CgkJCWJyZWFrOwoJCX0KCX0KfQoK
dWludDY0X3QgclszXSA9IHsweGZmZmZmZmZmZmZmZmZmZmYsIDB4ZmZmZmZmZmZmZmZmZmZmZiwg
MHgwfTsKCnZvaWQgZXhlY3V0ZV9jYWxsKGludCBjYWxsKQp7CgkJaW50cHRyX3QgcmVzID0gMDsK
CXN3aXRjaCAoY2FsbCkgewoJY2FzZSAwOgoJCU5PTkZBSUxJTkcoKih1aW50MzJfdCopMHgyMDAw
MDI4NCA9IDApOwoJCU5PTkZBSUxJTkcoKih1aW50MzJfdCopMHgyMDAwMDI4OCA9IDApOwoJCU5P
TkZBSUxJTkcoKih1aW50MzJfdCopMHgyMDAwMDI4YyA9IDApOwoJCU5PTkZBSUxJTkcoKih1aW50
MzJfdCopMHgyMDAwMDI5MCA9IDApOwoJCU5PTkZBSUxJTkcoKih1aW50MzJfdCopMHgyMDAwMDI5
OCA9IC0xKTsKCQlOT05GQUlMSU5HKG1lbXNldCgodm9pZCopMHgyMDAwMDI5YywgMCwgMTIpKTsK
CQlyZXMgPSBzeXNjYWxsKF9fTlJfaW9fdXJpbmdfc2V0dXAsIDB4MTIyNCwgMHgyMDAwMDI4MHVs
KTsKCQlpZiAocmVzICE9IC0xKQoJCQkJclswXSA9IHJlczsKCQlicmVhazsKCWNhc2UgMToKCQlO
T05GQUlMSU5HKCoodWludDMyX3QqKTB4MjAwMDAyODQgPSAwKTsKCQlOT05GQUlMSU5HKCoodWlu
dDMyX3QqKTB4MjAwMDAyODggPSAwKTsKCQlOT05GQUlMSU5HKCoodWludDMyX3QqKTB4MjAwMDAy
OGMgPSAwKTsKCQlOT05GQUlMSU5HKCoodWludDMyX3QqKTB4MjAwMDAyOTAgPSAwKTsKCQlOT05G
QUlMSU5HKCoodWludDMyX3QqKTB4MjAwMDAyOTggPSAtMSk7CgkJTk9ORkFJTElORyhtZW1zZXQo
KHZvaWQqKTB4MjAwMDAyOWMsIDAsIDEyKSk7CgkJcmVzID0gc3lzY2FsbChfX05SX2lvX3VyaW5n
X3NldHVwLCAweDEyMjQsIDB4MjAwMDAyODB1bCk7CgkJaWYgKHJlcyAhPSAtMSkKCQkJCXJbMV0g
PSByZXM7CgkJYnJlYWs7CgljYXNlIDI6CgkJcmVzID0gc3lzY2FsbChfX05SX2lvX3VyaW5nX3Jl
Z2lzdGVyLCByWzFdLCA5dWwsIDB1bCwgMHVsKTsKCQlpZiAocmVzICE9IC0xKQoJCQkJclsyXSA9
IHJlczsKCQlicmVhazsKCWNhc2UgMzoKCQlzeXNjYWxsKF9fTlJfaW9fdXJpbmdfcmVnaXN0ZXIs
IHJbMF0sIDB4MTZ1bCwgMHgyMDAwMDAwMHVsLCByWzJdKTsKCQlicmVhazsKCWNhc2UgNDoKCQlO
T05GQUlMSU5HKCoodWludDhfdCopMHgyMDAwMDFjMCA9IDB4MWMpOwoJCU5PTkZBSUxJTkcoKih1
aW50OF90KikweDIwMDAwMWMxID0gMCk7CgkJTk9ORkFJTElORygqKHVpbnQxNl90KikweDIwMDAw
MWMyID0gMCk7CgkJTk9ORkFJTElORygqKHVpbnQzMl90KikweDIwMDAwMWM0ID0gLTEpOwoJCU5P
TkZBSUxJTkcoKih1aW50NjRfdCopMHgyMDAwMDFjOCA9IDB4MjAwMDAwMDApOwoJCU5PTkZBSUxJ
TkcoKih1aW50NjRfdCopMHgyMDAwMDAwMCA9IDB4NDAwMDApOwoJCU5PTkZBSUxJTkcoKih1aW50
NjRfdCopMHgyMDAwMDAwOCA9IDgpOwoJCU5PTkZBSUxJTkcoKih1aW50NjRfdCopMHgyMDAwMDAx
MCA9IDApOwoJCU5PTkZBSUxJTkcoKih1aW50NjRfdCopMHgyMDAwMDFkMCA9IDApOwoJCU5PTkZB
SUxJTkcoKih1aW50MzJfdCopMHgyMDAwMDFkOCA9IDB4MTgpOwoJCU5PTkZBSUxJTkcoKih1aW50
MzJfdCopMHgyMDAwMDFkYyA9IDApOwoJCU5PTkZBSUxJTkcoKih1aW50NjRfdCopMHgyMDAwMDFl
MCA9IDB4MjM0NTYpOwoJCU5PTkZBSUxJTkcoKih1aW50MTZfdCopMHgyMDAwMDFlOCA9IDApOwoJ
CU5PTkZBSUxJTkcoKih1aW50MTZfdCopMHgyMDAwMDFlYSA9IHJbMl0pOwoJCU5PTkZBSUxJTkco
bWVtc2V0KCh2b2lkKikweDIwMDAwMWVjLCAwLCAyMCkpOwoJCU5PTkZBSUxJTkcoc3l6X2lvX3Vy
aW5nX3N1Ym1pdCgwLCAwLCAweDIwMDAwMWMwLCA4KSk7CgkJYnJlYWs7Cgl9Cgp9CmludCBtYWlu
KHZvaWQpCnsKCQlzeXNjYWxsKF9fTlJfbW1hcCwgMHgxZmZmZjAwMHVsLCAweDEwMDB1bCwgMHVs
LCAweDMydWwsIC0xLCAwdWwpOwoJc3lzY2FsbChfX05SX21tYXAsIDB4MjAwMDAwMDB1bCwgMHgx
MDAwMDAwdWwsIDd1bCwgMHgzMnVsLCAtMSwgMHVsKTsKCXN5c2NhbGwoX19OUl9tbWFwLCAweDIx
MDAwMDAwdWwsIDB4MTAwMHVsLCAwdWwsIDB4MzJ1bCwgLTEsIDB1bCk7CglpbnN0YWxsX3NlZ3Zf
aGFuZGxlcigpOwoJCQlsb29wKCk7CglyZXR1cm4gMDsKfQo=
--000000000000d1298b05e446d1cb
Content-Type: application/octet-stream; name="repro.syz"
Content-Disposition: attachment; filename="repro.syz"
Content-Transfer-Encoding: base64
Content-ID: <f_l5ud7b4i1>
X-Attachment-Id: f_l5ud7b4i1

cjAgPSBpb191cmluZ19zZXR1cCgweDEyMjQsICYoMHg3ZjAwMDAwMDAyODApKQpyMSA9IGlvX3Vy
aW5nX3NldHVwKDB4MTIyNCwgJigweDdmMDAwMDAwMDI4MCkpCnIyID0gaW9fdXJpbmdfcmVnaXN0
ZXIkSU9SSU5HX1JFR0lTVEVSX1BFUlNPTkFMSVRZKHIxLCAweDksIDB4MCwgMHgwKQppb191cmlu
Z19yZWdpc3RlciRJT1JJTkdfVU5SRUdJU1RFUl9QRVJTT05BTElUWShyMCwgMHgxNiwgMHgyMDAw
MDAwMCwgcjIpIChhc3luYykKc3l6X2lvX3VyaW5nX3N1Ym1pdCgweDAsIDB4MCwgJigweDdmMDAw
MDAwMDFjMCk9QElPUklOR19PUF9PUEVOQVQyPXsweDFjLCAweDAsIDB4MCwgMHhmZmZmZmZmZmZm
ZmZmZmZmLCAmKDB4N2YwMDAwMDAwMDAwKT17MHg0MDAwMCwgMHg4fSwgMHgwLCAweDE4LCAweDAs
IDB4MjM0NTYsIHsweDAsIHIyfX0sIDB4OCkK
--000000000000d1298b05e446d1cb--
