Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DDD665E5D
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 15:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjAKOvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 09:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbjAKOvC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 09:51:02 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9439AB4B1;
        Wed, 11 Jan 2023 06:51:00 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hw16so25563689ejc.10;
        Wed, 11 Jan 2023 06:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Px7xJPrg8tMa+4e2XXTP7S59M4xmhWDAvjIU2YkfE/A=;
        b=OzoXchICbL0AfiBK7BfGK1bGthLDuQixw6//eOfmCnsv3VkPGBkyhMDDjMT4lvTK4S
         Hgob/def8all9+UTFUkV2O9wPC9cTsqjJHVkaAfW2dkBBFMr2KhN8TafRyvk7D6V6OeX
         ouoLYlNN5uO9+hvY0+Wb8cEA7/GRo82tn9Kalw9K4Z2qzxQ3PJeOwmF4zrHSWor3QnAM
         23EjJVN9r3bqw6ZAzHoVcUVkwYY4Kvh7oQb5lpX/VUYhhlF8mt5ju3A8oS0zw+oyTtMc
         azfT4wn1gJ4BhQ0ebpyDm+/Dw2RmWxVn3oYZakpIjMWYc9JYmFtNwRA6K7/mso2WnE7w
         dr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Px7xJPrg8tMa+4e2XXTP7S59M4xmhWDAvjIU2YkfE/A=;
        b=GE0Mk6fpvt7bKseuEVw/OO61Eol3UCOth/Zc6LOYg66nnq7NSBqXFOtwZgs/c1CMSR
         VZ2GrW0AbgG+fO55qnEvB/wuVqYN0eumtUKJKqhfwpJarbU9rYpaYUlMOJSYfRtp/fjL
         hsHUozshSujkHh08dstEEXfyhYcGZYFkf0wNjVvZR4XxFxU4NWj2tinHqZHPH4SQqUp3
         L47HJ1WeNmrGpVE27s0i0gFFB3uUqDOO4cLwdpAJPgD8VF+yjgS9WCitiTqlGnPYGeRq
         oGCUr/NO60+8i7p3tn/zZZ/KmVmOX8HBOFxLdCqHodELO3Tz6QU58NXvqJhpaUpgeoXG
         XPkA==
X-Gm-Message-State: AFqh2kpEm3Mk3CLstO18NU5UDJ5Jh4tfRp9b0V9oGHRIcE2IVDAUtrUE
        hjcZy4axczI7KMQZaYOPfcU=
X-Google-Smtp-Source: AMrXdXuKSqtB+u+7wb+BwfX2WzY9SMiOnIUYBdI/jTsq1RQA4c7hwAmSlDt54z6xJD5BImXhOkk7Zw==
X-Received: by 2002:a17:906:d288:b0:84d:428f:be90 with SMTP id ay8-20020a170906d28800b0084d428fbe90mr10597227ejb.42.1673448659024;
        Wed, 11 Jan 2023 06:50:59 -0800 (PST)
Received: from [192.168.8.100] (188.31.114.68.threembb.co.uk. [188.31.114.68])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090631c100b007aea1dc1840sm6275485ejf.111.2023.01.11.06.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 06:50:58 -0800 (PST)
Message-ID: <14bdf892-1fd8-9a4b-0f26-01805b4880b4@gmail.com>
Date:   Wed, 11 Jan 2023 14:49:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] io_uring: Add NULL checks for current->io_uring
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20230111101907.600820-1-baijiaju1990@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230111101907.600820-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 10:19, Jia-Ju Bai wrote:
> As described in a previous commit 998b30c3948e, current->io_uring could
> be NULL, and thus a NULL check is required for this variable.
> 
> In the same way, other functions that access current->io_uring also
> require NULL checks of this variable.

io_uring_enter() {
...
	ret = io_uring_add_tctx_node(ctx);
	if (unlikely(ret))
		goto out;

	mutex_lock(&ctx->uring_lock);
	ret = io_submit_sqes(ctx, to_submit);
}

io_uring_add_tctx_node() should make sure to setup current->io_uring
or fail, so it should be NULL there, and SQPOLL should be fine as well.
Did you see it hitting NULL?


> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> ---
>   io_uring/io_uring.c | 3 ++-
>   io_uring/io_uring.h | 3 +++
>   io_uring/tctx.c     | 9 ++++++++-
>   3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 2ac1cd8d23ea..8075c0880c7a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2406,7 +2406,8 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
>   		/* try again if it submitted nothing and can't allocate a req */
>   		if (!ret && io_req_cache_empty(ctx))
>   			ret = -EAGAIN;
> -		current->io_uring->cached_refs += left;
> +		if (likely(current->io_uring))
> +			current->io_uring->cached_refs += left;
>   	}
>   
>   	io_submit_state_end(ctx);
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index ab4b2a1c3b7e..398c7c2ba22b 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -362,6 +362,9 @@ static inline void io_get_task_refs(int nr)
>   {
>   	struct io_uring_task *tctx = current->io_uring;
>   
> +	if (unlikely(!tctx))
> +		return;
> +
>   	tctx->cached_refs -= nr;
>   	if (unlikely(tctx->cached_refs < 0))
>   		io_task_refs_refill(tctx);
> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
> index 4324b1cf1f6a..6574bbe82b5d 100644
> --- a/io_uring/tctx.c
> +++ b/io_uring/tctx.c
> @@ -145,7 +145,8 @@ int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx)
>   	if (ret)
>   		return ret;
>   
> -	current->io_uring->last = ctx;
> +	if (likely(current->io_uring))
> +		current->io_uring->last = ctx;
>   	return 0;
>   }
>   
> @@ -200,6 +201,9 @@ void io_uring_unreg_ringfd(void)
>   	struct io_uring_task *tctx = current->io_uring;
>   	int i;
>   
> +	if (unlikely(!tctx))
> +		return;
> +
>   	for (i = 0; i < IO_RINGFD_REG_MAX; i++) {
>   		if (tctx->registered_rings[i]) {
>   			fput(tctx->registered_rings[i]);
> @@ -259,6 +263,9 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
>   		return ret;
>   
>   	tctx = current->io_uring;
> +	if (unlikely(!tctx))
> +		return -EINVAL;
> +
>   	for (i = 0; i < nr_args; i++) {
>   		int start, end;
>   

-- 
Pavel Begunkov
