Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C01D1950
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 17:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732196AbgEMPZy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 11:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgEMPZy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 11:25:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BDDC061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 08:25:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k7so6263639pjs.5
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q36mXwVZYBxcn4/2okEvI1cjKHZZswhgXUjRwsQbwKE=;
        b=d4C5GUyVfHkJUimNOHU7+H67Wcu9PI9qsJw3RurWd0i9IRGifbygh9OIno9kIxhnue
         +BQDdurMhUtyzGEVNLl756dHn8v/uEyxo9g1oAk6USP4Ii+LJUo3Py3nW4gO/1ihB8HU
         qShUhYMeaTakjzyGKSlDPmX/x7y8kYFdrqgk9Rhw/4LwblGJ/T71CFZRfx2qRmWEQXUV
         UJHyW4q3PSpb38kaDcF3v0ffkJ5S32/49Y9IygIfn0X6AfosSN3fQPrAE0MMfQ+S5cKQ
         3ydG3Pnn/0yR/1KNP2IgVHbgS/w6TgtvuT2kCzsdfuSXqQOZxFlRToJq1sOsET7kB21m
         00dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q36mXwVZYBxcn4/2okEvI1cjKHZZswhgXUjRwsQbwKE=;
        b=tr1GMwdXY+XByBzMIxmLtlmjjir3nqN6LmGYx4MGvg6eBAcKzS7MyyrTL6BxM9s58B
         qrZK+n+YFsz9YQa7AW35xaVFrSABv2spnaiv5TuzF6FVcejG6kaInkKaGo8SkNmCR1GE
         kf6KBR/1EAtlukJpxFvhhP7S1tK8oOuky6LK2ff/ykGTNvGo5TvQuCyeP8lq+DPrWcWI
         f5mmN9Ws3iAjZVzNhjz7faMpEUD0Cpk6X69BZAIJcjQM8fsl6Y5g9X2UNkKNlCcdSLwq
         KnG3fkzw7hBubZNOEHDa7acpRVUjhyzTbE5rfrKb5Y/wHb2/271oDB4fUrxn19qwrJp5
         Aa/w==
X-Gm-Message-State: AGi0PuarJwFVZVmdP+4UnGCKo7KneOaoNjp6bPqk8f5nuuNXHExIdDRd
        fGE7ZXVhHSMZcJDJwxeCBmu5LXeTlnk=
X-Google-Smtp-Source: APiQypL7wttrTHtTgKHQXKC6+PWY48BWlRgRryBQL2tKJxFRQxBkpgRN9kVWjTsDzoOPHPFykdSY+w==
X-Received: by 2002:a17:90a:9311:: with SMTP id p17mr35343328pjo.145.1589383553444;
        Wed, 13 May 2020 08:25:53 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:e16c:b526:b72a:3095? ([2605:e000:100e:8c61:e16c:b526:b72a:3095])
        by smtp.gmail.com with ESMTPSA id g1sm15917231pjt.25.2020.05.13.08.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 08:25:52 -0700 (PDT)
Subject: Re: [RFC PATCH] io_uring: don't submit sqes when ctx->refs is dying
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200513123754.25189-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <89e8a0b4-bc18-49c8-5628-93eb403622e2@kernel.dk>
Date:   Wed, 13 May 2020 09:25:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200513123754.25189-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/20 6:37 AM, Xiaoguang Wang wrote:
> When IORING_SETUP_SQPOLL is enabled, io_ring_ctx_wait_and_kill() will wait
> for sq thread to idle by busy loop:
>     while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
>         cond_resched();
> Above codes are not friendly, indeed I think this busy loop will introduce a
> cpu burst in current cpu, though it maybe short.
> 
> In this patch, if ctx->refs is dying, we forbids sq_thread from submitting
> sqes anymore, just discard leftover sqes.

I don't think this really changes anything. What happens if:

> @@ -6051,7 +6053,8 @@ static int io_sq_thread(void *data)
>  		}
>  
>  		mutex_lock(&ctx->uring_lock);
> -		ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
> +		if (likely(!percpu_ref_is_dying(&ctx->refs)))
> +			ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>  		mutex_unlock(&ctx->uring_lock);
>  		timeout = jiffies + ctx->sq_thread_idle;

You check for dying here, but that could change basically while you're
checking it. So you're still submitting sqes with a ref that's going
away. You've only reduced the window, you haven't eliminated it.

-- 
Jens Axboe

