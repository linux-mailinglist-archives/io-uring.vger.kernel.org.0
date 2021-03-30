Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F6234E74D
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 14:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhC3MP7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 08:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhC3MPk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 08:15:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EDAC061574
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 05:15:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j9so14302757wrx.12
        for <io-uring@vger.kernel.org>; Tue, 30 Mar 2021 05:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K6BvwJy6wVYVERFztOW1jZTGBTOtp5H/KwFjttsG9kY=;
        b=t+ENJCDohibHxYn5pFVN5BK1txXhDIgP9ooClvWNFhZOTyy2yK7zae23tUgbpDqaBC
         zIWlisqT8xVgGOLXPQF6/6ceKHAzICfGW6LBuk6Tmnasypi12end5LqF5fh1d2uuaV8n
         oBswAJcrQUAaY+m7l+xS5aeBZmt2FhefL5HPvzX68eBdfmFKX4Y+tdgd5uQia/zkvwPv
         OnHopSLGsUcyO5SwwthABwO5SGAyFep5UhexvjDxYkCGpLb9SsYjTtCRQBCz6CjhMyjt
         CXO7uhNRQ8sYbHB10y6l98iFxtWavVcjUKcEuGv2OZsjTKaFRvZA9NB5I0H5FX+Yon2d
         qgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6BvwJy6wVYVERFztOW1jZTGBTOtp5H/KwFjttsG9kY=;
        b=YltWD+4RGHhW9keEBp+/yAcabGyQKDtxk3YLyHSd6zaCywh1G0Cfkivq0pE8KF3T5J
         L1dj9N7/poQi2Vm88NbNHLoda3fp9z1o7cnBSnCY8aWdaEdOMEe4Z/B3jKzbfKx20aeM
         sx5aNHJYDlU9zRqRHJGaMzHwK85AfnmhaF9yvmLkBnfWFgPym6YWIERsjYlz65Gx+Imz
         EUv7SvTdq1pHdsD3JiD2FCl/QORZYTsxZ0fwhNSibgMcXDBOTdo/hHPSnruAFvaKgH4v
         d2QIr4xFkb4SqZJvy9EaRFyIvByoU4FWk8p+0Dolhybj8weS6OK9X+7K8/ZGHezGdgPk
         V8Ig==
X-Gm-Message-State: AOAM532u6GTQZWC+8mSs3tQJVRNK3qL5eMdG3kGNmn/55Hu46IwsnlG3
        rNadlIZ2aVXaevFKea3hn/TffK+KYXzLfA==
X-Google-Smtp-Source: ABdhPJzsq+towSEAIU+rCSqtierwtT79nSO0Ubsqe/w6wB8T7PUcqr0joHEMHrnhtwn0qOU00BefYA==
X-Received: by 2002:a5d:6b89:: with SMTP id n9mr33347025wrx.236.1617106538940;
        Tue, 30 Mar 2021 05:15:38 -0700 (PDT)
Received: from [192.168.8.117] ([85.255.234.174])
        by smtp.gmail.com with ESMTPSA id i10sm34034889wrs.11.2021.03.30.05.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 05:15:38 -0700 (PDT)
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        io-uring@vger.kernel.org
References: <YGMIwcxAIJPAWGLu@wantstofly.org>
 <YGMJJira3jChpc/n@wantstofly.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v5 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <d70eb4c8-2335-117f-dfaf-8515cad67df5@gmail.com>
Date:   Tue, 30 Mar 2021 13:11:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <YGMJJira3jChpc/n@wantstofly.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/03/2021 12:19, Lennert Buytenhek wrote:
> IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
> arguments, but with a small twist: it takes an additional offset
> argument, and reading from the specified directory starts at the given
> offset.
> 
> Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
> the right directory position before calling vfs_getdents().
> 
> For the first IORING_OP_GETDENTS call on a directory, the offset
> parameter can be set to zero, and for subsequent calls, it can be
> set to the ->d_off field of the last struct linux_dirent64 returned
> by the previous IORING_OP_GETDENTS call.

I still consider this API being quite a mess. In particular, changing
file->pos even with specified offset is neither convenient for users
nor good performance-wise, and just looks weird.

I haven't been following the last discussion, but iirc Matthew proposed
how to do it right. If you want to "get it done quick", just seek
position back after doing your stuff, because once this patch is merged
we have to maintain the behaviour.


> Alternatively, specifying an offset argument of -1 will read from
> the directory's current file offset (IORING_FEAT_RW_CUR_POS).
> 
> Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> ---
>  fs/io_uring.c                 | 66 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 67 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f4ff3da821a5..90637d5a34b9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -670,6 +670,13 @@ struct io_mkdir {
>  	struct filename			*filename;
>  };
>  
> +struct io_getdents {
> +	struct file			*file;
> +	struct linux_dirent64 __user	*dirent;
> +	unsigned int			count;
> +	loff_t				pos;
> +};
> +
>  struct io_completion {
>  	struct file			*file;
>  	struct list_head		list;
> @@ -811,6 +818,7 @@ struct io_kiocb {
>  		struct io_rename	rename;
>  		struct io_unlink	unlink;
>  		struct io_mkdir		mkdir;
> +		struct io_getdents	getdents;
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> @@ -1025,6 +1033,9 @@ static const struct io_op_def io_op_defs[] = {
>  	[IORING_OP_RENAMEAT] = {},
>  	[IORING_OP_UNLINKAT] = {},
>  	[IORING_OP_MKDIRAT] = {},
> +	[IORING_OP_GETDENTS] = {
> +		.needs_file		= 1,
> +	},
>  };
>  
>  static bool io_disarm_next(struct io_kiocb *req);
> @@ -4314,6 +4325,56 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +static int io_getdents_prep(struct io_kiocb *req,
> +			    const struct io_uring_sqe *sqe)
> +{
> +	struct io_getdents *getdents = &req->getdents;
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index)
> +		return -EINVAL;
> +
> +	getdents->pos = READ_ONCE(sqe->off);
> +	getdents->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	getdents->count = READ_ONCE(sqe->len);
> +	return 0;
> +}
> +
> +static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_getdents *getdents = &req->getdents;
> +	int ret = 0;
> +
> +	/* getdents always requires a blocking context */
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
> +	mutex_lock(&req->file->f_pos_lock);
> +
> +	if (getdents->pos != -1 && getdents->pos != req->file->f_pos) {
> +		loff_t res = vfs_llseek(req->file, getdents->pos, SEEK_SET);
> +		if (res < 0)
> +			ret = res;
> +	}
> +
> +	if (ret == 0) {
> +		ret = vfs_getdents(req->file, getdents->dirent,
> +				   getdents->count);
> +	}
> +
> +	mutex_unlock(&req->file->f_pos_lock);
> +
> +	if (ret < 0) {
> +		if (ret == -ERESTARTSYS)
> +			ret = -EINTR;
> +		req_set_fail_links(req);
> +	}
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
>  #if defined(CONFIG_NET)
>  static int io_setup_async_msg(struct io_kiocb *req,
>  			      struct io_async_msghdr *kmsg)
> @@ -5991,6 +6052,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_unlinkat_prep(req, sqe);
>  	case IORING_OP_MKDIRAT:
>  		return io_mkdirat_prep(req, sqe);
> +	case IORING_OP_GETDENTS:
> +		return io_getdents_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6253,6 +6316,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	case IORING_OP_MKDIRAT:
>  		ret = io_mkdirat(req, issue_flags);
>  		break;
> +	case IORING_OP_GETDENTS:
> +		ret = io_getdents(req, issue_flags);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index cf26a94ab880..0693a6e4d6bb 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -138,6 +138,7 @@ enum {
>  	IORING_OP_RENAMEAT,
>  	IORING_OP_UNLINKAT,
>  	IORING_OP_MKDIRAT,
> +	IORING_OP_GETDENTS,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
