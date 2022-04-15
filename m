Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB286502B04
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 15:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354061AbiDONjt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 09:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354075AbiDONhw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 09:37:52 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC7A6BDD9
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:28 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q12so7275101pgj.13
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IpmlOEp98TNoFIiXCSBILNNQBxT4LVahr5P1H6DIKFw=;
        b=z+ylKNkpMOfoRtJZLUzfP3qbFrgwD5gn2qbpfThchkIocZNNosuwxXdXo/MPjHeW45
         VURnOjuflZnL6l9TRbRTGNNsYMCDiHAB3tSZ8Z05hJKra3RwHyYg7FjAfexqQDBqsNQf
         KVnj1O1DHB+nkRhII0TPn8pYB87fy+kyp47c4Ma4ZgvVfN/VFnh6D2yLyXtGGXib5xF1
         RPylWOMuZbJbtPrrJD95zlvEJrhUjOQNITUKG06xAHoWsG8LFfevkIf6mkDmgB0gsnTs
         fv5I8++jU52vXSKTFWUcus5gpe/epsMGHLW1TjlSVFdc9xXFARcQon4WETYtpB8WN32W
         Pwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IpmlOEp98TNoFIiXCSBILNNQBxT4LVahr5P1H6DIKFw=;
        b=o0XBbhwmzpTYeN4HEqFU9SRW/HFiXj7fnM7fnhgcd6j5wzf2vwhpIEFHpCE6faxeAo
         E5cqoByWJQbLHArpFs8XDs4hr/QRTeYMmV0JVVJokFcz835WFth0hbPp3ZVFrcaBYfoB
         bkPirzM1DDRi3cXRwF2CPdRBA9TagBYH1CSJ/8Ro6vlsBOnKY6gTqmKfLth29oc3zyfX
         m2S0vX7zI704pWHdhfWOaOxqnkLLqabLhgsxTkaRA6sqDTyPLT8V81Ba+0iUhVC84oam
         vQcSf2xneGMYM27bBhpSri3HMISd0xrizytjgyAKStU7KBu2/1SPycxgXGcno83L39/x
         6RhQ==
X-Gm-Message-State: AOAM530fuCdBChudG6GQLJPu81oOU2iZKxcO11rIWbJSOe+tu5lLzNnk
        w5Y8M28bpots+7Afa50onauYVxo2T0TlZQ==
X-Google-Smtp-Source: ABdhPJz8Iv/wt3dGE04ZMI7vCa1lx9iLzwzn8BwZDu6laHF42O1tCBo03S00DhVNtdUZDHr6liCTxQ==
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id z2-20020a056a00240200b004e13df25373mr8892955pfh.40.1650029607094;
        Fri, 15 Apr 2022 06:33:27 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n19-20020a635c53000000b0039dc2ea9876sm4576604pgm.49.2022.04.15.06.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:33:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: add support for IORING_ASYNC_CANCEL_ALL
Date:   Fri, 15 Apr 2022 07:33:18 -0600
Message-Id: <20220415133319.75077-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415133319.75077-1-axboe@kernel.dk>
References: <20220415133319.75077-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current cancelation will lookup and cancel the first request it
finds based on the key passed in. Add a flag that allows to cancel any
request that matches they key. It completes with either -ENOENT if none
were found, or res > 0 for the number of entries canceled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 60 +++++++++++++++++++++++++----------
 include/uapi/linux/io_uring.h |  7 ++++
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6dcf3ad7ee99..c7e5d60fbbe5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -568,6 +568,7 @@ struct io_sync {
 struct io_cancel {
 	struct file			*file;
 	u64				addr;
+	u32				flags;
 };
 
 struct io_timeout {
@@ -6319,6 +6320,7 @@ static bool io_poll_disarm(struct io_kiocb *req)
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
 	u64 data;
+	u32 flags;
 };
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
@@ -6774,7 +6776,8 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 	if (!tctx || !tctx->io_wq)
 		return -ENOENT;
 
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd, false);
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd,
+					cd->flags & IORING_ASYNC_CANCEL_ALL);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -6825,27 +6828,34 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
-	    sqe->splice_fd_in)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
+	req->cancel.flags = READ_ONCE(sqe->cancel_flags);
+	if (req->cancel.flags & ~IORING_ASYNC_CANCEL_ALL)
+		return -EINVAL;
+
 	return 0;
 }
 
-static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
+			     unsigned int issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_cancel_data cd = {
-		.ctx	= ctx,
-		.data	= req->cancel.addr,
-	};
+	bool cancel_all = cd->flags & IORING_ASYNC_CANCEL_ALL;
+	struct io_ring_ctx *ctx = cd->ctx;
 	struct io_tctx_node *node;
-	int ret;
+	int ret, nr = 0;
 
-	ret = io_try_cancel(req, &cd);
-	if (ret != -ENOENT)
-		goto done;
+	do {
+		ret = io_try_cancel(req, cd);
+		if (ret == -ENOENT)
+			break;
+		if (!cancel_all)
+			return ret;
+		nr++;
+		io_run_task_work();
+	} while (1);
 
 	/* slow path, try all io-wq's */
 	io_ring_submit_lock(ctx, issue_flags);
@@ -6853,12 +6863,28 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		ret = io_async_cancel_one(tctx, &cd);
-		if (ret != -ENOENT)
-			break;
+		ret = io_async_cancel_one(tctx, cd);
+		if (ret != -ENOENT) {
+			if (!cancel_all)
+				break;
+			nr++;
+			io_run_task_work();
+		}
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
-done:
+	return cancel_all ? nr : ret;
+}
+
+static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_cancel_data cd = {
+		.ctx	= req->ctx,
+		.data	= req->cancel.addr,
+		.flags	= req->cancel.flags,
+	};
+	int ret;
+
+	ret = __io_async_cancel(&cd, req, issue_flags);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_complete_post(req, ret, 0);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1845cf7c80ba..476e58a2837f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -187,6 +187,13 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
+/*
+ * ASYNC_CANCEL flags.
+ *
+ * IORING_ASYNC_CANCEL_ALL	Cancel all requests that match the given key
+ */
+#define IORING_ASYNC_CANCEL_ALL	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.35.1

