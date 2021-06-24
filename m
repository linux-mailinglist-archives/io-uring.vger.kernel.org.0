Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825163B2FB4
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 15:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhFXNGn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 09:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhFXNGl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 09:06:41 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60ACC061574;
        Thu, 24 Jun 2021 06:04:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f15so6580591wro.8;
        Thu, 24 Jun 2021 06:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tqOFmc3AsN8ZrcXfm8zyUbLuAY7mjz+hRVJIlXtXUos=;
        b=Lbqd9NVjnjK+JUPAwtqdPTozSqcPMTFBiPWlwHp8Z6GNs5IBtCO7x7aFdLVxX50/1a
         eLx0HKTnUZt2fO2JMM9L7r74rC2qPZBsL23AzYzSMf+hMCHCDMUovzRrgzMHw1Lio7Up
         jIPIDsEbhGM0D0IEydU4/Jcpdt23kBNjSULKiRfhVD3ypF5VoCbGz+x59N0uRFKq2TUv
         hOYIWGnZXNYDlJil25tJSN/ls2WzmLYYV4zlXf+A+auyS0J3KHzoiEtqS/wSVQY0NJ1D
         7GIjEcM4skP7hVr6PTWpVDBEfAgLzu/rRytFxx8/PbO/0RlaITqJeJJs6qOAfQCohIto
         U+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tqOFmc3AsN8ZrcXfm8zyUbLuAY7mjz+hRVJIlXtXUos=;
        b=GZdLd2pzm9hSNlAvikWNlBVwNDDlehMfVcL//f5e2Ah6DfE9oiOJ7ObFgxe/UOnJbH
         A0UtZBU3+LdbPZRzpleHP7tmAjpDJALyX0evotK7sU9w4cRWmsgBYlzStdFoVjQpi/UY
         5jZUJFT1Nah4z3qw4O6GFZobZk4NGRgguozweRava67hfpXy5Dy/ReA+v5aArqSIlJYz
         vm0+xPQGUxvzNtnaBth+8xJsdMTm1ON9dHy4jzwLynkTB4b6HigKtPHHMJoJ/xqWKTKH
         5urgJCdRw0BWP2A993P+a/+BASOVdmOWO5bWhTXnZ0p447IBJtL2aQjUHA5vqZRYIW25
         jMNg==
X-Gm-Message-State: AOAM530zBGIO64uBNatgzpDTkQiOZNxoNwYIdAyCQAhHbYaIuYHbm6SN
        ov9Fldtj8hIYLT9mymab9q+XRfa5cLLDluyT
X-Google-Smtp-Source: ABdhPJxwsMF0qOqviQlq/IMUwd7mkmL0S2QO36LcGoXnG7G+RsDDyA0+hS2I7t49o0BQjKGZyuRN6A==
X-Received: by 2002:a5d:4e0b:: with SMTP id p11mr4424597wrt.132.1624539860119;
        Thu, 24 Jun 2021 06:04:20 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id o11sm2904206wmq.1.2021.06.24.06.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 06:04:19 -0700 (PDT)
Subject: Re: [PATCH v6 8/9] io_uring: add support for IORING_OP_SYMLINKAT
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210624111452.658342-1-dkadashev@gmail.com>
 <20210624111452.658342-9-dkadashev@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ee2ed452-212d-b1a6-74ab-6907660effa6@gmail.com>
Date:   Thu, 24 Jun 2021 14:04:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624111452.658342-9-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/24/21 12:14 PM, Dmitry Kadashev wrote:
> IORING_OP_SYMLINKAT behaves like symlinkat(2) and takes the same flags
> and arguments.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/internal.h                 |  1 +
>  fs/io_uring.c                 | 66 +++++++++++++++++++++++++++++++++++
>  fs/namei.c                    |  3 +-
>  include/uapi/linux/io_uring.h |  1 +
>  4 files changed, 69 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 207a455e32d3..3b3954214385 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -78,6 +78,7 @@ int may_linkat(struct user_namespace *mnt_userns, struct path *link);
>  int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
>  		 struct filename *newname, unsigned int flags);
>  int do_mkdirat(int dfd, struct filename *name, umode_t mode);
> +int do_symlinkat(struct filename *from, int newdfd, struct filename *to);
>  
>  /*
>   * namespace.c
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7aa08ed78452..c161f06a3cea 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -680,6 +680,13 @@ struct io_mkdir {
>  	struct filename			*filename;
>  };
>  
> +struct io_symlink {
> +	struct file			*file;
> +	int				new_dfd;
> +	struct filename			*oldpath;
> +	struct filename			*newpath;
> +};
> +
>  struct io_completion {
>  	struct file			*file;
>  	struct list_head		list;
> @@ -833,6 +840,7 @@ struct io_kiocb {
>  		struct io_rename	rename;
>  		struct io_unlink	unlink;
>  		struct io_mkdir		mkdir;
> +		struct io_symlink	symlink;
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> @@ -1048,6 +1056,7 @@ static const struct io_op_def io_op_defs[] = {
>  	[IORING_OP_RENAMEAT] = {},
>  	[IORING_OP_UNLINKAT] = {},
>  	[IORING_OP_MKDIRAT] = {},
> +	[IORING_OP_SYMLINKAT] = {},
>  };
>  
>  static bool io_disarm_next(struct io_kiocb *req);
> @@ -3599,6 +3608,54 @@ static int io_mkdirat(struct io_kiocb *req, int issue_flags)
>  	return 0;
>  }
>  
> +static int io_symlinkat_prep(struct io_kiocb *req,
> +			    const struct io_uring_sqe *sqe)
> +{
> +	struct io_symlink *sl = &req->symlink;
> +	const char __user *oldpath, *newpath;
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +	if (sqe->ioprio || sqe->len || sqe->rw_flags || sqe->buf_index)
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	sl->new_dfd = READ_ONCE(sqe->fd);
> +	oldpath = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	newpath = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +
> +	sl->oldpath = getname(oldpath);
> +	if (IS_ERR(sl->oldpath))
> +		return PTR_ERR(sl->oldpath);
> +
> +	sl->newpath = getname(newpath);
> +	if (IS_ERR(sl->newpath)) {
> +		putname(sl->oldpath);
> +		return PTR_ERR(sl->newpath);
> +	}
> +
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +	return 0;
> +}
> +
> +static int io_symlinkat(struct io_kiocb *req, int issue_flags)
> +{
> +	struct io_symlink *sl = &req->symlink;
> +	int ret;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +	ret = do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
>  static int io_shutdown_prep(struct io_kiocb *req,
>  			    const struct io_uring_sqe *sqe)
>  {
> @@ -6009,6 +6066,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_unlinkat_prep(req, sqe);
>  	case IORING_OP_MKDIRAT:
>  		return io_mkdirat_prep(req, sqe);
> +	case IORING_OP_SYMLINKAT:
> +		return io_symlinkat_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6173,6 +6232,10 @@ static void io_clean_op(struct io_kiocb *req)
>  		case IORING_OP_MKDIRAT:
>  			putname(req->mkdir.filename);
>  			break;
> +		case IORING_OP_SYMLINKAT:
> +			putname(req->symlink.oldpath);
> +			putname(req->symlink.newpath);
> +			break;
>  		}
>  	}
>  	if ((req->flags & REQ_F_POLLED) && req->apoll) {
> @@ -6304,6 +6367,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	case IORING_OP_MKDIRAT:
>  		ret = io_mkdirat(req, issue_flags);
>  		break;
> +	case IORING_OP_SYMLINKAT:
> +		ret = io_symlinkat(req, issue_flags);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> diff --git a/fs/namei.c b/fs/namei.c
> index f99de6e294ad..f5b0379d2f8c 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -4208,8 +4208,7 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
>  }
>  EXPORT_SYMBOL(vfs_symlink);
>  
> -static int do_symlinkat(struct filename *from, int newdfd,
> -		  struct filename *to)
> +int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
>  {
>  	int error;
>  	struct dentry *dentry;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 49a24a149eeb..796f37ab4ce3 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -138,6 +138,7 @@ enum {
>  	IORING_OP_RENAMEAT,
>  	IORING_OP_UNLINKAT,
>  	IORING_OP_MKDIRAT,
> +	IORING_OP_SYMLINKAT,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
