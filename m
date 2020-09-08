Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAE42621A0
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 23:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgIHVAq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 17:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgIHVAl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 17:00:41 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F54CC061573
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 14:00:40 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l63so464031edl.9
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 14:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z0OVPsRjFh8JdFuKU/q47TyvttZ8Bv68EKjhBB29gfQ=;
        b=FmJfaPjUKnUH+fP8b8VgksoNYRnFJ1HiCQ+0D2bfnmbSUCv4QoYqWEcRNPKvD15/Lu
         Nt0Kk8N7cvrQDOJvL6OFNpc2YqKbYIeyCtLizbz8FMiL0xaCgumPp0YNQJ3Yc5w0FikB
         va+x3hmXs7Dgl98HuqzPGteQ5ibxqaUw2CYSOfoOLKWDZiVHo7nHWak+kYcjiOx17G2L
         CWtV9wQgIVd38H6gMNOpUI7CSc8G1lbyrgB5fEdcA30Kt2mkafAPJ+7vTkmdARh5o4yo
         msZBu2/01GiUdwdRdGoVyvvJgMo2eTBTZhJU8Q2qJVw3/MJAR9LaiwnUwAhPaPYaNUYd
         yKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z0OVPsRjFh8JdFuKU/q47TyvttZ8Bv68EKjhBB29gfQ=;
        b=tAJSVBY2hAHg6UDtO0hxdUB9r1lcq+fJieobe3u+HzfeqGoeguaoU+HvsjhJp3vMuH
         YPOwKP7WN1gYcPc6ImsaZRozA5ObgNvzXN3mGUaVoVGAy0j2h9MTsVFI1VYJU+iOdtFq
         uQPxI42yoiYJGQr5LcfEIC1GWMelXuqk6s/ysPYqsj9+SoFU4tdn7UcwYpppA7wHYrUt
         gZuJ2Dw1sIYpSKtAtH/kbTBPQRcL/JW66eBi+MPyYebVZt2f99aoSKWE8k6GLcHLZN8a
         hAJiEi7G2EDAorjIhHJj/D0l8ZEWMp7LX7NvhoCEie2dCHpCa4iBJ2PVnVLdfVxNW4rZ
         bFTw==
X-Gm-Message-State: AOAM531T9Whsx0DmBBEViTb1V+1Vw3XI+MD4lyQ9/KV8rTCY7gC79uCU
        NY5JKCq5SiJuuMaBwU8ZcJUCaHgXehY=
X-Google-Smtp-Source: ABdhPJyyQXmaP3xzzEz9GSyAA3AUpErSl/PtZd1K+oKqgGiqNe40NF9L8sBwgF5eBBHTNJULHn711A==
X-Received: by 2002:a05:6402:2d9:: with SMTP id b25mr924078edx.131.1599598838398;
        Tue, 08 Sep 2020 14:00:38 -0700 (PDT)
Received: from [192.168.43.239] ([5.100.193.184])
        by smtp.gmail.com with ESMTPSA id w8sm240172ejo.117.2020.09.08.14.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 14:00:37 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
Message-ID: <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
Date:   Tue, 8 Sep 2020 23:58:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/09/2020 20:48, Jens Axboe wrote:
> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
> the ring fd/file appropriately so we can defer grab them.

IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
that isn't the case with SQPOLL threads. Am I mistaken?

And it looks strange that the following snippet will effectively disable
such requests.

fd = dup(ring_fd)
close(ring_fd)
ring_fd = fd

> 
> Reported-by: Josef Grieb <josef.grieb@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 80913973337a..e21a7a9c6a59 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6757,7 +6757,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
>  
>  	mutex_lock(&ctx->uring_lock);
>  	if (likely(!percpu_ref_is_dying(&ctx->refs)))
> -		ret = io_submit_sqes(ctx, to_submit, NULL, -1);
> +		ret = io_submit_sqes(ctx, to_submit, ctx->ring_file, ctx->ring_fd);
>  	mutex_unlock(&ctx->uring_lock);
>  
>  	if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
> @@ -8966,6 +8966,11 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		goto err;
>  	}
>  
> +	if (p->flags & IORING_SETUP_SQPOLL) {
> +		ctx->ring_fd = fd;
> +		ctx->ring_file = file;
> +	}
> +
>  	ret = io_sq_offload_create(ctx, p);
>  	if (ret)
>  		goto err;
> 

-- 
Pavel Begunkov
