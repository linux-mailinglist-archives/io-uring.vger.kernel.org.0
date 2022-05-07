Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F141B51E7D0
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352506AbiEGOe0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347909AbiEGOeZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:34:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D2F1580B
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 07:30:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c1-20020a17090a558100b001dca2694f23so9069810pji.3
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 07:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2JF6VhWHyd6FlEiIjIGB1X+UZ4g8MHE8TFDdF1g2Ec=;
        b=F10s3Tw9VmXW9izxIvMbTnVuE6PGtyMS+tajNgAT70Uqd4n5Es4Z078vsdc/8oqtF+
         +261OY9YV2ONqkCw88yuMAvIPzXfT9MNDrLQdoawVF0G2eztlM8PKNRlU2sVa9LlWGYn
         E8yv8h4Vv0CC7yabGeGkQIaRFk4LxeLoNq29uOhiydLCW3Is/s0HaqCqImjBsgmawpc7
         Q7chw855+RKjntcaN9a71FHsC3WgmCeA0M/93l6nlNzQPc8pLU3suajpi06fegrl/sl0
         ZT8pTLCmRFyvB2j+m3JBK8Ahgz+DC7BYELXAFhBNyJfWarKB/dHbW/Eu+O4YKwiO9JY4
         lBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2JF6VhWHyd6FlEiIjIGB1X+UZ4g8MHE8TFDdF1g2Ec=;
        b=KBYGtZ3iq68yJFmW6NuAHagRscAEYiBmDkOmehYZRsfhf+ZplHNYuMBTgmrNEJAH9D
         e9QA663rcUg4jmvtZUrXcOvfZliIimdg3CtiTfhDtHeNBA+5H2V7ruPsDJfXgnk7B5ig
         jBzOxPHlapImneHwwxYK4nj4K+oVKz77NqVFJi59Mov7dUuJOgbKMw0j1UHrloFhZzTe
         Et2aKLxG2n6MR0AGwYMyGXOH1wzfzjuJ9R07YmFmIDDLRGVrqArWxH2eYeDx5cOH9eSh
         Cun3k4Gz9aUWiuvYA/631WEAlH+cSMYkD/dZo614a3Yd4qUFWeRuo9VAH4OVdsEMSBby
         hWWA==
X-Gm-Message-State: AOAM532PzWl61HD0ZRkk+ipEeL9dx/sVKzM0Zza8shjWvdWxlmKSqjJP
        6DselzqBTcMQXuhVfStp11FnDOITIWU2kA==
X-Google-Smtp-Source: ABdhPJwQQlOHkb09JE8d7inn6GUKz+t/6MdVcmHLlX19p5KLyVF98dyIZucTFEQ7U54UwClH/BWQmw==
X-Received: by 2002:a17:902:e5cc:b0:15e:b847:2936 with SMTP id u12-20020a170902e5cc00b0015eb8472936mr8473141plf.138.1651933836792;
        Sat, 07 May 2022 07:30:36 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h7-20020aa796c7000000b0050dc76281e3sm5332936pfq.189.2022.05.07.07.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 07:30:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: add io_pin_pages() helper
Date:   Sat,  7 May 2022 08:30:30 -0600
Message-Id: <20220507143031.48321-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220507143031.48321-1-axboe@kernel.dk>
References: <20220507143031.48321-1-axboe@kernel.dk>
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
index 667bb96cec98..fe68de1ce308 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9686,30 +9686,18 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
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
@@ -9719,10 +9707,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (!vmas)
 		goto done;
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
@@ -9740,6 +9724,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				break;
 			}
 		}
+		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
 	}
@@ -9753,14 +9738,53 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -9773,8 +9797,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -9782,7 +9806,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	if (ret)
 		kvfree(imu);
 	kvfree(pages);
-	kvfree(vmas);
 	return ret;
 }
 
-- 
2.35.1

