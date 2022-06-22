Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B9554289
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 08:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiFVF4M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 01:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiFVF4L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 01:56:11 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E30340F0
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 22:56:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655877366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TCYJR7DIdxbPgke571XlZQN3/92yaoDkEpr8RGVyuac=;
        b=TpvksRRNug0T5vjCYE0T69j6pURSC+Zo68r2baKD0Ehdbvz7y4fp56Mp5LCa1M4cZMBwno
        6ssc4XJv/5KIZAumjoAhbidjSWUmfC9EKH13B0STiyjkHQnB0E3kMP3AvTVVfyZGbNUY4y
        Rk0AHmkxPWIAoNPzrbX7jDqfBX+Bojw=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: kbuf: kill __io_kbuf_recycle()
Date:   Wed, 22 Jun 2022 13:55:51 +0800
Message-Id: <20220622055551.642370-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

__io_kbuf_recycle() is only called in io_kbuf_recycle(). Kill it and
tweak the code so that the legacy pbuf and ring pbuf code become clear

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/kbuf.c | 71 +++++++++++++++++++++++++++++--------------------
 io_uring/kbuf.h | 21 ++++++---------
 2 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e4ee11cd337c..4b7f2aa99e38 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -37,36 +37,30 @@ static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 	return xa_load(&ctx->io_bl_xa, bgid);
 }
 
-void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
+static int io_buffer_add_list(struct io_ring_ctx *ctx,
+			      struct io_buffer_list *bl, unsigned int bgid)
+{
+	bl->bgid = bgid;
+	if (bgid < BGID_ARRAY)
+		return 0;
+
+	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
+}
+
+void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	struct io_buffer *buf;
 
 	/*
-	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
-	 * the flag and hence ensure that bl->head doesn't get incremented.
-	 * If the tail has already been incremented, hang on to it.
+	 * For legacy provided buffer mode, don't recycle if we already did
+	 * IO to this buffer. For ring-mapped provided buffer mode, we should
+	 * increment ring->head to explicitly monopolize the buffer to avoid
+	 * multiple use.
 	 */
-	if (req->flags & REQ_F_BUFFER_RING) {
-		if (req->buf_list) {
-			if (req->flags & REQ_F_PARTIAL_IO) {
-				/*
-				 * If we end up here, then the io_uring_lock has
-				 * been kept held since we retrieved the buffer.
-				 * For the io-wq case, we already cleared
-				 * req->buf_list when the buffer was retrieved,
-				 * hence it cannot be set here for that case.
-				 */
-				req->buf_list->head++;
-				req->buf_list = NULL;
-			} else {
-				req->buf_index = req->buf_list->bgid;
-				req->flags &= ~REQ_F_BUFFER_RING;
-			}
-		}
+	if (req->flags & REQ_F_PARTIAL_IO)
 		return;
-	}
 
 	io_ring_submit_lock(ctx, issue_flags);
 
@@ -77,16 +71,35 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	req->buf_index = buf->bgid;
 
 	io_ring_submit_unlock(ctx, issue_flags);
+	return;
 }
 
-static int io_buffer_add_list(struct io_ring_ctx *ctx,
-			      struct io_buffer_list *bl, unsigned int bgid)
+void io_kbuf_recycle_ring(struct io_kiocb *req)
 {
-	bl->bgid = bgid;
-	if (bgid < BGID_ARRAY)
-		return 0;
-
-	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
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
+	return;
 }
 
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 5da3d4039aed..b5a89ffadf31 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -35,7 +35,6 @@ struct io_buffer {
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 			      unsigned int issue_flags);
-void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags);
 void io_destroy_buffers(struct io_ring_ctx *ctx);
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
@@ -49,6 +48,9 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
+void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
+void io_kbuf_recycle_ring(struct io_kiocb *req);
+
 static inline bool io_do_buffer_select(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
@@ -58,18 +60,11 @@ static inline bool io_do_buffer_select(struct io_kiocb *req)
 
 static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
-	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
-		return;
-	/*
-	 * For legacy provided buffer mode, don't recycle if we already did
-	 * IO to this buffer. For ring-mapped provided buffer mode, we should
-	 * increment ring->head to explicitly monopolize the buffer to avoid
-	 * multiple use.
-	 */
-	if ((req->flags & REQ_F_BUFFER_SELECTED) &&
-	    (req->flags & REQ_F_PARTIAL_IO))
-		return;
-	__io_kbuf_recycle(req, issue_flags);
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		io_kbuf_recycle_legacy(req, issue_flags);
+
+	if (req->flags & REQ_F_BUFFER_RING)
+		io_kbuf_recycle_ring(req);
 }
 
 static inline unsigned int __io_put_kbuf_list(struct io_kiocb *req,
-- 
2.25.1

