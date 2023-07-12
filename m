Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12B3750E4D
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjGLQWI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjGLQVh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:21:37 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7A42D66
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:38 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-780c89d1998so65378939f.1
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689178836; x=1689783636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHQnR1IfcUdXYrM7+d+V63clco2CkTNN3BLu3B8kYXA=;
        b=Lo1FTlqYe3dOi5Ag/fCqU9v9ddmgKWS1Or3KMqoHEpyuOtAkZV+2GKHxbUPFX9xx/H
         F3V+ngDDsSQ/dCCtZExDjtlMVGf9hz8MCF0v4AYZT8Rf1nbGjYABAykwfG336LCE08+k
         DTqNLmFsDfE6dZfcIeFdJzURSBNSZPu6zxLOe5i6pMJFCL8n+AaIvQEaYc+py73zxBbj
         /PKq2IQT4q7pblB/gjEAgBbUJa8Upq2T4YQyrl7C68fy8KfI4xBbBZ0YFgK1015aoC+d
         hQvl8Nbei4smum+bPdo4ap9vDDeWolayz0kX5HgJPnX6p9lL/Lor4s2VISkRgnnWHqI3
         4sYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689178836; x=1689783636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHQnR1IfcUdXYrM7+d+V63clco2CkTNN3BLu3B8kYXA=;
        b=cTyycMGHdVEdy7sM7iDxBtk5EmmQVqPMxmCAxaBVO3SuNaYM8VVFq+22Dw/IrVBttZ
         uCZOMODGYw12LsMXTcg8qPu+b+ngVH6axUxvNKTR4DeKPZeWbXUmdTTzfjrNju/NgwOT
         /rExcfMeKBPHuLFtGmvjKiZDe2WYbe5UrxLILfQnkNdavsRNZw4KIejugT6cbii3zDns
         O5k0048UL7h4UxIbRiH8xgBJHWDHMIMsISWRSgG1rFpRTxWWRKTsjwhL6IFBQDElnGQC
         Vruywl2YE4oAfP7kr4laTgSNCR5vBn5ufeh4at9fx32X/BamjwxMC0NDaxpgOLLgvDV/
         wQDw==
X-Gm-Message-State: ABy/qLbG2AIQTZbTZGkyspESV7JzUnMuT94Ln6LhqiR9ofYwZKUvhuBR
        898wKC/VLbQb3e7OibReRes2hOsP+aqATzy9BKg=
X-Google-Smtp-Source: APBJJlFGCof3cgeu4+tHnAxT1FiwYUER82IUCt2NZWeehvAn+WHJxGFpUUPFbD6cnUzkvyOD35Jx3w==
X-Received: by 2002:a05:6602:1a96:b0:780:d6ef:160 with SMTP id bn22-20020a0566021a9600b00780d6ef0160mr21303750iob.1.1689178835760;
        Wed, 12 Jul 2023 09:20:35 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x24-20020a029718000000b0042aec33bc26sm1328775jai.18.2023.07.12.09.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:20:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring: add support for vectored futex waits
Date:   Wed, 12 Jul 2023 10:20:17 -0600
Message-Id: <20230712162017.391843-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230712162017.391843-1-axboe@kernel.dk>
References: <20230712162017.391843-1-axboe@kernel.dk>
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
index fa92ee795c83..df65b8f3593f 100644
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
@@ -135,6 +184,52 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -162,6 +257,55 @@ static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
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

