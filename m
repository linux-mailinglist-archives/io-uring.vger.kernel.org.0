Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29434505C98
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 18:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346389AbiDRQq5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 12:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346363AbiDRQqv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 12:46:51 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFC53298C
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:11 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id y85so5210884iof.3
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qK5/oe31XB4fYPhewKSxsND7CwbNHiuhBCq7ASwWnKo=;
        b=WbCSBY0vCbMzWvH8bHJ50VoSnekaFHA4CuXuPB0QjZE3mhIrfkIdH2ta4D39yT8jIj
         BI6BhOUA3NfcklHyOX/bP+ZGU2UT+Yti0JZ83KNBHMluW3dJMFpAOx86lIlas1AQsvc2
         QogTUO4iwut7Czm6CJFZDGKkW1IlVf3WuSvm6P8+GVOd4Jzg0XjAeZB3cE7FTvCaTfL+
         nCSMoQMmDIgww47oOq6tACP2n2KMSS7sDXE5FBLSrbG46a+d6ah6IZrrfKpcRgkyhN/a
         onAAqb3xFfklQVehkpYPyczQPtX+Y5qXaVJHvFBtZXOPYKRu9XezUPfDLKH7ZGSobfIt
         hQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qK5/oe31XB4fYPhewKSxsND7CwbNHiuhBCq7ASwWnKo=;
        b=mib7odPFGbtGL8lsXMicDB17F3m5WE+uELyzfCTkiOS/92/XIFcI4m3Ve6ZxuAIIFz
         gru+MSa9C8al16NDBeXqnW8lSx+RR1wjvgAncJsb/yySbkmKDV4n21n5Rp8dvZ/i7zdt
         dh5bnYw2zhruP/4ObY/imVMWkS+HOy+57iaVhdBiC//BeSqLuZTE5nRX5h5z4fgbcuK7
         tsL6/lHlFaw5PyZJ2ysUNLz1nHgDwuCMFiLeNNfqtfBayJ9ytv5SLqXpcSjjWRiyvrk6
         DXpz/9XaDF+gST2BeRQRxlb7qoMD9OjMsBPw9ksoyHy5BdGI9ILyRqI6jHZf08XVs78G
         /KTA==
X-Gm-Message-State: AOAM530lChTw8b4FXixjYHvldUSWBPZg52QqPjOLweC7gn0tDDvZwxFe
        X+pf5iuttMOUheB/iTDmWSpAuse8jQqajA==
X-Google-Smtp-Source: ABdhPJzJkdkOgM5rm5FqMGhyERpGhX7csuL5YVkg9Pk1ZTJt3Lc74C+jg9lV8C2Mw0CuztXceqseSg==
X-Received: by 2002:a02:b388:0:b0:326:6217:13a1 with SMTP id p8-20020a02b388000000b00326621713a1mr5405118jan.12.1650300250116;
        Mon, 18 Apr 2022 09:44:10 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y19-20020a056e020f5300b002cc33e5997dsm1188926ilj.63.2022.04.18.09.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:44:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: add support for IORING_ASYNC_CANCEL_ANY
Date:   Mon, 18 Apr 2022 10:44:02 -0600
Message-Id: <20220418164402.75259-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418164402.75259-1-axboe@kernel.dk>
References: <20220418164402.75259-1-axboe@kernel.dk>
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

Rather than match on a specific key, be it user_data or file, allow
canceling any request that we can lookup. Works like
IORING_ASYNC_CANCEL_ALL in that it cancels multiple requests, but it
doesn't key off user_data or the file.

Can't be set with IORING_ASYNC_CANCEL_FD, as that's a key selector.
Only one may be used at the time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 39 ++++++++++++++++++++++-------------
 include/uapi/linux/io_uring.h |  2 ++
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70050c94560e..e537b0bf4422 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6304,7 +6304,8 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry(req, list, hash_node) {
-			if (req->file != cd->file)
+			if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
+			    req->file != cd->file)
 				continue;
 			if (cd->seq == req->work.cancel_seq)
 				continue;
@@ -6330,7 +6331,7 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
 	struct io_kiocb *req;
 
-	if (cd->flags & IORING_ASYNC_CANCEL_FD)
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
 		req = io_poll_file_find(ctx, cd);
 	else
 		req = io_poll_find(ctx, false, cd);
@@ -6499,9 +6500,10 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	bool found = false;
 
 	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
-		if (cd->data != req->cqe.user_data)
+		if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
+		    cd->data != req->cqe.user_data)
 			continue;
-		if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
+		if (cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY)) {
 			if (cd->seq == req->work.cancel_seq)
 				continue;
 			req->work.cancel_seq = cd->seq;
@@ -6782,14 +6784,16 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 
 	if (req->ctx != cd->ctx)
 		return false;
-	if (cd->flags & IORING_ASYNC_CANCEL_FD) {
+	if (cd->flags & IORING_ASYNC_CANCEL_ANY) {
+		;
+	} else if (cd->flags & IORING_ASYNC_CANCEL_FD) {
 		if (req->file != cd->file)
 			return false;
 	} else {
 		if (req->cqe.user_data != cd->data)
 			return false;
 	}
-	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
+	if (cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY)) {
 		if (cd->seq == req->work.cancel_seq)
 			return false;
 		req->work.cancel_seq = cd->seq;
@@ -6802,12 +6806,13 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 {
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
+	bool all;
 
 	if (!tctx || !tctx->io_wq)
 		return -ENOENT;
 
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd,
-					cd->flags & IORING_ASYNC_CANCEL_ALL);
+	all = cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY);
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd, all);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -6853,6 +6858,9 @@ static int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 	return ret;
 }
 
+#define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
+			 IORING_ASYNC_CANCEL_ANY)
+
 static int io_async_cancel_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
@@ -6865,10 +6873,13 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
 	req->cancel.flags = READ_ONCE(sqe->cancel_flags);
-	if (req->cancel.flags & ~(IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_FD))
+	if (req->cancel.flags & ~CANCEL_FLAGS)
 		return -EINVAL;
-	if (req->cancel.flags & IORING_ASYNC_CANCEL_FD)
+	if (req->cancel.flags & IORING_ASYNC_CANCEL_FD) {
+		if (req->cancel.flags & IORING_ASYNC_CANCEL_ANY)
+			return -EINVAL;
 		req->cancel.fd = READ_ONCE(sqe->fd);
+	}
 
 	return 0;
 }
@@ -6876,7 +6887,7 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
 			     unsigned int issue_flags)
 {
-	bool cancel_all = cd->flags & IORING_ASYNC_CANCEL_ALL;
+	bool all = cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY);
 	struct io_ring_ctx *ctx = cd->ctx;
 	struct io_tctx_node *node;
 	int ret, nr = 0;
@@ -6885,7 +6896,7 @@ static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
 		ret = io_try_cancel(req, cd);
 		if (ret == -ENOENT)
 			break;
-		if (!cancel_all)
+		if (!all)
 			return ret;
 		nr++;
 	} while (1);
@@ -6898,13 +6909,13 @@ static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
 
 		ret = io_async_cancel_one(tctx, cd);
 		if (ret != -ENOENT) {
-			if (!cancel_all)
+			if (!all)
 				break;
 			nr++;
 		}
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
-	return cancel_all ? nr : ret;
+	return all ? nr : ret;
 }
 
 static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cc7fe82a1798..980d82eb196e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -193,9 +193,11 @@ enum {
  * IORING_ASYNC_CANCEL_ALL	Cancel all requests that match the given key
  * IORING_ASYNC_CANCEL_FD	Key off 'fd' for cancelation rather than the
  *				request 'user_data'
+ * IORING_ASYNC_CANCEL_ANY	Match any request
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
+#define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 
 /*
  * IO completion data structure (Completion Queue Entry)
-- 
2.35.1

