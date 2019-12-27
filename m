Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67B712B243
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2019 08:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfL0HNK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Dec 2019 02:13:10 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40489 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfL0HNK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Dec 2019 02:13:10 -0500
Received: by mail-il1-f197.google.com with SMTP id e4so10924786ilm.7
        for <io-uring@vger.kernel.org>; Thu, 26 Dec 2019 23:13:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qT/dFbKkgsV/TviWbRV8GBUOtJP8/w1B8XzceuAp8Gs=;
        b=Ck9bGUzpmXTO3tUtVtwLsAIOn7UqdPyxjgyKb5EtDhHyqj8l/MBq/hGx2ajEr4CQ2h
         W30kgKqeHendl+v2WOO0F+d4yuPtVeSnOHxR+VHHrC9ciETsEX6Mp3rVnoNujnK7GLyD
         eJVjKs39LkzyVKuW2OR5v2HV71YKal+D7Ha01mH+tORAZQ8EIV0K0tiq1M94g/fuvnfv
         6uD7Kvs4Lk1ds/rr/gJWa+fvy5vlXXy95P0OwJEZSsWjCo8AVNbej13nTvF5xCVB+J/m
         2RdajqvSFGud1j5j3I8jIGRvY/5N0MTrcLi54CZB5es+ZHLti+i9c+5UxsF2kwOb0yVO
         i9wA==
X-Gm-Message-State: APjAAAX+kSJJixFlrTNvzmwAGidZq6lRgdWebbJPFui1rlppeIbfxdyO
        IVh0YAJENnFrQU9MU6SUhAGhypnKYIfntjCYCUlOhl9QiPjf
X-Google-Smtp-Source: APXvYqzCGihC4JCmnjNiqTgeplGWr46CydCCqxAuOZQm21vAIZTVS3MaFLswpfFnpHi38UlIj6iMlSYZKT3BiRpGSJKSnT4indUb
MIME-Version: 1.0
X-Received: by 2002:a6b:f913:: with SMTP id j19mr31529823iog.124.1577430788237;
 Thu, 26 Dec 2019 23:13:08 -0800 (PST)
Date:   Thu, 26 Dec 2019 23:13:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca7268059aaa3987@google.com>
Subject: general protection fault in __io_uring_register
From:   syzbot <syzbot+6b340e00888c8016e91d@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ddd09fc Add linux-next specific files for 20191220
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1295eec1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f183b01c3088afc6
dashboard link: https://syzkaller.appspot.com/bug?extid=6b340e00888c8016e91d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6b340e00888c8016e91d@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 21080 Comm: syz-executor.2 Not tainted  
5.5.0-rc2-next-20191220-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:io_sqe_files_register fs/io_uring.c:4941 [inline]
RIP: 0010:__io_uring_register+0x555/0x2790 fs/io_uring.c:6121
Code: 3c 02 00 0f 85 7e 20 00 00 49 8b 9f 68 01 00 00 e8 e0 90 9d ff 48 8d  
7b 48 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 49 20 00 00 48 8b 95 20 ff ff ff 48 c7 43 48 00
RSP: 0018:ffffc9000491fd10 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000e02f000
RDX: 0000000000000009 RSI: ffffffff81d7c4b0 RDI: 0000000000000048
RBP: ffffc9000491fea8 R08: 1ffffffff165b7dd R09: fffffbfff165b7de
R10: fffffbfff165b7dd R11: ffffffff8b2dbeef R12: ffff88809457a600
R13: 0000000000000002 R14: 000000000000035b R15: ffff8880a76c5800
FS:  00007f6f11615700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff73a203db8 CR3: 000000009ae2a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __do_sys_io_uring_register fs/io_uring.c:6177 [inline]
  __se_sys_io_uring_register fs/io_uring.c:6159 [inline]
  __x64_sys_io_uring_register+0x1a1/0x570 fs/io_uring.c:6159
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a919
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6f11614c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000045a919
RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000035b R11: 0000000000000246 R12: 00007f6f116156d4
R13: 00000000004cf810 R14: 00000000004d70a0 R15: 00000000ffffffff
Modules linked in:
---[ end trace 128a762a80939ab8 ]---
RIP: 0010:io_sqe_files_register fs/io_uring.c:4941 [inline]
RIP: 0010:__io_uring_register+0x555/0x2790 fs/io_uring.c:6121
Code: 3c 02 00 0f 85 7e 20 00 00 49 8b 9f 68 01 00 00 e8 e0 90 9d ff 48 8d  
7b 48 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 49 20 00 00 48 8b 95 20 ff ff ff 48 c7 43 48 00
RSP: 0018:ffffc9000491fd10 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000e02f000
RDX: 0000000000000009 RSI: ffffffff81d7c4b0 RDI: 0000000000000048
RBP: ffffc9000491fea8 R08: 1ffffffff165b7dd R09: fffffbfff165b7de
R10: fffffbfff165b7dd R11: ffffffff8b2dbeef R12: ffff88809457a600
R13: 0000000000000002 R14: 000000000000035b R15: ffff8880a76c5800
FS:  00007f6f11615700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff73a203db8 CR3: 000000009ae2a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
