Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DF7528A2A
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiEPQVd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240443AbiEPQVc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:21:32 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6723969B
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:21:30 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e4so1584686ils.12
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BHrnUCULi94CXBvhDDxhLej14RAoghKBNksHDXxG2Uk=;
        b=nqrrZrT1CKtEuE1QpG4V/QuFxfePiGsYtP5xtFIunkD5RognrFZI4Dxk0OxhRaXXHE
         lZWyuwmmsbqDcGVdlIInyWPW+D9Kjh21YIWxpoJCSagh2w66AYPnwzX66ThCyZ310S2S
         vaos32c1OUPf84Sr255sBlUfkdCCzlbEC8V8W0ipGqKWmyWTnsYN9+ypkBgoI8em+Nxo
         BsoI3RYLnOvNf9798c5jzrEZ0hX/H6XCVSHo3677VMMKTVMc3LxspBTyGI3yEhUu/zTP
         xg40zw2cQM73df250CmRfPrAsgFLTWNcFb3J6tZpdbIU2NmORsIlTcWCeRrKxk2swFBs
         A70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BHrnUCULi94CXBvhDDxhLej14RAoghKBNksHDXxG2Uk=;
        b=E21BRPU0JDUpVKpeTVFv7V54Kf1EKUbHio3CFegTLCkfXP3K6lZzAnw1ZJo2JyO9ox
         aS8Acv5Fa8Qup7ePsHC63bMfZMWKgCwi/doAl+W4MMoU+yWZRD21a+YLg1A2jcf9C2Us
         mYeLVsHPai8P1SpUA5yyiFWXYLH6yR1/NpI6iIPduugZCTSWAtQav/uQBaSEDfkFZrgT
         w8UrKwtC8B9uEwDnrMvWax4A5wTy17aO7TJf0xBZVL4Xac37NLGrcwNbzHwiDngDYAaV
         D+VinkQSTJTIGPgkV2bbRu237oAuUxTNVxq4G6sx1li0pXcTbVKm76wKB+9FvFYHabZY
         EFtg==
X-Gm-Message-State: AOAM531lOn0FXvtFEYsShhD9xpXXksP8tiF7gXQAmghieHaQ+L/z1IM3
        leOhDxXVDE76vH2vgW+L+ugK6irr7uT+Mw==
X-Google-Smtp-Source: ABdhPJznJBUpYjZ6+VJjQwr/WAYVjW71A6KMYFBUPTFuCBGHChh98crTmsGmjM2SQv57C0YhkAEmrg==
X-Received: by 2002:a05:6e02:1a83:b0:2cf:522a:971c with SMTP id k3-20020a056e021a8300b002cf522a971cmr9302954ilv.282.1652718088780;
        Mon, 16 May 2022 09:21:28 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l9-20020a92d8c9000000b002d0ebe7c14asm2740ilo.21.2022.05.16.09.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 09:21:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: add io_pin_pages() helper
Date:   Mon, 16 May 2022 10:21:17 -0600
Message-Id: <20220516162118.155763-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516162118.155763-1-axboe@kernel.dk>
References: <20220516162118.155763-1-axboe@kernel.dk>
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

Abstract this out from io_sqe_buffer_register() so we can use it
elsewhere too without duplicating this code.

No intended functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 77 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a458a7b3280..5867dcabc73b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9845,30 +9845,18 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
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
@@ -9878,10 +9866,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (!vmas)
 		goto done;
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
@@ -9899,6 +9883,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				break;
 			}
 		}
+		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
 	}
@@ -9912,14 +9897,53 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -9932,8 +9956,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -9941,7 +9965,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (ret)
 		kvfree(imu);
 	kvfree(pages);
-	kvfree(vmas);
 	return ret;
 }
 
-- 
2.35.1

