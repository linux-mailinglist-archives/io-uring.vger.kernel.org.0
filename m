Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95266E689B
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjDRPt2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 11:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbjDRPtS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 11:49:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FF7CC17;
        Tue, 18 Apr 2023 08:49:16 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r15so6214208wmo.1;
        Tue, 18 Apr 2023 08:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681832955; x=1684424955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HeNjOFrTuZuCuhpkRwg6ivljw7cwq/rMRsd+qVjznzY=;
        b=RxtxdKNe4EOZeD/rsX9M86UlJh03a7oh+S5LkToD8wsEvZ7jKSdBSVphhFX2sOoDAJ
         bGzpAmPKEejxjg71GV52q7a27iyL/xYy4M/d2kApUF7C+GZ+i6FY2vODi6xC59fYPoKX
         c+ffAJ2BlU+6VKn6AhApQvJ4O+X8GOQrRqOzCoMjjEYTHeon9FGJpOWOo8nVtRq5dUSY
         /k/khXDfWND879oTdy2gnPRzduT+fU2tXidyBOXmbllH62qMwYg4xOhgBDPojHgESj5i
         guCcOU/kpK4NndpXwN8LmeA2Ce3BkwTQv/1Bnqhj2uDLwF2BOWRuyAOyl5jBHW0QJa1g
         Sg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681832955; x=1684424955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HeNjOFrTuZuCuhpkRwg6ivljw7cwq/rMRsd+qVjznzY=;
        b=UUEW0ADlMuQTOV33lilbDpUn6jRK0rXcu9E4RLjulsBqW3WV/ynUlmT4SvtWMeLFZ4
         rQILCoreDCZqAmgYAW/ZM39SPTc591APu6nSgouBceh9adMdQnGE4makwqYWPhiqy7nU
         cv1uJJme4MPnyn9PJ3DyodLdrxfTpgtKR6eIklUo+PiC4w01woQvzmaJRTNQ9TVbFtIX
         qPjY5ER8fc6YLpZBi2bCkRWQRNDABx4mO6y+j8/yZZ+wGps9yc+FlEfFjXUL2p3mLkJC
         hHN+XZU+0wnTnLFzZLRRUYFFGx5da7wO/ytlQUFc9ri1JqEguQv/lJ+sHXVGlg3OfPUn
         o9WQ==
X-Gm-Message-State: AAQBX9dtY0I/GUeUJdmwCS450go/gnMGNh0EARz8jYKiVM2eEjTnUhFJ
        TJcOo5RxTiyqsfpWCDKd+G8=
X-Google-Smtp-Source: AKy350Zx/7jVACHVDEd59MlmNb4yh3Qa9I4tP2Z8+vUyRAqrt3dGiF4TfRMd44P/Wpn+tmYhFgyqMQ==
X-Received: by 2002:a7b:ce97:0:b0:3f1:6fea:790a with SMTP id q23-20020a7bce97000000b003f16fea790amr7103576wmj.30.1681832954636;
        Tue, 18 Apr 2023 08:49:14 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id k10-20020a7bc40a000000b003f1736fdfedsm6708400wmi.10.2023.04.18.08.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 08:49:13 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in pin_user_pages()
Date:   Tue, 18 Apr 2023 16:49:12 +0100
Message-Id: <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681831798.git.lstoakes@gmail.com>
References: <cover.1681831798.git.lstoakes@gmail.com>
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

We are shortly to remove pin_user_pages(), and instead perform the required
VMA checks ourselves. In most cases there will be a single VMA so this
should caues no undue impact on an already slow path.

Doing this eliminates the one instance of vmas being used by
pin_user_pages().

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 io_uring/rsrc.c | 55 ++++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7a43aed8e395..3a927df9d913 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1138,12 +1138,37 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
+static int check_vmas_locked(unsigned long addr, unsigned long len)
+{
+	struct file *file;
+	VMA_ITERATOR(vmi, current->mm, addr);
+	struct vm_area_struct *vma = vma_next(&vmi);
+	unsigned long end = addr + len;
+
+	if (WARN_ON_ONCE(!vma))
+		return -EINVAL;
+
+	file = vma->vm_file;
+	if (file && !is_file_hugepages(file))
+		return -EOPNOTSUPP;
+
+	/* don't support file backed memory */
+	for_each_vma_range(vmi, vma, end) {
+		if (vma->vm_file != file)
+			return -EINVAL;
+
+		if (file && !vma_is_shmem(vma))
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
-	struct vm_area_struct **vmas = NULL;
 	struct page **pages = NULL;
-	int i, pret, ret = -ENOMEM;
+	int pret, ret = -ENOMEM;
 
 	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
@@ -1153,31 +1178,14 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	if (!pages)
 		goto done;
 
-	vmas = kvmalloc_array(nr_pages, sizeof(struct vm_area_struct *),
-			      GFP_KERNEL);
-	if (!vmas)
-		goto done;
-
 	ret = 0;
 	mmap_read_lock(current->mm);
+
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages, vmas);
-	if (pret == nr_pages) {
-		struct file *file = vmas[0]->vm_file;
+			      pages, NULL);
 
-		/* don't support file backed memory */
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
+	if (pret == nr_pages) {
+		ret = check_vmas_locked(ubuf, len);
 		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
@@ -1194,7 +1202,6 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	}
 	ret = 0;
 done:
-	kvfree(vmas);
 	if (ret < 0) {
 		kvfree(pages);
 		pages = ERR_PTR(ret);
-- 
2.40.0

