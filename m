Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899B2407F25
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhILSLj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhILSLj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:11:39 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2365C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:10:24 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id q14so7720287ils.5
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2YQvGiiTELEBfg7tIuV34e00wPWbcilLMxNm/m+jpLw=;
        b=MHUi70OkkL5XbNUmqQHIpIDUiP7luuAzj/tAy0GlLZ33dlwvNS2v8TDHP/tDLwOJ96
         x4tncgA4CQeMQ8Zc9Pz1Wy+HW4tcdqq6iJ4k7W6bNr1P3eH0bDEA1eLqYeUdaqkp9p1p
         bBxFjFCXdS4Z+V1oJ5WfFNf0CEPQvzyazQROTHTlArE4Pzzu7G+5cHztJ/1l/136fkeV
         Y9iTln2WkIUK5wvKyLu53/vUhwTlohYhnAQUzWlhHZk8y2KdCsNVN8JHbMHvRNjwNWy/
         VNtFhmHLESd0Y79UEtEndEE1ofS3+QVWXp102AhvegfpAz97zhsdQpyMnYn8fZ2FMMdB
         +kXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2YQvGiiTELEBfg7tIuV34e00wPWbcilLMxNm/m+jpLw=;
        b=3nvrVdO/YbeuVLHtLD62gzcSpW+e4l8BilxcgvoemPlSjE5A0o9GAl/8QwZ4JoVWgq
         g8iHRMA2griMw2O6sH4gel5tzwPe1hpn4vsdRUEI7rcx5V48+U5AmlLA7tAPujE0IBo5
         S8wlSyxcPeG8j4b2vSyn2G9H+PoRS9M8K7qNRoYzU1HN33iGFJggpVve/dalvnzdkrKy
         J0MFdkmvsmlE3VkWEiw7Mru0Ypo2QfrCi3rD4FSRhSLliKJeBN3bXIxj9mIHRENo4Clc
         nP9/GuXr8kLcfGdJ8KqnTlkNF6LcyGJmjqKnWYyjutMu5HTNQmLoUesr4FNMkp3pEgXn
         a15w==
X-Gm-Message-State: AOAM531gNf3+X9iNnO0RX5zxl31FsMZhqDJZkwTaTchOCeZAQqCI0H4y
        jT8YfQltbtQFaRP2TY9OQR846w==
X-Google-Smtp-Source: ABdhPJwHWZXLToTSdcSd8O+V1e73YxSwshvKsJ8Uri41/9g57snV7DxnRbakWK6fPxkKQOh9WwHHsA==
X-Received: by 2002:a92:c145:: with SMTP id b5mr5029684ilh.203.1631470224292;
        Sun, 12 Sep 2021 11:10:24 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e10sm1068961ili.53.2021.09.12.11.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:10:23 -0700 (PDT)
Subject: Re: [PATCH 1/4] io-wq: tweak return value of io_wqe_create_worker()
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-2-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c01cd26-a569-7a99-964a-9436c8baa57f@kernel.dk>
Date:   Sun, 12 Sep 2021 12:10:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210911194052.28063-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/21 1:40 PM, Hao Xu wrote:
> The return value of io_wqe_create_worker() should be false if we cannot
> create a new worker according to the name of this function.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 382efca4812b..1b102494e970 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -267,7 +267,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>  		return create_io_worker(wqe->wq, wqe, acct->index);
>  	}
>  
> -	return true;
> +	return false;
>  }

I think this is just a bit confusing. It's not an error case, we just
didn't need to create a worker. So don't return failure, or the caller
will think that we failed while we did not.

-- 
Jens Axboe

