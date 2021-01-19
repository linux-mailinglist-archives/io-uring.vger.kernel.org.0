Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA5D2FBD69
	for <lists+io-uring@lfdr.de>; Tue, 19 Jan 2021 18:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390364AbhASRTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 12:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391533AbhASRTW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 12:19:22 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662C1C061573
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 09:18:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id p15so308817pjv.3
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 09:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sSkm7SjliZxex2Zt76tX01uRvPtpzF92Rua8y8+ITV4=;
        b=unLcbIYYrEFujLfTCi8auMRpwa+7TX1bg811zJD+2K3qwpZXWqvF+ry69MQpZ6yzdl
         mbTwLFdH5j4CYqXSGvl2vnD3E1tnL+lzU8sVaegypjc4yq0wVngb+uOhWpodD+TwGDCh
         KqLf48mwKtTMMS5rXq+JL7sTNFul2PHrLIlFOvX1LXltLJE3N8/M0/yu3ZQWtPW3pvUm
         Z1Wewl8NsrxsLuxoFl+pRJIfRbQl0Np2Ac5uS8+dHmuxHCdQKMRx9wkHAP9OEhe/vKGU
         yoxtuH1uaBn27cvT3u+2sWKlxh3Dt5/w9Ada0MEWQyw0I6a+RV1Z6qny9jRR/1667yok
         j6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sSkm7SjliZxex2Zt76tX01uRvPtpzF92Rua8y8+ITV4=;
        b=mHPh82CSh6hq0G3QJxdttt5baJiomRiX1lbMDqVCTAFljb8+CWjZRSEs2W9Dmn9WLr
         7CF/KE6ynfoATulkdvllOqqAV+dwcP1U72GAMzvdsOOPHUoaL6/QMt/RMhm2xTFQ32RH
         RFfK80YceGnhxldMJZSFacR0f+XtojNjWkuNh3uh5LdRQE5F8gaSzbIIp2vO8ioBHyRE
         GQe/j4R3x0pk4BIm3DkNih9SRLCDOiB4/kAi9I5Nd/JNYPw8+GPMRScglQ7YIy4/akrd
         jti+rdLtxj0pgl516tkOLaUASiHrW6FNcchWJVzOHph61ZdbqjA+6PsY9FAWsI5e55e+
         8z3w==
X-Gm-Message-State: AOAM532zkeHzeY0wuilyyyLlgS16O/2hhzcIZej5c5OsyfiL4/tFOlvF
        7w/wZ9rALcP2XDryyx8w4pN8xA==
X-Google-Smtp-Source: ABdhPJwg3isLRERtLxAZdh/c8bHNEmVn2Z7IPHdJ7xtPIk/R+K1Nswxk7u0mcFevqhXcV+zb5TFWRw==
X-Received: by 2002:a17:90b:11d8:: with SMTP id gv24mr746006pjb.232.1611076721817;
        Tue, 19 Jan 2021 09:18:41 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b185sm10020658pfa.112.2021.01.19.09.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 09:18:41 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix SQPOLL IORING_OP_CLOSE cancelation state
Message-ID: <e1617bdf-3b4f-f598-a0ad-13ad68bb1e42@kernel.dk>
Date:   Tue, 19 Jan 2021 10:18:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_CLOSE is special in terms of cancelation, since it has an
intermediate state where we've removed the file descriptor but hasn't
closed the file yet. For that reason, it's currently marked with
IO_WQ_WORK_NO_CANCEL to prevent cancelation. This ensures that the op
is always run even if canceled, to prevent leaving us with a live file
but an fd that is gone. However, with SQPOLL, since a cancel request
doesn't carry any resources on behalf of the request being canceled, if
we cancel before any of the close op has been run, we can end up with
io-wq not having the ->files assigned. This can result in the following
oops reported by Joseph:

BUG: kernel NULL pointer dereference, address: 00000000000000d8
PGD 800000010b76f067 P4D 800000010b76f067 PUD 10b462067 PMD 0
Oops: 0000 [#1] SMP PTI
CPU: 1 PID: 1788 Comm: io_uring-sq Not tainted 5.11.0-rc4 #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
RIP: 0010:__lock_acquire+0x19d/0x18c0
Code: 00 00 8b 1d fd 56 dd 08 85 db 0f 85 43 05 00 00 48 c7 c6 98 7b 95 82 48 c7 c7 57 96 93 82 e8 9a bc f5 ff 0f 0b e9 2b 05 00 00 <48> 81 3f c0 ca 67 8a b8 00 00 00 00 41 0f 45 c0 89 04 24 e9 81 fe
RSP: 0018:ffffc90001933828 EFLAGS: 00010002
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000d8
RBP: 0000000000000246 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888106e8a140 R15: 00000000000000d8
FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000d8 CR3: 0000000106efa004 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_acquire+0x31a/0x440
 ? close_fd_get_file+0x39/0x160
 ? __lock_acquire+0x647/0x18c0
 _raw_spin_lock+0x2c/0x40
 ? close_fd_get_file+0x39/0x160
 close_fd_get_file+0x39/0x160
 io_issue_sqe+0x1334/0x14e0
 ? lock_acquire+0x31a/0x440
 ? __io_free_req+0xcf/0x2e0
 ? __io_free_req+0x175/0x2e0
 ? find_held_lock+0x28/0xb0
 ? io_wq_submit_work+0x7f/0x240
 io_wq_submit_work+0x7f/0x240
 io_wq_cancel_cb+0x161/0x580
 ? io_wqe_wake_worker+0x114/0x360
 ? io_uring_get_socket+0x40/0x40
 io_async_find_and_cancel+0x3b/0x140
 io_issue_sqe+0xbe1/0x14e0
 ? __lock_acquire+0x647/0x18c0
 ? __io_queue_sqe+0x10b/0x5f0
 __io_queue_sqe+0x10b/0x5f0
 ? io_req_prep+0xdb/0x1150
 ? mark_held_locks+0x6d/0xb0
 ? mark_held_locks+0x6d/0xb0
 ? io_queue_sqe+0x235/0x4b0
 io_queue_sqe+0x235/0x4b0
 io_submit_sqes+0xd7e/0x12a0
 ? _raw_spin_unlock_irq+0x24/0x30
 ? io_sq_thread+0x3ae/0x940
 io_sq_thread+0x207/0x940
 ? do_wait_intr_irq+0xc0/0xc0
 ? __ia32_sys_io_uring_enter+0x650/0x650
 kthread+0x134/0x180
 ? kthread_create_worker_on_cpu+0x90/0x90
 ret_from_fork+0x1f/0x30

Fix this by moving the IO_WQ_WORK_NO_CANCEL until _after_ we've modified
the fdtable. Canceling before this point is totally fine, and running
it in the io-wq context _after_ that point is also fine.

For 5.12, we'll handle this internally and get rid of the no-cancel
flag, as IORING_OP_CLOSE is the only user of it.

Fixes: 14587a46646d ("io_uring: enable file table usage for SQPOLL rings")
Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Joseph, can you test this patch and see if this fixes it for you?

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b76bb50f18c7..5f6f1e48954e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4472,7 +4472,6 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 * io_wq_work.flags, so initialize io_wq_work firstly.
 	 */
 	io_req_init_async(req);
-	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4505,6 +4504,8 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
 
 	/* if the file has a flush method, be safe and punt to async */
 	if (close->put_file->f_op->flush && force_nonblock) {
+		/* not safe to cancel at this point */
+		req->work.flags |= IO_WQ_WORK_NO_CANCEL;
 		/* was never set, but play safe */
 		req->flags &= ~REQ_F_NOWAIT;
 		/* avoid grabbing files - we don't need the files */

-- 
Jens Axboe

