Return-Path: <io-uring+bounces-11140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D0BCC6376
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:19:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C209F31157FB
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2EF2D7DD9;
	Wed, 17 Dec 2025 06:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LmUvmlcM"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6FB2D77E5;
	Wed, 17 Dec 2025 06:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951884; cv=none; b=Zb8MopV4i/c5HLlXncrhxKzBndiFNWPqSw7+iBnQRfW/zidg7bEtlGb76F56gFJjh5EthBfsF75YN3XOsr00pqv2jE+yOwOwfTl6dqUTH0PhNfwiaGA8ss1X4ToaazsXoF4VnTJWovZwM056iooZutpIgU003mPibcJOdMUqWeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951884; c=relaxed/simple;
	bh=RruMgZSxdfaggQ78oUqsYBrAaX0hyCyThWzu3AV5L5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl0ILKjOh0YtaeK3oKMTg0yxlsjQNXg4N81mzVUTegRZxATTfZhZ/m0YbLnWRDll9YRA9/lxXF2xLnsUVjJAAb27qrMgwbJMUJyMTbXL1DcYI9i4eceHDuhP7qSezdz/xbu1nO03WIvXiBdDd7njtI4vzabUJtZHca6XiJjiHI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LmUvmlcM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NJxCH4Cs09XHq379TlzGggdnfeW+Uk4V3DkiJV5EGqk=; b=LmUvmlcMeQnT+DW7R9+wD/l0lv
	PrUeS+knoqMVDTztPdmda8tN4cj5d1m7k51KA3byc9oweRjQ+b7GhqMCaqbUiStJ7vlNZdbrlwhuS
	s+VDLVFF6bAmhjeCaGO0g0XAipNYIS8QYZMAPfkB+fhlgmSWewVWhjszuc3LbTpZSqJ7SEIFvdylV
	ntiPthftAluFdMygra5e6NXVjh0afektVXaTQxeB2UmWqdLWYeZt7uEs9VqheMFNXx3CEf3op7UT5
	318TTiZ9dHXpGcUVY8AaKXHYyOlSkM88AdID3PycpcDCJOQpY3iDORIBFvXSV01/zrqwBOXIyS7cY
	ctVIn6ug==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVkkp-00000006DpG-1aBb;
	Wed, 17 Dec 2025 06:11:20 +0000
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
Subject: [PATCH 07/10] fs: add a ->sync_lazytime method
Date: Wed, 17 Dec 2025 07:09:40 +0100
Message-ID: <20251217061015.923954-8-hch@lst.de>
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

Allow the file system to explicitly implement lazytime syncing instead
of pigging back on generic inode dirtying.  This allows to simplify
the XFS implementation and prepares for non-blocking lazytime timestamp
updates.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/locking.rst |  2 ++
 Documentation/filesystems/vfs.rst     |  6 ++++++
 fs/fs-writeback.c                     | 16 +++++++++++++---
 include/linux/fs.h                    |  1 +
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 77704fde9845..9b2f14ada8cd 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -81,6 +81,7 @@ prototypes::
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
 	void (*update_time)(struct inode *, struct timespec *, int);
+	void (*sync_lazytime)(struct inode *inode);
 	int (*atomic_open)(struct inode *, struct dentry *,
 				struct file *, unsigned open_flag,
 				umode_t create_mode);
@@ -117,6 +118,7 @@ getattr:	no
 listxattr:	no
 fiemap:		no
 update_time:	no
+sync_lazytime:	no
 atomic_open:	shared (exclusive if O_CREAT is set in open flags)
 tmpfile:	no
 fileattr_get:	no or exclusive
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 670ba66b60e4..4509655d12c6 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -486,6 +486,7 @@ As of kernel 2.6.22, the following members are defined:
 		int (*getattr) (struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
 		ssize_t (*listxattr) (struct dentry *, char *, size_t);
 		void (*update_time)(struct inode *, struct timespec *, int);
+		void (*sync_lazytime)(struct inode *inode);
 		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 				   unsigned open_flag, umode_t create_mode);
 		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
@@ -642,6 +643,11 @@ otherwise noted.
 	an inode.  If this is not defined the VFS will update the inode
 	itself and call mark_inode_dirty_sync.
 
+``sync_lazytime``:
+	called by the writeback code to update the lazy time stamps to
+	regular time stamp updates that get syncing into the on-disk
+	inode.
+
 ``atomic_open``
 	called on the last component of an open.  Using this optional
 	method the filesystem can look up, possibly create and open the
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fa555e10d8b9..c2e08eaeadc8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1717,7 +1717,10 @@ bool sync_lazytime(struct inode *inode)
 		return false;
 
 	trace_writeback_lazytime(inode);
-	mark_inode_dirty_sync(inode);
+	if (inode->i_op->sync_lazytime)
+		inode->i_op->sync_lazytime(inode);
+	else
+		mark_inode_dirty_sync(inode);
 	return true;
 }
 
@@ -2569,16 +2572,20 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	trace_writeback_mark_inode_dirty(inode, flags);
 
 	if (flags & I_DIRTY_INODE) {
+		bool was_dirty_time =
+			inode_state_read_once(inode) & I_DIRTY_TIME;
+
 		/*
 		 * Inode timestamp update will piggback on this dirtying.
 		 * We tell ->dirty_inode callback that timestamps need to
 		 * be updated by setting I_DIRTY_TIME in flags.
 		 */
-		if (inode_state_read_once(inode) & I_DIRTY_TIME) {
+		if (was_dirty_time) {
 			spin_lock(&inode->i_lock);
 			if (inode_state_read(inode) & I_DIRTY_TIME) {
 				inode_state_clear(inode, I_DIRTY_TIME);
 				flags |= I_DIRTY_TIME;
+				was_dirty_time = true;
 			}
 			spin_unlock(&inode->i_lock);
 		}
@@ -2591,9 +2598,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * for just I_DIRTY_PAGES or I_DIRTY_TIME.
 		 */
 		trace_writeback_dirty_inode_start(inode, flags);
-		if (sb->s_op->dirty_inode)
+		if (sb->s_op->dirty_inode) {
 			sb->s_op->dirty_inode(inode,
 				flags & (I_DIRTY_INODE | I_DIRTY_TIME));
+		} else if (was_dirty_time && inode->i_op->sync_lazytime) {
+			inode->i_op->sync_lazytime(inode);
+		}
 		trace_writeback_dirty_inode(inode, flags);
 
 		/* I_DIRTY_INODE supersedes I_DIRTY_TIME. */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 75d5f38b08c9..255eb3b42d1d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2011,6 +2011,7 @@ struct inode_operations {
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
 	int (*update_time)(struct inode *, int);
+	void (*sync_lazytime)(struct inode *inode);
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode);
-- 
2.47.3


