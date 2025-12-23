Return-Path: <io-uring+bounces-11282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D2572CD78FF
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 60D33301F7E6
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D942521D58B;
	Tue, 23 Dec 2025 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xHjQTPFE"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC3E213E89;
	Tue, 23 Dec 2025 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450315; cv=none; b=qVx9+BX/UI1Zw7HrpHWoMQQYUhHZ1tUwFE3v9d89Z63THliup+/EV722nmd8J0rc0BEzmcC8p8pOhdD1BefRPVubv66wDEDeWbrDv7zPm7Qny26+a2ME6hZOiB6yCDQ7wTop+vrrzB/9XxFV7PQ53UAtKGDApoCwcNmiBgNAoqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450315; c=relaxed/simple;
	bh=02jwja2mFnK7IUu9FyFc4wEXpetK9T86ekJ2eQqy7ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/QyK95l5h4fVixJth5NmuSJBed8I/KuNYcrtWLvahF+/VZWr4UQStThoubVc3yMWA4BK78qs2sHd8pwVRCR5BsksPhD4lXKP8ezeAXVQJ2iu/qfGjdi5uBr/bvokH1j9hoDzrezuNfRHTBjP2KFKyAQKZYJjIH1a/NchYCXVho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xHjQTPFE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JYculw36y8vPPKOTahkzD78mhvcJELW76SRDvO4CaAc=; b=xHjQTPFEeZqNRMqe5RJxk1orOU
	URiGbcYt3RjLThVIaGXSqJwQis3FyYI2rBXYVm2peDSK4zmATc32UW80LHmCI7MCbMJiiTVOfhDbj
	9SM2fLT89clgbyuz7BM9zFJ+yji7wnOw25TXwEsEiWek4IYk7OPARnmW3OGHi4U96l3J/hJC2Qv/l
	kQ8Fh+YgKJzLMdsloHTFnZC+BB7K+WPCsSHnagDwR1u5ZhiLlI4aTwyVJx0FXVmw+AF3f6fjIrhOm
	R5Ni5z1eEpmwLtDkAEJ2PFbCBuL2Axeo1lytteVy0NV5yaBMDx3LGLnCe76sMR7fBwyBbawwgfBVJ
	N/0CsN4Q==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqQ3-0000000EIqa-2GeB;
	Tue, 23 Dec 2025 00:38:31 +0000
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
Subject: [PATCH 05/11] fs: return I_DIRTY_* and allow error returns from inode_update_timestamps
Date: Tue, 23 Dec 2025 09:37:48 +0900
Message-ID: <20251223003756.409543-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003756.409543-1-hch@lst.de>
References: <20251223003756.409543-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Change the inode_update_timestamps calling convention, so that instead
of returning the updated flags that are only needed to calculate the
I_DIRTY_* flags, return the I_DIRTY_* flags diretly in an argument, and
reserve the return value to return an error code, which will be needed to
support non-blocking timestamp updates.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c    |  8 +++++---
 fs/inode.c          | 44 ++++++++++++++++++++++++++++----------------
 fs/nfs/inode.c      |  4 ++--
 fs/orangefs/inode.c |  5 ++++-
 fs/ubifs/file.c     |  4 ++--
 include/linux/fs.h  |  2 +-
 6 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 317db7d10a21..b04842c83eef 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6349,13 +6349,15 @@ static int btrfs_dirty_inode(struct btrfs_inode *inode)
 static int btrfs_update_time(struct inode *inode, int flags)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	bool dirty;
+	int dirty_flags, error;
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
-	dirty = inode_update_timestamps(inode, flags);
-	return dirty ? btrfs_dirty_inode(BTRFS_I(inode)) : 0;
+	error = inode_update_timestamps(inode, flags, &dirty_flags);
+	if (error || !dirty_flags)
+		return error;
+	return btrfs_dirty_inode(BTRFS_I(inode));
 }
 
 /*
diff --git a/fs/inode.c b/fs/inode.c
index 19f50bdb6f7d..59fffb1dbdeb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2081,10 +2081,18 @@ static bool relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 	return false;
 }
 
+static inline int timestamp_dirty_flag(struct super_block *sb)
+{
+	if (sb->s_flags & SB_LAZYTIME)
+		return I_DIRTY_TIME;
+	return I_DIRTY_SYNC;
+}
+
 /**
  * inode_update_timestamps - update the timestamps on the inode
  * @inode: inode to be updated
  * @flags: S_* flags that needed to be updated
+ * @dirty_flags: returns the I_DIRTY_* flags for the modification
  *
  * The update_time function is called when an inode's timestamps need to be
  * updated for a read or write operation. This function handles updating the
@@ -2095,14 +2103,18 @@ static bool relatime_need_update(struct vfsmount *mnt, struct inode *inode,
  * attempt to update all three of them. S_ATIME updates can be handled
  * independently of the rest.
  *
- * Returns a set of S_* flags indicating which values changed.
+ * Sets @dirty_flags to contain the I_DIRTY_FLAG_* flags for the actual changes.
+ *
+ * Returns 0 or a negative errno.
  */
-int inode_update_timestamps(struct inode *inode, int flags)
+int inode_update_timestamps(struct inode *inode, int flags, int *dirty_flags)
 {
-	int updated = 0;
 	struct timespec64 now;
+	int updated = 0;
 
-	if (flags & (S_MTIME|S_CTIME|S_VERSION)) {
+	*dirty_flags = 0;
+
+	if (flags & (S_MTIME | S_CTIME | S_VERSION)) {
 		struct timespec64 ctime = inode_get_ctime(inode);
 		struct timespec64 mtime = inode_get_mtime(inode);
 
@@ -2124,11 +2136,17 @@ int inode_update_timestamps(struct inode *inode, int flags)
 			updated |= S_ATIME;
 	}
 
+	if (updated & (S_MTIME | S_CTIME | S_MTIME))
+		*dirty_flags |= timestamp_dirty_flag(inode->i_sb);
+	if (updated & S_VERSION)
+		*dirty_flags |= I_DIRTY_SYNC;
+
 	if (updated & S_MTIME)
 		inode_set_mtime_to_ts(inode, now);
 	if (updated & S_ATIME)
 		inode_set_atime_to_ts(inode, now);
-	return updated;
+
+	return 0;
 }
 EXPORT_SYMBOL(inode_update_timestamps);
 
@@ -2146,18 +2164,12 @@ EXPORT_SYMBOL(inode_update_timestamps);
  */
 int generic_update_time(struct inode *inode, int flags)
 {
-	int updated = inode_update_timestamps(inode, flags);
-	int dirty_flags = 0;
-
-	if (!updated)
-		return 0;
+	int dirty_flags, error;
 
-	if (updated & (S_ATIME|S_MTIME|S_CTIME))
-		dirty_flags = inode->i_sb->s_flags & SB_LAZYTIME ? I_DIRTY_TIME : I_DIRTY_SYNC;
-	if (updated & S_VERSION)
-		dirty_flags |= I_DIRTY_SYNC;
-	__mark_inode_dirty(inode, dirty_flags);
-	return 0;
+	error = inode_update_timestamps(inode, flags, &dirty_flags);
+	if (!error && dirty_flags)
+		__mark_inode_dirty(inode, dirty_flags);
+	return error;
 }
 EXPORT_SYMBOL(generic_update_time);
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 84049f3cd340..6dfe382cb9fa 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -671,8 +671,8 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 
 static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
 {
-	enum file_time_flags time_flags = 0;
 	unsigned int cache_flags = 0;
+	int time_flags = 0, dirty_flags;
 
 	if (ia_valid & ATTR_MTIME) {
 		time_flags |= S_MTIME | S_CTIME;
@@ -682,7 +682,7 @@ static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
 		time_flags |= S_ATIME;
 		cache_flags |= NFS_INO_INVALID_ATIME;
 	}
-	inode_update_timestamps(inode, time_flags);
+	inode_update_timestamps(inode, time_flags, &dirty_flags);
 	NFS_I(inode)->cache_validity &= ~cache_flags;
 }
 
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index d7275990ffa4..beb45690081c 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -875,11 +875,14 @@ int orangefs_permission(struct mnt_idmap *idmap,
 int orangefs_update_time(struct inode *inode, int flags)
 {
 	struct iattr iattr;
+	int error, dirty_flags;
 
 	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
 	    get_khandle_from_ino(inode));
 
-	flags = inode_update_timestamps(inode, flags);
+	error = inode_update_timestamps(inode, flags, &dirty_flags);
+	if (error || !flags)
+		return error;
 
 	memset(&iattr, 0, sizeof iattr);
         if (flags & S_ATIME)
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index ec1bb9f43acc..fe236886484c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1377,7 +1377,7 @@ int ubifs_update_time(struct inode *inode, int flags)
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_budget_req req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(ui->data_len, 8) };
-	int err, release;
+	int err, release, dirty_flags;
 
 	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
 		return generic_update_time(inode, flags);
@@ -1387,7 +1387,7 @@ int ubifs_update_time(struct inode *inode, int flags)
 		return err;
 
 	mutex_lock(&ui->ui_mutex);
-	inode_update_timestamps(inode, flags);
+	inode_update_timestamps(inode, flags, &dirty_flags);
 	release = ui->dirty;
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 	mutex_unlock(&ui->ui_mutex);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fccb0a38cb74..ec2f78db0977 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2398,7 +2398,7 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 void iput_not_last(struct inode *);
-int inode_update_timestamps(struct inode *inode, int flags);
+int inode_update_timestamps(struct inode *inode, int flags, int *dirty_flags);
 int generic_update_time(struct inode *inode, int flags);
 
 /* /sys/fs */
-- 
2.47.3


