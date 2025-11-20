Return-Path: <io-uring+bounces-10689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E534C727BE
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 08:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 73DE14EEA5B
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 06:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F473101DB;
	Thu, 20 Nov 2025 06:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b+2WCodR"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57B30FC3A;
	Thu, 20 Nov 2025 06:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621455; cv=none; b=j0jlpY0Jg4aDsnl9/KIBld9B/CdmIeUHGaE2Ty4Joq1ZT6LEzz7yWNQOLOnKJomanjJ5gIb1SMp5TVpByzXz02u8k9QQCbhx3Pt+YCNUt7Hqt6RxbDxQGbeqAaoi2rsd0IzvFSK0wdJkLdh2/aVCWeQfBtqlHlP1LYJhrbYz6Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621455; c=relaxed/simple;
	bh=VQ12R36tuN6IBvA7SPFboenmR4JJ1c2HlCuI631CDEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5Ca51sz1TMKg/wFVS/rwEZV78ul0Cif+iErkTzJdTh5a3sfan1r0lprPNX2s1RJtfDHVopOif46wvmr83E7LIWcYv4rauCUY87zO2pkG6S+Aid9n72HMRmrjmXLEH5QlVQJBMw3uYuFrJNI2ydFUB02HC2+OWho7kYZd6X6OKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b+2WCodR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QMycGVWTy0DabPVfpyALeYhHpx/KrXgMXRpxHbcHFnA=; b=b+2WCodR0yID2akDOWWimW+7+f
	ZhnHeAYvvc6WlLLObWIk7HYzXHvypytNFvSj3xLx4JP22w78yWpeyK2KsISUJoAp8IAntyUsvSzhW
	GdbSzDtnk5QdtHzFuA5qwkkeEW8P81KAGQgnbiCe7I2nKxzkG0eFZxx/hw5gITe9Es16v1sYA9bGY
	W56/5p8pDecnanVY1n1wtdnMfwi+b0gs7dv4Kf5G7h5F5MkzFlFCcP60x+WpH8Bqaju8hxuyudN7j
	SsYnM6mzpKsXwsrB1YrhfNM5B7ntyFLZ5fsJdhlqgeH0AkPlsR3DBr032Ey11mCWA5Wm8SarSg+Cj
	cWMwl6jA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLyVH-00000006FOZ-3wPa;
	Thu, 20 Nov 2025 06:50:52 +0000
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
Subject: [PATCH 14/16] fs: add support for non-blocking timestamp updates
Date: Thu, 20 Nov 2025 07:47:35 +0100
Message-ID: <20251120064859.2911749-15-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120064859.2911749-1-hch@lst.de>
References: <20251120064859.2911749-1-hch@lst.de>
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
index 668e4a1df7ae..ea7e87bce1cd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6302,6 +6302,9 @@ static int btrfs_update_time(struct inode *inode, int flags)
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
index 601c14a3ac77..0184cb64fe9f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2234,6 +2234,9 @@ static int gfs2_update_time(struct inode *inode, int flags)
 	struct gfs2_holder *gh;
 	int error;
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	gh = gfs2_glock_is_locked_by_me(gl);
 	if (gh && gl->gl_state != LM_ST_EXCLUSIVE) {
 		gfs2_glock_dq(gh);
diff --git a/fs/inode.c b/fs/inode.c
index 156a5fb50c7e..577eea4e9704 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2072,12 +2072,26 @@ int inode_update_timestamps(struct inode *inode, int *flags)
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
@@ -2093,6 +2107,9 @@ int inode_update_timestamps(struct inode *inode, int *flags)
 
 	*flags = updated;
 	return 0;
+bail:
+	*flags = 0;
+	return -EAGAIN;
 }
 EXPORT_SYMBOL(inode_update_timestamps);
 
@@ -2112,6 +2129,9 @@ int generic_update_time(struct inode *inode, int flags)
 {
 	int error;
 
+	if (flags & S_NOWAIT)
+		return -EAGAIN;
+
 	error = inode_update_timestamps(inode, &flags);
 	if (!error && flags)
 		mark_inode_dirty_time(inode, flags);
@@ -2340,7 +2360,7 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 		return 0;
 
 	if (flags & IOCB_NOWAIT)
-		return -EAGAIN;
+		sync_mode |= S_NOWAIT;
 
 	if (mnt_get_write_access_file(file))
 		return 0;
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index ec56a777053d..569280935179 100644
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
index e11f310ce092..c132d1f5502b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -576,6 +576,9 @@ int ovl_update_time(struct inode *inode, int flags)
 			.dentry = ovl_upperdentry_dereference(OVL_I(inode)),
 		};
 
+		if (flags & S_NOWAIT)
+			return -EAGAIN;
+
 		if (upperpath.dentry) {
 			touch_atime(&upperpath);
 			inode_set_atime_to_ts(inode,
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 7f631473da6c..33af8bbeab4f 100644
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
index 0ace5f790006..da055dade25f 100644
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
index eddb2bab0edd..924ea0449dc6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2659,10 +2659,12 @@ static inline void inode_dec_link_count(struct inode *inode)
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


