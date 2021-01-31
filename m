Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD91309DC0
	for <lists+io-uring@lfdr.de>; Sun, 31 Jan 2021 16:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhAaPud (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jan 2021 10:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhAaPuV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jan 2021 10:50:21 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEECC061573
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 07:49:37 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id g10so13920108wrx.1
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 07:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ddG8EPmRqboQlmuVLMgbQxlihaEE837rnlA2gmkI9C0=;
        b=RUkaNUaTfdQflJ7kL1llQRZaRtgG8aqTJQsK3JOAxl+1RTpm6tjUpSbnNf8LlffZkt
         +M5xex5epm5nc2oV3izPAariFOQGDXgbDORtFMRnqvAiwFjB5DEUzoT/78pLsa0kiYxz
         RGraN4IugfASS3/xUNqM8i+pmj3JViRA8q/Y0lT3qDqlgDsQgCZXA1y/zzp88B8JoFeT
         bXECpCd3T9n84cHcQ7gCqlx/Z64hijZ+um1tVXjkKekwfmXcIV3tWNOIob0jbULT5VGu
         ktdCuDu3JcYKQ+K5w7hozJCjklZClW+KYDcmh2Q4id23YBIqUuoNkAkrPchOSkTbApSS
         I2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ddG8EPmRqboQlmuVLMgbQxlihaEE837rnlA2gmkI9C0=;
        b=T1IyuNvrsCH7idbiSm38fsR0Nnfo9TRcIhYVJ9pFkpWiuLq5ZGG2NkI0jMwKMK4xjg
         5ywxalHsSLcF+YeG1CqzMcWen3wryIPS6W3purc7OOriB9Fyv6LRBE8tH4zmO+I5JFVo
         d60KXX+y2obbi2jSYVlvvg6yRTebL38Zww4pf7wYnE01B2rcSrt845Z1hroCSC0yd6Ki
         0BUn/FTuS5WaM0x0f/bAZ8qg01AtYaKGQE9c1RImNG4MPfuyXYDpVOcMs9pkHJ9TGVNg
         kZh9EoLU4xuVvd5BjDMwMbe7RJJcbRPngOUpuxkaJh9FhQg63loB0+G6nANmyPf310fN
         kLPA==
X-Gm-Message-State: AOAM531G4/X8dfc8Ov8+wAA8fpPbRjtqbYx63DoHmSq4y0pClETFdoyC
        bG85oCpKJ+Y24Iwia12vRU2ckIHu1MY=
X-Google-Smtp-Source: ABdhPJxBYJpRKSyE3q0QPpod310f3M6MH43TW7CSQ0Ab5jqISLAJU4gDtN3qgbSRhaKmv6R1kJNo7g==
X-Received: by 2002:a5d:58c2:: with SMTP id o2mr14030805wrf.31.1612108176233;
        Sun, 31 Jan 2021 07:49:36 -0800 (PST)
Received: from [192.168.8.165] ([148.252.128.5])
        by smtp.gmail.com with ESMTPSA id z185sm19921015wmb.0.2021.01.31.07.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 07:49:35 -0800 (PST)
Subject: Re: [PATCH v3] io_uring: check kthread parked flag before sqthread
 goes to sleep
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612103944-208132-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <686e4de3-83b7-e75b-f39d-43df2d7380d4@gmail.com>
Date:   Sun, 31 Jan 2021 15:45:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1612103944-208132-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 31/01/2021 14:39, Hao Xu wrote:
[...] 
> So check if sqthread gets park flag right before schedule().
> since ctx_list is always empty when this problem happens, here I put
> kthread_should_park() before setting the wakeup flag(ctx_list is empty
> so this for loop is fast), where is close enough to schedule(). The
> problem doesn't show again in my repro testing after this fix.
> 

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> v1-->v2
> - tweak the commit message
> 
> v2-->v3
> - remove duplicate kthread_should_park() since thread parking is rare
> operation
> - put kthread_should_park() in if (needs_sched)
> 
> 
>  fs/io_uring.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c07913ec0cca..d9019ce2bda0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7115,9 +7115,6 @@ static int io_sq_thread(void *data)
>  			continue;
>  		}
>  
> -		if (kthread_should_park())
> -			continue;
> -
>  		needs_sched = true;
>  		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> @@ -7132,7 +7129,7 @@ static int io_sq_thread(void *data)
>  			}
>  		}
>  
> -		if (needs_sched) {
> +		if (needs_sched && !kthread_should_park()) {
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>  				io_ring_set_wakeup_flag(ctx);
>  
> 

-- 
Pavel Begunkov
