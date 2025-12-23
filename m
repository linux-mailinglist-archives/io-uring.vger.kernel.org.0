Return-Path: <io-uring+bounces-11279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 987E6CD78A8
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E24C53052E38
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D668212564;
	Tue, 23 Dec 2025 00:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NIXFdjXY"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C7419C553;
	Tue, 23 Dec 2025 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450298; cv=none; b=Jc9NFFqk1Flzm2lhfGXEy4R4MuZdgax6MBMhy9Ly6ku7VCVavRd8d+kXVYiSUhshmAo6RMIdNKHGAmBzRC1SGeOu1phWChTmOWFiLxpk+aSyFAs71pRDVmWTKbzV4ts/urp+jXBmM8pzCRDgjMrmjCVFJdEJb3s94GcoZ427X8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450298; c=relaxed/simple;
	bh=mG2PmgVDyuDuBBMP0oEujnBn5ZRsm5oTQwPMA2QJoII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drhgxy3qkiE0l3ZV6TCLa3DzMcMTTRZmKSAJK196vWuj1XdZptQSR/7he93PP7OX1OrYV2lV15N051esAOmZXgglH6Yes3GGA/KhZRhJbMy2UgKzCIvA618XHjGNXsxtDRwMEZcz4jR8cB1mzVLPXdD/hS5wsR+B4sI5DoGLuho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NIXFdjXY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tRUa7Rl1dRbBO67JGDeBR683UJh/Sd6qTahEp1yS/wU=; b=NIXFdjXYEeyMV4Xdwwik4psLm2
	t4/+52zfIlvTMpSEc7BYD2CH0Oh064BW0KaE6Fz7BywfQWvt3+9N1Dqm6b6vLfRSbOPaLpFVeW8pz
	apI65N/czKdDwh3kA24+4FjHR8/fSQCvr/FtPD1gW45ohDG2HOMdGQoyqqh3o6FP0yO2gqta+bQcf
	I9gT7cKpBGoZpPaZQQHtJP8zeIXHnsbLZlvzgnpvEoKh027+1fhK9u0qg4hGKIM8FnGa2whWzJJd1
	OR41EJf20s3yfzaza54VTyxPkKjfnE1g7b5wE4pmcof4rugSPUZKqF6z0yEvcPW4JeX7GvhjeVZ3O
	rKsHtAlA==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqPm-0000000EIkN-0mZY;
	Tue, 23 Dec 2025 00:38:14 +0000
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
	linux-nfs@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 02/11] fs: allow error returns from generic_update_time
Date: Tue, 23 Dec 2025 09:37:45 +0900
Message-ID: <20251223003756.409543-3-hch@lst.de>
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

Now that no caller looks at the updated flags, switch generic_update_time
to the same calling convention as the ->update_time method and return 0
or a negative errno.

This prepares for adding non-blocking timestamp updates that could return
-EAGAIN.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/gfs2/inode.c    | 3 +--
 fs/inode.c         | 4 ++--
 fs/ubifs/file.c    | 6 ++----
 fs/xfs/xfs_iops.c  | 6 ++----
 include/linux/fs.h | 2 +-
 5 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 36618e353199..e08eb419347c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2257,8 +2257,7 @@ static int gfs2_update_time(struct inode *inode, int flags)
 		if (error)
 			return error;
 	}
-	generic_update_time(inode, flags);
-	return 0;
+	return generic_update_time(inode, flags);
 }
 
 static const struct inode_operations gfs2_file_iops = {
diff --git a/fs/inode.c b/fs/inode.c
index 07effa0cb999..7eb28dd45a5a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2141,7 +2141,7 @@ EXPORT_SYMBOL(inode_update_timestamps);
  * or S_VERSION need to be updated we attempt to update all three of them. S_ATIME
  * updates can be handled done independently of the rest.
  *
- * Returns a S_* mask indicating which fields were updated.
+ * Returns a negative error value on error, else 0.
  */
 int generic_update_time(struct inode *inode, int flags)
 {
@@ -2153,7 +2153,7 @@ int generic_update_time(struct inode *inode, int flags)
 	if (updated & S_VERSION)
 		dirty_flags |= I_DIRTY_SYNC;
 	__mark_inode_dirty(inode, dirty_flags);
-	return updated;
+	return 0;
 }
 EXPORT_SYMBOL(generic_update_time);
 
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index c3265b8804f5..ec1bb9f43acc 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1379,10 +1379,8 @@ int ubifs_update_time(struct inode *inode, int flags)
 			.dirtied_ino_d = ALIGN(ui->data_len, 8) };
 	int err, release;
 
-	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT)) {
-		generic_update_time(inode, flags);
-		return 0;
-	}
+	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
+		return generic_update_time(inode, flags);
 
 	err = ubifs_budget_space(c, &req);
 	if (err)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ad94fbf55014..9dedb54e3cb0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1197,10 +1197,8 @@ xfs_vn_update_time(
 
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
 		if (!((flags & S_VERSION) &&
-		      inode_maybe_inc_iversion(inode, false))) {
-			generic_update_time(inode, flags);
-			return 0;
-		}
+		      inode_maybe_inc_iversion(inode, false)))
+			return generic_update_time(inode, flags);
 
 		/* Capture the iversion update that just occurred */
 		log_flags |= XFS_ILOG_CORE;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ee623c16d835..fccb0a38cb74 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2399,7 +2399,7 @@ extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 void iput_not_last(struct inode *);
 int inode_update_timestamps(struct inode *inode, int flags);
-int generic_update_time(struct inode *, int);
+int generic_update_time(struct inode *inode, int flags);
 
 /* /sys/fs */
 extern struct kobject *fs_kobj;
-- 
2.47.3


