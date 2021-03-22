Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F89834366E
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 02:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCVBwF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 21:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVBvx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 21:51:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7154CC061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:51:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o16so15006905wrn.0
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bjDDHru6Fpa+lHi3gD4gxpSrzlDiuCH/ikFBsWARmj4=;
        b=St6NTK8tOGN3MAl/NdDiscNfkjf36NeNwE9ag11p4Cqe/vjLJP8LRyhQUVgMXk2/4z
         mFjq9+/z4Cf+WS9v8FjWaBxz+DLWaugWHMPSSsYZQMGeFbNul1OMudHm05Bj5fRBMyrx
         eq21x+976IBtzGjucgOeRWzx1usK9dETpoJDFrTy84NhNJzGPZ/ViQ+x6QNFiWwV+Rpr
         1tpMziHQjY6TElXjkIjFoEoHIFd4h6d2XDuLs636dnXoIp0zWa8pkSTF6anRUkoKfqyK
         /pMcRriIDg37qWrxa2PgglkXiUi/1d7Nlb6Yx8Zgh8g9ivfGEOho8tkccybNy+AOL2fO
         UR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bjDDHru6Fpa+lHi3gD4gxpSrzlDiuCH/ikFBsWARmj4=;
        b=QReFeavFyflzXpdgC6ojWzbm9fPhpfPCfW9uaD21x43kvzpQtka1RhfPIaXyTpejxm
         GxVhfo+oLP7jwqQEkngRYjrFEXu36yUaih0/mXO1JVE+3lwJE6oyZIIyoYNMPAmP7dND
         uovxVAImDLdIpk4dU+HISVfgVYRPZuXzzyqZptbgJrB2gi4dRhCjr6lBGtdNVyg7jFYN
         LYuPbk8eTtN/FK4O4CsYatYieQv+QX+M3xkj/ZvgbyVNC6EpDr3o5prBYGSJj3NxTbV7
         fQuGb8rD+cjnnz6JYZvIllJ/aiTaUIbQN//MnaaCZBXjbvaCF9rJLGoO8I7/bLq1nOBT
         LIIA==
X-Gm-Message-State: AOAM533Vd37ZMrj25UXoGSYJ3L7VOAuMTtY9R04mOnR0kEUpmJmnGfHl
        LrShwhgxG0w5V0WlT+G6cqU=
X-Google-Smtp-Source: ABdhPJzKHw5QQ62UGIGUqyzz24Ptwptp+TgQbY/g0I0Venh4jmBARhykVJGLld8f5sVM12G7NUWxMw==
X-Received: by 2002:a5d:550b:: with SMTP id b11mr15804925wrv.313.1616377912218;
        Sun, 21 Mar 2021 18:51:52 -0700 (PDT)
Received: from [192.168.8.179] ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id z7sm18871397wrt.70.2021.03.21.18.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 18:51:51 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix provide_buffers sign extension
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>
References: <562376a39509e260d8532186a06226e56eb1f594.1616149233.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <fb6df1ed-0eba-3a83-7d22-4ae9b1ffcaac@gmail.com>
Date:   Mon, 22 Mar 2021 01:47:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <562376a39509e260d8532186a06226e56eb1f594.1616149233.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/03/2021 10:21, Pavel Begunkov wrote:
> io_provide_buffers_prep()'s "p->len * p->nbufs" to sign extension
> problems. Not a huge problem as it's only used for access_ok() and
> increases the checked length, but better to keep typing right.

Forgot to mention, I suggest it for 5.12, simple enough and
may be a problem for userspace in some rare cases.


> Reported-by: Colin Ian King <colin.king@canonical.com>
> Fixes: efe68c1ca8f49 ("io_uring: validate the full range of provided buffers for access")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c2489b463eb9..4f1c98502a09 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3978,6 +3978,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
>  static int io_provide_buffers_prep(struct io_kiocb *req,
>  				   const struct io_uring_sqe *sqe)
>  {
> +	unsigned long size;
>  	struct io_provide_buf *p = &req->pbuf;
>  	u64 tmp;
>  
> @@ -3991,7 +3992,8 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
>  	p->addr = READ_ONCE(sqe->addr);
>  	p->len = READ_ONCE(sqe->len);
>  
> -	if (!access_ok(u64_to_user_ptr(p->addr), (p->len * p->nbufs)))
> +	size = (unsigned long)p->len * p->nbufs;
> +	if (!access_ok(u64_to_user_ptr(p->addr), size))
>  		return -EFAULT;
>  
>  	p->bgid = READ_ONCE(sqe->buf_group);
> 

-- 
Pavel Begunkov
