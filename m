Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857A0302E6E
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 22:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbhAYVs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 16:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732831AbhAYVia (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 16:38:30 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFD2C06178C
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 13:36:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id jx18so444417pjb.5
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 13:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RR9cpc0li7Cy+iCgVs2UGz+g/+/e/QO8xrsdnQqT/gg=;
        b=wii1ffPVA3hIzWmH5KIsG1GQDdIuO8KDZKbOfoQPdGUcgsJGiUHVtBbVmfkOkAxh+W
         O+t4/wSGF85iniqlxD3JAtkmtDd7AdVYYUB/ZRPDX3s9E67C2kDpWrNvCBTpmpla4djB
         vcLr525VjgEYKFhXAvKodhKxT9clEB6uSHBSJuQmwBcZ/I64M98g0E7s8i5JG/7MAFyg
         XG/KsoSRfrS3KINnWh7R/5SfShRFSsO+pbLXdZeJVtgDSTp0GM/Hz15CiBPcbvmtBJph
         V26UaI0H9obAUwiGAv+8kRvgj1ByXlrQHaeB+ttp/m89lByMO7fv69XbI7eDn9NB+qC2
         DMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RR9cpc0li7Cy+iCgVs2UGz+g/+/e/QO8xrsdnQqT/gg=;
        b=a0bQtEcQrvncOG/C56Levp15mo2Cr/Ve8p7+zLwdKQg07mFsxJBPbLhpjJpbW805Yd
         6Gd1pfVgnr/8eOXp4ZajPbSUZ5KmuvZfJ2LlatvzGFF4v7EVbCR3uun3RZejldMShjoR
         LdEjfvOQyij73UMVFeAWZ3WEs0mHNuglyy025drXMCXSxkCTbw4ClGIWZjVXXgIpP7XF
         vNGSdtSoVIIE9sy7SIlHM1/ZRx7r2ExIk3N1QKkXuEO9Qrq+pPqynfYPIgK2uptAHAtE
         6P4+tSlDByZoX0U9aUFkD+GLEQ9LwHkf1W2eW0O4cCCCQHf1kmtduPcvokQJGEiEXiQA
         ijSA==
X-Gm-Message-State: AOAM532JxZwxjbU7kkfxmTNFhLNRZW+5+Olva81xfKlA0/tAgs71GKVm
        qZHJdhqLJQuRyA7KPvfPhe0Mug==
X-Google-Smtp-Source: ABdhPJwYgfaMvJqHezZ5Re+AtxEPtis0t9QhAKBCdB3riDe/w3lTbIOWOlI5/VjPObLr0DN3Lehrtg==
X-Received: by 2002:a17:90a:db4c:: with SMTP id u12mr2219251pjx.14.1611610586167;
        Mon, 25 Jan 2021 13:36:26 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i3sm9638913pfq.194.2021.01.25.13.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:36:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] fs: ensure that ->getattr() honors AT_STATX_CACHED
Date:   Mon, 25 Jan 2021 14:36:13 -0700
Message-Id: <20210125213614.24001-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125213614.24001-1-axboe@kernel.dk>
References: <20210125213614.24001-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For filesystems that provide a private ->getattr() implementation, some of
them need to do IO to satisfy the request. If we need to block off
->getattr() and AT_STATX_CACHED is set, then return -EAGAIN and have the
caller retry.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/9p/vfs_inode.c   | 2 ++
 fs/afs/inode.c      | 3 +++
 fs/ceph/inode.c     | 2 ++
 fs/cifs/inode.c     | 3 +++
 fs/coda/inode.c     | 7 ++++++-
 fs/ecryptfs/inode.c | 3 +++
 fs/fuse/dir.c       | 2 ++
 fs/gfs2/inode.c     | 2 ++
 fs/kernfs/inode.c   | 8 +++++++-
 fs/nfs/inode.c      | 3 +++
 fs/ocfs2/file.c     | 3 +++
 fs/orangefs/inode.c | 3 +++
 fs/ubifs/dir.c      | 7 ++++++-
 fs/udf/symlink.c    | 3 +++
 fs/vboxsf/utils.c   | 4 ++++
 15 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 4a937fac1acb..291d74bcf582 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1030,6 +1030,8 @@ v9fs_vfs_getattr(const struct path *path, struct kstat *stat,
 		generic_fillattr(d_inode(dentry), stat);
 		return 0;
 	}
+	if (flags & AT_STATX_CACHED)
+		return -EAGAIN;
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid))
 		return PTR_ERR(fid);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index b0d7b892090d..19ba728ff18f 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -743,6 +743,9 @@ int afs_getattr(const struct path *path, struct kstat *stat,
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
+	if (query_flags & AT_STATX_CACHED)
+		return -EAGAIN;
+
 	do {
 		read_seqbegin_or_lock(&vnode->cb_lock, &seq);
 		generic_fillattr(inode, stat);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index adc8fc3c5d85..997f380646fd 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2378,6 +2378,8 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
 
 	/* Skip the getattr altogether if we're asked not to sync */
 	if (!(flags & AT_STATX_DONT_SYNC)) {
+		if (flags & AT_STATX_CACHED)
+			return -EAGAIN;
 		err = ceph_do_getattr(inode,
 				statx_to_caps(request_mask, inode->i_mode),
 				flags & AT_STATX_FORCE_SYNC);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a83b3a8ffaac..1f8007caa27c 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2379,6 +2379,9 @@ int cifs_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(dentry);
 	int rc;
 
+	if (flags & AT_STATX_CACHED)
+		return -EAGAIN;
+
 	/*
 	 * We need to be sure that all dirty pages are written and the server
 	 * has actual ctime, mtime and file length.
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index b1c70e2b9b1e..444f1ef97b08 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -254,7 +254,12 @@ static void coda_evict_inode(struct inode *inode)
 int coda_getattr(const struct path *path, struct kstat *stat,
 		 u32 request_mask, unsigned int flags)
 {
-	int err = coda_revalidate_inode(d_inode(path->dentry));
+	int err;
+
+	if (flags & AT_STATX_CACHED)
+		return -EAGAIN;
+
+	err = coda_revalidate_inode(d_inode(path->dentry));
 	if (!err)
 		generic_fillattr(d_inode(path->dentry), stat);
 	return err;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index e23752d9a79f..61fdb5a0dbdc 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -980,6 +980,9 @@ static int ecryptfs_getattr_link(const struct path *path, struct kstat *stat,
 		char *target;
 		size_t targetsiz;
 
+		if (flags & AT_STATX_CACHED)
+			return -EAGAIN;
+
 		target = ecryptfs_readlink_lower(dentry, &targetsiz);
 		if (!IS_ERR(target)) {
 			kfree(target);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 78f9f209078c..638722d3c1ed 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1084,6 +1084,8 @@ static int fuse_update_get_attr(struct inode *inode, struct file *file,
 		sync = time_before64(fi->i_time, get_jiffies_64());
 
 	if (sync) {
+		if (flags & AT_STATX_CACHED)
+			return -EAGAIN;
 		forget_all_cached_acls(inode);
 		err = fuse_do_getattr(inode, stat, file);
 	} else if (stat) {
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c1b77e8d6b1c..3d485d9f1afe 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2032,6 +2032,8 @@ static int gfs2_getattr(const struct path *path, struct kstat *stat,
 
 	gfs2_holder_mark_uninitialized(&gh);
 	if (gfs2_glock_is_locked_by_me(ip->i_gl) == NULL) {
+		if (flags & AT_STATX_CACHED)
+			return -EAGAIN;
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
 		if (error)
 			return error;
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index fc2469a20fed..2193b3c0b9cd 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -189,7 +189,13 @@ int kernfs_iop_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	struct kernfs_node *kn = inode->i_private;
 
-	mutex_lock(&kernfs_mutex);
+	if (query_flags & AT_STATX_CACHED) {
+		if (!mutex_trylock(&kernfs_mutex))
+			return -EAGAIN;
+	} else {
+		mutex_lock(&kernfs_mutex);
+	}
+
 	kernfs_refresh_inode(kn, inode);
 	mutex_unlock(&kernfs_mutex);
 
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 522aa10a1a3e..1eb167c14884 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -799,6 +799,9 @@ int nfs_getattr(const struct path *path, struct kstat *stat,
 
 	trace_nfs_getattr_enter(inode);
 
+	if (query_flags & AT_STATX_CACHED)
+		return -EAGAIN;
+
 	if ((query_flags & AT_STATX_DONT_SYNC) && !force_sync) {
 		nfs_readdirplus_parent_cache_hit(path->dentry);
 		goto out_no_update;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 85979e2214b3..e48d0c33fb46 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1306,6 +1306,9 @@ int ocfs2_getattr(const struct path *path, struct kstat *stat,
 	struct ocfs2_super *osb = sb->s_fs_info;
 	int err;
 
+	if (flags & AT_STATX_CACHED)
+		return -EAGAIN;
+
 	err = ocfs2_inode_revalidate(path->dentry);
 	if (err) {
 		if (err != -ENOENT)
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 48f0547d4850..4864334e40e8 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -900,6 +900,9 @@ int orangefs_getattr(const struct path *path, struct kstat *stat,
 		     "orangefs_getattr: called on %pd mask %u\n",
 		     path->dentry, request_mask);
 
+	if (flags & AT_STATX_CACHED)
+		return -EAGAIN;
+
 	ret = orangefs_inode_getattr(inode,
 	    request_mask & STATX_SIZE ? ORANGEFS_GETATTR_SIZE : 0);
 	if (ret == 0) {
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 9a6b8660425a..c199b260c50c 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1573,7 +1573,12 @@ int ubifs_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	struct ubifs_inode *ui = ubifs_inode(inode);
 
-	mutex_lock(&ui->ui_mutex);
+	if (flags & AT_STATX_CACHED) {
+		if (!mutex_trylock(&ui->ui_mutex))
+			return -EAGAIN;
+	} else {
+		mutex_lock(&ui->ui_mutex);
+	}
 
 	if (ui->flags & UBIFS_APPEND_FL)
 		stat->attributes |= STATX_ATTR_APPEND;
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index c973db239604..0edd973b8a43 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -159,6 +159,9 @@ static int udf_symlink_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_backing_inode(dentry);
 	struct page *page;
 
+	if (flags & AT_STATX_CACHED)
+		return -EAGAIN;
+
 	generic_fillattr(inode, stat);
 	page = read_mapping_page(inode->i_mapping, 0, NULL);
 	if (IS_ERR(page))
diff --git a/fs/vboxsf/utils.c b/fs/vboxsf/utils.c
index 018057546067..dc93cd59290d 100644
--- a/fs/vboxsf/utils.c
+++ b/fs/vboxsf/utils.c
@@ -228,6 +228,10 @@ int vboxsf_getattr(const struct path *path, struct kstat *kstat,
 		sf_i->force_restat = 1;
 		fallthrough;
 	default:
+		if (flags & AT_STATX_CACHED) {
+			err = -EAGAIN;
+			break;
+		}
 		err = vboxsf_inode_revalidate(dentry);
 	}
 	if (err)
-- 
2.30.0

