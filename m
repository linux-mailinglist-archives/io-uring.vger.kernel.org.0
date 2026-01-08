Return-Path: <io-uring+bounces-11523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7B0D0368A
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 15:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9C45D3023549
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 14:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE155501191;
	Thu,  8 Jan 2026 14:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0/JWrEAT"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390B50118C;
	Thu,  8 Jan 2026 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882078; cv=none; b=YuyzxYcoPFzstoVyNRiH0eMsY7rbvQF8gVl/V28jC9/hXmPHkCxSgLOaZ9EIO7hzo//szJHQxZ2Zle5y6uGkeyfs4yh1A9Gzjta7Q5OE3uFpHX/sGA/Kf7ZxQK61wK9dgk8w9ue4P9am+HAht7IQeKJRA+Kij6V4/56XMvWBDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882078; c=relaxed/simple;
	bh=8/JLs4IrZpMOr3xF4gPW01ZuZilf/sgRKxT0PJ8cmME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUNGhpdmsTPnyUzYMEMM6mG69szPpz//6BVhdy/VC3QL7gvWQjCkqmitrTeGgSCT0HfGZ5rGbpBpZ9vqfh3LbSyqKklIF9zGuSQF9XDGu3YUW+eMCDg5teWd+kht/jjrFubl5AerBqbvjVzr7zupJJqdZQ6EeNs0R70/9qAtzZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0/JWrEAT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GMiF9//0kquQMpqL6P4q+NlQfu8tvch3hnZIyAVeC2U=; b=0/JWrEATOZqBP0roA531vUafSq
	FfDDVV1tOJxwZfG9oC8BmjI4ygJa0YhDcFJkzlt8NMSxI/ZaMy2kFuKgDJMUpFTPso/z8B3b2wA4l
	D5aYBMMF0Uza5ncF2whtUy2J337PQplYD5g5eFOWqOUZkkidm1YimR03KCXhyCNUpOB1RqPpRqa/S
	Ey1Glw5OHx9xFH0f/i6MWMIFwA7L/8gEW3tQyLrKyegZDoie/C9qG+JbSu3QUsbSET6IQQbMUMbTU
	P+4uSTfElv39DDGwhhOgr9UUEauYxGUygwLxSvF1MLHj5m5rbxJDjfmlRRr6o90HEA54lyKY2/F1T
	L+LAn9QA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdqt0-0000000HJoG-0mfI;
	Thu, 08 Jan 2026 14:21:14 +0000
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
	linux-nfs@vger.kernel.org
Subject: [PATCH 08/11] fs: add support for non-blocking timestamp updates
Date: Thu,  8 Jan 2026 15:19:08 +0100
Message-ID: <20260108141934.2052404-9-hch@lst.de>
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

Currently file_update_time_flags unconditionally returns -EAGAIN if any
timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
non-blocking direct writes impossible on file systems with granular
enough timestamps.

Pass IOCB_NOWAIT to ->update_time and return -EAGAIN if it could block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/inode.c     |  2 ++
 fs/gfs2/inode.c      |  3 +++
 fs/inode.c           | 45 +++++++++++++++++++++++++++++++++-----------
 fs/orangefs/inode.c  |  3 +++
 fs/overlayfs/inode.c |  2 ++
 fs/ubifs/file.c      |  3 +++
 fs/xfs/xfs_iops.c    |  3 +++
 7 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 23fc38de9be5..241727459c0a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6362,6 +6362,8 @@ static int btrfs_update_time(struct inode *inode, enum fs_update_time type,
 
 	if (btrfs_root_readonly(root))
 		return -EROFS;
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
 
 	dirty = inode_update_time(inode, type, flags);
 	if (dirty <= 0)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4ef39ff6889d..c02ebf0ca625 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2250,6 +2250,9 @@ static int gfs2_update_time(struct inode *inode, enum fs_update_time type,
 	struct gfs2_holder *gh;
 	int error;
 
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
 	gh = gfs2_glock_is_locked_by_me(gl);
 	if (gh && gl->gl_state != LM_ST_EXCLUSIVE) {
 		gfs2_glock_dq(gh);
diff --git a/fs/inode.c b/fs/inode.c
index 0cafe74bff2d..cd3ca98e8355 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2090,7 +2090,7 @@ static int inode_update_atime(struct inode *inode)
 	return inode_time_dirty_flag(inode);
 }
 
-static int inode_update_cmtime(struct inode *inode)
+static int inode_update_cmtime(struct inode *inode, unsigned int flags)
 {
 	struct timespec64 ctime = inode_get_ctime(inode);
 	struct timespec64 mtime = inode_get_mtime(inode);
@@ -2101,12 +2101,27 @@ static int inode_update_cmtime(struct inode *inode)
 	mtime_changed = !timespec64_equal(&now, &mtime);
 	if (mtime_changed || !timespec64_equal(&now, &ctime))
 		dirty = inode_time_dirty_flag(inode);
-	if (mtime_changed)
-		inode_set_mtime_to_ts(inode, now);
 
-	if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, !!dirty))
-		dirty |= I_DIRTY_SYNC;
+	/*
+	 * Pure timestamp updates can be recorded in the inode without blocking
+	 * by not dirtying the inode.  But when the file system requires
+	 * i_version updates, the update of i_version can still block.
+	 * Error out if we'd actually have to update i_version or don't support
+	 * lazytime.
+	 */
+	if (IS_I_VERSION(inode)) {
+		if (flags & IOCB_NOWAIT) {
+			if (!(inode->i_sb->s_flags & SB_LAZYTIME) ||
+			    inode_iversion_need_inc(inode))
+				return -EAGAIN;
+		} else {
+			if (inode_maybe_inc_iversion(inode, !!dirty))
+				dirty |= I_DIRTY_SYNC;
+		}
+	}
 
+	if (mtime_changed)
+		inode_set_mtime_to_ts(inode, now);
 	return dirty;
 }
 
@@ -2131,7 +2146,7 @@ int inode_update_time(struct inode *inode, enum fs_update_time type,
 	case FS_UPD_ATIME:
 		return inode_update_atime(inode);
 	case FS_UPD_CMTIME:
-		return inode_update_cmtime(inode);
+		return inode_update_cmtime(inode, flags);
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
@@ -2152,6 +2167,16 @@ int generic_update_time(struct inode *inode, enum fs_update_time type,
 {
 	int dirty;
 
+	/*
+	 * ->dirty_inode is what could make generic timestamp updates block.
+	 * Don't support non-blocking timestamp updates here if it is set.
+	 * File systems that implement ->dirty_inode but want to support
+	 * non-blocking timestamp updates should call inode_update_time
+	 * directly.
+	 */
+	if ((flags & IOCB_NOWAIT) && inode->i_sb->s_op->dirty_inode)
+		return -EAGAIN;
+
 	dirty = inode_update_time(inode, type, flags);
 	if (dirty <= 0)
 		return dirty;
@@ -2380,15 +2405,13 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 	if (!need_update)
 		return 0;
 
-	if (flags & IOCB_NOWAIT)
-		return -EAGAIN;
-
+	flags &= IOCB_NOWAIT;
 	if (mnt_get_write_access_file(file))
 		return 0;
 	if (inode->i_op->update_time)
-		ret = inode->i_op->update_time(inode, FS_UPD_CMTIME, 0);
+		ret = inode->i_op->update_time(inode, FS_UPD_CMTIME, flags);
 	else
-		ret = generic_update_time(inode, FS_UPD_CMTIME, 0);
+		ret = generic_update_time(inode, FS_UPD_CMTIME, flags);
 	mnt_put_write_access_file(file);
 	return ret;
 }
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index eab16afb5b8a..f420f48fc069 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -878,6 +878,9 @@ int orangefs_update_time(struct inode *inode, enum fs_update_time type,
 	struct iattr iattr = { };
 	int dirty;
 
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
 	switch (type) {
 	case FS_UPD_ATIME:
 		iattr.ia_valid = ATTR_ATIME;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index c0ce3519e4af..00c69707bda9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -566,6 +566,8 @@ int ovl_update_time(struct inode *inode, enum fs_update_time type,
 		};
 
 		if (upperpath.dentry) {
+			if (flags & IOCB_NOWAIT)
+				return -EAGAIN;
 			touch_atime(&upperpath);
 			inode_set_atime_to_ts(inode,
 					      inode_get_atime(d_inode(upperpath.dentry)));
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 0cc44ad142de..3dc3ca1cd803 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1377,6 +1377,9 @@ int ubifs_update_time(struct inode *inode, enum fs_update_time type,
 	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
 		return generic_update_time(inode, type, flags);
 
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d9eae1af14a8..aef5b05c1b76 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1195,6 +1195,9 @@ xfs_vn_update_time(
 
 	trace_xfs_update_time(ip);
 
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
 		if (type == FS_UPD_ATIME ||
 		    !inode_maybe_inc_iversion(inode, false))
-- 
2.47.3


