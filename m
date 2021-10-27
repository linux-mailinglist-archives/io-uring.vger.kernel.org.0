Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EBF43BEFC
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 03:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237460AbhJ0B3c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Oct 2021 21:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhJ0B32 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Oct 2021 21:29:28 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D10C061570;
        Tue, 26 Oct 2021 18:27:03 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id o133so1148410pfg.7;
        Tue, 26 Oct 2021 18:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=in2IT+3mSwE8tp25ZK3anihHaZVwSuOsI+bIaMO5RWM=;
        b=QgwCsKNtgEbQshdKjClqHboymG6L1itQ+OUIpXlSaWZDuRpUTQxUJu5JvOzPts6ura
         RbV2ZDA7EocIQX7dZq92TXpF18NaP4cmDdLsGWvf11nUe8bbLc5Z+IL8EROxyr/ENd4e
         97bAmGNq+7eAXqdhcD0y01AhG02SggX1sDNHDNXcibnR7RF1Q4dUco/tf9KYlpfAwmXG
         YZts9w7POOSv9lxm51MVPyhwZL/Pzw89gedV14Ynktos/8STUSUHPG2fzWcMlwvaAZQ2
         c/g5iDWkq6MuIsHvENndje78ijSQ/5GvrfEo/llJdFgc0mOLHtJks/67mMEdSJk29R8h
         c9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=in2IT+3mSwE8tp25ZK3anihHaZVwSuOsI+bIaMO5RWM=;
        b=WO31qT5Y0kD7nIxncH/Lm/0whYvnezWtt+XHmEwW7U4uR9RMYo7NfEw3jqBmC0fwx9
         TIkOECL9t60E8+oVKEDcw3SzvmSLGj4Cvxx8ZDjWFWtzIRnLAbnGZlhpWB8zJVoAYxWX
         m/7JwIdHxCdDeGTmJ7Re/DgYH5Q+s78WcWhvJyh8bJtQIW09nIKWpA/6lncwemuyJFbi
         7qip9oH2cZs/0C4x+o88KRT3zkO4EKIYE50fp0ycP9im8bVCkr/0XFi2LoxLawHYnlbl
         SaPzxlTJ0dZwyIf9VWp71KbInLbhdqDSA6bP3LpQN89AinfjDlisVE8utEK+gROnmPUT
         52/w==
X-Gm-Message-State: AOAM532GmL+PYZgvePxvoOAUhYWopq3ROGTJCx1eA+2WPF6fgBNDNfkw
        rlzXZp+oPthcLGqREdv2i1wEYFyXYyCqYRm4YA==
X-Google-Smtp-Source: ABdhPJzlRP9hUvJlwtoBlh/pQQz3JIxQ9fXjEYglXSMoVSEGnutcu8Qqc1Lg2FtstfcioORxr/UUkCP36zPWG3+ZnRM=
X-Received: by 2002:a05:6a00:1242:b0:44c:2025:29e3 with SMTP id
 u2-20020a056a00124200b0044c202529e3mr29848282pfi.59.1635298022875; Tue, 26
 Oct 2021 18:27:02 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 27 Oct 2021 09:26:49 +0800
Message-ID: <CACkBjsY6iQ7JObmRiU+ztLayVoLi7X42=VFT38aC3Agj_KLkxw@mail.gmail.com>
Subject: WARNING in io_ring_exit_work
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 519d81956ee2 Linux 5.15-rc6
git tree: upstream
console output:
https://drive.google.com/file/d/1d_-yYvTUew4bWhNCFt9Fs2zdpijQwnwd/view?usp=sharing
kernel config: https://drive.google.com/file/d/12PUnxIM1EPBgW4ZJmI7WJBRaY1lA83an/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

------------[ cut here ]------------
WARNING: CPU: 2 PID: 16505 at fs/io_uring.c:9413
io_ring_exit_work+0x23e/0x1550 fs/io_uring.c:9413
Modules linked in:
CPU: 2 PID: 16505 Comm: kworker/u9:6 Not tainted 5.15.0-rc6 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events_unbound io_ring_exit_work
RIP: 0010:io_ring_exit_work+0x23e/0x1550 fs/io_uring.c:9413
Code: 00 0f 85 67 0f 00 00 48 8b 05 ce b4 7c 09 31 ff 4c 8b 64 24 40
49 29 c4 4c 89 e6 e8 7c 23 92 ff 4d 85 e4 79 0d e8 f2 21 92 ff <0f> 0b
41 bd 70 17 00 00 e8 e5 21 92 ff 4c 89 ee 4c 89 ff e8 6a 42
RSP: 0018:ffffc90001fafbb0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802fd22000 RCX: ffff8880144ab900
RDX: 0000000000000000 RSI: ffff8880144ab900 RDI: 0000000000000002
RBP: ffffc90001fafd28 R08: ffffffff81e43cce R09: 0000000000000000
R10: 0000000000000007 R11: ffffed1005fa44c0 R12: fffffffffffffffc
R13: 0000000000000005 R14: dffffc0000000000 R15: ffff88802fd22920
FS:  0000000000000000(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3bcc12b000 CR3: 000000000b68e000 CR4: 0000000000350ee0
Call Trace:
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Kernel panic - not syncing: panic_on_warn set ...
CPU: 2 PID: 16505 Comm: kworker/u9:6 Not tainted 5.15.0-rc6 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 panic+0x2b0/0x6dd kernel/panic.c:232
 __warn.cold+0x20/0x2f kernel/panic.c:603
 report_bug+0x273/0x300 lib/bug.c:199
 handle_bug+0x3c/0x60 arch/x86/kernel/traps.c:239
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:259
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:566
RIP: 0010:io_ring_exit_work+0x23e/0x1550 fs/io_uring.c:9413
Code: 00 0f 85 67 0f 00 00 48 8b 05 ce b4 7c 09 31 ff 4c 8b 64 24 40
49 29 c4 4c 89 e6 e8 7c 23 92 ff 4d 85 e4 79 0d e8 f2 21 92 ff <0f> 0b
41 bd 70 17 00 00 e8 e5 21 92 ff 4c 89 ee 4c 89 ff e8 6a 42
RSP: 0018:ffffc90001fafbb0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802fd22000 RCX: ffff8880144ab900
RDX: 0000000000000000 RSI: ffff8880144ab900 RDI: 0000000000000002
RBP: ffffc90001fafd28 R08: ffffffff81e43cce R09: 0000000000000000
R10: 0000000000000007 R11: ffffed1005fa44c0 R12: fffffffffffffffc
R13: 0000000000000005 R14: dffffc0000000000 R15: ffff88802fd22920
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Dumping ftrace buffer:
   (ftrace buffer empty)
Kernel Offset: disabled
Rebooting in 1 seconds..
