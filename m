Return-Path: <io-uring+bounces-1214-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E23DD88B73F
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 03:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 128B31C31CCE
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 02:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7079184FC9;
	Tue, 26 Mar 2024 02:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJ1aYul0"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE42C4E1A8;
	Tue, 26 Mar 2024 02:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711419440; cv=none; b=eaVfLLZ/k/BuoMkDF5iibIE+MCRvKB2wCHXhaQi5IevXb4DrtN1dp1SdsQZ6XJe+5lR6ru+nJBdZby3qyBws2hV3AsfuFLo30ScRLHKaXqruTvpZ9hw1dNFQcrGk56Lt2kvMsPjdixARwpWMghnO6eJmKGKL0Hd8v/lCuaXf5DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711419440; c=relaxed/simple;
	bh=vkTcVT9jigW1nbd2RmwlNu3cwMbNkxnWB23GTD8rbXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d2SNuDlwEJQyGnkswYsSOjCHsuYLSlen/MQbeeGYi7WQzcrwZUNihvfesdJ0vBkYGTYrsAGDiHG105byL1sO8xcl0WIqdmAhGRbo6pSn7uKnQ/kqpJ9E+4ulXD/Pn8GJYexSVNo1ocbkgarmB74j7HSB4ZUuuq2ua4+Xj1ct+rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJ1aYul0; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711419438; x=1742955438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vkTcVT9jigW1nbd2RmwlNu3cwMbNkxnWB23GTD8rbXw=;
  b=aJ1aYul0ARnSVVv04Avty7gYVlb6Kt8cEy2YEST7D+qRn2PdhsjoyruD
   uh7Xi1Bfh2+fqKcXTFGfr/OQV+cFtt1TE8AxwdRZ3BIac0wKYdb1z91Ii
   mhikUe5ea0OFn8BZqufIbx6Lpp+TVk767NK5h6nz5eZscpm1IF2MP8TO2
   PI5vEjKKAJiYc+ZDbOdv8UTTz3A9hny2Z5T4NthO0xrzUNlOrDwSwiffS
   rj+ubmWmLwc6EAzcjhZbqAtSq2jX8F8RvfNrXD7apv5Dj3aJFbXzNzKJt
   wljm9fO9eIktPttrKPQA5GCT6hL5ZgQCoVXFKApA4ChjQ/VCTOxCe9rO7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6564218"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6564218"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 19:17:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20489867"
Received: from rpwilson-mobl.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.251.11.187])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 19:17:14 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	bp@alien8.de,
	broonie@kernel.org,
	christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com,
	debug@rivosinc.com,
	hpa@zytor.com,
	keescook@chromium.org,
	kirill.shutemov@linux.intel.com,
	luto@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	x86@kernel.org
Cc: rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
Date: Mon, 25 Mar 2024 19:16:44 -0700
Message-Id: <20240326021656.202649-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240326021656.202649-1-rick.p.edgecombe@intel.com>
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mm_struct contains a function pointer *get_unmapped_area(), which
is set to either arch_get_unmapped_area() or
arch_get_unmapped_area_topdown() during the initialization of the mm.

Since the function pointer only ever points to two functions that are named
the same across all arch's, a function pointer is not really required. In
addition future changes will want to add versions of the functions that
take additional arguments. So to save a pointers worth of bytes in
mm_struct, and prevent adding additional function pointers to mm_struct in
future changes, remove it and keep the information about which
get_unmapped_area() to use in a flag.

Add the new flag to MMF_INIT_MASK so it doesn't get clobbered on fork by
mmf_init_flags(). Most MM flags get clobbered on fork. In the pre-existing
behavior mm->get_unmapped_area() would get copied to the new mm in
dup_mm(), so not clobbering the flag preserves the existing behavior
around inheriting the topdown-ness.

Introduce a helper, mm_get_unmapped_area(), to easily convert code that
refers to the old function pointer to instead select and call either
arch_get_unmapped_area() or arch_get_unmapped_area_topdown() based on the
flag. Then drop the mm->get_unmapped_area() function pointer. Leave the
get_unmapped_area() pointer in struct file_operations alone. The main
purpose of this change is to reorganize in preparation for future changes,
but it also converts the calls of mm->get_unmapped_area() from indirect
branches into a direct ones.

The stress-ng bigheap benchmark calls realloc a lot, which calls through
get_unmapped_area() in the kernel. On x86, the change yielded a ~1%
improvement there on a retpoline config.

In testing a few x86 configs, removing the pointer unfortunately didn't
result in any actual size reductions in the compiled layout of mm_struct.
But depending on compiler or arch alignment requirements, the change could
shrink the size of mm_struct.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-sgx@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org
---
v4:
 - Split out pde_get_unmapped_area() refactor into separate patch
   (Christophe Leroy)

v3:
 - Fix comment that still referred to mm->get_unmapped_area()
 - Resolve trivial rebase conflicts with "mm: thp_get_unmapped_area must
   honour topdown preference"
 - Spelling fix in log

v2:
 - Fix comment on MMF_TOPDOWN (Kirill, rppt)
 - Move MMF_TOPDOWN to actually unused bit
 - Add MMF_TOPDOWN to MMF_INIT_MASK so it doesn't get clobbered on fork,
   and result in the children using the search up path.
 - New lower performance results after above bug fix
 - Add Reviews and Acks
---
 arch/s390/mm/hugetlbpage.c       |  2 +-
 arch/s390/mm/mmap.c              |  4 ++--
 arch/sparc/kernel/sys_sparc_64.c | 15 ++++++---------
 arch/sparc/mm/hugetlbpage.c      |  2 +-
 arch/x86/kernel/cpu/sgx/driver.c |  2 +-
 arch/x86/mm/hugetlbpage.c        |  2 +-
 arch/x86/mm/mmap.c               |  4 ++--
 drivers/char/mem.c               |  2 +-
 drivers/dax/device.c             |  6 +++---
 fs/hugetlbfs/inode.c             |  4 ++--
 fs/proc/inode.c                  |  3 ++-
 fs/ramfs/file-mmu.c              |  2 +-
 include/linux/mm_types.h         |  6 +-----
 include/linux/sched/coredump.h   |  5 ++++-
 include/linux/sched/mm.h         |  5 +++++
 io_uring/io_uring.c              |  2 +-
 kernel/bpf/arena.c               |  2 +-
 kernel/bpf/syscall.c             |  2 +-
 mm/debug.c                       |  6 ------
 mm/huge_memory.c                 |  9 ++++-----
 mm/mmap.c                        | 21 ++++++++++++++++++---
 mm/shmem.c                       | 11 +++++------
 mm/util.c                        |  6 +++---
 23 files changed, 66 insertions(+), 57 deletions(-)

diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index c2e8242bd15d..219d906fe830 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -328,7 +328,7 @@ unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 			goto check_asce_limit;
 	}
 
-	if (mm->get_unmapped_area == arch_get_unmapped_area)
+	if (!test_bit(MMF_TOPDOWN, &mm->flags))
 		addr = hugetlb_get_unmapped_area_bottomup(file, addr, len,
 				pgoff, flags);
 	else
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index b14fc0887654..6b2e4436ad4a 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -185,10 +185,10 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 	 */
 	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = mmap_base_legacy(random_factor);
-		mm->get_unmapped_area = arch_get_unmapped_area;
+		clear_bit(MMF_TOPDOWN, &mm->flags);
 	} else {
 		mm->mmap_base = mmap_base(random_factor, rlim_stack);
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		set_bit(MMF_TOPDOWN, &mm->flags);
 	}
 }
 
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 1e9a9e016237..1dbf7211666e 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -218,14 +218,10 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	unsigned long align_goal, addr = -ENOMEM;
-	unsigned long (*get_area)(struct file *, unsigned long,
-				  unsigned long, unsigned long, unsigned long);
-
-	get_area = current->mm->get_unmapped_area;
 
 	if (flags & MAP_FIXED) {
 		/* Ok, don't mess with it. */
-		return get_area(NULL, orig_addr, len, pgoff, flags);
+		return mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
 	}
 	flags &= ~MAP_SHARED;
 
@@ -238,7 +234,8 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 		align_goal = (64UL * 1024);
 
 	do {
-		addr = get_area(NULL, orig_addr, len + (align_goal - PAGE_SIZE), pgoff, flags);
+		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr,
+					    len + (align_goal - PAGE_SIZE), pgoff, flags);
 		if (!(addr & ~PAGE_MASK)) {
 			addr = (addr + (align_goal - 1UL)) & ~(align_goal - 1UL);
 			break;
@@ -256,7 +253,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 	 * be obtained.
 	 */
 	if (addr & ~PAGE_MASK)
-		addr = get_area(NULL, orig_addr, len, pgoff, flags);
+		addr = mm_get_unmapped_area(current->mm, NULL, orig_addr, len, pgoff, flags);
 
 	return addr;
 }
@@ -292,7 +289,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 	    gap == RLIM_INFINITY ||
 	    sysctl_legacy_va_layout) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
-		mm->get_unmapped_area = arch_get_unmapped_area;
+		clear_bit(MMF_TOPDOWN, &mm->flags);
 	} else {
 		/* We know it's 32-bit */
 		unsigned long task_size = STACK_TOP32;
@@ -303,7 +300,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 			gap = (task_size / 6 * 5);
 
 		mm->mmap_base = PAGE_ALIGN(task_size - gap - random_factor);
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		set_bit(MMF_TOPDOWN, &mm->flags);
 	}
 }
 
diff --git a/arch/sparc/mm/hugetlbpage.c b/arch/sparc/mm/hugetlbpage.c
index b432500c13a5..38a1bef47efb 100644
--- a/arch/sparc/mm/hugetlbpage.c
+++ b/arch/sparc/mm/hugetlbpage.c
@@ -123,7 +123,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 		    (!vma || addr + len <= vm_start_gap(vma)))
 			return addr;
 	}
-	if (mm->get_unmapped_area == arch_get_unmapped_area)
+	if (!test_bit(MMF_TOPDOWN, &mm->flags))
 		return hugetlb_get_unmapped_area_bottomup(file, addr, len,
 				pgoff, flags);
 	else
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 262f5fb18d74..22b65a5f5ec6 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -113,7 +113,7 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
 	if (flags & MAP_FIXED)
 		return addr;
 
-	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 5804bbae4f01..6d77c0039617 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -141,7 +141,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	}
 
 get_unmapped_area:
-	if (mm->get_unmapped_area == arch_get_unmapped_area)
+	if (!test_bit(MMF_TOPDOWN, &mm->flags))
 		return hugetlb_get_unmapped_area_bottomup(file, addr, len,
 				pgoff, flags);
 	else
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index c90c20904a60..a2cabb1c81e1 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -129,9 +129,9 @@ static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
 void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	if (mmap_is_legacy())
-		mm->get_unmapped_area = arch_get_unmapped_area;
+		clear_bit(MMF_TOPDOWN, &mm->flags);
 	else
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		set_bit(MMF_TOPDOWN, &mm->flags);
 
 	arch_pick_mmap_base(&mm->mmap_base, &mm->mmap_legacy_base,
 			arch_rnd(mmap64_rnd_bits), task_size_64bit(0),
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 3c6670cf905f..9b80e622ae80 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -544,7 +544,7 @@ static unsigned long get_unmapped_area_zero(struct file *file,
 	}
 
 	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
-	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 #else
 	return -ENOSYS;
 #endif
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 93ebedc5ec8c..47c126d37b59 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -329,14 +329,14 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 	if ((off + len_align) < off)
 		goto out;
 
-	addr_align = current->mm->get_unmapped_area(filp, addr, len_align,
-			pgoff, flags);
+	addr_align = mm_get_unmapped_area(current->mm, filp, addr, len_align,
+					  pgoff, flags);
 	if (!IS_ERR_VALUE(addr_align)) {
 		addr_align += (off - addr_align) & (align - 1);
 		return addr_align;
 	}
  out:
-	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
 }
 
 static const struct address_space_operations dev_dax_aops = {
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6502c7e776d1..3dee18bf47ed 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -249,11 +249,11 @@ generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	}
 
 	/*
-	 * Use mm->get_unmapped_area value as a hint to use topdown routine.
+	 * Use MMF_TOPDOWN flag as a hint to use topdown routine.
 	 * If architectures have special needs, they should define their own
 	 * version of hugetlb_get_unmapped_area.
 	 */
-	if (mm->get_unmapped_area == arch_get_unmapped_area_topdown)
+	if (test_bit(MMF_TOPDOWN, &mm->flags))
 		return hugetlb_get_unmapped_area_topdown(file, addr, len,
 				pgoff, flags);
 	return hugetlb_get_unmapped_area_bottomup(file, addr, len,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 75396a24fd8c..d19434e2a58e 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -455,8 +455,9 @@ pde_get_unmapped_area(struct proc_dir_entry *pde, struct file *file, unsigned lo
 		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
 
 #ifdef CONFIG_MMU
-	return current->mm->get_unmapped_area(file, orig_addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, file, orig_addr, len, pgoff, flags);
 #endif
+
 	return orig_addr;
 }
 
diff --git a/fs/ramfs/file-mmu.c b/fs/ramfs/file-mmu.c
index c7a1aa3c882b..b45c7edc3225 100644
--- a/fs/ramfs/file-mmu.c
+++ b/fs/ramfs/file-mmu.c
@@ -35,7 +35,7 @@ static unsigned long ramfs_mmu_get_unmapped_area(struct file *file,
 		unsigned long addr, unsigned long len, unsigned long pgoff,
 		unsigned long flags)
 {
-	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 }
 
 const struct file_operations ramfs_file_operations = {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5240bd7bca33..9313e43123d4 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -777,11 +777,7 @@ struct mm_struct {
 		} ____cacheline_aligned_in_smp;
 
 		struct maple_tree mm_mt;
-#ifdef CONFIG_MMU
-		unsigned long (*get_unmapped_area) (struct file *filp,
-				unsigned long addr, unsigned long len,
-				unsigned long pgoff, unsigned long flags);
-#endif
+
 		unsigned long mmap_base;	/* base of mmap area */
 		unsigned long mmap_legacy_base;	/* base of mmap area in bottom-up allocations */
 #ifdef CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES
diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
index 02f5090ffea2..e62ff805cfc9 100644
--- a/include/linux/sched/coredump.h
+++ b/include/linux/sched/coredump.h
@@ -92,9 +92,12 @@ static inline int get_dumpable(struct mm_struct *mm)
 #define MMF_VM_MERGE_ANY	30
 #define MMF_VM_MERGE_ANY_MASK	(1 << MMF_VM_MERGE_ANY)
 
+#define MMF_TOPDOWN		31	/* mm searches top down by default */
+#define MMF_TOPDOWN_MASK	(1 << MMF_TOPDOWN)
+
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
-				 MMF_VM_MERGE_ANY_MASK)
+				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
 
 static inline unsigned long mmf_init_flags(unsigned long flags)
 {
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index b6543f9d78d6..ed1caa26c8be 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -8,6 +8,7 @@
 #include <linux/mm_types.h>
 #include <linux/gfp.h>
 #include <linux/sync_core.h>
+#include <linux/sched/coredump.h>
 
 /*
  * Routines for handling mm_structs
@@ -186,6 +187,10 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
 			  unsigned long flags);
 
+unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *filp,
+				   unsigned long addr, unsigned long len,
+				   unsigned long pgoff, unsigned long flags);
+
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d4b448fdc50..405bab0a560c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3520,7 +3520,7 @@ static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
 #else
 	addr = 0UL;
 #endif
-	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
 }
 
 #else /* !CONFIG_MMU */
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 86571e760dd6..74d566dcd2cb 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -314,7 +314,7 @@ static unsigned long arena_get_unmapped_area(struct file *filp, unsigned long ad
 			return -EINVAL;
 	}
 
-	ret = current->mm->get_unmapped_area(filp, addr, len * 2, 0, flags);
+	ret = mm_get_unmapped_area(current->mm, filp, addr, len * 2, 0, flags);
 	if (IS_ERR_VALUE(ret))
 		return ret;
 	if ((ret >> 32) == ((ret + len - 1) >> 32))
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ae2ff73bde7e..dead5e1977d8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -980,7 +980,7 @@ static unsigned long bpf_get_unmapped_area(struct file *filp, unsigned long addr
 	if (map->ops->map_get_unmapped_area)
 		return map->ops->map_get_unmapped_area(filp, addr, len, pgoff, flags);
 #ifdef CONFIG_MMU
-	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
 #else
 	return addr;
 #endif
diff --git a/mm/debug.c b/mm/debug.c
index c1c1a6a484e4..37a17f77df9f 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -180,9 +180,6 @@ EXPORT_SYMBOL(dump_vma);
 void dump_mm(const struct mm_struct *mm)
 {
 	pr_emerg("mm %px task_size %lu\n"
-#ifdef CONFIG_MMU
-		"get_unmapped_area %px\n"
-#endif
 		"mmap_base %lu mmap_legacy_base %lu\n"
 		"pgd %px mm_users %d mm_count %d pgtables_bytes %lu map_count %d\n"
 		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
@@ -208,9 +205,6 @@ void dump_mm(const struct mm_struct *mm)
 		"def_flags: %#lx(%pGv)\n",
 
 		mm, mm->task_size,
-#ifdef CONFIG_MMU
-		mm->get_unmapped_area,
-#endif
 		mm->mmap_base, mm->mmap_legacy_base,
 		mm->pgd, atomic_read(&mm->mm_users),
 		atomic_read(&mm->mm_count),
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9859aa4f7553..cede9ccb84dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -824,8 +824,8 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	ret = current->mm->get_unmapped_area(filp, addr, len_pad,
-					      off >> PAGE_SHIFT, flags);
+	ret = mm_get_unmapped_area(current->mm, filp, addr, len_pad,
+				   off >> PAGE_SHIFT, flags);
 
 	/*
 	 * The failure might be due to length padding. The caller will retry
@@ -843,8 +843,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
 
 	off_sub = (off - ret) & (size - 1);
 
-	if (current->mm->get_unmapped_area == arch_get_unmapped_area_topdown &&
-	    !off_sub)
+	if (test_bit(MMF_TOPDOWN, &current->mm->flags) && !off_sub)
 		return ret + size;
 
 	ret += off_sub;
@@ -861,7 +860,7 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (ret)
 		return ret;
 
-	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 6dbda99a47da..224e9ce1e2fd 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1813,7 +1813,8 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
 	unsigned long (*get_area)(struct file *, unsigned long,
-				  unsigned long, unsigned long, unsigned long);
+				  unsigned long, unsigned long, unsigned long)
+				  = NULL;
 
 	unsigned long error = arch_mmap_check(addr, len, flags);
 	if (error)
@@ -1823,7 +1824,6 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
-	get_area = current->mm->get_unmapped_area;
 	if (file) {
 		if (file->f_op->get_unmapped_area)
 			get_area = file->f_op->get_unmapped_area;
@@ -1842,7 +1842,11 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	if (!file)
 		pgoff = 0;
 
-	addr = get_area(file, addr, len, pgoff, flags);
+	if (get_area)
+		addr = get_area(file, addr, len, pgoff, flags);
+	else
+		addr = mm_get_unmapped_area(current->mm, file, addr, len,
+					    pgoff, flags);
 	if (IS_ERR_VALUE(addr))
 		return addr;
 
@@ -1857,6 +1861,17 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 
 EXPORT_SYMBOL(get_unmapped_area);
 
+unsigned long
+mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
+		     unsigned long addr, unsigned long len,
+		     unsigned long pgoff, unsigned long flags)
+{
+	if (test_bit(MMF_TOPDOWN, &mm->flags))
+		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags);
+	return arch_get_unmapped_area(file, addr, len, pgoff, flags);
+}
+EXPORT_SYMBOL(mm_get_unmapped_area);
+
 /**
  * find_vma_intersection() - Look up the first VMA which intersects the interval
  * @mm: The process address space.
diff --git a/mm/shmem.c b/mm/shmem.c
index 0aad0d9a621b..4078c3a1b2d0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2273,8 +2273,6 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long uaddr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
-	unsigned long (*get_area)(struct file *,
-		unsigned long, unsigned long, unsigned long, unsigned long);
 	unsigned long addr;
 	unsigned long offset;
 	unsigned long inflated_len;
@@ -2284,8 +2282,8 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
-	get_area = current->mm->get_unmapped_area;
-	addr = get_area(file, uaddr, len, pgoff, flags);
+	addr = mm_get_unmapped_area(current->mm, file, uaddr, len, pgoff,
+				    flags);
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		return addr;
@@ -2342,7 +2340,8 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = get_area(NULL, uaddr, inflated_len, 0, flags);
+	inflated_addr = mm_get_unmapped_area(current->mm, NULL, uaddr,
+					     inflated_len, 0, flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)
@@ -4807,7 +4806,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long addr, unsigned long len,
 				      unsigned long pgoff, unsigned long flags)
 {
-	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 }
 #endif
 
diff --git a/mm/util.c b/mm/util.c
index 669397235787..8619d353a1aa 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -469,17 +469,17 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 
 	if (mmap_is_legacy(rlim_stack)) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
-		mm->get_unmapped_area = arch_get_unmapped_area;
+		clear_bit(MMF_TOPDOWN, &mm->flags);
 	} else {
 		mm->mmap_base = mmap_base(random_factor, rlim_stack);
-		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
+		set_bit(MMF_TOPDOWN, &mm->flags);
 	}
 }
 #elif defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 {
 	mm->mmap_base = TASK_UNMAPPED_BASE;
-	mm->get_unmapped_area = arch_get_unmapped_area;
+	clear_bit(MMF_TOPDOWN, &mm->flags);
 }
 #endif
 
-- 
2.34.1


