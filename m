Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EE64DD121
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 00:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiCQXYX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Mar 2022 19:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiCQXYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Mar 2022 19:24:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF7D15A26
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 16:23:02 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s8so8036551pfk.12
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 16:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=ew+DU7zowQPtPXLVufJsfbEOUGIKb3eqejp7+5F7q5A=;
        b=lCgpBcEFUyuacain7be3qABRSG4s9JCsl6HWubD+YrEe4WMfSLws96FLhVjEcxTmTp
         VKLsTIf1inEmV1RfJs5oWb5FyRIe/6j0Q1EY60ruj7vEpFcRsontoUl/oLkMNlk9bhxP
         o/rCnIC2U/8MOfzWXQGRo9anp8m122SrqIIXtJjK53zcrw3B0UAkx9jQmKYKR6oDttoL
         ea8gnK/bot9GOaMjB3NhOV0MhJn9o2xEdmJeAYnM8wwwNxZc6YohOg/xC3F79jQKiLKY
         wIXbfuBZP1T/Hb9xZkIbp8M0Bb2C+xVZhVBcZlai8xZjG0MFjlBlOpDanfwXj8AHREn4
         h73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=ew+DU7zowQPtPXLVufJsfbEOUGIKb3eqejp7+5F7q5A=;
        b=Lnq7lqn5cZeTwLRxtSKng5dZmAOQzK/9ilkKiwZ9oPxyo3MrRahZ/E9NMKh5A3RFjU
         HV0G26BPponsYSs9rGTrqZBdiG+ejGo+b0g4WuGteOOsGMQu0Trjlb8R9aSdOSdZJujK
         s8umugVNoCqjktoMapCIQ/a6xZO648PwOZcTA+rYCP+DWXdI8NPv335govCbvsAh2pnH
         WmrBG2Sc7FFeKuZOAsxbwpaS/2JzmoUy70EOyXi5J5pJfmBVsHDFQZ22WLeeziliV2lD
         EJ05IlPYYcmWJBOho2SK3gDN2lS6FEUoz9+7gzsNbnwkegonsXP5+nBazr3nLK51DMTB
         EBlA==
X-Gm-Message-State: AOAM532/8/rmTP3mjc+eHE4zOFZWvOXEU5RTIUobPtWmMxxww4NXf8bZ
        +LZd9sFlDN6peWpvG2wEHXdrBUrB+ynuBUet
X-Google-Smtp-Source: ABdhPJxodKn3bc0tMUl5rT9SOG6aByFruDkrx/vKkUCDlqY001hhnIx2PciTR3IaCa5DEV9r5lxeRg==
X-Received: by 2002:a63:78cd:0:b0:376:46c:6585 with SMTP id t196-20020a6378cd000000b00376046c6585mr5716048pgc.313.1647559381640;
        Thu, 17 Mar 2022 16:23:01 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v4-20020a056a00148400b004f9eaf80107sm8299076pfu.203.2022.03.17.16.23.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 16:23:01 -0700 (PDT)
Message-ID: <d538f0b7-b427-b07a-db18-2cba0778ff5f@kernel.dk>
Date:   Thu, 17 Mar 2022 17:23:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: manage provided buffers strictly ordered
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Workloads using provided buffers benefit from using and returning buffers
in the right order, and so does TLBs for that matter. Manage the internal
buffer list in a straight list, rather than use the head buffer as the
insertion node. Use a hashed list for the buffer group IDs instead of
xarray, the overhead is much lower this way. xarray provides internal
locking and other trickery that is handy for some uses cases, but
io_uring already locks internally for the buffer manipulation and needs
none of that.

This is good for about a 2% reduction in overhead, combination of the
improved management and the fact that the workload has an easier time
bundling back provided buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68498cebc0ef..690bfeaa609a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -264,6 +264,12 @@ struct io_rsrc_data {
 	bool				quiesce;
 };
 
+struct io_buffer_list {
+	struct list_head list;
+	struct list_head buf_list;
+	__u16 bgid;
+};
+
 struct io_buffer {
 	struct list_head list;
 	__u64 addr;
@@ -334,6 +340,8 @@ struct io_ev_fd {
 	struct rcu_head		rcu;
 };
 
+#define IO_BUFFERS_HASH_BITS	5
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -386,7 +394,7 @@ struct io_ring_ctx {
 		struct list_head	timeout_list;
 		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
-		struct xarray		io_buffers;
+		struct list_head	*io_buffers;
 		struct list_head	io_buffers_cache;
 		struct list_head	apoll_cache;
 		struct xarray		personalities;
@@ -1361,10 +1369,25 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 	return cflags;
 }
 
+static struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
+						 unsigned int bgid)
+{
+	struct list_head *hash_list;
+	struct io_buffer_list *bl;
+
+	hash_list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
+	list_for_each_entry(bl, hash_list, list)
+		if (bl->bgid == bgid || bgid == -1U)
+			return bl;
+
+	return NULL;
+}
+
 static void io_kbuf_recycle(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer *head, *buf;
+	struct io_buffer_list *bl;
+	struct io_buffer *buf;
 
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return;
@@ -1372,21 +1395,8 @@ static void io_kbuf_recycle(struct io_kiocb *req)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	buf = req->kbuf;
-
-	head = xa_load(&ctx->io_buffers, buf->bgid);
-	if (head) {
-		list_add(&buf->list, &head->list);
-	} else {
-		int ret;
-
-		INIT_LIST_HEAD(&buf->list);
-
-		/* if we fail, just leave buffer attached */
-		ret = xa_insert(&ctx->io_buffers, buf->bgid, buf, GFP_KERNEL);
-		if (unlikely(ret < 0))
-			return;
-	}
-
+	bl = io_buffer_get_list(ctx, buf->bgid);
+	list_add(&buf->list, &bl->buf_list);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	req->kbuf = NULL;
 }
@@ -1501,7 +1511,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
-	int hash_bits;
+	int i, hash_bits;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -1528,6 +1538,13 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	/* set invalid range, so io_import_fixed() fails meeting it */
 	ctx->dummy_ubuf->ubuf = -1UL;
 
+	ctx->io_buffers = kcalloc(1U << IO_BUFFERS_HASH_BITS,
+					sizeof(struct list_head), GFP_KERNEL);
+	if (!ctx->io_buffers)
+		goto err;
+	for (i = 0; i < (1U << IO_BUFFERS_HASH_BITS); i++)
+		INIT_LIST_HEAD(&ctx->io_buffers[i]);
+
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		goto err;
@@ -1539,7 +1556,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	INIT_LIST_HEAD(&ctx->apoll_cache);
 	init_completion(&ctx->ref_comp);
-	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
@@ -1568,6 +1584,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 err:
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->cancel_hash);
+	kfree(ctx->io_buffers);
 	kfree(ctx);
 	return NULL;
 }
@@ -3351,30 +3368,36 @@ static void io_ring_submit_lock(struct io_ring_ctx *ctx, bool needs_lock)
 		mutex_lock(&ctx->uring_lock);
 }
 
+static void io_buffer_add_list(struct io_ring_ctx *ctx,
+			       struct io_buffer_list *bl, unsigned int bgid)
+{
+	struct list_head *list;
+
+	list = &ctx->io_buffers[hash_32(bgid, IO_BUFFERS_HASH_BITS)];
+	INIT_LIST_HEAD(&bl->buf_list);
+	bl->bgid = bgid;
+	list_add(&bl->list, list);
+}
+
 static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 					  int bgid, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf = req->kbuf;
-	struct io_buffer *head;
 	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return kbuf;
 
-	io_ring_submit_lock(req->ctx, needs_lock);
+	io_ring_submit_lock(ctx, needs_lock);
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	lockdep_assert_held(&ctx->uring_lock);
 
-	head = xa_load(&req->ctx->io_buffers, bgid);
-	if (head) {
-		if (!list_empty(&head->list)) {
-			kbuf = list_last_entry(&head->list, struct io_buffer,
-							list);
-			list_del(&kbuf->list);
-		} else {
-			kbuf = head;
-			xa_erase(&req->ctx->io_buffers, bgid);
-		}
+	bl = io_buffer_get_list(ctx, bgid);
+	if (bl && !list_empty(&bl->buf_list)) {
+		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
+		list_del(&kbuf->list);
 		if (*len > kbuf->len)
 			*len = kbuf->len;
 		req->flags |= REQ_F_BUFFER_SELECTED;
@@ -4669,8 +4692,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
-			       int bgid, unsigned nbufs)
+static int __io_remove_buffers(struct io_ring_ctx *ctx,
+			       struct io_buffer_list *bl, unsigned nbufs)
 {
 	unsigned i = 0;
 
@@ -4679,17 +4702,16 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 		return 0;
 
 	/* the head kbuf is the list itself */
-	while (!list_empty(&buf->list)) {
+	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
-		nxt = list_first_entry(&buf->list, struct io_buffer, list);
+		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&nxt->list);
 		if (++i == nbufs)
 			return i;
 		cond_resched();
 	}
 	i++;
-	xa_erase(&ctx->io_buffers, bgid);
 
 	return i;
 }
@@ -4698,7 +4720,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer *head;
+	struct io_buffer_list *bl;
 	int ret = 0;
 	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
@@ -4707,9 +4729,9 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	ret = -ENOENT;
-	head = xa_load(&ctx->io_buffers, p->bgid);
-	if (head)
-		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
+	bl = io_buffer_get_list(ctx, p->bgid);
+	if (bl)
+		ret = __io_remove_buffers(ctx, bl, p->nbufs);
 	if (ret < 0)
 		req_set_fail(req);
 
@@ -4798,7 +4820,7 @@ static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
 }
 
 static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
-			  struct io_buffer **head)
+			  struct io_buffer_list *bl)
 {
 	struct io_buffer *buf;
 	u64 addr = pbuf->addr;
@@ -4810,30 +4832,24 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 			break;
 		buf = list_first_entry(&ctx->io_buffers_cache, struct io_buffer,
 					list);
-		list_del(&buf->list);
+		list_move_tail(&buf->list, &bl->buf_list);
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
 		buf->bgid = pbuf->bgid;
 		addr += pbuf->len;
 		bid++;
-		if (!*head) {
-			INIT_LIST_HEAD(&buf->list);
-			*head = buf;
-		} else {
-			list_add_tail(&buf->list, &(*head)->list);
-		}
 		cond_resched();
 	}
 
-	return i ? i : -ENOMEM;
+	return i ? 0 : -ENOMEM;
 }
 
 static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer *head, *list;
+	struct io_buffer_list *bl;
 	int ret = 0;
 	bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
@@ -4841,14 +4857,18 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	list = head = xa_load(&ctx->io_buffers, p->bgid);
-
-	ret = io_add_buffers(ctx, p, &head);
-	if (ret >= 0 && !list) {
-		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
-		if (ret < 0)
-			__io_remove_buffers(ctx, head, p->bgid, -1U);
+	bl = io_buffer_get_list(ctx, p->bgid);
+	if (unlikely(!bl)) {
+		bl = kmalloc(sizeof(*bl), GFP_KERNEL);
+		if (!bl) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		io_buffer_add_list(ctx, bl, p->bgid);
 	}
+
+	ret = io_add_buffers(ctx, p, bl);
+err:
 	if (ret < 0)
 		req_set_fail(req);
 	/* complete before unlock, IOPOLL may need the lock */
@@ -9936,11 +9956,20 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
-	struct io_buffer *buf;
-	unsigned long index;
+	int i;
+
+	for (i = 0; i < (1U << IO_BUFFERS_HASH_BITS); i++) {
+		struct list_head *list = &ctx->io_buffers[i];
 
-	xa_for_each(&ctx->io_buffers, index, buf)
-		__io_remove_buffers(ctx, buf, index, -1U);
+		while (!list_empty(list)) {
+			struct io_buffer_list *bl;
+
+			bl = list_first_entry(list, struct io_buffer_list, list);
+			__io_remove_buffers(ctx, bl, -1U);
+			list_del(&bl->list);
+			kfree(bl);
+		}
+	}
 
 	while (!list_empty(&ctx->io_buffers_pages)) {
 		struct page *page;
@@ -10049,6 +10078,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_free_napi_list(ctx);
 	kfree(ctx->cancel_hash);
 	kfree(ctx->dummy_ubuf);
+	kfree(ctx->io_buffers);
 	kfree(ctx);
 }
 
-- 
Jens Axboe

