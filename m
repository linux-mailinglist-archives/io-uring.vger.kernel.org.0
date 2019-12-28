Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211E512BD67
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 12:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfL1LQZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 06:16:25 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37794 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfL1LQZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 06:16:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so15727462wru.4;
        Sat, 28 Dec 2019 03:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cps8bvJoj3nIGDxDxbINAK/1T/Mo3oxy8efE17E3EPU=;
        b=N135beCaijCCWOcve1nYHJuQ+Y2BiVEDypZhcCdY+CD3GQjOzLIQPZHoHG4Bz78S0q
         ZS/8VS1rdSsJISoYdn2JNfeeOgpMjBUPQ53WL5dQgG024Vl1TdnBM8MPXgTOs564rWBU
         bvUsLGqkq2DEM40HdkFXG7CfJAiM55u16KHXzYTqVMYGFUCgWnPLgT9kYWaEL1UjpVms
         tSId4YWyqXFaQKVfJKtdiHE2GeXNBWAvtRUmdAC0YIMDtRe1hncYg/00mQIFga4PjC9t
         TsLVgj8BAwP6gX24yWk4i/MVIxWMwW5D8VGCGvgdZD/2iyNtddLP9fmTU2FBP+PNQHNH
         k24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cps8bvJoj3nIGDxDxbINAK/1T/Mo3oxy8efE17E3EPU=;
        b=RB1usDvABLsWnhmP6C+ZqYS79jI7OErAJpTyrPNHnHexvkvbjlaIQ4MaeDFOybfIlw
         YYnu8QyDN3I6BhIt/Z9gGq0UXfKIdDHGBJ2K56iBkfLGrZm1f80y2e29XjY51buPlGyS
         4eSxMgXSb7UOCjAAWgJer5avqvbm85uzR5EChRERmr/WnIssnaaAwejzAkGwPouetTOf
         Kr5Uu6GOeDmi1ROrnB4c3vpkcP4D4yHcKFvON19L1DCUIpn6ugNeHqKIEf5ViDcEWr0/
         8gwulwoTjjWwd4AimDO8gwLIJXJrRyADSM0CroWVIqN4+DcybH1jUnEciqn3k9KyDsfj
         XkSQ==
X-Gm-Message-State: APjAAAUssAF3t1UXr5U1dNQtcwhM9auBa10+fa7yXzB6O7iW3Bg2BImx
        uO8jMC9qsmSPB13gPqDGbWyoqgt+
X-Google-Smtp-Source: APXvYqyXsbDjswaC5u2/YTs9+ArjU9k3Q5BsHJgo93GHwemveKowyqMfl8n/bqlUH2BEv/ho+bbJmA==
X-Received: by 2002:a05:6000:367:: with SMTP id f7mr54173646wrf.174.1577531782665;
        Sat, 28 Dec 2019 03:16:22 -0800 (PST)
Received: from [192.168.43.144] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id b15sm13930002wmj.13.2019.12.28.03.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2019 03:16:22 -0800 (PST)
Subject: Re: [PATCH v4 2/2] io_uring: batch getting pcpu references
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1577528535.git.asml.silence@gmail.com>
 <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
Date:   Sat, 28 Dec 2019 14:15:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/12/2019 14:13, Pavel Begunkov wrote:
> percpu_ref_tryget() has its own overhead. Instead getting a reference
> for each request, grab a bunch once per io_submit_sqes().
> 
> ~5% throughput boost for a "submit and wait 128 nops" benchmark.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7fc1158bf9a4..404946080e86 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1080,9 +1080,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>  	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
>  	struct io_kiocb *req;
>  
> -	if (!percpu_ref_tryget(&ctx->refs))
> -		return NULL;
> -
>  	if (!state) {
>  		req = kmem_cache_alloc(req_cachep, gfp);
>  		if (unlikely(!req))
> @@ -1141,6 +1138,14 @@ static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
>  	}
>  }
>  
> +static void __io_req_free_empty(struct io_kiocb *req)

If anybody have better naming (or a better approach at all), I'm all ears.


> +{
> +	if (likely(!io_is_fallback_req(req)))
> +		kmem_cache_free(req_cachep, req);
> +	else
> +		clear_bit_unlock(0, (unsigned long *) req->ctx->fallback_req);
> +}
> +
>  static void __io_free_req(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> @@ -1162,11 +1167,9 @@ static void __io_free_req(struct io_kiocb *req)
>  			wake_up(&ctx->inflight_wait);
>  		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
>  	}
> -	percpu_ref_put(&ctx->refs);
> -	if (likely(!io_is_fallback_req(req)))
> -		kmem_cache_free(req_cachep, req);
> -	else
> -		clear_bit_unlock(0, (unsigned long *) ctx->fallback_req);
> +
> +	percpu_ref_put(&req->ctx->refs);
> +	__io_req_free_empty(req);
>  }
>  
>  static bool io_link_cancel_timeout(struct io_kiocb *req)
> @@ -4551,6 +4554,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  			return -EBUSY;
>  	}
>  
> +	if (!percpu_ref_tryget_many(&ctx->refs, nr))
> +		return -EAGAIN;
> +
>  	if (nr > IO_PLUG_THRESHOLD) {
>  		io_submit_state_start(&state, nr);
>  		statep = &state;
> @@ -4567,7 +4573,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  			break;
>  		}
>  		if (!io_get_sqring(ctx, req, &sqe)) {
> -			__io_free_req(req);
> +			__io_req_free_empty(req);
>  			break;
>  		}
>  
> @@ -4598,6 +4604,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
>  			break;
>  	}
>  
> +	if (submitted != nr)
> +		percpu_ref_put_many(&ctx->refs, nr - submitted);
>  	if (link)
>  		io_queue_link_head(link);
>  	if (statep)
> 

-- 
Pavel Begunkov
