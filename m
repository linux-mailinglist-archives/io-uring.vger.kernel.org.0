Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0413F342C
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 20:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236938AbhHTTAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 15:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhHTTAa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 15:00:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E94C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 11:59:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q6so15579896wrv.6
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 11:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=moJLnnaVroSVmN//eLXSRpU3abNtI4jwLq9bORuwMg4=;
        b=mLCVd5jnx1RMFFzmaQCGQhkqb0F7STZxupgWarYTXDDOvcIpDQkKNLvtK8Z5/9cTnu
         WKgm1uni6EEzBgtCPb+TpYbh8XJWTYbyCxWU+9gGqAIURX99aDdDcitz9xdpFa8ZhECk
         hY+MpN67dR8aSZgRYnvrCeCOnhyQHjLLe/K0KOayd6z0EPLGCo2KH+B9w/+itNrU7d+R
         N8G0NgOUdvbLdZcudBiZEwP7nCYAUKpu2Bd0bUE8PUrK1JRiq2UbTovgR7cuenIBJb6i
         ABn3t9J202oYZRLCcsquzWQqs+OYfu/0uXXMiB8Dw2sg1I/+UxIMC8REnbq3i9ynWx+c
         nbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=moJLnnaVroSVmN//eLXSRpU3abNtI4jwLq9bORuwMg4=;
        b=Eso3/UznoaVNgDQA6XrdB6KFLxWkbF83NuNBeRWdYcssJQUMXgDHQgUI7JG2gthXml
         Yp9+hv1GKK35IHLXC574QwLwRsF9QBAMFYna97eNtvlUSFaANHAl8CsrEGO/LEwgatGs
         bN9JEw84m/KaDuEnFzn9JaTL4zu7N8hPH49jwBPKrQ4o6wud7YXwwDfR7g7EZNreaB9+
         lgibIxhVpd+1fYy9u+JYpegCMMQLy2yfZIE1is1NIY0XE0E6Ex24dhCndVXaq50uZZOv
         40mcNJz5jqiHf8SlNKdwSuOAaXS/rmVhzeplLrAMgUi3VzpBCHSbiM5Iz0F0CP11Bwph
         9sNg==
X-Gm-Message-State: AOAM533UWAH+wfhE+CPMtshQg+CMDqF4tg5uSvJxDPqmj1ny7xA/w5s7
        35SEA0lLmxZTL/TSHRzPrFbIf0wDvhI=
X-Google-Smtp-Source: ABdhPJwerukkrCR4524bvg5usXcRNhu6UfaP6zHsfis4+9/vCr3VO0viYUhwF14WcSlEp55mL8TcYg==
X-Received: by 2002:a5d:4742:: with SMTP id o2mr282272wrs.296.1629485990634;
        Fri, 20 Aug 2021 11:59:50 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id z5sm5677802wmi.36.2021.08.20.11.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 11:59:50 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
Message-ID: <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
Date:   Fri, 20 Aug 2021 19:59:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210820184013.195812-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 7:40 PM, Hao Xu wrote:
> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
> may cause problems when accessing it parallelly.

Did you hit any problem? It sounds like it should be fine as is:

The trick is that it's only responsible to flush requests added
during execution of current call to tctx_task_work(), and those
naturally synchronised with the current task. All other potentially
enqueued requests will be of someone else's responsibility.

So, if nobody flushed requests, we're finely in-sync. If we see
0 there, but actually enqueued a request, it means someone
actually flushed it after the request had been added.

Probably, needs a more formal explanation with happens-before
and so.

> 
> Fixes: d10299e14aae ("io_uring: inline struct io_comp_state")

FWIW, it came much earlier than this commit, IIRC

commit 2c32395d8111037ae2cb8cab883e80bcdbb70713
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Feb 28 22:04:53 2021 +0000

    io_uring: fix __tctx_task_work() ctx race


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c755efdac71f..420f8dfa5327 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2003,11 +2003,10 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
>  {
>  	if (!ctx)
>  		return;
> -	if (ctx->submit_state.compl_nr) {
> -		mutex_lock(&ctx->uring_lock);
> +	mutex_lock(&ctx->uring_lock);
> +	if (ctx->submit_state.compl_nr)
>  		io_submit_flush_completions(ctx);
> -		mutex_unlock(&ctx->uring_lock);
> -	}
> +	mutex_unlock(&ctx->uring_lock);
>  	percpu_ref_put(&ctx->refs);
>  }
>  
> 

-- 
Pavel Begunkov
