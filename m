Return-Path: <io-uring+bounces-11669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BD431D1C63E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CFB24309F8C9
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726E232E68F;
	Wed, 14 Jan 2026 04:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="vkzyzs4E"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1442F7449;
	Wed, 14 Jan 2026 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=BCDtkNQHGCy1f6PwnU15wZvmA04zl97oKoupKBVcNe2Q4dLEAUt9+M+bGII6SIYk6MiLWRmi4bprrps10ctwETYbUe/6uedEg9Udq+5S9xRcnxl0l262X3prTHiMbs0T/bLfVSZqiVVYfjGPPdHaOjeJg6GYO6rN0ByGjlVTEUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=eXKVmukn3ymqplJ5Nf+zMmgxI0ovB5ZcpB+UI18vaPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRZzLNbmEAinD9tgyr6xJ92B9d/s6IstnNB5aiPr/9y7Gw6OyEGfWBvjg6C0kfr5Pfv11tK6A9mtwha4iQEdGWobGELAzX1wITCjDQzBB26iUuL6x0kO2oDsoukLp0xX2aYyYI7kG6BrConO73kclWVmv0EUY9sr1zkyBEDEen4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=vkzyzs4E; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fmXZq62g6UELg+AE+ZD10sFlI/M451x/DE+rYFKzrjo=; b=vkzyzs4EBwxkCV3by6GdzEeBNa
	eFwLFqzsqeZjugGpPkmI5KdHWG2pls7/28914DV0qTnROOdUa0fTdMyY7u5t2o2FhoEVOV1swEoTK
	3+hobTh/4GHf7Rkg2MUydLioY3CjqgfiT998CtlH4IdluODH+oP6gRGbn5CwvduZy9qjs7DOC4fxX
	oP8Uj+ePhx0/V8JDzpHYnc1rSzm+nM9TzUa/hvQyc9g7Uf+9pnmVn5yRCMUVSKj2uWsArhLg48jkC
	D3gvjnKxDR+cXOGz51sPYZSPE6I/7Z6rA9/BK6QXRxKuo2+2hbvWfYxlVmmDYBLlYLpO86wwVPu8j
	DvIIStag==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZG-0000000GIoM-2Tuk;
	Wed, 14 Jan 2026 04:33:14 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 33/68] simplify the callers of file_open_name()
Date: Wed, 14 Jan 2026 04:32:35 +0000
Message-ID: <20260114043310.3885463-34-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

It accepts ERR_PTR() for name and does the right thing in that case.
That allows to simplify the logics in callers, making them trivial
to switch to CLASS(filename).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/open.c        | 10 ++--------
 kernel/acct.c    |  4 +---
 mm/huge_memory.c | 15 +++------------
 mm/swapfile.c    | 21 +++------------------
 4 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index ac8dedea8daf..7254eda9f4a5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1398,14 +1398,8 @@ struct file *file_open_name(struct filename *name, int flags, umode_t mode)
  */
 struct file *filp_open(const char *filename, int flags, umode_t mode)
 {
-	struct filename *name = getname_kernel(filename);
-	struct file *file = ERR_CAST(name);
-
-	if (!IS_ERR(name)) {
-		file = file_open_name(name, flags, mode);
-		putname(name);
-	}
-	return file;
+	CLASS(filename_kernel, name)(filename);
+	return file_open_name(name, flags, mode);
 }
 EXPORT_SYMBOL(filp_open);
 
diff --git a/kernel/acct.c b/kernel/acct.c
index 2a2b3c874acd..812808e5b1b8 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -218,7 +218,6 @@ static int acct_on(const char __user *name)
 	/* Difference from BSD - they don't do O_APPEND */
 	const int open_flags = O_WRONLY|O_APPEND|O_LARGEFILE;
 	struct pid_namespace *ns = task_active_pid_ns(current);
-	struct filename *pathname __free(putname) = getname(name);
 	struct file *original_file __free(fput) = NULL;	// in that order
 	struct path internal __free(path_put) = {};	// in that order
 	struct file *file __free(fput_sync) = NULL;	// in that order
@@ -226,8 +225,7 @@ static int acct_on(const char __user *name)
 	struct vfsmount *mnt;
 	struct fs_pin *old;
 
-	if (IS_ERR(pathname))
-		return PTR_ERR(pathname);
+	CLASS(filename, pathname)(name);
 	original_file = file_open_name(pathname, open_flags, 0);
 	if (IS_ERR(original_file))
 		return PTR_ERR(original_file);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..a6d37902b73d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4692,23 +4692,18 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 				pgoff_t off_end, unsigned int new_order,
 				long in_folio_offset)
 {
-	struct filename *file;
 	struct file *candidate;
 	struct address_space *mapping;
-	int ret = -EINVAL;
 	pgoff_t index;
 	int nr_pages = 1;
 	unsigned long total = 0, split = 0;
 	unsigned int min_order;
 	unsigned int target_order;
 
-	file = getname_kernel(file_path);
-	if (IS_ERR(file))
-		return ret;
-
+	CLASS(filename_kernel, file)(file_path);
 	candidate = file_open_name(file, O_RDONLY, 0);
 	if (IS_ERR(candidate))
-		goto out;
+		return -EINVAL;
 
 	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
 		 file_path, off_start, off_end, new_order, in_folio_offset);
@@ -4757,12 +4752,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 	}
 
 	filp_close(candidate, NULL);
-	ret = 0;
-
 	pr_debug("%lu of %lu file-backed THP split\n", split, total);
-out:
-	putname(file);
-	return ret;
+	return 0;
 }
 
 #define MAX_INPUT_BUF_SZ 255
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46d2008e4b99..25120cf7c480 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2831,7 +2831,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	struct filename *pathname;
 	unsigned int maxpages;
 	int err, found = 0;
 
@@ -2840,14 +2839,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	BUG_ON(!current->mm);
 
-	pathname = getname(specialfile);
-	if (IS_ERR(pathname))
-		return PTR_ERR(pathname);
-
+	CLASS(filename, pathname)(specialfile);
 	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
-	err = PTR_ERR(victim);
 	if (IS_ERR(victim))
-		goto out;
+		return PTR_ERR(victim);
 
 	mapping = victim->f_mapping;
 	spin_lock(&swap_lock);
@@ -2964,8 +2959,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 out_dput:
 	filp_close(victim, NULL);
-out:
-	putname(pathname);
 	return err;
 }
 
@@ -3392,7 +3385,6 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *si;
-	struct filename *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
 	struct dentry *dentry;
@@ -3422,12 +3414,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	INIT_WORK(&si->discard_work, swap_discard_work);
 	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
 
-	name = getname(specialfile);
-	if (IS_ERR(name)) {
-		error = PTR_ERR(name);
-		name = NULL;
-		goto bad_swap;
-	}
+	CLASS(filename, name)(specialfile);
 	swap_file = file_open_name(name, O_RDWR | O_LARGEFILE | O_EXCL, 0);
 	if (IS_ERR(swap_file)) {
 		error = PTR_ERR(swap_file);
@@ -3635,8 +3622,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 out:
 	if (!IS_ERR_OR_NULL(folio))
 		folio_release_kmap(folio, swap_header);
-	if (name)
-		putname(name);
 	if (inode)
 		inode_unlock(inode);
 	return error;
-- 
2.47.3


