Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D67F74FC5E
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 02:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjGLArh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 20:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjGLArY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 20:47:24 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B4C1726
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:22 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b898cfa6a1so9141325ad.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 17:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689122841; x=1689727641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybabf6Mx4VMuhxCixGmKPdJebzTyct2xBcgC4A4QTHE=;
        b=jplCC0xsZilG74DILpEjVEcJAUe8+fabKs3V5dzMOA/MRxevrMTrfCsq5J8kwB4it9
         yaq6LQmO55fkvLM9PkUBtS8Vd+9hPjkLC/z+ctQwPYiD+IXWSn5VSM6ZOMB8w+S82lnN
         zJsNx2XDTbzxqfwZnAlQtzeb3c+aQ+7CPf4uEAoAY/3TnZ7CHx30kYV0pdFx8ugI2WpN
         +7zLN+EyS2SmVPA0PobdaLBphljLcWlQHCbTxGF33YU1BSOIkP1puvtC13xCFHSQ/FY5
         pkAZ3E12S/zah08ptHaKyTMOQW92q0+qKaFslkh39kRHH1BXj2m+B66uV9mLDQa3gkro
         VN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689122841; x=1689727641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybabf6Mx4VMuhxCixGmKPdJebzTyct2xBcgC4A4QTHE=;
        b=LmHeCSPg6ON9nXxJzgrsdOLc+IwupaR64oIQ4emsHvs4RlZIGIqYgJnCVdABu/FN5y
         3tM90mzbp5eiJbtykeNBUbvSzoNyrpZ78Ep4e6alPwzTGnK05H2qQGGIzL4wakT4fV8K
         YBf6frQEZB/ITI65ZlvOID3Nvru+q1SA/MA2UZ9FPvv+GKrvtLA2BB1DiFbJivGe4hte
         KnxumDH27UZFz+3yo0kpNoCl2fEVryTOzhiNUB1gidlm8pbakDJDVkzeRRrUgBlm+l1o
         KdQwB9JLe1xuPThNzk1EQiT/t7st7ZoucfHLsMKLetCpGFHLRoAfIe/RykY1zAv4seFn
         veAw==
X-Gm-Message-State: ABy/qLaRKO46zRncRBDmwZ7CsRMWm1EG2rIgSRxm6jAYIJOeL/CZgA5Y
        dCyXNbN+OINBtJNAIRbugsU6aF6bi8YuDKgmxvI=
X-Google-Smtp-Source: APBJJlHEg/AwTm78Dq6O8WVJlRDk8pyUyhJoGvYjko3I2P2q+wSFXyqKnOsqjZ0AQ/vpoX0AWye6Uw==
X-Received: by 2002:a17:902:da92:b0:1b3:d8ac:8db3 with SMTP id j18-20020a170902da9200b001b3d8ac8db3mr21326390plx.6.1689122840987;
        Tue, 11 Jul 2023 17:47:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902b18800b001b694140d96sm2543542plr.170.2023.07.11.17.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 17:47:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring: add futex waitv
Date:   Tue, 11 Jul 2023 18:47:05 -0600
Message-Id: <20230712004705.316157-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712004705.316157-1-axboe@kernel.dk>
References: <20230712004705.316157-1-axboe@kernel.dk>
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

Needs a bit of splitting and a few hunks should go further back (like
the wake handler typedef).

WIP, adds IORING_OP_FUTEX_WAITV - pass in an array of futex addresses,
and wait on all of them until one of them triggers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |   1 +
 io_uring/futex.c              | 165 +++++++++++++++++++++++++++++++---
 io_uring/futex.h              |   2 +
 io_uring/opdef.c              |  11 +++
 4 files changed, 169 insertions(+), 10 deletions(-)

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
index ff0f6b394756..b22120545d31 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -14,11 +14,16 @@
 
 struct io_futex {
 	struct file	*file;
-	u32 __user	*uaddr;
+	union {
+		u32 __user			*uaddr;
+		struct futex_waitv __user	*uwaitv;
+	};
 	int		futex_op;
 	unsigned int	futex_val;
 	unsigned int	futex_flags;
 	unsigned int	futex_mask;
+	unsigned int	futex_nr;
+	unsigned long	futexv_owned;
 };
 
 struct io_futex_data {
@@ -45,6 +50,13 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
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
@@ -53,22 +65,59 @@ static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
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
@@ -124,7 +173,7 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 
-	if (unlikely(sqe->addr2 || sqe->buf_index || sqe->addr3))
+	if (unlikely(sqe->buf_index || sqe->addr3))
 		return -EINVAL;
 
 	iof->futex_op = READ_ONCE(sqe->fd);
@@ -135,6 +184,53 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
+
+	__futex_unqueue(q);
+	smp_store_release(&q->lock_ptr, NULL);
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
 
@@ -162,6 +258,55 @@ static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
 	return kmalloc(sizeof(struct io_futex_data), GFP_NOWAIT);
 }
 
+int io_futex_waitv(struct io_kiocb *req, unsigned int issue_flags)
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
index ddc9e0d73c52..7828e27e4184 100644
--- a/io_uring/futex.h
+++ b/io_uring/futex.h
@@ -3,7 +3,9 @@
 #include "cancel.h"
 
 int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags);
+int io_futex_waitv(struct io_kiocb *req, unsigned int issue_flags);
 int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags);
 
 #if defined(CONFIG_FUTEX)
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c9f23c21a031..2034acfe10d0 100644
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
+		.issue			= io_futex_waitv,
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

