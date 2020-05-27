Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7271E4BB8
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 19:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgE0RTk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 May 2020 13:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730056AbgE0RTk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 May 2020 13:19:40 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4A9C03E97D;
        Wed, 27 May 2020 10:19:39 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d24so20871269eds.11;
        Wed, 27 May 2020 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xWhuN+/xahKyoraWNhVS8LiATomfd60M+/p8tZgUqn8=;
        b=Syl3vMLfXnGtO4GU7ZR26YhQ5zqamBaP+p6ISC1V6yMZU1VgAluJWrHtGJMpvm6Y0b
         5dEab6/BZu5ccJzH03o4DFTPrYYQK5+df4OkbTIdCO7lc6Cf0MSl2pfGtutnFTktqU84
         p1XDGBUOd9UrySwbF0sF7/7cRiY5bVmq63PXcBtefxznSE7NgNwyQmzU67cjpAYxxj4B
         xo8ITJcg6/cuR7vhM8vX9mUnRe2FSEgm525Z70NgMxmarZNMHddkfnBwn6O/etJOjt+F
         mRWPwyrDZDclK/ol9cGa4oKIFtciYqvvi2teP4HK+R2NTkgfqx1mw65USdng9EaGNu1z
         CNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xWhuN+/xahKyoraWNhVS8LiATomfd60M+/p8tZgUqn8=;
        b=qF1gJK6COx5GixGk4CvnC2dOVaoIciScKh/l2MmJjnPQBYX3qqaOp9zrGf3lP4OGZ2
         a/QvxaUVISnN3baTLNFaRS1oDSpwtmTsOY1wjtZ8YaBFf/iL8ErVkHEHmlL7XRKQ+UsL
         DZRZc3UlFjqsFXBuRgyC6qNLWI29tPleUsHO6TiXm3QlC97yZzUSKb/YxLktirZ4rSxg
         YJL2lwZxQg3rs1JEEidqv+gZ5xmEFl3HATlj9Q8lVc0KRS9uv/0xHZph/DZpR3A605Md
         34UsKdr9a6K+0jrte4X81GGXH39vUhZIvq1m7NrYIsP978ZlnMMizr+PVLME52DYppae
         gczA==
X-Gm-Message-State: AOAM533Y2QR9B+AKix91sAam63sfPnfos+wgVm5qFjvTAdBgD31lhXdF
        I/lYFQ+CpIxcNJV9gCowc8pxm/bN
X-Google-Smtp-Source: ABdhPJyH8fCnx6WpkKgzQTBPoo5RO6n/llHkgaB6C3mFoSkPW87Lc3/KLJvTyJp+8cLe0CT3jgYnoQ==
X-Received: by 2002:a50:f086:: with SMTP id v6mr26008479edl.140.1590599978153;
        Wed, 27 May 2020 10:19:38 -0700 (PDT)
Received: from [192.168.43.204] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id r9sm2753460edg.13.2020.05.27.10.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 10:19:37 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix overflowed reqs cancellation
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7acb1a15ee5a79103d71372d6330b19c5397a482.1590574948.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <eb0da4ac-0deb-1b07-62d7-af7701f2b0d2@gmail.com>
Date:   Wed, 27 May 2020 20:18:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7acb1a15ee5a79103d71372d6330b19c5397a482.1590574948.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/05/2020 13:23, Pavel Begunkov wrote:
> Overflowed requests in io_uring_cancel_files() should be shed only of
> inflight and overflowed refs. All other left references are owned by
> someone else. E.g. a submission ref owned by __io_queue_sqe() but not
> yet reached the point of releasing it.
> 
> However, if an overflowed request in io_uring_cancel_files() had extra
> refs, after refcount_sub_and_test(2) check fails, it
> 
> - tries to cancel the req, which is already going away. That's pointless,
> just go for the next lap of inflight waiting.
> 
> - io_put_req() underflowing req->refs of a potentially freed request.e
Probably needs v2, please disregard this for now.

> 
> Fixes: 2ca10259b418 ("io_uring: prune request from overflow list on flush")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index de6547e68626..01851a74bb12 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7483,19 +7483,13 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  			WRITE_ONCE(ctx->rings->cq_overflow,
>  				atomic_inc_return(&ctx->cached_cq_overflow));
>  
> -			/*
> -			 * Put inflight ref and overflow ref. If that's
> -			 * all we had, then we're done with this request.
> -			 */
> -			if (refcount_sub_and_test(2, &cancel_req->refs)) {
> -				io_free_req(cancel_req);
> -				finish_wait(&ctx->inflight_wait, &wait);
> -				continue;
> -			}
> +			/* Put inflight ref and overflow ref. */
> +			io_double_put_req(cancel_req);
> +		} else {
> +			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
> +			io_put_req(cancel_req);
>  		}
>  
> -		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
> -		io_put_req(cancel_req);
>  		schedule();
>  		finish_wait(&ctx->inflight_wait, &wait);
>  	}
> 

-- 
Pavel Begunkov
