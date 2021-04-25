Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AAE36A78C
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhDYNdZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhDYNdZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:25 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F3EC061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e5so24403035wrg.7
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pG+3k4fP9fo3MhQr8A2e0UasRZDbM1ipNBVTYvFeJkA=;
        b=ixMTVhKYe21vNIdIFACl93RhU6VSdV2PkX1NrB2t4KfVvcbqAN3Ld6Mov8WbjUfcFB
         47oWRGE7TkK/l5lpW8lMpV0YiK08hi6MMnZFjb/ftnLMySPFARdt9SycaBZ7xssQQ+7u
         2DhVtcgoa2TBOFIBuAYLsNqofhigSkIR9aF2RXiaWAD1WhzHx+3lJ37GWOxMkVFWKLzF
         X0rujTBkOGMKm2Jv4ZnBlfhrzsCnWeGNYOa8TTtIpHvqaD0CPaCQs0oYYLIpl5bJHXGX
         tJ1CwAcQZUsB5J0NWRY5RFHf4lNqsBRPuVRGZaqmBfT3fpVVeAzI5FqlGEH8m/R714JS
         k2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pG+3k4fP9fo3MhQr8A2e0UasRZDbM1ipNBVTYvFeJkA=;
        b=WsXqCvqZv+s6sI6hA8DwkEmCY1OmnUN8dbOA7QaFx+AbCNZznu3WYDtIeSxdd1Wiw6
         qEoZy6jSiGSZOtb+OxdqZVdk+EWhlgwsnYQvIqcw2c0gizepuka6mXeJIdD7stDnu6Hs
         VTFmlDzi72XrIJXIZF+arLWzDc5lPb0bXOyx6MjD9rOSYCEBaM3eOXT5+KOh8BfedKot
         h9xvAynccIWtLoeNBDj9J1qpwM33HckL5l6LD73Ka26eSCaInJkx7FfSXzWcdSqsgIqc
         hGuTd25CUObbiC8fltpqXXx9ST6U9lGO+Afz6a9+NN6QXU2crFcTpthfXcLwkdmgihLn
         P7Kg==
X-Gm-Message-State: AOAM53167o342N8E4f7dHKooi7JYqlRYS5/oDOMiwZuQm0j0503tpm6W
        /aOMZCk/Icgp9Jkv+qfAuL4=
X-Google-Smtp-Source: ABdhPJzI4RN33tQsgeBUS040qcgdSkSKsOBIepjlswZKztW5DNDbbHMIMFNrLl50JsryuZhQz7aXFw==
X-Received: by 2002:adf:fd0b:: with SMTP id e11mr5876146wrr.402.1619357564154;
        Sun, 25 Apr 2021 06:32:44 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 09/12] io_uring: keep table of pointers to ubufs
Date:   Sun, 25 Apr 2021 14:32:23 +0100
Message-Id: <b96efa4c5febadeccf41d0e849ac099f4c83b0d3.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of keeping a table of ubufs convert them into pointers to ubuf,
so we can atomically read one pointer and be sure that the content of
ubuf won't change.

Because it was already dynamically allocating imu->bvec, throw both
imu and bvec into a single structure so they can be allocated together.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5882303cc84a..ea725c0cbf79 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -195,9 +195,9 @@ enum io_uring_cmd_flags {
 struct io_mapped_ubuf {
 	u64		ubuf;
 	u64		ubuf_end;
-	struct		bio_vec *bvec;
 	unsigned int	nr_bvecs;
 	unsigned long	acct_pages;
+	struct bio_vec	bvec[];
 };
 
 struct io_ring_ctx;
@@ -405,7 +405,7 @@ struct io_ring_ctx {
 
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
-	struct io_mapped_ubuf	*user_bufs;
+	struct io_mapped_ubuf	**user_bufs;
 
 	struct user_struct	*user;
 
@@ -2760,7 +2760,7 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-	imu = &ctx->user_bufs[index];
+	imu = ctx->user_bufs[index];
 	buf_addr = req->rw.addr;
 
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
@@ -8076,16 +8076,17 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 	return off;
 }
 
-static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slot)
 {
+	struct io_mapped_ubuf *imu = *slot;
 	unsigned int i;
 
 	for (i = 0; i < imu->nr_bvecs; i++)
 		unpin_user_page(imu->bvec[i].bv_page);
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx, imu->acct_pages);
-	kvfree(imu->bvec);
-	imu->nr_bvecs = 0;
+	kvfree(imu);
+	*slot = NULL;
 }
 
 static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
@@ -8152,7 +8153,7 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 
 	/* check previously registered pages */
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
@@ -8197,9 +8198,10 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 }
 
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
-				  struct io_mapped_ubuf *imu,
+				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage)
 {
+	struct io_mapped_ubuf *imu = NULL;
 	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
 	unsigned long off, start, end, ubuf;
@@ -8211,6 +8213,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	start = ubuf >> PAGE_SHIFT;
 	nr_pages = end - start;
 
+	*pimu = NULL;
 	ret = -ENOMEM;
 
 	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
@@ -8222,8 +8225,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (!vmas)
 		goto done;
 
-	imu->bvec = kvmalloc_array(nr_pages, sizeof(struct bio_vec),
-				   GFP_KERNEL);
+	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
 	if (!imu->bvec)
 		goto done;
 
@@ -8253,14 +8255,12 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		 */
 		if (pret > 0)
 			unpin_user_pages(pages, pret);
-		kvfree(imu->bvec);
 		goto done;
 	}
 
 	ret = io_buffer_account_pin(ctx, pages, pret, imu, last_hpage);
 	if (ret) {
 		unpin_user_pages(pages, pret);
-		kvfree(imu->bvec);
 		goto done;
 	}
 
@@ -8280,8 +8280,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = ubuf;
 	imu->ubuf_end = ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	*pimu = imu;
 	ret = 0;
 done:
+	if (ret)
+		kvfree(imu);
 	kvfree(pages);
 	kvfree(vmas);
 	return ret;
@@ -8331,15 +8334,15 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
-		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
-
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
 			break;
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
-		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
+
+		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
+					     &last_hpage);
 		if (ret)
 			break;
 	}
@@ -9248,7 +9251,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = &ctx->user_bufs[i];
+		struct io_mapped_ubuf *buf = ctx->user_bufs[i];
 		unsigned int len = buf->ubuf_end - buf->ubuf;
 
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, len);
-- 
2.31.1

