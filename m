Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C2B6E2CDA
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 01:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjDNX22 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 19:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjDNX21 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 19:28:27 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97455A5E6;
        Fri, 14 Apr 2023 16:27:55 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f169350e6cso19505e9.1;
        Fri, 14 Apr 2023 16:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681514869; x=1684106869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GS8ed+C9TZSDKqE7yJs3rXmG1XU+tjMZxFV1EPCP0I=;
        b=PlJksDxUb5hQplwDvFaxMJP0+U8KcfMstaXF/Ydg3scwoxrJw6uTWy//QIrOU+Z1ZU
         uvZBfEzsO8dwMd0hFEXuz6FbNobdiojzzqmx4wCRgvt3WqO/jAM96chSioBfCyimq9MW
         1Plxl2L+tI875o1BfeLrCMsG88RovrZ4W6Y0pt7lLykXy5oPJHYI0FiMII0YdaW9Qd3t
         /tMILivNmVgHap7jcjKg8GN4D91a+P8BtTebvVb4rOcwy+zaWtlwiLIv/vg/hHU9Z1fZ
         Sp+fQ0SXbMDe9NEBbWWDyCjalOKIMy3b/96mq8y7D42eveTU+xCmbnFChq+NnsB8FVXa
         B1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681514869; x=1684106869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GS8ed+C9TZSDKqE7yJs3rXmG1XU+tjMZxFV1EPCP0I=;
        b=XOD1dEsaB+t9EYPFvC9ktnHlThAhJgbNd4txoqjvfK+bLDlAu/iscHbx5rQwEIAe2P
         NTYLAn+lp4N2fwAxJrxDlIIAYL/In63Qjncx5Cwi0YXxsXUabm+Sy0IScMyDFJdQKE8R
         WzSm01RyjXq7Z/ilAocRDzE9AzqtJ4QOmddtYToG61H1kOXkj9lN5HVDfgwCbZFOhPWc
         quj3A2NWJ2miiKIptxkTG4ZNdceappO8opv5a1PXPwc98gz6dOAO+dZV5ck+JUAm3bvl
         h03P+mnVkmYTOBLp/yPFW9RQzEkuEpnlJEoamnyAHSaJFXjj+/GbOrqqKD9eeDNZWkEj
         EOdQ==
X-Gm-Message-State: AAQBX9drEsoik5p1WjQO4Wee0z3tshfOz4F7iT9MhBsMeQbxTRx+5LPd
        oahWIwACqg9oPaG6lVLW1io=
X-Google-Smtp-Source: AKy350aEKRNl4yEmWU3ls2e43huE46hCf94U9FbgI4T18fJMMqHHLwHuUQ5mYJ4TA1JhCVprgp02FA==
X-Received: by 2002:a5d:6107:0:b0:2ef:b2fc:7e8f with SMTP id v7-20020a5d6107000000b002efb2fc7e8fmr221640wrt.42.1681514869607;
        Fri, 14 Apr 2023 16:27:49 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id c11-20020a7bc84b000000b003ed2384566fsm5348810wml.21.2023.04.14.16.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 16:27:48 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on pin_user_pages()
Date:   Sat, 15 Apr 2023 00:27:45 +0100
Message-Id: <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681508038.git.lstoakes@gmail.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
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

