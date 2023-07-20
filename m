Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A433575BA78
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjGTWTs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjGTWTb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:31 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21022D77
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:21 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-682ae5d4184so279569b3a.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891560; x=1690496360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yngZZlfPVZGDNxCRXmaNtB0CBksElpTKnpJJx+/jGI=;
        b=1pVJBoiRFHG8xw4oGGS0FUma0RTwwFPsW+3J10eFLNIawQoVQTVSSEzHX8aCcEbPlR
         +CM3+yuNP5H6EJAAu+k6ZXyqwugwwcUEFLDR1+NDZmbF6G5zDFcMdQcvD9j1ApXZ0Lwv
         7Dr+1qyHzF5Mb3Nl/1YvujlWhSVLxg61XQdhJkRiqwq5LHMM4QP+v5zuAV9K7TZzF0Om
         2kWvOK3I1Q3OIEQGeHPSn9s9btVHc98eoQQg3qPKgby3kRH5ayeK5INCqmQokQd72EUq
         gLOwSIZsECf1eFjNBHkULthVJp6yPPeKjMIrXfBVhVII1/cNhSrKwdQIMUG949mR5ZYd
         2NBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891560; x=1690496360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yngZZlfPVZGDNxCRXmaNtB0CBksElpTKnpJJx+/jGI=;
        b=TxlF4guUmG2ozydFwUVAa36ejm8YkJozG2cg4e+VyTsy+loCxawjVhvy/hBP2NN8gr
         qGq1dc0WcuIbBUjZwavEsgIIJGs/TFMW1/I9zWmv39QEKBtlUgySza4bIxQjUbN0MiD5
         rt5qaTluYhr78A9bUNJg7ru11s+vnK0F9hFFsUnUQDHdquTreyqV6M1X0rGARKHeEHbY
         B89Y7xlBFBMaqDokeoe6MgG38Ds+mRQr9DmeF/jRlcrq71jJ5Xj6EHiZp7HBb2GJS0q4
         SUIXr8VuQmtKobgscHEV4JgDkzqTuLs7BKZi+asfWE9q1Z+wPLm7gJbIF3gwL9WBVPCc
         UT/A==
X-Gm-Message-State: ABy/qLYuPnEfoxCzcj4+YBgVBikRlUx2KVH43daVxKX7+OEH8ulckSxo
        hOsFEDQPnejms4y9emk7JQf7d1BvdHV1TtlNjmk=
X-Google-Smtp-Source: APBJJlEzXaPy9iif5Y8vR0VqAaZX1wrTRUTylfeqfzDDmAes/b5PaOYdrRps8JAs/qEb0uZORoHtyg==
X-Received: by 2002:a05:6a20:4295:b0:137:8f19:1de7 with SMTP id o21-20020a056a20429500b001378f191de7mr361793pzj.0.1689891560549;
        Thu, 20 Jul 2023 15:19:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/10] io_uring: add support for vectored futex waits
Date:   Thu, 20 Jul 2023 16:18:58 -0600
Message-Id: <20230720221858.135240-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720221858.135240-1-axboe@kernel.dk>
References: <20230720221858.135240-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for IORING_OP_FUTEX_WAITV, which allows registering a
notification for a number of futexes at once. If one of the futexes are
woken, then the request will complete with the index of the futex that got
woken as the result. This is identical to what the normal vectored futex
waitv operation does.

Use like IORING_OP_FUTEX_WAIT, except sqe->addr must now contain the a
pointer to a struct futex_waitv array, and sqe->off must now contain the
number of elements in that array.

Waiting on N futexes could be done with IORING_OP_FUTEX_WAIT as well,
but that punts a lot of the work to the application:

1) Application would need to submit N IORING_OP_FUTEX_WAIT requests,
   rather than just a single IORING_OP_FUTEX_WAITV.

2) When one futex is woken, application would need to cancel the
   remaining N-1 requests that didn't trigger.

While this is of course doable, having a single vectored futex wait
makes for much simpler application code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/futex.c              | 164 +++++++++++++++++++++++++++++++---
 io_uring/futex.h              |   2 +
 io_uring/opdef.c              |  11 +++
 4 files changed, 168 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3bd2d765f593..420f38675769 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -238,6 +238,7 @@ enum io_uring_op {
 	IORING_OP_SENDMSG_ZC,
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
+	IORING_OP_FUTEX_WAITV,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 0114fda797e1..93df54dffaa0 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -14,10 +14,15 @@
 
 struct io_futex {
 	struct file	*file;
-	u32 __user	*uaddr;
+	union {
+		u32 __user			*uaddr;
+		struct futex_waitv __user	*uwaitv;
+	};
 	unsigned int	futex_val;
 	unsigned int	futex_flags;
 	unsigned int	futex_mask;
+	unsigned int	futex_nr;
+	unsigned long	futexv_owned;
 };
 
 struct io_futex_data {
@@ -44,6 +49,13 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->futex_cache, io_futex_cache_entry_free);
 }
 
+static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
+{
+	req->async_data = NULL;
+	hlist_del_init(&req->hash_node);
+	io_req_task_complete(req, ts);
+}
+
 static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_futex_data *ifd = req->async_data;
@@ -52,22 +64,59 @@ static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	io_tw_lock(ctx, ts);
 	if (!io_alloc_cache_put(&ctx->futex_cache, &ifd->cache))
 		kfree(ifd);
-	req->async_data = NULL;
-	hlist_del_init(&req->hash_node);
-	io_req_task_complete(req, ts);
+	__io_futex_complete(req, ts);
 }
 
-static bool __io_futex_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static void io_futexv_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	struct io_futex_data *ifd = req->async_data;
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct futex_vector *futexv = req->async_data;
+	struct io_ring_ctx *ctx = req->ctx;
+	int res = 0;
 
-	/* futex wake already done or in progress */
-	if (!futex_unqueue(&ifd->q))
+	io_tw_lock(ctx, ts);
+
+	res = futex_unqueue_multiple(futexv, iof->futex_nr);
+	if (res != -1)
+		io_req_set_res(req, res, 0);
+
+	kfree(req->async_data);
+	req->flags &= ~REQ_F_ASYNC_DATA;
+	__io_futex_complete(req, ts);
+}
+
+static bool io_futexv_claimed(struct io_futex *iof)
+{
+	return test_bit(0, &iof->futexv_owned);
+}
+
+static bool io_futexv_claim(struct io_futex *iof)
+{
+	if (test_bit(0, &iof->futexv_owned) ||
+	    test_and_set_bit(0, &iof->futexv_owned))
 		return false;
+	return true;
+}
+
+static bool __io_futex_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	/* futex wake already done or in progress */
+	if (req->opcode == IORING_OP_FUTEX_WAIT) {
+		struct io_futex_data *ifd = req->async_data;
+
+		if (!futex_unqueue(&ifd->q))
+			return false;
+		req->io_task_work.func = io_futex_complete;
+	} else {
+		struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+
+		if (!io_futexv_claim(iof))
+			return false;
+		req->io_task_work.func = io_futexv_complete;
+	}
 
 	hlist_del_init(&req->hash_node);
 	io_req_set_res(req, -ECANCELED, 0);
-	req->io_task_work.func = io_futex_complete;
 	io_req_task_work_add(req);
 	return true;
 }
@@ -123,7 +172,7 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 
-	if (unlikely(sqe->fd || sqe->addr2 || sqe->buf_index || sqe->addr3))
+	if (unlikely(sqe->fd || sqe->buf_index || sqe->addr3))
 		return -EINVAL;
 
 	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -133,6 +182,52 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (iof->futex_flags & FUTEX_CMD_MASK)
 		return -EINVAL;
 
+	iof->futexv_owned = 0;
+	return 0;
+}
+
+static void io_futex_wakev_fn(struct wake_q_head *wake_q, struct futex_q *q)
+{
+	struct io_kiocb *req = q->wake_data;
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+
+	if (!io_futexv_claim(iof))
+		return;
+	if (unlikely(!__futex_wake_mark(q)))
+		return;
+
+	io_req_set_res(req, 0, 0);
+	req->io_task_work.func = io_futexv_complete;
+	io_req_task_work_add(req);
+}
+
+int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct futex_vector *futexv;
+	int ret;
+
+	ret = io_futex_prep(req, sqe);
+	if (ret)
+		return ret;
+
+	iof->futex_nr = READ_ONCE(sqe->off);
+	if (!iof->futex_nr || iof->futex_nr > FUTEX_WAITV_MAX)
+		return -EINVAL;
+
+	futexv = kcalloc(iof->futex_nr, sizeof(*futexv), GFP_KERNEL);
+	if (!futexv)
+		return -ENOMEM;
+
+	ret = futex_parse_waitv(futexv, iof->uwaitv, iof->futex_nr,
+				io_futex_wakev_fn, req);
+	if (ret) {
+		kfree(futexv);
+		return ret;
+	}
+
+	req->flags |= REQ_F_ASYNC_DATA;
+	req->async_data = futexv;
 	return 0;
 }
 
@@ -160,6 +255,55 @@ static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
 	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
 }
 
+int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct futex_vector *futexv = req->async_data;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret, woken = -1;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	ret = futex_wait_multiple_setup(futexv, iof->futex_nr, &woken);
+
+	/*
+	 * The above call leaves us potentially non-running. This is fine
+	 * for the sync syscall as it'll be blocking unless we already got
+	 * one of the futexes woken, but it obviously won't work for an async
+	 * invocation. Mark is runnable again.
+	 */
+	__set_current_state(TASK_RUNNING);
+
+	/*
+	 * We got woken while setting up, let that side do the completion
+	 */
+	if (io_futexv_claimed(iof)) {
+skip:
+		io_ring_submit_unlock(ctx, issue_flags);
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
+
+	/*
+	 * 0 return means that we successfully setup the waiters, and that
+	 * nobody triggered a wakeup while we were doing so. < 0 or 1 return
+	 * is either an error or we got a wakeup while setting up.
+	 */
+	if (!ret) {
+		hlist_add_head(&req->hash_node, &ctx->futex_list);
+		goto skip;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	else if (woken != -1)
+		ret = woken;
+	io_req_set_res(req, ret, 0);
+	kfree(futexv);
+	req->flags &= ~REQ_F_ASYNC_DATA;
+	return IOU_OK;
+}
+
 int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
diff --git a/io_uring/futex.h b/io_uring/futex.h
index ddc9e0d73c52..0847e9e8a127 100644
--- a/io_uring/futex.h
+++ b/io_uring/futex.h
@@ -3,7 +3,9 @@
 #include "cancel.h"
 
 int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags);
+int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags);
 int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags);
 
 #if defined(CONFIG_FUTEX)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c9f23c21a031..b9e1e12cac9c 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -443,6 +443,14 @@ const struct io_issue_def io_issue_defs[] = {
 		.issue			= io_futex_wake,
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_FUTEX_WAITV] = {
+#if defined(CONFIG_FUTEX)
+		.prep			= io_futexv_prep,
+		.issue			= io_futexv_wait,
+#else
+		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
@@ -670,6 +678,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_FUTEX_WAKE] = {
 		.name			= "FUTEX_WAKE",
 	},
+	[IORING_OP_FUTEX_WAITV] = {
+		.name			= "FUTEX_WAITV",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.40.1

