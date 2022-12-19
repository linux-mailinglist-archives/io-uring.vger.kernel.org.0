Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6437B651070
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 17:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiLSQbR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 11:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiLSQbJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 11:31:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D889A101DD
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 08:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671467429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FTkE8SfNE6dzRFrNyVwG9cvTvjVvHRxb1O0DRwg34/g=;
        b=Ohbyf5XjMi100/t2qHyrDygf8JiXZwtN+sNIRCVfZm048o3nnuLDvcXEtizBVS5ku/r99l
        rWRQRFs2na2Pw7K34pQAddSICd8swZQ25DAScejN9djLjxMqdQ/PUNqsW5u1McLc7JhMDQ
        sPb1hXO2Fx/owgLKX3IxAat639jMDb0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-HbpgYJm1ME20S55ECx5g6Q-1; Mon, 19 Dec 2022 11:30:23 -0500
X-MC-Unique: HbpgYJm1ME20S55ECx5g6Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C64453828882;
        Mon, 19 Dec 2022 16:30:22 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A2AD40C945A;
        Mon, 19 Dec 2022 16:30:18 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH mm-stable RFC 1/2] mm/nommu: factor out check for NOMMU shared mappings into is_nommu_shared_mapping()
Date:   Mon, 19 Dec 2022 17:30:12 +0100
Message-Id: <20221219163013.259423-2-david@redhat.com>
In-Reply-To: <20221219163013.259423-1-david@redhat.com>
References: <20221219163013.259423-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want to stop using VM_MAYSHARE in private mappings to pave the way
for clarifying the semantics of VM_MAYSHARE vs. VM_SHARED and reduce
the confusion. While CONFIG_MMU uses VM_MAYSHARE to represent MAP_SHARED,
!CONFIG_MMU also sets VM_MAYSHARE for selected R/O private file mappings
that are an effective overlay of a file mapping.

Let's factor out all relevant VM_MAYSHARE checks in !CONFIG_MMU code into
is_nommu_shared_mapping() first.

Note that whenever VM_SHARED is set, VM_MAYSHARE must be set as well
(unless there is a serious BUG). So there is not need to test for VM_SHARED
manually.

No functional change intended.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/char/mem.c    |  2 +-
 fs/cramfs/inode.c     |  2 +-
 fs/proc/task_nommu.c  |  2 +-
 fs/ramfs/file-nommu.c |  2 +-
 fs/romfs/mmap-nommu.c |  2 +-
 include/linux/mm.h    | 15 +++++++++++++++
 io_uring/io_uring.c   |  2 +-
 mm/nommu.c            | 11 ++++++-----
 8 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 83bf2a4dcb57..ffb101d349f0 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -343,7 +343,7 @@ static unsigned zero_mmap_capabilities(struct file *file)
 /* can't do an in-place private mapping if there's no MMU */
 static inline int private_mapping_ok(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_MAYSHARE;
+	return is_nommu_shared_mapping(vma->vm_flags);
 }
 #else
 
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 61ccf7722fc3..50e4e060db68 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -437,7 +437,7 @@ static int cramfs_physmem_mmap(struct file *file, struct vm_area_struct *vma)
 
 static int cramfs_physmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -ENOSYS;
+	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -ENOSYS;
 }
 
 static unsigned long cramfs_physmem_get_unmapped_area(struct file *file,
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 2fd06f52b6a4..0ec35072a8e5 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -38,7 +38,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 		}
 
 		if (atomic_read(&mm->mm_count) > 1 ||
-		    vma->vm_flags & VM_MAYSHARE) {
+		    is_nommu_shared_mapping(vma->vm_flags)) {
 			sbytes += size;
 		} else {
 			bytes += size;
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index cb240eac5036..cd4537692751 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -264,7 +264,7 @@ static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
  */
 static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (!(vma->vm_flags & (VM_SHARED | VM_MAYSHARE)))
+	if (!is_nommu_shared_mapping(vma->vm_flags))
 		return -ENOSYS;
 
 	file_accessed(file);
diff --git a/fs/romfs/mmap-nommu.c b/fs/romfs/mmap-nommu.c
index 2c4a23113fb5..4578dc45e50a 100644
--- a/fs/romfs/mmap-nommu.c
+++ b/fs/romfs/mmap-nommu.c
@@ -63,7 +63,7 @@ static unsigned long romfs_get_unmapped_area(struct file *file,
  */
 static int romfs_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -ENOSYS;
+	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -ENOSYS;
 }
 
 static unsigned romfs_mmap_capabilities(struct file *file)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f3f196e4d66d..734d0bc7c7c6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1363,6 +1363,21 @@ static inline bool is_cow_mapping(vm_flags_t flags)
 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 }
 
+#ifndef CONFIG_MMU
+static inline bool is_nommu_shared_mapping(vm_flags_t flags)
+{
+	/*
+	 * NOMMU shared mappings are ordinary MAP_SHARED mappings and selected
+	 * R/O MAP_PRIVATE file mappings that are an effective R/O overlay of
+	 * a file mapping. R/O MAP_PRIVATE mappings might still modify
+	 * underlying memory if ptrace is active, so this is only possible if
+	 * ptrace does not apply. Note that there is no mprotect() to upgrade
+	 * write permissions later.
+	 */
+	return flags & VM_MAYSHARE;
+}
+#endif
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b521186efa5c..84fa23b1f782 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3174,7 +3174,7 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 
 static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_SHARED | VM_MAYSHARE) ? 0 : -EINVAL;
+	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;
 }
 
 static unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
diff --git a/mm/nommu.c b/mm/nommu.c
index 214c70e1d059..6c4bdc07a776 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -958,9 +958,10 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	 */
 	if (capabilities & NOMMU_MAP_DIRECT) {
 		ret = call_mmap(vma->vm_file, vma);
+		/* shouldn't return success if we're not sharing */
+		if (WARN_ON_ONCE(!is_nommu_shared_mapping(vma->vm_flags)))
+			ret = -ENOSYS;
 		if (ret == 0) {
-			/* shouldn't return success if we're not sharing */
-			BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
 			vma->vm_region->vm_top = vma->vm_region->vm_end;
 			return 0;
 		}
@@ -1106,7 +1107,7 @@ unsigned long do_mmap(struct file *file,
 	 *   these cases, sharing is handled in the driver or filesystem rather
 	 *   than here
 	 */
-	if (vm_flags & VM_MAYSHARE) {
+	if (is_nommu_shared_mapping(vm_flags)) {
 		struct vm_region *pregion;
 		unsigned long pglen, rpglen, pgend, rpgend, start;
 
@@ -1116,7 +1117,7 @@ unsigned long do_mmap(struct file *file,
 		for (rb = rb_first(&nommu_region_tree); rb; rb = rb_next(rb)) {
 			pregion = rb_entry(rb, struct vm_region, vm_rb);
 
-			if (!(pregion->vm_flags & VM_MAYSHARE))
+			if (!is_nommu_shared_mapping(pregion->vm_flags))
 				continue;
 
 			/* search for overlapping mappings on the same file */
@@ -1597,7 +1598,7 @@ static unsigned long do_mremap(unsigned long addr,
 	if (vma->vm_end != vma->vm_start + old_len)
 		return (unsigned long) -EFAULT;
 
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (is_nommu_shared_mapping(vma->vm_flags))
 		return (unsigned long) -EPERM;
 
 	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
-- 
2.38.1

