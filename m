Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306ED637D86
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 17:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiKXQRw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 11:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKXQRw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 11:17:52 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00BB21E02
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:17:50 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o30so1638747wms.2
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 08:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6HPxzHuBF1SJWGz5S2yPNh5XH+p5oMAKH0Ba78ujOGI=;
        b=mkOvKQn2tNYBPHvV9JFB5ttvRKgpFjZHjs/KJts/wTXjSVuuo0odMh8IpDicH162Jl
         +O7tEjLUp3109pcgqweznMSRRIyT4I12t2TK80i2tgZT8Y4L/IfCIK+SDqd7jPJ8nynM
         Gq+v7XMyPbe761ZPIANdGWRFjjB/LIEQLWH3d56jLIVPxFp9x42bwBThE25WFYRwW6Yp
         WeoGvhA2IJkUmcLUr629PUVCzIipSt3sDEkQq48K5fQzNcRCKADJyfdTxDvypaDS0f+o
         DGNYwgWtUvoI6BOJMs9TwTsL/yQ5jKgAY8rLEg1FonGe+z0F5b1k0krq4zACDqcdnxuH
         yqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6HPxzHuBF1SJWGz5S2yPNh5XH+p5oMAKH0Ba78ujOGI=;
        b=GhEnEJkGN3AHIYbnqSmQUSV+0LFxEqetUtTGOJCspMcmPSewE9oO9KZbdQS+IfJjlP
         ObaL6LBKg25A9V4Hthn8nm8ErmQ7/UtXDDsrehZEGDTxCYpUONje9r6ggLvMw0BFOfRq
         VBIqFJpA3Yy3rgJK4FvLzYum3JL+vxqq8tCjOdT6O1hMDAuUWy180iBHAiuLQVQ4u77T
         Hwop2VAHh4/axBOvF6M9lb+7BJ+B9T4/vz6jJxXntzN5NURi7ZG6hlJvwMksW1PQ16tV
         e7nJ5M+tAuiy5cIWCDcOjPjtBSodyMSoDwtsr1ecHgnvXbtsW6ixI0TYNeRKOul0vJZY
         H6sw==
X-Gm-Message-State: ANoB5pl8FnVb3yff9ZlQSwDF2WoZlIa5rBUgtdjUpMfgVwjKcEjaFCZT
        b5FJtZuz+lwKeu7eIDepoAgwfD6rDc8=
X-Google-Smtp-Source: AA0mqf74HttTdWpvDBgdPRTp9gmZCpmoUxC4BUl7Hy9/ktWBcdmkFQMuoDRIF+elCBpTJocMS4+Q8A==
X-Received: by 2002:a7b:cb83:0:b0:3cf:96da:3846 with SMTP id m3-20020a7bcb83000000b003cf96da3846mr26885064wmi.10.1669306669250;
        Thu, 24 Nov 2022 08:17:49 -0800 (PST)
Received: from [192.168.8.100] (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id t2-20020a5d42c2000000b0023662d97130sm1693540wrr.20.2022.11.24.08.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 08:17:48 -0800 (PST)
Message-ID: <c03977b8-85a1-5984-ebda-8a0c7d0087d2@gmail.com>
Date:   Thu, 24 Nov 2022 16:16:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] io_uring: kill io_cqring_ev_posted() and
 __io_cq_unlock_post()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
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

On 11/21/22 14:52, Jens Axboe wrote:
> __io_cq_unlock_post() is identical to io_cq_unlock_post(), and
> io_cqring_ev_posted() has a single caller so migth as well just inline
> it there.

It was there for one purpose, to inline it in the hottest path,
i.e. __io_submit_flush_completions(). I'll be reverting it back



> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 762ecab801f2..2260fb7aa7f2 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -581,23 +581,14 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
>   		io_eventfd_flush_signal(ctx);
>   }
>   
> -static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
> -{
> -	io_commit_cqring_flush(ctx);
> -	io_cqring_wake(ctx);
> -}
> -
> -static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
> +void io_cq_unlock_post(struct io_ring_ctx *ctx)
>   	__releases(ctx->completion_lock)
>   {
>   	io_commit_cqring(ctx);
>   	spin_unlock(&ctx->completion_lock);
> -	io_cqring_ev_posted(ctx);
> -}
>   
> -void io_cq_unlock_post(struct io_ring_ctx *ctx)
> -{
> -	__io_cq_unlock_post(ctx);
> +	io_commit_cqring_flush(ctx);
> +	io_cqring_wake(ctx);
>   }
>   
>   /* Returns true if there are no backlogged entries after the flush */
> @@ -1346,7 +1337,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   		if (!(req->flags & REQ_F_CQE_SKIP))
>   			__io_fill_cqe_req(ctx, req);
>   	}
> -	__io_cq_unlock_post(ctx);
> +	io_cq_unlock_post(ctx);
>   
>   	io_free_batch_list(ctx, state->compl_reqs.first);
>   	INIT_WQ_LIST(&state->compl_reqs);
> 

-- 
Pavel Begunkov
