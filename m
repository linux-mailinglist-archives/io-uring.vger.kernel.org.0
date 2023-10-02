Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469CA7B55C6
	for <lists+io-uring@lfdr.de>; Mon,  2 Oct 2023 17:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbjJBOiH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 10:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbjJBOiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 10:38:06 -0400
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABEEB0
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 07:38:02 -0700 (PDT)
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-57b708ce1c1so3808623eaf.1
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 07:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696257482; x=1696862282;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uv9FgHyylQRc96e7HKR/4ZeW448+Z6VHfeYDS3t+eHk=;
        b=SX3yBMJ5N1CzPQu/kdNjZX8OXUGplkfz8Q8cQRda9wO3PkbhkZvEgX/pzsleDvlxD1
         NLzMoe8+smad9L2U2Qghp2FcLa4hSe+U45/koj6iEursz7Em+gB85xAoGZLzzs4ZTB3G
         yFX4PGnxjOgAOfRP4JS8uwSZSy3KuDQimKgdcuSi77QWsp5Z6dgOVIj22N9JIbgBMq1L
         Wo9FJWDsqeUsY96QNvVX0zDo/lASgb4u6Nk8MZIEL62r9LPjaj75BGEbvKrH/RyMiRzu
         w1Q79nR56SK/1QFZFBF9C2Zp59Bva28l+/DH2bZLt07oxFhcBdK7BiQyXY82PPAvgw5O
         jyOQ==
X-Gm-Message-State: AOJu0YwZEEwHwPbdBf/0IsiejMn+Ai9BcLH3bTp/RibiP7CyYYjgaSIl
        FUVTHTb45i4HNIJnq7hy1CSJ30Fc+sFYI/UbhC1qPlh7L+ec
X-Google-Smtp-Source: AGHT+IEllKMwoiBrJu4bnAfPatkUdzqa4kALl00EttRGW1upBuaeZQMevlUP5UE3qYNq3KlKU4MTGlezRvjpSUiTN3/br2uc3qDV
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1687:b0:56d:72ca:c4dc with SMTP id
 bc7-20020a056820168700b0056d72cac4dcmr4214231oob.0.1696257482107; Mon, 02 Oct
 2023 07:38:02 -0700 (PDT)
Date:   Mon, 02 Oct 2023 07:38:02 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab32d40606bcb85e@google.com>
Subject: [syzbot] [io-uring?] general protection fault in io_get_cqe_overflow
From:   syzbot <syzbot+efc45d4e7ba6ab4ef1eb@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9f3ebbef746f Merge tag '6.6-rc3-ksmbd-server-fixes' of git..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1149528a680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12da82ece7bf46f9
dashboard link: https://syzkaller.appspot.com/bug?extid=efc45d4e7ba6ab4ef1eb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128b2062680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128da28a680000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6347b8b20dfc/disk-9f3ebbef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/30d3cf579ba8/vmlinux-9f3ebbef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/99f0fa64b776/bzImage-9f3ebbef.xz

The issue was bisected to:

commit f26cc9593581bd734c846bf827401350b36dc3c9
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Jan 4 01:34:57 2023 +0000

    io_uring: lockdep annotate CQ locking

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10deb67c680000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12deb67c680000
console output: https://syzkaller.appspot.com/x/log.txt?x=14deb67c680000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+efc45d4e7ba6ab4ef1eb@syzkaller.appspotmail.com
Fixes: f26cc9593581 ("io_uring: lockdep annotate CQ locking")

general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 1 PID: 5030 Comm: syz-executor742 Not tainted 6.6.0-rc3-syzkaller-00146-g9f3ebbef746f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/06/2023
RIP: 0010:io_get_cqe_overflow+0x1f2/0x570 io_uring/io_uring.h:116
Code: fc ff df 80 3c 08 00 74 08 48 89 ef e8 67 54 b2 fd 4c 8b 75 00 49 8d 6e 2c 48 89 e8 48 c1 e8 03 48 bb 00 00 00 00 00 fc ff df <0f> b6 04 18 84 c0 0f 85 18 03 00 00 44 8b 65 00 41 83 e4 04 31 ff
RSP: 0018:ffffc9000398f930 EFLAGS: 00010207
RAX: 0000000000000005 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: ffff888017a4d940 RSI: 0000000000000020 RDI: 0000000000000000
RBP: 000000000000002c R08: ffffffff84362701 R09: fffff52000731f20
R10: dffffc0000000000 R11: fffff52000731f20 R12: 1ffff1100410b400
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc9000398f9c0
FS:  0000555555943380(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001380 CR3: 000000007d529000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_get_cqe io_uring/io_uring.h:132 [inline]
 io_fill_cqe_aux io_uring/io_uring.c:884 [inline]
 __io_post_aux_cqe+0xe7/0x440 io_uring/io_uring.c:931
 io_rsrc_put_work io_uring/rsrc.c:156 [inline]
 io_rsrc_node_ref_zero+0x219/0x570 io_uring/rsrc.c:191
 io_put_rsrc_node io_uring/rsrc.h:112 [inline]
 io_queue_rsrc_removal+0x4a0/0x5c0 io_uring/rsrc.c:667
 __io_sqe_buffers_update io_uring/rsrc.c:469 [inline]
 __io_register_rsrc_update+0x828/0x1430 io_uring/rsrc.c:499
 io_register_rsrc_update+0x1cd/0x220 io_uring/rsrc.c:530
 __do_sys_io_uring_register io_uring/io_uring.c:4587 [inline]
 __se_sys_io_uring_register+0x78f/0x1470 io_uring/io_uring.c:4547
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fddb16c14e9
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe58601a08 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 0000000000006ba5 RCX: 00007fddb16c14e9
RDX: 0000000020001600 RSI: 0000000000000010 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00000000000ac5f8 R09: 00000000000ac5f8
R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe58601bd8 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:io_get_cqe_overflow+0x1f2/0x570 io_uring/io_uring.h:116
Code: fc ff df 80 3c 08 00 74 08 48 89 ef e8 67 54 b2 fd 4c 8b 75 00 49 8d 6e 2c 48 89 e8 48 c1 e8 03 48 bb 00 00 00 00 00 fc ff df <0f> b6 04 18 84 c0 0f 85 18 03 00 00 44 8b 65 00 41 83 e4 04 31 ff
RSP: 0018:ffffc9000398f930 EFLAGS: 00010207
RAX: 0000000000000005 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: ffff888017a4d940 RSI: 0000000000000020 RDI: 0000000000000000
RBP: 000000000000002c R08: ffffffff84362701 R09: fffff52000731f20
R10: dffffc0000000000 R11: fffff52000731f20 R12: 1ffff1100410b400
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc9000398f9c0
FS:  0000555555943380(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001380 CR3: 000000007d529000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	df 80 3c 08 00 74    	filds  0x7400083c(%rax)
   6:	08 48 89             	or     %cl,-0x77(%rax)
   9:	ef                   	out    %eax,(%dx)
   a:	e8 67 54 b2 fd       	call   0xfdb25476
   f:	4c 8b 75 00          	mov    0x0(%rbp),%r14
  13:	49 8d 6e 2c          	lea    0x2c(%r14),%rbp
  17:	48 89 e8             	mov    %rbp,%rax
  1a:	48 c1 e8 03          	shr    $0x3,%rax
  1e:	48 bb 00 00 00 00 00 	movabs $0xdffffc0000000000,%rbx
  25:	fc ff df
* 28:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax <-- trapping instruction
  2c:	84 c0                	test   %al,%al
  2e:	0f 85 18 03 00 00    	jne    0x34c
  34:	44 8b 65 00          	mov    0x0(%rbp),%r12d
  38:	41 83 e4 04          	and    $0x4,%r12d
  3c:	31 ff                	xor    %edi,%edi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
