Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8910B5167E8
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354816AbiEAVAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354821AbiEAVA3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:29 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5B618398
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:03 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d15so11154667plh.2
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bwKiUuOiYENMlLum0LQXI24rCO0BBn3uwHxoACAM6Js=;
        b=3ynFshUmJHZ2MV0f+QKHTA8+DnbGkqkI+CsTSgSYz6d6F8Tn9Rcos7eoe25aUfwNIv
         9lZPQEnsd5Oz5h3l6vOq3jcWdPMK9pfpmTx648j04EasIBqMyoq/kMD9wZFPQbbQyb8h
         d2eIFALk3i3QhSp98i0i/Fgd2BT+whUOd+G+7lKtr0gchUV10dgz/SffHkQgXWBQvDi+
         78lvAogyG97UUyuO/Ky5Rue5Vyp1H9k9YWyFac3vD86sL2eGKBlQsqGsnPA14/6nAooq
         DBtB682ug9RTvHAVTDrWleOkM+r3AClhVQdTax40hD12okQK/zE/WuXz0JMTPiLgI837
         OsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bwKiUuOiYENMlLum0LQXI24rCO0BBn3uwHxoACAM6Js=;
        b=ETZ5m79r+cxNNnjNq1nXVyeN2mtTG5h11sWyDJLke7u5Yrh3h6D4qtMYX5g//0UtB4
         XKmm/sblEaSjflMtvd6bZOJa8/0gp7oW/xXpJycYKKs8VX0kW51atm3io/moW2iGxZZd
         19rzmWQ0EtEYhP82mJIeSui6HOARzD0uv9rZcxMrXL0fVn4oE4UCnnzEU4ouLUQ6A2dD
         TNtoyVsotd5/mKG77Q6Le4AsvVfa0WAEc9xEjhDYJFQ+zQm/F88h4sYBwHeqQgq/f18d
         Rnc0SVBdOJdEhFggLk7eByaMFV1v1TLZ/LyWM5u/7ZPNwhZlsA4LBT5xtTCFeqLHmrbE
         oiAw==
X-Gm-Message-State: AOAM53345yOR0p6ja5cLUIOPNFzGoIpB3uGcVQwJYitLubkB+IvsSPVx
        iGLu6eUkJ3Dkt/CRXfPwxjJL11bibB/aMg==
X-Google-Smtp-Source: ABdhPJw1gKU28++L1aCTjd9A0PF61RnPTjlf4/S9PAzn1O6M3nsu4lVs6G82JMZLOusycZEUnuBHpA==
X-Received: by 2002:a17:903:110f:b0:15e:7d64:bdad with SMTP id n15-20020a170903110f00b0015e7d64bdadmr9192627plh.59.1651438622626;
        Sun, 01 May 2022 13:57:02 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/16] io_uring: always use req->buf_index for the provided buffer group
Date:   Sun,  1 May 2022 14:56:43 -0600
Message-Id: <20220501205653.15775-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index baa1b5426bfc..eba18685a705 100644
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
@@ -5999,7 +5997,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		void __user *buf;
 
-		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		buf = io_buffer_select(req, &sr->len, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
 	}
@@ -8272,9 +8270,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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

