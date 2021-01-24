Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937E7301D11
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 16:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbhAXPNc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 10:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbhAXPMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 10:12:45 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A83C061788
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 07:12:02 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d16so9072419wro.11
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 07:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LUZGzMby/Q/fjxeL/dBz3jRWref9jlrEEprnAc/1QgA=;
        b=rWc7kiNZrqdsg+OENMYMUTx4TadJv7CJXSWWxaUWANxGqFnPsDMu4+NVLDyKqSudU5
         JSrGqgSNM8NmN26jFjoTWtkRjKkTOIzkzfhgguRQ0H9/CAIHy8nTWlCgBEOOZnc/4MZ0
         r5Nl+ioo9vgtoLPO0OTclNKfACasExaLpsrxIdo75TyiaO+l6N5SYGZ+hoNlr30IhOC8
         xjFw/Rz/lfOFv481FtjvNfrpWi3AK18Xbz6BKdBcteoFgyaaZmf1LhTua9huR2pvLcrv
         UtuK/wArU4lIcbFYrw+HBGkfMHmzq+HLSTsmBMIrajxYyy+UgN1f2OgFnlSBq7WLOP+2
         ajhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LUZGzMby/Q/fjxeL/dBz3jRWref9jlrEEprnAc/1QgA=;
        b=MRbkDySSznro6UKruDr+4AhQ6PFUA2pSo1xdxDQ41Y505UwVcKh5IQ24PPLoFXq9ng
         OqTsV2eoWdXizOILmrlIVjz2Vl2Kz7lC14UcdyZOBVgd7IT63HFdSxXhdpGinU+k4KfU
         +avc+CgrXlCd2qilT8N1NzSd6AkLffsNQzOgncjnWLeO36Ph/I1S5eQsrvEG71+1431m
         MTCzfSDySfFvA2NxBSyoL4rdsl+Dm9SO4zB/a8nSUI+fFQ/X25yGVbC1VqLQDsRFP6tB
         9Qnsr96wgPKNfIet3Ra+8QWJViL7Wo0EFVe7L6/66gMS/xtVY7gFJU7bUJlZdwlrHgom
         +oeA==
X-Gm-Message-State: AOAM531qgWd+bVN8R5mTcNQ6Zzd0S9pnNDdV2Y29IFjRyFwAHGGgbcx9
        p2ReE56jgI154Vxb+caABHLXa8U8fQWngg==
X-Google-Smtp-Source: ABdhPJx1ayUFF0HUSMQsli/pnCjGUuotKP9euDvgrQmE8gad/9BwAKmkcZ+ccqP6WxvU1t41drz0Yg==
X-Received: by 2002:adf:f512:: with SMTP id q18mr545245wro.55.1611501121310;
        Sun, 24 Jan 2021 07:12:01 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id b11sm13878366wrp.60.2021.01.24.07.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 07:12:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Abaci <abaci@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 1/1] io_uring: fix sleeping under spin in __io_clean_op
Date:   Sun, 24 Jan 2021 15:08:14 +0000
Message-Id: <fe4392d827ae90d82ba5b15d2ada86d60ce15f48.1611500328.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[   27.629441] BUG: sleeping function called from invalid context
	at fs/file.c:402
[   27.631317] in_atomic(): 1, irqs_disabled(): 1, non_block: 0,
	pid: 1012, name: io_wqe_worker-0
[   27.633220] 1 lock held by io_wqe_worker-0/1012:
[   27.634286]  #0: ffff888105e26c98 (&ctx->completion_lock)
	{....}-{2:2}, at: __io_req_complete.part.102+0x30/0x70
[   27.649249] Call Trace:
[   27.649874]  dump_stack+0xac/0xe3
[   27.650666]  ___might_sleep+0x284/0x2c0
[   27.651566]  put_files_struct+0xb8/0x120
[   27.652481]  __io_clean_op+0x10c/0x2a0
[   27.653362]  __io_cqring_fill_event+0x2c1/0x350
[   27.654399]  __io_req_complete.part.102+0x41/0x70
[   27.655464]  io_openat2+0x151/0x300
[   27.656297]  io_issue_sqe+0x6c/0x14e0
[   27.660991]  io_wq_submit_work+0x7f/0x240
[   27.662890]  io_worker_handle_work+0x501/0x8a0
[   27.664836]  io_wqe_worker+0x158/0x520
[   27.667726]  kthread+0x134/0x180
[   27.669641]  ret_from_fork+0x1f/0x30

Instead of cleaning files on overflow, return back overflow cancellation
into io_uring_cancel_files(). Previously it was racy to clean
REQ_F_OVERFLOW flag, but we got rid of it, and can do it through
repetitive attempts targeting all matching requests.

Reported-by: Abaci <abaci@linux.alibaba.com>
Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Jens, apart from reported it fixes a bug in 2 last patches of 5.11, when
it cleans REQ_F_INFLIGHT even though it still references io_uring file.
Better to take this patch before them.



diff --git a/fs/io_uring.c b/fs/io_uring.c
index 862113a9364f..8a98afed50cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1025,6 +1025,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
+static void io_req_drop_files(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -1048,8 +1049,7 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static inline void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
-			  REQ_F_INFLIGHT))
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
 		__io_clean_op(req);
 }
 
@@ -1394,6 +1394,8 @@ static void io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
+	if (req->flags & REQ_F_INFLIGHT)
+		io_req_drop_files(req);
 
 	io_put_identity(req->task->io_uring, req);
 }
@@ -6230,9 +6232,6 @@ static void __io_clean_op(struct io_kiocb *req)
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
-
-	if (req->flags & REQ_F_INFLIGHT)
-		io_req_drop_files(req);
 }
 
 static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
@@ -8879,6 +8878,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
 		io_poll_remove_all(ctx, task, files);
 		io_kill_timeouts(ctx, task, files);
+		io_cqring_overflow_flush(ctx, true, task, files);
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
 		schedule();
-- 
2.24.0

