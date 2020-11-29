Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FDF2C7A2E
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgK2RQP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 12:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2RQK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 12:16:10 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5D9C0613D3
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:15:30 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h21so17689521wmb.2
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RlvUww5Nt7FDFiFT8HhuWp0eN00KfBHjCFby8SxEfYk=;
        b=J1IUR+nA7dxN5lNEw/M8evPhCP0YzoHJ+PAf1LCJ/YpHTOl/r1SBJIZkhWp2WwGEFB
         FxzaM0FhgF+Se9qFtEaAvGsTHhzdryPiB8/R7qovf0WamPJvQQKiQiOrtUamlQaynpqB
         y8CPOWsWMDoo1i66+xaHbNeU9EUjlGJQvRk7ikFxe0Sb1/9y6rq3A+xeaHMypR4MlswZ
         pEOR+U+rHlcDGG3PLHdM8e1mbI/EUVJkD3EC/YeDtIhesHPj74pfSHQHJYVa6FArhLJH
         6Jjq0Qp8d31FxMVBEgbHSEkJGvyokM9eKmqKiVmtkSN6b7FLThJhpVmhu1LmSWHqd/ng
         SXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlvUww5Nt7FDFiFT8HhuWp0eN00KfBHjCFby8SxEfYk=;
        b=WApEDtnPRxVK6tPR1NyFwGkBkmThjjsQwT3HhtlV1QbWfrIAx2bYygHqC0CfhQtSWH
         H3FKQqNRBhWkXxCsqp1M2EgJazfTBfMcAZiJ/3UFeNK5ljsHYOZKxpclShXe5RnEwPbD
         0M1zgEM8GpipjrZ2el3SChCivRHDRqsr1CB9fUrKVTEjHMaf+w4AzgwPxcPpFCapdOAd
         anCb+vWKwi4bLlIbD5GDfLKtL2TQmS38Ir7hfhES6SDcYNQLG1NNGQwDx8/oTxa+Db2N
         0K2Z8WSucyiUgWxRYK/i8BTQenySJwHsVyXcG9YRjIy46nEmc/t3xKaRRkkyxsiuxTY/
         AMQw==
X-Gm-Message-State: AOAM532lQ+nme0XzB+1CDC4WdIaxNcHCdrxe2A+w2lI2If8AyOwoFbUE
        YLC4YJddvCDYOr3K8hrln5Ieo4R9PEo=
X-Google-Smtp-Source: ABdhPJxGui4zVa14hsUGgpWf7UOtIOkG6zeYytBxlDA0J4VlZYmL+T2m01omYD6i48BAkv2UwYVfNg==
X-Received: by 2002:a7b:c3d2:: with SMTP id t18mr19544747wmj.112.1606670129113;
        Sun, 29 Nov 2020 09:15:29 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b4sm23312035wmc.1.2020.11.29.09.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 09:15:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: add timeout update
Date:   Sun, 29 Nov 2020 17:12:06 +0000
Message-Id: <eb04a3d3154dce299c91d12a315a2335603c508a.1606669225.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606669225.git.asml.silence@gmail.com>
References: <cover.1606669225.git.asml.silence@gmail.com>
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
 fs/io_uring.c                 | 52 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bffcbec6c9be..63d0d546e661 100644
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
@@ -5677,17 +5681,51 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
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
+	if (tr->flags) {
+		if (!(tr->flags & IORING_TIMEOUT_UPDATE))
+			return -EINVAL;
+		if (tr->flags & ~(IORING_TIMEOUT_UPDATE|IORING_TIMEOUT_ABS))
+			return -EINVAL;
+
+		ret = __io_sq_thread_acquire_mm(req->ctx);
+		if (ret)
+			return ret;
+		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
+			return -EFAULT;
+	}
 	return 0;
 }
 
@@ -5696,11 +5734,19 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
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
index 6bb8229de892..12a6443ea60d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -151,6 +151,7 @@ enum {
  * sqe->timeout_flags
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
+#define IORING_TIMEOUT_UPDATE	(1U << 31)
 
 /*
  * sqe->splice_flags
-- 
2.24.0

