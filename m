Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F963C5A1A
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 13:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379889AbhGLJbN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 05:31:13 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41923 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379869AbhGLJbG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 05:31:06 -0400
Received: by mail-io1-f71.google.com with SMTP id b13-20020a056602330db02905101d652a35so11412558ioz.8
        for <io-uring@vger.kernel.org>; Mon, 12 Jul 2021 02:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RqEuL8434mkrR62CcVotYB74q2KSRIID0fO56L4zDhw=;
        b=pu1NTzdAEBLsfAligWgzwqroWDBmrgzmarBLSjUMCBAwP4ED9qCoLCUGohGQgl6LPW
         ImaZjGTmpNaykGm+OMxQ9XL8eMWatpv96kfiKytjIIRh23DiJ1sUq2q1MoA4IoZRjRhi
         2MfOqIP7WlxrZ9U1FwqF+8zWueEfWiUWsgVpwZgDrRn6SrAoZczV1Rxn5AsndLtpspB7
         kV4DZP+/wU459mXdx9ZgKHjSL+32t3v9xLVf6pBxBsMo/mYHlKEGgpF9oxeiyUQ2cYsz
         EvUtF5IkkWZEkXVDR5CMTog8xi+DzeY0HVYygfEdJOz7un8ggsxl/xmj9Lc2xUecWSfQ
         JSew==
X-Gm-Message-State: AOAM530ZKmGoO8ylOEg2+422jqseRR8zvjtouS5nj9jN7cy9x5DxjEt0
        ZCtYePw/Ap5vPKYGgd3DcLERZYzjsErTryPa0+w6/34gC47G
X-Google-Smtp-Source: ABdhPJxYCtcbgCqEfRSlWV44wvQRTMpOBo4rvqW47TCzvOkoh35x56g7oOGFpGjzNwZX9WFCUal/e4XtYpIX7Z4Oq2lhCpU5KPd+
MIME-Version: 1.0
X-Received: by 2002:a05:6602:146:: with SMTP id v6mr38780269iot.5.1626082097781;
 Mon, 12 Jul 2021 02:28:17 -0700 (PDT)
Date:   Mon, 12 Jul 2021 02:28:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d0615505c6e9bd7f@google.com>
Subject: [syzbot] kernel BUG in io_queue_async_work
From:   syzbot <syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e2f74b13 Add linux-next specific files for 20210708
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14fc6fb4300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59e1e3bbc3afca75
dashboard link: https://syzkaller.appspot.com/bug?extid=d50e4f20cfad4510ec22

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/io_uring.c:1293!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 18789 Comm: kworker/0:10 Not tainted 5.13.0-next-20210708-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events io_fallback_req_func
RIP: 0010:io_queue_async_work+0x539/0x5f0 fs/io_uring.c:1293
Code: 89 be 89 00 00 00 48 c7 c7 00 8a 9a 89 c6 05 28 5f 77 0b 01 e8 be e9 06 07 e9 6e ff ff ff e8 be 1e 95 ff 0f 0b e8 b7 1e 95 ff <0f> 0b e8 b0 1e 95 ff 0f 0b e9 1a fd ff ff e8 d4 2f db ff e9 47 fb
RSP: 0018:ffffc900032efba8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802840c800 RCX: 0000000000000000
RDX: ffff888082e09c80 RSI: ffffffff81e07d49 RDI: ffff8880224da498
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000043736500
R10: ffffffff81e222ff R11: 0000000000000000 R12: ffff8880782e78c0
R13: 0000000000000019 R14: ffff88802840c8b0 R15: ffff8880782e7918
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe2796bd8c CR3: 000000000b68e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __io_queue_sqe+0x913/0xf10 fs/io_uring.c:6444
 io_req_task_submit+0x100/0x120 fs/io_uring.c:2020
 io_fallback_req_func+0x81/0xb0 fs/io_uring.c:2437
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 4d51acadba583174 ]---
RIP: 0010:io_queue_async_work+0x539/0x5f0 fs/io_uring.c:1293
Code: 89 be 89 00 00 00 48 c7 c7 00 8a 9a 89 c6 05 28 5f 77 0b 01 e8 be e9 06 07 e9 6e ff ff ff e8 be 1e 95 ff 0f 0b e8 b7 1e 95 ff <0f> 0b e8 b0 1e 95 ff 0f 0b e9 1a fd ff ff e8 d4 2f db ff e9 47 fb
RSP: 0018:ffffc900032efba8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88802840c800 RCX: 0000000000000000
RDX: ffff888082e09c80 RSI: ffffffff81e07d49 RDI: ffff8880224da498
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000043736500
R10: ffffffff81e222ff R11: 0000000000000000 R12: ffff8880782e78c0
R13: 0000000000000019 R14: ffff88802840c8b0 R15: ffff8880782e7918
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3dee45e000 CR3: 000000002dd4e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
