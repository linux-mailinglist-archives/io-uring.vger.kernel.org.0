Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6323D10D
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 21:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgHETzr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 15:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgHEQqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Aug 2020 12:46:16 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49672C061757;
        Wed,  5 Aug 2020 03:53:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t10so19702088plz.10;
        Wed, 05 Aug 2020 03:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=n6eJX7kP2wSPXMfsAV6wxlSNMqm5O3KWO3aWCRlizZw=;
        b=ZzlJ8kJoS7x+Dr6GTqIhchPVuBKmZlR0zUuECW0cbKEhBrYElwE7LQ7jHTErhJ2kQl
         HVQnpAfXI+4M6TyxQykGyIWV17dv2YXk0J5lTE69XNDRBK1LXR0ximX3GaeNG22uFydr
         Ok3z75gZLQbISvYmmqbaV8a5heyCDdNjeOWBaKc0+opsTD+mbUh7CtRNmRPhtkIwOuMG
         dx04lDe4XSlsBbdWF8ZOdG5ItJ0gSmBe0Pq1nnheKKv4mTaT+zeDTyaNbciggbhd/rcG
         Lc8JSrmCjV1KbqbJi1/NV+Nm4P/P1CRcg8AemG9hRxKK2zDn99xZmgc4m5/u2GoEItk2
         GPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=n6eJX7kP2wSPXMfsAV6wxlSNMqm5O3KWO3aWCRlizZw=;
        b=e5O2msKvhjNQIJGwkKYmDI9kFjPhe/fF79YhuHi5TfW1y9XEKWONSOURpUgnH3hmjo
         ZUiXL01mhX2v9+BdB206RDWAWifm57bVoFaQqYGDCz4J4hN9n+Dh0L4H9NBAlIBmDhdl
         dPqiQbH3HkVa/+9kWnREPDVjZx/Lr0SOoi22vnLPn5YrOfr3RIJiDMFxHawGatuo4CfS
         3hk6hvhmPY0cN6nRr7a0tdOtsqVoW/W1OlJleJO9tsnPm0Lsvr8y/4gQo2Pf049mVdez
         jhZcHgC4Vuocm3L86o7v/ZR44D/sUPyWwbRIELBRemL0MgGEXrYRSfBF4PEXiMbJUjaz
         WOSw==
X-Gm-Message-State: AOAM532skLEgb8PIog7ltvzatOmMAStVqOKgKEO1l7d0fh9OXD/wrf/U
        /GSF7gvS+A3uCCQlsruppmhxMXqv9Tc=
X-Google-Smtp-Source: ABdhPJx8eWt5XQbC91jHW+PQBpRVhEPK391Djy5BqFygVS6+lYLLwe83RtbnRNGUGjnUrVZMyGDKEA==
X-Received: by 2002:a17:90a:5d15:: with SMTP id s21mr2766192pji.154.1596624835362;
        Wed, 05 Aug 2020 03:53:55 -0700 (PDT)
Received: from localhost ([104.192.108.10])
        by smtp.gmail.com with ESMTPSA id n25sm2978818pff.51.2020.08.05.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 03:53:54 -0700 (PDT)
Date:   Wed, 5 Aug 2020 03:53:50 -0700
From:   Guoyu Huang <hgy5945@gmail.com>
To:     viro@zeniv.linux.org.uk, axboe@kernel.dk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: Fix NULL pointer dereference in loop_rw_write()
Message-ID: <20200805105350.GA102801@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

loop_rw_iter() does not check whether the file has a read or
write function. This can lead to NULL pointer dereference
when the user passes in a file descriptor that does not have
read or write function.

The crash log looks like this:

[   99.834071] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   99.835364] #PF: supervisor instruction fetch in kernel mode
[   99.836522] #PF: error_code(0x0010) - not-present page
[   99.837771] PGD 8000000079d62067 P4D 8000000079d62067 PUD 79d8c067 PMD 0
[   99.839649] Oops: 0010 [#2] SMP PTI
[   99.840591] CPU: 1 PID: 333 Comm: io_wqe_worker-0 Tainted: G      D           5.8.0 #2
[   99.842622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[   99.845140] RIP: 0010:0x0
[   99.845840] Code: Bad RIP value.
[   99.846672] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
[   99.848018] RAX: 0000000000000000 RBX: ffff92363bd67300 RCX: ffff92363d461208
[   99.849854] RDX: 0000000000000010 RSI: 00007ffdbf696bb0 RDI: ffff92363bd67300
[   99.851743] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
[   99.853394] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
[   99.855148] R13: 0000000000000000 R14: ffff92363d461208 R15: ffffa1c7c01ebc68
[   99.856914] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
[   99.858651] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.860032] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0
[   99.861979] Call Trace:
[   99.862617]  loop_rw_iter.part.0+0xad/0x110
[   99.863838]  io_write+0x2ae/0x380
[   99.864644]  ? kvm_sched_clock_read+0x11/0x20
[   99.865595]  ? sched_clock+0x9/0x10
[   99.866453]  ? sched_clock_cpu+0x11/0xb0
[   99.867326]  ? newidle_balance+0x1d4/0x3c0
[   99.868283]  io_issue_sqe+0xd8f/0x1340
[   99.869216]  ? __switch_to+0x7f/0x450
[   99.870280]  ? __switch_to_asm+0x42/0x70
[   99.871254]  ? __switch_to_asm+0x36/0x70
[   99.872133]  ? lock_timer_base+0x72/0xa0
[   99.873155]  ? switch_mm_irqs_off+0x1bf/0x420
[   99.874152]  io_wq_submit_work+0x64/0x180
[   99.875192]  ? kthread_use_mm+0x71/0x100
[   99.876132]  io_worker_handle_work+0x267/0x440
[   99.877233]  io_wqe_worker+0x297/0x350
[   99.878145]  kthread+0x112/0x150
[   99.878849]  ? __io_worker_unuse+0x100/0x100
[   99.879935]  ? kthread_park+0x90/0x90
[   99.880874]  ret_from_fork+0x22/0x30
[   99.881679] Modules linked in:
[   99.882493] CR2: 0000000000000000
[   99.883324] ---[ end trace 4453745f4673190b ]---
[   99.884289] RIP: 0010:0x0
[   99.884837] Code: Bad RIP value.
[   99.885492] RSP: 0018:ffffa1c7c01ebc08 EFLAGS: 00010202
[   99.886851] RAX: 0000000000000000 RBX: ffff92363acd7f00 RCX: ffff92363d461608
[   99.888561] RDX: 0000000000000010 RSI: 00007ffe040d9e10 RDI: ffff92363acd7f00
[   99.890203] RBP: ffffa1c7c01ebc40 R08: 0000000000000000 R09: 0000000000000000
[   99.891907] R10: ffffffff9ec692a0 R11: 0000000000000000 R12: 0000000000000010
[   99.894106] R13: 0000000000000000 R14: ffff92363d461608 R15: ffffa1c7c01ebc68
[   99.896079] FS:  0000000000000000(0000) GS:ffff92363dd00000(0000) knlGS:0000000000000000
[   99.898017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.899197] CR2: ffffffffffffffd6 CR3: 000000007ac66000 CR4: 00000000000006e0

Signed-off-by: Guoyu Huang <hgy5945@gmail.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 493e5047e67c..3c21e2e002b4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2661,8 +2661,10 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)

 		if (req->file->f_op->read_iter)
 			ret2 = call_read_iter(req->file, kiocb, &iter);
-		else
+		else if (req->file->f_op->read)
 			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;

 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
@@ -2776,8 +2778,10 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)

 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
-		else
+		else if (req->file->f_op->write)
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+		else
+			ret2 = -EINVAL;

 		if (!force_nonblock)
 			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
--
2.25.1

