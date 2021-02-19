Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A12931FF20
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBSTAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 14:00:30 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:59362 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBSTA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 14:00:28 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 537FD7F4AC; Fri, 19 Feb 2021 20:59:42 +0200 (EET)
Date:   Fri, 19 Feb 2021 20:59:42 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v3 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210219185942.GE342512@wantstofly.org>
References: <20210218122640.GA334506@wantstofly.org>
 <20210218122755.GC334506@wantstofly.org>
 <20210219123403.GT2858050@casper.infradead.org>
 <20210219180704.GD342512@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219180704.GD342512@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 19, 2021 at 08:07:04PM +0200, Lennert Buytenhek wrote:

> > > IORING_OP_GETDENTS may or may not update the specified directory's
> > > file offset, and the file offset should not be relied upon having
> > > any particular value during or after an IORING_OP_GETDENTS call.
> > 
> > This doesn't give me the warm fuzzies.  What I might suggest
> > is either passing a parameter to iterate_dir() or breaking out an
> > iterate_dir_nofpos() to make IORING_OP_GETDENTS more of a READV operation.
> > ie the equivalent of this:
> > 
> > @@ -37,7 +37,7 @@
> >  } while (0)
> >  
> >  
> > -int iterate_dir(struct file *file, struct dir_context *ctx)
> > +int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos)
> >  {
> >         struct inode *inode = file_inode(file);
> >         bool shared = false;
> > @@ -60,12 +60,14 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
> >  
> >         res = -ENOENT;
> >         if (!IS_DEADDIR(inode)) {
> > -               ctx->pos = file->f_pos;
> > +               if (use_fpos)
> > +                       ctx->pos = file->f_pos;
> >                 if (shared)
> >                         res = file->f_op->iterate_shared(file, ctx);
> >                 else
> >                         res = file->f_op->iterate(file, ctx);
> > -               file->f_pos = ctx->pos;
> > +               if (use_fpos)
> > +                       file->f_pos = ctx->pos;
> >                 fsnotify_access(file);
> >                 file_accessed(file);
> >         }
> > 
> > That way there's no need to play with llseek or take a mutex on the
> > f_pos of the directory.
> 
> I'll try this!

The patch below (on top of v3) does what you suggest, and it removes
the vfs_llseek() call, but there's two issues:

- We still need to take some sort of mutex on the directory, because,
  while ->iterate_shared() can be called concurrently on different
  struct files that point to the same underlying dir inode, it cannot
  be called concurrently on the same struct file.  From
  Documentation/filesystems/porting.rst:

	->iterate_shared() is added; it's a parallel variant of ->iterate().
	Exclusion on struct file level is still provided (as well as that
	between it and lseek on the same struct file) but if your directory
	has been opened several times, you can get these called in parallel.
	[...]

- Calling a filesystem's ->iterate_shared() on the same dir with changing
  file positions but without calling the directory's ->llseek() in between
  to notify the filesystem of changes in the file position seems to violate
  an (unstated?) guarantee.  It works on my btrfs root fs, since that uses
  generic_file_llseek() for directory ->llseek(), but e.g. ceph does:

| static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
| {
|         struct ceph_dir_file_info *dfi = file->private_data;
|         struct inode *inode = file->f_mapping->host;
|         loff_t retval;
|
|         inode_lock(inode);
|         retval = -EINVAL;
|         switch (whence) {
|         case SEEK_CUR:
|                 offset += file->f_pos;
|         case SEEK_SET:
|                 break;
|         case SEEK_END:
|                 retval = -EOPNOTSUPP;
|         default:
|                 goto out;
|         }
|
|         if (offset >= 0) {
|                 if (need_reset_readdir(dfi, offset)) {
|                         dout("dir_llseek dropping %p content\n", file);
|                         reset_readdir(dfi);
|                 } else if (is_hash_order(offset) && offset > file->f_pos) {
|                         /* for hash offset, we don't know if a forward seek
|                          * is within same frag */
|                         dfi->dir_release_count = 0;
|                         dfi->readdir_cache_idx = -1;
|                 }
|
|                 if (offset != file->f_pos) {
|                         file->f_pos = offset;
|                         file->f_version = 0;
|                         dfi->file_info.flags &= ~CEPH_F_ATEND;
|                 }
|                 retval = offset;
|         }
| out:
|         inode_unlock(inode);
|         return retval;
| }

So I think we probably can't get rid of the conditional vfs_llseek()
call for now (and we'll probably have to keep taking the dir's
->f_pos_lock) -- what do you think?

(The caveat about that the file pointer may or may not be updated by
IORING_OP_GETDENTS would allow making this optimization in the future,
and for now it would mean that you can't mix getdents64() and
IORING_OP_GETDENTS calls on the same dirfd, which would seem like an
unusual thing to do anyway.)

Thanks!



diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3362e812928d..97bf0965de30 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4709,25 +4709,17 @@ static int io_getdents_prep(struct io_kiocb *req,
 static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_getdents *getdents = &req->getdents;
-	int ret = 0;
+	int ret;

 	/* getdents always requires a blocking context */
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
+	/* to serialize ->iterate_shared() on this file */
 	mutex_lock(&req->file->f_pos_lock);
 
-	if (req->file->f_pos != getdents->pos) {
-		loff_t res = vfs_llseek(req->file, getdents->pos, SEEK_SET);
-		if (res < 0)
-			ret = res;
-	}
-
-	if (ret == 0) {
-		ret = vfs_getdents(req->file, getdents->dirent,
-				   getdents->count);
-	}
+	ret = vfs_getdents(req->file, getdents->dirent,
+			   getdents->count, &getdents->pos);
 
 	mutex_unlock(&req->file->f_pos_lock);
 
diff --git a/fs/readdir.c b/fs/readdir.c
index f52167c1eb61..ffdc70fe5dcf 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -37,7 +37,7 @@
 } while (0)
 
 
-int iterate_dir(struct file *file, struct dir_context *ctx)
+int __iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos)
 {
 	struct inode *inode = file_inode(file);
 	bool shared = false;
@@ -60,12 +60,14 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		ctx->pos = file->f_pos;
+		if (use_fpos)
+			ctx->pos = file->f_pos;
 		if (shared)
 			res = file->f_op->iterate_shared(file, ctx);
 		else
 			res = file->f_op->iterate(file, ctx);
-		file->f_pos = ctx->pos;
+		if (use_fpos)
+			file->f_pos = ctx->pos;
 		fsnotify_access(file);
 		file_accessed(file);
 	}
@@ -76,6 +78,11 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 out:
 	return res;
 }
+
+int iterate_dir(struct file *file, struct dir_context *ctx)
+{
+	return __iterate_dir(file, ctx, true);
+}
 EXPORT_SYMBOL(iterate_dir);
 
 /*
@@ -349,7 +356,7 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 }
 
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count)
+		 unsigned int count, loff_t *f_pos)
 {
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
@@ -358,7 +365,13 @@ int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
 	};
 	int error;
 
-	error = iterate_dir(file, &buf.ctx);
+	if (f_pos == NULL) {
+		error = __iterate_dir(file, &buf.ctx, true);
+	} else {
+		buf.ctx.pos = *f_pos;
+		error = __iterate_dir(file, &buf.ctx, false);
+	}
+
 	if (error >= 0)
 		error = buf.error;
 	if (buf.prev_reclen) {
@@ -384,7 +397,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
 
-	error = vfs_getdents(f.file, dirent, count);
+	error = vfs_getdents(f.file, dirent, count, NULL);
 	fdput_pos(f);
 	return error;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 114885d3f6c4..7104cd9b26ca 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3107,11 +3107,12 @@ const char *simple_get_link(struct dentry *, struct inode *,
 			    struct delayed_call *);
 extern const struct inode_operations simple_symlink_inode_operations;
 
+extern int __iterate_dir(struct file *, struct dir_context *, bool);
 extern int iterate_dir(struct file *, struct dir_context *);
 
 struct linux_dirent64;
 int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
-		 unsigned int count);
+		 unsigned int count, loff_t *f_pos);
 
 int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 		int flags);
