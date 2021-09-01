Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FE83FD730
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 11:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbhIAJsr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 05:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhIAJsq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 05:48:46 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D76C061575;
        Wed,  1 Sep 2021 02:47:50 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so3417048wmh.1;
        Wed, 01 Sep 2021 02:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aMg3NODH8Ey3eCpI+t2A6v0su9qdk4Ke/uuuhl535ws=;
        b=OrjvQJy00TNBAB3Ai2WQzeBw7QDdfslCsOrFIzWbyyX/zH8LJzYNFTNdDwd56x+hQj
         AydFWj50UXXPBVEXMdqtrZ+JRDN1lbbd6EC5NeJ1d//auqIvRiPljYD6r7Teg2o1YfwA
         VidXwRernBLawiBDsAWSxy4w8qroxDmU4i8hZy03Urp0SK3H6eqkBho4/tLoRXomXsAT
         Uw9Rd5fW2uofWrVmDbRkwgcWoMcFQsvF8473Du1u86GcCLdYfx/9ocnKaitxZMxS+jvx
         BoVoHUs/8NMT8jtMyK1ngmKXHDyJFHFLHOuzfpXAW23PgCCnW08BVs1jaRDpa11L9rmO
         oiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aMg3NODH8Ey3eCpI+t2A6v0su9qdk4Ke/uuuhl535ws=;
        b=LSaM5JnnHJ8XH7K+K2l0PAiOFP4oHoGQuoU6xYU/OwISPzqbC3eR9HO2FkZXhHKGjm
         ejT4LJkZAhHMso5aARpeiSTohI1xSOaJwXLxl6kdaEYj4Zzv182y7wggVVn1LezZY2Fw
         wryR3bmOVgLqNFrbizSzZ0H5jJPBNWorsxk2I82ovLms6SixBPbA4z++krmYnfgSfd/2
         sjpdhuTd9kulHeLUz1RbUjsvR776u77dbOGStLi4qsXjrEhK8QqBsiJtvGnaFF9fqlyb
         On5NqYtviV5byYLKsjFqNIYSiD8dRGbA4Ey9DWk1CNd+XmtIYE/m6oJyvETFY9Q0gJBN
         yEZw==
X-Gm-Message-State: AOAM531Feq23dKqdaYjGHMQXGFLdeRHONOZSwKLx57p6/mhvVVjqUp0G
        xCcX+tDjOBg5s3G/VWMfChHi7HLvgvA=
X-Google-Smtp-Source: ABdhPJycsBV7lugiVztxDKyEIVMLSWx1ESn1pMe8wIzVuPyGIArAIZkJW0HZ9AJNMpyx4QfgMubvUA==
X-Received: by 2002:a05:600c:1457:: with SMTP id h23mr8701530wmi.143.1630489668414;
        Wed, 01 Sep 2021 02:47:48 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id x21sm4883743wmi.15.2021.09.01.02.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 02:47:48 -0700 (PDT)
Subject: Re: [RFC PATCH] io_uring: stop issue failed request to fix panic
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <b04adedd-a78a-634f-f28b-5840d5ec01df@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b2bd9fd0-736d-668f-7c32-3dda6f862758@gmail.com>
Date:   Wed, 1 Sep 2021 10:47:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b04adedd-a78a-634f-f28b-5840d5ec01df@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/21 10:39 AM, 王贇 wrote:
> We observed panic:
>   BUG: kernel NULL pointer dereference, address:0000000000000028
>   [skip]
>   Oops: 0000 [#1] SMP PTI
>   CPU: 1 PID: 737 Comm: a.out Not tainted 5.14.0+ #58
>   Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>   RIP: 0010:vfs_fadvise+0x1e/0x80
>   [skip]
>   Call Trace:
>    ? tctx_task_work+0x111/0x2a0
>    io_issue_sqe+0x524/0x1b90

Most likely it was fixed yesterday. Can you try?
https://git.kernel.dk/cgit/linux-block/log/?h=for-5.15/io_uring

Or these two patches in particular

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/io_uring&id=c6d3d9cbd659de8f2176b4e4721149c88ac096d4
https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/io_uring&id=b8ce1b9d25ccf81e1bbabd45b963ed98b2222df8

> This is caused by io_wq_submit_work() calling io_issue_sqe()
> on a failed fadvise request, and the io_init_req() return error
> before initialize the file for it, lead into the panic when
> vfs_fadvise() try to access 'req->file'.
> 
> This patch add the missing check & handle for failed request
> before calling io_issue_sqe().
> 
> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6f35b12..bfec7bf 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2214,7 +2214,8 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
> 
>  	io_tw_lock(ctx, locked);
>  	/* req->task == current here, checking PF_EXITING is safe */
> -	if (likely(!(req->task->flags & PF_EXITING)))
> +	if (likely(!(req->task->flags & PF_EXITING) &&
> +		   !(req->flags & REQ_F_FAIL)))
>  		__io_queue_sqe(req);
>  	else
>  		io_req_complete_failed(req, -EFAULT);
> @@ -6704,7 +6705,10 @@ static void io_wq_submit_work(struct io_wq_work *work)
> 
>  	if (!ret) {
>  		do {
> -			ret = io_issue_sqe(req, 0);
> +			if (likely(!(req->flags & REQ_F_FAIL)))
> +				ret = io_issue_sqe(req, 0);
> +			else
> +				io_req_complete_failed(req, -EFAULT);
>  			/*
>  			 * We can get EAGAIN for polled IO even though we're
>  			 * forcing a sync submission from here, since we can't
> 

-- 
Pavel Begunkov
