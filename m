Return-Path: <io-uring+bounces-1779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5CE8BD21B
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C16F31C218C9
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70BE7155A52;
	Mon,  6 May 2024 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mdcM3M4J"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342921552F7;
	Mon,  6 May 2024 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715011681; cv=none; b=XP1meAl8ALlbKEB1+GoIxH3XXtCol/5Azz6ekV0YKzaRPkOZpooXxnuOd7/SzSvlizxBUgP2nVgnCK4ThwbnHkm1CoseZKbAiTx+fCvtI/Me6vQK9/Vddck9VvYhH9xEYdFi5dvMPY60UGnYJru0wTxdPaev4lJxYQWHB0IdeWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715011681; c=relaxed/simple;
	bh=2IOd66RSOqQqrKQkuMh3XogGiLvLLMV7lnIQ5ZnGbPE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ab+S3ejjGcxj4AmsJYFwHp1MJ4UeIqbizPvsOHQ+JUzWEi7gxTAl5fcSlM7/bj3HmrWP9mSa/5epd+xCS1HcqFVb+leMOnPQTJCc7C5xtwAEmDjx8MgJ3n+yvRNb+v4erKGANSsZuJ6HiaH/7evuEYtmnd19B0ueSzRe7Mhdv+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mdcM3M4J; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715011679; x=1746547679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2IOd66RSOqQqrKQkuMh3XogGiLvLLMV7lnIQ5ZnGbPE=;
  b=mdcM3M4JAswq+Hj/4Jf8yuJJzZ01cw/1YIbVCq41wSpETdlk/y+wCCKG
   Zm5wngIWty+CYyYkYBxJboRiH5P5Sp7aMxzCLDqTo+c4sWsxLXg0gx0iZ
   ICjxPI7MQGO4zSU25v8UzZkJVkuasCkw+113Id0SpRZecPk/3CK4JUCL2
   X2Gp/ANFecJKEF7RfXSUX5GxkGd3k1fJeXjnni6M/P+yMGpWIG6PZcOqK
   AQuzxwxWUTTCuBffe/10Q4i3vtKMFf3Fwd6/YQr79alcEMS7Rrek/qjga
   OmWUC8WaxWZlYmWg7BWc5+uBSNvvny8mI8bPfuX9l+Eq9r5VkSyxvBgJb
   Q==;
X-CSE-ConnectionGUID: NLhT/Lx7Qmu2o7wZa+FILQ==
X-CSE-MsgGUID: BDduzWQaQ6Knn/Zh12Op3g==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21440400"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="21440400"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 09:07:58 -0700
X-CSE-ConnectionGUID: u2l7s34lSJ6s3YOUXNviqw==
X-CSE-MsgGUID: +dIdv11yQnK7uo5bWilyRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="32705046"
Received: from haabdall-mobl.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.82.8])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 09:07:57 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: akpm@linux-foundation.org
Cc: rick.p.edgecombe@intel.com,
	Liam.Howlett@oracle.com,
	bp@alien8.de,
	bpf@vger.kernel.org,
	broonie@kernel.org,
	christophe.leroy@csgroup.eu,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	debug@rivosinc.com,
	hpa@zytor.com,
	io-uring@vger.kernel.org,
	keescook@chromium.org,
	kirill.shutemov@linux.intel.com,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	luto@kernel.org,
	mingo@redhat.com,
	nvdimm@lists.linux.dev,
	peterz@infradead.org,
	sparclinux@vger.kernel.org,
	tglx@linutronix.de,
	x86@kernel.org
Subject: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Date: Mon,  6 May 2024 09:07:47 -0700
Message-Id: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently the get_unmapped_area() pointer on mm_struct was removed in
favor of direct callable function that can determines which of two
handlers to call based on an mm flag. This function,
mm_get_unmapped_area(), checks the flag of the mm passed as an argument.

Dan Williams pointed out (see link) that all callers pass curret->mm, so
the mm argument is unneeded. It could be conceivable for a caller to want
to pass a different mm in the future, but in this case a new helper could
easily be added.

So remove the mm argument, and rename the function
current_get_unmapped_area().

Fixes: 529ce23a764f ("mm: switch mm->get_unmapped_area() to a flag")
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://lore.kernel.org/lkml/6603bed6662a_4a98a2949e@dwillia2-mobl3.amr.corp.intel.com.notmuch/
---
Based on linux-next.
---
 arch/sparc/kernel/sys_sparc_64.c |  9 +++++----
 arch/x86/kernel/cpu/sgx/driver.c |  2 +-
 drivers/char/mem.c               |  2 +-
 drivers/dax/device.c             |  6 +++---
 fs/proc/inode.c                  |  2 +-
 fs/ramfs/file-mmu.c              |  2 +-
 include/linux/sched/mm.h         |  6 +++---
 io_uring/memmap.c                |  2 +-
 kernel/bpf/arena.c               |  2 +-
 kernel/bpf/syscall.c             |  2 +-
 mm/mmap.c                        | 11 +++++------
 mm/shmem.c                       |  9 ++++-----
 12 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index d9c3b34ca744..cf0b4ace5bf9 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -220,7 +220,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 
 	if (flags & MAP_FIXED) {
 		/* Ok, don't mess with it. */
-		return mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
+		return current_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
 	}
 	flags &= ~MAP_SHARED;
 
@@ -233,8 +233,9 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 		align_goal = (64UL * 1024);
 
 	do {
-		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr,
-					    len + (align_goal - PAGE_SIZE), pgoff, flags);
+		addr = current_get_unmapped_area(NULL, orig_addr,
+						 len + (align_goal - PAGE_SIZE),
+						 pgoff, flags);
 		if (!(addr & ~PAGE_MASK)) {
 			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
 			break;
@@ -252,7 +253,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 	 * be obtained.
 	 */
 	if (addr & ~PAGE_MASK)
-		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
+		addr = current_get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
 
 	return addr;
 }
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 22b65a5f5ec6..5f7bfd9035f7 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -113,7 +113,7 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
 	if (flags & MAP_FIXED)
 		return addr;
 
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return current_get_unmapped_area(file, addr, len, pgoff, flags);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 7c359cc406d5..a29c4bd506d5 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -546,7 +546,7 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 	}
 
 	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return current_get_unmapped_area(file, addr, len, pgoff, flags);
 #else
 	return -ENOSYS;
 #endif
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index eb61598247a9..c379902307b7 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -329,14 +329,14 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 	if ((off + len_align) < off)
 		goto out;
 
-	addr_align = mm_get_unmapped_area(current->mm, filp, addr, len_align,
-					  pgoff, flags);
+	addr_align = current_get_unmapped_area(filp, addr, len_align,
+					       pgoff, flags);
 	if (!IS_ERR_VALUE(addr_align)) {
 		addr_align += (off - addr_align) & (align - 1);
 		return addr_align;
 	}
  out:
-	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
 static const struct address_space_operations dev_dax_aops = {
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index d19434e2a58e..24a6aeac3de5 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -455,7 +455,7 @@ pde_get_unmapped_area(struct proc_dir_entry *pde, struct file *file, unsigned lo
 		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
 
 #ifdef CONFIG_MMU
-	return mm_get_unmapped_area(current->mm, file, orig_addr, len, pgoff, flags);
+	return current_get_unmapped_area(file, orig_addr, len, pgoff, flags);
 #endif
 
 	return orig_addr;
diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index b45c7edc3225..85f57de31102 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -35,7 +35,7 @@ static unsigned long ramfs_mmu_get_unmapped_area(struct file *file,
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags)
 {
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return current_get_unmapped_area(file, addr, len, pgoff, flags);
 }
 
 const struct file_operations ramfs_file_operations = {
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 91546493c43d..c67c7de05c7a 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -187,9 +187,9 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
 			  unsigned long flags);
 
-unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *filp,
-				   unsigned long addr, unsigned long len,
-				   unsigned long pgoff, unsigned long flags);
+unsigned long current_get_unmapped_area(struct file *filp, unsigned long addr,
+					unsigned long len, unsigned long pgoff,
+					unsigned long flags);
 
 unsigned long
 arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 4785d6af5fee..1aaea32c797c 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -305,7 +305,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 #else
 	addr = 0UL;
 #endif
-	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
 #else /* !CONFIG_MMU */
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 4a1be699bb82..054486f7c453 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -314,7 +314,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 			return -EINVAL;
 	}
 
-	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
+	ret = current_get_unmapped_area(filp, addr, len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2222c3ff88e7..d9ff2843f6ef 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -992,7 +992,7 @@ static unsigned long bpf_get_unmapped_area(struct file *filp, unsigned long addr
 	if (map->ops->map_get_unmapped_area)
 		return map->ops->map_get_unmapped_area(filp, addr, len, pgoff, flags);
 #ifdef CONFIG_MMU
-	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+	return current_get_unmapped_area(filp, addr, len, pgoff, flags);
 #else
 	return addr;
 #endif
diff --git a/mm/mmap.c b/mm/mmap.c
index 83b4682ec85c..4e98a907c53d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1901,16 +1901,15 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	return error ? error : addr;
 }
 
-unsigned long
-mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
-		     unsigned long addr, unsigned long len,
-		     unsigned long pgoff, unsigned long flags)
+unsigned long current_get_unmapped_area(struct file *file, unsigned long addr,
+					unsigned long len, unsigned long pgoff,
+					unsigned long flags)
 {
-	if (test_bit(MMF_TOPDOWN, &mm->flags))
+	if (test_bit(MMF_TOPDOWN, &current->mm->flags))
 		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags);
 	return arch_get_unmapped_area(file, addr, len, pgoff, flags);
 }
-EXPORT_SYMBOL(mm_get_unmapped_area);
+EXPORT_SYMBOL(current_get_unmapped_area);
 
 /**
  * find_vma_intersection() - Look up the first VMA which intersects the interval
diff --git a/mm/shmem.c b/mm/shmem.c
index f5d60436b604..c0acd7db93c8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2276,8 +2276,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
-	addr = mm_get_unmapped_area(current->mm, file, uaddr, len, pgoff,
-				    flags);
+	addr = current_get_unmapped_area(file, uaddr, len, pgoff, flags);
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return addr;
@@ -2334,8 +2333,8 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = mm_get_unmapped_area(current->mm, NULL, uaddr,
-					     inflated_len, 0, flags);
+	inflated_addr = current_get_unmapped_area(NULL, uaddr,
+						  inflated_len, 0, flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)
@@ -4799,7 +4798,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long addr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	return current_get_unmapped_area(file, addr, len, pgoff, flags);
 }
 #endif
 

base-commit: 9221b2819b8a4196eecf5476d66201be60fbcf29
-- 
2.34.1


