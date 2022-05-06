Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5B51DD86
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 18:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354781AbiEFQ1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 12:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443742AbiEFQ1C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 12:27:02 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C306B0BD;
        Fri,  6 May 2022 09:23:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b19so10691352wrh.11;
        Fri, 06 May 2022 09:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bWltGt189d1ui9+bM0zr/qzUPbT+8oyFW3d+tpI0+NM=;
        b=OKYt/UD0am+VdaKsjdKBseXyhdIlfZuvW5HZvH2b5jBPfMYS4uDskjY9WiltAslVT2
         hTYU6jMfRUvcM/IOaKgaF8FLYIXMrjClrX+YjtRo1BKtLSvzKknmQxOpvjRnt3adyjaC
         M9J+862hX23eoSGMGA06X2qv0zSFHntQOZmF/8WrGUacYyzAmorGr3q2wq/usf20IyBn
         HAOUoADiDFWs/3vs+UAYYBtNnFEkaiXUx6p/31oQGap6I/zm5V69mOu3Mtf9VvQtzpq9
         d11GdYms2SHqOh3z3LUXNr0uKuow2085u5mzUwJuQD+jdoncd5hQZvk2ChB0xuEbG/96
         DTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bWltGt189d1ui9+bM0zr/qzUPbT+8oyFW3d+tpI0+NM=;
        b=N00wTFpepH6IDOhuuB4vOrLOqqwNhoCGcW133+KpBA4SxniY1Y51bK3/NodSNNzfu5
         COv4tgbZwKAJa5JjFGH1Y6hLJ/D3QPBoS8dMyW9lNtJdi93wfBDV+I6qsGPtos9C/LMH
         FwBwqqTIIb9BrJq80jJbNqMAA4ZIyXd01NprPeOM4bOTWCQ1yda8yYa2Z5PiQ3MdZ3x2
         BAA5MC6AjNycW6ct1trJ7aUABZJF/L71xghOW/QGl5R+q6fLZ5VOMWml7gFMAm3grhe4
         o0B52Itt4NMqfMSYap3mzmBxTBZBygRMVy74hxj0nURf6wYQabIXlupvz8LTuX1NFZhn
         TvmA==
X-Gm-Message-State: AOAM530/2nlsuxsUutNXHnxL2WXKoDh0AsonyeaK890/SPZzVWjnbZks
        Ws7Snm77rA5rhA12O0kymGywb+ebBDw=
X-Google-Smtp-Source: ABdhPJzwg4JahEHEGHDrJzroiLhHqAhfxsotfridXw3Yepz7Sjk9FqmzuvG9qgsk7lRzk9KF1cR8lA==
X-Received: by 2002:a5d:4148:0:b0:20a:d2de:d960 with SMTP id c8-20020a5d4148000000b0020ad2ded960mr3372721wrq.61.1651854197268;
        Fri, 06 May 2022 09:23:17 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.237.75])
        by smtp.gmail.com with ESMTPSA id s22-20020a1cf216000000b003942a244ee9sm4448695wmc.46.2022.05.06.09.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 09:23:16 -0700 (PDT)
Message-ID: <28b1901e-3eb2-2a50-525c-62e1aa39eaac@gmail.com>
Date:   Fri, 6 May 2022 17:22:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 4/5] io_uring: add a helper for poll clean
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-5-haoxu.linux@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220506070102.26032-5-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 08:01, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a helper for poll clean, it will be used in the multishot accept in
> the later patches.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   fs/io_uring.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d33777575faf..0a83ecc457d1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5711,6 +5711,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	return 0;
>   }
>   
> +static inline void __io_poll_clean(struct io_kiocb *req)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	io_poll_remove_entries(req);
> +	spin_lock(&ctx->completion_lock);
> +	hash_del(&req->hash_node);
> +	spin_unlock(&ctx->completion_lock);
> +}
> +
> +#define REQ_F_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
> +static inline void io_poll_clean(struct io_kiocb *req)
> +{
> +	if ((req->flags & REQ_F_APOLL_MULTI_POLLED) == REQ_F_APOLL_MULTI_POLLED)

So it triggers for apoll multishot only when REQ_F_POLLED is _not_ set,
but if it's not set it did never go through arm_poll / etc. and there is
nothing to clean up. What is the catch?

btw, don't see the function used in this patch, better to add it later
or at least mark with attribute unused, or some may get build failures.


> +		__io_poll_clean(req);
> +}
> +
>   static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	struct io_accept *accept = &req->accept;
> @@ -6041,17 +6058,13 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
>   
>   static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>   {
> -	struct io_ring_ctx *ctx = req->ctx;
>   	int ret;
>   
>   	ret = io_poll_check_events(req, locked);
>   	if (ret > 0)
>   		return;
>   
> -	io_poll_remove_entries(req);
> -	spin_lock(&ctx->completion_lock);
> -	hash_del(&req->hash_node);
> -	spin_unlock(&ctx->completion_lock);
> +	__io_poll_clean(req);
>   
>   	if (!ret)
>   		io_req_task_submit(req, locked);

-- 
Pavel Begunkov
