Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC66151606C
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244388AbiD3UyK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245150AbiD3Uxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:55 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8B413F40
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:32 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t13so8989259pgn.8
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/VqNFbzicUMKy4gXt1iB7bSR/oJ6wsAcE21tvivRq48=;
        b=4qeSIByuJSKKmkS33sDu7MFmECwlzWKKShnwpvxItxxiqR6qUbL0OeQeGlZccaVBsG
         nOXTKDrbjNTanPCZEoJ/6Te/Hd6VDuGGwhNf3Nj4p3nSaAnjNphzIF2K2C5skWuky+HN
         hGXS/pLU6UaLJbUucwlMxTd/IjFdi8vbIpiAwJ4nnDeRkaxzo2w+han+RmAUNk+D5JtL
         CYFvylmooCsnsoKHQqdZtwi8IoFnJhU/sX5wx0Ba5/tVw2yWKee/bRi4Mv7EtPOD1ceF
         clQLz4zmXXY4ME620DColdIDfsKgwjzfPwtAG27rhFjgUEyquTFeyUaRCvGEXJ0nikuP
         WVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/VqNFbzicUMKy4gXt1iB7bSR/oJ6wsAcE21tvivRq48=;
        b=jgTnmvfYnKcJSEAEY0yrnZh4lY4KCRuGQxMvgJVmllI7D6XeutFKngY5bWwKKxzjnQ
         1QbEoiTL34GfWG0icL/TJusBuTjHkwj59j4qro+0dHBDsF42eGRH9uTP3ZuETVnfycpm
         XkmEp91ms0kTzk9OxzmCHHhy7wCxLNAuqc2tuEKIrwvKZgWFFuq9s+5zKl3XeR1yCwaK
         C87lRPvdwu2u1Na8xcyhB/NbD7jRZqVpETZCWxJix62KmkIB5f5YaLLX4bzlBgkhYLH/
         aYrH6v5XMx7QUuEyiJiOBwZhgXEt6ASROcP73I87O+ORd5+ZMw1FdmqtF18EWWuHvbjh
         lwKA==
X-Gm-Message-State: AOAM533u9UfsIfw/IjcnRbt75GAKGgF9ogpMDPqiSBatIhEZlW/R75xm
        cMlKNCYzgJexTo0DpTwCKyXlIRw2hCh95JAj
X-Google-Smtp-Source: ABdhPJy5NlsXvPwsPtffnCnYtoY4cWt2RC7kT9RSnKVjHJBeLCoNMY6k48NBzc/X+k+yrC+z74t72g==
X-Received: by 2002:aa7:8094:0:b0:505:b544:d1ca with SMTP id v20-20020aa78094000000b00505b544d1camr4997182pff.26.1651351831321;
        Sat, 30 Apr 2022 13:50:31 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/12] io_uring: always use req->buf_index for the provided buffer group
Date:   Sat, 30 Apr 2022 14:50:15 -0600
Message-Id: <20220430205022.324902-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
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

