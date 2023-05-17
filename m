Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FBF70720F
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 21:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjEQT01 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 15:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjEQT0K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 15:26:10 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97074AD1A;
        Wed, 17 May 2023 12:25:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3078c092056so823852f8f.1;
        Wed, 17 May 2023 12:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684351545; x=1686943545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IDPgbDXgNpmFaT/Xq61rTSESXh922Cqn8VFjEHQlO/U=;
        b=dcn4x8zmZYzMdxqkxin+0Kp7oATcck21D2y26zDzpSXi6bO9bOBrwUasI9ojQYvRQA
         Zi713T2NPyPIzQBAXspWoX4abLIAfZM/Hag4DsUoyq9FLSKw83Xnw4kJhDkspxU1p62K
         vVaoFNdRZIAhuKmQttjFmCmDyC572QHulp1NowyT8iq/Nvyci8UUJp55j4wCgmf0x+HA
         NC0uwt++BTCQqq8HDts1cBcme23dDYfw3Tg0t0eNYYibcHvjK+2B2QjCBcx5Xjgtwhr7
         qtiINwWlapVJ3KpKa0fevqyxxIICgFQbRh/pFOxP564gguNmk1v+f2g4r5eMslZkWV72
         e5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684351545; x=1686943545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IDPgbDXgNpmFaT/Xq61rTSESXh922Cqn8VFjEHQlO/U=;
        b=gvHJ3+thKiufoY6WgTpr1QrR+hF0292BJYzxviLxhoEgKaRNtfvpq3GCZfMqW58f4F
         x+RZM1wBTrOHkRAPFgUucVbmNNT2YeoIPtLA8TqupyFC0c3tz+u88ZZj1Hz9gcWt0D3t
         JVjp1w8GGwU7Bt9nQmzYIgFL/mVsnVLqFffsyQTnOmWt95ymLLm7fDukM8KehdsyE2yL
         zzeCaLEEj2auhLxMSGn6d1XwdkUDSrwwypD8oXHnG5eKqC8/Fda4XYgtjhH28Ie5hQmb
         3G9KTkdPMXKqWtXO8tMU+NJGsXwAchYECJziv9SU2CQHWL0UBWPK0niluAJS089H7YBy
         5QxQ==
X-Gm-Message-State: AC+VfDxJenx7AL7xr+vH3Nyh5WO9FlPAgz0nDS4cbqGqKfIZOgfKKPx0
        33Xo+OG/ornM10GA4gdCErK/6EzpDDf+8g==
X-Google-Smtp-Source: ACHHUZ5gUIunrgcLQA5O73BeJ9za8lFR9tf5MVp4yuOnPxdVTT9mfQ+v0R4XrZy+Pi+kpOanAXPPSw==
X-Received: by 2002:adf:e58a:0:b0:2f6:a8dd:f088 with SMTP id l10-20020adfe58a000000b002f6a8ddf088mr1148050wrm.62.1684351544804;
        Wed, 17 May 2023 12:25:44 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id f26-20020a1c6a1a000000b003f4272c2d0csm3076037wmc.36.2023.05.17.12.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:25:43 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 4/6] io_uring: rsrc: delegate VMA file-backed check to GUP
Date:   Wed, 17 May 2023 20:25:42 +0100
Message-Id: <e4a4efbda9cd12df71e0ed81796dc630231a1ef2.1684350871.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1684350871.git.lstoakes@gmail.com>
References: <cover.1684350871.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that the GUP explicitly checks FOLL_LONGTERM pin_user_pages() for
broken file-backed mappings in "mm/gup: disallow FOLL_LONGTERM GUP-nonfast
writing to file-backed mappings", there is no need to explicitly check VMAs
for this condition, so simply remove this logic from io_uring altogether.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 io_uring/rsrc.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d46f72a5ef73..b6451f8bc5d5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1030,9 +1030,8 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
-	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
-	int i, pret, ret = -ENOMEM;
+	int pret, ret = -ENOMEM;
 
 	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
@@ -1042,45 +1041,24 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	if (!pages)
 		goto done;
 
-	vmas = kvmalloc_array(nr_pages, sizeof(struct vm_area_struct *),
-			      GFP_KERNEL);
-	if (!vmas)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages, vmas);
-	if (pret == nr_pages) {
-		/* don't support file backed memory */
-		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
-				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
-				ret = -EOPNOTSUPP;
-				break;
-			}
-		}
+			      pages, NULL);
+	if (pret == nr_pages)
 		*npages = nr_pages;
-	} else {
+	else
 		ret = pret < 0 ? pret : -EFAULT;
-	}
+
 	mmap_read_unlock(current->mm);
 	if (ret) {
-		/*
-		 * if we did partial map, or found file backed vmas,
-		 * release any pages we did get
-		 */
+		/* if we did partial map, release any pages we did get */
 		if (pret > 0)
 			unpin_user_pages(pages, pret);
 		goto done;
 	}
 	ret = 0;
 done:
-	kvfree(vmas);
 	if (ret < 0) {
 		kvfree(pages);
 		pages = ERR_PTR(ret);
-- 
2.40.1

