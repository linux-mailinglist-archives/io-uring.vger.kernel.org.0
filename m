Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84957B23DF
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 19:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjI1RZ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 13:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjI1RZv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 13:25:51 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BA81A3
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9a1bcc540c0so349166266b.1
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 10:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695921935; x=1696526735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9pNfSmgoO/6zgbmdJj7yqQWCPYQ2n2ZMjs03U8i3Ac=;
        b=aulyJR9J4odx8b7LMUrcvNdAGld9cmuhhxUeWa0NdaYxwaFNQPHoj0Uv8HMnPVei1l
         z6rMfGE2on9yomZTtnf54AormX4tLIaJg4BEUHgDhMwmxzb1aVZkiIpryXJ1p7u3GpI+
         rh7EZ27rVZYnXhrBAeyh6oX1lvZAaWFNNV3bliSPz3d/G3iqaJfdbPk+nR2RralZgAmF
         KakWzMz1Nd8XEQHkKkPvTMRPkxuGY4rwQ2zn+sgcy7lIsKv2ek/HU1pTIFOSwtvj87zF
         f8jkMTOdKwKLkI28ghYlgsCly3af4wvxTPWHnoOvLjvPpcAKY8W+17loCejNbA1QnVTs
         MB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695921935; x=1696526735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9pNfSmgoO/6zgbmdJj7yqQWCPYQ2n2ZMjs03U8i3Ac=;
        b=QrU0TgotrrJGqCv5t2CM8+fbVdgsu6YgZbRgazzqDPeuHatQy12jKJIinjSZTv24I0
         R9/aY6jJL9wVFIQ49BNuectsfav7Gyoewn8VBpJxnGy9aegDMWF0vpqtake5itU9XawV
         dQr74quh7cOPeS3p9Ipo6BSeQF+s7/syeAW2Nq75ZrucLDDAdF8j+Qn9FioVxffKlDhu
         LaHQDwl5C2z/oms8iiz6+sv8WzqT+2F8XocCXO/JoPYT4IWmdu4Lyn4LrhBn+Plctw/N
         eicBnX0HC5ef35TTmi/36QmDuFMYaFEKEUfXEvUbhNL2N7R0GdPq1XYRTXem+gIs6eSc
         YkGg==
X-Gm-Message-State: AOJu0YyL1cZepSy7wP6R0NKs2xhx7h2/EsJQaLL61rWzLm9uw8xdIuE0
        rB8vmP+hJYrUqrul6psYRSuTKoML/SLb91Hhp1MFdLxI
X-Google-Smtp-Source: AGHT+IFUP9vS47vrviSl7sjXnjGqkAKP4WwY5YGZoh2TzhNdlBsa6XwNha4d5tI2s/BT6T1TLuu5qQ==
X-Received: by 2002:a17:906:9f05:b0:9b2:b532:d8d7 with SMTP id fy5-20020a1709069f0500b009b2b532d8d7mr1833220ejc.5.1695921934818;
        Thu, 28 Sep 2023 10:25:34 -0700 (PDT)
Received: from localhost.localdomain ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id j17-20020a170906279100b0099329b3ab67sm11151788ejc.71.2023.09.28.10.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 10:25:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring: add support for vectored futex waits
Date:   Thu, 28 Sep 2023 11:25:17 -0600
Message-Id: <20230928172517.961093-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230928172517.961093-1-axboe@kernel.dk>
References: <20230928172517.961093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Use like IORING_OP_FUTEX_WAIT, except sqe->addr must now contain a
pointer to a struct futex_waitv array, and sqe->off must now contain the
number of elements in that array. As flags are passed in the futex_vector
array, and likewise for the value and futex address(es), sqe->addr2
and sqe->addr3 are also reserved for IORING_OP_FUTEX_WAITV.

For cancelations, FUTEX_WAITV does not rely on the futex_unqueue()
return value as we're dealing with multiple futexes. Instead, a separate
per io_uring request atomic is used to claim ownership of the request.

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
 io_uring/futex.c              | 169 ++++++++++++++++++++++++++++++++--
 io_uring/futex.h              |   2 +
 io_uring/opdef.c              |  11 +++
 4 files changed, 174 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 04f9fba38d4b..92be89a871fc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -246,6 +246,7 @@ enum io_uring_op {
 	IORING_OP_WAITID,
 	IORING_OP_FUTEX_WAIT,
 	IORING_OP_FUTEX_WAKE,
+	IORING_OP_FUTEX_WAITV,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/futex.c b/io_uring/futex.c
index eb4406ac46fb..3c3575303c3d 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -14,10 +14,16 @@
 
 struct io_futex {
 	struct file	*file;
-	u32 __user	*uaddr;
+	union {
+		u32 __user			*uaddr;
+		struct futex_waitv __user	*uwaitv;
+	};
 	unsigned long	futex_val;
 	unsigned long	futex_mask;
+	unsigned long	futexv_owned;
 	u32		futex_flags;
+	unsigned int	futex_nr;
+	bool		futexv_unqueued;
 };
 
 struct io_futex_data {
@@ -44,6 +50,13 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
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
@@ -52,22 +65,56 @@ static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
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
 
-	/* futex wake already done or in progress */
-	if (!futex_unqueue(&ifd->q))
+	io_tw_lock(req->ctx, ts);
+
+	if (!iof->futexv_unqueued) {
+		int res;
+
+		res = futex_unqueue_multiple(futexv, iof->futex_nr);
+		if (res != -1)
+			io_req_set_res(req, res, 0);
+	}
+
+	kfree(req->async_data);
+	req->flags &= ~REQ_F_ASYNC_DATA;
+	__io_futex_complete(req, ts);
+}
+
+static bool io_futexv_claim(struct io_futex *iof)
+{
+	if (test_bit(0, &iof->futexv_owned) ||
+	    test_and_set_bit_lock(0, &iof->futexv_owned))
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
@@ -147,6 +194,55 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
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
+	/* No flags or mask supported for waitv */
+	if (unlikely(sqe->fd || sqe->buf_index || sqe->file_index ||
+		     sqe->addr2 || sqe->futex_flags || sqe->addr3))
+		return -EINVAL;
+
+	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iof->futex_nr = READ_ONCE(sqe->len);
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
+	iof->futexv_owned = 0;
+	iof->futexv_unqueued = 0;
+	req->flags |= REQ_F_ASYNC_DATA;
+	req->async_data = futexv;
+	return 0;
+}
+
 static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 {
 	struct io_futex_data *ifd = container_of(q, struct io_futex_data, q);
@@ -171,6 +267,61 @@ static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
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
+	 * Error case, ret is < 0. Mark the request as failed.
+	 */
+	if (unlikely(ret < 0)) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		req_set_fail(req);
+		io_req_set_res(req, ret, 0);
+		kfree(futexv);
+		req->async_data = NULL;
+		req->flags &= ~REQ_F_ASYNC_DATA;
+		return IOU_OK;
+	}
+
+	/*
+	 * 0 return means that we successfully setup the waiters, and that
+	 * nobody triggered a wakeup while we were doing so. If the wakeup
+	 * happened post setup, the task_work will be run post this issue and
+	 * under the submission lock. 1 means We got woken while setting up,
+	 * let that side do the completion. Note that
+	 * futex_wait_multiple_setup() will have unqueued all the futexes in
+	 * this case. Mark us as having done that already, since this is
+	 * different from normal wakeup.
+	 */
+	if (!ret) {
+		/*
+		 * If futex_wait_multiple_setup() returns 0 for a
+		 * successful setup, then the task state will not be
+		 * runnable. This is fine for the sync syscall, as
+		 * it'll be blocking unless we already got one of the
+		 * futexes woken, but it obviously won't work for an
+		 * async invocation. Mark us runnable again.
+		 */
+		__set_current_state(TASK_RUNNING);
+		hlist_add_head(&req->hash_node, &ctx->futex_list);
+	} else {
+		iof->futexv_unqueued = 1;
+		if (woken != -1)
+			io_req_set_res(req, woken, 0);
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return IOU_ISSUE_SKIP_COMPLETE;
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
index 31a3a421e94d..25a3515a177c 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -459,6 +459,14 @@ const struct io_issue_def io_issue_defs[] = {
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
@@ -693,6 +701,9 @@ const struct io_cold_def io_cold_defs[] = {
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

