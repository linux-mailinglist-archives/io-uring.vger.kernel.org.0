Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B652E78898A
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 15:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243942AbjHYN7M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 09:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245446AbjHYN6v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 09:58:51 -0400
Received: from out-243.mta1.migadu.com (out-243.mta1.migadu.com [IPv6:2001:41d0:203:375::f3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4393F26A8
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 06:58:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692971902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/SxFJtissRd8EFEKfjvtrzUrKe2UZWHAXBAv8XN+2Ws=;
        b=H+vckW3ukzz5hjvgszvW+1Vskdq8aMOiLkYCBE1Az9/xG1yWB6DZ1XyeKFMPNSqNSLbo4Q
        BK4s/Y8OqUoLH1ryggMh8Z7KOoNgKutNOuqFDsqEXi2EBbOwNmuW7uA4ULqzQhkjnOziKD
        v+STrU9jb3kQlof7g0vxHj3RnnOLFJ0=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 07/29] vfs: add a nowait parameter for touch_atime()
Date:   Fri, 25 Aug 2023 21:54:09 +0800
Message-Id: <20230825135431.1317785-8-hao.xu@linux.dev>
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a nowait boolean parameter for touch_atime() to support nowait
semantics. It is true only when io_uring is the initial caller.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/cachefiles/namei.c | 2 +-
 fs/ecryptfs/file.c    | 4 ++--
 fs/inode.c            | 7 ++++---
 fs/namei.c            | 4 ++--
 fs/nfsd/vfs.c         | 2 +-
 fs/overlayfs/file.c   | 2 +-
 fs/overlayfs/inode.c  | 2 +-
 fs/stat.c             | 2 +-
 include/linux/fs.h    | 4 ++--
 kernel/bpf/inode.c    | 4 ++--
 net/unix/af_unix.c    | 4 ++--
 11 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index d9d22d0ec38a..7a21bf0e36b8 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -591,7 +591,7 @@ static bool cachefiles_open_file(struct cachefiles_object *object,
 	 * used to keep track of culling, and atimes are only updated by read,
 	 * write and readdir but not lookup or open).
 	 */
-	touch_atime(&file->f_path);
+	touch_atime(&file->f_path, false);
 	dput(dentry);
 	return true;
 
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index ce0a3c5ed0ca..3db7006cc440 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -39,7 +39,7 @@ static ssize_t ecryptfs_read_update_atime(struct kiocb *iocb,
 	rc = generic_file_read_iter(iocb, to);
 	if (rc >= 0) {
 		path = ecryptfs_dentry_to_lower_path(file->f_path.dentry);
-		touch_atime(path);
+		touch_atime(path, false);
 	}
 	return rc;
 }
@@ -64,7 +64,7 @@ static ssize_t ecryptfs_splice_read_update_atime(struct file *in, loff_t *ppos,
 	rc = filemap_splice_read(in, ppos, pipe, len, flags);
 	if (rc >= 0) {
 		path = ecryptfs_dentry_to_lower_path(in->f_path.dentry);
-		touch_atime(path);
+		touch_atime(path, false);
 	}
 	return rc;
 }
diff --git a/fs/inode.c b/fs/inode.c
index 8fefb69e1f84..e83b836f2d09 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1961,17 +1961,17 @@ bool atime_needs_update(const struct path *path, struct inode *inode)
 	return true;
 }
 
-void touch_atime(const struct path *path)
+int touch_atime(const struct path *path, bool nowait)
 {
 	struct vfsmount *mnt = path->mnt;
 	struct inode *inode = d_inode(path->dentry);
 	struct timespec64 now;
 
 	if (!atime_needs_update(path, inode))
-		return;
+		return 0;
 
 	if (!sb_start_write_trylock(inode->i_sb))
-		return;
+		return 0;
 
 	if (__mnt_want_write(mnt) != 0)
 		goto skip_update;
@@ -1989,6 +1989,7 @@ void touch_atime(const struct path *path)
 	__mnt_drop_write(mnt);
 skip_update:
 	sb_end_write(inode->i_sb);
+	return 0;
 }
 EXPORT_SYMBOL(touch_atime);
 
diff --git a/fs/namei.c b/fs/namei.c
index e56ff39a79bc..35731d405730 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1776,12 +1776,12 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
 		return ERR_PTR(-ELOOP);
 
 	if (!(nd->flags & LOOKUP_RCU)) {
-		touch_atime(&last->link);
+		touch_atime(&last->link, false);
 		cond_resched();
 	} else if (atime_needs_update(&last->link, inode)) {
 		if (!try_to_unlazy(nd))
 			return ERR_PTR(-ECHILD);
-		touch_atime(&last->link);
+		touch_atime(&last->link, false);
 	}
 
 	error = security_inode_follow_link(link->dentry, inode,
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8a2321d19194..3179e7b5d209 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1569,7 +1569,7 @@ nfsd_readlink(struct svc_rqst *rqstp, struct svc_fh *fhp, char *buf, int *lenp)
 	if (unlikely(!d_is_symlink(path.dentry)))
 		return nfserr_inval;
 
-	touch_atime(&path);
+	touch_atime(&path, false);
 
 	link = vfs_get_link(path.dentry, &done);
 	if (IS_ERR(link))
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 21245b00722a..6ff466ef98ea 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -255,7 +255,7 @@ static void ovl_file_accessed(struct file *file)
 		inode->i_ctime = upperinode->i_ctime;
 	}
 
-	touch_atime(&file->f_path);
+	touch_atime(&file->f_path, false);
 }
 
 static rwf_t ovl_iocb_to_rwf(int ifl)
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a63e57447be9..66e03025e748 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -703,7 +703,7 @@ int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags)
 		};
 
 		if (upperpath.dentry) {
-			touch_atime(&upperpath);
+			touch_atime(&upperpath, false);
 			inode->i_atime = d_inode(upperpath.dentry)->i_atime;
 		}
 	}
diff --git a/fs/stat.c b/fs/stat.c
index 7c238da22ef0..713773e61110 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -485,7 +485,7 @@ static int do_readlinkat(int dfd, const char __user *pathname,
 		if (d_is_symlink(path.dentry) || inode->i_op->readlink) {
 			error = security_inode_readlink(path.dentry);
 			if (!error) {
-				touch_atime(&path);
+				touch_atime(&path, false);
 				error = vfs_readlink(path.dentry, buf, bufsiz);
 			}
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f3e315e8efdd..ba54879089ac 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2201,13 +2201,13 @@ enum file_time_flags {
 };
 
 extern bool atime_needs_update(const struct path *, struct inode *);
-extern void touch_atime(const struct path *);
+extern int touch_atime(const struct path *path, bool nowait);
 int inode_update_time(struct inode *inode, struct timespec64 *time, int flags);
 
 static inline void file_accessed(struct file *file)
 {
 	if (!(file->f_flags & O_NOATIME))
-		touch_atime(&file->f_path);
+		touch_atime(&file->f_path, false);
 }
 
 extern int file_modified(struct file *file);
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4174f76133df..bc020b45d5c8 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -517,7 +517,7 @@ static void *bpf_obj_do_get(int path_fd, const char __user *pathname,
 
 	raw = bpf_any_get(inode->i_private, *type);
 	if (!IS_ERR(raw))
-		touch_atime(&path);
+		touch_atime(&path, false);
 
 	path_put(&path);
 	return raw;
@@ -591,7 +591,7 @@ struct bpf_prog *bpf_prog_get_type_path(const char *name, enum bpf_prog_type typ
 		return ERR_PTR(ret);
 	prog = __get_prog_inode(d_backing_inode(path.dentry), type);
 	if (!IS_ERR(prog))
-		touch_atime(&path);
+		touch_atime(&path, false);
 	path_put(&path);
 	return prog;
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 123b35ddfd71..5868e4e47320 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1084,7 +1084,7 @@ static struct sock *unix_find_bsd(struct sockaddr_un *sunaddr, int addr_len,
 
 	err = -EPROTOTYPE;
 	if (sk->sk_type == type)
-		touch_atime(&path);
+		touch_atime(&path, false);
 	else
 		goto sock_put;
 
@@ -1114,7 +1114,7 @@ static struct sock *unix_find_abstract(struct net *net,
 
 	dentry = unix_sk(sk)->path.dentry;
 	if (dentry)
-		touch_atime(&unix_sk(sk)->path);
+		touch_atime(&unix_sk(sk)->path, false);
 
 	return sk;
 }
-- 
2.25.1

