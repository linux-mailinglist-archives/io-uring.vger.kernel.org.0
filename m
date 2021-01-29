Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99706308545
	for <lists+io-uring@lfdr.de>; Fri, 29 Jan 2021 06:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhA2FiC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Jan 2021 00:38:02 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:51156 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhA2FiB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Jan 2021 00:38:01 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 603BC7F45D; Fri, 29 Jan 2021 07:37:03 +0200 (EET)
Date:   Fri, 29 Jan 2021 07:37:03 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     David Laight <David.Laight@aculab.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210129053703.GB190469@wantstofly.org>
References: <20210123114152.GA120281@wantstofly.org>
 <a99467bab6d64a7f9057181d979ec563@AcuMS.aculab.com>
 <20210128230710.GA190469@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210128230710.GA190469@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 29, 2021 at 01:07:10AM +0200, Lennert Buytenhek wrote:

> > > One open question is whether IORING_OP_GETDENTS64 should be more like
> > > pread(2) and allow passing in a starting offset to read from the
> > > directory from.  (This would require some more surgery in fs/readdir.c.)
> > 
> > Since directories are seekable this ought to work.
> > Modulo horrid issues with 32bit file offsets.
> 
> The incremental patch below does this.  (It doesn't apply cleanly on
> top of v1 of the IORING_OP_GETDENTS patch as I have other changes in
> my tree -- I'm including it just to illustrate the changes that would
> make this work.)
> 
> This change seems to work, and makes IORING_OP_GETDENTS take an
> explicitly specified directory offset (instead of using the file's
> ->f_pos), making it more like pread(2) [...]

...but the fact that this patch avoids taking file->f_pos_lock (as this
proposed version of IORING_OP_GETDENTS avoids using file->f_pos) means
that ->iterate_shared() can then be called concurrently on the same
struct file, which breaks the mutual exclusion guarantees provided here.

If possible, I'd like to keep the ability to explicitly pass in a
directory offset to start reading from into IORING_OP_GETDENTS, so
perhaps we can simply satisfy the mutual exclusion requirement by
taking ->f_pos_lock by hand -- but then I do need to check that it's OK
for ->iterate{,_shared}() to be called successively with discontinuous
offsets without ->llseek() being called in between.

(If that's not OK, then we can either have IORING_OP_GETDENTS just
always start reading at ->f_pos like before (which might then require
adding a IORING_OP_GETDENTS2 at some point in the future if we'll
ever want to change that), or we could have IORING_OP_GETDENTS itself
call ->llseek() for now whenever necessary.)


> , and I like the change from
> a conceptual point of view, but it's a bit ugly around
> iterate_dir_use_ctx_pos().  Any thoughts on how to do this more
> cleanly (without breaking iterate_dir() semantics)?
> 
> 
> > You'd need to return the final offset to allow another
> > read to continue from the end position.
> 
> We can use the ->d_off value as returned in the last struct
> linux_dirent64 as the directory offset to continue reading from
> with the next IORING_OP_GETDENTS call, illustrated by the patch
> to uringfind.c at the bottom.
> 
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 13dd29f8ebb3..0f9707ed9294 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -576,6 +576,7 @@ struct io_getdents {
>  	struct file			*file;
>  	struct linux_dirent64 __user	*dirent;
>  	unsigned int			count;
> +	loff_t				pos;
>  };
>  
>  struct io_completion {
> @@ -4584,9 +4585,10 @@ static int io_getdents_prep(struct io_kiocb *req,
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> -	if (sqe->ioprio || sqe->off || sqe->rw_flags || sqe->buf_index)
> +	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index)
>  		return -EINVAL;
>  
> +	getdents->pos = READ_ONCE(sqe->off);
>  	getdents->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
>  	getdents->count = READ_ONCE(sqe->len);
>  	return 0;
> @@ -4601,7 +4603,8 @@ static int io_getdents(struct io_kiocb *req, bool force_nonblock)
>  	if (force_nonblock)
>  		return -EAGAIN;
>  
> -	ret = vfs_getdents(req->file, getdents->dirent, getdents->count);
> +	ret = vfs_getdents(req->file, getdents->dirent, getdents->count,
> +			   &getdents->pos);
>  	if (ret < 0) {
>  		if (ret == -ERESTARTSYS)
>  			ret = -EINTR;
> diff --git a/fs/readdir.c b/fs/readdir.c
> index f52167c1eb61..d6bd78f6350a 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -37,7 +37,7 @@
>  } while (0)
>  
>  
> -int iterate_dir(struct file *file, struct dir_context *ctx)
> +int iterate_dir_use_ctx_pos(struct file *file, struct dir_context *ctx)
>  {
>  	struct inode *inode = file_inode(file);
>  	bool shared = false;
> @@ -60,12 +60,10 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
>  
>  	res = -ENOENT;
>  	if (!IS_DEADDIR(inode)) {
> -		ctx->pos = file->f_pos;
>  		if (shared)
>  			res = file->f_op->iterate_shared(file, ctx);
>  		else
>  			res = file->f_op->iterate(file, ctx);
> -		file->f_pos = ctx->pos;
>  		fsnotify_access(file);
>  		file_accessed(file);
>  	}
> @@ -76,6 +74,17 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
>  out:
>  	return res;
>  }
> +
> +int iterate_dir(struct file *file, struct dir_context *ctx)
> +{
> +	int res;
> +
> +	ctx->pos = file->f_pos;
> +	res = iterate_dir_use_ctx_pos(file, ctx);
> +	file->f_pos = ctx->pos;
> +
> +	return res;
> +}
>  EXPORT_SYMBOL(iterate_dir);
>  
>  /*
> @@ -349,16 +358,18 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
>  }
>  
>  int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> -		 unsigned int count)
> +		 unsigned int count, loff_t *pos)
>  {
>  	struct getdents_callback64 buf = {
>  		.ctx.actor = filldir64,
> +		.ctx.pos = *pos,
>  		.count = count,
>  		.current_dir = dirent
>  	};
>  	int error;
>  
> -	error = iterate_dir(file, &buf.ctx);
> +	error = iterate_dir_use_ctx_pos(file, &buf.ctx);
> +	*pos = buf.ctx.pos;
>  	if (error >= 0)
>  		error = buf.error;
>  	if (buf.prev_reclen) {
> @@ -384,7 +395,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
>  	if (!f.file)
>  		return -EBADF;
>  
> -	error = vfs_getdents(f.file, dirent, count);
> +	error = vfs_getdents(f.file, dirent, count, &f.file->f_pos);
>  	fdput_pos(f);
>  	return error;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 114885d3f6c4..4d9d96163f92 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3107,11 +3107,12 @@ const char *simple_get_link(struct dentry *, struct inode *,
>  			    struct delayed_call *);
>  extern const struct inode_operations simple_symlink_inode_operations;
>  
> +extern int iterate_dir_use_ctx_pos(struct file *, struct dir_context *);
>  extern int iterate_dir(struct file *, struct dir_context *);
>  
>  struct linux_dirent64;
>  int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> -		 unsigned int count);
> +		 unsigned int count, loff_t *pos);
>  
>  int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
>  		int flags);
> 
> 
> 
> Corresponding uringfind.c change:
> 
> diff --git a/uringfind.c b/uringfind.c
> index 4282296..e140388 100644
> --- a/uringfind.c
> +++ b/uringfind.c
> @@ -22,9 +22,10 @@ struct linux_dirent64 {
>  };
>  
>  static inline void io_uring_prep_getdents(struct io_uring_sqe *sqe, int fd,
> -					  void *buf, unsigned int count)
> +					  void *buf, unsigned int count,
> +					  uint64_t off)
>  {
> -	io_uring_prep_rw(IORING_OP_GETDENTS, sqe, fd, buf, count, 0);
> +	io_uring_prep_rw(IORING_OP_GETDENTS, sqe, fd, buf, count, off);
>  }
>  
>  
> @@ -38,6 +39,7 @@ struct dir {
>  
>  	struct dir	*parent;
>  	int		fd;
> +	uint64_t	off;
>  	uint8_t		buf[16384];
>  	char		name[0];
>  };
> @@ -131,7 +133,8 @@ static void schedule_readdir(struct dir *dir)
>  	struct io_uring_sqe *sqe;
>  
>  	sqe = get_sqe();
> -	io_uring_prep_getdents(sqe, dir->fd, dir->buf, sizeof(dir->buf));
> +	io_uring_prep_getdents(sqe, dir->fd, dir->buf, sizeof(dir->buf),
> +			       dir->off);
>  	io_uring_sqe_set_data(sqe, dir);
>  }
>  
> @@ -145,6 +148,7 @@ static void opendir_completion(struct dir *dir, int ret)
>  	}
>  
>  	dir->fd = ret;
> +	dir->off = 0;
>  	schedule_readdir(dir);
>  }
>  
> @@ -179,6 +183,7 @@ static void readdir_completion(struct dir *dir, int ret)
>  				schedule_opendir(dir, dent->d_name);
>  		}
>  
> +		dir->off = dent->d_off;
>  		bufp += dent->d_reclen;
>  	}
>  
