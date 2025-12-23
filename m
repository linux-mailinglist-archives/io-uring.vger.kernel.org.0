Return-Path: <io-uring+bounces-11285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B36CCD7956
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BC7E3082091
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA59274B2B;
	Tue, 23 Dec 2025 00:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RoP3vCRa"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14549258EC3;
	Tue, 23 Dec 2025 00:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450331; cv=none; b=l+xxANGRIfTiVITu0W6ZvXycxxwPelgOvTQfSxQF4T/7UeWikp18TwR7QUeF9eD26voisw7JyBF3py8LGlTPj91IRtzeiCUO4I9LJAgJ/TWBvzJz0SXx6tbG/stfjTVCRAgQY+WirAuyAEtIUhm45oJofgZfuid6jr8il26Fml4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450331; c=relaxed/simple;
	bh=6NB5DA8B9zQy51ODCNY5BX/Ss8k7EUgAwattRxRwjEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3YOOIUjw7zcNzLuPkcYNkBoMBxSkcXEBshqIIRDIyQQkfwsPJr82a6ToAQE2V1NCxrjzFmgayVxzYQPS9y+AsvOkpV0Qqp3c5eM1bsZI5jWOjsVw1XjnmNhwBjFyp1fsgjUFbKeP7cXldAesxgqR3EyKpZFEXCiFEIUNNiBQfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RoP3vCRa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9qCDtCy2v3payACRaxwKUv7ePGUjjs+NfQFo3M8oXRA=; b=RoP3vCRaSI5C876WE7SFJNLYGH
	IZ7XbV8pmw+HOKS+5r6r3yorNXR8Hw538eUILX8mNSC+XlZvVzlUcjS+OjJkCD9OpnPkBCoBmYZ2S
	J77HX+sS3yKICBPDOqprBFvQatgoqvK4TNwxNfLsBXKCh0TKFopy9xHWBLoQl9f+ZEkYXOAUo4rfQ
	mjccEGyGZYW0JFMqekZpr0yqkCRuvkslw/GlZwhfjai8x9UiiGfCNHzDBpY6nFliJDjpQFqMCjOPV
	sQP2IfMz/00RBr3eDd43+fV0YdTwR7Yk7rKSAq1Jn4tYmOy50mF4skiVx/ZwJfQ4XjLGGZ2Lz3TGN
	yhtR6Fzg==;
Received: from s58.ghokkaidofl2.vectant.ne.jp ([202.215.7.58] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXqQJ-0000000EJ07-0YZe;
	Tue, 23 Dec 2025 00:38:47 +0000
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
Subject: [PATCH 08/11] fs: add support for non-blocking timestamp updates
Date: Tue, 23 Dec 2025 09:37:51 +0900
Message-ID: <20251223003756.409543-9-hch@lst.de>
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

Currently file_update_time_flags unconditionally returns -EAGAIN if any
timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
non-blocking direct writes impossible on file systems with granular
enough timestamps.

Add a S_NOWAIT to ask for timestamps to not block, and return -EAGAIN in
all methods for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fat/misc.c        |  3 +++
 fs/gfs2/inode.c      |  3 +++
 fs/inode.c           | 29 ++++++++++++++++++++++++++---
 fs/overlayfs/inode.c |  2 ++
 fs/ubifs/file.c      |  3 +++
 fs/xfs/xfs_iops.c    |  3 +++
 include/linux/fs.h   | 21 +++++++++++++++++----
 7 files changed, 57 insertions(+), 7 deletions(-)

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
index 212dab5c65ad..98a878427ecb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2111,6 +2111,13 @@ int inode_update_timestamps(struct inode *inode, int flags, int *dirty_flags)
 
 	*dirty_flags = 0;
 
+	/*
+	 * Non-blocking timestamp updates require an explicit opt-in from the
+	 * file system.
+	 */
+	if ((flags & S_NOWAIT) && !(flags & S_CAN_NOWAIT_LAZYTIME))
+		return -EAGAIN;
+
 	if (flags & (S_MTIME | S_CTIME | S_VERSION)) {
 		struct timespec64 ctime = inode_get_ctime(inode);
 		struct timespec64 mtime = inode_get_mtime(inode);
@@ -2120,8 +2127,24 @@ int inode_update_timestamps(struct inode *inode, int flags, int *dirty_flags)
 			updated |= S_CTIME;
 		if (!timespec64_equal(&now, &mtime))
 			updated |= S_MTIME;
-		if (IS_I_VERSION(inode) && inode_maybe_inc_iversion(inode, updated))
-			updated |= S_VERSION;
+
+		/*
+		 * Pure timestamp updates can be recorded in the inode without
+		 * blocking by not dirtying the inode.  But when the file system
+		 * requires i_version updates, actual i_version update may block
+		 * despite that.  Error out if we'd actually have to update
+		 * i_version or don't support lazytime.
+		 */
+		if (IS_I_VERSION(inode)) {
+			if (flags & S_NOWAIT) {
+				if (!(inode->i_sb->s_flags & SB_LAZYTIME) ||
+				    inode_iversion_need_inc(inode))
+					return -EAGAIN;
+			} else {
+				if (inode_maybe_inc_iversion(inode, updated))
+					updated |= S_NOWAIT;
+			}
+		}
 	} else {
 		now = current_time(inode);
 	}
@@ -2391,7 +2414,7 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 		return 0;
 
 	if (flags & IOCB_NOWAIT)
-		return -EAGAIN;
+		sync_mode |= S_NOWAIT;
 
 	if (mnt_get_write_access_file(file))
 		return 0;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index bdbf86b56a9b..6d23cacbf776 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -565,6 +565,8 @@ int ovl_update_time(struct inode *inode, int flags)
 		};
 
 		if (upperpath.dentry) {
+			if (flags & S_NOWAIT)
+				return -EAGAIN;
 			touch_atime(&upperpath);
 			inode_set_atime_to_ts(inode,
 					      inode_get_atime(d_inode(upperpath.dentry)));
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index fe236886484c..b74dd4d21330 100644
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
index d1d57149aa93..0ea175e19a8b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2239,10 +2239,23 @@ static inline void inode_dec_link_count(struct inode *inode)
 }
 
 enum file_time_flags {
-	S_ATIME = 1,
-	S_MTIME = 2,
-	S_CTIME = 4,
-	S_VERSION = 8,
+	/* update atime: */
+	S_ATIME			= 1U << 0,
+
+	/* update mtime */
+	S_MTIME			= 1U << 1,
+
+	/* update ctime */
+	S_CTIME			= 1U << 2,
+
+	/* force update i_version even if no timestamp changes */
+	S_VERSION		= 1U << 3,
+
+	/* only update timestamps or i_version if it doesn't require blocking */
+	S_NOWAIT		= 1U << 14,
+
+	/* support S_NOWAIT for SB_LAZYTIME mounts in inode_update_timestamps */
+	S_CAN_NOWAIT_LAZYTIME	= 1U << 15,
 };
 
 extern bool atime_needs_update(const struct path *, struct inode *);
-- 
2.47.3


