Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75D3135B50
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 15:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgAIO0U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 09:26:20 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45706 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgAIO0T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 09:26:19 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so5312064lfa.12
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 06:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/MPfMCaHvfnf9UVgDpmcSBrrl6PbjFTkOKHm8zP+lwo=;
        b=bK5dn2hmSUK6niSvrb/5li2cGbf73aaUZPyTj4rmHFgAMFvkVoG3IBZbw/rfxP3I+s
         LPJUrMka3CgOyubTGcWNpJnQnUJkphkrwdDVuVSln2T4k/GVhJJeHRL1a/ZHPKO/Vgf4
         /hFkTP2789EqUb8WlYWZ48obLXzDTrjJKY2gC3RDy9XPwO8pLZL7vcsbK6ChwSFwBi9v
         ZKBqB/Kgvl4upR/pgUbxxu0y7aldwzCczybtGyCN4w1qk7yJw0nPGr6Hgj1vk+bwRg5x
         0GZLWQwQWxiSA7gv3AfwOq/UID0spwPdV+5/I5Yr0u9afOohixjQhPWa2yrhSRko1iZd
         121A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/MPfMCaHvfnf9UVgDpmcSBrrl6PbjFTkOKHm8zP+lwo=;
        b=aJ48+F2aHtubCSgNFgMIyahgFAefOZ7/5h+42JcvQfVOuxQGAlfrLiOO4BZGWjfais
         H+RTQNy539fXKVR0yYRnwAdHbW9k0ISyFZy9h4O7/Z/cQi0qQzRxSXewkIpjPMVHp/0U
         gNdGQuE3fBA0POIlFp8UqobkVGhcvckUuHZbllIBnVJXH3kx06yHV6FOnbcoclpPdbQ+
         uhGpwxPsJ7cD8+nuxtCj38cNPhxIGXSfhFE9QqHkNtcisI6bpxIn7bjplh0qqGz4LjWl
         vtKntKks9BwaPYZSCRPN/cnC5zZSRbpigr1Wop9An54D+bwcNe3vUuFk6IOCF1442P6c
         6a5w==
X-Gm-Message-State: APjAAAXNi0q9tikNQyP4RHcsQ9YajEWAnQnKgg4HpnlGWLl94rLbpT5X
        WJg5yrUuKCcP1iNV7HVh8QSg0SElRX0=
X-Google-Smtp-Source: APXvYqyaupDrsfyvqVq7VB+15SPryjwNYWzHiBt7MqXOi9sQLLN9JNNcsiFbl5YT6I7OQHSQ1o+4ag==
X-Received: by 2002:a19:4901:: with SMTP id w1mr6353864lfa.168.1578579977447;
        Thu, 09 Jan 2020 06:26:17 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id p15sm3110657lfo.88.2020.01.09.06.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 06:26:16 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Dmitrii Dolgov <9erthalion6@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
Date:   Thu, 9 Jan 2020 17:26:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200109131750.30468-1-9erthalion6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/2020 4:17 PM, Dmitrii Dolgov wrote:
> With combination of --fixedbufs and an old version of fio I've managed
> to get a strange situation, when doing io_iopoll_complete NULL pointer
> dereference on file_data was caused in io_free_req_many. Interesting
> enough, the very same configuration doesn't fail on a newest version of
> fio (the old one is fc220349e4514, the new one is 2198a6b5a9f4), but I
> guess it still makes sense to have this check if it's possible to craft
> such request to io_uring.

I didn't looked up why it could become NULL in the first place, but the
problem is probably deeper.

1. I don't see why it puts @rb->to_free @file_data->refs, even though
there could be non-fixed reqs. It needs to count REQ_F_FIXED_FILE reqs
and put only as much.

2. Jens, there is another line bothering me, could you take a look?

io_free_req_many()
{
...
	if (req->flags & REQ_F_INFLIGHT) ...;
	else
		rb->reqs[i] = NULL;
...
}

It zeroes rb->reqs[i], calls __io_req_aux_free(), but did not free
memory for the request itself. Is it as intended?

> 
> More details about configuration:
> 
> [global]
> filename=/dev/vda
> rw=randread
> bs=256k
> direct=1
> time_based=1
> randrepeat=1
> gtod_reduce=1
> 
> [fiotest]
> 
> fio test.fio \
>     --readonly \
>     --ioengine=io_uring \
>     --iodepth 1024 \
>     --fixedbufs \
>     --hipri \
>     --numjobs=1 \
>     --runtime=10
> 
> Signed-off-by: Dmitrii Dolgov <9erthalion6@gmail.com>
> ---
>  fs/io_uring.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> I'm not entirely sure if my analysis is correct, but since this change
> fixes the issue for me, I've decided to post it.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c770c2c0eb52..c5e69dfc0221 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1232,7 +1232,8 @@ static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>  do_free:
>  	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
>  	percpu_ref_put_many(&ctx->refs, rb->to_free);
> -	percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
> +	if (ctx->file_data)
> +		percpu_ref_put_many(&ctx->file_data->refs, rb->to_free);
>  	rb->to_free = rb->need_iter = 0;
>  }
>  
> 

-- 
Pavel Begunkov
