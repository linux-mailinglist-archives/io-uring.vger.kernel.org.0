Return-Path: <io-uring+bounces-11138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2175FCC633E
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4480B30F956B
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C26F2D7813;
	Wed, 17 Dec 2025 06:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="480JPtH2"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409532D7801;
	Wed, 17 Dec 2025 06:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951867; cv=none; b=Z1uoef8F9IpAoovYl8BxmIMfHgTEDaOuyyxAUffZGz2g00xLKYRqpX8IL50fUqEmPE5s9thr/Xvz+TJDHPjVoTyXmV+K7pY9UphS2/xYx93iRVjc2+JyZcuesI6wQboVtdNszz2yX2aZslgL/ryQQfooCoBFy7KqCS+BVpXSglM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951867; c=relaxed/simple;
	bh=okOrwgLi68XFQp+zfVuzGqGKku/vIvp0bDxiBuooDCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHbBF+4LGohuGuZzyBGp5ZJZ+qgo2m8WavMJ459DOoUJ8DbgH659OzfkhRS6pJEUEhyipjijYwO9iRCBjhNvxb7EFG040iuVs3OlGWA9l/O9bfXOh2ycl9USr9+lBWJoiWeRvB/OriAQAonqYvSdB3sL1DoUdUBh+uMqmIqgJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=480JPtH2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=a/hGAZJqhu3hxsPVnEixVnV2WWMDltJPBUM8q6tr0wA=; b=480JPtH2QoDCSeDHd2ZG973xFA
	MEIEfWvKgEHtlPJssnHWh6vFXsITXaomgOIfQbXibqC3sydDOmTliBf1kIRr+3xD5XNk0WbZ/VEcF
	EzxA6XdG30HaxpIhk7SXrc3pO47LqWhEEa2zIWmqmcoXMQf7QfvUiu0P8mt+hjqWSGdv9HxJpNCAk
	1F/R+ev9TfdkmENOfOE8aIDKiyP4vTsKQe2kKvBapQkGqj6KiBcXZHvF60qt8lygUDo1AZ04FJDZg
	81o9prZE/RQvQiJo5FUS7esxXlUr1LJYdro8PQo2/kCS1ULzFhGMf3ds1gGWF3ldabk6WUBPHbwfY
	u1LYRj0w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVkkZ-00000006Ddf-0Az9;
	Wed, 17 Dec 2025 06:11:03 +0000
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
Subject: [PATCH 05/10] fs: allow error returns from inode_update_timestamps
Date: Wed, 17 Dec 2025 07:09:38 +0100
Message-ID: <20251217061015.923954-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217061015.923954-1-hch@lst.de>
References: <20251217061015.923954-1-hch@lst.de>
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
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/inode.c    |  8 +++++---
 fs/inode.c          | 24 ++++++++++++++++--------
 fs/nfs/inode.c      |  4 ++--
 fs/orangefs/inode.c |  5 ++++-
 fs/ubifs/file.c     |  2 +-
 include/linux/fs.h  |  2 +-
 6 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 317db7d10a21..3ca8d294770e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6349,13 +6349,15 @@ static int btrfs_dirty_inode(struct btrfs_inode *inode)
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
index 17ecb7bb5067..2c0d69f7fd01 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2095,14 +2095,18 @@ static bool relatime_need_update(struct vfsmount *mnt, struct inode *inode,
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
 
@@ -2119,7 +2123,7 @@ int inode_update_timestamps(struct inode *inode, int flags)
 		now = current_time(inode);
 	}
 
-	if (flags & S_ATIME) {
+	if (*flags & S_ATIME) {
 		struct timespec64 atime = inode_get_atime(inode);
 
 		if (!timespec64_equal(&now, &atime)) {
@@ -2127,7 +2131,9 @@ int inode_update_timestamps(struct inode *inode, int flags)
 			updated |= S_ATIME;
 		}
 	}
-	return updated;
+
+	*flags = updated;
+	return 0;
 }
 EXPORT_SYMBOL(inode_update_timestamps);
 
@@ -2145,10 +2151,12 @@ EXPORT_SYMBOL(inode_update_timestamps);
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
index 84049f3cd340..221816524c66 100644
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
index d7275990ffa4..3b58f31bd54f 100644
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
index ec1bb9f43acc..71540644a931 100644
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
index 66d3d18cf4e3..75d5f38b08c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2399,7 +2399,7 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 void iput_not_last(struct inode *);
-int inode_update_timestamps(struct inode *inode, int flags);
+int inode_update_timestamps(struct inode *inode, int *flags);
 int generic_update_time(struct inode *inode, int flags);
 
 /* /sys/fs */
-- 
2.47.3


