Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2302B7A9A3D
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 20:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjIUShq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 14:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjIUSh1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 14:37:27 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D10D868F
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:25 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-79f8df47bfbso10254439f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695320964; x=1695925764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T07+FrfCPjZBo72MwSk6fDllH6IdPm+PDxNrxWagj38=;
        b=XjA2LfKPRX+SU4/H3+AzQrupIHosj67NBFlTc+tdPDTcz80R3VLJdTkJbxnt7UBDUQ
         vUX1tgdxThvBw1zkH5+1zRqOkiW4z0wlx0ktvE6DHny6BykYkJAAhvWA+ubOtrpuL/8u
         cybB1u1BzyVqBz3TRKvMJmNixNnUZ9XEuariQQY00UzjikcFKxckzQjfqrD61y+fCmrl
         f4nRBls5SBjvucuEynYf1z4b2BR8c+FR071nsUQ+sDX752TYzPIPKeJGS4nxQtQZml7u
         E/54/7GOVAbRqLb74PFGj9B71Phh+fb9NMX+WJgyfCItr4EJTsHAGf4D+VxxHFzuTo9j
         vHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320964; x=1695925764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T07+FrfCPjZBo72MwSk6fDllH6IdPm+PDxNrxWagj38=;
        b=BIC5O9CK5NT9OzdkiVlh+pY82cBf+132As0/C1KKdcIWp+uku/e5oOLCjiaWWfYgpa
         WAcw2wsfDJqe40mgR3W2QTRW53shunuP2uqiN+oBwqw6DjPeSHmoEr1DNCfz73uCbDeB
         PvUU7LRpF3fK3smC8JaqbiNsKXE2aufkgUtas2AnxSBme5TTxIVWr72HovdJ/uGUZ9ib
         sc2EDpF2FtgAQWdH9Bb9Y7CVSOzIvefOTdblYYTbvskE6DuDWtmbZ/4lEDcsmBv/xhql
         JaqG/wWORhWcmys1sWnxCnJN5Mx1uMpQzk8iL65GHWlIa/2TR9LcvD0k8ZWQSj8T2jVz
         3Fdg==
X-Gm-Message-State: AOJu0YwgdLncItHS87JZfxL17uxF7w7TVXhdBPJfz1B9g+yJvEddTYWX
        UkdAJnG93UZdUCrA30SX1o8IZNuDYiyml+Egh/qM8g==
X-Google-Smtp-Source: AGHT+IHHeGJYB3BCeWiqyDSINsxeVgZhZetGoHC2AFY9MnSBSKh1BEBTLr68Bh1E8VMEO0o+TJc9UQ==
X-Received: by 2002:a05:6602:13c2:b0:79d:1c65:9bde with SMTP id o2-20020a05660213c200b0079d1c659bdemr8647351iov.1.1695320964457;
        Thu, 21 Sep 2023 11:29:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o25-20020a02c6b9000000b0042b227eb1ddsm500441jan.55.2023.09.21.11.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 11:29:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring: add support for vectored futex waits
Date:   Thu, 21 Sep 2023 12:29:08 -0600
Message-Id: <20230921182908.160080-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921182908.160080-1-axboe@kernel.dk>
References: <20230921182908.160080-1-axboe@kernel.dk>
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

Use like IORING_OP_FUTEX_WAIT, except sqe->addr must now contain the a
pointer to a struct futex_waitv array, and sqe->off must now contain the
number of elements in that array.

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
 io_uring/futex.c              | 164 ++++++++++++++++++++++++++++++++--
 io_uring/futex.h              |   2 +
 io_uring/opdef.c              |  11 +++
 4 files changed, 169 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4ddd7bdbbfb8..172472626f5b 100644
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
index 4278302d212c..0c07df8668aa 100644
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
 	unsigned long	futex_val;
 	unsigned long	futex_mask;
+	unsigned long	futexv_owned;
 	u32		futex_flags;
+	unsigned int	futex_nr;
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
@@ -146,6 +195,54 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
+		     sqe->addr2 || sqe->addr3))
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
+	req->flags |= REQ_F_ASYNC_DATA;
+	req->async_data = futexv;
+	return 0;
+}
+
 static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 {
 	struct io_futex_data *ifd = container_of(q, struct io_futex_data, q);
@@ -170,6 +267,55 @@ static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
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
+	 * invocation. Mark us runnable again.
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

