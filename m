Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AD1666F51
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjALKQ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239873AbjALKPD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:15:03 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB295654C
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:14:41 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id u1-20020a5d8181000000b006ee29a8c421so10975947ion.19
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:14:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0nRCtvtkB3zOKRm9xdU+tMBABuOLRRmuR87z8JSiY0k=;
        b=mZqA73/pBsEWWT0zKfN/66iH7k+ykZiPge4OIab7SVdMz5KOo0Wqe4O6wc5XxCrwai
         f1eB9CmP65M1ojJDRK9Ta7vbe6jCVBMUTJ1JEUOEJB26Sh/iF1H2MY6LOqRRbipxSPLo
         apRiube2p+rkzp8Y0y3ll69dIpD31BVFAizb3wmd7K+hoeG1qbIuUit+9mshHHpREeiW
         EBFHeNjgZNA0XM7+Wtxt1AC/DlKKM+o/BGJKDLmWI/YIerERl4c5wcXGRnbVANhM568j
         qqAxwx0Wdk0xxEYmDpQ0792QH8FXj28+h15/jx5mZ+uw00II2rivJHtti5PfNdexJiNj
         GwdQ==
X-Gm-Message-State: AFqh2koyMxv94UIZwY1V52m7ilhQhTdxsroCiiYWrFaBYoTTGSnh5J14
        nbivoqg3QzDQvmJ36oP2wbI/UJhm0ddxSO8fAd9G3ZzNrt6V
X-Google-Smtp-Source: AMrXdXsbkxEp6TlHV0w2xTfbRpfwr9EjQymfDfdvHYJlzVpgKsNgjxJ3k46bpUYzx4u03sYs0BHdHlO5Bvf779CY2aL3P5dGuRPE
MIME-Version: 1.0
X-Received: by 2002:a5e:c814:0:b0:6ec:dc1e:c18f with SMTP id
 y20-20020a5ec814000000b006ecdc1ec18fmr5404840iol.113.1673518481186; Thu, 12
 Jan 2023 02:14:41 -0800 (PST)
Date:   Thu, 12 Jan 2023 02:14:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098a61b05f20e62db@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in __io_put_task
From:   syzbot <syzbot+1aa0bce76589e2e98756@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following issue on:

HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14d269ce480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
dashboard link: https://syzkaller.appspot.com/bug?extid=1aa0bce76589e2e98756
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1aa0bce76589e2e98756@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 1) object: ffff88801fe06ca8 object type: rcu_head hint: 0x0
WARNING: CPU: 0 PID: 6765 at lib/debugobjects.c:509 debug_print_object+0x194/0x2c0 lib/debugobjects.c:509
Modules linked in:
CPU: 0 PID: 6765 Comm: kworker/0:29 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events io_fallback_req_func
RIP: 0010:debug_print_object+0x194/0x2c0 lib/debugobjects.c:509
Code: df 48 89 fe 48 c1 ee 03 80 3c 16 00 0f 85 c7 00 00 00 48 8b 14 dd c0 dc a6 8a 50 4c 89 ee 48 c7 c7 80 d0 a6 8a e8 00 79 ae 05 <0f> 0b 58 83 05 ce 27 66 0a 01 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e
RSP: 0018:ffffc900057df950 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff88807d03d7c0 RSI: ffffffff8166972c RDI: fffff52000afbf1c
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8a4dd0a0
R13: ffffffff8aa6d580 R14: ffff88802a8da408 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055574b30e000 CR3: 000000001ddab000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:996 [inline]
 debug_check_no_obj_freed+0x305/0x420 lib/debugobjects.c:1027
 slab_free_hook mm/slub.c:1756 [inline]
 slab_free_freelist_hook+0xeb/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
 put_task_struct_many include/linux/sched/task.h:125 [inline]
 __io_put_task+0x155/0x1e0 io_uring/io_uring.c:725
 io_put_task io_uring/io_uring.h:328 [inline]
 __io_req_complete_post+0x7ac/0xcd0 io_uring/io_uring.c:978
 io_req_complete_post+0xf1/0x1a0 io_uring/io_uring.c:992
 io_req_task_complete+0x189/0x260 io_uring/io_uring.c:1623
 io_poll_task_func+0xa95/0x1220 io_uring/poll.c:347
 io_fallback_req_func+0xfd/0x204 io_uring/io_uring.c:252
 process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
 worker_thread+0x669/0x1090 kernel/workqueue.c:2440
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
