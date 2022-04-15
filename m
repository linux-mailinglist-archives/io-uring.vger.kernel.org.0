Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8605F502024
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348428AbiDOBcx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 21:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243739AbiDOBcx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 21:32:53 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFB442EE6
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 18:30:22 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id j4-20020a92c204000000b002caad37af3fso4002679ilo.22
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 18:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=htiLe9E3ZdtiIoT+zYEOMOvsXOFLg2/YOwYvDcOTymA=;
        b=CcikjGimYIai2dm47ZpmgkkVTLyXFxwLT9SvhR1ALNgQZp8H8QiFsByMTLmMaM9gaQ
         rmq63Vi62xo21VXoAzyn9g69LvZEV2CEDSJX/+osc+lB5GuS0J+sZDDn1DSJY6A+X+1N
         FsyqneW15I8xXGSPV9EnEUrK9MZ5Vv+rYncJSLlmAA8sqgT9Ed+9c9v8B4gHCUvPLxZy
         oFQOWgJqvDqUYPTuOxo9HqkjbofF5mUQpGei0GPHT6+fShBTRUZ/cTljTyON1Jpgvj1D
         NjjtxoRBOlGYHIE3GWaKjMadniIsoMsLR6XdB2SO4i/cddlEGBrcM+lqfvoE4VB+c0Go
         WGYA==
X-Gm-Message-State: AOAM533nrQGBcB9j28i88wuPD58T1P86jer6eKjIQ59IdtJGonzwuk/t
        yAxdEXwjJNPKMwBrG9ObEauBY8QwFWgRX8ZyJ+vn1Q+XkBfs
X-Google-Smtp-Source: ABdhPJzcWFkIT089oQ8yY6tnd49uvUWhdenPo09/el0bna8t8l85/zaiYIUV5IOLyiS5AxFCUuKlBWmvbsQC1ofC5cgJtKduJbWo
MIME-Version: 1.0
X-Received: by 2002:a92:d18b:0:b0:2c6:675:807c with SMTP id
 z11-20020a92d18b000000b002c60675807cmr2169666ilz.33.1649986222155; Thu, 14
 Apr 2022 18:30:22 -0700 (PDT)
Date:   Thu, 14 Apr 2022 18:30:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a7edb305dca75a50@google.com>
Subject: [syzbot] kernel BUG in commit_creds
From:   syzbot <syzbot+60c52ca98513a8760a91@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, ebiederm@xmission.com,
        io-uring@vger.kernel.org, legion@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    40354149f4d7 Add linux-next specific files for 20220414
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1778a95cf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a44d62051576f6f5
dashboard link: https://syzkaller.appspot.com/bug?extid=60c52ca98513a8760a91
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1102d2e0f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e22af4f00000

The issue was bisected to:

commit 6bf9c47a398911e0ab920e362115153596c80432
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Mar 29 16:10:08 2022 +0000

    io_uring: defer file assignment

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14f6da04f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16f6da04f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12f6da04f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60c52ca98513a8760a91@syzkaller.appspotmail.com
Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")

------------[ cut here ]------------
kernel BUG at kernel/cred.c:456!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3596 Comm: syz-executor409 Not tainted 5.18.0-rc2-next-20220414-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:commit_creds+0xf33/0x1360 kernel/cred.c:456
Code: 84 d2 0f 85 94 03 00 00 45 8b 74 24 2c 89 de 44 89 f7 e8 80 d8 29 00 41 39 de 0f 85 03 f8 ff ff e9 10 f8 ff ff e8 6d d5 29 00 <0f> 0b e8 66 d5 29 00 0f 0b e8 5f d5 29 00 0f 0b 48 89 cf e8 15 68
RSP: 0018:ffffc900039dfc58 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff8880186457c0 RSI: ffffffff81502c83 RDI: ffff888022af9700
RBP: ffff888022af9700 R08: 0000000000000000 R09: 0000000020a96400
R10: ffffffff83b21be5 R11: 0000000000000000 R12: ffff888022af9500
R13: ffff8880186457c0 R14: ffff8880186457c0 R15: ffffed10030c8bfc
FS:  00005555558b03c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005624d8428d20 CR3: 000000001e73f000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 install_process_keyring security/keys/process_keys.c:306 [inline]
 lookup_user_key+0x534/0x1270 security/keys/process_keys.c:653
 __do_sys_add_key+0x1d3/0x430 security/keys/keyctl.c:126
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd586be1a69
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9ed85078 EFLAGS: 00000246 ORIG_RAX: 00000000000000f8
RAX: ffffffffffffffda RBX: 00007ffe9ed85098 RCX: 00007fd586be1a69
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000200000c0
RBP: 00007ffe9ed85090 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:commit_creds+0xf33/0x1360 kernel/cred.c:456
Code: 84 d2 0f 85 94 03 00 00 45 8b 74 24 2c 89 de 44 89 f7 e8 80 d8 29 00 41 39 de 0f 85 03 f8 ff ff e9 10 f8 ff ff e8 6d d5 29 00 <0f> 0b e8 66 d5 29 00 0f 0b e8 5f d5 29 00 0f 0b 48 89 cf e8 15 68
RSP: 0018:ffffc900039dfc58 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff8880186457c0 RSI: ffffffff81502c83 RDI: ffff888022af9700
RBP: ffff888022af9700 R08: 0000000000000000 R09: 0000000020a96400
R10: ffffffff83b21be5 R11: 0000000000000000 R12: ffff888022af9500
R13: ffff8880186457c0 R14: ffff8880186457c0 R15: ffffed10030c8bfc
FS:  00005555558b03c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005624d841fd90 CR3: 000000001e73f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
