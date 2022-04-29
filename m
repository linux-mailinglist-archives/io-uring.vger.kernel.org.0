Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9711514944
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359126AbiD2Mbf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359128AbiD2Mbd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:33 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1D6C8BF2
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e24so7002019pjt.2
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KP/+JFXwXXF7n1EUZaYo+723Op3tLlFwcVQ5kugkeYM=;
        b=sf4hqM+9WgQtSMxuIBfS6xr8ZBUKIWvvg1UGmKNN2prZRa8QNyqXwkwgsxfc92HZmH
         DIEZRBoxDTicMdntiaZS+shmzhxlqnGFwX4USTukUHfxEEEcUNOPqTvJRodupiIenlzW
         q5pMXG4oppASxlliufq9xkLEu5RNfqeUitdacj4EwRbBPCTNeKR4vI4F3NtoitHGwlme
         AJu9a8rRJBczGo3dfsjY5emdtnRGFbbzPnpKvpD5tnYb7XLEXMCdevRKvpdImErVPZAF
         TURbvnxomNwv9siLG8jth54bTjqtWCLsAGzeV+ydXG2CCfhGWyWpqLijv8BUBfIvDuF8
         CW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KP/+JFXwXXF7n1EUZaYo+723Op3tLlFwcVQ5kugkeYM=;
        b=hmADfDM4DX6OOps1iu6hazawIPyfDL4fn9SuZPuE9vcwsuGgJldozNp/5MTvK32lg1
         WGon9ykajj2bcuhGA54iY3UK8OhZbXWi4b6GK4ZtBhUctJQiiajkrymdXNayu3GaKc8U
         SXxiaAiU1k2h7TuKF4eJzkrRZiq/xuwYWJAeY27xzfSJtnV3MDXy2ABRN9vNePYx0FOZ
         qJRH2/025T6p4XS8Z3+GP0IQPjY5Xy0qKR7he42eba68iJLxEDSygmycsob1mS85Lgwl
         dZeK25ODXdh7dCbuIoevpQ1y2tQgf4hpv4J5xCP2ModE+Uvt9iN35hrjVXTkj8KXb67w
         KQdQ==
X-Gm-Message-State: AOAM530zXqcdMJy2CBfVZ1u9kbe9OK7F7wtmA0AJCr2xSS1ifTi9BWPn
        xWkl/RdLP9eb3SXvI7AKL3RekPeIObCUiGg5
X-Google-Smtp-Source: ABdhPJyyi+P5q6wJye8mPCEhqEAHYfg0QUdF5y4Uv0mPR8XK0gRtuP5cYH2MysRuAc9+sdSh27r2Pw==
X-Received: by 2002:a17:902:7045:b0:157:144:57c5 with SMTP id h5-20020a170902704500b00157014457c5mr38326691plt.86.1651235292993;
        Fri, 29 Apr 2022 05:28:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/10] io_uring: always use req->buf_index for the provided buffer group
Date:   Fri, 29 Apr 2022 06:27:57 -0600
Message-Id: <20220429122803.41101-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 fs/io_uring.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cdb23f9861c5..3c46915ebf35 100644
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
@@ -3412,7 +3411,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->rw.flags = READ_ONCE(sqe->rw_flags);
-	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -3572,7 +3570,7 @@ static void io_buffer_add_list(struct io_ring_ctx *ctx,
 }
 
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-				     int bgid, unsigned int issue_flags)
+				     unsigned int issue_flags)
 {
 	struct io_buffer *kbuf = req->kbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -3583,7 +3581,7 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
-	bl = io_buffer_get_list(ctx, bgid);
+	bl = io_buffer_get_list(ctx, req->buf_index);
 	if (bl && !list_empty(&bl->buf_list)) {
 		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&kbuf->list);
@@ -3617,7 +3615,7 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 		return -EINVAL;
 
 	len = clen;
-	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
+	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3639,7 +3637,7 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	len = iov[0].iov_len;
 	if (len < 0)
 		return -EINVAL;
-	buf = io_buffer_select(req, &len, req->buf_index, issue_flags);
+	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 	iov[0].iov_base = buf;
@@ -3695,8 +3693,7 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (req->flags & REQ_F_BUFFER_SELECT) {
-			buf = io_buffer_select(req, &sqe_len, req->buf_index,
-						issue_flags);
+			buf = io_buffer_select(req, &sqe_len, issue_flags);
 			if (IS_ERR(buf))
 				return ERR_CAST(buf);
 			req->rw.len = sqe_len;
@@ -5904,7 +5901,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-	sr->bgid = READ_ONCE(sqe->buf_group);
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
@@ -5942,7 +5938,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		void __user *buf;
 
-		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		buf = io_buffer_select(req, &sr->len, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
 		kmsg->fast_iov[0].iov_base = buf;
@@ -6004,7 +6000,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		void __user *buf;
 
-		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		buf = io_buffer_select(req, &sr->len, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
 	}
@@ -8277,9 +8273,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
 			return -EINVAL;
-		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-		    !io_op_defs[opcode].buffer_select)
-			return -EOPNOTSUPP;
+		if ((sqe_flags & IOSQE_BUFFER_SELECT)) {
+			if (!io_op_defs[opcode].buffer_select)
+				return -EOPNOTSUPP;
+			req->buf_index = READ_ONCE(sqe->buf_group);
+		}
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
-- 
2.35.1

