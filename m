Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7538B41928C
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 12:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhI0KxR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 06:53:17 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:49761 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233878AbhI0KxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 06:53:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Upn7J34_1632739883;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Upn7J34_1632739883)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 18:51:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 6/8] io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
Date:   Mon, 27 Sep 2021 18:51:21 +0800
Message-Id: <20210927105123.169301-7-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927105123.169301-1-haoxu@linux.alibaba.com>
References: <20210927105123.169301-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move them up to avoid explicit declaration. We will use them in later
patches.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91bb4a7bb84a..7f7b77a458d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2134,6 +2134,27 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
 
+static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
+{
+	unsigned int cflags;
+
+	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+	cflags |= IORING_CQE_F_BUFFER;
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	kfree(kbuf);
+	return cflags;
+}
+
+static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
+{
+	struct io_buffer *kbuf;
+
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return 0;
+	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+	return io_put_kbuf(req, kbuf);
+}
+
 static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
 {
 	do {
@@ -2423,27 +2444,6 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
 }
 
-static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
-{
-	unsigned int cflags;
-
-	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
-	cflags |= IORING_CQE_F_BUFFER;
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	kfree(kbuf);
-	return cflags;
-}
-
-static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
-{
-	struct io_buffer *kbuf;
-
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
-		return 0;
-	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
-	return io_put_kbuf(req, kbuf);
-}
-
 static inline bool io_run_task_work(void)
 {
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
-- 
2.24.4

