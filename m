Return-Path: <io-uring+bounces-11284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DFB74CD7953
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01A27307F55A
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E751C26462E;
	Tue, 23 Dec 2025 00:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PFaoQK+y"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF6221CC62;
	Tue, 23 Dec 2025 00:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450327; cv=none; b=Q4bTpY75h2TGp0bRbe5M3sN/i5YrYZsUUeLWtgqvN64T0shX04vZawmgHVLL7A97fBl5ecwIBMG5bFyzAj3cOa/UC3HBiLT+ut2Tk+GG83GBcgi+c7jVze9yFhnW9WCbvFlcuSx/JA02qhoagWXzanXeu2dhE+jYjejUX69nNB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450327; c=relaxed/simple;
	bh=qaOGtIky2XCtTnP0SDPywp8lOzU86xrwLAmqZfPQs6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alfr8FtE6acCkow6dZOOtk3JoAGoO8RmAo7MonAI5fbako0jOgJwqWOTTKrKHKfV4hfUZOpKb3VUmUV5dNdGp2at9UiHhnxAl72jqnIIpoOfGjfd9vR3gUph0uGLiAt+IFd9+Lx5jhAZXGF9o26jUaTISJgMSQRIdObgjIM5ru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PFaoQK+y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PEzFFfQYrzre1PDYjF58mXS0QPUnOB7YeyUziN79BhI=; b=PFaoQK+yBZAGC1SmCXraMTUMfY
	qzuGaT6BC/BlLTrZz6yP6D7G9pcUwPVv++FqfHPeVUsy1i2aSL84+gXP5m3WX3a5FQ8jdJ/p/RnT0
	f3HN8RIqqeT5WvH5iU6wskNSRIwv31/xB+l62NL8FNL9OjHlHVibOiJNvhcxSReF33daQFI16l1mR
	2pBvez0dKhbWGEH2c1u5wJPQmz/szpRfvdaf5lxj7PAdJog4gL1MAecQO8lZn1xc6cnsPzMhZFg7S
	IP0SKdX2rAjtGyhuwNaP+zfrfrOxzZiFHHa/OgPfPIi1wUlZGSstYa0mF6G3ub3HXQdoHBWu/SYk5
	yphvv0bA==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqQE-0000000EIwg-0Ovk;
	Tue, 23 Dec 2025 00:38:42 +0000
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
Subject: [PATCH 07/11] fs: add a ->sync_lazytime method
Date: Tue, 23 Dec 2025 09:37:50 +0900
Message-ID: <20251223003756.409543-8-hch@lst.de>
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

Allow the file system to explicitly implement lazytime syncing instead
of pigging back on generic inode dirtying.  This allows to simplify
the XFS implementation and prepares for non-blocking lazytime timestamp
updates.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/locking.rst |  2 ++
 Documentation/filesystems/vfs.rst     |  6 ++++++
 fs/fs-writeback.c                     | 13 +++++++++++--
 include/linux/fs.h                    |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

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
index 3d68b757136c..62658be2578b 100644
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
 
@@ -2569,6 +2572,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	trace_writeback_mark_inode_dirty(inode, flags);
 
 	if (flags & I_DIRTY_INODE) {
+		bool was_dirty_time = false;
+
 		/*
 		 * Inode timestamp update will piggback on this dirtying.
 		 * We tell ->dirty_inode callback that timestamps need to
@@ -2579,6 +2584,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			if (inode_state_read(inode) & I_DIRTY_TIME) {
 				inode_state_clear(inode, I_DIRTY_TIME);
 				flags |= I_DIRTY_TIME;
+				was_dirty_time = true;
 			}
 			spin_unlock(&inode->i_lock);
 		}
@@ -2591,9 +2597,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
index ec2f78db0977..d1d57149aa93 100644
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


