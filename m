Return-Path: <io-uring+bounces-11141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC9EBCC6382
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 07:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FA75311F98F
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182752D8792;
	Wed, 17 Dec 2025 06:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ya/BLi9T"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4149F2D592D;
	Wed, 17 Dec 2025 06:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951895; cv=none; b=ivjdsXe+/JfYb/o4QKytl8TjLUtV/TAsoR9Yv2Q7o5rbSNzcjL2rIImOx3yQRc2g4nVX2rkfGfRhtyYOIG0CD7CnoW6ufqUikmHlBaJCaDYNxjWm1nu1FqdfZX/Qk8g4pnnv1Gs56VF0bs/oMLY6zu3DMchAOpNO2iBIvlnXof4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951895; c=relaxed/simple;
	bh=7z2I7x3A3H1NrmZ1qwLIAupXj2GXPk76uLOXnCiOh7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVlaX/MGN7CauKT3+x9LAsi8FrcFSQZr6kKoyQ1lEzh7j+wJaHqlheNI5voW+Sua77HzT6qQSauGKZEcTCN1RVv/G4QB9J5nXudhTa2Gpg6P0TJ9OgEAg4yiXgGY4B6Y6xdV9vBZPPEdVYy4OnFm5d75vIEt5ZsocFwUTMSlkR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ya/BLi9T; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cmRL1L+E+zHvjbrc9UAFAA7Vx/VoU2I7wtmuzyJddKQ=; b=Ya/BLi9TcBVCvQJPTSrjTsU+kk
	cDD4h0wlYMKrmlup9RFOvtaf9JB0JqbIv/VgzIK5pWnxixZzImtM3xyfM0ITzmJxxiaB3HPLuH9bl
	hqYB74CAIIQDjorsvygDP1Sm8b/LTbDgwofUiPkdBHjUYW6NQZ7BDfMVWWdVNUSFGc900sJr32jDn
	mdLmc2XzF8Aqj0T9BAiXjowBRIvimBkQigASwH5eK/2TS5XI30LpQLKyUnmzD80w+WV8lA/SKbeaY
	VJ+xAconzOU+Oft9xbp+qjprWqEda1d1ze2uWah9NloEWPT66JKOEEQJ2kJ0nbZcW+6h41ikM2mhc
	9grPGoUQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVkl0-00000006DwG-1Iyh;
	Wed, 17 Dec 2025 06:11:30 +0000
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
Subject: [PATCH 08/10] fs: add support for non-blocking timestamp updates
Date: Wed, 17 Dec 2025 07:09:41 +0100
Message-ID: <20251217061015.923954-9-hch@lst.de>
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

Currently file_update_time_flags unconditionally returns -EAGAIN if any
timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
non-blocking direct writes impossible on file systems with granular
enough timestamps.

Add a S_NOWAIT to ask for timestamps to not block, and return -EAGAIN in
all methods for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/inode.c     |  3 +++
 fs/fat/misc.c        |  3 +++
 fs/gfs2/inode.c      |  3 +++
 fs/inode.c           | 30 +++++++++++++++++++++++++-----
 fs/orangefs/inode.c  |  3 +++
 fs/overlayfs/inode.c |  3 +++
 fs/ubifs/file.c      |  3 +++
 fs/xfs/xfs_iops.c    |  3 +++
 include/linux/fs.h   | 10 ++++++----
 9 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ca8d294770e..7e5553878818 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6354,6 +6354,9 @@ static int btrfs_update_time(struct inode *inode, int flags)
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	error = inode_update_timestamps(inode, &flags);
 	if (error || !flags)
 		return error;
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 950da09f0961..5df3193c35f9 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -346,6 +346,9 @@ int fat_update_time(struct inode *inode, int flags)
 	if (inode->i_ino == MSDOS_ROOT_INO)
 		return 0;
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	if (flags & (S_ATIME | S_CTIME | S_MTIME)) {
 		fat_truncate_time(inode, NULL, flags);
 		if (inode->i_sb->s_flags & SB_LAZYTIME)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e08eb419347c..0dce2af533b2 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2249,6 +2249,9 @@ static int gfs2_update_time(struct inode *inode, int flags)
 	struct gfs2_holder *gh;
 	int error;
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	gh = gfs2_glock_is_locked_by_me(gl);
 	if (gh && gl->gl_state != LM_ST_EXCLUSIVE) {
 		gfs2_glock_dq(gh);
diff --git a/fs/inode.c b/fs/inode.c
index f1c09fc0913d..0180ad526cf8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2110,12 +2110,26 @@ int inode_update_timestamps(struct inode *inode, int *flags)
 		now = inode_set_ctime_current(inode);
 		if (!timespec64_equal(&now, &ctime))
 			updated |= S_CTIME;
-		if (!timespec64_equal(&now, &mtime)) {
-			inode_set_mtime_to_ts(inode, now);
+		if (!timespec64_equal(&now, &mtime))
 			updated |= S_MTIME;
+
+		if (IS_I_VERSION(inode)) {
+			if (*flags & S_NOWAIT) {
+				/*
+				 * Error out if we'd need timestamp updates, as
+				 * the generally requires blocking to dirty the
+				 * inode in one form or another.
+				 */
+				if (updated && inode_iversion_need_inc(inode))
+					goto bail;
+			} else {
+				if (inode_maybe_inc_iversion(inode, updated))
+					updated |= S_VERSION;
+			}
 		}
-		if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, updated))
-			updated |= S_VERSION;
+
+		if (updated & S_MTIME)
+			inode_set_mtime_to_ts(inode, now);
 	} else {
 		now = current_time(inode);
 	}
@@ -2131,6 +2145,9 @@ int inode_update_timestamps(struct inode *inode, int *flags)
 
 	*flags = updated;
 	return 0;
+bail:
+	*flags = 0;
+	return -EAGAIN;
 }
 EXPORT_SYMBOL(inode_update_timestamps);
 
@@ -2150,6 +2167,9 @@ int generic_update_time(struct inode *inode, int flags)
 {
 	int error;
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	error = inode_update_timestamps(inode, &flags);
 	if (!error && flags)
 		mark_inode_dirty_time(inode, flags);
@@ -2378,7 +2398,7 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 		return 0;
 
 	if (flags & IOCB_NOWAIT)
-		return -EAGAIN;
+		sync_mode |= S_NOWAIT;
 
 	if (mnt_get_write_access_file(file))
 		return 0;
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 3b58f31bd54f..a84142f56344 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -880,6 +880,9 @@ int orangefs_update_time(struct inode *inode, int flags)
 	gossip_debug(GOSSIP_INODE_DEBUG, "orangefs_update_time: %pU\n",
 	    get_khandle_from_ino(inode));
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	error = inode_update_timestamps(inode, &flags);
 	if (error || !flags)
 		return error;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index bdbf86b56a9b..28ec75994cb3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -564,6 +564,9 @@ int ovl_update_time(struct inode *inode, int flags)
 			.dentry = ovl_upperdentry_dereference(OVL_I(inode)),
 		};
 
+		if (flags & S_NOWAIT)
+			return -EAGAIN;
+
 		if (upperpath.dentry) {
 			touch_atime(&upperpath);
 			inode_set_atime_to_ts(inode,
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 71540644a931..fd47d0e972e2 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1382,6 +1382,9 @@ int ubifs_update_time(struct inode *inode, int flags)
 	if (!IS_ENABLED(CONFIG_UBIFS_ATIME_SUPPORT))
 		return generic_update_time(inode, flags);
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9dedb54e3cb0..626a541b247b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1195,6 +1195,9 @@ xfs_vn_update_time(
 
 	trace_xfs_update_time(ip);
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	if (inode->i_sb->s_flags & SB_LAZYTIME) {
 		if (!((flags & S_VERSION) &&
 		      inode_maybe_inc_iversion(inode, false)))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 255eb3b42d1d..34152f687b46 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2240,10 +2240,12 @@ static inline void inode_dec_link_count(struct inode *inode)
 }
 
 enum file_time_flags {
-	S_ATIME = 1,
-	S_MTIME = 2,
-	S_CTIME = 4,
-	S_VERSION = 8,
+	S_ATIME		= 1U << 0,
+	S_MTIME		= 1U << 1,
+	S_CTIME		= 1U << 2,
+	S_VERSION	= 1U << 3,
+
+	S_NOWAIT	= 1U << 15,
 };
 
 extern bool atime_needs_update(const struct path *, struct inode *);
-- 
2.47.3


