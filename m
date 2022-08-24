Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235FF59FF8F
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 18:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239555AbiHXQfd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 12:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbiHXQfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 12:35:32 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AF580F51
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 09:35:31 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id i26-20020a056e021d1a00b002e9865e8963so8285664ila.14
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 09:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=igPw/4yA+mTANwSdMoZucgTYkONKNQ2e1OHP2G/JPo0=;
        b=K0bD5uxsV47aAjVUdpqylHWD8Eqq3VA9SKVIiXUlYZoy+tTQ4KmahboEhiP3+lC3GW
         nz4PS4ugb3nl/U9WeSaHE2GLZNLEnJARmAEOVuKLrh6G3m3YSm7nDDdpiTRS3tTr6y2J
         Q7BFPmgNjtyG2yOWEw4BwwpozMcMtPGbWnbsBaNOfyL5wDjsL4vVCrlM0/EYs5s+I6Dp
         qpOseUtFWSwy6GYfOMQCFDWpmwH2fswqdHJUEUaXWdGRzEFcfbzFB48BsSjuD0iUXChA
         nwNya7gcYr45lahlYs3bRkCR+OHMVTXdb5Ih/xm3Y23OxskfxFzBpd/NhSxa4LYM8MQg
         Knzw==
X-Gm-Message-State: ACgBeo1hZ8Y3BW8wLiTALu0CRCfx9Ezb4ekoeZ9y9grA+9Uc1Qz7pA8x
        5sD6Plpo9Um/0cGXx7Q0RuRE5W4AvRDAG4UEB/VcbHZO6YQH
X-Google-Smtp-Source: AA6agR5bgppAZ7QEzoIstb2KBTdF0RBmHECgpmY4kmUqRRoeAiwbgTDcu5VE+GfWrTZs5Qckj5AW/LVVrGs+AGXZu2jtZJ4f3U/a
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d02:b0:346:f5ef:6ab2 with SMTP id
 q2-20020a0566380d0200b00346f5ef6ab2mr14004741jaj.300.1661358930783; Wed, 24
 Aug 2022 09:35:30 -0700 (PDT)
Date:   Wed, 24 Aug 2022 09:35:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e9f4e905e6ff4495@google.com>
Subject: [syzbot] general protection fault in __io_sync_cancel
From:   syzbot <syzbot+bf76847df5f7359c9e09@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    df0219d11b6f Merge tag 'parisc-for-6.0-2' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=108d7fcb080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=911efaff115942bb
dashboard link: https://syzkaller.appspot.com/bug?extid=bf76847df5f7359c9e09
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ef1715080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fcebc3080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bf76847df5f7359c9e09@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 3614 Comm: syz-executor233 Not tainted 6.0.0-rc2-syzkaller-00044-gdf0219d11b6f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:__io_sync_cancel+0x10d/0x1c0 io_uring/cancel.c:224
Code: 48 c1 ea 03 80 3c 02 00 0f 85 aa 00 00 00 49 8b 86 f8 00 00 00 48 8d 1c d8 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 8e 00 00 00 48 8b 1b 48 8d 7d 08 48 b8 00 00 00
RSP: 0018:ffffc900038ffc20 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff83f87914 RDI: ffff888146d8a0f8
RBP: ffffc900038ffce0 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801c9df800 R14: ffff888146d8a000 R15: 0000000000000000
FS:  0000555556c5e300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000005d84c8 CR3: 0000000070564000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_sync_cancel+0x240/0x630 io_uring/cancel.c:265
 __io_uring_register io_uring/io_uring.c:3833 [inline]
 __do_sys_io_uring_register+0x5c9/0x1110 io_uring/io_uring.c:3878
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f9ae908dd29
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc2e5075e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9ae908dd29
RDX: 0000000020000000 RSI: 0000000000000018 RDI: 000000000000000a
RBP: 00007f9ae9051ed0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 00007f9ae9051f60
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__io_sync_cancel+0x10d/0x1c0 io_uring/cancel.c:224
Code: 48 c1 ea 03 80 3c 02 00 0f 85 aa 00 00 00 49 8b 86 f8 00 00 00 48 8d 1c d8 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 8e 00 00 00 48 8b 1b 48 8d 7d 08 48 b8 00 00 00
RSP: 0018:ffffc900038ffc20 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff83f87914 RDI: ffff888146d8a0f8
RBP: ffffc900038ffce0 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801c9df800 R14: ffff888146d8a000 R15: 0000000000000000
FS:  0000555556c5e300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f622cf74268 CR3: 0000000070564000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 aa 00 00 00    	jne    0xb8
   e:	49 8b 86 f8 00 00 00 	mov    0xf8(%r14),%rax
  15:	48 8d 1c d8          	lea    (%rax,%rbx,8),%rbx
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 da             	mov    %rbx,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 8e 00 00 00    	jne    0xc2
  34:	48 8b 1b             	mov    (%rbx),%rbx
  37:	48 8d 7d 08          	lea    0x8(%rbp),%rdi
  3b:	48                   	rex.W
  3c:	b8                   	.byte 0xb8
  3d:	00 00                	add    %al,(%rax)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
