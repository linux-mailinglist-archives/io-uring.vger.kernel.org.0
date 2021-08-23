Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526613F4AAF
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 14:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhHWMcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 08:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhHWMcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 08:32:05 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A2AC061575
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 05:31:22 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z9so25972547wrh.10
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 05:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9P1rCgDHTh4Snmzq/a5R0nG5KY4lDtFc0Bb1Vkmh10c=;
        b=p5zaoQ/Vf7Ao8Kge6M4MEzhK3C0R+we2XZuX3CltXZJ9NxepVKx3SDPDzsprjdEJ7u
         ydedE3gWGMcPC1o6yRRDIH7eMe4tN1Ka4gS6Cq51r7AndenM2EZWz34LhMXj71NV5Dk1
         7VlHvoyllQX0YfAb+nRwgh9EA13R95g0Xc/54BMh1f3d91tn5uwcAcJd2slzNB5twLdq
         iHyZvsuyUItnGrhauJEeg7XeY+O20MOg+AphGP91bUTRlLy5NdrWoTaXLkGEaYBy4715
         a7rWX2rd8VWAsZfjmXtC4XLQ5Bokiugf/I8S6RU2wwJBOMV08UG/Wfhvj5frR2Q1TGFl
         vmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9P1rCgDHTh4Snmzq/a5R0nG5KY4lDtFc0Bb1Vkmh10c=;
        b=Dm5rDIuEE9XYVvudi3ukOsmAo0F9J2yVKlv0d6sMYap9/COpRxTrxptqslnfbe1mfZ
         fw7xnvDvJqQTZmSFOP04idIij9dSRSU7mX5iowB3p7srFLSO6gSM2RgzqG7w+SXupIHn
         zXjpfPL4UJBdZpghzTYP6hXxoMXo0azI6HOHnD5eLLOaldqpfsrJQAh0lHBe3/2j+dOR
         PLJop4w9xiZ8mYw2cVrMs3wc+hSmQ10+2oni6QJ2W4NAFuHZQPlIlQLjSCKFdADX6wzb
         Hb3rt8XDuLbLWVfiH99UddHcmRSmuP9zoTwaGm4iKzHxAARhYkcKWdudOHzsgrLvreeb
         +z3g==
X-Gm-Message-State: AOAM532XPCsiHm0gOJisFQ0RGNFG9npzGkzsFRmZ0lqjJ4esU4hpeAzO
        j8RPk0gWfvQuaaUJa7zDtls=
X-Google-Smtp-Source: ABdhPJz7Tl/R94Q2asOm68i+KeRidjDGB9r/DtMXy7hx4b57LCdBeYUdj6GuJLZAuo5oB04OBzU0GQ==
X-Received: by 2002:a05:6000:1805:: with SMTP id m5mr13188957wrh.265.1629721881537;
        Mon, 23 Aug 2021 05:31:21 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id n13sm12942556wmc.18.2021.08.23.05.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 05:31:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com,
        syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: fix io_try_cancel_userdata race for iowq
Date:   Mon, 23 Aug 2021 13:30:44 +0100
Message-Id: <dfdd37a80cfa9ffd3e59538929c99cdd55d8699e.1629721757.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 1 PID: 5870 at fs/io_uring.c:5975 io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
CPU: 0 PID: 5870 Comm: iou-wrk-5860 Not tainted 5.14.0-rc6-next-20210820-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_try_cancel_userdata+0x30f/0x540 fs/io_uring.c:5975
Call Trace:
 io_async_cancel fs/io_uring.c:6014 [inline]
 io_issue_sqe+0x22d5/0x65a0 fs/io_uring.c:6407
 io_wq_submit_work+0x1dc/0x300 fs/io_uring.c:6511
 io_worker_handle_work+0xa45/0x1840 fs/io-wq.c:533
 io_wqe_worker+0x2cc/0xbb0 fs/io-wq.c:582
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

io_try_cancel_userdata() can be called from io_async_cancel() executing
in the io-wq context, so the warning fires, which is there to alert
anyone accessing task->io_uring->io_wq in a racy way. However,
io_wq_put_and_exit() always first waits for all threads to complete,
so the only detail left is to zero tctx->io_wq after the context is
removed.

note: one little assumption is that when IO_WQ_WORK_CANCEL, the executor
won't touch ->io_wq, because io_wq_destroy() might cancel left pending
requests in such a way.

Cc: stable@vger.kernel.org
Reported-by: syzbot+b0c9d1588ae92866515f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9534c72dc4b..027afe2f55d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5804,7 +5804,7 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	WARN_ON_ONCE(req->task != current);
+	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
 	if (ret != -ENOENT)
@@ -6309,6 +6309,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	if (timeout)
 		io_queue_linked_timeout(timeout);
 
+	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (work->flags & IO_WQ_WORK_CANCEL)
 		ret = -ECANCELED;
 
@@ -9124,8 +9125,8 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 		 * Must be after io_uring_del_task_file() (removes nodes under
 		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
 		 */
-		tctx->io_wq = NULL;
 		io_wq_put_and_exit(wq);
+		tctx->io_wq = NULL;
 	}
 }
 
-- 
2.32.0

