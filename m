Return-Path: <io-uring+bounces-10686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F432C7269A
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 07:53:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 2EF2B2C14A
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD22D3019CB;
	Thu, 20 Nov 2025 06:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oZzRVCMW"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC612E541F;
	Thu, 20 Nov 2025 06:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621436; cv=none; b=rq9wYp+OG7eLQhidLDYAv3teKbumE3HKB6FI3W6CfVX4rcr/rS4Lqn34Md/BoHFFaaEG0mLx8vd7PWQ+1n9AjSzyEjD26FsmQovH8ijaj1UxboYh9pjOKCr7ZvO5PxE2wX8vuO0ovO+gVJzWo/dkxUsEGT6O9k4ZY4EemyIYfxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621436; c=relaxed/simple;
	bh=8RQuYZtmZOhSBP6VBVaux5+xlBPUciV40wL+l/obf3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upvSMbuBr7w9F8E/tZJD5KdEsEpp8ah2tkGhu20rTNI8qR5Is9fMVVipCKzWJiUHF9j1KtfpYbWmNuiJVMXu3PLQS24CHrlfq3AFl+6FVdWFz4OSqgiqKqoiocTbcmmIR1Jr625irsrRihV/eTkIYgvQwi/lHU+voCWwnRoRzBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oZzRVCMW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Owjo2UjA4NIjI42zoeMtcCMbICtYJ5/7TKH091BB2iw=; b=oZzRVCMWoUD1SccPyN+yyBGoT+
	lg/w1k7o4PAM+mUx5yPhJG+ffydYpAbfoLbrRxV67u+M9+KZ3LiIpxFjsqhZxbeGJ5WlD9pTgV9UY
	lvD7RxzkeTlZRi9tKnPrRiAX6/DndpG/hHBq6Njke/6s91G0/mvS6ear2ecQ4Ghp+XuCin/hYvwRa
	pQ8LJlZmMB7yxIWTSPLBNzy8HiJpYGtCASGlO7RvEGKAbwH+tOchOiB4NB7Wq257SsZc1ikyihsFN
	7Hi0otE/dKkFgQ2kvwoWAOip8cCTC58sgN1J+kNS2rGCjMD/xNltuekg7LonjPMCqleqZ1A7xHAqt
	ZXkSQH/Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyUy-00000006FBP-1AW2;
	Thu, 20 Nov 2025 06:50:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>,
	Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 11/16] fs: allow error returns from inode_update_timestamps
Date: Thu, 20 Nov 2025 07:47:32 +0100
Message-ID: <20251120064859.2911749-12-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120064859.2911749-1-hch@lst.de>
References: <20251120064859.2911749-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Change flags to a by reference argument so that it can be updated so that
the return value can be used for error returns.  This will be used to
implement non-blocking timestamp updates.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c    |  8 +++++---
 fs/inode.c          | 24 ++++++++++++++++--------
 fs/nfs/inode.c      |  4 ++--
 fs/orangefs/inode.c |  5 ++++-
 fs/ubifs/file.c     |  2 +-
 include/linux/fs.h  |  2 +-
 6 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 05f6d272c5d7..668e4a1df7ae 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6297,13 +6297,15 @@ static int btrfs_dirty_inode(struct btrfs_inode *inode)
 static int btrfs_update_time(struct inode *inode, int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	bool dirty;
+	int error;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
-	dirty = inode_update_timestamps(inode, flags);
-	return dirty ? btrfs_dirty_inode(BTRFS_I(inode)) : 0;
+	error = inode_update_timestamps(inode, &flags);
+	if (error || !flags)
+		return error;
+	return btrfs_dirty_inode(BTRFS_I(inode));
 }
 
 /*
diff --git a/fs/inode.c b/fs/inode.c
index edbc24a489ca..5b338de7a4c6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2057,14 +2057,18 @@ static bool relatime_need_update(struct vfsmount *mnt, struct inode *inode,
  * attempt to update all three of them. S_ATIME updates can be handled
  * independently of the rest.
  *
- * Returns a set of S_* flags indicating which values changed.
+ * Updates @flags to contain the S_* flags which actually need changing.  This
+ * can drop flags from the input when they don't need an update, or can add
+ * S_VERSION when the version needs to be bumped.
+ *
+ * Returns 0 or a negative errno.
  */
-int inode_update_timestamps(struct inode *inode, int flags)
+int inode_update_timestamps(struct inode *inode, int *flags)
 {
 	int updated = 0;
 	struct timespec64 now;
 
-	if (flags & (S_MTIME|S_CTIME|S_VERSION)) {
+	if (*flags & (S_MTIME | S_CTIME | S_VERSION)) {
 		struct timespec64 ctime = inode_get_ctime(inode);
 		struct timespec64 mtime = inode_get_mtime(inode);
 
@@ -2081,7 +2085,7 @@ int inode_update_timestamps(struct inode *inode, int flags)
 		now = current_time(inode);
 	}
 
-	if (flags & S_ATIME) {
+	if (*flags & S_ATIME) {
 		struct timespec64 atime = inode_get_atime(inode);
 
 		if (!timespec64_equal(&now, &atime)) {
@@ -2089,7 +2093,9 @@ int inode_update_timestamps(struct inode *inode, int flags)
 			updated |= S_ATIME;
 		}
 	}
-	return updated;
+
+	*flags = updated;
+	return 0;
 }
 EXPORT_SYMBOL(inode_update_timestamps);
 
@@ -2107,10 +2113,12 @@ EXPORT_SYMBOL(inode_update_timestamps);
  */
 int generic_update_time(struct inode *inode, int flags)
 {
-	flags = inode_update_timestamps(inode, flags);
-	if (flags)
+	int error;
+
+	error = inode_update_timestamps(inode, &flags);
+	if (!error && flags)
 		mark_inode_dirty_time(inode, flags);
-	return 0;
+	return error;
 }
 EXPORT_SYMBOL(generic_update_time);
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 13ad70fc00d8..f7d5d23cd927 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -671,8 +671,8 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 
 static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
 {
-	enum file_time_flags time_flags = 0;
 	unsigned int cache_flags = 0;
+	int time_flags = 0;
 
 	if (ia_valid & ATTR_MTIME) {
 		time_flags |= S_MTIME | S_CTIME;
@@ -682,7 +682,7 @@ static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
 		time_flags |= S_ATIME;
 		cache_flags |= NFS_INO_INVALID_ATIME;
 	}
-	inode_update_timestamps(inode, time_flags);
+	inode_update_timestamps(inode, &time_flags);
 	NFS_I(inode)->cache_validity &= ~cache_flags;
 }
 
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 55f6c8026812..ec56a777053d 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -875,11 +875,14 @@ int orangefs_permission(struct mnt_idmap *idmap,
 int orangefs_update_time(struct inode *inode, int flags)
 {
 	struct iattr iattr;
+	int error;
 
 	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
 	    get_khandle_from_ino(inode));
 
-	flags = inode_update_timestamps(inode, flags);
+	error = inode_update_timestamps(inode, &flags);
+	if (error || !flags)
+		return error;
 
 	memset(&iattr, 0, sizeof iattr);
         if (flags & S_ATIME)
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 3e119cb93ea9..7f631473da6c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1387,7 +1387,7 @@ int ubifs_update_time(struct inode *inode, int flags)
 		return err;
 
 	mutex_lock(&ui->ui_mutex);
-	inode_update_timestamps(inode, flags);
+	inode_update_timestamps(inode, &flags);
 	release = ui->dirty;
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 	mutex_unlock(&ui->ui_mutex);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b4d82e5c6c32..a6a38e30c998 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2825,7 +2825,7 @@ extern int current_umask(void);
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 void iput_not_last(struct inode *);
-int inode_update_timestamps(struct inode *inode, int flags);
+int inode_update_timestamps(struct inode *inode, int *flags);
 int generic_update_time(struct inode *inode, int flags);
 
 /* /sys/fs */
-- 
2.47.3


