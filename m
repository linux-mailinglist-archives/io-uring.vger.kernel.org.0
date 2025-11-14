Return-Path: <io-uring+bounces-10622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE54C5B86D
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 07:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA2A13BBE08
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 06:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB352F3621;
	Fri, 14 Nov 2025 06:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2EzS8YQk"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511EA2EBB84;
	Fri, 14 Nov 2025 06:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763101661; cv=none; b=PqNUFAaJ6VmjfKnQ18Jzu6K55k5isOun6jcrZQJS+Rx5kzmTZ7Vr+AhTnET8iKKFgYKscbY6uTq7vasuD2UOAoHCYjJ/fcL/sHdAr7KdfM7ov1ZGyFnyYbkxREazDaASPLaBc3kxx9GIkIBASfEiNd/MSiNle6AbPnbj7l2K988=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763101661; c=relaxed/simple;
	bh=hW14srXwKsylQfnauabSdThXLkLJInWFan5WxPCEAPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6ClUDRScAzEVcM5d6V75Akk2rxlUyjviym1nJJwLUHwcfqG5dMGegcfcj5da0dwaxAsJJSAs4W4kpzJXDCy+NVU5I24Ls1+Cea1o6bQR/Yj+2qFm2GjGwfs55R9mikBZpAgnT3M3Mo28dYJK5rN+4ctWz7FWyooboRSta0EcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2EzS8YQk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=e9bPnNCYpLQApILQtZjaJbvLitU2MuCq9c3qPwz2cI4=; b=2EzS8YQkqibmj/W9HWE2pynooR
	j+JLv0oOGAAVKLm2HcEAhMyv1VQzOw8r7ungcpGGbcqMDOzZH4fX8nwctVc1YPXDzLc3w8itEJVMy
	kh7JcXj30ryvVj9CatsVlzgl6HAptft143mUgdNfGHaQzZ/mpnjC71etWRcvrUctZFfOUEXRJn/ix
	AMoOK+7lb9YT/kCerwVieLTdDwFTbc4Q/xspvkCE7HPwXzIElKXyk0WikZv6HcgA9c6+YmddnuBEF
	DPkaNM2VYBbsGLwAui1vL5FW+7YpWwu0J6qxR2PKsufc8+kcDwA0WcDPp+djCa0HE1KqlMgRjnuSy
	Ag1PTgHw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJnHV-0000000Beja-3cxB;
	Fri, 14 Nov 2025 06:27:38 +0000
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
Subject: [PATCH 07/14] fs: return a negative error from generic_update_time
Date: Fri, 14 Nov 2025 07:26:10 +0100
Message-ID: <20251114062642.1524837-8-hch@lst.de>
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

Now that no caller looks at the updated flags, switch generic_update_time
to the same calling convention as the ->update_time method and return 0
or a negative errno.

This prepares for adding non-blocking timestamp updates that could return
-EAGAIN.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/inode.c    | 3 +--
 fs/inode.c         | 6 +++---
 fs/ubifs/file.c    | 6 ++----
 fs/xfs/xfs_iops.c  | 6 ++----
 include/linux/fs.h | 2 +-
 5 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8a7ed80d9f2d..601c14a3ac77 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2242,8 +2242,7 @@ static int gfs2_update_time(struct inode *inode, int flags)
 		if (error)
 			return error;
 	}
-	generic_update_time(inode, flags);
-	return 0;
+	return generic_update_time(inode, flags);
 }
 
 static const struct inode_operations gfs2_file_iops = {
diff --git a/fs/inode.c b/fs/inode.c
index d3edcc5baec9..74e672dd90aa 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2091,7 +2091,7 @@ EXPORT_SYMBOL(inode_update_timestamps);
  * or S_VERSION need to be updated we attempt to update all three of them. S_ATIME
  * updates can be handled done independently of the rest.
  *
- * Returns a S_* mask indicating which fields were updated.
+ * Returns a negative error value on error, else 0.
  */
 int generic_update_time(struct inode *inode, int flags)
 {
@@ -2103,7 +2103,7 @@ int generic_update_time(struct inode *inode, int flags)
 	if (updated & S_VERSION)
 		dirty_flags |= I_DIRTY_SYNC;
 	__mark_inode_dirty(inode, dirty_flags);
-	return updated;
+	return 0;
 }
 EXPORT_SYMBOL(generic_update_time);
 
@@ -2335,7 +2335,7 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 	if (inode->i_op->update_time)
 		ret = inode->i_op->update_time(inode, sync_mode);
 	else
-		generic_update_time(inode, sync_mode);
+		ret = generic_update_time(inode, sync_mode);
 	mnt_put_write_access_file(file);
 	return ret;
 }
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index ca41ce8208c4..3e119cb93ea9 100644
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
index caff0125faea..0ace5f790006 100644
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
index a09cebdb4881..c1077ae7c6b2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2823,7 +2823,7 @@ extern int current_umask(void);
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 int inode_update_timestamps(struct inode *inode, int flags);
-int generic_update_time(struct inode *, int);
+int generic_update_time(struct inode *inode, int flags);
 
 /* /sys/fs */
 extern struct kobject *fs_kobj;
-- 
2.47.3


