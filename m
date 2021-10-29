Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6385443FC47
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 14:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhJ2M0I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 08:26:08 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:57961 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhJ2M0H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 08:26:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uu9pzWg_1635510157;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uu9pzWg_1635510157)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 20:22:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5/6] io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
Date:   Fri, 29 Oct 2021 20:22:36 +0800
Message-Id: <20211029122237.164312-6-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211029122237.164312-1-haoxu@linux.alibaba.com>
References: <20211029122237.164312-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move them up to avoid explicit declaration. We will use them in later
patches.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 52f95db3cfdb..694195c086f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2148,6 +2148,24 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
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
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return 0;
+	return io_put_kbuf(req, req->kbuf);
+}
+
 static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
 {
 	do {
@@ -2417,24 +2435,6 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
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
-	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
-		return 0;
-	return io_put_kbuf(req, req->kbuf);
-}
-
 static inline bool io_run_task_work(void)
 {
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
-- 
2.24.4

