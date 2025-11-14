Return-Path: <io-uring+bounces-10626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DF5E3C5B942
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 777BD4F44BE
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528C32FBE0F;
	Fri, 14 Nov 2025 06:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d5Iq/2XZ"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31FA2EBB8F;
	Fri, 14 Nov 2025 06:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101694; cv=none; b=bSHjr5yxBQrkGzftZ1e4fGOhdqFb0xfZSa5qnzyjO3XL1KUR7ojqctap9/D8J/Fz/G4xe7WFpn8Kkoi+//6xqyC+Xz85TjBwcBRR1A7A7mBS7Y+Y0NVTetc9uW6UsqmGWoYSm7J/CFg5e3D16Nd7o931BBKfOHvJckXeP2llY0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101694; c=relaxed/simple;
	bh=4iTADAPgCX7wAApBC5k7t6AIJS1LmJ0Jgq1oVM10bKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1hQ09BRidnbgEhpCROSR4enlR+4E4vXGPJZsht+9Zn7x4H/Hyh+U1/nEadBnwEwLLicijwnW83YHmCU+9JpXdLqJammStQ/uNaogRBd0viAeWMM5GRREI9PkRB6o5kYPWy7gOKElV+r2X2GLOu9MQ0AX/8g9IdOTF0dgUS41lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d5Iq/2XZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tWEmrP63I/HqQsUVRoDU+2mXodgPm+VxEOqNeB7T8PA=; b=d5Iq/2XZbdK/9vYCyRXnwRoQ4L
	svVdEoCDH+hR1dpn1WJWPRS7M5bQRU5cB3p8qcqraoXQZAzd10323xccf+aWUM3uRhxgunE+a8thN
	f1NmXmhsQF2r+QPFOOS+6dBrIG1HpGG+IsMoxEUdOETqWaQj/Q8nSzTGhE2c8SLCCNe6UZEAKAcYf
	NBI16jF/4FuXwAeNgVR7T+CfU5LVEKLBuJ6RLthzIdg1HrZNekPKC2MQABegBRbIL/Rp0hIp/xHes
	JhAi87yClSkoRJcFPtksFX/XjjcaesXfq0SGsW1iE6GYYoZfh1pQsnPj+y4MH1UugjDwuJgYi20UE
	zFlpGWuQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnI2-0000000Bf2b-2qcy;
	Fri, 14 Nov 2025 06:28:11 +0000
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
	gfs2@lists.linux.dev,
	io-uring@vger.kernel.org,
	devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 11/14] fs: add a ->sync_lazytime method
Date: Fri, 14 Nov 2025 07:26:14 +0100
Message-ID: <20251114062642.1524837-12-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114062642.1524837-1-hch@lst.de>
References: <20251114062642.1524837-1-hch@lst.de>
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
index 4f13b01e42eb..ff59760daae2 100644
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
index ae6d1f1ccc71..7245f547416f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1699,7 +1699,10 @@ bool sync_lazytime(struct inode *inode)
 		return false;
 
 	trace_writeback_lazytime(inode);
-	mark_inode_dirty_sync(inode);
+	if (inode->i_op->sync_lazytime)
+		inode->i_op->sync_lazytime(inode);
+	else
+		mark_inode_dirty_sync(inode);
 	return false;
 }
 
@@ -2547,6 +2550,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	trace_writeback_mark_inode_dirty(inode, flags);
 
 	if (flags & I_DIRTY_INODE) {
+		bool was_dirty_time = true;
+
 		/*
 		 * Inode timestamp update will piggback on this dirtying.
 		 * We tell ->dirty_inode callback that timestamps need to
@@ -2557,6 +2562,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			if (inode->i_state & I_DIRTY_TIME) {
 				inode->i_state &= ~I_DIRTY_TIME;
 				flags |= I_DIRTY_TIME;
+				was_dirty_time = true;
 			}
 			spin_unlock(&inode->i_lock);
 		}
@@ -2569,9 +2575,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
index 5c762d80b8a8..61051c86dbd2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2363,6 +2363,7 @@ struct inode_operations {
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
 	int (*update_time)(struct inode *, int);
+	void (*sync_lazytime)(struct inode *inode);
 	int (*atomic_open)(struct inode *, struct dentry *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode);
-- 
2.47.3


