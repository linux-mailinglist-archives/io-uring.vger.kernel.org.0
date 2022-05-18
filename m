Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B6452B574
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiERIkU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 04:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbiERIkT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 04:40:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A52E1238B1
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 01:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=P8s2iw1N3sL3IRMVRz72GXdwH+YWNdJ1pUpX8T3gav4=; b=khvJYo5vmjIDvNXDtCYKldVBk9
        iWuzJ8C8A9rV6hQnKkuZy1sYxTszGc1xI2aZzyqtzhALlpWcbz3oOSwxQrTA+ZOBzYbcHp7PODlOh
        fTSOQTH1Wx6Xxcyd6VjsLLIhU73cIdh2AWHbIYpyLszoZ9ysdxi9R6ciMza0W4hnMmKmivlxzARlU
        hT1sLAeF2LsJMKCwphzfCBF5VLFZifwtOmhLr2Gb3oFO+FxB1lbgoFD+HuEaCQNRq5dZCY4bObcEo
        wacDGCeIA4xb4VZ67JeYQPHBpWuSwc7zwaMtRtBHuadVljp8h6rakC/haOJTGwkkBMXDw0Gk7O5pk
        /Jmx4/Og==;
Received: from [2001:4bb8:19a:7bdf:8143:492c:c3b:39b6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrFE8-000dTW-P3; Wed, 18 May 2022 08:40:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH 2/6] io_uring: don't use ERR_PTR for user pointers
Date:   Wed, 18 May 2022 10:40:01 +0200
Message-Id: <20220518084005.3255380-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518084005.3255380-1-hch@lst.de>
References: <20220518084005.3255380-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ERR_PTR abuses the high bits of a pointer to transport error information.
This is only safe for kernel pointers and not user pointers.  Fix
io_buffer_select and its helpers to just return NULL for failure and get
rid of this abuse.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/io_uring.c | 83 +++++++++++++++++++++++----------------------------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 99862cbc1041c..abb7108258f96 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3797,11 +3797,8 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 }
 
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
-					      struct io_buffer_list *bl,
-					      unsigned int issue_flags)
+					      struct io_buffer_list *bl)
 {
-	void __user *ret = ERR_PTR(-ENOBUFS);
-
 	if (!list_empty(&bl->buf_list)) {
 		struct io_buffer *kbuf;
 
@@ -3812,11 +3809,9 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 		req->flags |= REQ_F_BUFFER_SELECTED;
 		req->kbuf = kbuf;
 		req->buf_index = kbuf->bid;
-		ret = u64_to_user_ptr(kbuf->addr);
+		return u64_to_user_ptr(kbuf->addr);
 	}
-
-	io_ring_submit_unlock(req->ctx, issue_flags);
-	return ret;
+	return NULL;
 }
 
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
@@ -3829,7 +3824,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 
 	if (unlikely(smp_load_acquire(&br->tail) == head)) {
 		io_ring_submit_unlock(req->ctx, issue_flags);
-		return ERR_PTR(-ENOBUFS);
+		return NULL;
 	}
 
 	head &= bl->mask;
@@ -3847,22 +3842,19 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
-	if (!(issue_flags & IO_URING_F_UNLOCKED))
-		return u64_to_user_ptr(buf->addr);
-
-	/*
-	 * If we came in unlocked, we have no choice but to
-	 * consume the buffer here. This does mean it'll be
-	 * pinned until the IO completes. But coming in
-	 * unlocked means we're in io-wq context, hence there
-	 * should be no further retry. For the locked case, the
-	 * caller must ensure to call the commit when the
-	 * transfer completes (or if we get -EAGAIN and must
-	 * poll or retry).
-	 */
-	req->buf_list = NULL;
-	bl->head++;
-	io_ring_submit_unlock(req->ctx, issue_flags);
+	if (issue_flags & IO_URING_F_UNLOCKED) {
+		/*
+		 * If we came in unlocked, we have no choice but to consume the
+		 * buffer here. This does mean it'll be pinned until the IO
+		 * completes. But coming in unlocked means we're in io-wq
+		 * context, hence there should be no further retry. For the
+		 * locked case, the caller must ensure to call the commit when
+		 * the transfer completes (or if we get -EAGAIN and must poll
+		 * or retry).
+		 */
+		req->buf_list = NULL;
+		bl->head++;
+	}
 	return u64_to_user_ptr(buf->addr);
 }
 
@@ -3871,20 +3863,19 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
+	void __user *ret = NULL;
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
-	if (unlikely(!bl)) {
-		io_ring_submit_unlock(req->ctx, issue_flags);
-		return ERR_PTR(-ENOBUFS);
+	if (likely(bl)) {
+		if (bl->buf_nr_pages)
+			ret = io_ring_buffer_select(req, len, bl, issue_flags);
+		else
+			ret = io_provided_buffer_select(req, len, bl);
 	}
-
-	/* selection helpers drop the submit lock again, if needed */
-	if (bl->buf_nr_pages)
-		return io_ring_buffer_select(req, len, bl, issue_flags);
-
-	return io_provided_buffer_select(req, len, bl, issue_flags);
+	io_ring_submit_unlock(req->ctx, issue_flags);
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -3906,8 +3897,8 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 
 	len = clen;
 	buf = io_buffer_select(req, &len, issue_flags);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
+	if (!buf)
+		return -ENOBUFS;
 	req->rw.addr = (unsigned long) buf;
 	iov[0].iov_base = buf;
 	req->rw.len = iov[0].iov_len = (compat_size_t) len;
@@ -3929,8 +3920,8 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	if (len < 0)
 		return -EINVAL;
 	buf = io_buffer_select(req, &len, issue_flags);
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
+	if (!buf)
+		return -ENOBUFS;
 	req->rw.addr = (unsigned long) buf;
 	iov[0].iov_base = buf;
 	req->rw.len = iov[0].iov_len = len;
@@ -3987,8 +3978,8 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		if (io_do_buffer_select(req)) {
 			buf = io_buffer_select(req, &sqe_len, issue_flags);
-			if (IS_ERR(buf))
-				return ERR_CAST(buf);
+			if (!buf)
+				return ERR_PTR(-ENOBUFS);
 			req->rw.addr = (unsigned long) buf;
 			req->rw.len = sqe_len;
 		}
@@ -5259,8 +5250,8 @@ static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 		size_t len = 1;
 
 		buf = io_buffer_select(req, &len, issue_flags);
-		if (IS_ERR(buf))
-			return PTR_ERR(buf);
+		if (!buf)
+			return -ENOBUFS;
 	}
 
 	if (!(req->ctx->flags & IORING_SETUP_CQE32))
@@ -6394,8 +6385,8 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		void __user *buf;
 
 		buf = io_buffer_select(req, &sr->len, issue_flags);
-		if (IS_ERR(buf))
-			return PTR_ERR(buf);
+		if (!buf)
+			return -ENOBUFS;
 		kmsg->fast_iov[0].iov_base = buf;
 		kmsg->fast_iov[0].iov_len = sr->len;
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
@@ -6464,8 +6455,8 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		void __user *buf;
 
 		buf = io_buffer_select(req, &sr->len, issue_flags);
-		if (IS_ERR(buf))
-			return PTR_ERR(buf);
+		if (!buf)
+			return -ENOBUFS;
 		sr->buf = buf;
 	}
 
-- 
2.30.2

