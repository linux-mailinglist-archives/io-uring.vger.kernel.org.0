Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A816557C6B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiFWNBl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 09:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbiFWNBk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 09:01:40 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F854D624
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 06:01:36 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655989294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qWcBne5XvgRAPXabSwBFa18/FIhGM7wpYwOWuzhdeOY=;
        b=TGTv3SUcQO0DU0gAThSS7e1Ue5xrRLslGClatbWBnqcCkXZOwin7soLbRbouHpc+Nll0fy
        8MC4QTZNylRsas1kE1Y81DQhxmDNCegiSG/j3/JAzY4Q3d4cnM/bpThRvEGznHUPEDiv9A
        p5Yu1HKBfpGsSR7coEbjUrM1qWnE19U=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2] io_uring: kbuf: inline io_kbuf_recycle_ring()
Date:   Thu, 23 Jun 2022 21:01:26 +0800
Message-Id: <20220623130126.179232-1-hao.xu@linux.dev>
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

Make io_kbuf_recycle_ring() inline since it is the fast path of
provided buffer.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/kbuf.c | 28 ----------------------------
 io_uring/kbuf.h | 28 +++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 4b7f2aa99e38..8e4f1e8aaf4a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -74,34 +74,6 @@ void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	return;
 }
 
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
index b5a89ffadf31..3d48f1ab5439 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -49,7 +49,33 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 unsigned int __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
 void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
-void io_kbuf_recycle_ring(struct io_kiocb *req);
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
 
 static inline bool io_do_buffer_select(struct io_kiocb *req)
 {

base-commit: 5ec69c3a15ae6e904d76545d9a9c686eb758def0
-- 
2.25.1

