Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D67D6E3143
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 14:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjDOMJ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 08:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjDOMJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 08:09:46 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24E59EDB;
        Sat, 15 Apr 2023 05:09:34 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f09ec7a5c6so3720935e9.2;
        Sat, 15 Apr 2023 05:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681560572; x=1684152572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogbzg8OyWbIWXrChHJ9Cs2MTyuvpbtikA67CTEycjjg=;
        b=caKhPvxuQxF4KgsYZ2h7A9kGXFx/HVLs5+b1E8jpXvmkRbh5hbUgTMIc9WSAuMO6Ly
         jTYLKrBLpZi6/0WhGV9z/aqQ5Pxo/3kkEAx3o+LVW213AtNMndeAAnq2g5hhIMMNJAzc
         yXOWEjtSbi7UQBtuH3VmDsWexLmGFjSvBTy3TKK9WAuFHpG8guRq7BRYyfoqhjPvcPX4
         E6IJRhFlaRvWRGR4xIKyRL5K9ObYsekxLCXxEzjWNCldXy/01x2RhZ91qg1qnK3h4MY1
         T5+DH4QohG0gqfmP8ZI1d2zSq8QDoh9utsJOmSxsduIK8KcT7x7c/F/RM7zxoi9YGKMW
         Ndlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681560572; x=1684152572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogbzg8OyWbIWXrChHJ9Cs2MTyuvpbtikA67CTEycjjg=;
        b=KhYIHx3Ou+MbjsF14MDcnid00WlMUrXTzVSP/LD0f2j9oGhxnBMSakUT/zbm9HGS12
         OSVWXHUqxZAtIH8PvF8neC61Lxp+C/+GsuPiuhiybdnkXZXBYo9f3JuhCd2kZmvhxId8
         Nta95tlcUmDtaoQFwaS1mdrG/qSlkxuheEkK6clTgmOrf9yel/4N/yZiW8c0e3roSpLd
         7oMpg1a/UuJLddqMgzFDm02U8nu6/cfnSELZfWA8xdqOjkKnsgAgmUxJeqtogWBrKtLJ
         pdTG25T987Nes9siSRyhca/iDO5eNDL0CVBjuwpp5/daCF6FGXHU3hbO3LlNXw0vb+fg
         TGAA==
X-Gm-Message-State: AAQBX9flledA/paRY5kobRbgEtZpzTH/Ng5tzyu/QkAKuoG1HT3PbEus
        npEyTCw5t7UMs2ha8RGakpE=
X-Google-Smtp-Source: AKy350bwP6PWorDhaoLcU09MiqExRCfP6vqBOwGgiv4blXxkUTfR0MfB3ffsxDJBsvhcGMj8Lvo56w==
X-Received: by 2002:adf:ec88:0:b0:2cf:2dcc:3421 with SMTP id z8-20020adfec88000000b002cf2dcc3421mr1382084wrn.5.1681560572590;
        Sat, 15 Apr 2023 05:09:32 -0700 (PDT)
Received: from lucifer.home ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.googlemail.com with ESMTPSA id x14-20020adfdd8e000000b002efb4f2d240sm999141wrl.87.2023.04.15.05.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 05:09:31 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v3 5/7] io_uring: rsrc: use FOLL_SAME_FILE on pin_user_pages()
Date:   Sat, 15 Apr 2023 13:09:30 +0100
Message-Id: <b67cc6876574b010acad1e6b221032883d172d0d.1681558407.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681558407.git.lstoakes@gmail.com>
References: <cover.1681558407.git.lstoakes@gmail.com>
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
 io_uring/rsrc.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 7a43aed8e395..56de4d7bfc2b 100644
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
@@ -1153,31 +1152,29 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
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
 
-		/* don't support file backed memory */
-		for (i = 0; i < nr_pages; i++) {
-			if (vmas[i]->vm_file != file) {
-				ret = -EINVAL;
-				break;
-			}
-			if (!file)
-				continue;
-			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
+		if (WARN_ON_ONCE(!vma)) {
+			ret = -EINVAL;
+		} else {
+			/* don't support file backed memory */
+			file = vma->vm_file;
+			if (file && !vma_is_shmem(vma) && !is_file_hugepages(file))
 				ret = -EOPNOTSUPP;
-				break;
-			}
 		}
+
 		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
@@ -1194,7 +1191,6 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	}
 	ret = 0;
 done:
-	kvfree(vmas);
 	if (ret < 0) {
 		kvfree(pages);
 		pages = ERR_PTR(ret);
-- 
2.40.0

