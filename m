Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE851123AB4
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 00:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfLQXVf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 18:21:35 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41153 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQXVe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 18:21:34 -0500
Received: by mail-pl1-f195.google.com with SMTP id bd4so76734plb.8
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 15:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GmljEGBgtpmc+8iroW//rwgukhMJ+MwtBQPSUaRaS9c=;
        b=tF3zPMN+/xu3h+Z5rc57rMs7F8Uo4B619gxCsAZmQCjTeNfkbAUoXCz+Qp4/P8uWiP
         PGjWV//gldA44MkBn5jDzom3+5uOclW8sLvhquOPXeL2djxus01tP7mr2Nnnw5+Zf04m
         zj+3tAeqVxoFHz8r2hCa/QPdEGB4Uq8p9OxcTvmS9jG03J7j+pedvkVvoa9q/h0BOLKL
         G70TlY/vlv9vI+5WlDES6AZ+NZKdkSJBYy15L/I5b2sgLr5ueEQYyb5PYonrFhuHFNl1
         9i919KS4E9Gu26/YF4l81LF5k13QRgqd47QiZip7t6ILLl6tDQ7mBpvabb1ZGQgvD5Wk
         80nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GmljEGBgtpmc+8iroW//rwgukhMJ+MwtBQPSUaRaS9c=;
        b=ToFmLhP62nKW6k8NpEjcsxXIZyTefT7R9KMhFuxD7r3iVpcUs5h7rnf9U6d5xb7Zp9
         buSMsq1ij0K0MdL63f+m97DNWfRlQX/EBgC5xbTgYuaEA3HkpAWsnlxfu4dQDZQgnBzV
         /iQmq4j/xsN7IzmxUsKyGBuJMun4IoaQ5sd+fYafDtGRJ9J7R0hXCo4tXWQtOqhk1XWK
         TjhIIJjkdiExWWW2/1BU/m2C8hx4HwoIOYrnfF0w+DvlNi6fvVofz37jNx8+M2txnOEh
         IOq0xOlDOByZFW2wOGHhaQ/IyINMlTJqLhFn9x7uyx5ba6m9yFvNIUvOlcZlnRXW8uTN
         RXGg==
X-Gm-Message-State: APjAAAXCd81Qb6q6jyErRWbJRGp4cHJvBh5MJoSNalB35NzSIl/FAFBY
        +PqadXiZlBz+ZtyL3Sjy8r0SCg==
X-Google-Smtp-Source: APXvYqxGsyOATNrzJ3PctjFgAJdiNKMaZyiM508Mj9ocTn2uiWx9F9tQ95+TYTddhHmvBSfucqwUfw==
X-Received: by 2002:a17:90a:1ae9:: with SMTP id p96mr26433pjp.8.1576624894229;
        Tue, 17 Dec 2019 15:21:34 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 12sm93553pfn.177.2019.12.17.15.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 15:21:33 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: batch getting pcpu references
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576621553.git.asml.silence@gmail.com>
 <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e54d77e4-9357-cb9e-9d06-d96b24f49a44@kernel.dk>
Date:   Tue, 17 Dec 2019 16:21:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b72c5ec7f6d9a9881948de6cb88d30cc5e0354e9.1576621553.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 3:28 PM, Pavel Begunkov wrote:
> percpu_ref_tryget() has its own overhead. Instead getting a reference
> for each request, grab a bunch once per io_submit_sqes().
> 
> basic benchmark with submit and wait 128 non-linked nops showed ~5%
> performance gain. (7044 KIOPS vs 7423)
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> For notice: it could be done without @extra_refs variable,
> but looked too tangled because of gotos.
> 
> 
>  fs/io_uring.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cf4138f0e504..6c85dfc62224 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -845,9 +845,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>  	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
>  	struct io_kiocb *req;
>  
> -	if (!percpu_ref_tryget(&ctx->refs))
> -		return NULL;
> -
>  	if (!state) {
>  		req = kmem_cache_alloc(req_cachep, gfp);
>  		if (unlikely(!req))
> @@ -3929,6 +3926,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  	struct io_submit_state state, *statep = NULL;
>  	struct io_kiocb *link = NULL;
>  	int i, submitted = 0;
> +	unsigned int extra_refs;
>  	bool mm_fault = false;
>  
>  	/* if we have a backlog and couldn't flush it all, return BUSY */
> @@ -3941,6 +3939,10 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  		statep = &state;
>  	}
>  
> +	if (!percpu_ref_tryget_many(&ctx->refs, nr))
> +		return -EAGAIN;
> +	extra_refs = nr;
> +
>  	for (i = 0; i < nr; i++) {
>  		struct io_kiocb *req = io_get_req(ctx, statep);
>  
> @@ -3949,6 +3951,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  				submitted = -EAGAIN;
>  			break;
>  		}
> +		--extra_refs;
>  		if (!io_get_sqring(ctx, req)) {
>  			__io_free_req(req);
>  			break;
> @@ -3976,6 +3979,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  		io_queue_link_head(link);
>  	if (statep)
>  		io_submit_state_end(&state);
> +	if (extra_refs)
> +		percpu_ref_put_many(&ctx->refs, extra_refs);

Might be cleaner to introduce a 'ret' variable, and leave submitted to be just
that, the number submitted. Then you could just do:

if (submitted != nr)
	percpu_ref_put_many(&ctx->refs, nr - submitted);

and not need that weird extra_refs.

-- 
Jens Axboe

