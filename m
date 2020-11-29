Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1189B2C7704
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbgK2Auu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729994AbgK2Aus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:48 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3CAC061A4A;
        Sat, 28 Nov 2020 16:50:08 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id l4so1305526pgu.5;
        Sat, 28 Nov 2020 16:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5zZtbdH284IqbpK8B6kvHiDlmI2ESe79oqrn5JS6ws=;
        b=dJQyQEm4sbZgkQ4dENWnDByIiLsTUQLCpMn5lFiv6hGj9EI1tZ4FMxvfCLdL+g0ioX
         sNpqOIAo54usFcPJkhE/5+EKX1U+OXbzitT1KPARw35ovpJB1LkcQe6eSCi2yn/2yd8M
         w+JUPpNieEFZrQU9JDCyMiTxjFgeaS0mD0pLkq3bgUyw+03j1mW3GUagC9xeT9lWZuxX
         E8g7xRNusPLmO2O+80rMKf0VDQEUNROsxwHOvHoQqMN6P8scQWY/gc8Y7K56oH8xEY48
         cZNDg9fWACRtrDawGTR5NKZeacfSf5hzViiKmfwCoZoSdhemW0wX5eXlTR3oR7AI6pPm
         fKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5zZtbdH284IqbpK8B6kvHiDlmI2ESe79oqrn5JS6ws=;
        b=NBbWUMTaLqpaoHh3mIefhrbdT/jB13txj6CEr/nxEQ2J2otqyrmTIdII0u5VE6todZ
         Ro6FoCRgSdetaDPdD4PDGHv5xc3eDANA+TH2aip5KjBjOhzee09cT30jefzpa5/kYbO4
         ZVI7Pljd0Ro9Ulsmk6+i927mIBnxiUyrGuihpu2rmFsLcBY+7ykch9MnnYWgp2lwCQCF
         BT8D/fBFs9t99LHk3OHhtSnAAlUT7YiNk4WckDYGfQJd6g3F2EU66QZO34gCXvht8k/G
         T1zngv07GJ5K5k0RIQVCc5RrFIUbZHZS0uycHyTO2LnMhAjdJmwoFF5j14RchD554GpV
         1VWQ==
X-Gm-Message-State: AOAM531GuVUpWXHp+Thl1qCfqaq7PX6fUcOcTEv9qoByiViAogfVW/qy
        OusjzYHoqxpb+H1QB9d+EOKhkrQXO6G79A==
X-Google-Smtp-Source: ABdhPJwS/77yFW8lfb4leVTCpQ0K/Hm99fjNxOrtp24akvAml+w8CeCJ4JKC9KwiKvJ2AvDSfCyHTg==
X-Received: by 2002:a17:90a:ead3:: with SMTP id ev19mr2775582pjb.106.1606611007873;
        Sat, 28 Nov 2020 16:50:07 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:07 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 09/13] fs/userfaultfd: use iov_iter for copy/zero
Date:   Sat, 28 Nov 2020 16:45:44 -0800
Message-Id: <20201129004548.1619714-10-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Use iov_iter for copy and zero ioctls. This is done in preparation to
support a write_iter() interface that would provide similar services as
UFFDIO_COPY/ZERO.

In the case of UFFDIO_ZERO, the iov_iter is not really used for any
purpose other than providing the length of the range that is zeroed.

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c              | 21 ++++++--
 include/linux/hugetlb.h       |  4 +-
 include/linux/mm.h            |  6 +--
 include/linux/shmem_fs.h      |  2 +-
 include/linux/userfaultfd_k.h | 10 ++--
 mm/hugetlb.c                  | 12 +++--
 mm/memory.c                   | 36 ++++++-------
 mm/shmem.c                    | 17 +++----
 mm/userfaultfd.c              | 96 +++++++++++++++++------------------
 9 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index db1a963f6ae2..7bbee2a00d37 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1914,6 +1914,8 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
 	struct uffdio_copy uffdio_copy;
 	struct uffdio_copy __user *user_uffdio_copy;
 	struct userfaultfd_wake_range range;
+	struct iov_iter iter;
+	struct iovec iov;
 
 	user_uffdio_copy = (struct uffdio_copy __user *) arg;
 
@@ -1940,10 +1942,15 @@ static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
 		goto out;
 	if (uffdio_copy.mode & ~(UFFDIO_COPY_MODE_DONTWAKE|UFFDIO_COPY_MODE_WP))
 		goto out;
+
+	ret = import_single_range(READ, (__force void __user *)uffdio_copy.src,
+				  uffdio_copy.len, &iov, &iter);
+	if (unlikely(ret))
+		return ret;
+
 	if (mmget_not_zero(ctx->mm)) {
-		ret = mcopy_atomic(ctx->mm, uffdio_copy.dst, uffdio_copy.src,
-				   uffdio_copy.len, &ctx->mmap_changing,
-				   uffdio_copy.mode);
+		ret = mcopy_atomic(ctx->mm, uffdio_copy.dst, &iter,
+				   &ctx->mmap_changing, uffdio_copy.mode);
 		mmput(ctx->mm);
 	} else {
 		return -ESRCH;
@@ -1971,6 +1978,8 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
 	struct uffdio_zeropage uffdio_zeropage;
 	struct uffdio_zeropage __user *user_uffdio_zeropage;
 	struct userfaultfd_wake_range range;
+	struct iov_iter iter;
+	struct iovec iov;
 
 	user_uffdio_zeropage = (struct uffdio_zeropage __user *) arg;
 
@@ -1992,10 +2001,12 @@ static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
 	if (uffdio_zeropage.mode & ~UFFDIO_ZEROPAGE_MODE_DONTWAKE)
 		goto out;
 
+	ret = import_single_range(READ, (__force void __user *)0,
+				  uffdio_zeropage.range.len, &iov, &iter);
+
 	if (mmget_not_zero(ctx->mm)) {
 		ret = mfill_zeropage(ctx->mm, uffdio_zeropage.range.start,
-				     uffdio_zeropage.range.len,
-				     &ctx->mmap_changing);
+				     &iter, &ctx->mmap_changing);
 		mmput(ctx->mm);
 	} else {
 		return -ESRCH;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index ebca2ef02212..2f3452e0bb84 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -137,7 +137,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm, pte_t *dst_pte,
 				struct vm_area_struct *dst_vma,
 				unsigned long dst_addr,
-				unsigned long src_addr,
+				struct iov_iter *iter,
 				struct page **pagep);
 int hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
@@ -312,7 +312,7 @@ static inline int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 						pte_t *dst_pte,
 						struct vm_area_struct *dst_vma,
 						unsigned long dst_addr,
-						unsigned long src_addr,
+						struct iov_iter *iter,
 						struct page **pagep)
 {
 	BUG();
diff --git a/include/linux/mm.h b/include/linux/mm.h
index db6ae4d3fb4e..1f183c441d89 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3085,10 +3085,10 @@ extern void copy_user_huge_page(struct page *dst, struct page *src,
 				unsigned long addr_hint,
 				struct vm_area_struct *vma,
 				unsigned int pages_per_huge_page);
-extern long copy_huge_page_from_user(struct page *dst_page,
-				const void __user *usr_src,
+extern long copy_huge_page_from_iter(struct page *dst_page,
+				size_t offset, struct iov_iter *iter,
 				unsigned int pages_per_huge_page,
-				bool allow_pagefault);
+				bool atomic);
 
 /**
  * vma_is_special_huge - Are transhuge page-table entries considered special?
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index a5a5d1d4d7b1..1973bb1c6a10 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -122,7 +122,7 @@ extern void shmem_uncharge(struct inode *inode, long pages);
 extern int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
 				  struct vm_area_struct *dst_vma,
 				  unsigned long dst_addr,
-				  unsigned long src_addr,
+				  struct iov_iter *iter,
 				  struct page **pagep);
 extern int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
 				    pmd_t *dst_pmd,
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a8e5f3ea9bb2..b5c1be67b0d7 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -35,12 +35,10 @@ extern int sysctl_unprivileged_userfaultfd;
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
 extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
-			    unsigned long src_start, unsigned long len,
-			    bool *mmap_changing, __u64 mode);
-extern ssize_t mfill_zeropage(struct mm_struct *dst_mm,
-			      unsigned long dst_start,
-			      unsigned long len,
-			      bool *mmap_changing);
+			    struct iov_iter *iter, bool *mmap_changing,
+			    __u64 mode);
+extern ssize_t mfill_zeropage(struct mm_struct *dst_mm, unsigned long dst_start,
+			      struct iov_iter *iter, bool *mmap_changing);
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
 			       bool enable_wp, bool *mmap_changing);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 37f15c3c24dc..3aa779123dfe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4603,7 +4603,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 			    pte_t *dst_pte,
 			    struct vm_area_struct *dst_vma,
 			    unsigned long dst_addr,
-			    unsigned long src_addr,
+			    struct iov_iter *iter,
 			    struct page **pagep)
 {
 	struct address_space *mapping;
@@ -4622,13 +4622,15 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 		if (IS_ERR(page))
 			goto out;
 
-		ret = copy_huge_page_from_user(page,
-						(const void __user *) src_addr,
-						pages_per_huge_page(h), false);
+		pagefault_disable();
+
+		ret = copy_huge_page_from_iter(page, 0, iter,
+						pages_per_huge_page(h), true);
+
+		pagefault_enable();
 
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
-			ret = -ENOENT;
 			*pagep = page;
 			/* don't free the page */
 			goto out;
diff --git a/mm/memory.c b/mm/memory.c
index c48f8df6e502..650f1ba19812 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5178,33 +5178,29 @@ void copy_user_huge_page(struct page *dst, struct page *src,
 	process_huge_page(addr_hint, pages_per_huge_page, copy_subpage, &arg);
 }
 
-long copy_huge_page_from_user(struct page *dst_page,
-				const void __user *usr_src,
-				unsigned int pages_per_huge_page,
-				bool allow_pagefault)
+long copy_huge_page_from_iter(struct page *dst_page,
+			      size_t offset,
+			      struct iov_iter *iter,
+			      unsigned int pages_per_huge_page,
+			      bool atomic)
 {
-	void *src = (void *)usr_src;
-	void *page_kaddr;
 	unsigned long i, rc = 0;
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
+	unsigned long of_in_page = offset_in_page(offset);
 
-	for (i = 0; i < pages_per_huge_page; i++) {
-		if (allow_pagefault)
-			page_kaddr = kmap(dst_page + i);
-		else
-			page_kaddr = kmap_atomic(dst_page + i);
-		rc = copy_from_user(page_kaddr,
-				(const void __user *)(src + i * PAGE_SIZE),
-				PAGE_SIZE);
-		if (allow_pagefault)
-			kunmap(dst_page + i);
-		else
-			kunmap_atomic(page_kaddr);
+	for (i = offset / PAGE_SIZE; i < pages_per_huge_page; i++) {
+		size_t bytes = PAGE_SIZE - of_in_page;
+
+		rc = __copy_page_from_iter(dst_page + i, of_in_page,
+					   bytes, iter, atomic);
 
-		ret_val -= (PAGE_SIZE - rc);
-		if (rc)
+		ret_val -= rc;
+
+		if (rc != bytes)
 			break;
 
+		of_in_page = 0;
+
 		cond_resched();
 	}
 	return ret_val;
diff --git a/mm/shmem.c b/mm/shmem.c
index 537c137698f8..77232cf8bd49 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2361,7 +2361,7 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 				  pmd_t *dst_pmd,
 				  struct vm_area_struct *dst_vma,
 				  unsigned long dst_addr,
-				  unsigned long src_addr,
+				  struct iov_iter *iter,
 				  bool zeropage,
 				  struct page **pagep)
 {
@@ -2371,7 +2371,6 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 	gfp_t gfp = mapping_gfp_mask(mapping);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	spinlock_t *ptl;
-	void *page_kaddr;
 	struct page *page;
 	pte_t _dst_pte, *dst_pte;
 	int ret;
@@ -2387,18 +2386,14 @@ static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 			goto out_unacct_blocks;
 
 		if (!zeropage) {	/* mcopy_atomic */
-			page_kaddr = kmap_atomic(page);
-			ret = copy_from_user(page_kaddr,
-					     (const void __user *)src_addr,
-					     PAGE_SIZE);
-			kunmap_atomic(page_kaddr);
+			ret = __copy_page_from_iter(page, 0, PAGE_SIZE, iter, true);
 
 			/* fallback to copy_from_user outside mmap_lock */
 			if (unlikely(ret)) {
 				*pagep = page;
 				shmem_inode_unacct_blocks(inode, 1);
 				/* don't free the page */
-				return -ENOENT;
+				return ret;
 			}
 		} else {		/* mfill_zeropage_atomic */
 			clear_highpage(page);
@@ -2484,11 +2479,11 @@ int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm,
 			   pmd_t *dst_pmd,
 			   struct vm_area_struct *dst_vma,
 			   unsigned long dst_addr,
-			   unsigned long src_addr,
+			   struct iov_iter *iter,
 			   struct page **pagep)
 {
 	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
-				      dst_addr, src_addr, false, pagep);
+				      dst_addr, iter, false, pagep);
 }
 
 int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
@@ -2499,7 +2494,7 @@ int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
 	struct page *page = NULL;
 
 	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
-				      dst_addr, 0, true, &page);
+				      dst_addr, NULL, true, &page);
 }
 
 #ifdef CONFIG_TMPFS
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 9a3d451402d7..ee77fb229185 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -15,6 +15,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
 #include <linux/shmem_fs.h>
+#include <linux/uio.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
@@ -48,17 +49,20 @@ struct vm_area_struct *find_dst_vma(struct mm_struct *dst_mm,
 	return dst_vma;
 }
 
+/*
+ * mcopy_atomic_pte() -Returns error of the number of bytes that were not
+ * copied.
+ */
 static int mcopy_atomic_pte(struct mm_struct *dst_mm,
 			    pmd_t *dst_pmd,
 			    struct vm_area_struct *dst_vma,
 			    unsigned long dst_addr,
-			    unsigned long src_addr,
+			    struct iov_iter *iter,
 			    struct page **pagep,
 			    bool wp_copy)
 {
 	pte_t _dst_pte, *dst_pte;
 	spinlock_t *ptl;
-	void *page_kaddr;
 	int ret;
 	struct page *page;
 	pgoff_t offset, max_off;
@@ -70,17 +74,13 @@ static int mcopy_atomic_pte(struct mm_struct *dst_mm,
 		if (!page)
 			goto out;
 
-		page_kaddr = kmap_atomic(page);
-		ret = copy_from_user(page_kaddr,
-				     (const void __user *) src_addr,
-				     PAGE_SIZE);
-		kunmap_atomic(page_kaddr);
+		ret = __copy_page_from_iter(page, 0, PAGE_SIZE, iter, true);
 
 		/* fallback to copy_from_user outside mmap_lock */
-		if (unlikely(ret)) {
-			ret = -ENOENT;
+		if (unlikely(ret != PAGE_SIZE)) {
 			*pagep = page;
 			/* don't free the page */
+			ret = PAGE_SIZE - ret;
 			goto out;
 		}
 	} else {
@@ -205,7 +205,7 @@ static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
 static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 					      struct vm_area_struct *dst_vma,
 					      unsigned long dst_start,
-					      unsigned long src_start,
+					      struct iov_iter *iter,
 					      unsigned long len,
 					      bool zeropage)
 {
@@ -213,7 +213,7 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	ssize_t err;
 	pte_t *dst_pte;
-	unsigned long src_addr, dst_addr;
+	unsigned long dst_addr;
 	long copied;
 	struct page *page;
 	unsigned long vma_hpagesize;
@@ -232,7 +232,6 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 		return -EINVAL;
 	}
 
-	src_addr = src_start;
 	dst_addr = dst_start;
 	copied = 0;
 	page = NULL;
@@ -272,7 +271,7 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 			goto out_unlock;
 	}
 
-	while (src_addr < src_start + len) {
+	while (iov_iter_count(iter) > 0) {
 		pte_t dst_pteval;
 
 		BUG_ON(dst_addr >= dst_start + len);
@@ -306,7 +305,7 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 		}
 
 		err = hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma,
-						dst_addr, src_addr, &page);
+						dst_addr, iter, &page);
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		i_mmap_unlock_read(mapping);
@@ -314,14 +313,14 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
+		if (unlikely(err > 0)) {
+			size_t offset = vma_hpagesize - err;
+
 			mmap_read_unlock(dst_mm);
 			BUG_ON(!page);
 
-			err = copy_huge_page_from_user(page,
-						(const void __user *)src_addr,
-						vma_hpagesize / PAGE_SIZE,
-						true);
+			err = copy_huge_page_from_iter(page, offset, iter,
+						vma_hpagesize / PAGE_SIZE, false);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
@@ -330,12 +329,12 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 
 			dst_vma = NULL;
 			goto retry;
-		} else
-			BUG_ON(page);
+		} else {
+			BUG_ON(err != 0 && page);
+		}
 
 		if (!err) {
 			dst_addr += vma_hpagesize;
-			src_addr += vma_hpagesize;
 			copied += vma_hpagesize;
 
 			if (fatal_signal_pending(current))
@@ -415,7 +414,7 @@ static __always_inline ssize_t mfill_atomic_pte(struct mm_struct *dst_mm,
 						pmd_t *dst_pmd,
 						struct vm_area_struct *dst_vma,
 						unsigned long dst_addr,
-						unsigned long src_addr,
+						struct iov_iter *iter,
 						struct page **page,
 						bool zeropage,
 						bool wp_copy)
@@ -435,7 +434,7 @@ static __always_inline ssize_t mfill_atomic_pte(struct mm_struct *dst_mm,
 	if (!(dst_vma->vm_flags & VM_SHARED)) {
 		if (!zeropage)
 			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
-					       dst_addr, src_addr, page,
+					       dst_addr, iter, page,
 					       wp_copy);
 		else
 			err = mfill_zeropage_pte(dst_mm, dst_pmd,
@@ -445,30 +444,34 @@ static __always_inline ssize_t mfill_atomic_pte(struct mm_struct *dst_mm,
 		if (!zeropage)
 			err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd,
 						     dst_vma, dst_addr,
-						     src_addr, page);
+						     iter, page);
 		else
 			err = shmem_mfill_zeropage_pte(dst_mm, dst_pmd,
 						       dst_vma, dst_addr);
 	}
 
+	if (zeropage && err >= 0)
+		iov_iter_advance(iter, PAGE_SIZE - err);
+
 	return err;
 }
 
 static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 					      unsigned long dst_start,
-					      unsigned long src_start,
-					      unsigned long len,
+					      struct iov_iter *iter,
 					      bool zeropage,
 					      bool *mmap_changing,
 					      __u64 mode)
 {
+	unsigned long len = iov_iter_count(iter);
 	struct vm_area_struct *dst_vma;
 	ssize_t err;
 	pmd_t *dst_pmd;
-	unsigned long src_addr, dst_addr;
+	unsigned long dst_addr;
 	long copied;
 	struct page *page;
 	bool wp_copy;
+	unsigned long remaining = iov_iter_count(iter);
 
 	/*
 	 * Sanitize the command parameters:
@@ -477,10 +480,8 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 	BUG_ON(len & ~PAGE_MASK);
 
 	/* Does the address range wrap, or is the span zero-sized? */
-	BUG_ON(src_start + len <= src_start);
 	BUG_ON(dst_start + len <= dst_start);
 
-	src_addr = src_start;
 	dst_addr = dst_start;
 	copied = 0;
 	page = NULL;
@@ -527,7 +528,7 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 	 */
 	if (is_vm_hugetlb_page(dst_vma))
 		return  __mcopy_atomic_hugetlb(dst_mm, dst_vma, dst_start,
-						src_start, len, zeropage);
+						iter, len, zeropage);
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
@@ -542,10 +543,10 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 	    unlikely(anon_vma_prepare(dst_vma)))
 		goto out_unlock;
 
-	while (src_addr < src_start + len) {
+	while (remaining > 0) {
 		pmd_t dst_pmdval;
 
-		BUG_ON(dst_addr >= dst_start + len);
+		BUG_ON(dst_addr >= dst_start + remaining);
 
 		dst_pmd = mm_alloc_pmd(dst_mm, dst_addr);
 		if (unlikely(!dst_pmd)) {
@@ -577,31 +578,29 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 		BUG_ON(pmd_trans_huge(*dst_pmd));
 
 		err = mfill_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
-				       src_addr, &page, zeropage, wp_copy);
+				       iter, &page, zeropage, wp_copy);
 		cond_resched();
 
-		if (unlikely(err == -ENOENT)) {
-			void *page_kaddr;
+		if (unlikely(err > 0)) {
+			size_t bytes = err;
+			size_t offset = PAGE_SIZE - bytes;
 
 			mmap_read_unlock(dst_mm);
 			BUG_ON(!page);
 
-			page_kaddr = kmap(page);
-			err = copy_from_user(page_kaddr,
-					     (const void __user *) src_addr,
-					     PAGE_SIZE);
-			kunmap(page);
+			err = copy_page_from_iter(page, offset, bytes, iter);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
 			}
 			goto retry;
 		} else
-			BUG_ON(page);
+			BUG_ON(err != 0 && page);
+
+		remaining = iov_iter_count(iter);
 
 		if (!err) {
 			dst_addr += PAGE_SIZE;
-			src_addr += PAGE_SIZE;
 			copied += PAGE_SIZE;
 
 			if (fatal_signal_pending(current))
@@ -623,17 +622,16 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 }
 
 ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
-		     unsigned long src_start, unsigned long len,
-		     bool *mmap_changing, __u64 mode)
+		     struct iov_iter *iter, bool *mmap_changing, __u64 mode)
 {
-	return __mcopy_atomic(dst_mm, dst_start, src_start, len, false,
-			      mmap_changing, mode);
+	return __mcopy_atomic(dst_mm, dst_start, iter, false, mmap_changing,
+			      mode);
 }
 
 ssize_t mfill_zeropage(struct mm_struct *dst_mm, unsigned long start,
-		       unsigned long len, bool *mmap_changing)
+		       struct iov_iter *iter, bool *mmap_changing)
 {
-	return __mcopy_atomic(dst_mm, start, 0, len, true, mmap_changing, 0);
+	return __mcopy_atomic(dst_mm, start, iter, true, mmap_changing, 0);
 }
 
 int mwriteprotect_range(struct mm_struct *dst_mm, unsigned long start,
-- 
2.25.1

