Return-Path: <io-uring+bounces-11522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8538CD034F1
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 15:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 791B1301E210
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 14:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9B54FF875;
	Thu,  8 Jan 2026 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H0Hx47GU"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06F34FF842;
	Thu,  8 Jan 2026 14:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882068; cv=none; b=thYVY/OU1fYY2RACCXYvTQYbFu44mcT27M7OYagcZcDUuvYKXt9KsVEVp0KVRENjLVX701VmhD++WQDx74dBOcRvnv+wc1HSeROlM0NfgM/11+QN4ZbxS0g9O8pmXfGpElDSnIMUCH6zyg3EhTY8MN+D/r9dIvLLChpdXBONGqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882068; c=relaxed/simple;
	bh=sWRDWgR+AQbA40dgr/mtOYcKgGp8x2pClWq5wVlhEf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+S8OOipUVy9LYSAuZdrOfBBf+xY8wA2tOC3HU8mlT2/OBhQnqPiB6H6huvO8w6K/RUJLgWxVbqy28Z7VZfvT7vGj/dCahdJN3c0qEmkathpiQWZQkBNYRJcx5iHXt09rOHTiM8vOvj+yh1Xd0OrvZEZYdgaGdm2rCzBxAdkLj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H0Hx47GU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=umifNtNgLmyvzlwo5GetVQnsGgQ+5QSJwODRNDbwxqk=; b=H0Hx47GUehvTzEEd/jEXZXdSAS
	eZ57jHvkuzRc1xzKov0EAXhjVO8k3Jrj8vlKqjOCHeE4J19/JvxJNUwDCDlcjn+w08kmeRKSsoAWM
	0nun/EI+1OI1ooXr1b5OBkYQIii0U3RLXkfcbNw/quqS3KtvXCrsOcehr3xKyYSpJKB6kg2fmOlap
	R2Y6gBXLAuKa6BoKNVc3hwkIBijGXiJ/ssYvO0OxTtThGkBRxOpV54UbW3AzcvUKFQmWl3vhfwkb6
	ccMXUlfJAGd53F8sKRl3G6iKXeZNPybwpvgYMo7N1vZ7ravyqJexC0gZdV8cZOtULejEEOPGxdYWA
	5EovUYdQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdqsp-0000000HJj2-2gCe;
	Thu, 08 Jan 2026 14:21:04 +0000
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
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 07/11] fs: add a ->sync_lazytime method
Date: Thu,  8 Jan 2026 15:19:07 +0100
Message-ID: <20260108141934.2052404-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108141934.2052404-1-hch@lst.de>
References: <20260108141934.2052404-1-hch@lst.de>
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
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/locking.rst |  2 ++
 Documentation/filesystems/vfs.rst     |  6 ++++++
 fs/fs-writeback.c                     | 13 +++++++++++--
 include/linux/fs.h                    |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 37a4a7fa8094..0312fba6d73b 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -82,6 +82,7 @@ prototypes::
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
 	void (*update_time)(struct inode *inode, enum fs_update_time type,
 			    int flags);
+	void (*sync_lazytime)(struct inode *inode);
 	int (*atomic_open)(struct inode *, struct dentry *,
 				struct file *, unsigned open_flag,
 				umode_t create_mode);
@@ -118,6 +119,7 @@ getattr:	no
 listxattr:	no
 fiemap:		no
 update_time:	no
+sync_lazytime:	no
 atomic_open:	shared (exclusive if O_CREAT is set in open flags)
 tmpfile:	no
 fileattr_get:	no or exclusive
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 51aa9db64784..d8cb181f69f8 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -487,6 +487,7 @@ As of kernel 2.6.22, the following members are defined:
 		ssize_t (*listxattr) (struct dentry *, char *, size_t);
 		void (*update_time)(struct inode *inode, enum fs_update_time type,
 				    int flags);
+		void (*sync_lazytime)(struct inode *inode);
 		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 				   unsigned open_flag, umode_t create_mode);
 		int (*tmpfile) (struct mnt_idmap *, struct inode *, struct file *, umode_t);
@@ -643,6 +644,11 @@ otherwise noted.
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
index 35b3e6c6b084..7837db1ba1d2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2024,6 +2024,7 @@ struct inode_operations {
 		      u64 len);
 	int (*update_time)(struct inode *inode, enum fs_update_time type,
 			   unsigned int flags);
+	void (*sync_lazytime)(struct inode *inode);
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode);
-- 
2.47.3


