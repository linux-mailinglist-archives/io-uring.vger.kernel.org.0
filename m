Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D93FFF57
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 13:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348576AbhICLoe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 07:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348247AbhICLoe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 07:44:34 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45471C061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 04:43:34 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m9so7840529wrb.1
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 04:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sw9JTmEw1FQiBNQC24oUITZLCASmPsPFSNzeoRsbk3o=;
        b=V7DCaNiFPVVJZj8DxCciK5mwni2xd4/MOBzfnLxcJxP2MjmN9yQh9pD+HWE6XJs/cJ
         RLoXpQslQ2gdhwtJKIr3Ga0n5TSNcAB6zWxUxVvtQuc3eoN/TqCR2tb6uN8rld7Ooe2h
         M2nDAFmAkotjMODyQyNTlW5lfvgr+dva9BDWBlsaWUn96Chcf1Yyzzgd7/BOQ8gJv55u
         iy32AXIXgNTNz+wuKOWeE6lBJDqr/KsKOo9x7IYwq0yHIjePT1gVlz9xguK+Qu7+6Vzf
         1a9x5phW4kobyVlEJMC89WEDJsvOWyW8kDhtd5gJgj0V51BwCpBc2uxozBD3g34druoE
         CVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sw9JTmEw1FQiBNQC24oUITZLCASmPsPFSNzeoRsbk3o=;
        b=GnLuqP4IJ8wOx/cDPz7WIHeMxuvbHxwDSN7aa4vVwB5rS/SsHdtFL1NicMnq9OtFUx
         A2MeujXYN1HSxXS4FV9CiRPh7nUp/QZPqVjF++0u/cOFVo13wf3IzbLexNXJpWuCVbd4
         sjSgnzynT+g/mhthbMoWQHSpcoi8VXAcNdhTf1Wl1MuKI/8qAnFhWotnhSlFSFKWiJHJ
         X7bcuj6k6KW3x4RrQCp9oSsF5D3lR/dW4ZuMNL9l3Ba71EmF7O8KZPOung7EZu2ZqFcP
         sgplvkui0kPfGTabJl0il2+ONbHVrrZiHkoT+hJvGHXHd+r9XQ64SATXLCctyiVnPWEr
         aOaA==
X-Gm-Message-State: AOAM53251okhTUiXeGGeBgadsfxRD2N0W3teB45WTIFiiQcOg0xp1iAf
        /fojV0nkE0/BICrRjGsVXjg=
X-Google-Smtp-Source: ABdhPJxKk22qXyx9iemu2gVrhck9Ub5nu+o6Ja6ikqsVQ5DmlqpI60wxD5h3iXa16GODF+YQdDE28Q==
X-Received: by 2002:a5d:58dc:: with SMTP id o28mr3529301wrf.399.1630669412826;
        Fri, 03 Sep 2021 04:43:32 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id a10sm4660989wrd.51.2021.09.03.04.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 04:43:32 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-2-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/6] io_uring: enhance flush completion logic
Message-ID: <fd529494-96d4-bc91-8e0c-0adf731b9052@gmail.com>
Date:   Fri, 3 Sep 2021 12:42:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210903110049.132958-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 12:00 PM, Hao Xu wrote:
> Though currently refcount of a req is always one when we flush inline

It can be refcounted and != 1. E.g. poll requests, or consider
that tw also flushes, and you may have a read that goes to apoll
and then get tw resubmitted from io_async_task_func(). And other
cases.

> completions, but still a chance there will be exception in the future.
> Enhance the flush logic to make sure we maintain compl_nr correctly.

See below

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> we need to either removing the if check to claim clearly that the req's
> refcount is 1 or adding this patch's logic.
> 
>  fs/io_uring.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2bde732a1183..c48d43207f57 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2291,7 +2291,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
>  	__must_hold(&ctx->uring_lock)
>  {
>  	struct io_submit_state *state = &ctx->submit_state;
> -	int i, nr = state->compl_nr;
> +	int i, nr = state->compl_nr, remain = 0;
>  	struct req_batch rb;
>  
>  	spin_lock(&ctx->completion_lock);
> @@ -2311,10 +2311,12 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
>  
>  		if (req_ref_put_and_test(req))
>  			io_req_free_batch(&rb, req, &ctx->submit_state);
> +		else
> +			state->compl_reqs[remain++] = state->compl_reqs[i];

Our ref is dropped, and something else holds another reference. That
"something else" is responsible to free the request once it put the last
reference. This chunk would make the following io_submit_flush_completions()
to underflow refcount and double free.

>  	}
>  
>  	io_req_free_batch_finish(ctx, &rb);
> -	state->compl_nr = 0;
> +	state->compl_nr = remain;
>  }
>  
>  /*
> 

-- 
Pavel Begunkov
