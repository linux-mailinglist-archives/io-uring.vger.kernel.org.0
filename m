Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C1530F46D
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhBDN7t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbhBDN5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:57:43 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B566C061352
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:13 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id t142so1025943wmt.1
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gaHPV73rRnUDt98JYixAH4NXNQoJ7mGeZnGHKCExkx0=;
        b=KVlLrC1ZkuXqHaABAj34Ecyjd1m4Cy6CES7YlPU/CRoHeZIPmVvGrXnx4pdZ0XToD/
         YOKm72aBP+2zpSZVNBkkL1DjG+CnDyK/M0oxCr1oJMT6lmYxy9rLng14DjUh0Ov8kSyL
         uTXzqgzzJyDLNfdGZBm6B3cePnQRdcC6vJePtRE2xpA5QyjswQI+sJKfUS3Mp6PqQrHX
         UObnuaymD8XQ6LWY0h++XC6eOiHpinuNtwtFaqxZ0Al51A+afNHwoXv+zFdcKPjtOost
         p9tPlWsMm9GPUHnYgxP2ZkaNVBPN4NXZcx4WEh4crWQPzz7rpaStmEnWELx8ntUOm+c+
         VVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gaHPV73rRnUDt98JYixAH4NXNQoJ7mGeZnGHKCExkx0=;
        b=T6gNfBLsSBfiFr/nt0BzV71O4PC7GK5lKSHeaK3TVY1xssqbZp8E/+MnRaH3ghdxmg
         bSO5cz5i9AEJzbqz3B4jOz+dIy/wU4wMSpXbq4+XzTtRmf68IadhQh1CyhkzCiXmLRjI
         iB2ybSKQ730l6htmH1XdeqBjJrq9uwV4T271F6b2z10n4jTePxzAkeCQP5oL7ABXYy09
         6lY4SHAkXJcEmJfh0DOVVmT7YOQMaKBqlZfc26gRHSckC9OSl0jaSP7Gn7CW9iLYjfW1
         fN03nIVW5bVBEHUvybJJt2sz5a5QqvZCJr+LkAY+OCnlYxwBKrE4qOKbMbeF81zKlNht
         Xorw==
X-Gm-Message-State: AOAM533fQB3joYEcIpP50IunMVunW0wVcjIYF2wCPyakg1gumEKoErt2
        GLhFLmYcLZ9aKsTffy8TKw4=
X-Google-Smtp-Source: ABdhPJyAKSCgEjruKSNojOxhJ5O2lP7fzpVrJMhdvVJMrVAw+vIt0WIMElXsPmkwOriUh4dQa5skSw==
X-Received: by 2002:a1c:4904:: with SMTP id w4mr7624491wma.180.1612446972374;
        Thu, 04 Feb 2021 05:56:12 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 11/13] io_uring: io_import_iovec return type cleanup
Date:   Thu,  4 Feb 2021 13:52:06 +0000
Message-Id: <7318e2fe57d6c5319bf28caca6924a06d999e605.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_import_iovec() doesn't return IO size anymore, only error code. Make
it more apparent by returning int instead of ssize and clean up
leftovers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce2ea3f55f65..24cc00ff7155 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1030,9 +1030,8 @@ static struct file *io_file_get(struct io_submit_state *state,
 static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
 static void io_rsrc_put_work(struct work_struct *work);
 
-static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
-			       struct iovec **iovec, struct iov_iter *iter,
-			       bool needs_lock);
+static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
+			   struct iov_iter *iter, bool needs_lock);
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
@@ -2693,9 +2692,8 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	ssize_t ret = -ECANCELED;
+	int rw, ret = -ECANCELED;
 	struct iov_iter iter;
-	int rw;
 
 	/* already prepared */
 	if (req->async_data)
@@ -3004,8 +3002,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		io_rw_done(kiocb, ret);
 }
 
-static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
-			       struct iov_iter *iter)
+static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	size_t len = req->rw.len;
@@ -3069,7 +3066,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 		}
 	}
 
-	return len;
+	return 0;
 }
 
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
@@ -3210,16 +3207,14 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, needs_lock);
 }
 
-static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
-				 struct iovec **iovec, struct iov_iter *iter,
-				 bool needs_lock)
+static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
+			   struct iov_iter *iter, bool needs_lock)
 {
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
 	size_t sqe_len = req->rw.len;
+	u8 opcode = req->opcode;
 	ssize_t ret;
-	u8 opcode;
 
-	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
 		return io_import_fixed(req, rw, iter);
@@ -3244,10 +3239,8 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		ret = io_iov_buffer_select(req, *iovec, needs_lock);
-		if (!ret) {
-			ret = (*iovec)->iov_len;
-			iov_iter_init(iter, rw, *iovec, 1, ret);
-		}
+		if (!ret)
+			iov_iter_init(iter, rw, *iovec, 1, (*iovec)->iov_len);
 		*iovec = NULL;
 		return ret;
 	}
@@ -3379,7 +3372,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 {
 	struct io_async_rw *iorw = req->async_data;
 	struct iovec *iov = iorw->fast_iov;
-	ssize_t ret;
+	int ret;
 
 	ret = io_import_iovec(rw, req, &iov, &iorw->iter, false);
 	if (unlikely(ret < 0))
@@ -3518,7 +3511,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	}
 	io_size = iov_iter_count(iter);
 	req->result = io_size;
-	ret = 0;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
-- 
2.24.0

