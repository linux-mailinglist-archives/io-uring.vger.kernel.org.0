Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E5C40421F
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348476AbhIIAM0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:12:26 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:44816 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348431AbhIIAMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:12:25 -0400
Received: by mail-il1-f199.google.com with SMTP id d4-20020a923604000000b0022a2b065b0aso146790ila.11
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 17:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HPCfgBq/8lv91SsfidmQBovpBZFgQI+XnFeRrNlG13U=;
        b=CZ7vY1E/xvQT2XNriusyT5Xk2BOvUB6sfsmD76OaABN43d0Ehx/0FGjg6vY8JSI08e
         6k3ucqhL3zQdUJFDeABGRCIpCQsIHqxStFZRX25sojfvP89uAPuL8kWybg8k1ucEIaHC
         AAsnmLZ1OXnmvH3Yp6G6B5gm3ALBQ2VvIGb6rd5agPo3FM5ZWGfDCaArOvUeBIWmLC/M
         4OCLwdqio7O2McqfbPWBvdhxtzWKETaZ2n8S9Yp4Dz8js38PoUw/hO8cqS21P2QRwL8x
         gGLG96Tz8Hy9/93chommE51Uv7GJzPuCLveB4j7OwlSqZL/6Sf/IXs4Xz4JzntWy16Mi
         xh5w==
X-Gm-Message-State: AOAM532lr8SsAyw0oFvkGn79E1XoyOFA0Zu8X+daGmI1xLiCrRm6qrXl
        POk8oYgJ2r3QbUsBFG291raRiZa32gvLPBmbjRor7Fl0cSRl
X-Google-Smtp-Source: ABdhPJzbjMIbjbQkLWgtrtNr0hKjxAUoRSLaLx0mcz8q2Bu2hYOZbveYf6RF7iZnXArE4Yz9EDFrmOQDwazZSjpKYvtlrhaVaVW7
MIME-Version: 1.0
X-Received: by 2002:a6b:e604:: with SMTP id g4mr186815ioh.148.1631146276946;
 Wed, 08 Sep 2021 17:11:16 -0700 (PDT)
Date:   Wed, 08 Sep 2021 17:11:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a0acd05cb84d626@google.com>
Subject: [syzbot] WARNING in io_req_complete_post
From:   syzbot <syzbot+a0516daac8b536b4b8c0@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b2bb710d34d5 Add linux-next specific files for 20210907
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14a956b3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=457dbc3619116cdf
dashboard link: https://syzkaller.appspot.com/bug?extid=a0516daac8b536b4b8c0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a0516daac8b536b4b8c0@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 14536 at fs/io_uring.c:1151 req_ref_put_and_test fs/io_uring.c:1151 [inline]
WARNING: CPU: 0 PID: 14536 at fs/io_uring.c:1151 req_ref_put_and_test fs/io_uring.c:1146 [inline]
WARNING: CPU: 0 PID: 14536 at fs/io_uring.c:1151 io_req_complete_post+0x946/0xa50 fs/io_uring.c:1794
Modules linked in:
CPU: 0 PID: 14536 Comm: syz-executor.3 Not tainted 5.14.0-next-20210907-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:req_ref_put_and_test fs/io_uring.c:1151 [inline]
RIP: 0010:req_ref_put_and_test fs/io_uring.c:1146 [inline]
RIP: 0010:io_req_complete_post+0x946/0xa50 fs/io_uring.c:1794
Code: e9 94 ff 48 8b 34 24 31 ff e8 76 ee 94 ff e9 6e fc ff ff e8 0c e9 94 ff 4c 89 ef e8 d4 c0 62 ff e9 38 f8 ff ff e8 fa e8 94 ff <0f> 0b e9 8a fb ff ff e8 ee e8 94 ff 49 8d 7e 58 31 c9 ba 01 00 00
RSP: 0018:ffffc9000bf6fda8 EFLAGS: 00010216
RAX: 000000000000ec57 RBX: ffff88806c12e000 RCX: ffffc9000fa5e000
RDX: 0000000000040000 RSI: ffffffff81e12466 RDI: 0000000000000003
RBP: ffff88801cfea000 R08: 000000000000007f R09: ffff88806c12e05f
R10: ffffffff81e11fed R11: 0000000000000000 R12: ffff88801cfea640
R13: ffff88806c12e05c R14: 000000000000007f R15: ffff88806c12e058
FS:  00007f03ce5d4700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f03ce5d4718 CR3: 00000000149d2000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tctx_task_work+0x189/0x6c0 fs/io_uring.c:2158
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f03ce5d4188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000080 RBX: 000000000056c038 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 000000000000688c RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffde5bbb8df R14: 00007f03ce5d4300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
