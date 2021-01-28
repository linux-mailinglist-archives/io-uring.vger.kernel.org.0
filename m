Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A090E3068BE
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 01:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhA1AkR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 19:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231613AbhA1AjP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 27 Jan 2021 19:39:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9055E64DCC;
        Thu, 28 Jan 2021 00:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611794314;
        bh=KWXI8YcQRRJvF3pGjArGgcOc05RxBCFQJUqLZjr/g4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uLzIQb1TqvqNsbenmMlz0Ga6OeDEMMlssBB+B0EbcTyde4RRiO2V8NwJk9tOwr8CH
         +QdFWXCYE6oDhhtsTHt6vVTGMPsx4RjNS5Cv7OD7reIHAlOR0Yu0UbakFP9DjmpVCY
         nJ7Dc5CubVoJMEQBQahTYrNWmTnuDW7dH4Cmo++eIRrHGTNA4U/VmT9qHJgW1Jpfgl
         e2nj7h0jS7sz7Kq/2WW0FLw0tgUlYy3JRMsqNROu6r2qUsDXQXqhTf2qmwwuyB6fif
         pZdBi2pysM8rvFG/l71H8ODp4pf3IcTHRkFlep/fvd4Fe5cslceDuwkMfG+8AMNcmv
         QsybLZS88WTxw==
Date:   Wed, 27 Jan 2021 16:38:31 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
Message-ID: <20210128003831.GE7695@magnolia>
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127212541.88944-3-axboe@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jan 27, 2021 at 02:25:38PM -0700, Jens Axboe wrote:
> This is a file private kind of request. io_uring doesn't know what's
> in this command type, it's for the file_operations->uring_cmd()
> handler to deal with.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c                 | 59 +++++++++++++++++++++++++++++++++++
>  include/linux/io_uring.h      | 12 +++++++
>  include/uapi/linux/io_uring.h |  1 +
>  3 files changed, 72 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 03748faa5295..55c2714a591e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -712,6 +712,7 @@ struct io_kiocb {
>  		struct io_shutdown	shutdown;
>  		struct io_rename	rename;
>  		struct io_unlink	unlink;
> +		struct io_uring_cmd	uring_cmd;
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> @@ -805,6 +806,8 @@ struct io_op_def {
>  	unsigned		needs_async_data : 1;
>  	/* should block plug */
>  	unsigned		plug : 1;
> +	/* doesn't support personality */
> +	unsigned		no_personality : 1;
>  	/* size of async data needed, if any */
>  	unsigned short		async_size;
>  	unsigned		work_flags;
> @@ -998,6 +1001,11 @@ static const struct io_op_def io_op_defs[] = {
>  		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
>  						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
>  	},
> +	[IORING_OP_URING_CMD] = {
> +		.needs_file		= 1,
> +		.no_personality		= 1,
> +		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
> +	},
>  };
>  
>  enum io_mem_account {
> @@ -3797,6 +3805,47 @@ static int io_unlinkat(struct io_kiocb *req, bool force_nonblock)
>  	return 0;
>  }
>  
> +static void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
> +{
> +	struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
> +
> +	if (ret < 0)
> +		req_set_fail_links(req);
> +	io_req_complete(req, ret);
> +}
> +
> +static int io_uring_cmd_prep(struct io_kiocb *req,
> +			     const struct io_uring_sqe *sqe)
> +{
> +	struct io_uring_cmd *cmd = &req->uring_cmd;
> +
> +	if (!req->file->f_op->uring_cmd)
> +		return -EOPNOTSUPP;
> +
> +	memcpy(&cmd->pdu, (void *) &sqe->off, sizeof(cmd->pdu));

Hmmm.  struct io_uring_pdu is (by my count) 6x uint64_t (==48 bytes) in
size.  This starts copying the pdu from byte 8 in struct io_uring_sqe,
and the sqe is 64 bytes in size.

I guess (having not played much with io_uring) that the stuff in the
first eight bytes of the sqe are header info that's common to all
io_uring operations, and hence not passed to io_uring_cmd*.

Assuming that I got that right, that means that the pdu information
doesn't actually go all the way to the end of the sqe, which currently
is just a bunch of padding.  Was that intentional, or does this mean
that io_uring_pdu could actually be 8 bytes longer?

Also, I thought io_uring_seq.user_data was supposed to coincide with
io_uring_pdu.reserved?  They don't seem to...?

(I could be totally off here, fwiw.)

The reason why I'm counting bytes so stingily is that xfs_scrub issues
millions upon millions of ioctl calls to scrub an XFS.  Wouldn't it be
nice if there was a way to submit a single userspace buffer to the
kernel and let it run every scrubber for that fs object in order?  I
could cram all that data into the pdu struct ... if it had 56 bytes of
space.

If not, it wouldn't be a big deal to use one of the data[4] fields as a
pointer to a larger struct, but where's the fun in that? :)

Granted I'm programming speculatively in my head, not building an actual
prototype.  There are all kinds of other questions I have, like, can a
uring command handler access the task struct or the userspace memory of
the process it was called from?  What happens when the user is madly
pounding on ^C while uring commands are running?  I should probably
figure out the answers to those questions and maybe even write/crib a
program first... 

--D

> +	cmd->done = io_uring_cmd_done;
> +	return 0;
> +}
> +
> +static int io_uring_cmd(struct io_kiocb *req, bool force_nonblock)
> +{
> +	enum io_uring_cmd_flags flags = 0;
> +	struct file *file = req->file;
> +	int ret;
> +
> +	if (force_nonblock)
> +		flags |= IO_URING_F_NONBLOCK;
> +
> +	ret = file->f_op->uring_cmd(&req->uring_cmd, flags);
> +	/* queued async, consumer will call ->done() when complete */
> +	if (ret == -EIOCBQUEUED)
> +		return 0;
> +	else if (ret < 0)
> +		req_set_fail_links(req);
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
>  static int io_shutdown_prep(struct io_kiocb *req,
>  			    const struct io_uring_sqe *sqe)
>  {
> @@ -6093,6 +6142,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_renameat_prep(req, sqe);
>  	case IORING_OP_UNLINKAT:
>  		return io_unlinkat_prep(req, sqe);
> +	case IORING_OP_URING_CMD:
> +		return io_uring_cmd_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6351,6 +6402,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
>  	case IORING_OP_UNLINKAT:
>  		ret = io_unlinkat(req, force_nonblock);
>  		break;
> +	case IORING_OP_URING_CMD:
> +		ret = io_uring_cmd(req, force_nonblock);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -6865,6 +6919,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	if (id) {
>  		struct io_identity *iod;
>  
> +		if (io_op_defs[req->opcode].no_personality)
> +			return -EINVAL;
> +
>  		iod = idr_find(&ctx->personality_idr, id);
>  		if (unlikely(!iod))
>  			return -EINVAL;
> @@ -10260,6 +10317,8 @@ static int __init io_uring_init(void)
>  	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
>  	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
>  	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
> +	BUILD_BUG_ON(offsetof(struct io_uring_sqe, user_data) !=
> +		     offsetof(struct io_uring_pdu, reserved));
>  
>  	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>  	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 35b2d845704d..e4e822d86e22 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -34,6 +34,18 @@ struct io_uring_task {
>  	bool			sqpoll;
>  };
>  
> +struct io_uring_pdu {
> +	__u64 data[4];	/* available for free use */
> +	__u64 reserved;	/* can't be used by application! */
> +	__u64 data2;	/* available or free use */
> +};
> +
> +struct io_uring_cmd {
> +	struct file *file;
> +	struct io_uring_pdu pdu;
> +	void (*done)(struct io_uring_cmd *, ssize_t);
> +};
> +
>  #if defined(CONFIG_IO_URING)
>  struct sock *io_uring_get_socket(struct file *file);
>  void __io_uring_task_cancel(void);
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index ac4e1738a9af..0a0de40a3a5c 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -137,6 +137,7 @@ enum {
>  	IORING_OP_SHUTDOWN,
>  	IORING_OP_RENAMEAT,
>  	IORING_OP_UNLINKAT,
> +	IORING_OP_URING_CMD,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> -- 
> 2.30.0
> 
