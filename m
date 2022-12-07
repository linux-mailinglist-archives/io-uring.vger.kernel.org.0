Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E2B6452B5
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLGDyi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLGDyi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:38 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E874E686
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:37 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id l11so23200084edb.4
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuK6PNjfl60GoY8hn5Dn5BqgQFQV7WXHDnH07XnDKew=;
        b=ZKZA7HD1Zpb8OblH8aWwufWc62/YCeWnwp1oMmCuB+Of+sj00ry1ljhNa8UjVwQ9Tn
         CqbF8N4U0FosEmvZBoQOtr9tjuSomOytA9QqSvY2vfYRu3EjURT+ulFnhdwBkBuF2X+8
         naPB3tbGPNyVXiwOn3c+qIpT6e+U5KMduDknjGxxyqTgwBy1kYaSWW1x7kOpDN2bYvwW
         uXOFTVPr0Q6TL+Bzx39zGvGLX2ZlF27mA5aao0P/SX+nWXCys2LBv1rD2EMVOfBBGAbr
         q4Z+Mc+xsRyjG7Lb6cGy8QCmu7CV2sR5Cu2yJIfyG6bN2rZDs1oe+7HcAQygSfilKqxV
         t4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuK6PNjfl60GoY8hn5Dn5BqgQFQV7WXHDnH07XnDKew=;
        b=Mzt5F5koGXYmrrw3WvEuWWEic/LnC2vKJgaIqGFzIDdcKjfaZPHxNyG/Hp4X2fmcZh
         CS6/JcualDD27L3BnOX5zTVWtO4dHfEwj79fggcCe+O1QNTG8xCWJWMZ2O3qp1n9AcuF
         dbbo4akTHKMoPWjxeG6Krx2jNyuDAf5rS/FVy3m6jhQtw8uk1rrhWLn5qsQ86Ume1EoD
         9OYppnvLoy7DgzIDn1wizsW//1be12n5zKmjcftXyMGnftvKlUiW0vpxYeNfXb4f3AjE
         gCS2ugH155fHlDlsFyWjeJ8r8vbOT+oL/dyVYYIJNah5EErJFraUvYxVKgHdhQDBE1sM
         K94g==
X-Gm-Message-State: ANoB5pksIEdBLUrJ6vmLV2IbOTkrEs5wtZslByVPKsvS4D9bIjWgtZ/9
        KYvPL2EbZ4Gy9PVDqRkSDgrqls0QNSc=
X-Google-Smtp-Source: AA0mqf7RUjzCQalqepzweQ3OGC17kzO0TA0x/ycBgHmXQF8kXefKC4HQQDc6XQXcloiQBI/78d6jbQ==
X-Received: by 2002:a05:6402:28ac:b0:46a:b8d0:a052 with SMTP id eg44-20020a05640228ac00b0046ab8d0a052mr47551021edb.399.1670385275421;
        Tue, 06 Dec 2022 19:54:35 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 03/12] io_uring: skip overflow CQE posting for dying ring
Date:   Wed,  7 Dec 2022 03:53:28 +0000
Message-Id: <26d13751155a735a3029e24f8d9ca992f810419d.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After io_ring_ctx_wait_and_kill() is called there should be no users
poking into rings and so there is no need to post CQEs. So, instead of
trying to post overflowed CQEs into the CQ, drop them. Also, do it
in io_ring_exit_work() in a loop to reduce the number of contexts it
can be executed from and even when it struggles to quiesce the ring we
won't be leaving memory allocated for longer than needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 62372a641add..5c0b3ba6059e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -611,12 +611,30 @@ void io_cq_unlock_post(struct io_ring_ctx *ctx)
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
+static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
+{
+	struct io_overflow_cqe *ocqe;
+	LIST_HEAD(list);
+
+	io_cq_lock(ctx);
+	list_splice_init(&ctx->cq_overflow_list, &list);
+	clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
+	io_cq_unlock(ctx);
+
+	while (!list_empty(&list)) {
+		ocqe = list_first_entry(&list, struct io_overflow_cqe, list);
+		list_del(&ocqe->list);
+		kfree(ocqe);
+	}
+}
+
+/* Returns true if there are no backlogged entries after the flush */
+static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
 	bool all_flushed;
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
-	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
+	if (__io_cqring_events(ctx) == ctx->cq_entries)
 		return false;
 
 	if (ctx->flags & IORING_SETUP_CQE32)
@@ -627,15 +645,11 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
 		struct io_overflow_cqe *ocqe;
 
-		if (!cqe && !force)
+		if (!cqe)
 			break;
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
-		if (cqe)
-			memcpy(cqe, &ocqe->cqe, cqe_size);
-		else
-			io_account_cq_overflow(ctx);
-
+		memcpy(cqe, &ocqe->cqe, cqe_size);
 		list_del(&ocqe->list);
 		kfree(ocqe);
 	}
@@ -658,7 +672,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx, false);
+		ret = __io_cqring_overflow_flush(ctx);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
@@ -1478,7 +1492,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	check_cq = READ_ONCE(ctx->check_cq);
 	if (unlikely(check_cq)) {
 		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-			__io_cqring_overflow_flush(ctx, false);
+			__io_cqring_overflow_flush(ctx);
 		/*
 		 * Similarly do not spin if we have not informed the user of any
 		 * dropped CQE.
@@ -2646,8 +2660,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		__io_sqe_buffers_unregister(ctx);
 	if (ctx->file_data)
 		__io_sqe_files_unregister(ctx);
-	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true);
+	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
@@ -2788,6 +2801,12 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
+		if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
+			mutex_lock(&ctx->uring_lock);
+			io_cqring_overflow_kill(ctx);
+			mutex_unlock(&ctx->uring_lock);
+		}
+
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
 
@@ -2853,8 +2872,6 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
-	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
 	if (ctx->rings)
-- 
2.38.1

