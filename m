Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27133E23A7
	for <lists+io-uring@lfdr.de>; Fri,  6 Aug 2021 09:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbhHFHCg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Aug 2021 03:02:36 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35691 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbhHFHCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Aug 2021 03:02:34 -0400
Received: by mail-il1-f198.google.com with SMTP id v18-20020a056e020f92b02901ff388acf98so4108361ilo.2
        for <io-uring@vger.kernel.org>; Fri, 06 Aug 2021 00:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YOruhbXjknj07TqBsDd0ivPVwgxxq4P/kYOSASbx7Ew=;
        b=n+tIAdE3q59VsYDK+/rAia72g+PbJA3kwDWeInB6HrPrgKaRxGhjXyWoUesq5hAnC7
         4v9PTcnjsiK75g5TSCHvWtaFCnuBLjN13dMehpB6pceK9ZC8WbGCkV7cWbGcai2ZgZID
         FC/F2Kx1LKfr9/Hiis3EgZF3rLniVQOdsLdDrAWAgvOHiZUQ07oFq+9gayZ7hVCtC4OP
         mdLWCIgqRjRVgEFwZCTZprF4JX/eU5aT+i5KN6woN0plBBLYdzVI+vwxl96fJWRR9Etp
         e7qWi9Z7piTcodLg50lp1nPGmJrnCzZ6YIWSvLeCYJv00NHOtz8D1sjK2nNpc7rI1qB9
         W1/g==
X-Gm-Message-State: AOAM5317eNAB195BTGUCEhR2frZcifXU3ZsyyfRmR2VWaWMKB/NzUUk4
        T6doePVzBF1GDFIC0mAC9DsugRBfXJI0oyY8a2lRfpxrkCKp
X-Google-Smtp-Source: ABdhPJwswUO3MfN3mtN9XHnSiTVAxxfoMmn5e49ROfk1F6/xPYpe19YzKWLf6TrZX7Om0L9nzSglH0wT1EeozMwF0UeZuO9oJOif
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2e8a:: with SMTP id m10mr233364iow.45.1628233339292;
 Fri, 06 Aug 2021 00:02:19 -0700 (PDT)
Date:   Fri, 06 Aug 2021 00:02:19 -0700
In-Reply-To: <0000000000005225a605bd97fa64@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cccfe405c8de9d1c@google.com>
Subject: Re: [syzbot] WARNING in io_ring_exit_work
From:   syzbot <syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    8d4b477da1a8 Add linux-next specific files for 20210730
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1478e4fa300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4adf4987f875c210
dashboard link: https://syzkaller.appspot.com/bug?extid=00e15cda746c5bc70e24
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d5cd96300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1798471e300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1182 at fs/io_uring.c:8802 io_ring_exit_work+0x24e/0x1600 fs/io_uring.c:8802
Modules linked in:
CPU: 1 PID: 1182 Comm: kworker/u4:5 Not tainted 5.14.0-rc3-next-20210730-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound io_ring_exit_work
RIP: 0010:io_ring_exit_work+0x24e/0x1600 fs/io_uring.c:8802
Code: 30 11 00 00 48 8b 05 c1 dc 80 09 31 ff 48 8b 2c 24 48 29 c5 48 89 ee e8 c0 a8 95 ff 48 85 ed 0f 89 a8 fe ff ff e8 52 a3 95 ff <0f> 0b e9 9c fe ff ff e8 46 a3 95 ff 48 c7 c2 c0 25 2a 90 48 c7 c6
RSP: 0018:ffffc90004ed7b98 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff88801c921c80 RSI: ffffffff81e014de RDI: 0000000000000003
RBP: ffffffffffffffff R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81e014d0 R11: 0000000000000000 R12: fffffbfff16c1e30
R13: ffffed100e3f4894 R14: ffff888071fa4920 R15: ffff888071fa4000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000488 CR3: 00000001c82cf000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

