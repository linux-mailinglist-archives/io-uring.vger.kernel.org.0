Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C822F2200D8
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 01:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGNXG1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 19:06:27 -0400
Received: from lavender.maple.relay.mailchannels.net ([23.83.214.99]:51713
        "EHLO lavender.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbgGNXG1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 19:06:27 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 5A86D54196D;
        Tue, 14 Jul 2020 22:59:09 +0000 (UTC)
Received: from pdx1-sub0-mail-a68.g.dreamhost.com (100-96-5-127.trex.outbound.svc.cluster.local [100.96.5.127])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 7BA16541A79;
        Tue, 14 Jul 2020 22:59:08 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a68.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Tue, 14 Jul 2020 22:59:09 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Gusty-Chemical: 62a022ad62cb2212_1594767548955_2352658233
X-MC-Loop-Signature: 1594767548955:1861628098
X-MC-Ingress-Time: 1594767548955
Received: from pdx1-sub0-mail-a68.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a68.g.dreamhost.com (Postfix) with ESMTP id 33F097F238;
        Tue, 14 Jul 2020 15:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=aJDUBaigUHtbkn8R6sBj6rhyJnI=; b=
        M+eAD/20uP5EYDA2Qia4ogBrtewfzZz9trRG9XBa9VZNHRHFjIVPwqkC76Z169jD
        b3/eoNz0i5xuty7aymTU5O5eJuNDtWFtTFbGWUz2YOsGAOrN5xKSQ2s8cdvyJ8iG
        ewZxEwqKx4pwDsqSE8Qr+0VT6pMZheJYNE4wY+NXwUg=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a68.g.dreamhost.com (Postfix) with ESMTPSA id 736527F11D;
        Tue, 14 Jul 2020 15:59:06 -0700 (PDT)
Date:   Tue, 14 Jul 2020 17:59:05 -0500
X-DH-BACKEND: pdx1-sub0-mail-a68
From:   Clay Harris <bugs@claycon.org>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [WIP PATCH] io_uring: Support opening a file into the fixed-file
 table
Message-ID: <20200714225905.jqlvdvxx564rykxu@ps29521.dreamhostps.com>
References: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrfedugdduhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqeenucggtffrrghtthgvrhhnpefgtdekjeehffefvdfhhedttdehkeejgfegiedtjedthfeuvdfgieevkeekvdfhvdenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 14 2020 at 14:08:26 -0700, Josh Triplett quoth thus:

> Add a new operation IORING_OP_OPENAT2_FIXED_FILE, which opens a file
> into the fixed-file table rather than installing a file descriptor.
> Using a new operation avoids having an IOSQE flag that almost all
> operations will need to ignore; io_openat2_fixed_file also has
> substantially different control-flow than io_openat2, and it can avoid
> requiring the file table if not needed for the dirfd.
> 
> (This intentionally does not use the IOSQE_FIXED_FILE flag, because
> semantically, IOSQE_FIXED_FILE for openat2 should mean to interpret the
> dirfd as a fixed-file-table index, and that would be useful future
> behavior for both IORING_OP_OPENAT2 and IORING_OP_OPENAT2_FIXED_FILE.)
> 
> Create a new io_sqe_files_add_new function to add a single new file to
> the fixed-file table. This function returns -EBUSY if attempting to
> overwrite an existing file.
> 
> Provide a new field to pass along the fixed-file-table index for an
> open-like operation; future operations such as
> IORING_OP_ACCEPT_FIXED_FILE can use the same index.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> (Should this check for and reject open flags like O_CLOEXEC that only
> affect the file descriptor?)
> 
> I've tested this (and I'll send my liburing patch momentarily), and it
> works fine if you do the open in one batch and operate on the fixed-file
> in another batch. As discussed via Twitter, opening and operating on a
> file in the same batch will require changing other operations to obtain
> their fixed-file entries later, post-prep.
> 
> It might make sense to do and test that for one operation at a time, and
> add a .late_fixed_file flag to the operation definition for operations
> that support that.
> 
> It might also make sense to have the prep for
> IORING_OP_OPENAT2_FIXED_FILE stick an indication in the fixed-file table
> that there *will* be a file there later, perhaps an
> ERR_PTR(-EINPROGRESS), and make sure there isn't one already, to detect
> potential errors earlier and to let the prep for other operations
> confirm that there *will* be a file; on the other hand, that would mean
> there's an invalid non-NULL file pointer in the fixed file table, which
> seems potentially error-prone if any operation ever forgets that.
> 
> The other next step would be to add an IORING_OP_CLOSE_FIXED_FILE
> (separate from the existing CLOSE op) that removes an entry currently in
> the fixed file table and calls fput on it. (With some care, that
> *should* be possible even for an entry that was originally registered
> from a file descriptor.)
> 
> And finally, we should have an IORING_OP_FIXED_FILE_TO_FD operation,
> which calls get_unused_fd_flags (with specified flags to allow for
> O_CLOEXEC) and then fd_install. That allows opening a file via io_uring,
> operating on it via the ring, but then also operating on it via other
> syscalls (or inheriting it or anything else you can do with a file
> descriptor).

I'd been thinking about fixed file operations previous to your post,
so I'm happy to see this work.

I see IORING_OP_FIXED_FILE_TO_FD as a dup() function from fixed file
to process descriptor space.  It would be nice if it would take
parameters to select the functionality of dup, dup2, dup3, F_DUPFD,
and F_DUPFD_CLOEXEC.  As I recall, O_CLOFORK is on its way from
Posix-land, so I'd think there will also be something like
F_DUPFD_CLOFORK coming.

> 

It would be useful if IORING_REGISTER_xxx_UPDATE would accept a
placeholder value to ask the kernel not to mess with that index.
I think AT_FDCWD would be a good choice.

>  fs/io_uring.c                 | 90 ++++++++++++++++++++++++++++++++++-
>  include/uapi/linux/io_uring.h |  6 ++-
>  2 files changed, 94 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 9fd7e69696c3..df6f017ef8e8 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -425,6 +425,7 @@ struct io_sr_msg {
>  struct io_open {
>  	struct file			*file;
>  	int				dfd;
> +	u32				open_fixed_idx;
>  	struct filename			*filename;
>  	struct open_how			how;
>  	unsigned long			nofile;
> @@ -878,6 +879,10 @@ static const struct io_op_def io_op_defs[] = {
>  		.hash_reg_file		= 1,
>  		.unbound_nonreg_file	= 1,
>  	},
> +	[IORING_OP_OPENAT2_FIXED_FILE] = {
> +		.file_table		= 1,
> +		.needs_fs		= 1,
> +	},
>  };
>  
>  static void io_wq_submit_work(struct io_wq_work **workptr);
> @@ -886,6 +891,9 @@ static void io_put_req(struct io_kiocb *req);
>  static void __io_double_put_req(struct io_kiocb *req);
>  static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
>  static void io_queue_linked_timeout(struct io_kiocb *req);
> +static int io_sqe_files_add_new(struct io_ring_ctx *ctx,
> +				u32 index,
> +				struct file *file);
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				 struct io_uring_files_update *ip,
>  				 unsigned nr_args);
> @@ -3060,10 +3068,48 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  					len);
>  	if (ret)
>  		return ret;
> +	req->open.open_fixed_idx = READ_ONCE(sqe->open_fixed_idx);
>  
>  	return __io_openat_prep(req, sqe);
>  }
>  
> +static int io_openat2_fixed_file(struct io_kiocb *req, bool force_nonblock)
> +{
> +	struct io_open *open = &req->open;
> +	struct open_flags op;
> +	struct file *file;
> +	int ret;
> +
> +	if (force_nonblock) {
> +		/* only need file table for an actual valid fd */
> +		if (open->dfd == -1 || open->dfd == AT_FDCWD)
> +			req->flags |= REQ_F_NO_FILE_TABLE;
> +		return -EAGAIN;
> +	}
> +
> +	ret = build_open_flags(&open->how, &op);
> +	if (ret)
> +		goto err;
> +
> +	file = do_filp_open(open->dfd, open->filename, &op);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +	} else {
> +		fsnotify_open(file);
> +		ret = io_sqe_files_add_new(req->ctx, open->open_fixed_idx, file);
> +		if (ret)
> +			fput(file);
> +	}
> +err:
> +	putname(open->filename);
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +	if (ret < 0)
> +		req_set_fail_links(req);
> +	io_cqring_add_event(req, ret);
> +	io_put_req(req);
> +	return 0;
> +}
> +
>  static int io_openat2(struct io_kiocb *req, bool force_nonblock)
>  {
>  	struct open_flags op;
> @@ -5048,6 +5094,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
>  		ret = io_madvise_prep(req, sqe);
>  		break;
>  	case IORING_OP_OPENAT2:
> +	case IORING_OP_OPENAT2_FIXED_FILE:
>  		ret = io_openat2_prep(req, sqe);
>  		break;
>  	case IORING_OP_EPOLL_CTL:
> @@ -5135,6 +5182,7 @@ static void io_cleanup_req(struct io_kiocb *req)
>  		break;
>  	case IORING_OP_OPENAT:
>  	case IORING_OP_OPENAT2:
> +	case IORING_OP_OPENAT2_FIXED_FILE:
>  		break;
>  	case IORING_OP_SPLICE:
>  	case IORING_OP_TEE:
> @@ -5329,12 +5377,17 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		ret = io_madvise(req, force_nonblock);
>  		break;
>  	case IORING_OP_OPENAT2:
> +	case IORING_OP_OPENAT2_FIXED_FILE:
>  		if (sqe) {
>  			ret = io_openat2_prep(req, sqe);
>  			if (ret)
>  				break;
>  		}
> -		ret = io_openat2(req, force_nonblock);
> +		if (req->opcode == IORING_OP_OPENAT2) {
> +			ret = io_openat2(req, force_nonblock);
> +		} else {
> +			ret = io_openat2_fixed_file(req, force_nonblock);
> +		}
>  		break;
>  	case IORING_OP_EPOLL_CTL:
>  		if (sqe) {
> @@ -6791,6 +6844,41 @@ static int io_queue_file_removal(struct fixed_file_data *data,
>  	return 0;
>  }
>  
> +/*
> + * Add a single new file in an empty entry of the fixed file table. Does not
> + * allow overwriting an existing entry; returns -EBUSY in that case.
> + */
> +static int io_sqe_files_add_new(struct io_ring_ctx *ctx,
> +				u32 index,
> +				struct file *file)
> +{
> +	struct fixed_file_table *table;
> +	u32 i;
> +	int err;
> +
> +	if (unlikely(index > ctx->nr_user_files))
> +		return -EINVAL;
> +	i = array_index_nospec(index, ctx->nr_user_files);
> +	table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
> +	index = i & IORING_FILE_TABLE_MASK;
> +	if (unlikely(table->files[index]))
> +		return -EBUSY;
> +	/*
> +	 * Don't allow io_uring instances to be registered. If UNIX isn't
> +	 * enabled, then this causes a reference cycle and this instance can
> +	 * never get freed. If UNIX is enabled we'll handle it just fine, but
> +	 * there's still no point in allowing a ring fd as it doesn't support
> +	 * regular read/write anyway.
> +	 */
> +	if (unlikely(file->f_op == &io_uring_fops))
> +		return -EBADF;
> +	err = io_sqe_file_register(ctx, file, i);
> +	if (err)
> +		return err;
> +	table->files[index] = file;
> +	return 0;
> +}
> +
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				 struct io_uring_files_update *up,
>  				 unsigned nr_args)
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 7843742b8b74..95f107e6f65e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -54,7 +54,10 @@ struct io_uring_sqe {
>  			} __attribute__((packed));
>  			/* personality to use, if used */
>  			__u16	personality;
> -			__s32	splice_fd_in;
> +			union {
> +				__s32	splice_fd_in;
> +				__s32	open_fixed_idx;
> +			};
>  		};
>  		__u64	__pad2[3];
>  	};
> @@ -130,6 +133,7 @@ enum {
>  	IORING_OP_PROVIDE_BUFFERS,
>  	IORING_OP_REMOVE_BUFFERS,
>  	IORING_OP_TEE,
> +	IORING_OP_OPENAT2_FIXED_FILE,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> -- 
> 2.28.0.rc0
