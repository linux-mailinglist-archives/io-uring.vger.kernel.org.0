Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDF651606F
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244333AbiD3UyL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245198AbiD3UyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:54:00 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2F63983F
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p12so9611310pfn.0
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qx6bMjVlbiHa3vnn6JprTk6vfGQO5bZIXGVPUQoMvEE=;
        b=pLkVSZdtJT14Jtu0maMO+0ol3YKGrgWDALdGLXDaxB2CyYGvE0jV2mTRUKJdKf9gIA
         rbWmQ62JoFjgkoXOaz0lC9rlutl/DzBlhkQAfDC0KMrbtyVpzq2j8xfmWgq9WxRWlYpu
         zMmvBn/M3X9EawqtjWN1FtZfGmhimuWBgtXfnk5oiGSS1FwaDUep5lEsTkbo2BdJPhaE
         rbDPZyXiIjhzc3C/ZtQRntC5XJuy5oSUHcRS9jzGlulgadfRpZNkqUawy5TDu+SkwzG0
         0YaZheDAl/wV18H07BmJ/+/S3Y7KfUCkVFcbxFTdLVCIYtHXAjb129o+ZiBCqagskGeK
         Y9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qx6bMjVlbiHa3vnn6JprTk6vfGQO5bZIXGVPUQoMvEE=;
        b=GGwqPCzds4+E2xrJs9FzH31ZGkgtrdXn9AkEXYofDYJq51HgCwhgby/MT94aau2NLd
         ZltJwRoiMdRQo4sz7wqdx8X+QhB2SCEU1BECQCCdqOkQwfjJsclegB1A3hSx1sxXZHtR
         C7vN8qKjcm8gjFfYSZy2nEUr3rudy0tF/gmF5Vuiotg5oZK3VL+VgZAY+zL13zQDHvk4
         wFZdfiUUdBX+JCeZxry3zHmTo6eJDEWBn22wLtCNMKehaZ8VrGe/9ufVX1LE8t3OE1lO
         hybMOlx/5xbByiDNFEjwdVVkNsxD71MB7kLNZp1V+OkeSpsxFgoGyTOn4Gla9QJq8EmB
         uPqQ==
X-Gm-Message-State: AOAM532F4PG+FUDdxLgvBs8BMxGQlrdyPGZXK9+kRA/qDR8K9QOPEWyt
        ixBtaIo9TcR6CUJPBCPD8pwIaoaK0r7FiQ0G
X-Google-Smtp-Source: ABdhPJy5WYEEoySsicshJhDCV77+p36oH88fLsuG9nXya4S5DHN+qB9cfIfPrNDJwSwHhb686C0xoQ==
X-Received: by 2002:a65:604b:0:b0:398:ebeb:ad8f with SMTP id a11-20020a65604b000000b00398ebebad8fmr4266567pgp.89.1651351836065;
        Sat, 30 Apr 2022 13:50:36 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/12] io_uring: add io_pin_pages() helper
Date:   Sat, 30 Apr 2022 14:50:19 -0600
Message-Id: <20220430205022.324902-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
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
index eb168a7c6e06..8b9636043dbf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10166,30 +10166,18 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
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
@@ -10199,10 +10187,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (!vmas)
 		goto done;
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
@@ -10220,6 +10204,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				break;
 			}
 		}
+		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
 	}
@@ -10233,14 +10218,53 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -10253,8 +10277,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -10262,7 +10286,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (ret)
 		kvfree(imu);
 	kvfree(pages);
-	kvfree(vmas);
 	return ret;
 }
 
-- 
2.35.1

