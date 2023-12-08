Return-Path: <io-uring+bounces-269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB26A80AEA0
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 22:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43D381F21023
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 21:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED19F5733A;
	Fri,  8 Dec 2023 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJTinAQN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB84374FF
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 21:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDAEC433C7;
	Fri,  8 Dec 2023 21:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702070069;
	bh=oEwVR85frWo3KTYsrdtpbSbpnUZM2oWUE6HKgw+5QH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bJTinAQN1thLZGOJ9NomasvJZt3xg2vyv0KrJeHfbfSAK4QBkPDseSDJXmBE5G0r0
	 23kn0aBkk5YjseasAJxrL8i2DnP9VNfmJU4jC/o0CK3njWzAbRnnsn+6yBoEWSDC2o
	 lhpMh3RfnIr0UxvLKctHUz1iiia3mPl4SzC+WDz8/V1za5FPsfEEhJunDbg57jMY64
	 T3t5lRkIsRP8XCaHC1LBzBtHs3GU6Ex7ciVcGmi5LT4+MddEmA0YXXcgPfqJrt6G2l
	 ILMFnD14y4mbqSmp+i5gbIfKuaER4bpTj83u3WkULm58B1d5Z9j8MXH/EsJ2Jx1A+Q
	 99qPbX/D2eEQg==
Date: Fri, 8 Dec 2023 22:14:25 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring/openclose: add support for
 IORING_OP_FIXED_FD_INSTALL
Message-ID: <20231208-leihwagen-losen-e751332ab864@brauner>
References: <df0e24ff-f3a0-4818-8282-2a4e03b7b5a6@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <df0e24ff-f3a0-4818-8282-2a4e03b7b5a6@kernel.dk>

On Thu, Dec 07, 2023 at 08:11:45PM -0700, Jens Axboe wrote:
> io_uring can currently open/close regular files or fixed/direct
> descriptors. Or you can instantiate a fixed descriptor from a regular
> one, and then close the regular descriptor. But you currently can't turn
> a purely fixed/direct descriptor into a regular file descriptor.
> 
> IORING_OP_FIXED_FD_INSTALL adds support for installing a direct
> descriptor into the normal file table, just like receiving a file
> descriptor or opening a new file would do. This is all nicely abstracted
> into receive_fd(), and hence adding support for this is truly trivial.
> 
> Since direct descriptors are only usable within io_uring itself, it can
> be useful to turn them into real file descriptors if they ever need to
> be accessed via normal syscalls. This can either be a transitory thing,
> or just a permanent transition for a given direct descriptor.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Would you mind giving me a Suggested-by?

So this interesting. Usually we allow to receive fds if the task we're
taking a reference to a file from:

(1) is cooperating: SCM_RIGHTS
(2) is the same task that's taking an addition reference: dup*(),
    seccomp notify addfd

Both cases ensure that the file->f_count == and fdtable->count == 1
optimizations continue to work correctly in the regular system call
fdget*() routines.

I guess that this is a variant of (2). Effectively a dup*() from a
private file table into the regular fdtable.

So I just want to make sure we don't break this here because we broke
that on accident before (pidfd_getfd()):

A fixed file always has file->f_count == 1. The private io_uring fdtable
is:

* shared between all io workers?
* accessible to all processes that have mapped the io_uring ring?

And fixed files can only be used from within io_uring itself.

So multiple caller might issue fixed file rquests to different io
workers for concurrent operations. The file->f_count stays at 1 for all
of them. Someone now requests a regular fd for that fixed file.

So now an fixed-to-fd requests comes in. The file->f_count is bumped > 1
and that fd is installed into the fdtable of the caller through one of
the io worker threads spawned for that caller?

Assume caller now issues a readdir() operation on that fd. file->f_count
will be > 1 for as long as it's used as a fixed file. So regular system
call fdget*() locking rules should work even with that new extension
added.

I think that's sound.

But I want to share some doubts as well. I think the concept of fixed
files is pretty neat. But it poses a new semantic challenge to
userspace.

io_uring_setup() gives you an fd back that you use to mmap() the
io_uring. You make that io_uring_setup() fd a fixed file. You close the
regular fd but now the io_uring instance stays around. You create and
register a bunch of fixed files.

So now you've set up an io_uring instance that is completely made up of
fixed files including the io_uring file itself.

So a process that assumes that once it has closed all fds in its fdtable
of all threads that all resources have been released.

But that's not true now. At least for some pretty obvious cases such as
filesystems. For example, io_uring could just pin random filesystems in
there. Say it holds open a file in a btrfs mount and the service
manager having closed all fds now tries unmount it and fails
inexplicably.

So effectively, fixed files let you completely hide files and that's
potentially a problem. So cool idea but this might cause us some trouble
later down the road.

Reviewed-by: Christian Brauner <brauner@kernel.org>

Two comments below.

>  include/uapi/linux/io_uring.h |  2 ++
>  io_uring/opdef.c              |  9 +++++++++
>  io_uring/openclose.c          | 37 +++++++++++++++++++++++++++++++++++
>  io_uring/openclose.h          |  3 +++
>  4 files changed, 51 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index f1c16f817742..af82aab9e632 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -71,6 +71,7 @@ struct io_uring_sqe {
>  		__u32		uring_cmd_flags;
>  		__u32		waitid_flags;
>  		__u32		futex_flags;
> +		__u32		install_fd_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */
> @@ -253,6 +254,7 @@ enum io_uring_op {
>  	IORING_OP_FUTEX_WAIT,
>  	IORING_OP_FUTEX_WAKE,
>  	IORING_OP_FUTEX_WAITV,
> +	IORING_OP_FIXED_FD_INSTALL,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 799db44283c7..6705634e5f52 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -469,6 +469,12 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_eopnotsupp_prep,
>  #endif
>  	},
> +	[IORING_OP_FIXED_FD_INSTALL] = {
> +		.needs_file		= 1,
> +		.audit_skip		= 1,
> +		.prep			= io_install_fixed_fd_prep,
> +		.issue			= io_install_fixed_fd,
> +	},
>  };
>  
>  const struct io_cold_def io_cold_defs[] = {
> @@ -704,6 +710,9 @@ const struct io_cold_def io_cold_defs[] = {
>  	[IORING_OP_FUTEX_WAITV] = {
>  		.name			= "FUTEX_WAITV",
>  	},
> +	[IORING_OP_FIXED_FD_INSTALL] = {
> +		.name			= "FIXED_FD_INSTALL",
> +	},
>  };
>  
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> index fb73adb89067..5b8f79edef26 100644
> --- a/io_uring/openclose.c
> +++ b/io_uring/openclose.c
> @@ -31,6 +31,11 @@ struct io_close {
>  	u32				file_slot;
>  };
>  
> +struct io_fixed_install {
> +	struct file			*file;
> +	int				flags;
> +};
> +
>  static bool io_openat_force_async(struct io_open *open)
>  {
>  	/*
> @@ -254,3 +259,35 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
>  	io_req_set_res(req, ret, 0);
>  	return IOU_OK;
>  }
> +
> +int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_fixed_install *ifi;
> +
> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index ||
> +	    sqe->splice_fd_in || sqe->addr3)
> +		return -EINVAL;
> +
> +	/* must be a fixed file */
> +	if (!(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
> +
> +	/* really just O_CLOEXEC or not */
> +	ifi->flags = READ_ONCE(sqe->install_fd_flags);

I'm a big big fan of having all new fd returning apis return their fds
O_CLOEXEC by default and forcing userspace to explicitly turn this off
via fcntl(). pidfds are cloexec by default, so are seccomp notifier fds.

> +	return 0;
> +}
> +
> +int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_fixed_install *ifi;
> +	int ret;
> +
> +	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
> +	ret = receive_fd(req->file, ifi->flags);

After changes currently in vfs.misc the helper is now:

receive_fd(req->file, NULL, ifi->flags)

So fyi, this will cause a build failure in -next.

> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, 0);
> +	return IOU_OK;
> +}
> diff --git a/io_uring/openclose.h b/io_uring/openclose.h
> index 4b1c28d3a66c..8a93c98ad0ad 100644
> --- a/io_uring/openclose.h
> +++ b/io_uring/openclose.h
> @@ -12,3 +12,6 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
>  
>  int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>  int io_close(struct io_kiocb *req, unsigned int issue_flags);
> +
> +int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags);
> -- 
> 2.42.0
> 
> -- 
> Jens Axboe
> 

