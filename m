Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A9A400D5F
	for <lists+io-uring@lfdr.de>; Sun,  5 Sep 2021 00:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhIDWpX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Sep 2021 18:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbhIDWpX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Sep 2021 18:45:23 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4516C061575
        for <io-uring@vger.kernel.org>; Sat,  4 Sep 2021 15:44:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id e26so1829172wmk.2
        for <io-uring@vger.kernel.org>; Sat, 04 Sep 2021 15:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ErQVVgho6ec1hziRt+mqtWV+TRAOAdIgrUVaWlsy9cg=;
        b=UrmZrhFKIONFvflUoPOe0pf6WIvBZP1Prlts/qI8AwaNSsXZmlLMMAxia5rGjkSLew
         wboMauDFsjTPa/H05eqsbKLwatG/8/kr/VjyGTahrBClIQSaJpHnzTTYldZDPDva2ydh
         LEzoXap6gEqIo73xp/stZU4KJH/25EoKFHHfXMVF2sZKFUME3ZcjoRlCqN43V5QneGOG
         OZg6Ax992MHrO69Kn0+AZtzRfRwK3wa16mAxRCMQP74NBv+ZGYGYV6CkhZKXO3njwnsl
         DZOVBH78dHpI529pCiDqSKyh4Vy734KBEBtK518AY4Y+yp11PqREPCpiid59Ta4lDN6d
         2Jag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ErQVVgho6ec1hziRt+mqtWV+TRAOAdIgrUVaWlsy9cg=;
        b=pGDnfb/+q2kdlY6fS4vE+MP4gChGbIqkGksPYRPgaGJFnwjHRUHTR/SfOf2HhEQO16
         LbAkX3uX6ZbXYuemlRhwyWH9xJqpYSfj0Cff7xMaPO8qza8Ijgyw9hfdwaUhNoc1tPld
         agQPiem4eH8GKCdJEtY9Ir8FkBHbrnzlgbbApt38PDPOZBRm+QWlb03Ye2OQ0JKqCyRH
         4OFGEgA3ak9wn+aaQwrJR06RFH2YZi9lumI18xqEjgT/nIVSJqCbkSEqVAkHiT/uY8DO
         cBu5/vCyPDoUCb13gT+TWz1MvqUroYz1vGQZxHVgOuAmQqoOR60c4m38vtab6FMOBPvG
         FOgg==
X-Gm-Message-State: AOAM532Bkk7vw+ALI/ooqClgGixY7Xpg3WIapwuEzKax9K+74NklbeHz
        HXUFLUi8gSPwxschzQtjImQ=
X-Google-Smtp-Source: ABdhPJwDvw6RoaZAbCxykGetdhq/g30sDmu7KhiKoyYibR+c1Proa4+5n6r+ILCJ2h2PjP++1tYhOQ==
X-Received: by 2002:a1c:7ec9:: with SMTP id z192mr4804889wmc.152.1630795459456;
        Sat, 04 Sep 2021 15:44:19 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id m4sm3055686wmc.3.2021.09.04.15.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 15:44:19 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3cdcd28b-4723-32f8-5a0f-59fab8f4af27@gmail.com>
Date:   Sat, 4 Sep 2021 23:43:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903110049.132958-7-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 12:00 PM, Hao Xu wrote:
> Update io_accept_prep() to enable multishot mode for accept operation.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index eb81d37dce78..34612646ae3c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_accept *accept = &req->accept;
> +	bool is_multishot;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	accept->flags = READ_ONCE(sqe->accept_flags);
>  	accept->nofile = rlimit(RLIMIT_NOFILE);
>  
> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
> +		return -EINVAL;

Why REQ_F_FORCE_ASYNC is not allowed? It doesn't sound like there
should be any problem, would just eventually go looping
poll_wait + tw

> +
>  	accept->file_slot = READ_ONCE(sqe->file_index);
>  	if (accept->file_slot && ((req->open.how.flags & O_CLOEXEC) ||
> -				  (accept->flags & SOCK_CLOEXEC)))
> +				  (accept->flags & SOCK_CLOEXEC) || is_multishot))
>  		return -EINVAL;
> -	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
> +	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK | IORING_ACCEPT_MULTISHOT))
>  		return -EINVAL;
>  	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
>  		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
> +	if (is_multishot) {
> +		req->flags |= REQ_F_APOLL_MULTISHOT;
> +		accept->flags &= ~IORING_ACCEPT_MULTISHOT;
> +	}
> +
>  	return 0;
>  }
>  
> 

-- 
Pavel Begunkov
