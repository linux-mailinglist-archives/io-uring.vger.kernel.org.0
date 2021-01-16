Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064122F8DF9
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 18:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbhAPRGM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 12:06:12 -0500
Received: from mail-pl1-f199.google.com ([209.85.214.199]:32863 "EHLO
        mail-pl1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbhAPQh7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 11:37:59 -0500
Received: by mail-pl1-f199.google.com with SMTP id a21so6268456pls.0
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 08:37:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xmu1bAJMqYAQJZd2tpHte/jVzTDcoISvLjpkL3yBNXk=;
        b=mVeulRRDS7zWyqzm1tFZgWS7bWnmJvaEn+OxR3aqsoln5rBNTxH7QjmFNl2/hRgOKX
         sqM/3dTF3772WUYz7w/zavYI3f83jJXClDDh0Gx2z9HP9j4q6oARpPPOf3Z+FN+r92Jd
         xXckqJlqLaKSY08Y2Q8QqYjtt3lPvoGZblvOSMC68+fh0+K+WKTcp6pj087MBJsTfS0w
         MtvrvT2EaWlB61Go+tkeZT6V6LDiwGTtjAACNhzRRPny8PLgRf+9T+77U952y5v8Rwwl
         qCHP2Kb+Lqs7PF1RUy99nkw6TDTqLkbS3K/R8voaHtB+Xvy9NVCH3MQ5tnTgiVMwS50R
         5uuQ==
X-Gm-Message-State: AOAM531awwJ3B44n550ZBR70Hc6rqUY6GbdjCmiMQrB+XaOk59eYFQbx
        UWQN9mAzH2ObQxXybXuTszNNhKscffxQcyZH8inKFJkzNdLU
X-Google-Smtp-Source: ABdhPJxzX7+ZImt+e5kh0Ekrc1+vQpIc2kaW7a8DlwiGv80W7dn/0vHbU9l4ZHIhrE7K8TO7fl0zzmceiFZBj06mFHYUBjBOwR86
MIME-Version: 1.0
X-Received: by 2002:a92:c002:: with SMTP id q2mr15171843ild.186.1610805796695;
 Sat, 16 Jan 2021 06:03:16 -0800 (PST)
Date:   Sat, 16 Jan 2021 06:03:16 -0800
In-Reply-To: <0000000000002c365205b8f26d09@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000050736105b904f335@google.com>
Subject: Re: WARNING in io_uring_flush
From:   syzbot <syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    1d94330a Merge tag 'for-5.11/dm-fixes-1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13210c3b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
dashboard link: https://syzkaller.appspot.com/bug?extid=a32b546d58dde07875a1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d14c58d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a2feb8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a32b546d58dde07875a1@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8613 at fs/io_uring.c:9096 io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
Modules linked in:
CPU: 1 PID: 8613 Comm: syz-executor948 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_uring_flush+0x326/0x3a0 fs/io_uring.c:9096
Code: e9 58 fe ff ff e8 aa e3 9a ff 49 c7 84 24 a0 00 00 00 00 00 00 00 e9 aa fe ff ff e8 74 9e dd ff e9 91 fd ff ff e8 8a e3 9a ff <0f> 0b e9 51 ff ff ff e8 6e 9e dd ff e9 06 fd ff ff 4c 89 f7 e8 61
RSP: 0018:ffffc90001a4faa0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801113b780 RSI: ffffffff81d7e636 RDI: 0000000000000003
RBP: ffff88801c862280 R08: 0000000000000000 R09: 00000000196e5401
R10: ffffffff81d7e585 R11: 0000000000000000 R12: ffff888019724000
R13: ffff8880196e5401 R14: ffff888019724040 R15: ffff8880197240d0
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000025f8e000 CR4: 0000000000350ef0
Call Trace:
 filp_close+0xb4/0x170 fs/open.c:1280
 close_files fs/file.c:401 [inline]
 put_files_struct fs/file.c:416 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:413
 exit_files+0x7e/0xa0 fs/file.c:433
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x3e9/0x20a0 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446b69
Code: Unable to access opcode bytes at RIP 0x446b3f.
RSP: 002b:00007fbb80bcecf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006dbc28 RCX: 0000000000446b69
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dbc28
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 00007ffc1b88469f R14: 00007fbb80bcf9c0 R15: 00000000006dbc2c

