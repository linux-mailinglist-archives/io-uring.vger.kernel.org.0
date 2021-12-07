Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050E246C708
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 23:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhLGWDc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 17:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhLGWDc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 17:03:32 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F33AC061574
        for <io-uring@vger.kernel.org>; Tue,  7 Dec 2021 14:00:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so554863pjb.1
        for <io-uring@vger.kernel.org>; Tue, 07 Dec 2021 14:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6ZCP2UkNspnPGcmqD3FGFp5rcGLWw2a62yiENcUai1M=;
        b=bWl/zkJuXq2txO1kiRmidPsfPrTijizPu0CRNvNlwCOCNNlq3pl0O9rQOrWYpFELk6
         /48Szh8MuYiEbwbigUwwJcDeDX298lYXD2ds5yusILXJpxf5p5IF4pZ+ikNaGar/1PtR
         lDhUggQM0rMEvStARdtnKhcKEy1WhvzNPR7icc17iccp35t9Db5b9ZiUXRSMDlxWm8m2
         CaWPzUMxRxNvFiOTMoGVTe5vwVLcyKHJg3hTPjVm23MrjXKqgGbb1UFJo+6GsF2EEomS
         rdXWuXMJSyp8srap72lbEU9UGk70J5tbw1VXY6uKLd4KOH7PalTOyvJbPpJaF+xcNdQ7
         u1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ZCP2UkNspnPGcmqD3FGFp5rcGLWw2a62yiENcUai1M=;
        b=mdK7dWmcyVxIwQ/c8sKgrzmH38UV8XQzoB0pLjzaWjy+020G1DAQ3PpiqKWKGSseI4
         9B20Qt2NomwHqKof5bJkxlz3WAGgW3TDdcUa/MFG2/Y6bFQlaKSvFwVSyqjJIrZWIMc2
         VDl4f+nY1DG2zV4eTPiBvCrgtMDrmfT4nbVOP7LbFoCVaA0JhGsaPNeiqcMA0bMGFGmX
         CkyMFw92WPbvi6y7JKnqDxcPQP7N4Xvg1XqbXL28xqQ/tWCM5CxWmYX8N3ahLJZSKnLX
         DMGRo0ZUjJIsea8oR3tDPnvRCH2yRlRCmmsytqPmPE08ilowRbLS5SNpNQDvPixQaOIW
         V4Nw==
X-Gm-Message-State: AOAM531Mq9SB/guwIdT1vrt0aazSEJDIamdbluwCafKEx5Lcm23gD+64
        4udMobeKEd9OHFdwFn3x4S0tIjI+iLJgWtX/
X-Google-Smtp-Source: ABdhPJxBxmAhltZ6i2fakmlRUNBeBVICFCilIKDczxick+PHMFC5QpICXIgyyFY8rcm/MKSUrYBp3A==
X-Received: by 2002:a17:903:248c:b0:142:9bf:8b0 with SMTP id p12-20020a170903248c00b0014209bf08b0mr54376433plw.70.1638914400944;
        Tue, 07 Dec 2021 14:00:00 -0800 (PST)
Received: from ?IPv6:2600:380:b45e:42fd:5a55:bd65:7fc7:f698? ([2600:380:b45e:42fd:5a55:bd65:7fc7:f698])
        by smtp.gmail.com with ESMTPSA id lw1sm3873990pjb.38.2021.12.07.13.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 14:00:00 -0800 (PST)
Subject: Re: [PATCH 5/5] io_uring: batch completion in prior_task_list
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
 <20211207093951.247840-6-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1fcdb967-03f0-bdd3-2127-9d678d40aff2@kernel.dk>
Date:   Tue, 7 Dec 2021 14:59:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211207093951.247840-6-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/21 2:39 AM, Hao Xu wrote:
> In previous patches, we have already gathered some tw with
> io_req_task_complete() as callback in prior_task_list, let's complete
> them in batch while we cannot grab uring lock. In this way, we batch
> the req_complete_post path.
> 
> Tested-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi Pavel,
> May I add the above Test-by tag here?

When you fold in Pavel's fixed, please also address the below.

>  fs/io_uring.c | 70 +++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 60 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 21738ed7521e..f224f8df77a1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2225,6 +2225,49 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
>  	percpu_ref_put(&ctx->refs);
>  }
>  
> +static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
> +{
> +	io_commit_cqring(ctx);
> +	spin_unlock(&ctx->completion_lock);
> +	io_cqring_ev_posted(ctx);
> +}
> +
> +static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
> +				 bool *uring_locked, bool *compl_locked)
> +{

Please wrap at 80 lines. And let's name this one 'handle_prev_tw_list'
instead.

-- 
Jens Axboe

