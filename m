Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48935400D5B
	for <lists+io-uring@lfdr.de>; Sun,  5 Sep 2021 00:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhIDWlS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Sep 2021 18:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbhIDWlR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Sep 2021 18:41:17 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8BDC061575
        for <io-uring@vger.kernel.org>; Sat,  4 Sep 2021 15:40:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b10so3974473wru.0
        for <io-uring@vger.kernel.org>; Sat, 04 Sep 2021 15:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H0cdnyDvgcbniLDDGkPVTtIjL9YZLzFI3MxcKuLxik4=;
        b=m52MGqssWuyy6ERAQfUoDVQTqawntgG9Gn6zeVNPxR4+hxU4EBASb0FISolo73tNWl
         DAaYp2E9LU7ISdocoBYDQQnKd/MEsRBDcUx6RebPhNnS1pWUtiuTy380Qy7MwHwwQJye
         m8KaQNn9rA2biO5F617UDz1+WEjSVxGQExiJA8nFwJGxAu5GF+vB8QfX5r1FvurdUnBL
         FqlCtQ8k4VD64Grz8waEnxPzaxhCd1bOh/5m1rJyUd+qEH+uWy4Grlpud9ceHd26Jr1b
         d6yhmiGJoATo6Xd9s6nIJmFy8J6ProkJPKJrYHTh9pDvrMEf2zmFKBPJbeLtXAw+Dkke
         HKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H0cdnyDvgcbniLDDGkPVTtIjL9YZLzFI3MxcKuLxik4=;
        b=UvP1oP54J3eD1J1j1DQ6+kf0erzxxeRdEWVV4Ty5Bq0JLd1NVbBXiyU5nRqwI3HFYp
         lLH0gKXxWnilBiMB/ZcArMDRnoxvxi1qEEktd8d+jo1nkAFQHbfEzuaHiBCCQp0VKz56
         5YoyjzLmyzjt38biw+L4P3ecrhE2DIuA6qZxSxHsyBj6IDczjj+NNRyBb0ZuXHET9Iw5
         cJa4E0xYHOJ8O+riVc8qRX4linSvaaTw6o3+UjvDGtkmv0NJqu6tXvmdV71/9xejmZbf
         tyLo7wLLYhaYB/Hu5lcrfJYXnz+hyuaJO79tgd93iZ3uS0NRkBmwe9EfRZwhd6aoMp9n
         NraQ==
X-Gm-Message-State: AOAM532oH2t37OWWKxhGQUaO9AT1cTRYuuLcVfT3I10NAO28pVdnT2UQ
        RQ39EQHlf25O2etEPZ/kXLl2xpeulz8=
X-Google-Smtp-Source: ABdhPJwnkGfnHem98/xZQubCZOfwWIPHViftF0XHAM67s1FGRkmRkWKxJA5c+1Ok6KmJejd/pFuYqg==
X-Received: by 2002:adf:9e01:: with SMTP id u1mr5823647wre.420.1630795213889;
        Sat, 04 Sep 2021 15:40:13 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id a77sm3126680wmd.31.2021.09.04.15.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 15:40:13 -0700 (PDT)
Subject: Re: [PATCH 5/6] io_uring: implement multishot mode for accept
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-6-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3070a597-3326-5cac-253e-e2b58eebd3a2@gmail.com>
Date:   Sat, 4 Sep 2021 23:39:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903110049.132958-6-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 12:00 PM, Hao Xu wrote:
> Refactor io_accept() to support multishot mode.

Multishot with the fixed/direct mode sounds weird (considering that
the slot index is specified by userspace), let's forbid them.

io_accept_prep() {
	if (accept->file_slot && (flags & MULTISHOT))
		return -EINVAL;
	...
}

> theoretical analysis:
>   1) when connections come in fast
>     - singleshot:
>               add accept sqe(userpsace) --> accept inline
>                               ^                 |
>                               |-----------------|
>     - multishot:
>              add accept sqe(userspace) --> accept inline
>                                               ^     |
>                                               |--*--|
> 
>     we do accept repeatedly in * place until get EAGAIN
> 
>   2) when connections come in at a low pressure
>     similar thing like 1), we reduce a lot of userspace-kernel context
>     switch and useless vfs_poll()
> 
> tests:
> Did some tests, which goes in this way:
> 
>   server    client(multiple)
>   accept    connect
>   read      write
>   write     read
>   close     close
> 
> Basically, raise up a number of clients(on same machine with server) to
> connect to the server, and then write some data to it, the server will
> write those data back to the client after it receives them, and then
> close the connection after write return. Then the client will read the
> data and then close the connection. Here I test 10000 clients connect
> one server, data size 128 bytes. And each client has a go routine for
> it, so they come to the server in short time.
> test 20 times before/after this patchset, time spent:(unit cycle, which
> is the return value of clock())
> before:
>   1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
>   +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
>   +1934226+1914385)/20.0 = 1927633.75
> after:
>   1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
>   +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
>   +1871324+1940803)/20.0 = 1894750.45
> 
> (1927633.75 - 1894750.45) / 1927633.75 = 1.65%
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> not sure if we should cancel it when io_cqring_fill_event() reurn false
> 
>  fs/io_uring.c | 34 +++++++++++++++++++++++++++++-----
>  1 file changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index dae7044e0c24..eb81d37dce78 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4885,16 +4885,18 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  
>  static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  {
> +	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_accept *accept = &req->accept;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>  	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
>  	bool fixed = !!accept->file_slot;
>  	struct file *file;
> -	int ret, fd;
> +	int ret, ret2 = 0, fd;
>  
>  	if (req->file->f_flags & O_NONBLOCK)
>  		req->flags |= REQ_F_NOWAIT;
>  
> +retry:
>  	if (!fixed) {
>  		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
>  		if (unlikely(fd < 0))
> @@ -4906,20 +4908,42 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  		if (!fixed)
>  			put_unused_fd(fd);
>  		ret = PTR_ERR(file);
> -		if (ret == -EAGAIN && force_nonblock)
> -			return -EAGAIN;
> +		if (ret == -EAGAIN && force_nonblock) {
> +			if ((req->flags & (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)) ==
> +			    (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED))
> +				ret = 0;
> +			return ret;
> +		}
>  		if (ret == -ERESTARTSYS)
>  			ret = -EINTR;
>  		req_set_fail(req);
>  	} else if (!fixed) {
>  		fd_install(fd, file);
>  		ret = fd;
> +		/*
> +		 * if it's in multishot mode, let's return -EAGAIN to make it go
> +		 * into fast poll path
> +		 */
> +		if ((req->flags & REQ_F_APOLL_MULTISHOT) && force_nonblock &&
> +		   !(req->flags & REQ_F_POLLED))
> +			ret2 = -EAGAIN;
>  	} else {
>  		ret = io_install_fixed_file(req, file, issue_flags,
>  					    accept->file_slot - 1);
>  	}
> -	__io_req_complete(req, issue_flags, ret, 0);
> -	return 0;
> +
> +	if (req->flags & REQ_F_APOLL_MULTISHOT) {
> +		spin_lock(&ctx->completion_lock);
> +		if (io_cqring_fill_event(ctx, req->user_data, ret, 0)) {
> +			io_commit_cqring(ctx);
> +			ctx->cq_extra++;
> +		}
> +		spin_unlock(&ctx->completion_lock);
> +		goto retry;
> +	} else {
> +		__io_req_complete(req, issue_flags, ret, 0);
> +	}
> +	return ret2;
>  }
>  
>  static int io_connect_prep_async(struct io_kiocb *req)
> 

-- 
Pavel Begunkov
