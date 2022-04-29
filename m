Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD31515311
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379837AbiD2SAH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379835AbiD2SAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:05 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED58FFB7
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:45 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id i20so8877572ion.0
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/VqNFbzicUMKy4gXt1iB7bSR/oJ6wsAcE21tvivRq48=;
        b=O23arPzxAP0Y6ZuLC1NgeEiREsfxMYWNaqDaYEZwYwpK8NrHVTM7dNDjD35378JZpS
         grsgkr3nztp7saR6rtN59WY9aaMGK46nWNYERFfWD31AfwNNAR4lGUHczxo/7/GLMGxV
         sazzBs4p2T9eCkRTy44J3Kool/Gy2Ljp6VodO3jDcNt9S4+BVnF7Viek4EwED6Pn7MKx
         7NwNW5DJe0XkevmKjdFO6ayoDnavwCH73cR7tZt/8mxipyfP9EKKIHQZoAxlqbWzuiYU
         J+S5wNs7cxlnyQWqrclbOC91AQ5k8+SjHb+P8IDdB9SHWKV7Yu4k91sh9N6/4FrQ3ft8
         7ldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/VqNFbzicUMKy4gXt1iB7bSR/oJ6wsAcE21tvivRq48=;
        b=2zB3Cf7NRrSXLm/xLuKwJyWgma9YfUZ9FjAYPeU6IO9x3X0+O2qy7dHWEMGTpRwJC0
         RTUQpsiAlhhWo+bPX6LB/9OJNn6yTx6nU63vxUoGT7ccWob6ZTiHuj+3tAae4JWwrUuP
         Ks0s0rvUgSrp9m0JPRBOknD7C8cr5p637X27zKwG0iJGsdPUt8J7i7KKckZBztLCsS4p
         DP/C3MuaO9fpWugeWxzD84b2DfwFG9H/Q+rqmsNMfQJD5tkOCKNVLfW7OYWOiAnEQXcA
         ftvrsIkm3UDS/Yn5TBzB9+dYDnISNl4yRGKoG+FMf2hv9kyBdpA46qgoaJkROyREusvN
         jxmA==
X-Gm-Message-State: AOAM533zq6YdWq2acoVD+O5DtkFmOLV/iN7Zkp/Oi+OJrlosbUMXvbfu
        CqJ6F6PEdSiOVUomKzgOg+754/p9Ip43VQ==
X-Google-Smtp-Source: ABdhPJzD2GYsPTm0cnrAtK47a1N5J3mwT80ueIT+WOv7Abo+ox0pyZ2ajrJAc5aHiKt28YffDxCPIw==
X-Received: by 2002:a05:6638:14d1:b0:32a:a87d:6055 with SMTP id l17-20020a05663814d100b0032aa87d6055mr233923jak.116.1651255004972;
        Fri, 29 Apr 2022 10:56:44 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/11] io_uring: always use req->buf_index for the provided buffer group
Date:   Fri, 29 Apr 2022 11:56:29 -0600
Message-Id: <20220429175635.230192-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The read/write opcodes use it already, but the recv/recvmsg do not. If
we switch them over and read and validate this at init time while we're
checking if the opcode supports it anyway, then we can do it in one spot
and we don't have to pass in a separate group ID for io_buffer_select().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a570f47e3f76..41205548180d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -644,7 +644,6 @@ struct io_sr_msg {
 		void __user			*buf;
 	};
 	int				msg_flags;
-	int				bgid;
 	size_t				len;
 	size_t				done_io;
 };
@@ -3412,6 +3411,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->rw.flags = READ_ONCE(sqe->rw_flags);
+	/* used for fixed read/write too - just read unconditionally */
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
@@ -3572,7 +3572,7 @@ static void io_buffer_add_list(struct io_ring_ctx *ctx,
 }
 
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-				     int bgid, unsigned int issue_flags)
+				     unsigned int issue_flags)
 {
 	struct io_buffer *kbuf = req->kbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3583,7 +3583,7 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
-	bl = io_buffer_get_list(ctx, bgid);
+	bl = io_buffer_get_list(ctx, req->buf_index);
 	if (bl && !list_empty(&bl->buf_list)) {
 		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&kbuf->list);
@@ -3617,7 +3617,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 		return -EINVAL;
 
 	len = clen;
-	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
+	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3639,7 +3639,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	len = iov[0].iov_len;
 	if (len < 0)
 		return -EINVAL;
-	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
+	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3691,8 +3691,7 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			buf = io_buffer_select(req, &sqe_len, req->buf_index,
-						issue_flags);
+			buf = io_buffer_select(req, &sqe_len, issue_flags);
 			if (IS_ERR(buf))
 				return ERR_CAST(buf);
 			req->rw.len = sqe_len;
@@ -5900,7 +5899,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-	sr->bgid = READ_ONCE(sqe->buf_group);
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
@@ -5938,7 +5936,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		void __user *buf;
 
-		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		buf = io_buffer_select(req, &sr->len, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
 		kmsg->fast_iov[0].iov_base = buf;
@@ -6000,7 +5998,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		void __user *buf;
 
-		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		buf = io_buffer_select(req, &sr->len, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
 	}
@@ -8273,9 +8271,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
 			return -EINVAL;
-		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-		    !io_op_defs[opcode].buffer_select)
-			return -EOPNOTSUPP;
+		if (sqe_flags & IOSQE_BUFFER_SELECT) {
+			if (!io_op_defs[opcode].buffer_select)
+				return -EOPNOTSUPP;
+			req->buf_index = READ_ONCE(sqe->buf_group);
+		}
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
-- 
2.35.1

