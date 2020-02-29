Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB9F1746A6
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 13:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgB2MIN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 07:08:13 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33608 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgB2MIN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 07:08:13 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so6394036lji.0
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 04:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RY8owUi24KN0dwo2xos66LeNhcrZWAT5ki5P2yPKkko=;
        b=I/oP/sco8zWGMtGKp/HuL2v7xLNLe4EzNhUaQ5J+j8+2oiIicguyhFyf0p5j1GpQQL
         VJPZV7FNWyxG8K4Wm4rc0vVZntd86d72ryXYq6eFXUCCvP7lYs+3dm0sOo7ydh9KewJ7
         28QOBSeaebaIkhgsOY/3qrc7Yz/K1KvzoHh0DU3iwoiUXZEbjRIa48E3I4YzK23Yz+Cg
         Q4Cs8N+JrO/HEwbs5hYASABh7wC7s6BnU+jzwr70mxnTAQIGKBfTT+wdbbm8tuBKIUDQ
         /E2kdZmXRkztxq1llJgsr0zqq8VsT7aWxOS47d7/Mx0HvfyKm733WwopJm5ZtMxTcSy8
         Sg7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RY8owUi24KN0dwo2xos66LeNhcrZWAT5ki5P2yPKkko=;
        b=QruTI+OoLJ68jdfQKS+75aE4PPJHsbYCIvKzUyj8HLnpg1Smb1xR4VVNVHSHFFb2fc
         MbYXT7g0yt5YRq61WYg9jKzbAUgpSre0tWQSBijrGUFzE+yrugR4NaMlLTvaniWd03IY
         fXkbSRKa9CweQvmr55DjYuYUowa2q8yz8xiPayKQB8ZwfaDQukJAZT+U6pHlEbbvTShn
         433Uc1RR/5LWcRxb09fsZAHn9Uwyj+X1gk7Hde8q/kzpVHRXVnzab77sGBA76mXv/HZi
         ddTL8bbJ6+YOWS4ppcvZw3OHRfzSdNy0WYrx0OUtzFhULlxlWrJdFZajsLrcwgnL6nLg
         D63w==
X-Gm-Message-State: ANhLgQ1dBbX64520H0MJT08k1lvyC188TNuWNZt0PgHu0wXvIhGPKakJ
        Vp10JHLSGdR4mDb28uokE7g=
X-Google-Smtp-Source: ADFU+vsHDuAEwDZOpxCeF2j5cv577Nv04Bo2WQOzi/ilLfqSE7cCxHmtCpfclNeQoz99olNUPqFhyw==
X-Received: by 2002:a2e:8490:: with SMTP id b16mr5975025ljh.282.1582978091331;
        Sat, 29 Feb 2020 04:08:11 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id g20sm6951124lfb.33.2020.02.29.04.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 04:08:10 -0800 (PST)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <1717ee0c-9700-654e-d75b-6398b1c4c1a9@gmail.com>
Date:   Sat, 29 Feb 2020 15:08:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228203053.25023-3-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/2020 11:30 PM, Jens Axboe wrote:
> IORING_OP_PROVIDE_BUFFERS uses the buffer registration infrastructure to
> support passing in an addr/len that is associated with a buffer ID and
> buffer group ID. The group ID is used to index and lookup the buffers,
> while the buffer ID can be used to notify the application which buffer
> in the group was used. The addr passed in is the starting buffer address,
> and length is each buffer length. A number of buffers to add with can be
> specified, in which case addr is incremented by length for each addition,
> and each buffer increments the buffer ID specified.
> 
> No validation is done of the buffer ID. If the application provides
> buffers within the same group with identical buffer IDs, then it'll have
> a hard time telling which buffer ID was used. The only restriction is
> that the buffer ID can be a max of 16-bits in size, so USHRT_MAX is the
> maximum ID that can be used.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

>  
> +static int io_provide_buffers_prep(struct io_kiocb *req,
> +				   const struct io_uring_sqe *sqe)
> +{

*provide* may be confusing, at least it's for me. It's not immediately
obvious, who gives and who consumes. Not sure what name would be better yet.

> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
> +			      bool force_nonblock)
> +{
> +	struct io_provide_buf *p = &req->pbuf;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct list_head *list;
> +	int ret = 0;
> +
> +	/*
> +	 * "Normal" inline submissions always hold the uring_lock, since we
> +	 * grab it from the system call. Same is true for the SQPOLL offload.
> +	 * The only exception is when we've detached the request and issue it
> +	 * from an async worker thread, grab the lock for that case.
> +	 */
> +	if (!force_nonblock)
> +		mutex_lock(&ctx->uring_lock);
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	list = idr_find(&ctx->io_buffer_idr, p->gid);
> +	if (!list) {
> +		list = kmalloc(sizeof(*list), GFP_KERNEL);

Could be easier to hook struct io_buffer into idr directly, i.e. without
a separate allocated list-head entry.

> +		if (!list) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		INIT_LIST_HEAD(list);
> +		ret = idr_alloc(&ctx->io_buffer_idr, list, p->gid, p->gid + 1,
> +					GFP_KERNEL);
> +		if (ret < 0) {
> +			kfree(list);
> +			goto out;
> +		}
> +	}
> +
> +	ret = io_add_buffers(p, list);
> +	if (!ret) {
> +		/* no buffers added and list empty, remove entry */
> +		if (list_empty(list)) {
> +			idr_remove(&ctx->io_buffer_idr, p->gid);
> +			kfree(list);
> +		}
> +		ret = -ENOMEM;
> +	}
> +out:
> +	if (!force_nonblock)
> +		mutex_unlock(&ctx->uring_lock);
> +	if (ret < 0)
> +		req_set_fail_links(req);
> +	io_cqring_add_event(req, ret);
> +	io_put_req_find_next(req, nxt);
> +	return 0;
> +}

-- 
Pavel Begunkov
