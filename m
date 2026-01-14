Return-Path: <io-uring+bounces-11674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 704B4D1C65F
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 05:37:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B041C30AAE21
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B7982F0C7D;
	Wed, 14 Jan 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="SwIcN5cN"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00DB2D9780;
	Wed, 14 Jan 2026 04:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768365118; cv=none; b=XMRQqnLwHoDlbMgxyv5LZ/8O8l4QdVA56zmb1TMAWgWRgXwvsKY17oJCROYVWm1Le6+1qxcJYmTeU4ccITSc2vAK2TR2+vjHglmRR9T1BYlSeRYWSG0l6s8c1yrnqJD6KNIcY2L3iQnmbs6zPEWp7t04ef2qefzZQwxqn0fpw4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768365118; c=relaxed/simple;
	bh=fzcXAIuYtN+EDVhHduC2Ki1YNhIkJ0p1xZMV5HbtOGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXJmfMf3D0W0wnuLMHofXHZQ2swiR6t4hcs8qMnaXj/5ePiZiMfYL2ToL9+0s72E3ozlBr4IYndjmEySPuLA5TvU5BUdcB8rFxT6PMSUeUuND3CwiO0q1dIJqSw1xQqW4rvcwnaMy4bJ+mlYNZHECp2Sf2tU6lX0UFo1tGfogQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=SwIcN5cN; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MzXkE5Pp5+OvqrjtNelv1COgAPA0k3Isne8ZRPPwzV0=; b=SwIcN5cNufxUsQ7UPDm9kBUpWX
	cIifc/wWShDP0FMG6aO/KF4qVeBgpvaKY2hskCT98nHamAkt5PGQhmExozOeYU4VW861oeVYlOWsx
	JbSZvHceweTagOqgx76RY/JyAyphkAPSrKFaqLFg+mAF/V2raMoa3uyVf4KNxN0cyjYNvx638nVJi
	3hfoQlI3h6OUgM6Hwq4ZpFjLsF6owtgiPzpPNMD+yTC9fKVm8wuHCMCdezbFg2yYyv+gxz/2aCN85
	y9J88pC7gc3uhtztDURAaGFueqeao+nKdngL3GaqK1HBRLnbouKQ4MK1H2VDfbASTUWdtYB8RaDyP
	PPnwtt3A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfsZF-0000000GInq-1Whk;
	Wed, 14 Jan 2026 04:33:13 +0000
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
Subject: [PATCH v5 23/68] allow incomplete imports of filenames
Date: Wed, 14 Jan 2026 04:32:25 +0000
Message-ID: <20260114043310.3885463-24-viro@zeniv.linux.org.uk>
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

There are two filename-related problems in io_uring and its
interplay with audit.

Filenames are imported when request is submitted and used when
it is processed.  Unfortunately, the latter may very well
happen in a different thread.  In that case the reference to
filename is put into the wrong audit_context - that of submitting
thread, not the processing one.  Audit logics is called by
the latter, and it really wants to be able to find the names
in audit_context current (== processing) thread.

Another related problem is the headache with refcounts -
normally all references to given struct filename are visible
only to one thread (the one that uses that struct filename).
io_uring violates that - an extra reference is stashed in
audit_context of submitter.  It gets dropped when submitter
returns to userland, which can happen simultaneously with
processing thread deciding to drop the reference it got.

We paper over that by making refcount atomic, but that means
pointless headache for everyone.

Solution: the notion of partially imported filenames.  Namely,
already copied from userland, but *not* exposed to audit yet.

io_uring can create that in submitter thread, and complete the
import (obtaining the usual reference to struct filename) in
processing thread.

Object: struct delayed_filename.

Primitives for working with it:

delayed_getname(&delayed_filename, user_string) - copies the name from
userland, returning 0 and stashing the address of (still incomplete)
struct filename in delayed_filename on success and returning -E... on
error.

delayed_getname_uflags(&delayed_filename, user_string, atflags) -
similar, in the same relation to delayed_getname() as getname_uflags()
is to getname()

complete_getname(&delayed_filename) - completes the import of filename
stashed in delayed_filename and returns struct filename to caller,
emptying delayed_filename.

CLASS(filename_complete_delayed, name)(&delayed_filename) - variant of
CLASS(filename) with complete_getname() for constructor.

dismiss_delayed_filename(&delayed_filename) - destructor; drops whatever
might be stashed in delayed_filename, emptying it.

putname_to_delayed(&delayed_filename, name) - if name is shared, stashes
its copy into delayed_filename and drops the reference to name, otherwise
stashes the name itself in there.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c           |  66 +++++++++++++++++++++++++---
 include/linux/fs.h   |  12 +++++
 io_uring/fs.c        | 101 +++++++++++++++++++++++--------------------
 io_uring/openclose.c |  26 +++++------
 io_uring/statx.c     |  17 +++-----
 io_uring/xattr.c     |  30 +++++--------
 6 files changed, 157 insertions(+), 95 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f1a2161bd691..b76cc43fe89d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -172,8 +172,8 @@ static int getname_long(struct filename *name, const char __user *filename)
 	return 0;
 }
 
-struct filename *
-getname_flags(const char __user *filename, int flags)
+static struct filename *
+do_getname(const char __user *filename, int flags, bool incomplete)
 {
 	struct filename *result;
 	char *kname;
@@ -214,10 +214,17 @@ getname_flags(const char __user *filename, int flags)
 	}
 
 	initname(result);
-	audit_getname(result);
+	if (likely(!incomplete))
+		audit_getname(result);
 	return result;
 }
 
+struct filename *
+getname_flags(const char __user *filename, int flags)
+{
+	return do_getname(filename, flags, false);
+}
+
 struct filename *getname_uflags(const char __user *filename, int uflags)
 {
 	int flags = (uflags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
@@ -242,7 +249,7 @@ struct filename *__getname_maybe_null(const char __user *pathname)
 	return no_free_ptr(name);
 }
 
-struct filename *getname_kernel(const char * filename)
+static struct filename *do_getname_kernel(const char *filename, bool incomplete)
 {
 	struct filename *result;
 	int len = strlen(filename) + 1;
@@ -267,9 +274,15 @@ struct filename *getname_kernel(const char * filename)
 	}
 	result->name = p;
 	initname(result);
-	audit_getname(result);
+	if (likely(!incomplete))
+		audit_getname(result);
 	return result;
 }
+
+struct filename *getname_kernel(const char *filename)
+{
+	return do_getname_kernel(filename, false);
+}
 EXPORT_SYMBOL(getname_kernel);
 
 void putname(struct filename *name)
@@ -294,6 +307,49 @@ void putname(struct filename *name)
 }
 EXPORT_SYMBOL(putname);
 
+static inline int __delayed_getname(struct delayed_filename *v,
+			   const char __user *string, int flags)
+{
+	v->__incomplete_filename = do_getname(string, flags, true);
+	return PTR_ERR_OR_ZERO(v->__incomplete_filename);
+}
+
+int delayed_getname(struct delayed_filename *v, const char __user *string)
+{
+	return __delayed_getname(v, string, 0);
+}
+
+int delayed_getname_uflags(struct delayed_filename *v, const char __user *string,
+			 int uflags)
+{
+	int flags = (uflags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+	return __delayed_getname(v, string, flags);
+}
+
+int putname_to_delayed(struct delayed_filename *v, struct filename *name)
+{
+	if (likely(atomic_read(&name->refcnt) == 1)) {
+		v->__incomplete_filename = name;
+		return 0;
+	}
+	v->__incomplete_filename = do_getname_kernel(name->name, true);
+	putname(name);
+	return PTR_ERR_OR_ZERO(v->__incomplete_filename);
+}
+
+void dismiss_delayed_filename(struct delayed_filename *v)
+{
+	putname(no_free_ptr(v->__incomplete_filename));
+}
+
+struct filename *complete_getname(struct delayed_filename *v)
+{
+	struct filename *res = no_free_ptr(v->__incomplete_filename);
+	if (!IS_ERR(res))
+		audit_getname(res);
+	return res;
+}
+
 /**
  * check_acl - perform ACL permission checking
  * @idmap:	idmap of the mount the inode was found from
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f0f1e8034539..f1612a7dffd0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2516,6 +2516,17 @@ static inline struct filename *getname_maybe_null(const char __user *name, int f
 extern void putname(struct filename *name);
 DEFINE_FREE(putname, struct filename *, if (!IS_ERR_OR_NULL(_T)) putname(_T))
 
+struct delayed_filename {
+	struct filename *__incomplete_filename;	// don't touch
+};
+#define INIT_DELAYED_FILENAME(ptr) \
+	((void)(*(ptr) = (struct delayed_filename){}))
+int delayed_getname(struct delayed_filename *, const char __user *);
+int delayed_getname_uflags(struct delayed_filename *v, const char __user *, int);
+void dismiss_delayed_filename(struct delayed_filename *);
+int putname_to_delayed(struct delayed_filename *, struct filename *);
+struct filename *complete_getname(struct delayed_filename *);
+
 static inline struct filename *refname(struct filename *name)
 {
 	atomic_inc(&name->refcnt);
@@ -2527,6 +2538,7 @@ EXTEND_CLASS(filename, _kernel, getname_kernel(p), const char *p)
 EXTEND_CLASS(filename, _flags, getname_flags(p, f), const char __user *p, unsigned int f)
 EXTEND_CLASS(filename, _uflags, getname_uflags(p, f), const char __user *p, unsigned int f)
 EXTEND_CLASS(filename, _maybe_null, getname_maybe_null(p, f), const char __user *p, unsigned int f)
+EXTEND_CLASS(filename, _complete_delayed, complete_getname(p), struct delayed_filename *p)
 
 extern int finish_open(struct file *file, struct dentry *dentry,
 			int (*open)(struct inode *, struct file *));
diff --git a/io_uring/fs.c b/io_uring/fs.c
index 37079a414eab..c04c6282210a 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -19,8 +19,8 @@ struct io_rename {
 	struct file			*file;
 	int				old_dfd;
 	int				new_dfd;
-	struct filename			*oldpath;
-	struct filename			*newpath;
+	struct delayed_filename		oldpath;
+	struct delayed_filename		newpath;
 	int				flags;
 };
 
@@ -28,22 +28,22 @@ struct io_unlink {
 	struct file			*file;
 	int				dfd;
 	int				flags;
-	struct filename			*filename;
+	struct delayed_filename		filename;
 };
 
 struct io_mkdir {
 	struct file			*file;
 	int				dfd;
 	umode_t				mode;
-	struct filename			*filename;
+	struct delayed_filename		filename;
 };
 
 struct io_link {
 	struct file			*file;
 	int				old_dfd;
 	int				new_dfd;
-	struct filename			*oldpath;
-	struct filename			*newpath;
+	struct delayed_filename		oldpath;
+	struct delayed_filename		newpath;
 	int				flags;
 };
 
@@ -51,6 +51,7 @@ int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
 	const char __user *oldf, *newf;
+	int err;
 
 	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
@@ -63,14 +64,14 @@ int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	ren->new_dfd = READ_ONCE(sqe->len);
 	ren->flags = READ_ONCE(sqe->rename_flags);
 
-	ren->oldpath = getname(oldf);
-	if (IS_ERR(ren->oldpath))
-		return PTR_ERR(ren->oldpath);
+	err = delayed_getname(&ren->oldpath, oldf);
+	if (unlikely(err))
+		return err;
 
-	ren->newpath = getname(newf);
-	if (IS_ERR(ren->newpath)) {
-		putname(ren->oldpath);
-		return PTR_ERR(ren->newpath);
+	err = delayed_getname(&ren->newpath, newf);
+	if (unlikely(err)) {
+		dismiss_delayed_filename(&ren->oldpath);
+		return err;
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
@@ -85,8 +86,9 @@ int io_renameat(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_renameat2(ren->old_dfd, ren->oldpath, ren->new_dfd,
-				ren->newpath, ren->flags);
+	ret = do_renameat2(ren->old_dfd, complete_getname(&ren->oldpath),
+			   ren->new_dfd, complete_getname(&ren->newpath),
+			   ren->flags);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
@@ -97,14 +99,15 @@ void io_renameat_cleanup(struct io_kiocb *req)
 {
 	struct io_rename *ren = io_kiocb_to_cmd(req, struct io_rename);
 
-	putname(ren->oldpath);
-	putname(ren->newpath);
+	dismiss_delayed_filename(&ren->oldpath);
+	dismiss_delayed_filename(&ren->newpath);
 }
 
 int io_unlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_unlink *un = io_kiocb_to_cmd(req, struct io_unlink);
 	const char __user *fname;
+	int err;
 
 	if (sqe->off || sqe->len || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
@@ -118,9 +121,9 @@ int io_unlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	un->filename = getname(fname);
-	if (IS_ERR(un->filename))
-		return PTR_ERR(un->filename);
+	err = delayed_getname(&un->filename, fname);
+	if (unlikely(err))
+		return err;
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
@@ -135,9 +138,9 @@ int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
 	if (un->flags & AT_REMOVEDIR)
-		ret = do_rmdir(un->dfd, un->filename);
+		ret = do_rmdir(un->dfd, complete_getname(&un->filename));
 	else
-		ret = do_unlinkat(un->dfd, un->filename);
+		ret = do_unlinkat(un->dfd, complete_getname(&un->filename));
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
@@ -148,13 +151,14 @@ void io_unlinkat_cleanup(struct io_kiocb *req)
 {
 	struct io_unlink *ul = io_kiocb_to_cmd(req, struct io_unlink);
 
-	putname(ul->filename);
+	dismiss_delayed_filename(&ul->filename);
 }
 
 int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_mkdir *mkd = io_kiocb_to_cmd(req, struct io_mkdir);
 	const char __user *fname;
+	int err;
 
 	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
@@ -165,9 +169,9 @@ int io_mkdirat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	mkd->mode = READ_ONCE(sqe->len);
 
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	mkd->filename = getname(fname);
-	if (IS_ERR(mkd->filename))
-		return PTR_ERR(mkd->filename);
+	err = delayed_getname(&mkd->filename, fname);
+	if (unlikely(err))
+		return err;
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
@@ -181,7 +185,7 @@ int io_mkdirat(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
+	ret = do_mkdirat(mkd->dfd, complete_getname(&mkd->filename), mkd->mode);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
@@ -192,13 +196,14 @@ void io_mkdirat_cleanup(struct io_kiocb *req)
 {
 	struct io_mkdir *md = io_kiocb_to_cmd(req, struct io_mkdir);
 
-	putname(md->filename);
+	dismiss_delayed_filename(&md->filename);
 }
 
 int io_symlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_link *sl = io_kiocb_to_cmd(req, struct io_link);
 	const char __user *oldpath, *newpath;
+	int err;
 
 	if (sqe->len || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
@@ -209,14 +214,14 @@ int io_symlinkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	oldpath = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	newpath = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 
-	sl->oldpath = getname(oldpath);
-	if (IS_ERR(sl->oldpath))
-		return PTR_ERR(sl->oldpath);
+	err = delayed_getname(&sl->oldpath, oldpath);
+	if (unlikely(err))
+		return err;
 
-	sl->newpath = getname(newpath);
-	if (IS_ERR(sl->newpath)) {
-		putname(sl->oldpath);
-		return PTR_ERR(sl->newpath);
+	err = delayed_getname(&sl->newpath, newpath);
+	if (unlikely(err)) {
+		dismiss_delayed_filename(&sl->oldpath);
+		return err;
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
@@ -231,7 +236,8 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
+	ret = do_symlinkat(complete_getname(&sl->oldpath), sl->new_dfd,
+			   complete_getname(&sl->newpath));
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
@@ -242,6 +248,7 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_link *lnk = io_kiocb_to_cmd(req, struct io_link);
 	const char __user *oldf, *newf;
+	int err;
 
 	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
@@ -254,14 +261,14 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	lnk->flags = READ_ONCE(sqe->hardlink_flags);
 
-	lnk->oldpath = getname_uflags(oldf, lnk->flags);
-	if (IS_ERR(lnk->oldpath))
-		return PTR_ERR(lnk->oldpath);
+	err = delayed_getname_uflags(&lnk->oldpath, oldf, lnk->flags);
+	if (unlikely(err))
+		return err;
 
-	lnk->newpath = getname(newf);
-	if (IS_ERR(lnk->newpath)) {
-		putname(lnk->oldpath);
-		return PTR_ERR(lnk->newpath);
+	err = delayed_getname(&lnk->newpath, newf);
+	if (unlikely(err)) {
+		dismiss_delayed_filename(&lnk->oldpath);
+		return err;
 	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
@@ -276,8 +283,8 @@ int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
-				lnk->newpath, lnk->flags);
+	ret = do_linkat(lnk->old_dfd, complete_getname(&lnk->oldpath),
+			lnk->new_dfd, complete_getname(&lnk->newpath), lnk->flags);
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_req_set_res(req, ret, 0);
@@ -288,6 +295,6 @@ void io_link_cleanup(struct io_kiocb *req)
 {
 	struct io_link *sl = io_kiocb_to_cmd(req, struct io_link);
 
-	putname(sl->oldpath);
-	putname(sl->newpath);
+	dismiss_delayed_filename(&sl->oldpath);
+	dismiss_delayed_filename(&sl->newpath);
 }
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 15dde9bd6ff6..aa3acb06247f 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -23,7 +23,7 @@ struct io_open {
 	struct file			*file;
 	int				dfd;
 	u32				file_slot;
-	struct filename			*filename;
+	struct delayed_filename		filename;
 	struct open_how			how;
 	unsigned long			nofile;
 };
@@ -67,12 +67,9 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 	open->dfd = READ_ONCE(sqe->fd);
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	open->filename = getname(fname);
-	if (IS_ERR(open->filename)) {
-		ret = PTR_ERR(open->filename);
-		open->filename = NULL;
+	ret = delayed_getname(&open->filename, fname);
+	if (unlikely(ret))
 		return ret;
-	}
 	req->flags |= REQ_F_NEED_CLEANUP;
 
 	open->file_slot = READ_ONCE(sqe->file_index);
@@ -121,6 +118,7 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	bool resolve_nonblock, nonblock_set;
 	bool fixed = !!open->file_slot;
+	CLASS(filename_complete_delayed, name)(&open->filename);
 	int ret;
 
 	ret = build_open_flags(&open->how, &op);
@@ -140,7 +138,7 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 			goto err;
 	}
 
-	file = do_filp_open(open->dfd, open->filename, &op);
+	file = do_filp_open(open->dfd, name, &op);
 	if (IS_ERR(file)) {
 		/*
 		 * We could hang on to this 'fd' on retrying, but seems like
@@ -152,9 +150,13 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 
 		ret = PTR_ERR(file);
 		/* only retry if RESOLVE_CACHED wasn't already set by application */
-		if (ret == -EAGAIN &&
-		    (!resolve_nonblock && (issue_flags & IO_URING_F_NONBLOCK)))
-			return -EAGAIN;
+		if (ret == -EAGAIN && !resolve_nonblock &&
+		    (issue_flags & IO_URING_F_NONBLOCK)) {
+			ret = putname_to_delayed(&open->filename,
+						 no_free_ptr(name));
+			if (likely(!ret))
+				return -EAGAIN;
+		}
 		goto err;
 	}
 
@@ -167,7 +169,6 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_fixed_fd_install(req, issue_flags, file,
 						open->file_slot);
 err:
-	putname(open->filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail(req);
@@ -184,8 +185,7 @@ void io_open_cleanup(struct io_kiocb *req)
 {
 	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
 
-	if (open->filename)
-		putname(open->filename);
+	dismiss_delayed_filename(&open->filename);
 }
 
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
diff --git a/io_uring/statx.c b/io_uring/statx.c
index 5111e9befbfe..7bcae4a6c4a3 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -16,7 +16,7 @@ struct io_statx {
 	int				dfd;
 	unsigned int			mask;
 	unsigned int			flags;
-	struct filename			*filename;
+	struct delayed_filename		filename;
 	struct statx __user		*buffer;
 };
 
@@ -24,6 +24,7 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
 	const char __user *path;
+	int ret;
 
 	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
@@ -36,14 +37,10 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sx->buffer = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	sx->flags = READ_ONCE(sqe->statx_flags);
 
-	sx->filename = getname_uflags(path, sx->flags);
-
-	if (IS_ERR(sx->filename)) {
-		int ret = PTR_ERR(sx->filename);
+	ret = delayed_getname_uflags(&sx->filename, path, sx->flags);
 
-		sx->filename = NULL;
+	if (unlikely(ret))
 		return ret;
-	}
 
 	req->flags |= REQ_F_NEED_CLEANUP;
 	req->flags |= REQ_F_FORCE_ASYNC;
@@ -53,11 +50,12 @@ int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_statx(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
+	CLASS(filename_complete_delayed, name)(&sx->filename);
 	int ret;
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = do_statx(sx->dfd, sx->filename, sx->flags, sx->mask, sx->buffer);
+	ret = do_statx(sx->dfd, name, sx->flags, sx->mask, sx->buffer);
 	io_req_set_res(req, ret, 0);
 	return IOU_COMPLETE;
 }
@@ -66,6 +64,5 @@ void io_statx_cleanup(struct io_kiocb *req)
 {
 	struct io_statx *sx = io_kiocb_to_cmd(req, struct io_statx);
 
-	if (sx->filename)
-		putname(sx->filename);
+	dismiss_delayed_filename(&sx->filename);
 }
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 322b94ff9e4b..0fb4e5303500 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -19,16 +19,14 @@
 struct io_xattr {
 	struct file			*file;
 	struct kernel_xattr_ctx		ctx;
-	struct filename			*filename;
+	struct delayed_filename		filename;
 };
 
 void io_xattr_cleanup(struct io_kiocb *req)
 {
 	struct io_xattr *ix = io_kiocb_to_cmd(req, struct io_xattr);
 
-	if (ix->filename)
-		putname(ix->filename);
-
+	dismiss_delayed_filename(&ix->filename);
 	kfree(ix->ctx.kname);
 	kvfree(ix->ctx.kvalue);
 }
@@ -48,7 +46,7 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	ix->filename = NULL;
+	INIT_DELAYED_FILENAME(&ix->filename);
 	ix->ctx.kvalue = NULL;
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
@@ -93,11 +91,7 @@ int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
-	ix->filename = getname(path);
-	if (IS_ERR(ix->filename))
-		return PTR_ERR(ix->filename);
-
-	return 0;
+	return delayed_getname(&ix->filename, path);
 }
 
 int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
@@ -119,8 +113,8 @@ int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = filename_getxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
-	ix->filename = NULL;
+	ret = filename_getxattr(AT_FDCWD, complete_getname(&ix->filename),
+				LOOKUP_FOLLOW, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_COMPLETE;
 }
@@ -132,7 +126,7 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	const char __user *name;
 	int ret;
 
-	ix->filename = NULL;
+	INIT_DELAYED_FILENAME(&ix->filename);
 	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	ix->ctx.cvalue = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	ix->ctx.kvalue = NULL;
@@ -169,11 +163,7 @@ int io_setxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	path = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 
-	ix->filename = getname(path);
-	if (IS_ERR(ix->filename))
-		return PTR_ERR(ix->filename);
-
-	return 0;
+	return delayed_getname(&ix->filename, path);
 }
 
 int io_fsetxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -200,8 +190,8 @@ int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
-	ix->filename = NULL;
+	ret = filename_setxattr(AT_FDCWD, complete_getname(&ix->filename),
+				LOOKUP_FOLLOW, &ix->ctx);
 	io_xattr_finish(req, ret);
 	return IOU_COMPLETE;
 }
-- 
2.47.3


