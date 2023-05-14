Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23BC701FC4
	for <lists+io-uring@lfdr.de>; Sun, 14 May 2023 23:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbjENV1J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 May 2023 17:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237913AbjENV1G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 May 2023 17:27:06 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0B910EA;
        Sun, 14 May 2023 14:26:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3063afa2372so11214825f8f.0;
        Sun, 14 May 2023 14:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684099618; x=1686691618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6lZfZiVFWsAlcMWN5PRi30FiuIH4ExiR/doISXVhpnA=;
        b=S/k6Ea9S7jTXAkegHdRNsYFunFJtyA0tD50ThbnkZoegODRr5kBExok5WQkHItiThy
         9Eqit3HhgZkuqZV4o6mY1FgL3cOhKarBAgLlvy7XoFrsUNHYKuSScvJHno7LbQGZCSJL
         cBrDEg28rcrgcSohO93qC0JLzI4nT0W5ZizqecvOSJm1aw/HNhkd0n9haUp4X7OXZDhf
         pIn9jvFlyWIMW7YfXnnzqDAaYDey1Eeyv7BGnybQ19c2uJvcxJKmXwtrK2ijBLkqrwE2
         OcSjIqGlL2tu6YE+rNveIHct+bjthi0raPd9ShK3wa4GpPLymWffn7c+Fva20QTttk3D
         mJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684099618; x=1686691618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6lZfZiVFWsAlcMWN5PRi30FiuIH4ExiR/doISXVhpnA=;
        b=BUm3r1r7+UHsjhdnSvDaTtDx9VbXCeXcPuplSkP7jx9BUPQgw4Ew3KRNHxT0kDgVQq
         7hScQvLvWNXHZ4W10WiGRpR+4OwaPYVKVLA1w1JnRa2P1o8wj/A0NHl45Js1DkcDue4Z
         05BbMArx7Wc5Uvl5dtaaezQAhPes0G3Zc3P4rcSsMuFjZATqteuFHPhAetlJTSI80loY
         a1kfEfLsVwPcRQFUJBpWLpm0Xbso0HptqRZqT60uQfYLyldfCb0ZiJrJ8Zxa8Qb9EP0C
         3S3LRHF8XcsfKgqe1AF49BppJBBefLf8i92Hj1lBglYFZEYf3YAck+WqfOdiDr8sGIMg
         D89A==
X-Gm-Message-State: AC+VfDzle/oP0gXOfc13049VByGJqp21WJkcO2RYTOA8W+c9sFo9ekz7
        MX5t9o2QmHb8uwGJwc52+xs=
X-Google-Smtp-Source: ACHHUZ7xbzYrHEIBsBEOTfbuU9xONp4amC/jy4CMWdSN4lsoxtCis8o8qIA1MVHQab6pCBBaxEceNw==
X-Received: by 2002:adf:f142:0:b0:306:36b5:8ada with SMTP id y2-20020adff142000000b0030636b58adamr24687541wro.29.1684099618096;
        Sun, 14 May 2023 14:26:58 -0700 (PDT)
Received: from lucifer.home ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.googlemail.com with ESMTPSA id z8-20020adfec88000000b003062675d4c9sm30253398wrn.39.2023.05.14.14.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 14:26:57 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v5 4/6] io_uring: rsrc: delegate VMA file-backed check to GUP
Date:   Sun, 14 May 2023 22:26:55 +0100
Message-Id: <642128d50f5423b3331e3108f8faf6b8ac0d957e.1684097002.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1684097001.git.lstoakes@gmail.com>
References: <cover.1684097001.git.lstoakes@gmail.com>
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

