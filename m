Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EA036D70C
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 14:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhD1MM0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 08:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhD1MMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 08:12:25 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E843EC061574
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 05:11:40 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x7so62741442wrw.10
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 05:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OgqNKHz8cApoWHdoNbal6CUGWuS3XtIKiLVV+Qua8u8=;
        b=QD+3L1f97riEDVlHf1wpqBgC+IXgwccYmSOFJYjF8Qy4xWWR1BCH1L/zMIcpJXWgIy
         ALj5DmZA9pB5NtzoKsQOYFybjRLEn38qN3ymLEZ5HFyQ29Sbs0vtBCgwjV9SsHCfBlbV
         aj1LRULyCQj8VsgEEsSUDbcctsOjTF8rM1N/4vn5V6t0J/ejHdGMsZK9g++H0A6QGoeF
         dopBEjjUDkskf7+NSj7EAfL4AWKX+Y08hTjN8gHC6Z6NERgq/z7FVPqlXdBrteZTXZCb
         ZkSfyVMmq6BcRx5LUfMGKgSf+mbZE/2LjoPvBPxv2AP1ebpTlEajSW11thB6/iGclfSb
         k3Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OgqNKHz8cApoWHdoNbal6CUGWuS3XtIKiLVV+Qua8u8=;
        b=VtHRXSOg8HEbMcRE24btIvBjvhoLlQUYoLLjKdpcMHbo1mxUhgTjJy6BpZMPnSEWWF
         ZEOSj6LplS5xoPhkT2WlS1Pl5+C+LhNWWJgXLWz0eP8ay0RsfC2wFM8y5RpON/619lzS
         Xeke9BJSh/JiAbfmp/jxGVZzcrehghfi3RCL8gYEvVXUuROUwSWZe7GNxNDbzQ35Y5Kj
         nhjDmDfTjFquSW+cbggw/+bNZNLpMjtEswo5O40CmkbHuZ52rSudjPwZpJbUBhuzVAWj
         VjhcNuGgqVxtCVhJfTAgXvGNnrh7VtHlTKJElAtcyQAEgJJZXpWMaXm+qHR65LA5UUZh
         v6WA==
X-Gm-Message-State: AOAM531bn2k/osy1Iym3ovcXo+nRHVUP50jqcgdHmKClmtmAaABBl0iz
        3ryYXWlt0Ge/LkavOj2lBUs/9KuKNPE=
X-Google-Smtp-Source: ABdhPJy9OoOdd/qu+CLzv9gMqsr+sbRQpH8so+tX/4u/xnZPdXlvU83zWFeFHnK5Nh6VUa9iEZ47fA==
X-Received: by 2002:a05:6000:136b:: with SMTP id q11mr14281702wrz.350.1619611899671;
        Wed, 28 Apr 2021 05:11:39 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id t14sm7876514wrz.55.2021.04.28.05.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:11:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: allow empty slots for reg buffers
Date:   Wed, 28 Apr 2021 13:11:29 +0100
Message-Id: <7e95e4d700082baaf010c648c72ac764c9cc8826.1619611868.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow empty reg buffer slots any request using which should fail. This
allows users to not register all buffers in advance, but do it lazily
and/or on demand via updates. That is achieved by setting iov_base and
iov_len to zero for registration and/or buffer updates. Empty buffer
can't have a non-zero tag.

Implementation details: to not add extra overhead to io_import_fixed(),
create a dummy buffer crafted to fail any request using it, and set it
to all empty buffer slots.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a48b88b3e289..43b00077dbd3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -456,6 +456,7 @@ struct io_ring_ctx {
 	spinlock_t			rsrc_ref_lock;
 	struct io_rsrc_node		*rsrc_node;
 	struct io_rsrc_node		*rsrc_backup_node;
+	struct io_mapped_ubuf		*dummy_ubuf;
 
 	struct io_restriction		restrictions;
 
@@ -1158,6 +1159,12 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 	__hash_init(ctx->cancel_hash, 1U << hash_bits);
 
+	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
+	if (!ctx->dummy_ubuf)
+		goto err;
+	/* set invalid range, so io_import_fixed() fails meeting it */
+	ctx->dummy_ubuf->ubuf = -1UL;
+
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		goto err;
@@ -1185,6 +1192,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->submit_state.comp.locked_free_list);
 	return ctx;
 err:
+	kfree(ctx->dummy_ubuf);
 	kfree(ctx->cancel_hash);
 	kfree(ctx);
 	return NULL;
@@ -8106,11 +8114,13 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	struct io_mapped_ubuf *imu = *slot;
 	unsigned int i;
 
-	for (i = 0; i < imu->nr_bvecs; i++)
-		unpin_user_page(imu->bvec[i].bv_page);
-	if (imu->acct_pages)
-		io_unaccount_mem(ctx, imu->acct_pages);
-	kvfree(imu);
+	if (imu != ctx->dummy_ubuf) {
+		for (i = 0; i < imu->nr_bvecs; i++)
+			unpin_user_page(imu->bvec[i].bv_page);
+		if (imu->acct_pages)
+			io_unaccount_mem(ctx, imu->acct_pages);
+		kvfree(imu);
+	}
 	*slot = NULL;
 }
 
@@ -8250,6 +8260,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	size_t size;
 	int ret, pret, nr_pages, i;
 
+	if (!iov->iov_base) {
+		*pimu = ctx->dummy_ubuf;
+		return 0;
+	}
+
 	ubuf = (unsigned long) iov->iov_base;
 	end = (ubuf + iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
@@ -8347,7 +8362,9 @@ static int io_buffer_validate(struct iovec *iov)
 	 * constraints here, we'll -EINVAL later when IO is
 	 * submitted if they are wrong.
 	 */
-	if (!iov->iov_base || !iov->iov_len)
+	if (!iov->iov_base)
+		return iov->iov_len ? -EFAULT : 0;
+	if (!iov->iov_len)
 		return -EFAULT;
 
 	/* arbitrary limit, but we need something */
@@ -8397,6 +8414,8 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
+		if (!iov.iov_base && tag)
+			return -EINVAL;
 
 		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
 					     &last_hpage);
@@ -8446,12 +8465,14 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(&iov);
 		if (err)
 			break;
+		if (!iov.iov_base && tag)
+			return -EINVAL;
 		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
 		if (err)
 			break;
 
 		i = array_index_nospec(offset, ctx->nr_user_bufs);
-		if (ctx->user_bufs[i]) {
+		if (ctx->user_bufs[i] != ctx->dummy_ubuf) {
 			err = io_queue_rsrc_removal(ctx->buf_data, offset,
 						    ctx->rsrc_node, ctx->user_bufs[i]);
 			if (unlikely(err)) {
@@ -8599,6 +8620,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_hash);
+	kfree(ctx->dummy_ubuf);
 	kfree(ctx);
 }
 
-- 
2.31.1

