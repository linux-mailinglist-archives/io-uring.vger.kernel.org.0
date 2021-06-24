Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4503D3B2FB1
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 15:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFXNGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 09:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFXNGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 09:06:24 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE09DC061756;
        Thu, 24 Jun 2021 06:04:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d11so6641532wrm.0;
        Thu, 24 Jun 2021 06:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=utIoD59szXP++PQPbacICDCP8YEBmnQcn0cMpGnY05E=;
        b=hI9KsOGjf0++CrSF32R+xsRZWqdVY7FXn1tfjaIg5PVO55ACNvLUtRtK/h/cScJHY7
         WOlE8W5LuMqTClJbeEaj+Fliq4qmujEO08Me+SMBMxjCIlVV6YGlAUVQKdOwdzyVTbuX
         TwKmhyssXU0HUN+lJUAHyiXSOmJZbbAS2PP65leuArxtdFWJ9Xch6zZvVTb25e71u5ad
         8dS80lgHIIyBLpmmcNW2Vza6j8p94cb51XJ/K9/h1Laco+ouwDIT0JmKXxNFQHASTU71
         FsNZO15Vti06STgUk+4Sj7yfQFyyCSSMXQoVgH5S86fD8eubX9XCWj+jGfoRVzYI+F30
         lusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=utIoD59szXP++PQPbacICDCP8YEBmnQcn0cMpGnY05E=;
        b=Z4Sy4LPV61fh52wXrLk8ZVtxdeh1otjNaE6uAmsPv/s+Ejlkypj2vDSPxrD+LA0qEV
         vrqaXIxlB7MDjRRJ7995FIUOk22DjTt7Z9+NJ4dM4qYR/MCjymPQR7hhG71BMedAErAs
         ntX9Jx0hsruiiI5LJOFV1OqqN9bXKF4t+nnYFeKWc1jg5g9NVU+hZ3LdNnVbVTkfpXGX
         oDZ4Z9z4sC4lugCetTytZICJvs2jFZBbq3nAqXwMucJdr1JhZBQB7WTfEhJ+OlaHnTDH
         ye2HxQd+0FtdLRttR5snJB/Cs3Gq/5t7sX1L9+9tTEu29TZv4wwdp6lVvzc+fZNZaeyj
         3l5w==
X-Gm-Message-State: AOAM530uGoYvCYXU1GOt3kjelHlUE6dRWoyZGJVwhYI86MmOt+CZklgs
        7XBIxOdlXJ7BC5l+tm2uFt8NoR8cih8fzVPI
X-Google-Smtp-Source: ABdhPJwpidTlXKwOBEuJPAQCtlfaXr5THuW1taiZkjB9Ika02PUxzIrVxQbOkvEQ9iSgXux4g7kpmA==
X-Received: by 2002:adf:e652:: with SMTP id b18mr4292818wrn.379.1624539843058;
        Thu, 24 Jun 2021 06:04:03 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g10sm2966906wmh.33.2021.06.24.06.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 06:04:02 -0700 (PDT)
Subject: Re: [PATCH v6 2/9] io_uring: add support for IORING_OP_MKDIRAT
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210624111452.658342-1-dkadashev@gmail.com>
 <20210624111452.658342-3-dkadashev@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <91aeb170-c86a-6f37-7c27-4cce9a71fb49@gmail.com>
Date:   Thu, 24 Jun 2021 14:03:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624111452.658342-3-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/24/21 12:14 PM, Dmitry Kadashev wrote:
> IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
> and arguments.

io_uring part looks good, great finally see it taken.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/io_uring.c                 | 59 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 60 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e7997f9bf879..7aa08ed78452 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -673,6 +673,13 @@ struct io_unlink {
>  	struct filename			*filename;
>  };
>  
> +struct io_mkdir {
> +	struct file			*file;
> +	int				dfd;
> +	umode_t				mode;
> +	struct filename			*filename;
> +};
> +
>  struct io_completion {
>  	struct file			*file;
>  	struct list_head		list;
> @@ -825,6 +832,7 @@ struct io_kiocb {
>  		struct io_shutdown	shutdown;
>  		struct io_rename	rename;
>  		struct io_unlink	unlink;
> +		struct io_mkdir		mkdir;
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> @@ -1039,6 +1047,7 @@ static const struct io_op_def io_op_defs[] = {
>  	},
>  	[IORING_OP_RENAMEAT] = {},
>  	[IORING_OP_UNLINKAT] = {},
> +	[IORING_OP_MKDIRAT] = {},
>  };
>  
>  static bool io_disarm_next(struct io_kiocb *req);
> @@ -3548,6 +3557,48 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +static int io_mkdirat_prep(struct io_kiocb *req,
> +			    const struct io_uring_sqe *sqe)
> +{
> +	struct io_mkdir *mkd = &req->mkdir;
> +	const char __user *fname;
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +	if (sqe->ioprio || sqe->off || sqe->rw_flags || sqe->buf_index)
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	mkd->dfd = READ_ONCE(sqe->fd);
> +	mkd->mode = READ_ONCE(sqe->len);
> +
> +	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	mkd->filename = getname(fname);
> +	if (IS_ERR(mkd->filename))
> +		return PTR_ERR(mkd->filename);
> +
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +	return 0;
> +}
> +
> +static int io_mkdirat(struct io_kiocb *req, int issue_flags)
> +{
> +	struct io_mkdir *mkd = &req->mkdir;
> +	int ret;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +	ret = do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
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
> @@ -5956,6 +6007,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_renameat_prep(req, sqe);
>  	case IORING_OP_UNLINKAT:
>  		return io_unlinkat_prep(req, sqe);
> +	case IORING_OP_MKDIRAT:
> +		return io_mkdirat_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6117,6 +6170,9 @@ static void io_clean_op(struct io_kiocb *req)
>  		case IORING_OP_UNLINKAT:
>  			putname(req->unlink.filename);
>  			break;
> +		case IORING_OP_MKDIRAT:
> +			putname(req->mkdir.filename);
> +			break;
>  		}
>  	}
>  	if ((req->flags & REQ_F_POLLED) && req->apoll) {
> @@ -6245,6 +6301,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	case IORING_OP_UNLINKAT:
>  		ret = io_unlinkat(req, issue_flags);
>  		break;
> +	case IORING_OP_MKDIRAT:
> +		ret = io_mkdirat(req, issue_flags);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index f1f9ac114b51..49a24a149eeb 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -137,6 +137,7 @@ enum {
>  	IORING_OP_SHUTDOWN,
>  	IORING_OP_RENAMEAT,
>  	IORING_OP_UNLINKAT,
> +	IORING_OP_MKDIRAT,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
