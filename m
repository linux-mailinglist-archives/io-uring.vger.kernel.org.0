Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8090F45DDEF
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 16:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356248AbhKYPwp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 10:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349320AbhKYPuk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 10:50:40 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3824DC0613B6;
        Thu, 25 Nov 2021 07:41:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d24so12601547wra.0;
        Thu, 25 Nov 2021 07:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=zhH8fxtB+0n5fQbasrwiigO8GJPjUdLGMJQNz0kRVbY=;
        b=CvWfUp+ysNo7JFBx9Cs/VKy+06hAw+k+A6p09tRehRmAd2BgHCg0qnr5QKQ0VywFav
         mlM1Iy/PK2Fkw5fIz1TP+zwUQZvm2MVd/5MmnHqTw+zcQX9aL1bn9A/TuqiW8YaUUags
         mtLTqdfiXSpc9nPk3jtsls9htT83Qgkx8A8BT+XD2eJLTco8r4pOCodouutZw/5Skl6E
         Jpc10uoXun1lisKG3aZeg5JcO8h3Ft+MhgTdbNCnYqkKEXY7eB/3B7C716hn4e8yIobH
         T2hS3H3ROw96ZBj+Vrp3sqC77wy4qwyK+dh/UcB34dZ4BnXhE9C2YJdV90WnMqPxoKG3
         qJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zhH8fxtB+0n5fQbasrwiigO8GJPjUdLGMJQNz0kRVbY=;
        b=AGMo4Mfysh56kldFQ1VyR8LOKscdeXJLr5RA1zReraC+M9HssSwzYTz2AIn1PwZO0a
         QtS6kPbCWwRKvMW7yaAIw56SXfQn/VgJ8NlMBKnBWoaLBNAH8RDQIYaRYvJcvPvbRlFI
         uzsD0O5mAdIVcLY/efGxogW4FiAWDYojyqMjZ6a2JAqXeLttw4tqUQKJtA+ruFJxDGfd
         JJk0hsCgm0lHpi8xacGLTcYUn1jpPgFdJSDa7vxWGEfh6z+vXUFjv+9mVviGP05F/TXU
         rblqiuzfYpY01GDMBSTRWhtKZSfzgSoZuuNe+sxCHL2aK+Db2mwv8B5y27EjMSyqx/qj
         Bc2Q==
X-Gm-Message-State: AOAM531GcFeh+htk8eaq8Pn1SGffCLHWQZ2xQODhwV9ZL2JEZJZS5SuZ
        3hkKglM496KeZnlPYimTOh5zSltMtKM=
X-Google-Smtp-Source: ABdhPJwJDriPk97ETIxBIFyO5Eosd7T/WKFIxM6wAxQ4VfN6v3L8EPZ0K7PUlWUSI6xi92QeuJ5zgw==
X-Received: by 2002:adf:e8c9:: with SMTP id k9mr7306136wrn.603.1637854885720;
        Thu, 25 Nov 2021 07:41:25 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id f18sm3101217wre.7.2021.11.25.07.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:41:25 -0800 (PST)
Message-ID: <9d9742a5-6965-d259-e1b4-f9422cc1306a@gmail.com>
Date:   Thu, 25 Nov 2021 15:41:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v1 3/3] io_uring: add support for getdents64
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20211123181010.1607630-1-shr@fb.com>
 <20211123181010.1607630-4-shr@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211123181010.1607630-4-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/23/21 18:10, Stefan Roesch wrote:
> This adds support for getdents64 to io_uring.

Looks good,
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>   fs/io_uring.c                 | 52 +++++++++++++++++++++++++++++++++++
>   include/uapi/linux/io_uring.h |  1 +
>   2 files changed, 53 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b07196b4511c..b19fa94bcd95 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -688,6 +688,13 @@ struct io_hardlink {
>   	int				flags;
>   };
>   
> +struct io_getdents {
> +	struct file			*file;
> +	struct linux_dirent64 __user	*dirent;
> +	unsigned int			count;
> +	loff_t				pos;
> +};
> +
>   struct io_async_connect {
>   	struct sockaddr_storage		address;
>   };
> @@ -847,6 +854,7 @@ struct io_kiocb {
>   		struct io_mkdir		mkdir;
>   		struct io_symlink	symlink;
>   		struct io_hardlink	hardlink;
> +		struct io_getdents	getdents;
>   	};
>   
>   	u8				opcode;
> @@ -1096,6 +1104,9 @@ static const struct io_op_def io_op_defs[] = {
>   	[IORING_OP_MKDIRAT] = {},
>   	[IORING_OP_SYMLINKAT] = {},
>   	[IORING_OP_LINKAT] = {},
> +	[IORING_OP_GETDENTS] = {
> +		.needs_file		= 1,
> +	},
>   };
>   
>   /* requests with any of those set should undergo io_disarm_next() */
> @@ -3940,6 +3951,42 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
>   	return 0;
>   }
>   
> +static int io_getdents_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
> +
> +	return 0;
> +}
> +
> +static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_getdents *getdents = &req->getdents;
> +	int ret;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +	ret = vfs_getdents(req->file, getdents->dirent, getdents->count, getdents->pos);
> +	if (ret < 0) {
> +		if (ret == -ERESTARTSYS)
> +			ret = -EINTR;
> +
> +		req_set_fail(req);
> +	}
> +
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
>   static int io_shutdown_prep(struct io_kiocb *req,
>   			    const struct io_uring_sqe *sqe)
>   {
> @@ -6446,6 +6493,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		return io_symlinkat_prep(req, sqe);
>   	case IORING_OP_LINKAT:
>   		return io_linkat_prep(req, sqe);
> +	case IORING_OP_GETDENTS:
> +		return io_getdents_prep(req, sqe);
>   	}
>   
>   	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6728,6 +6777,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>   	case IORING_OP_LINKAT:
>   		ret = io_linkat(req, issue_flags);
>   		break;
> +	case IORING_OP_GETDENTS:
> +		ret = io_getdents(req, issue_flags);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index c45b5e9a9387..792875075a2f 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -140,6 +140,7 @@ enum {
>   	IORING_OP_MKDIRAT,
>   	IORING_OP_SYMLINKAT,
>   	IORING_OP_LINKAT,
> +	IORING_OP_GETDENTS,
>   
>   	/* this goes last, obviously */
>   	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
