Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7523C72A8
	for <lists+io-uring@lfdr.de>; Tue, 13 Jul 2021 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhGMO4g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jul 2021 10:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236763AbhGMO4g (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 13 Jul 2021 10:56:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60F236128B;
        Tue, 13 Jul 2021 14:53:44 +0000 (UTC)
Date:   Tue, 13 Jul 2021 16:53:41 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH  1/7] namei: clean up do_rmdir retry logic
Message-ID: <20210713145341.lngtd5g3p6zf5eoo@wittgenstein>
References: <20210712123649.1102392-1-dkadashev@gmail.com>
 <20210712123649.1102392-2-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210712123649.1102392-2-dkadashev@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 12, 2021 at 07:36:43PM +0700, Dmitry Kadashev wrote:
> Moving the main logic to a helper function makes the whole thing much
> easier to follow.
> 
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Link: https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/namei.c | 44 +++++++++++++++++++++++++-------------------
>  1 file changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index b5adfd4f7de6..ae6cde7dc91e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3947,7 +3947,8 @@ int vfs_rmdir(struct user_namespace *mnt_userns, struct inode *dir,
>  }
>  EXPORT_SYMBOL(vfs_rmdir);
>  
> -int do_rmdir(int dfd, struct filename *name)
> +static int rmdir_helper(int dfd, struct filename *name,
> +			unsigned int lookup_flags)
>  {
>  	struct user_namespace *mnt_userns;
>  	int error;
> @@ -3955,54 +3956,59 @@ int do_rmdir(int dfd, struct filename *name)
>  	struct path path;
>  	struct qstr last;
>  	int type;
> -	unsigned int lookup_flags = 0;
> -retry:
> +
>  	error = __filename_parentat(dfd, name, lookup_flags, &path, &last, &type);
>  	if (error)
> -		goto exit1;
> +		return error;
>  
>  	switch (type) {
>  	case LAST_DOTDOT:
>  		error = -ENOTEMPTY;
> -		goto exit2;
> +		goto exit1;
>  	case LAST_DOT:
>  		error = -EINVAL;
> -		goto exit2;
> +		goto exit1;
>  	case LAST_ROOT:
>  		error = -EBUSY;
> -		goto exit2;
> +		goto exit1;
>  	}
>  
>  	error = mnt_want_write(path.mnt);
>  	if (error)
> -		goto exit2;
> +		goto exit1;
>  
>  	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
>  	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
>  	error = PTR_ERR(dentry);
>  	if (IS_ERR(dentry))
> -		goto exit3;
> +		goto exit2;
>  	if (!dentry->d_inode) {
>  		error = -ENOENT;
> -		goto exit4;
> +		goto exit3;
>  	}
>  	error = security_path_rmdir(&path, dentry);
>  	if (error)
> -		goto exit4;
> +		goto exit3;
>  	mnt_userns = mnt_user_ns(path.mnt);
>  	error = vfs_rmdir(mnt_userns, path.dentry->d_inode, dentry);
> -exit4:
> -	dput(dentry);
>  exit3:
> +	dput(dentry);
> +exit2:
>  	inode_unlock(path.dentry->d_inode);
>  	mnt_drop_write(path.mnt);
> -exit2:
> -	path_put(&path);
> -	if (retry_estale(error, lookup_flags)) {
> -		lookup_flags |= LOOKUP_REVAL;
> -		goto retry;
> -	}
>  exit1:
> +	path_put(&path);
> +	return error;
> +}
> +
> +int do_rmdir(int dfd, struct filename *name)
> +{
> +	int error;
> +
> +	error = rmdir_helper(dfd, name, 0);
> +	if (retry_estale(error, 0))
> +		error = rmdir_helper(dfd, name, LOOKUP_REVAL);

Instead of naming all these $something_helper I would follow the
underscore naming pattern we usually do, i.e. instead of e.g.
rmdir_helper do __rmdir() or __do_rmdir().
