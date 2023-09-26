Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F877AEF94
	for <lists+io-uring@lfdr.de>; Tue, 26 Sep 2023 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjIZPZ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Sep 2023 11:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbjIZPZZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Sep 2023 11:25:25 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9E6124
        for <io-uring@vger.kernel.org>; Tue, 26 Sep 2023 08:25:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3200b181b67so1203016f8f.0
        for <io-uring@vger.kernel.org>; Tue, 26 Sep 2023 08:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695741915; x=1696346715; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b0dRZrj80jIaBrBM7n1DAcbNjoRF9Qwd0BL2ki9dCF8=;
        b=TqHbl24ksaWpPE586DwCyFwgxeoZTX7AY9la4cI7Emx1XTv3sy5tfIQpjUc4QmTK5j
         rN5VDWzBlcpfdiEoVR3vqWmFBMLa67yNZ3dYYaNR6GyqppE+8+wRk/tAFM2V3iQaUWBl
         lO9agAB/wmhxENtTftNNc7ta9zI8fLZK8AAhuSDvzMIceun5GsPUfzCVujkEGUdCwX1+
         0hKNg4Vizmjzp3zIZ4LjpJG9Dd+pkHqGCK5OO7mp2nVVosD4xFbOnfIlFqjy+LgJtvgN
         RmYg0YqyBTYd4D3x807YTydBGpvgRCB/nZX3SQIcAINHTZw4r2FL5yGmJn1C8Jwxbzsl
         B6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695741915; x=1696346715;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b0dRZrj80jIaBrBM7n1DAcbNjoRF9Qwd0BL2ki9dCF8=;
        b=h+XyOIBsSHLYTs3C5881es14Nb5FbKBlsCaYcPaiA1yQrqwAuGRbcpAST+VnJMMHno
         1XEvxe+Q3MGf9M3e8tpO8NiVz6oTKTnG/pLdgkGYC4cJeKfo+4+LEdPUQsut5yZZ2BRJ
         gXVKS/RQN9BqaE06vTDEDujC7oXlWvbs6rjgJfqzfv3FXGuGlfisWBqWZfvQzB+TvVA6
         PCuuFTJFx6GVUFz/KqQ4YsW4nPQb1RSjG90KWk3ocXjeEyyyMuG4zuwYSjhDdigZoDeO
         f4SL7glEwcJ21vMvIFBA/9HYy2QWvTbe8bo1LX0EMu/+N3DGlUh+m3PgwSLBQkAEhZ0z
         Q6nw==
X-Gm-Message-State: AOJu0YwofTIcsrCs6qfliyx8QSMvPyvjFhUhTPNnaGPMOu7ZPnoTwEh/
        yYIT9GBGK35+eaNqt1GoXRR7Elidp8J93XXsBV0o3P4p
X-Google-Smtp-Source: AGHT+IHZeqj8ZtYmDyzDLLcX1OpS9Sufhh1V3MX13IPf812mNSybd7/H6SdmfhFnLW7fn/zxbXF6Eg==
X-Received: by 2002:a05:6000:1c7:b0:317:8fd:f01a with SMTP id t7-20020a05600001c700b0031708fdf01amr8725234wrx.7.1695741914895;
        Tue, 26 Sep 2023 08:25:14 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id c4-20020adfc044000000b003231a0ca5ebsm9431558wrf.49.2023.09.26.08.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 08:25:14 -0700 (PDT)
Message-ID: <7f9ce269-38e4-409f-bee1-d45a30e68973@kernel.dk>
Date:   Tue, 26 Sep 2023 09:25:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] io_uring: add support for vectored futex waits
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de
References: <20230921182908.160080-1-axboe@kernel.dk>
 <20230921182908.160080-9-axboe@kernel.dk>
 <9eb0fa5e-5f8d-4a55-940c-5e1ec22bbfd9@kernel.dk>
In-Reply-To: <9eb0fa5e-5f8d-4a55-940c-5e1ec22bbfd9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/23 12:41 AM, Jens Axboe wrote:
> After discussing this one with Thomas yesterday at KR2023 I had this
> nagging feeling that something was still amiss. Took a closer look at
> it, and there is an issue with the odd case of
> futex_wait_multiple_setup() returning 1. It does so if a wakeup was
> triggered during setup. Which is fine, except then it also unqueues ALL
> the futexes at that point, which is unlike the normal wakeup path on the
> io_uring side.
> 
> It'd be nice to unify those and leave the cleanup to the caller, but
> since we also re-loop in that setup handler if nobody was woken AND we
> use the futex_unqueue_multiple() to see if we were woken to begin with,
> I think it's cleaner to just note this fact in io_uring and deal with
> it.
> 
> I'm folding in the below incremental for now. Has a few cleanups in
> there too that I spotted while doing that, the important bit is the
> ->futexv_unqueued part.

For completeness, here's the V2 of this patch. Did a few more cleanups
since changes were being made. This is what is in the io_uring-futex
branch as of earlier today. Didn't think it was worthwhile to spin a new
full patchset version for this and post it.

commit 61f8c9c0b48632ea1f14519dfae9176ffbf65050
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Jun 12 19:04:32 2023 -0600

    io_uring: add support for vectored futex waits
    
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
index 4278302d212c..ad6578c97ab8 100644
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
@@ -146,6 +193,55 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
+	iof->futexv_unqueued = 0;
+	req->flags |= REQ_F_ASYNC_DATA;
+	req->async_data = futexv;
+	return 0;
+}
+
 static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 {
 	struct io_futex_data *ifd = container_of(q, struct io_futex_data, q);
@@ -170,6 +266,61 @@ static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
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
Jens Axboe

