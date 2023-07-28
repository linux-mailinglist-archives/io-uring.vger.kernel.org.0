Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28369767231
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbjG1Qnj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbjG1Qm7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:59 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1124F4231
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:51 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so33280639f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562570; x=1691167370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drbhhN+DgCzYIDWIkMO3R/dcC4lBZr1F8QCpgicu1Fc=;
        b=KFM1fbdwvRrsljCjrkepuuqyPrAaKzObZiavJxeWD4pfvPJLr3n0YLL31QNQ3DBMve
         Du1HIhROVhrBmIabwyFRABSuGjA7AQJgCROXuZ/G7IrlyrXuuxtAymS1LRwBiqZbDQtJ
         di/x2uY+xdGTL+JaoyETBIHeRG4rAL3Hf03nHsjbDvESUBgopLYmY2upYfbAJu/vN0is
         jFPIf+ySmbAKPSazj14/5lJE3KmZt6EAc4Sr1kikqjwBCxTdohs3ndVUQxnNmjzxb+AC
         WykeQHIVt4o4J0Vr02vhs4xeuTfZLVAca9zufF3LtJuLpZoZzrFDd3ao8MVCbd8yHNIi
         S4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562570; x=1691167370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=drbhhN+DgCzYIDWIkMO3R/dcC4lBZr1F8QCpgicu1Fc=;
        b=V8W8SRBAfmYJsBKdtuL3yHOn/mT6LVpwwbE+hdadR/1zgE0YX0FXkb3X+GnL4ychWr
         3mhcJCk6ZDzd91+lvBCa3januEO5QqAViAVNl/8ToCpEucY8XqvgT9rOazZ86W81sWzn
         Xz8iSe5a+xDDVILK9SCDCEUlEm1PyrYYjDOFpSdqgVvectrGvMnQckdWfl/Dr3Zb9nYo
         dia4Etl2+FaD4/9yyEkfa4dBgJYC3JaQy/zjG6KBsQZDqVLPvH3+9ZdfzZ+2pPrOssg+
         16ZslbaQj8yA45km+0cSfXQq8v7kfbwrziVxCqcWSJ4HRrhL95sm4+QEO08r0xr61GDM
         4PPA==
X-Gm-Message-State: ABy/qLa9BJYzSjqSATBtgdfgBwwKtGJPwhs3ZCZei9fU0noAOX48h2cv
        EphoCGQi1J8Wbae/eOHxv6MEa4WkD4wVe+/s1+0=
X-Google-Smtp-Source: APBJJlEG/KFr3aeK7vdfC86yyv7/KC3aRIRUCWSydQliroQhOQy7gxMw26reO4i12hyztyYdjGCm/A==
X-Received: by 2002:a92:dc51:0:b0:346:1919:7cb1 with SMTP id x17-20020a92dc51000000b0034619197cb1mr43797ilq.2.1690562570053;
        Fri, 28 Jul 2023 09:42:50 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/12] io_uring: add support for vectored futex waits
Date:   Fri, 28 Jul 2023 10:42:35 -0600
Message-Id: <20230728164235.1318118-13-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728164235.1318118-1-axboe@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
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
 io_uring/futex.c              | 164 ++++++++++++++++++++++++++++++++--
 io_uring/futex.h              |   2 +
 io_uring/opdef.c              |  11 +++
 4 files changed, 169 insertions(+), 9 deletions(-)

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
index f58ab33bfb32..c7936a34319a 100644
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

