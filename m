Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020D13B0B9B
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 19:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhFVRnz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 13:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVRnz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 13:43:55 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BC3C061574;
        Tue, 22 Jun 2021 10:41:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i5so7373193eds.1;
        Tue, 22 Jun 2021 10:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UZm3fHNnA/YCIzOCFqws+e7g1P6uWRfgyjBhMsINiF4=;
        b=a7kgV+FhOcVlDtZnBY+0ze0EdBEwy7CDFOo+Tth0movMxxXydikvKaz2Sqou7sNRdZ
         TPcau192f8geibSen7HJpcj89XnphvRH6vN/VieD/aDSx8QYekfatCInLvT7NFPP9ayI
         J6Fzl6l/Z58FdplEJWNqoYQbViTli7eRjnpJMEYDJydLFBYp+vzCov4iM/G43MOiLxiU
         eAO4Itya631Y/tUUOZJcHQDbtVkoBvFa1DXQWEDHALsHeyPqNkyn6RxqHwwe2mPyIN+P
         M+D+keG1fULYCUHNzJxfYpSjpccVFQyCDYN7xMyeoZ7JGI30Fiy8+c5s/MzsbagPocf5
         JKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZm3fHNnA/YCIzOCFqws+e7g1P6uWRfgyjBhMsINiF4=;
        b=bJNuOfcmFnQzG34LjnXsg/5HN4UtcC3Bd7HeXhi8DoTLBJ0caISlDPVXru03wzvaZq
         ekb6oKnRyKZG6fEw/zwCaFGBIqpvqQVjUMXCfgsF7JRTG854xJeFHY5OyFdfbNr6hkKl
         N6ml+Wv2U4aqtJJRPmoVGPXIi3JCrcATluTJ5BfNUwjmRBPZtBMzswFiwlahZazyYvRI
         FyKepkd8qJSpguiovWL0XVjbJAG1Up6orsx3ZgO92LpL7yeRw9kiF6pwdZEB6ZZz82HC
         vuo3iU4tamwvq+nBNQeHYjW1R3S2VZ2+zNUMXtlZ0uGFOSH05FF9v1DoaaexKvr9RYZJ
         eLIw==
X-Gm-Message-State: AOAM533FltsAJsKNeLfK88T5DVVryi9Ih3Gr911eu4uSzjxS80GbCMQb
        shxZDKAjKwk5J8d/Hi3WOi+CuKmMnQbdlWdq
X-Google-Smtp-Source: ABdhPJwG/04D68AaD6ZeYMr5w5z+ohc/LpyEO1ZuYV5gnJOTo+hvxUkTnZogd4DQ6ywRROHx6Cplrg==
X-Received: by 2002:a05:6402:b6a:: with SMTP id cb10mr6685479edb.275.1624383697447;
        Tue, 22 Jun 2021 10:41:37 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:e69])
        by smtp.gmail.com with ESMTPSA id w1sm81911edr.62.2021.06.22.10.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:41:37 -0700 (PDT)
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-3-dkadashev@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <f45781a8-234e-af92-e73d-a6453bd24f16@gmail.com>
Date:   Tue, 22 Jun 2021 18:41:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603051836.2614535-3-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> IORING_OP_MKDIRAT behaves like mkdirat(2) and takes the same flags
> and arguments.

Jens, a fold-in er discussed, and it will get you
a conflict at 8/10


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4b215e0f8dd8..c0e469ebd22d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3589,7 +3589,7 @@ static int io_mkdirat(struct io_kiocb *req, int issue_flags)
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-		req_set_fail_links(req);
+		req_set_fail(req);
 	io_req_complete(req, ret);
 	return 0;
 }


> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/io_uring.c                 | 55 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 56 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a1ca6badff36..8ab4eb559520 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -665,6 +665,13 @@ struct io_unlink {
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
> @@ -809,6 +816,7 @@ struct io_kiocb {
>  		struct io_shutdown	shutdown;
>  		struct io_rename	rename;
>  		struct io_unlink	unlink;
> +		struct io_mkdir		mkdir;
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> @@ -1021,6 +1029,7 @@ static const struct io_op_def io_op_defs[] = {
>  	},
>  	[IORING_OP_RENAMEAT] = {},
>  	[IORING_OP_UNLINKAT] = {},
> +	[IORING_OP_MKDIRAT] = {},
>  };
>  
>  static bool io_disarm_next(struct io_kiocb *req);
> @@ -3530,6 +3539,44 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +static int io_mkdirat_prep(struct io_kiocb *req,
> +			    const struct io_uring_sqe *sqe)
> +{
> +	struct io_mkdir *mkd = &req->mkdir;
> +	const char __user *fname;
> +
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
> +		req_set_fail_links(req);
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
>  static int io_shutdown_prep(struct io_kiocb *req,
>  			    const struct io_uring_sqe *sqe)
>  {
> @@ -5936,6 +5983,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_renameat_prep(req, sqe);
>  	case IORING_OP_UNLINKAT:
>  		return io_unlinkat_prep(req, sqe);
> +	case IORING_OP_MKDIRAT:
> +		return io_mkdirat_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6077,6 +6126,9 @@ static void io_clean_op(struct io_kiocb *req)
>  		case IORING_OP_UNLINKAT:
>  			putname(req->unlink.filename);
>  			break;
> +		case IORING_OP_MKDIRAT:
> +			putname(req->mkdir.filename);
> +			break;
>  		}
>  		req->flags &= ~REQ_F_NEED_CLEANUP;
>  	}
> @@ -6203,6 +6255,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
> index e1ae46683301..bf9d720d371f 100644
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
