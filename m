Return-Path: <io-uring+bounces-11667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 091D3D1C62C
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:36:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBE313099531
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A6732D0E6;
	Wed, 14 Jan 2026 04:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mRHzsbt/"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90992EA743;
	Wed, 14 Jan 2026 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365117; cv=none; b=oLs3prZ3s9MW7GpLjJ59vSAbVGtAVXrXs6IR8jnbAnGo8UqZbBh/PUuGxUuEGRU8B0961E7W0oU5drQ+/Ciy5/6kGilaY2mx0ohk+nf5XFSIHhA4widinXA4g1nf8XX1ia9ujoDHLwLyW642rG2Qo7liVpJYCjghSegymUUJGwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365117; c=relaxed/simple;
	bh=IzrgXOT9z6vkgtrPDIdf13q7qyMmn+4ybA/ta0J+TBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItOtolMRsUAMghvxolNU0zua46j0176+VZSkz5ejNEn9/AgY47+VXDS4QfgzDuwM3VOG9K7/zW8FqxYp8cuWKcW5CdS2od1s6/O8HciPA26UduTvCWDfmFtBVllVnavGPYQDrcyKPR8ClScRoKcb0FwQC2ix1TdX3xOp11wqjJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mRHzsbt/; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qlZnLmrphR+14Jm/ap5jKQC7QyDfASXXE6J1NbaMqlo=; b=mRHzsbt/EMjM0RGmJYUjo5wW1N
	NEHDBphqWm6gzFbTK5kdMXVtZIzmzYzBWMIYp5QGSLzyYKxG20QIyBSsnUffrIOGysBPcjc3BGLVG
	Ey1m5PoPIs+nxHqsLFwvK6lhwdZMq0YYH3frOgAm2bziBEv6ldTTKAMUCF0+wePAjt493w0mggWxy
	fEH6ZtySdHOz170rhW7fS1zCMfZHzUVeWKMHuECX6myaU+6igVdpThoYiT7oyfTTzIZ3zHujHIQgE
	u5GznV1YlZXbeja/wTvaZenli2BXGhKZQOC7igT/yFDmYd4q2EyEhR+you+px82p1K0mVWlvu3eM2
	l5Ri9j3w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZE-0000000GInZ-1akx;
	Wed, 14 Jan 2026 04:33:12 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>,
	audit@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 16/68] ntfs: ->d_compare() must not block
Date: Wed, 14 Jan 2026 04:32:18 +0000
Message-ID: <20260114043310.3885463-17-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

... so don't use __getname() there.  Switch it (and ntfs_d_hash(), while
we are at it) to kmalloc(PATH_MAX, GFP_NOWAIT).  Yes, ntfs_d_hash()
almost certainly can do with smaller allocations, but let ntfs folks
deal with that - keep the allocation size as-is for now.

Stop abusing names_cachep in ntfs, period - various uses of that thing
in there have nothing to do with pathnames; just use k[mz]alloc() and
be done with that.  For now let's keep sizes as-in, but AFAICS none of
the users actually want PATH_MAX.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ntfs3/dir.c    |  5 ++---
 fs/ntfs3/fsntfs.c |  4 ++--
 fs/ntfs3/inode.c  | 13 ++++++-------
 fs/ntfs3/namei.c  | 17 ++++++++---------
 fs/ntfs3/xattr.c  |  5 ++---
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index b98e95d6b4d9..cf038d713f50 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -423,8 +423,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	/* Allocate PATH_MAX bytes. */
-	name = __getname();
+	name = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
 
@@ -502,7 +501,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 
 out:
 
-	__putname(name);
+	kfree(name);
 	put_indx_node(node);
 
 	if (err == 1) {
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 5f138f715835..bd67ba7b5015 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2627,7 +2627,7 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 	u32 uni_bytes;
 	struct ntfs_inode *ni = sbi->volume.ni;
 	/* Allocate PATH_MAX bytes. */
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 
 	if (!uni)
 		return -ENOMEM;
@@ -2671,6 +2671,6 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 		err = _ni_write_inode(&ni->vfs_inode, 0);
 
 out:
-	__putname(uni);
+	kfree(uni);
 	return err;
 }
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0a9ac5efeb67..edfb973e4e82 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1281,7 +1281,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 		fa |= FILE_ATTRIBUTE_READONLY;
 
 	/* Allocate PATH_MAX bytes. */
-	new_de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	new_de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!new_de) {
 		err = -ENOMEM;
 		goto out1;
@@ -1702,7 +1702,7 @@ int ntfs_create_inode(struct mnt_idmap *idmap, struct inode *dir,
 	ntfs_mark_rec_free(sbi, ino, false);
 
 out2:
-	__putname(new_de);
+	kfree(new_de);
 	kfree(rp);
 
 out1:
@@ -1723,7 +1723,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	struct NTFS_DE *de;
 
 	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1737,7 +1737,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 
 	err = ni_add_name(ntfs_i(d_inode(dentry->d_parent)), ni, de);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -1760,8 +1760,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 	if (ntfs_is_meta_file(sbi, ni->mi.rno))
 		return -EINVAL;
 
-	/* Allocate PATH_MAX bytes. */
-	de = kmem_cache_zalloc(names_cachep, GFP_KERNEL);
+	de = kzalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -1797,7 +1796,7 @@ int ntfs_unlink_inode(struct inode *dir, const struct dentry *dentry)
 
 out:
 	ni_unlock(ni);
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 3b24ca02de61..b2af8f695e60 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -68,7 +68,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 				  u32 flags)
 {
 	struct ntfs_inode *ni = ntfs_i(dir);
-	struct cpu_str *uni = __getname();
+	struct cpu_str *uni = kmalloc(PATH_MAX, GFP_KERNEL);
 	struct inode *inode;
 	int err;
 
@@ -85,7 +85,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 			inode = dir_search_u(dir, uni, NULL);
 			ni_unlock(ni);
 		}
-		__putname(uni);
+		kfree(uni);
 	}
 
 	/*
@@ -303,8 +303,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 			return err;
 	}
 
-	/* Allocate PATH_MAX bytes. */
-	de = __getname();
+	de = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!de)
 		return -ENOMEM;
 
@@ -349,7 +348,7 @@ static int ntfs_rename(struct mnt_idmap *idmap, struct inode *dir,
 	ni_unlock(ni);
 	ni_unlock(dir_ni);
 out:
-	__putname(de);
+	kfree(de);
 	return err;
 }
 
@@ -407,7 +406,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
+	uni = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -429,7 +428,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	kmem_cache_free(names_cachep, uni);
+	kfree(uni);
 	return err;
 }
 
@@ -468,7 +467,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	 * Try slow way with current upcase table
 	 */
 	sbi = dentry->d_sb->s_fs_info;
-	uni1 = __getname();
+	uni1 = kmalloc(PATH_MAX, GFP_NOWAIT);
 	if (!uni1)
 		return -ENOMEM;
 
@@ -498,7 +497,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	ret = !ntfs_cmp_names_cpu(uni1, uni2, sbi->upcase, false) ? 0 : 1;
 
 out:
-	__putname(uni1);
+	kfree(uni1);
 	return ret;
 }
 
diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index c93df55e98d0..f3bb2c41c000 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -556,8 +556,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (unlikely(is_bad_ni(ni)))
 		return ERR_PTR(-EINVAL);
 
-	/* Allocate PATH_MAX bytes. */
-	buf = __getname();
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -588,7 +587,7 @@ struct posix_acl *ntfs_get_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (!IS_ERR(acl))
 		set_cached_acl(inode, type, acl);
 
-	__putname(buf);
+	kfree(buf);
 
 	return acl;
 }
-- 
2.47.3


