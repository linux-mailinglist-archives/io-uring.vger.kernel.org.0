Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFE122159D
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 21:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGOT4M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 15:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOT4L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 15:56:11 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228D1C061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 12:56:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so4112983wrv.9
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 12:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sze9JGS9PBcW6EBkXqr2qxtzXJHKSDXrmMgBBU2ojCA=;
        b=CUweVtwa/o3lJzkyg+2B4cjeKUo8G9Vo9LwKGQjcAFQVkmKIJhWeCQKD8BWXEo2lOz
         wlMjQxy6bQEpXV9hZsfIiZdMg0EDRWdFysmV2wVbnknNmSe7UPjv6qjdlfTqooQ1bo/f
         zLv9VA6eFxJpCZ0i5Tsb6/mx9eC/rTcQDwZ5GObwLAH6nProuawrFuDMpL3fYfz5abKq
         Kp2IUFerLWajus65VYSpUEutMA6oEGtxfsFYyM0OMm7+ZV+qFNIkeY6yrOLc8IaT5JWR
         JLL+8kGtbPflWD2w4uIPVhFPF1BsaQXXHgiiemmNrf4riLaoLDUPS0VLIWOLkFgTnCYW
         1J+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Sze9JGS9PBcW6EBkXqr2qxtzXJHKSDXrmMgBBU2ojCA=;
        b=CTLpnEgweVcXpS5IVk11zErTKf8bhYBB/6PMKe/vK2gOyQA/zBwvW/osb+9MOGDtdT
         armg/wXyO8hHI1+UlH0eqVqIJZUKhYBXXQVFFAjlk1tGwePANj5Ho0EAJxXpHdT7LyoL
         HItQXvdyHM9JHILKZFQK7ZemdiExXtgllruzkMrC5Od05iOgaFNLv/nlxqygB86dAZVR
         lCJ29UexP6Rpv66nBfF+QJ85SgtTac0sVoDA1VciKSaWAhllOhRqVf+VKCYYjP/1xM7I
         CN+KTT0aiTXHQ3zc1NmH/MsgDNsOWt30d2ueTmU+SoRl7s+1QueEUGk5npF2MMHHIW0n
         aLbA==
X-Gm-Message-State: AOAM5323JRZg81NLrqA9SgXor93TTve60lTtDogfPX5AlsAh5cbP+MXb
        s2ZfYJRWsld0vSpRaZ3mHUQCERXCxkk=
X-Google-Smtp-Source: ABdhPJxWCDkTR4jZinMffzmENz3jpfJjiTjn+DHgPlJpqL1y6F5B9IEhhOz1mA8GbwfMQhk6cXYyWw==
X-Received: by 2002:a5d:60d1:: with SMTP id x17mr1045115wrt.293.1594842969186;
        Wed, 15 Jul 2020 12:56:09 -0700 (PDT)
Received: from [192.168.43.238] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 92sm5312081wrr.96.2020.07.15.12.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 12:56:08 -0700 (PDT)
To:     Josh Triplett <josh@joshtriplett.org>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [WIP PATCH] io_uring: Support opening a file into the fixed-file
 table
Message-ID: <3fa35c6e-58df-09c5-3b7b-ded4f57356e8@gmail.com>
Date:   Wed, 15 Jul 2020 22:54:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/07/2020 00:08, Josh Triplett wrote:
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
> 
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

How about having it in io_openat2()? There are almost identical, that would be
just a couple of if's.

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

These 2 lines are better to be replace with (since 5.9):

io_req_complete(req, ret);

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

These OPENAT cases weren't doing anything, so were killed,
as should be this line.

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

We don't need all these brackets for one liners

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

I think, it's better to reuse IORING_OP_OPENAT2.
E.g. fixed version if "open_fixed_idx != 0" or something similar.

>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
