Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444EA3DC79D
	for <lists+io-uring@lfdr.de>; Sat, 31 Jul 2021 20:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhGaSWY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 31 Jul 2021 14:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhGaSWX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 31 Jul 2021 14:22:23 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CD6C06175F;
        Sat, 31 Jul 2021 11:22:17 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id x192so21774244ybe.0;
        Sat, 31 Jul 2021 11:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=B2wyjC7Ur8M6OKOZpCw0kgf58az5KHkX+mP2rwt1ZRE=;
        b=mixLP0SLeFkQtWsAk2J4lgpkl+YJdChpJ1SrVFalxOB8GvfNRDRfA3QHu9Z3IS9Amm
         r7nuRG31yEh3kq/GfqueEYAm3+upszhMKm2lZuWouHIWmtAUoFL8zk2SeiyLMtEv2Erk
         R870OkCpzJIeF4F/9esYmuunM2u0seiC0N3cW121LDdMWMncUN5WYh4rX3HXiqd5yb3z
         8GDOZqP8w0ilAPpLYWLS738q7C1S/cjS8uVB/So0EeASn94Ii0AG7fpn4OYvaNlRZEce
         //ROKmc1uw2/UzkEYiHzruNRE9whFmI1XaRGEazMlogbDKKCv8W33nSfXYF4bTjfJL5y
         BVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=B2wyjC7Ur8M6OKOZpCw0kgf58az5KHkX+mP2rwt1ZRE=;
        b=YetLGsfEer80FDSlnQayl5hfNpqLFvDn9J3fCxlY19lnjFc7touCP0NKTgleo+MI8J
         D2L/xPMIH183TylvWtCq80esVCb3rSPzBKLqXusen6FOLtWyD/9PHiIWJNKj87WqByJR
         NkMqxmAqbR5VhIXFwQ6TX8Eg35KyFeXQKiRT6OLgXXIFpB5lTDK02NLWjOLIcQXVIa8w
         Qasj+8VlA/CxHSyN9wIXE5IBBrsJXKjsiarwhQ+MTYEmDMwOCj4vGuxeubAjxxK1jjdT
         GZpOtKxOictuC0DTzqR2x7enGPFggBa6+DknUCiB6lzgUCmIMr5YNhxDmV9hkN006uHC
         b1Ug==
X-Gm-Message-State: AOAM531EX1PUN8Gi1ofbLrUxez8NvDEEPUmKSli4wKZ/RPsW98yBeb3e
        DH8xRlRPpNdHPC2D7XQeiy30a2krotfbVjltp+8r6z+/dQ4b1Q==
X-Google-Smtp-Source: ABdhPJzjVJvCxfkw59ibTUW0/DK5/bDfo7ySAlMaxICS3bxtLC7FuUGxj03ud6oYX9dsUQby7ulgsCgJRH8AOvzUjis=
X-Received: by 2002:a05:6902:1109:: with SMTP id o9mr11021445ybu.448.1627755736477;
 Sat, 31 Jul 2021 11:22:16 -0700 (PDT)
MIME-Version: 1.0
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sat, 31 Jul 2021 19:21:40 +0100
Message-ID: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
Subject: KASAN: stack-out-of-bounds in iov_iter_revert
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens, Pavel,

We had been running syzkaller on v5.10.y and a "KASAN:
stack-out-of-bounds in iov_iter_revert" was being reported on it. I
got some time to check that today and have managed to get a syzkaller
reproducer. I dont have a C reproducer which I can share but I can use
the syz-reproducer to reproduce this with v5.14-rc3 and also with
next-20210730.

==================================================================
[   74.211232] BUG: KASAN: stack-out-of-bounds in iov_iter_revert+0x809/0x900
[   74.212778] Read of size 8 at addr ffff888025dc78b8 by task
syz-executor.0/828

[   74.214756] CPU: 0 PID: 828 Comm: syz-executor.0 Not tainted
5.14.0-rc3-next-20210730 #1
[   74.216525] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   74.219033] Call Trace:
[   74.219683]  dump_stack_lvl+0x8b/0xb3
[   74.220706]  print_address_description.constprop.0+0x1f/0x140
[   74.222272]  ? iov_iter_revert+0x809/0x900
[   74.223285]  ? iov_iter_revert+0x809/0x900
[   74.224226]  kasan_report.cold+0x7f/0x11b
[   74.225147]  ? iov_iter_revert+0x809/0x900
[   74.226085]  iov_iter_revert+0x809/0x900
[   74.227002]  ? lock_is_held_type+0x98/0x110
[   74.227960]  io_write+0x57d/0xe40
[   74.228730]  ? io_read+0x10d0/0x10d0
[   74.229550]  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
[   74.230746]  ? lock_is_held_type+0x98/0x110
[   74.231699]  ? __lock_acquire+0xbb1/0x5b00
[   74.232647]  io_issue_sqe+0x4da/0x6a80
[   74.233507]  ? mark_lock+0xfc/0x2d80
[   74.234349]  ? __is_insn_slot_addr+0x14d/0x250
[   74.235385]  ? lock_chain_count+0x20/0x20
[   74.236312]  ? io_write+0xe40/0xe40
[   74.237119]  ? lock_is_held_type+0x98/0x110
[   74.238076]  ? find_held_lock+0x2c/0x110
[   74.238992]  ? lock_release+0x1dd/0x6b0
[   74.239874]  ? __fget_files+0x21c/0x3e0
[   74.240757]  ? lock_downgrade+0x6d0/0x6d0
[   74.241672]  ? lock_release+0x1dd/0x6b0
[   74.242578]  __io_queue_sqe+0x1ac/0xe60
[   74.243471]  ? io_issue_sqe+0x6a80/0x6a80
[   74.244402]  ? lock_is_held_type+0x98/0x110
[   74.245358]  io_submit_sqes+0x3f6e/0x76a0
[   74.246281]  ? xa_load+0x158/0x290
[   74.247113]  ? __do_sys_io_uring_enter+0x90c/0x1a20
[   74.248207]  __do_sys_io_uring_enter+0x90c/0x1a20
[   74.249277]  ? vm_mmap_pgoff+0xe8/0x280
[   74.250163]  ? io_submit_sqes+0x76a0/0x76a0
[   74.251149]  ? randomize_stack_top+0x100/0x100
[   74.252178]  ? __do_sys_futex+0xf2/0x3d0
[   74.253074]  ? __do_sys_futex+0xfb/0x3d0
[   74.253980]  ? do_futex+0x18c0/0x18c0
[   74.254852]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
[   74.256022]  ? syscall_enter_from_user_mode+0x1d/0x50
[   74.257167]  do_syscall_64+0x3b/0x90
[   74.257984]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   74.259125] RIP: 0033:0x466609
[   74.259830] Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89
01 48
[   74.263910] RSP: 002b:00007ffdb23903f8 EFLAGS: 00000246 ORIG_RAX:
00000000000001aa
[   74.265579] RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 0000000000466609
[   74.267162] RDX: 0000000000000000 RSI: 00000000000058ab RDI: 0000000000000003
[   74.268745] RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
[   74.270303] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
[   74.271899] R13: 00007ffdb2390590 R14: 000000000056bf80 R15: 000000000001215c

[   74.273856] The buggy address belongs to the page:
[   74.274948] page:00000000bd0ec836 refcount:0 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x25dc7
[   74.277000] flags: 0x100000000000000(node=0|zone=1)
[   74.278119] raw: 0100000000000000 0000000000000000 ffffea00009771c8
0000000000000000
[   74.279853] raw: 0000000000000000 0000000000000000 00000000ffffffff
0000000000000000
[   74.281553] page dumped because: kasan: bad access detected

[   74.283166] addr ffff888025dc78b8 is located in stack of task
syz-executor.0/828 at offset 152 in frame:
[   74.285238]  io_write+0x0/0xe40

[   74.286338] this frame has 3 objects:
[   74.287170]  [48, 56) 'iovec'
[   74.287185]  [80, 120) '__iter'
[   74.287863]  [160, 288) 'inline_vecs'

[   74.289751] Memory state around the buggy address:
[   74.290825]  ffff888025dc7780: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   74.292421]  ffff888025dc7800: 00 00 00 00 f1 f1 f1 f1 00 00 00 f2
f2 f2 00 00
[   74.294022] >ffff888025dc7880: 00 00 00 f2 f2 f2 f2 f2 00 00 00 00
00 00 00 00
[   74.295639]                                         ^
[   74.296766]  ffff888025dc7900: 00 00 00 00 00 00 00 00 f3 f3 f3 f3
00 00 00 00
[   74.298373]  ffff888025dc7980: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   74.299959] ==================================================================


Not sure if this has been already reported or not, but I will be happy
to test if you have a fix for this.


-- 
Regards
Sudip
