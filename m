Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01663B445
	for <lists+io-uring@lfdr.de>; Mon, 28 Nov 2022 22:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiK1Vel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Nov 2022 16:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiK1Vej (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Nov 2022 16:34:39 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF572FFDC
        for <io-uring@vger.kernel.org>; Mon, 28 Nov 2022 13:34:37 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id x5-20020a6bda05000000b006db3112c1deso6850312iob.0
        for <io-uring@vger.kernel.org>; Mon, 28 Nov 2022 13:34:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c8gSxVgdaAR7lRcCfZ2yDO/aV/WJWwxDePyjK/ZIADQ=;
        b=bN3wfAdwVLlD6XWNmAx/oJLsbQkt1bIt5jsfExr3iFNahqqcvrNUP98dRCEbINr/rA
         4VdRgBPYpJ2wIsyPlIwtTrFaK1NVJEnQ5bG90h4bqcE1tPc7LIZFRZ0xaWPt+w5+dTSV
         d/FVQZogwUINvumlr/62i/ywohLpEVimkzuEuOLnZSk5wVDBqQaONTAav7gJuwJCcN6o
         uOmJ5kTi74YFWyuQmV66FjvvK1ttCr4wY7B8yizdUdSS3fj3yKdZyu/n9nWta3NrxgiV
         rGCc6KyazXqVcTsLOHmrSzMeZS0nEqkWxb8KdOD2eCdl2iGREw4YgVU41ZafT98mZLmf
         bCDA==
X-Gm-Message-State: ANoB5pmhLMqZAVNrzI6Wf+eKvC7ncn7GMIAcVGeL8JP6LqDgfXkHsNlf
        d2m1gbzkXW+V4z1DZGjkoKedZUadb2cCSthWSho8vUTiKOAs
X-Google-Smtp-Source: AA0mqf66McWjyUifFkuhfDapgg2ShTwWb3jQsxIK+Yo/02t2689D1sfMeMzZqm6KASF5/B3KYLrJaytaDedlzuIAk3xThPY/LtAR
MIME-Version: 1.0
X-Received: by 2002:a92:8e08:0:b0:302:c028:895b with SMTP id
 c8-20020a928e08000000b00302c028895bmr15003482ild.154.1669671276390; Mon, 28
 Nov 2022 13:34:36 -0800 (PST)
Date:   Mon, 28 Nov 2022 13:34:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000052344f05ee8ea3b8@google.com>
Subject: [syzbot] WARNING in io_req_complete_failed
From:   syzbot <syzbot+bc54516b728ef2a08d76@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c35bd4e42885 Add linux-next specific files for 20221124
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=130f4e73880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11e19c740a0b2926
dashboard link: https://syzkaller.appspot.com/bug?extid=bc54516b728ef2a08d76
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10082015880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11107a05880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/968fee464d14/disk-c35bd4e4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4f46fe801b5b/vmlinux-c35bd4e4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c2cdf8fb264e/bzImage-c35bd4e4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bc54516b728ef2a08d76@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 151 at io_uring/io_uring.c:872 io_req_complete_failed+0x223/0x280 io_uring/io_uring.c:872
Modules linked in:
CPU: 0 PID: 151 Comm: kworker/0:2 Not tainted 6.1.0-rc6-next-20221124-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events io_fallback_req_func
RIP: 0010:io_req_complete_failed+0x223/0x280 io_uring/io_uring.c:872
Code: 58 be ff ff ff ff 48 8d b8 a8 00 00 00 e8 a5 24 03 06 31 ff 89 c3 89 c6 e8 3a 43 7d fd 85 db 0f 85 66 fe ff ff e8 7d 46 7d fd <0f> 0b e9 5a fe ff ff e8 91 66 cb fd e9 06 fe ff ff e8 67 67 cb fd
RSP: 0018:ffffc90002e9fc28 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801a690000 RSI: ffffffff84038513 RDI: 0000000000000005
RBP: ffff88807e9aa3c0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff21621e8 R12: 0000000000000016
R13: 00000000ffffff83 R14: dffffc0000000000 R15: ffffffffffffff78
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe6e758a01d CR3: 000000000c48e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_apoll_task_func+0x14d/0x170 io_uring/poll.c:319
 io_fallback_req_func+0xfd/0x1b2 io_uring/io_uring.c:250
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
