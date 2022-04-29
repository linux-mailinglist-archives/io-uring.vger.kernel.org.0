Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D807C515314
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiD2SAK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379840AbiD2SAI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:08 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556DDD344E
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:50 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id f2so10278271ioh.7
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i+VKVI6/zt9UTYmfiLSo36PZ7ETZYRPDN9jB1EtNliU=;
        b=VkqduebcnmqC5dJ90R6u3hIPK1amFDw0x3S4i5wc+O5CrXHuxWGa3iXGbL9ShJrk0T
         zH5V2tREio3XGuREvHbCWmW6hr7Cz/zR3y/uOxsNY+GLNeZpmhz44MP8YghnFRyjPYE5
         ZolYm+1IzWt+Oemw3/6xbfiWfyZjtRepw1sZwBLnyP0iCVJx4L/1/lqirttfbAbcAtHr
         hHBy4r9HqtoOChSKhcloIW8jhQYL+MfS+rK8mOFQQH0k2wW3SvTTaPHTYcyBd9EHZNXe
         QttcIiCdALKhKhWpBRod7SoWXsUViX/Q/Dk3MIk85+gRUHwPT0jAz2NmN5ShXexMYi94
         q/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i+VKVI6/zt9UTYmfiLSo36PZ7ETZYRPDN9jB1EtNliU=;
        b=x/8DQBjr6L+eDba/Fvc1wPoDg/EQOHsVa3m96taqRDVHCDm2j2YzU7GrXUEb6iP6od
         SJcn2+0aQ3Dssi9dZ02DePIeccbivoV5Mlp2VfkJpLEZFcqUROwQRY4Nvz+2KNhNvnVM
         0ImJj8P1i/vdGs1h6Uv0PgbuGsPybq2BM0lUG9wtnIxiscVwd0H/geMsVq6fYgF+sxoj
         pqJ6TNqPowsMX6HPtZvsYK9Z+W/SaX3W+Dn0fV5X1MaBI0lYGM5qiFA1ZecNpHjSBzbK
         QWKi8f6eBGXzifysJfdG48QhALZUTz+WBghPCC2jR1CI6+VeSk9xdDWcob8EwAAurBq+
         EPBw==
X-Gm-Message-State: AOAM532Aak3IFQifODjMEs7XdYOBJFAxADxKGEiRY3tGQs481nq6d7A4
        BvDqo+edVc5/hsEW4oUE3XSWfPAFCWmxfg==
X-Google-Smtp-Source: ABdhPJyWyVhnG0gKZNQKawzrDTojeZyKv1EMR+v0Y31oe1ZoPlUURUt6kzu19N8/rkRDUIeT+1RrjA==
X-Received: by 2002:a02:6d1b:0:b0:32a:c918:e0b2 with SMTP id m27-20020a026d1b000000b0032ac918e0b2mr232728jac.286.1651255007987;
        Fri, 29 Apr 2022 10:56:47 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/11] io_uring: add io_pin_pages() helper
Date:   Fri, 29 Apr 2022 11:56:32 -0600
Message-Id: <20220429175635.230192-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abstract this out from io_sqe_buffer_register() so we can use it
elsewhere too without duplicating this code.

No intended functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 77 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d4004c3a88a1..67465cf3700a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10160,30 +10160,18 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
-static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
-				  struct io_mapped_ubuf **pimu,
-				  struct page **last_hpage)
+static struct page **io_pin_pages(unsigned long ubuf, unsigned long len,
+				  int *npages)
 {
-	struct io_mapped_ubuf *imu = NULL;
+	unsigned long start, end, nr_pages;
 	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
-	unsigned long off, start, end, ubuf;
-	size_t size;
-	int ret, pret, nr_pages, i;
-
-	if (!iov->iov_base) {
-		*pimu = ctx->dummy_ubuf;
-		return 0;
-	}
+	int i, pret, ret = -ENOMEM;
 
-	ubuf = (unsigned long) iov->iov_base;
-	end = (ubuf + iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
 	nr_pages = end - start;
 
-	*pimu = NULL;
-	ret = -ENOMEM;
-
 	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto done;
@@ -10193,10 +10181,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (!vmas)
 		goto done;
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
@@ -10214,6 +10198,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				break;
 			}
 		}
+		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
 	}
@@ -10227,14 +10212,53 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 			unpin_user_pages(pages, pret);
 		goto done;
 	}
+	ret = 0;
+done:
+	kvfree(vmas);
+	if (ret < 0) {
+		kvfree(pages);
+		pages = ERR_PTR(ret);
+	}
+	return pages;
+}
 
-	ret = io_buffer_account_pin(ctx, pages, pret, imu, last_hpage);
+static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
+				  struct io_mapped_ubuf **pimu,
+				  struct page **last_hpage)
+{
+	struct io_mapped_ubuf *imu = NULL;
+	struct page **pages = NULL;
+	unsigned long off;
+	size_t size;
+	int ret, nr_pages, i;
+
+	if (!iov->iov_base) {
+		*pimu = ctx->dummy_ubuf;
+		return 0;
+	}
+
+	*pimu = NULL;
+	ret = -ENOMEM;
+
+	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
+				&nr_pages);
+	if (IS_ERR(pages)) {
+		ret = PTR_ERR(pages);
+		pages = NULL;
+		goto done;
+	}
+
+	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	if (!imu)
+		goto done;
+
+	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
 	if (ret) {
-		unpin_user_pages(pages, pret);
+		unpin_user_pages(pages, nr_pages);
 		goto done;
 	}
 
-	off = ubuf & ~PAGE_MASK;
+	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
 	size = iov->iov_len;
 	for (i = 0; i < nr_pages; i++) {
 		size_t vec_len;
@@ -10247,8 +10271,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		size -= vec_len;
 	}
 	/* store original address for later verification */
-	imu->ubuf = ubuf;
-	imu->ubuf_end = ubuf + iov->iov_len;
+	imu->ubuf = (unsigned long) iov->iov_base;
+	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	*pimu = imu;
 	ret = 0;
@@ -10256,7 +10280,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (ret)
 		kvfree(imu);
 	kvfree(pages);
-	kvfree(vmas);
 	return ret;
 }
 
-- 
2.35.1

