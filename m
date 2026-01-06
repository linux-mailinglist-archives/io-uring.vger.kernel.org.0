Return-Path: <io-uring+bounces-11391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 723CCCF723B
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 08:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 47E0C300EB80
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 07:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB12930C342;
	Tue,  6 Jan 2026 07:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pi261BXz"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E55530ACF1;
	Tue,  6 Jan 2026 07:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767685857; cv=none; b=ssA2w84uoPjhxzot3fFT7oUss9ep+stoGnuA3bd503beUFi+GSRBn4pLO7hRJOln+DbBYDC/vgL7pWU79/bVDPPZNhgQVWdwMiOPo0pQKOMCS/uxgt16z7lLXJ9blZE8J0k1HuARDeTBs4UoZf9VgM50Ly8ru+yc4szCnFPjfFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767685857; c=relaxed/simple;
	bh=wBTHOvYX4Jl4EpdWcIuMdN0ZmJWgTOZOB//IBmpMp4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtZKa4AtNARvUrjnm71Y5BLlzuXml4S8YkBPAYb7WIGB39MLQiseTcHrAitoqG49YEsqt/qMK5ddRQnzBO3S6rPUO8H23yIc9ivUxJR7B20BybVHC0YrkrdimmulWj2M3tTKY3zUOLLbi7XXp2XAkAwmtF+rTcQiAMaipCRaDsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pi261BXz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eXPtcAj+5Pl4ARa2x7jJIVvkDahrjDaRt+9j2aQ/Tj0=; b=pi261BXz3MfolLniRNisZ1t5XF
	hUASAOhquiwoR9/gHpyDKjLLiUqdl58rfpQMpkv66zR1tQUevruBhHuDjuQdK1bOw+JCfBdRK3HL3
	DTLnjZCDq0KzI6u+u+zdX+3NUgqspCkx7zZgks6hRrxmgos34FQSmEc9mn19/NFFpfc26wHCbwpP9
	IrdB0a3zFgO6DSWdjgUQ4MMRxvVo9i6l+t+zky5MGeWKSo08jQ9O5CcqMrQ6e70S9Y7a7cCKTTQ84
	y0z0wdL7173OoIg5vs5Ai2KuBXHE0kCBh4O/8LwV5bfGSDJW1VPL7Eb/kFBAe7t85zWRr4ZCLKlu+
	xuqe4sOw==;
Received: from [2001:4bb8:2af:87cb:5562:685f:c094:6513] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1q9-0000000CYgi-2She;
	Tue, 06 Jan 2026 07:50:53 +0000
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
Subject: [PATCH 04/11] fat: cleanup the flags for fat_truncate_time
Date: Tue,  6 Jan 2026 08:49:58 +0100
Message-ID: <20260106075008.1610195-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106075008.1610195-1-hch@lst.de>
References: <20260106075008.1610195-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Fat only has a single on-disk timestamp covering ctime and mtime.  Add
fat-specific flags that indicate which timestamp fat_truncate_time should
update to make this more clear.  This allows removing no-op
fat_truncate_time calls with the S_CTIME flag and prepares for removing
the S_* flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fat/dir.c         |  2 +-
 fs/fat/fat.h         |  8 ++++----
 fs/fat/file.c        | 14 ++++++--------
 fs/fat/inode.c       |  2 +-
 fs/fat/misc.c        | 39 ++++++++++++++++-----------------------
 fs/fat/namei_msdos.c | 13 +++++--------
 fs/fat/namei_vfat.c  |  9 ++++-----
 7 files changed, 37 insertions(+), 50 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 92b091783966..3d03bff40944 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1080,7 +1080,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		}
 	}
 
-	fat_truncate_time(dir, NULL, S_ATIME|S_MTIME);
+	fat_truncate_time(dir, NULL, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(dir))
 		(void)fat_sync_inode(dir);
 	else
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index d3e426de5f01..767b566b1cab 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -468,10 +468,10 @@ extern void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec64 *ts,
 			      __le16 *time, __le16 *date, u8 *time_cs);
 extern struct timespec64 fat_truncate_atime(const struct msdos_sb_info *sbi,
 					    const struct timespec64 *ts);
-extern struct timespec64 fat_truncate_mtime(const struct msdos_sb_info *sbi,
-					    const struct timespec64 *ts);
-extern int fat_truncate_time(struct inode *inode, struct timespec64 *now,
-			     int flags);
+#define FAT_UPDATE_ATIME	(1u << 0)
+#define FAT_UPDATE_CMTIME	(1u << 1)
+void fat_truncate_time(struct inode *inode, struct timespec64 *now,
+		unsigned int flags);
 extern int fat_update_time(struct inode *inode, int flags);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
 
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 4fc49a614fb8..f9bc93411aa2 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -224,7 +224,7 @@ static int fat_cont_expand(struct inode *inode, loff_t size)
 	if (err)
 		goto out;
 
-	fat_truncate_time(inode, NULL, S_CTIME|S_MTIME);
+	fat_truncate_time(inode, NULL, FAT_UPDATE_CMTIME);
 	mark_inode_dirty(inode);
 	if (IS_SYNC(inode)) {
 		int err2;
@@ -327,7 +327,7 @@ static int fat_free(struct inode *inode, int skip)
 		MSDOS_I(inode)->i_logstart = 0;
 	}
 	MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
-	fat_truncate_time(inode, NULL, S_CTIME|S_MTIME);
+	fat_truncate_time(inode, NULL, FAT_UPDATE_CMTIME);
 	if (wait) {
 		err = fat_sync_inode(inode);
 		if (err) {
@@ -553,15 +553,13 @@ int fat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	}
 
 	/*
-	 * setattr_copy can't truncate these appropriately, so we'll
-	 * copy them ourselves
+	 * setattr_copy can't truncate these appropriately, so we'll copy them
+	 * ourselves.  See fat_truncate_time for the c/mtime logic on fat.
 	 */
 	if (attr->ia_valid & ATTR_ATIME)
-		fat_truncate_time(inode, &attr->ia_atime, S_ATIME);
-	if (attr->ia_valid & ATTR_CTIME)
-		fat_truncate_time(inode, &attr->ia_ctime, S_CTIME);
+		fat_truncate_time(inode, &attr->ia_atime, FAT_UPDATE_ATIME);
 	if (attr->ia_valid & ATTR_MTIME)
-		fat_truncate_time(inode, &attr->ia_mtime, S_MTIME);
+		fat_truncate_time(inode, &attr->ia_mtime, FAT_UPDATE_CMTIME);
 	attr->ia_valid &= ~(ATTR_ATIME|ATTR_CTIME|ATTR_MTIME);
 
 	setattr_copy(idmap, inode, attr);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0b6009cd1844..59fa90617b5b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -246,7 +246,7 @@ static int fat_write_end(const struct kiocb *iocb,
 	if (err < len)
 		fat_write_failed(mapping, pos + len);
 	if (!(err < 0) && !(MSDOS_I(inode)->i_attrs & ATTR_ARCH)) {
-		fat_truncate_time(inode, NULL, S_CTIME|S_MTIME);
+		fat_truncate_time(inode, NULL, FAT_UPDATE_CMTIME);
 		MSDOS_I(inode)->i_attrs |= ATTR_ARCH;
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 950da09f0961..f4a1fa58bf05 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -299,43 +299,36 @@ struct timespec64 fat_truncate_atime(const struct msdos_sb_info *sbi,
 }
 
 /*
- * truncate mtime to 2 second granularity
- */
-struct timespec64 fat_truncate_mtime(const struct msdos_sb_info *sbi,
-				     const struct timespec64 *ts)
-{
-	return fat_timespec64_trunc_2secs(*ts);
-}
-
-/*
- * truncate the various times with appropriate granularity:
- *   all times in root node are always 0
+ * Update the in-inode atime and/or mtime after truncating the timestamp to the
+ * granularity.  All timestamps in root inode are always 0.
+ *
+ * ctime and mtime share the same on-disk field, and should be identical in
+ * memory.  All mtime updates will be applied to ctime, but ctime updates are
+ * ignored.
  */
-int fat_truncate_time(struct inode *inode, struct timespec64 *now, int flags)
+void fat_truncate_time(struct inode *inode, struct timespec64 *now,
+		unsigned int flags)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	struct timespec64 ts;
 
 	if (inode->i_ino == MSDOS_ROOT_INO)
-		return 0;
+		return;
 
 	if (now == NULL) {
 		now = &ts;
 		ts = current_time(inode);
 	}
 
-	if (flags & S_ATIME)
+	if (flags & FAT_UPDATE_ATIME)
 		inode_set_atime_to_ts(inode, fat_truncate_atime(sbi, now));
-	/*
-	 * ctime and mtime share the same on-disk field, and should be
-	 * identical in memory. all mtime updates will be applied to ctime,
-	 * but ctime updates are ignored.
-	 */
-	if (flags & S_MTIME)
-		inode_set_mtime_to_ts(inode,
-				      inode_set_ctime_to_ts(inode, fat_truncate_mtime(sbi, now)));
+	if (flags & FAT_UPDATE_CMTIME) {
+		/* truncate mtime to 2 second granularity */
+		struct timespec64 mtime = fat_timespec64_trunc_2secs(*now);
 
-	return 0;
+		inode_set_mtime_to_ts(inode, mtime);
+		inode_set_ctime_to_ts(inode, mtime);
+	}
 }
 EXPORT_SYMBOL_GPL(fat_truncate_time);
 
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 0b920ee40a7f..ba0152ed0810 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -251,7 +251,7 @@ static int msdos_add_entry(struct inode *dir, const unsigned char *name,
 	if (err)
 		return err;
 
-	fat_truncate_time(dir, ts, S_CTIME|S_MTIME);
+	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(dir))
 		(void)fat_sync_inode(dir);
 	else
@@ -295,7 +295,7 @@ static int msdos_create(struct mnt_idmap *idmap, struct inode *dir,
 		err = PTR_ERR(inode);
 		goto out;
 	}
-	fat_truncate_time(inode, &ts, S_ATIME|S_CTIME|S_MTIME);
+	fat_truncate_time(inode, &ts, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
 	d_instantiate(dentry, inode);
@@ -328,7 +328,6 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	drop_nlink(dir);
 
 	clear_nlink(inode);
-	fat_truncate_time(inode, NULL, S_CTIME);
 	fat_detach(inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -382,7 +381,7 @@ static struct dentry *msdos_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 		goto out;
 	}
 	set_nlink(inode, 2);
-	fat_truncate_time(inode, &ts, S_ATIME|S_CTIME|S_MTIME);
+	fat_truncate_time(inode, &ts, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
 	d_instantiate(dentry, inode);
@@ -415,7 +414,6 @@ static int msdos_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 	clear_nlink(inode);
-	fat_truncate_time(inode, NULL, S_CTIME);
 	fat_detach(inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -480,7 +478,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 				mark_inode_dirty(old_inode);
 
 			inode_inc_iversion(old_dir);
-			fat_truncate_time(old_dir, NULL, S_CTIME|S_MTIME);
+			fat_truncate_time(old_dir, NULL, FAT_UPDATE_CMTIME);
 			if (IS_DIRSYNC(old_dir))
 				(void)fat_sync_inode(old_dir);
 			else
@@ -540,7 +538,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	if (err)
 		goto error_dotdot;
 	inode_inc_iversion(old_dir);
-	fat_truncate_time(old_dir, &ts, S_CTIME|S_MTIME);
+	fat_truncate_time(old_dir, &ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(old_dir))
 		(void)fat_sync_inode(old_dir);
 	else
@@ -550,7 +548,6 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
-		fat_truncate_time(new_inode, &ts, S_CTIME);
 	}
 out:
 	brelse(sinfo.bh);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 5dbc4cbb8fce..e46f34cade1a 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -676,7 +676,7 @@ static int vfat_add_entry(struct inode *dir, const struct qstr *qname,
 		goto cleanup;
 
 	/* update timestamp */
-	fat_truncate_time(dir, ts, S_CTIME|S_MTIME);
+	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(dir))
 		(void)fat_sync_inode(dir);
 	else
@@ -806,7 +806,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	drop_nlink(dir);
 
 	clear_nlink(inode);
-	fat_truncate_time(inode, NULL, S_ATIME|S_MTIME);
+	fat_truncate_time(inode, NULL, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	fat_detach(inode);
 	vfat_d_version_set(dentry, inode_query_iversion(dir));
 out:
@@ -832,7 +832,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 	clear_nlink(inode);
-	fat_truncate_time(inode, NULL, S_ATIME|S_MTIME);
+	fat_truncate_time(inode, NULL, FAT_UPDATE_ATIME | FAT_UPDATE_CMTIME);
 	fat_detach(inode);
 	vfat_d_version_set(dentry, inode_query_iversion(dir));
 out:
@@ -918,7 +918,7 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
 static void vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
 {
 	inode_inc_iversion(dir);
-	fat_truncate_time(dir, ts, S_CTIME | S_MTIME);
+	fat_truncate_time(dir, ts, FAT_UPDATE_CMTIME);
 	if (IS_DIRSYNC(dir))
 		(void)fat_sync_inode(dir);
 	else
@@ -996,7 +996,6 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
-		fat_truncate_time(new_inode, &ts, S_CTIME);
 	}
 out:
 	brelse(sinfo.bh);
-- 
2.47.3


