Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3D83F533E
	for <lists+io-uring@lfdr.de>; Tue, 24 Aug 2021 00:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhHWWPJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 18:15:09 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:54271 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbhHWWPI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 18:15:08 -0400
Received: by mail-il1-f198.google.com with SMTP id c4-20020a056e020cc4b02902242bd90889so10604480ilj.20
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 15:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=SijtErviYrCHOwNGj36E6qhULs4xNwl8A7hm7GnvXvE=;
        b=Gv9eTrKglxXPBRRlD/+zSZOmpb/17U+Q0kl5300x8dQHZP/4Vo7pJvH4zf3Mmw6zQv
         JTqrPBaec8AFZQrCLU5E75spMXbozyTyteHacY30O67d5nStzYohwhGvajdpRsADx/9V
         tTJleVhDval52Dr45a94N7i14HpvUoDb6KQgznQX+8/u4IT/xDRftP87A6c5ea1kRK+8
         F58gHUTnPM36vPnecitBDxodKv3efVcv9bzuRP5DYN8hNBPpKAcm/a4HHZTbn1wRFnry
         oS5qXlNM57uEfwWW93xd6sQGMTa1riL4FXhRIBXJf9gTiHWZgMhSaqxRNKUYb7pV5WG7
         w48w==
X-Gm-Message-State: AOAM5334g+G7Xqwnn1HOw3Vg8lXBNqsAV+oekDLFZ+FuHiETcqBHVoLL
        kVOSTHOJZU4nh7Z7jBcVofP28evzpzQmgpq50I7CX44UIWE5
X-Google-Smtp-Source: ABdhPJzgIU95H75Qye1pqMQAP+Qs42AogeQcfFBEzerm+aKBHu7KDlqp8xbCLvNExijDvof70hSQkbOmc+hUY0qJ2uNkXpSLv9b5
MIME-Version: 1.0
X-Received: by 2002:a6b:e712:: with SMTP id b18mr28344115ioh.186.1629756865099;
 Mon, 23 Aug 2021 15:14:25 -0700 (PDT)
Date:   Mon, 23 Aug 2021 15:14:25 -0700
In-Reply-To: <000000000000dd79fc05ca367b9d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000003bb1805ca4157a5@google.com>
Subject: Re: [syzbot] WARNING in io_try_cancel_userdata
From:   syzbot <syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    46debfec12b4 Add linux-next specific files for 20210823
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12f00c39300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=49609005dc034be7
dashboard link: https://syzkaller.appspot.com/bug?extid=b0c9d1588ae92866515f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15830bee300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7008 at fs/io_uring.c:6082 io_try_cancel_userdata+0x30d/0x540 fs/io_uring.c:6082
Modules linked in:
CPU: 0 PID: 7008 Comm: iou-wrk-7007 Not tainted 5.14.0-rc7-next-20210823-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_try_cancel_userdata+0x30d/0x540 fs/io_uring.c:6082
Code: 52 07 e8 66 67 95 ff 48 8b 3c 24 e8 ad 67 52 07 e9 71 fe ff ff e8 53 67 95 ff 41 bf 8e ff ff ff e9 61 fe ff ff e8 43 67 95 ff <0f> 0b 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 80 3c 02
RSP: 0018:ffffc90003fefac0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88801d064c80 RCX: 0000000000000000
RDX: ffff88801ea75580 RSI: ffffffff81e078fd RDI: ffff88801d064cd0
RBP: ffff88801ea75580 R08: ffffffff899adde0 R09: ffffffff81e1e4e4
R10: 0000000000000027 R11: 000000000000000e R12: 1ffff920007fdf59
R13: 0000000000012345 R14: ffff888146628000 R15: ffff88801d064ce0
FS:  00007f0c5b7d6700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc3bfd8720 CR3: 0000000070d9c000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_async_cancel fs/io_uring.c:6122 [inline]
 io_issue_sqe+0x22d5/0x67b0 fs/io_uring.c:6515
 io_wq_submit_work+0x1d4/0x300 fs/io_uring.c:6619
 io_worker_handle_work+0x1584/0x1810 fs/io-wq.c:533
 io_wqe_worker+0x9cd/0xbb0 fs/io-wq.c:606
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

