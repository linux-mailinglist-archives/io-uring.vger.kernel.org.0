Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8FE6E2FE8
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 11:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDOJJJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 05:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjDOJIu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 05:08:50 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79349740;
        Sat, 15 Apr 2023 02:08:47 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so10819174wms.1;
        Sat, 15 Apr 2023 02:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681549726; x=1684141726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GS8ed+C9TZSDKqE7yJs3rXmG1XU+tjMZxFV1EPCP0I=;
        b=b454/ADSubR+UtZwD/vd9/bxU7eI6S5iNJ+h+0UiN9FgDora+ApBhUaT3SSlJPj557
         Wr3AFdfbJaL+aizieInN5iM4WcDgKnRveo/2NyepsbPQmZF74KcuE7RuIOiyD6ggtXa6
         ALOo/15uJ0W2QbV3lcS061wfIQnR61bEBb8pnD6aBXrCXX96Kdxx2HQDKFGkGZpb7EpW
         OmTyhghPGusO7/l9glNJkiPfr2rNIQjHZklmjuE1K1RDy4jndjREXz5eqSeEihKFhXsA
         LyQ/OMWU+Dr0qQaxFDPpttO2bKIZFUYKcoe8bc2bHU7zWvT8dbv3t9Daba//frSBg37T
         2SgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681549726; x=1684141726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GS8ed+C9TZSDKqE7yJs3rXmG1XU+tjMZxFV1EPCP0I=;
        b=ZNNT0Urk+3pnlWYDyFbPhIRXG1+++6I23GhbdnJ3gJ15zcXvQ74SyN43UXt6zpCAMZ
         xnZ0UB5y24M8GFeeKqMyONthjXFQ1QqsXaPsNjeFVN3KrFKEkCuDyGsuKBxI+Ek41Scr
         ZKQ+iIGjFkkM+wUoSwEDCIE8CqqxBjvjDMU0VulvYpOM9t01fbBjvE7V2izhiYrrDtJM
         bu+7W75LEmdXn+ikVwDLM3Z/AU/AFeK44mA9Xv37pwrXLG79oCWCHPOeJyYP+/S52nPj
         0zCgVJ4x263MvEqUsc2Plm9xAl0DTIn2meYiCcas6SMYnQOkWp2MZwqDiHSYOFBlddvO
         b3Dg==
X-Gm-Message-State: AAQBX9c9Rny72eWFHcMs7B77cvUtnBikgkUdZuMVs1FOhr2laFmZceMs
        TJ2mHKlRF4cY8Dn0s08rFR4=
X-Google-Smtp-Source: AKy350aou3ekqdEv1AmYmuJIzUpY9augs9/NpgSD9Hdfv4oTmMl+FDy9Ovq+2DeTaldPP79lxq+pcg==
X-Received: by 2002:a7b:c7c8:0:b0:3ed:b094:3c93 with SMTP id z8-20020a7bc7c8000000b003edb0943c93mr5887766wmk.23.1681549725732;
        Sat, 15 Apr 2023 02:08:45 -0700 (PDT)
Received: from lucifer.home ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.googlemail.com with ESMTPSA id c8-20020a05600c0a4800b003ee5fa61f45sm9990707wmq.3.2023.04.15.02.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 02:08:45 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v2 5/7] io_uring: rsrc: use FOLL_SAME_FILE on pin_user_pages()
Date:   Sat, 15 Apr 2023 10:08:42 +0100
Message-Id: <362e96284273ef0781df0116b6491ce97b0fe073.1681547405.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681547405.git.lstoakes@gmail.com>
References: <cover.1681547405.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
prevents io_pin_pages() from pinning pages spanning multiple VMAs with
permitted characteristics (anon/huge), requiring that all VMAs share the
same vm_file.

The newly introduced FOLL_SAME_FILE flag permits this to be expressed as a
GUP flag rather than having to retrieve VMAs to perform the check.

We then only need to perform a VMA lookup for the first VMA to assert the
anon/hugepage requirement as we know the rest of the VMAs will possess the
same characteristics.

Doing this eliminates the one instance of vmas being used by
pin_user_pages().

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 io_uring/rsrc.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7a43aed8e395..adc860bcbd4f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1141,9 +1141,8 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
-	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
-	int i, pret, ret = -ENOMEM;
+	int pret, ret = -ENOMEM;
 
 	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
@@ -1153,31 +1152,26 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	if (!pages)
 		goto done;
 
-	vmas = kvmalloc_array(nr_pages, sizeof(struct vm_area_struct *),
-			      GFP_KERNEL);
-	if (!vmas)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
-	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages, vmas);
+
+	pret = pin_user_pages(ubuf, nr_pages,
+			      FOLL_WRITE | FOLL_LONGTERM | FOLL_SAME_FILE,
+			      pages, NULL);
 	if (pret == nr_pages) {
-		struct file *file = vmas[0]->vm_file;
+		/*
+		 * lookup the first VMA, we require that all VMAs in range
+		 * maintain the same file characteristics, as enforced by
+		 * FOLL_SAME_FILE
+		 */
+		struct vm_area_struct *vma = vma_lookup(current->mm, ubuf);
+		struct file *file;
 
 		/* don't support file backed memory */
-		for (i = 0; i < nr_pages; i++) {
-			if (vmas[i]->vm_file != file) {
-				ret = -EINVAL;
-				break;
-			}
-			if (!file)
-				continue;
-			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
-				ret = -EOPNOTSUPP;
-				break;
-			}
-		}
+		file = vma->vm_file;
+		if (file && !vma_is_shmem(vma) && !is_file_hugepages(file))
+			ret = -EOPNOTSUPP;
+
 		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
@@ -1194,7 +1188,6 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	}
 	ret = 0;
 done:
-	kvfree(vmas);
 	if (ret < 0) {
 		kvfree(pages);
 		pages = ERR_PTR(ret);
-- 
2.40.0

