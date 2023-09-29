Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50E17B342B
	for <lists+io-uring@lfdr.de>; Fri, 29 Sep 2023 16:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjI2OFC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Sep 2023 10:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjI2OFB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Sep 2023 10:05:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1671A8;
        Fri, 29 Sep 2023 07:04:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0B4951F390;
        Fri, 29 Sep 2023 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695996298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nMbeaIYXvbq/ZWZAZSKM3DOZf7GxOAPwhSfkSzXE8t8=;
        b=JtV8swiw0D1i8aVrxYf/Vqs+nAVJG5IGGNSCNoj849C7XMRkDpMgi7UbHCea47YqK83hqC
        uwRzTnbG3MhGKqyzA4jfUOsz5bTS/npeJgxHPMmOu6bnQqUqEDKwKgtXx5MyxS+KODdRBO
        M4wZNdmVpd2ijJBpKMpINq2OyY1ar/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695996298;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nMbeaIYXvbq/ZWZAZSKM3DOZf7GxOAPwhSfkSzXE8t8=;
        b=MiUZ4m76XxBMnES0KJBJyhWvce8iLz7BsEBlUqp0SHIlIO9nLnADpV2uBsTKq7xLMkbzxH
        PurlohJZ3sr03fAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84F781390A;
        Fri, 29 Sep 2023 14:04:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KplxHYnZFmXqEQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 29 Sep 2023 14:04:57 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 14ef5f16;
        Fri, 29 Sep 2023 14:04:56 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Luis Henriques <lhenriques@suse.de>
Subject: [RFC PATCH] fs: add AT_EMPTY_PATH support to unlinkat()
Date:   Fri, 29 Sep 2023 15:04:56 +0100
Message-Id: <20230929140456.23767-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The linkat() syscall has support for the AT_EMPTY_PATH linux-specific flag
for a long time.  This flag allows callers to use an empty string in the
'oldpath' parameter, and to create the link to the file descriptor instead.

This patch modifies the unlinkat() syscall to use a similar semantic for
this flag, i.e. to allow for an empty string to indicate that we want to
unlink the file descriptor inode.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
Hi!

I'm sending an early RFC of this patch specially because I'm not sure how
useful it is, and if support for this flag is really welcome.

The code is already a bit messy, and adding support for this extra flag
makes it even worse.  Maybe it could be refactored; suggestions are
welcome.

Also, this patch is only lightly tested -- it doesn't seem to break
anything, but I'll need to test it some more.  But as I said, I wanted to
get some feedback to make sure this patch is worth the trouble.

To be honest, this patch wasn't my idea: I remember seeing someone
somewhere suggesting or asking this flag to be added.  But it was long
time ago, I've written down the idea but I forgot keep a reference to the
source.  So, I hope the patch _may_ be useful to someone and that it's
purpose isn't just to make these two syscalls more symmetric (which is a
honourable goal in itself, if you ask my opinion! :-) ).

Cheers,
--
Luís

 fs/coredump.c |   2 +-
 fs/init.c     |   4 +-
 fs/internal.h |   4 +-
 fs/namei.c    | 112 +++++++++++++++++++++++++++++++-------------------
 io_uring/fs.c |   4 +-
 5 files changed, 76 insertions(+), 50 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 9d235fa14ab9..3e0b291fd60f 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -672,7 +672,7 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 			 * If it doesn't exist, that's fine. If there's some
 			 * other problem, we'll catch it at the filp_open().
 			 */
-			do_unlinkat(AT_FDCWD, getname_kernel(cn.corename));
+			do_unlinkat(AT_FDCWD, getname_kernel(cn.corename), 0);
 		}
 
 		/*
diff --git a/fs/init.c b/fs/init.c
index 9684406a8416..03ce144b4a63 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -217,7 +217,7 @@ int __init init_symlink(const char *oldname, const char *newname)
 
 int __init init_unlink(const char *pathname)
 {
-	return do_unlinkat(AT_FDCWD, getname_kernel(pathname));
+	return do_unlinkat(AT_FDCWD, getname_kernel(pathname), 0);
 }
 
 int __init init_mkdir(const char *pathname, umode_t mode)
@@ -241,7 +241,7 @@ int __init init_mkdir(const char *pathname, umode_t mode)
 
 int __init init_rmdir(const char *pathname)
 {
-	return do_rmdir(AT_FDCWD, getname_kernel(pathname));
+	return do_rmdir(AT_FDCWD, getname_kernel(pathname), 0);
 }
 
 int __init init_utimes(char *filename, struct timespec64 *ts)
diff --git a/fs/internal.h b/fs/internal.h
index d64ae03998cc..77018a31812b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -53,8 +53,8 @@ extern int finish_clean_context(struct fs_context *fc);
  */
 extern int filename_lookup(int dfd, struct filename *name, unsigned flags,
 			   struct path *path, struct path *root);
-int do_rmdir(int dfd, struct filename *name);
-int do_unlinkat(int dfd, struct filename *name);
+int do_rmdir(int dfd, struct filename *name, int flags);
+int do_unlinkat(int dfd, struct filename *name, int flags);
 int may_linkat(struct mnt_idmap *idmap, const struct path *link);
 int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
 		 struct filename *newname, unsigned int flags);
diff --git a/fs/namei.c b/fs/namei.c
index 156a570d7831..4327fffd8330 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4218,37 +4218,50 @@ int vfs_rmdir(struct mnt_idmap *idmap, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_rmdir);
 
-int do_rmdir(int dfd, struct filename *name)
+int do_rmdir(int dfd, struct filename *name, int flags)
 {
 	int error;
-	struct dentry *dentry;
+	struct dentry *dentry, *parent;
 	struct path path;
 	struct qstr last;
 	int type;
 	unsigned int lookup_flags = 0;
-retry:
-	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
-	if (error)
-		goto exit1;
+	bool empty_path = (flags & AT_EMPTY_PATH);
 
-	switch (type) {
-	case LAST_DOTDOT:
-		error = -ENOTEMPTY;
-		goto exit2;
-	case LAST_DOT:
-		error = -EINVAL;
-		goto exit2;
-	case LAST_ROOT:
-		error = -EBUSY;
-		goto exit2;
+retry:
+	if (empty_path) {
+		error = filename_lookup(dfd, name, 0, &path, NULL);
+		if (error)
+			goto exit1;
+		parent = path.dentry->d_parent;
+		dentry = path.dentry;
+	} else {
+		error = filename_parentat(dfd, name, lookup_flags, &path, &last,
+					  &type);
+		if (error)
+			goto exit1;
+
+		switch (type) {
+		case LAST_DOTDOT:
+			error = -ENOTEMPTY;
+			goto exit2;
+		case LAST_DOT:
+			error = -EINVAL;
+			goto exit2;
+		case LAST_ROOT:
+			error = -EBUSY;
+			goto exit2;
+		}
+		parent = path.dentry;
 	}
 
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto exit2;
 
-	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
-	dentry = lookup_one_qstr_excl(&last, path.dentry, lookup_flags);
+	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
+	if (!empty_path)
+		dentry = lookup_one_qstr_excl(&last, path.dentry, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit3;
@@ -4259,11 +4272,12 @@ int do_rmdir(int dfd, struct filename *name)
 	error = security_path_rmdir(&path, dentry);
 	if (error)
 		goto exit4;
-	error = vfs_rmdir(mnt_idmap(path.mnt), path.dentry->d_inode, dentry);
+	error = vfs_rmdir(mnt_idmap(path.mnt), parent->d_inode, dentry);
 exit4:
-	dput(dentry);
+	if (!empty_path)
+		dput(dentry);
 exit3:
-	inode_unlock(path.dentry->d_inode);
+	inode_unlock(parent->d_inode);
 	mnt_drop_write(path.mnt);
 exit2:
 	path_put(&path);
@@ -4278,7 +4292,7 @@ int do_rmdir(int dfd, struct filename *name)
 
 SYSCALL_DEFINE1(rmdir, const char __user *, pathname)
 {
-	return do_rmdir(AT_FDCWD, getname(pathname));
+	return do_rmdir(AT_FDCWD, getname(pathname), 0);
 }
 
 /**
@@ -4357,48 +4371,60 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-int do_unlinkat(int dfd, struct filename *name)
+int do_unlinkat(int dfd, struct filename *name, int flags)
 {
 	int error;
-	struct dentry *dentry;
+	struct dentry *dentry, *parent;
 	struct path path;
 	struct qstr last;
 	int type;
 	struct inode *inode = NULL;
 	struct inode *delegated_inode = NULL;
 	unsigned int lookup_flags = 0;
-retry:
-	error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
-	if (error)
-		goto exit1;
+	bool empty_path = (flags & AT_EMPTY_PATH);
 
-	error = -EISDIR;
-	if (type != LAST_NORM)
-		goto exit2;
+retry:
+	if (empty_path) {
+		error = filename_lookup(dfd, name, 0, &path, NULL);
+		if (error)
+			goto exit1;
+		parent = path.dentry->d_parent;
+		dentry = path.dentry;
+	} else {
+		error = filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
+		if (error)
+			goto exit1;
+		error = -EISDIR;
+		if (type != LAST_NORM)
+			goto exit2;
+		parent = path.dentry;
+	}
 
 	error = mnt_want_write(path.mnt);
 	if (error)
 		goto exit2;
 retry_deleg:
-	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
-	dentry = lookup_one_qstr_excl(&last, path.dentry, lookup_flags);
+	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
+	if (!empty_path)
+		dentry = lookup_one_qstr_excl(&last, parent, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
 
 		/* Why not before? Because we want correct error value */
-		if (last.name[last.len] || d_is_negative(dentry))
+		if ((!empty_path && last.name[last.len]) || d_is_negative(dentry))
 			goto slashes;
 		inode = dentry->d_inode;
 		ihold(inode);
 		error = security_path_unlink(&path, dentry);
 		if (error)
 			goto exit3;
-		error = vfs_unlink(mnt_idmap(path.mnt), path.dentry->d_inode,
+		error = vfs_unlink(mnt_idmap(path.mnt), parent->d_inode,
 				   dentry, &delegated_inode);
 exit3:
-		dput(dentry);
+		if (!empty_path)
+			dput(dentry);
 	}
-	inode_unlock(path.dentry->d_inode);
+	inode_unlock(parent->d_inode);
 	if (inode)
 		iput(inode);	/* truncate the inode here */
 	inode = NULL;
@@ -4429,19 +4455,19 @@ int do_unlinkat(int dfd, struct filename *name)
 	goto exit3;
 }
 
-SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
+SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flags)
 {
-	if ((flag & ~AT_REMOVEDIR) != 0)
+	if ((flags & ~(AT_REMOVEDIR | AT_EMPTY_PATH)) != 0)
 		return -EINVAL;
 
-	if (flag & AT_REMOVEDIR)
-		return do_rmdir(dfd, getname(pathname));
-	return do_unlinkat(dfd, getname(pathname));
+	if (flags & AT_REMOVEDIR)
+		return do_rmdir(dfd, getname_uflags(pathname, flags), flags);
+	return do_unlinkat(dfd, getname_uflags(pathname, flags), flags);
 }
 
 SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 {
-	return do_unlinkat(AT_FDCWD, getname(pathname));
+	return do_unlinkat(AT_FDCWD, getname(pathname), 0);
 }
 
 /**
diff --git a/io_uring/fs.c b/io_uring/fs.c
index f6a69a549fd4..c62e53367072 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -135,9 +135,9 @@ int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
 	if (un->flags & AT_REMOVEDIR)
-		ret = do_rmdir(un->dfd, un->filename);
+		ret = do_rmdir(un->dfd, un->filename, 0);
 	else
-		ret = do_unlinkat(un->dfd, un->filename);
+		ret = do_unlinkat(un->dfd, un->filename, 0);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
