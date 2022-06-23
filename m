Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74CA5573BA
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 09:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiFWHRi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 03:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiFWHRi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 03:17:38 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516BA45AED
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 00:17:36 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655968654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yzZV3KZ6biIf64EwUEid2qfQf2tuAGXoQWqj5DNuEd8=;
        b=GtTeCnw3R6CrcV9LwfSaozsfEizy9/ArU972sHVIRat8lFIyJHOuy7IwEWdSar/YKryVoK
        nxtNoCtZdRl8NOcDy/7T052U/Fc7UqvevhqxY7WzZQYy6isr68g18Ixp+Au3838B4Ry7of
        NSGEwPUJpHjE5EKt8NV3wklqA4K1zLI=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: kbuf: inline io_kbuf_recycle_ring()
Date:   Thu, 23 Jun 2022 15:17:23 +0800
Message-Id: <20220623071723.154971-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Make io_kbuf_recycle_ring() inline since it is the fast path of
provided buffer.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/kbuf.c | 66 ------------------------------------------------
 io_uring/kbuf.h | 67 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 64 insertions(+), 69 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 4b7f2aa99e38..306db7929a50 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -17,8 +17,6 @@
 
 #define IO_BUFFER_LIST_BUF_PER_PAGE (PAGE_SIZE / sizeof(struct io_uring_buf))
 
-#define BGID_ARRAY	64
-
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -28,15 +26,6 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
-static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
-							unsigned int bgid)
-{
-	if (ctx->io_bl && bgid < BGID_ARRAY)
-		return &ctx->io_bl[bgid];
-
-	return xa_load(&ctx->io_bl_xa, bgid);
-}
-
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
 			      struct io_buffer_list *bl, unsigned int bgid)
 {
@@ -47,61 +36,6 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
-void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer_list *bl;
-	struct io_buffer *buf;
-
-	/*
-	 * For legacy provided buffer mode, don't recycle if we already did
-	 * IO to this buffer. For ring-mapped provided buffer mode, we should
-	 * increment ring->head to explicitly monopolize the buffer to avoid
-	 * multiple use.
-	 */
-	if (req->flags & REQ_F_PARTIAL_IO)
-		return;
-
-	io_ring_submit_lock(ctx, issue_flags);
-
-	buf = req->kbuf;
-	bl = io_buffer_get_list(ctx, buf->bgid);
-	list_add(&buf->list, &bl->buf_list);
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	req->buf_index = buf->bgid;
-
-	io_ring_submit_unlock(ctx, issue_flags);
-	return;
-}
-
-void io_kbuf_recycle_ring(struct io_kiocb *req)
-{
-	/*
-	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
-	 * the flag and hence ensure that bl->head doesn't get incremented.
-	 * If the tail has already been incremented, hang on to it.
-	 * The exception is partial io, that case we should increment bl->head
-	 * to monopolize the buffer.
-	 */
-	if (req->buf_list) {
-		if (req->flags & REQ_F_PARTIAL_IO) {
-			/*
-			 * If we end up here, then the io_uring_lock has
-			 * been kept held since we retrieved the buffer.
-			 * For the io-wq case, we already cleared
-			 * req->buf_list when the buffer was retrieved,
-			 * hence it cannot be set here for that case.
-			 */
-			req->buf_list->head++;
-			req->buf_list = NULL;
-		} else {
-			req->buf_index = req->buf_list->bgid;
-			req->flags &= ~REQ_F_BUFFER_RING;
-		}
-	}
-	return;
-}
-
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
 {
 	unsigned int cflags;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b5a89ffadf31..5b0b129e3e9c 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -4,6 +4,8 @@
 
 #include <uapi/linux/io_uring.h>
 
+#define BGID_ARRAY	64
+
 struct io_buffer_list {
 	/*
 	 * If ->buf_nr_pages is set, then buf_pages/buf_ring are used. If not,
@@ -48,9 +50,6 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
-void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
-void io_kbuf_recycle_ring(struct io_kiocb *req);
-
 static inline bool io_do_buffer_select(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
@@ -58,6 +57,68 @@ static inline bool io_do_buffer_select(struct io_kiocb *req)
 	return !(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING));
 }
 
+static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
+							unsigned int bgid)
+{
+	if (ctx->io_bl && bgid < BGID_ARRAY)
+		return &ctx->io_bl[bgid];
+
+	return xa_load(&ctx->io_bl_xa, bgid);
+}
+
+static void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	struct io_buffer *buf;
+
+	/*
+	 * For legacy provided buffer mode, don't recycle if we already did
+	 * IO to this buffer. For ring-mapped provided buffer mode, we should
+	 * increment ring->head to explicitly monopolize the buffer to avoid
+	 * multiple use.
+	 */
+	if (req->flags & REQ_F_PARTIAL_IO)
+		return;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	buf = req->kbuf;
+	bl = io_buffer_get_list(ctx, buf->bgid);
+	list_add(&buf->list, &bl->buf_list);
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	req->buf_index = buf->bgid;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+}
+
+static inline void io_kbuf_recycle_ring(struct io_kiocb *req)
+{
+	/*
+	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
+	 * the flag and hence ensure that bl->head doesn't get incremented.
+	 * If the tail has already been incremented, hang on to it.
+	 * The exception is partial io, that case we should increment bl->head
+	 * to monopolize the buffer.
+	 */
+	if (req->buf_list) {
+		if (req->flags & REQ_F_PARTIAL_IO) {
+			/*
+			 * If we end up here, then the io_uring_lock has
+			 * been kept held since we retrieved the buffer.
+			 * For the io-wq case, we already cleared
+			 * req->buf_list when the buffer was retrieved,
+			 * hence it cannot be set here for that case.
+			 */
+			req->buf_list->head++;
+			req->buf_list = NULL;
+		} else {
+			req->buf_index = req->buf_list->bgid;
+			req->flags &= ~REQ_F_BUFFER_RING;
+		}
+	}
+}
+
 static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED)

base-commit: 5ec69c3a15ae6e904d76545d9a9c686eb758def0
-- 
2.25.1

