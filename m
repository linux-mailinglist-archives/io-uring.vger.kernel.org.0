Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E8B70DF36
	for <lists+io-uring@lfdr.de>; Tue, 23 May 2023 16:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbjEWOa2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 10:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237282AbjEWOaY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 10:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B15E45;
        Tue, 23 May 2023 07:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A305960A1F;
        Tue, 23 May 2023 14:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A540EC433EF;
        Tue, 23 May 2023 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684852220;
        bh=JqtvVA7Pl8+PRWvxhWl3Sdfq48DmCwvLP1zfr4KFyas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hX3fnIDbw0+aoIDNbMOl1VErOSlFHL/qxktowc0yeP+oB4ED4lCL4oCNfRgzrC/Vc
         oRl/pBLD4voKBjZs5MgpHkrhJkh675XdYVcX3QjMoWK+uPSyCxmiwE4UU+BRwMrWd3
         ANFVd7iTQrPTP+lLZxvjgH1FPM/VmxWUEuLttjTftMwIBpgNg31S6Ai9mVX4JiPJih
         PNZOk0vGXRnh75Zi9jC05PWQAGXHxeBmmwb3h4umk5DJbBHUYkVPHEMrfK2h6FuArz
         Pvr8j1EjEIqpJKBGt0Xb/nOKMawS9jnn80JXeRcef2atzruJv7wFz7fZdAItN2shuB
         Khk+m0lBxWdJA==
Date:   Tue, 23 May 2023 16:30:14 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 6/6] RFC: io_uring getdents: test returning an EOF
 flag in CQE
Message-ID: <20230523-abgleichen-rotieren-37fdb6fb9ef3@brauner>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
 <20230422-uring-getdents-v2-6-2db1e37dc55e@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230422-uring-getdents-v2-6-2db1e37dc55e@codewreck.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,WEIRD_QUOTING
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 10, 2023 at 07:52:54PM +0900, Dominique Martinet wrote:
> This turns out to be very slightly faster than an extra call to
> getdents, but in practice it doesn't seem to be such an improvement as
> the trailing getdents will return almost immediately be absorbed by the
> scheduling noise in a find-like context (my ""server"" is too noisy to
> get proper benchmarks out, but results look slightly better with this in
> async mode, and almost identical in the NOWAIT path)
> 
> If the user is waiting the end of a single directory though it might be
> worth it, so including the patch for comments.
> (in particular I'm not really happy that the flag has become in-out for
> vfs_getdents, especially when the getdents64 syscall does not use it,
> but I don't see much other way around it)
> 
> If this approach is acceptable/wanted then this patch will be split down
> further (at least dir_context/vfs_getdents, kernfs, libfs, uring in four
> separate commits)
> 
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
>  fs/internal.h                 |  2 +-
>  fs/kernfs/dir.c               |  1 +
>  fs/libfs.c                    |  9 ++++++---
>  fs/readdir.c                  | 10 ++++++----
>  include/linux/fs.h            |  2 ++
>  include/uapi/linux/io_uring.h |  2 ++
>  io_uring/fs.c                 |  8 ++++++--
>  7 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 0264b001d99a..0b1552c7a870 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -267,4 +267,4 @@ void mnt_idmap_put(struct mnt_idmap *idmap);
>  struct linux_dirent64;
>  
>  int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> -		 unsigned int count, unsigned long flags);
> +		 unsigned int count, unsigned long *flags);
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index 5a5b3e7881bf..53a6b4804c34 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -1860,6 +1860,7 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
>  	up_read(&root->kernfs_rwsem);
>  	file->private_data = NULL;
>  	ctx->pos = INT_MAX;
> +	ctx->flags |= DIR_CONTEXT_F_EOD;
>  	return 0;
>  }
>  
> diff --git a/fs/libfs.c b/fs/libfs.c
> index a3c7e42d90a7..b2a95dadffbd 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -208,10 +208,12 @@ int dcache_readdir(struct file *file, struct dir_context *ctx)
>  		p = &next->d_child;
>  	}
>  	spin_lock(&dentry->d_lock);
> -	if (next)
> +	if (next) {
>  		list_move_tail(&cursor->d_child, &next->d_child);
> -	else
> +	} else {
>  		list_del_init(&cursor->d_child);
> +		ctx->flags |= DIR_CONTEXT_F_EOD;
> +	}
>  	spin_unlock(&dentry->d_lock);
>  	dput(next);
>  
> @@ -1347,7 +1349,8 @@ static loff_t empty_dir_llseek(struct file *file, loff_t offset, int whence)
>  
>  static int empty_dir_readdir(struct file *file, struct dir_context *ctx)
>  {
> -	dir_emit_dots(file, ctx);
> +	if (dir_emit_dots(file, ctx))
> +		ctx->flags |= DIR_CONTEXT_F_EOD;
>  	return 0;
>  }
>  
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 1311b89d75e1..be75a2154b4f 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -358,14 +358,14 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
>   * @file    : pointer to file struct of directory
>   * @dirent  : pointer to user directory structure
>   * @count   : size of buffer
> - * @flags   : additional dir_context flags
> + * @flags   : pointer to additional dir_context flags
>   */
>  int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> -		 unsigned int count, unsigned long flags)
> +		 unsigned int count, unsigned long *flags)
>  {
>  	struct getdents_callback64 buf = {
>  		.ctx.actor = filldir64,
> -		.ctx.flags = flags,
> +		.ctx.flags = flags ? *flags : 0,
>  		.count = count,
>  		.current_dir = dirent
>  	};
> @@ -384,6 +384,8 @@ int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
>  		else
>  			error = count - buf.count;
>  	}
> +	if (flags)
> +		*flags = buf.ctx.flags;
>  	return error;
>  }
>  
> @@ -397,7 +399,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
>  	if (!f.file)
>  		return -EBADF;
>  
> -	error = vfs_getdents(f.file, dirent, count, 0);
> +	error = vfs_getdents(f.file, dirent, count, NULL);
>  
>  	fdput_pos(f);
>  	return error;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f7de2b5ca38e..d1e31bccfb4f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1723,8 +1723,10 @@ struct dir_context {
>   * flags for dir_context flags
>   * DIR_CONTEXT_F_NOWAIT: Request non-blocking iterate
>   *                       (requires file->f_mode & FMODE_NOWAIT)
> + * DIR_CONTEXT_F_EOD: Signal directory has been fully iterated, set by the fs
>   */
>  #define DIR_CONTEXT_F_NOWAIT	0x1
> +#define DIR_CONTEXT_F_EOD	0x2
>  
>  /*
>   * These flags let !MMU mmap() govern direct device mapping vs immediate
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 35d0de18d893..35877132027e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -381,11 +381,13 @@ struct io_uring_cqe {
>   * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
>   * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
>   * 			them from sends.
> + * IORING_CQE_F_EOF     If set, file or directory has reached end of file.
>   */
>  #define IORING_CQE_F_BUFFER		(1U << 0)
>  #define IORING_CQE_F_MORE		(1U << 1)
>  #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
>  #define IORING_CQE_F_NOTIF		(1U << 3)
> +#define IORING_CQE_F_EOF		(1U << 4)
>  
>  enum {
>  	IORING_CQE_BUFFER_SHIFT		= 16,
> diff --git a/io_uring/fs.c b/io_uring/fs.c
> index b15ec81c1ed2..f6222b0148ef 100644
> --- a/io_uring/fs.c
> +++ b/io_uring/fs.c
> @@ -322,6 +322,7 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_getdents *gd = io_kiocb_to_cmd(req, struct io_getdents);
>  	unsigned long getdents_flags = 0;
> +	u32 cqe_flags = 0;
>  	int ret;
>  
>  	if (issue_flags & IO_URING_F_NONBLOCK) {
> @@ -338,13 +339,16 @@ int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
>  			goto out;
>  	}
>  
> -	ret = vfs_getdents(req->file, gd->dirent, gd->count, getdents_flags);
> +	ret = vfs_getdents(req->file, gd->dirent, gd->count, &getdents_flags);

I don't understand how synchronization and updating of f_pos works here.
For example, what happens if a concurrent seek happens on the fd while
io_uring is using vfs_getdents which calls into iterate_dir() and
updates f_pos?
