Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDF5514948
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359135AbiD2Mbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359138AbiD2Mbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:34 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88CFC8BED
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:16 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id j6so6767403pfe.13
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DRMdwQzq/re4Svk3K0D+vCR+bSvhNpFrMmRpIP0tqWA=;
        b=izAWLmtO0BA7H3n4fB+/rj1iO7FkQiFc1+JU57PZsKbqYJP02gHMbgB7aZ+l44cL/U
         LzsyXCmoAfnX/qDdqqdK4JCDKOCmHHQRdhmHSlTUlzZfgZU2drFJC8w8wH3g/Vt9oEye
         wv/sBKoGUzUUDbAtZ+AQCUjUoK5D20/xpijbK3TeO6QwltG0yEWy+2iErBtl58eyL6GO
         Bs6SpoX5heTCGmdUAUKh5XJPCaLGSqBgq3/yGXnKtAuIBEmb0U7N7mbCWxq0YI8vhnjx
         rz962Ez+MhRCK3LVhRT3Bz292lvVT5XEZfh3tLwYXCIAj0mGZ7LZNIwpAX4hXdO/jspQ
         P+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DRMdwQzq/re4Svk3K0D+vCR+bSvhNpFrMmRpIP0tqWA=;
        b=q/wPwUPsrvQNkgOw7grUeuDD8gpaSRlBHlocWFrFIp9QslL4+ZHVoxVtvN8kmEWgg8
         4OC7rEYtMHI4PpUPkkazOiflz8BA7q/EyMRIlNRJTl2IgifPJweZDM/9qmDLftF0t/Vx
         4g/GtvqIl98a/8IyPFK5jq66Bf+90IdRLICyso2HK68msn1oL8DD7pOM37RGqjJCs/JZ
         avLNYtbDm0WGlhTRIbvKQHW1N54eat5cZlj5FhmoEKpBAhGvgPJnIsyCwEB2Gbq1qI1/
         Vrvxg+Y964JeNtnNRNjPwVjA+D+1uEO4Z6xREUdOvlk4jZirPNwUl3+InFSXk6BW9nmo
         H2WQ==
X-Gm-Message-State: AOAM5316tXNkxTfBenyMohfqWEm6JtCmgK6rTwfRFF5FAvpM+9UbgADw
        6igpQ9z4jil1EXCTIwx8M7QtnSGhfIUXtT87
X-Google-Smtp-Source: ABdhPJwijKuqtvhJxhwa0RwPSWTxB6EoAGxUHQ9Se8Ccpmq7BP0PGwYIP3ywl5QzfaaziwGFxrKK2g==
X-Received: by 2002:a05:6a00:b87:b0:50a:5ff2:bb2d with SMTP id g7-20020a056a000b8700b0050a5ff2bb2dmr39528925pfj.68.1651235296078;
        Fri, 29 Apr 2022 05:28:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/10] io_uring: add io_pin_pages() helper
Date:   Fri, 29 Apr 2022 06:28:00 -0600
Message-Id: <20220429122803.41101-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
index c9f06aac4a53..f8816c61d455 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10162,30 +10162,18 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
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
@@ -10195,10 +10183,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (!vmas)
 		goto done;
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
@@ -10216,6 +10200,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				break;
 			}
 		}
+		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
 	}
@@ -10229,14 +10214,53 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -10249,8 +10273,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -10258,7 +10282,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (ret)
 		kvfree(imu);
 	kvfree(pages);
-	kvfree(vmas);
 	return ret;
 }
 
-- 
2.35.1

