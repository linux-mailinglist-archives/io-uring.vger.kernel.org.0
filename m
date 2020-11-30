Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB60C2C8DCA
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 20:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgK3TPX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 14:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbgK3TPV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 14:15:21 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E42C0613D3
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:14:41 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id d3so418918wmb.4
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G2HxNnOkKwWmj/X9R+TffahlMmjtCxcFZgBEyduHx+o=;
        b=Zomhg3z14UiA/44UpTGTAYV57EjWVPAyJCxucG4iYEx5dgYwPa+1WPDtNVzF5s8AoJ
         4LYJjFhI8DdQyM57iniWfF8RBYME+sPVMoCN3kENp88GICPv54o2YzkmPG0URTrWMfLv
         RxU1+A410zccTGzu4ikHP/zF/z27zHohC1O0Mw0DNQvZWXRKfmC9pRsGeOHZgmHWTrIK
         pIvRj3soMUiRp07YFLPa8HSHKlXZhK5D/usfA/BJ7K3WJBJ2MEuarmuDSI7x1LAK2QS+
         EGUe/vf4KztGHVJr/0fMdKsk4oT6iOwAu/txaZIF8PQi/yP2CcLDbBYwm585btIWUb9J
         w7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2HxNnOkKwWmj/X9R+TffahlMmjtCxcFZgBEyduHx+o=;
        b=opUvoiFTw/xzLS/ne3Fg+A6mt8nzboWj8888luZsHiHWJXSyCeXF+qgit4EF7xKjhN
         lMQ4wwLwE24O4GYaIuLTyC/9oo3vp9oYTQLKvbk7OWyCN2iCq88ANPBWBLrniSNns8aD
         HkJww7rAJXX7WQF8EfhkiHpM2Xf+rYP8iwy50M4LP7IeIpIV1fBRlQAjsOi2TWDF7mnG
         K7zLFXoB8DC9DKCuLj9rov1vzYI0nGuKySV17MVJnB/2iGliq/hjl5uqnbEDFR7AbRSy
         E7hWqlZHNFtOOlGAjMIbnxE80LgpDEt6o0kNp4QdEmSbIHh8vknXALvXbKaogisPkvg8
         QIrQ==
X-Gm-Message-State: AOAM533cbL0jjuEn8ydAdKWUN70QEYPdux8BjtyScJnKJgg8Qasbonrq
        c4tWVg5LiRz+lEW9Ra2Y5wY=
X-Google-Smtp-Source: ABdhPJzOLWbJD24QL6X9o5gHtaQR8HJfUENgDTtPtK956mfp/S6MOPWEbAJyR1rg1j0qBKiwU8qRKw==
X-Received: by 2002:a1c:7f81:: with SMTP id a123mr364989wmd.6.1606763679898;
        Mon, 30 Nov 2020 11:14:39 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id d3sm28690657wrr.2.2020.11.30.11.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:14:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/2] io_uring: add timeout update
Date:   Mon, 30 Nov 2020 19:11:16 +0000
Message-Id: <1aabcd52c376b94be7a079e1901113bdf69b607a.1606763416.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606763415.git.asml.silence@gmail.com>
References: <cover.1606763415.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Support timeout updates through IORING_OP_TIMEOUT_REMOVE with passed in
IORING_TIMEOUT_UPDATE. Updates doesn't support offset timeout mode.
Oirignal timeout.off will be ignored as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 55 ++++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bffcbec6c9be..b811f14d1ce0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -453,6 +453,10 @@ struct io_timeout {
 struct io_timeout_rem {
 	struct file			*file;
 	u64				addr;
+
+	/* timeout update */
+	struct timespec64		ts;
+	u32				flags;
 };
 
 struct io_rw {
@@ -867,7 +871,10 @@ static const struct io_op_def io_op_defs[] = {
 		.async_size		= sizeof(struct io_timeout_data),
 		.work_flags		= IO_WQ_WORK_MM,
 	},
-	[IORING_OP_TIMEOUT_REMOVE] = {},
+	[IORING_OP_TIMEOUT_REMOVE] = {
+		/* used by timeout updates' prep() */
+		.work_flags		= IO_WQ_WORK_MM,
+	},
 	[IORING_OP_ACCEPT] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -5677,17 +5684,49 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	return 0;
 }
 
+static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
+			     struct timespec64 *ts, enum hrtimer_mode mode)
+{
+	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+	struct io_timeout_data *data;
+
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	req->timeout.off = 0; /* noseq */
+	data = req->async_data;
+	list_add_tail(&req->timeout.list, &ctx->timeout_list);
+	hrtimer_init(&data->timer, CLOCK_MONOTONIC, mode);
+	data->timer.function = io_timeout_fn;
+	hrtimer_start(&data->timer, timespec64_to_ktime(*ts), mode);
+	return 0;
+}
+
 static int io_timeout_remove_prep(struct io_kiocb *req,
 				  const struct io_uring_sqe *sqe)
 {
+	struct io_timeout_rem *tr = &req->timeout_rem;
+	int ret;
+
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->len)
 		return -EINVAL;
 
-	req->timeout_rem.addr = READ_ONCE(sqe->addr);
+	tr->addr = READ_ONCE(sqe->addr);
+	tr->flags = READ_ONCE(sqe->timeout_flags);
+	if (tr->flags & IORING_TIMEOUT_UPDATE) {
+		if (tr->flags & ~(IORING_TIMEOUT_UPDATE|IORING_TIMEOUT_ABS))
+			return -EINVAL;
+		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
+			return -EFAULT;
+	} else if (tr->flags) {
+		/* timeout removal doesn't support flags */
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -5696,11 +5735,19 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
  */
 static int io_timeout_remove(struct io_kiocb *req)
 {
+	struct io_timeout_rem *tr = &req->timeout_rem;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	ret = io_timeout_cancel(ctx, req->timeout_rem.addr);
+	if (req->timeout_rem.flags & IORING_TIMEOUT_UPDATE) {
+		enum hrtimer_mode mode = (tr->flags & IORING_TIMEOUT_ABS)
+					? HRTIMER_MODE_ABS : HRTIMER_MODE_REL;
+
+		ret = io_timeout_update(ctx, tr->addr, &tr->ts, mode);
+	} else {
+		ret = io_timeout_cancel(ctx, tr->addr);
+	}
 
 	io_cqring_fill_event(req, ret);
 	io_commit_cqring(ctx);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6bb8229de892..d31a2a1e8ef9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -151,6 +151,7 @@ enum {
  * sqe->timeout_flags
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
+#define IORING_TIMEOUT_UPDATE	(1U << 1)
 
 /*
  * sqe->splice_flags
-- 
2.24.0

