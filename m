Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B16D4EEA4B
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 11:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344465AbiDAJYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 05:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344463AbiDAJYU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 05:24:20 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411BA26936C
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 02:22:31 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id f18-20020a926a12000000b002be48b02bc6so1424959ilc.17
        for <io-uring@vger.kernel.org>; Fri, 01 Apr 2022 02:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=SiA6SGYJJIZ5dSSuu0urRTJnO2w3RknAKYRvrA5F5nY=;
        b=sv3hyTFJiPF/38HP+Rm9hSwErveZ+hs1aA57ICD4BGZrY3QbdMOAryTvN0clZSnd42
         xqYj6Mm6hd5NSnpZ0b6TcjVaiENcNeySIFJX2XXYhdIW7xkh6wQSFRSOZsvTGJSLj9Xj
         ilRhVso/OIFlYYQUbwyGnhVRiCjjgTvJ39UxiXdezg3EGKIM95PYv0lW4guCVAK0TknP
         2T62nkhC2djBwyFoU/AHmn05og2/Rg7KQCxs3yEE8Zmo2SIIlGe4B1aIC/4QjSu75gVb
         jWC9ujOdSzRbcH0OFN+l5EZnYiNxPB/bkDKw5nP1bkk16sChklvMM6m5mFXT0hjVVyGt
         stVA==
X-Gm-Message-State: AOAM532zqnic9S7z9bKUcv4HpTt+kOeHhmucfToVo+388S6YD+9Yl3G9
        CT8MHvz6+KItvd2TMR1URE/s9nRVZysHYwiG8be0YKoX7w5l
X-Google-Smtp-Source: ABdhPJwIlEf20SuiayZwei8JX5zZOt1ZlKFN06RW8QPp1ET9O17XMgisVehnNnpxaab7p2qZ1jfxPJyP9MGeE06rKoTzANM8Sli2
MIME-Version: 1.0
X-Received: by 2002:a92:1e09:0:b0:2c6:304e:61fa with SMTP id
 e9-20020a921e09000000b002c6304e61famr16320640ile.211.1648804950620; Fri, 01
 Apr 2022 02:22:30 -0700 (PDT)
Date:   Fri, 01 Apr 2022 02:22:30 -0700
In-Reply-To: <00000000000065061a05d85b8262@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000062c05a05db9451e4@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_poll_check_events
From:   syzbot <syzbot+edb9c7738ba8cbdbf197@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e5071887cd22 Add linux-next specific files for 20220401
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1672d26b700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=17fed8f59a304eee
dashboard link: https://syzkaller.appspot.com/bug?extid=edb9c7738ba8cbdbf197
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1016f8f3700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14907c5b700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+edb9c7738ba8cbdbf197@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 1 PID: 3567 Comm: syz-executor893 Not tainted 5.17.0-next-20220401-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:vfs_poll include/linux/poll.h:86 [inline]
RIP: 0010:io_poll_check_events+0x1e0/0x800 fs/io_uring.c:5960
Code: e8 03 48 c7 44 24 60 00 00 00 00 44 89 74 24 68 42 80 3c 28 00 0f 85 ac 05 00 00 48 8b 5d 00 48 8d 7b 28 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 88 05 00 00 48 8b 43 28 48 8d 78 48 48 89 fa
RSP: 0018:ffffc900038ffa00 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801cea0000 RSI: ffffffff81eba128 RDI: 0000000000000028
RBP: ffff8880182d28c0 R08: 0000000000000000 R09: ffff8880182d2947
R10: ffffffff81eba2f4 R11: 0000000000000006 R12: 0000000000000001
R13: dffffc0000000000 R14: 0000000040002038 R15: ffff8880182d2944
FS:  0000555556048300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff954a2e140 CR3: 000000001a5af000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_poll_task_func+0x41/0x500 fs/io_uring.c:5995
 handle_tw_list fs/io_uring.c:2462 [inline]
 tctx_task_work+0x1a4/0x1460 fs/io_uring.c:2496
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 get_signal+0x1c5/0x24c0 kernel/signal.c:2681
 arch_do_signal_or_restart+0x88/0x1a10 arch/x86/kernel/signal.c:867
 exit_to_user_mode_loop kernel/entry/common.c:180 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:215
 __syscall_exit_to_user_mode_work kernel/entry/common.c:297 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:308
 do_syscall_64+0x42/0x80 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff9549bcff9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd1be31e78 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000200 RBX: 0000000000000000 RCX: 00007ff9549bcff9
RDX: 0000000000000000 RSI: 000000000000146f RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff954980880
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:vfs_poll include/linux/poll.h:86 [inline]
RIP: 0010:io_poll_check_events+0x1e0/0x800 fs/io_uring.c:5960
Code: e8 03 48 c7 44 24 60 00 00 00 00 44 89 74 24 68 42 80 3c 28 00 0f 85 ac 05 00 00 48 8b 5d 00 48 8d 7b 28 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 88 05 00 00 48 8b 43 28 48 8d 78 48 48 89 fa
RSP: 0018:ffffc900038ffa00 EFLAGS: 00010206
RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801cea0000 RSI: ffffffff81eba128 RDI: 0000000000000028
RBP: ffff8880182d28c0 R08: 0000000000000000 R09: ffff8880182d2947
R10: ffffffff81eba2f4 R11: 0000000000000006 R12: 0000000000000001
R13: dffffc0000000000 R14: 0000000040002038 R15: ffff8880182d2944
FS:  0000555556048300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff954a2e140 CR3: 000000001a5af000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	e8 03 48 c7 44       	callq  0x44c74808
   5:	24 60                	and    $0x60,%al
   7:	00 00                	add    %al,(%rax)
   9:	00 00                	add    %al,(%rax)
   b:	44 89 74 24 68       	mov    %r14d,0x68(%rsp)
  10:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  15:	0f 85 ac 05 00 00    	jne    0x5c7
  1b:	48 8b 5d 00          	mov    0x0(%rbp),%rbx
  1f:	48 8d 7b 28          	lea    0x28(%rbx),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	0f 85 88 05 00 00    	jne    0x5bd
  35:	48 8b 43 28          	mov    0x28(%rbx),%rax
  39:	48 8d 78 48          	lea    0x48(%rax),%rdi
  3d:	48 89 fa             	mov    %rdi,%rdx

