Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0373B2EB677
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 00:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbhAEXsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jan 2021 18:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbhAEXsK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jan 2021 18:48:10 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFD6C061574
        for <io-uring@vger.kernel.org>; Tue,  5 Jan 2021 15:47:29 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e25so1114795wme.0
        for <io-uring@vger.kernel.org>; Tue, 05 Jan 2021 15:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PJ3Rw9hoU8jyBKMZA++fg0fB6VlZPAeiMQMVBdGXbow=;
        b=ZJLHd0FAWA9z5GNX+4IYBOT0cdb9/POKKvlh3wZPF5Im7/xqxPlqeC7xihNQkcQkPu
         rIgYfGGOJq3PLvJxYo89sclTyJ4n32WoagNt1Af7s+EDz2AINxUiuDgCALQGJUz+OSZ4
         yELnHXXg+DS8382TD71fHIw22xtXMVxaik0AYL2t7IQL0LeGDcAEHfMTWrBo9mm9nein
         p/eaD7HGl9Sxu3qlGIOIPE4EPzQJwamwEJUzo5NDdJu/gQyOLi5YVGg4CX/dQv+HxhEG
         6Jjef/m/EllgNNL5PX2PLVNGyVO3xwN9RnfO1eHpfsXVmA3mlPYOuhUPueNtebxVnbDf
         68AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PJ3Rw9hoU8jyBKMZA++fg0fB6VlZPAeiMQMVBdGXbow=;
        b=CCwkJ2QArymxLDrJ4vWETeGXd7Ifik4WIvPH/X3S0evJ5Sl0Yw9Gex2KKu3UpiqnMb
         3SYUR/GW3S6p+ifz6UWh2Tsvhx4uBfNdHo9SSqH4X5H5/wXRLGZ9xNC08cR9pFr6nBUP
         4Pr/CVM4MrA22QdywW94w0OAxNPLNwlfHVYA7rS4mYRAE4NqSKGoO99itgbpEocOfsRS
         wh/Lpq2P2GYKZGgZxIS7xP4LIKEBrzFYrE9OiVSc38vhc9CcxXnT7GynSRhNa5MZX6M0
         UUSj6C02wqOr5XSto7No3CJ6eU5e+saDoCeb/ChaLFXBlSkKpWhMb9Ul84q4G1CwwC4r
         wdQw==
X-Gm-Message-State: AOAM531cuYxcxdyn18P5ZumcFbqqJ9CPKvscK0lvMBVbBz+uJddN4mKd
        l4E9Wo8Ge+sWhmn4tQxheZ8=
X-Google-Smtp-Source: ABdhPJxiJW+alV07z2ZgBwWgEOwq7eZ/ovjowmamACKYedV5NG7CLqKbg1X3l4VSseZEH1cb9VkFBQ==
X-Received: by 2002:a1c:48d:: with SMTP id 135mr1224011wme.147.1609890448405;
        Tue, 05 Jan 2021 15:47:28 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id h29sm883754wrc.68.2021.01.05.15.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 15:47:27 -0800 (PST)
To:     arni@dagur.eu, io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20210105225932.1249603-1-arni@dagur.eu>
 <20210105225932.1249603-3-arni@dagur.eu>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/2] io_uring: Add vmsplice support
Message-ID: <d4e5fddf-4745-2fa9-a74a-55a0eae28e1b@gmail.com>
Date:   Tue, 5 Jan 2021 23:43:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210105225932.1249603-3-arni@dagur.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/01/2021 23:00, arni@dagur.eu wrote:
> From: Árni Dagur <arni@dagur.eu>
> 
> * The `sqe->splice_flags` field is used to hold flags.
> * We return -EAGAIN if force_nonblock is set.
> 
> Signed-off-by: Árni Dagur <arni@dagur.eu>
> ---
>  fs/io_uring.c                 | 76 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 77 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ca46f314640b..a99a89798386 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -531,6 +531,13 @@ struct io_splice {
>  	unsigned int			flags;
>  };
>  
> +struct io_vmsplice {
> +	struct file			*file;
> +	u64				addr;
> +	u64				len;
> +	unsigned int			flags;
> +};
> +
>  struct io_provide_buf {
>  	struct file			*file;
>  	__u64				addr;
> @@ -692,6 +699,7 @@ struct io_kiocb {
>  		struct io_madvise	madvise;
>  		struct io_epoll		epoll;
>  		struct io_splice	splice;
> +		struct io_vmsplice	vmsplice;
>  		struct io_provide_buf	pbuf;
>  		struct io_statx		statx;
>  		struct io_shutdown	shutdown;
> @@ -967,6 +975,12 @@ static const struct io_op_def io_op_defs[] = {
>  		.unbound_nonreg_file	= 1,
>  		.work_flags		= IO_WQ_WORK_BLKCG,
>  	},
> +	[IORING_OP_VMSPLICE] = {
> +		.needs_file = 1,
> +		.hash_reg_file		= 1,
> +		.unbound_nonreg_file	= 1,
> +		.work_flags		= IO_WQ_WORK_MM,
> +	},
>  	[IORING_OP_PROVIDE_BUFFERS] = {},
>  	[IORING_OP_REMOVE_BUFFERS] = {},
>  	[IORING_OP_TEE] = {
> @@ -3884,6 +3898,63 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
>  	return 0;
>  }
>  
> +static int io_vmsplice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_vmsplice *sp = &req->vmsplice;
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +	if (unlikely(READ_ONCE(sqe->off)))
> +		return -EINVAL;
> +
> +	sp->addr = READ_ONCE(sqe->addr);
> +	sp->len = READ_ONCE(sqe->len);
> +	sp->flags = READ_ONCE(sqe->splice_flags);
> +
> +	if (sp->flags & ~SPLICE_F_ALL)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int io_vmsplice(struct io_kiocb *req, bool force_nonblock)
> +{
> +	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
> +	struct io_vmsplice *sp = &req->vmsplice;
> +	void __user *buf = u64_to_user_ptr(sp->addr);

const struct iovec __user *uiov

> +	struct iov_iter __iter, *iter = &__iter;

read/write either use ((struct io_async_rw *)req->async_data)->iter
or to avoid allocation use an on-stack iter. This only has that
on-stack __iter, so why do you need *iter?

> +	struct file *file = sp->file;
> +	ssize_t io_size;
> +	int type, ret;
> +
> +	if (force_nonblock)
> +		return -EAGAIN;
> +
> +	if (file->f_mode & FMODE_WRITE)
> +		type = WRITE;
> +	else if (file->f_mode & FMODE_READ)
> +		type = READ;
> +	else {
> +		ret = -EBADF;
> +		goto err;

it jumps to kfree(iovec), where iovec=inline_vecs

> +	}
> +
> +	ret = __import_iovec(type, buf, sp->len, UIO_FASTIOV, &iovec, iter,
> +				req->ctx->compat);

This may happen asynchronously long after io_uring_enter(submit)
returned, e.g. if a user keeps uiov on-stack it will fail or read
garbage.

So, it's either to make it a part of ABI -- users must not delete
uiov until the request completion, or copy it while not-yet-async.
For consistency with read/write I'd prefer the second.

> +	if (ret < 0)
> +		goto err;
> +	io_size = iov_iter_count(iter);
> +
> +	ret = do_vmsplice(file, iter, sp->flags);
> +	if (ret != io_size) {
> +err:
> +		req_set_fail_links(req);
> +	}
> +	io_req_complete(req, ret);
> +	kfree(iovec);
> +	return 0;
> +}
> +
>  /*
>   * IORING_OP_NOP just posts a completion event, nothing else.
>   */
> @@ -6009,6 +6080,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_epoll_ctl_prep(req, sqe);
>  	case IORING_OP_SPLICE:
>  		return io_splice_prep(req, sqe);
> +	case IORING_OP_VMSPLICE:
> +		return io_vmsplice_prep(req, sqe);
>  	case IORING_OP_PROVIDE_BUFFERS:
>  		return io_provide_buffers_prep(req, sqe);
>  	case IORING_OP_REMOVE_BUFFERS:
> @@ -6262,6 +6335,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
>  	case IORING_OP_SPLICE:
>  		ret = io_splice(req, force_nonblock);
>  		break;
> +	case IORING_OP_VMSPLICE:
> +		ret = io_vmsplice(req, force_nonblock);
> +		break;
>  	case IORING_OP_PROVIDE_BUFFERS:
>  		ret = io_provide_buffers(req, force_nonblock, cs);
>  		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index d31a2a1e8ef9..6bc79f9bb123 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -137,6 +137,7 @@ enum {
>  	IORING_OP_SHUTDOWN,
>  	IORING_OP_RENAMEAT,
>  	IORING_OP_UNLINKAT,
> +	IORING_OP_VMSPLICE,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
