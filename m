Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904145167E9
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354864AbiEAVAc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354837AbiEAVAb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:31 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A173A26111
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:04 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a11so10952715pff.1
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AAcuiuj+q7FZ4WgI6F1wMSAZB4bWzRtcM9GdpIf2qv8=;
        b=YlikD5eN5E87uH9kzQaPyYhSEJtJnfIy3dmrx1mNHa7hJfFPfb7HnqVjF+uNGcTr1U
         iq+OJo4IJZt6/LPUAXOH2082NRD9K10PMZUX6Tq+Qde/XDJy0PTziRuhMCDSFbZTUbuO
         VHEg/11u+/1aaRrbmhkhWleMkM8pXOoiHu6wjzr7PQ8SDbSLH6YA31gHAPpdSeUtoWXE
         77PuOjGQSw6iYeuRvWm6BAsZ67/BAe/aoyVAd6DbxcEWOFZWc4c/uZz9iTs7h4LbWwRv
         8cO/AZs9fQGkErpPbdWbOQenPIkGffr9QxOhXJd433uGzmKYhfKOVOwyUtrnLfz0xGuM
         6tYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AAcuiuj+q7FZ4WgI6F1wMSAZB4bWzRtcM9GdpIf2qv8=;
        b=kppRNhSroG1RxtDJZBPZB9lkqQNjJKlRScbfBYOqtet41AQj1a4tIaLaGqibrKeZPy
         m57b3CSjUMoqbYc3F3i9UuTwBA3I4rWgzruqDslBef5pAhLf9eUqVf0kszRgtzFrI7w5
         IfM7CIgbYw/4m14BOO30hcwGIjPkm1Ly0efHkWmMZwcyjSuu1sf9rIC3ZqXHRBFynI3e
         btNqPHUUikShwQLZoFQATZUwZdL2xvggDkIZDi6Z/OusTaN2hLCFpfGeXB/d3JYwd6VM
         T7kTkTBuk6OsrA5YUbzzxzc5vMgecF8hW36AKvAR02/f3aGhRU61hGTPh9ZeYCsvndXi
         Jxew==
X-Gm-Message-State: AOAM531wX8uNXPGjO4EIr1Oi5BEUcaz/IplPyigyYDU9zIZRXM0iPYeN
        HgUP8FAgA50btlnbSBL3DNH+gWEyxMbsRQ==
X-Google-Smtp-Source: ABdhPJxXqOA4uiYd51FY0cencEVLXfcN+hw04lbgETChFygLnT6qGTtxHlNT+z7UsE/+nuC/Qqabrg==
X-Received: by 2002:a63:224f:0:b0:399:4a1a:b01f with SMTP id t15-20020a63224f000000b003994a1ab01fmr7332307pgm.123.1651438623766;
        Sun, 01 May 2022 13:57:03 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/16] io_uring: get rid of hashed provided buffer groups
Date:   Sun,  1 May 2022 14:56:44 -0600
Message-Id: <20220501205653.15775-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
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

Use a plain array for any group ID that's less than 64, and punt
anything beyond that to an xarray. 64 fits in a page even for 4KB
page sizes and with the planned additions.

This makes the expected group usage faster by avoiding a hash and lookup
to find our list, and it uses less memory upfront by not allocating any
memory for provided buffers unless it's actually being used.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 97 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 39 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eba18685a705..7efe2de5ce81 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -283,7 +283,6 @@ struct io_rsrc_data {
 };
 
 struct io_buffer_list {
-	struct list_head list;
 	struct list_head buf_list;
 	__u16 bgid;
 };
@@ -358,7 +357,7 @@ struct io_ev_fd {
 	struct rcu_head		rcu;
 };
 
-#define IO_BUFFERS_HASH_BITS	5
+#define BGID_ARRAY	64
 
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
@@ -414,7 +413,8 @@ struct io_ring_ctx {
 		struct list_head	timeout_list;
 		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
-		struct list_head	*io_buffers;
+		struct io_buffer_list	*io_bl;
+		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
 		struct list_head	apoll_cache;
 		struct xarray		personalities;
@@ -1613,15 +1613,10 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 						 unsigned int bgid)
 {
-	struct list_head *hash_list;
-	struct io_buffer_list *bl;
-
-	hash_list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
-	list_for_each_entry(bl, hash_list, list)
-		if (bl->bgid == bgid || bgid == -1U)
-			return bl;
+	if (ctx->io_bl && bgid < BGID_ARRAY)
+		return &ctx->io_bl[bgid];
 
-	return NULL;
+	return xa_load(&ctx->io_bl_xa, bgid);
 }
 
 static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
@@ -1727,12 +1722,14 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
-	int i, hash_bits;
+	int hash_bits;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return NULL;
 
+	xa_init(&ctx->io_bl_xa);
+
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
 	 * 32 entries per hash list if totally full and uniformly spread.
@@ -1754,13 +1751,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	/* set invalid range, so io_import_fixed() fails meeting it */
 	ctx->dummy_ubuf->ubuf = -1UL;
 
-	ctx->io_buffers = kcalloc(1U << IO_BUFFERS_HASH_BITS,
-					sizeof(struct list_head), GFP_KERNEL);
-	if (!ctx->io_buffers)
-		goto err;
-	for (i = 0; i < (1U << IO_BUFFERS_HASH_BITS); i++)
-		INIT_LIST_HEAD(&ctx->io_buffers[i]);
-
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		goto err;
@@ -1796,7 +1786,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 err:
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->cancel_hash);
-	kfree(ctx->io_buffers);
+	kfree(ctx->io_bl);
+	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
 }
@@ -3560,15 +3551,14 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
 	return __io_import_fixed(req, rw, iter, imu);
 }
 
-static void io_buffer_add_list(struct io_ring_ctx *ctx,
-			       struct io_buffer_list *bl, unsigned int bgid)
+static int io_buffer_add_list(struct io_ring_ctx *ctx,
+			      struct io_buffer_list *bl, unsigned int bgid)
 {
-	struct list_head *list;
-
-	list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
-	INIT_LIST_HEAD(&bl->buf_list);
 	bl->bgid = bgid;
-	list_add(&bl->list, list);
+	if (bgid < BGID_ARRAY)
+		return 0;
+
+	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
@@ -5318,6 +5308,23 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 	return i ? 0 : -ENOMEM;
 }
 
+static __cold int io_init_bl_list(struct io_ring_ctx *ctx)
+{
+	int i;
+
+	ctx->io_bl = kcalloc(BGID_ARRAY, sizeof(struct io_buffer_list),
+				GFP_KERNEL);
+	if (!ctx->io_bl)
+		return -ENOMEM;
+
+	for (i = 0; i < BGID_ARRAY; i++) {
+		INIT_LIST_HEAD(&ctx->io_bl[i].buf_list);
+		ctx->io_bl[i].bgid = i;
+	}
+
+	return 0;
+}
+
 static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_provide_buf *p = &req->pbuf;
@@ -5327,6 +5334,12 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_ring_submit_lock(ctx, issue_flags);
 
+	if (unlikely(p->bgid < BGID_ARRAY && !ctx->io_bl)) {
+		ret = io_init_bl_list(ctx);
+		if (ret)
+			goto err;
+	}
+
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
 		bl = kmalloc(sizeof(*bl), GFP_KERNEL);
@@ -5334,7 +5347,11 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -ENOMEM;
 			goto err;
 		}
-		io_buffer_add_list(ctx, bl, p->bgid);
+		ret = io_buffer_add_list(ctx, bl, p->bgid);
+		if (ret) {
+			kfree(bl);
+			goto err;
+		}
 	}
 
 	ret = io_add_buffers(ctx, p, bl);
@@ -10437,19 +10454,19 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
+	struct io_buffer_list *bl;
+	unsigned long index;
 	int i;
 
-	for (i = 0; i < (1U << IO_BUFFERS_HASH_BITS); i++) {
-		struct list_head *list = &ctx->io_buffers[i];
-
-		while (!list_empty(list)) {
-			struct io_buffer_list *bl;
+	for (i = 0; i < BGID_ARRAY; i++) {
+		if (!ctx->io_bl)
+			break;
+		__io_remove_buffers(ctx, &ctx->io_bl[i], -1U);
+	}
 
-			bl = list_first_entry(list, struct io_buffer_list, list);
-			__io_remove_buffers(ctx, bl, -1U);
-			list_del(&bl->list);
-			kfree(bl);
-		}
+	xa_for_each(&ctx->io_bl_xa, index, bl) {
+		xa_erase(&ctx->io_bl_xa, bl->bgid);
+		__io_remove_buffers(ctx, bl, -1U);
 	}
 
 	while (!list_empty(&ctx->io_buffers_pages)) {
@@ -10558,7 +10575,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_hash);
 	kfree(ctx->dummy_ubuf);
-	kfree(ctx->io_buffers);
+	kfree(ctx->io_bl);
+	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 }
 
@@ -12467,6 +12485,7 @@ static int __init io_uring_init(void)
 
 	/* ->buf_index is u16 */
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
+	BUILD_BUG_ON(BGID_ARRAY * sizeof(struct io_buffer_list) > PAGE_SIZE);
 
 	/* should fit into one byte */
 	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
-- 
2.35.1

