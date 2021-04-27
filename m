Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30B936C722
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 15:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbhD0Nk4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 09:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbhD0Nk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 09:40:56 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D90C061574
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 06:40:13 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l19so8997137ilk.13
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 06:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cD4fs0EujxhFTI5OxkOofodeMjZdAd89Onbbfkc4YV4=;
        b=lula2YDeKMSR3eIRh6cxQDMnFQFw+CcnLgKliM3bW6K9E+ks1YLAoqFlhGbeJJn7xC
         xXZL+PhtehC0CPpQ20smuHrdOaR/63tNb+KRm/lzeQs/lk+aPdsDFSKJYj6+ZiBICaFD
         tOVbRV2re29DaWltHzC5eIFT/FDoNCEk5Q3P8PYBznsWVqSHPNYYV4M+oMk3gG1X9kEU
         vs94VvXvzYe6MTAipA9D/OApiXfdzoCSKEJF8vSp5OcYKIG+2ljq6TAscDgbNniQBISI
         I1mIn4mWp9ESORAW20o3at+Qe0l/FgzkFjmnjJhxJcVgySw0bziQJWiZoSXnNF9v+jyK
         3CyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cD4fs0EujxhFTI5OxkOofodeMjZdAd89Onbbfkc4YV4=;
        b=awb3WFvq+SoEJ+XHFFJIvdk3B1eea/JOknE7GWhPcVpwNa8PKZzrK7g9Nk6sSqkXjL
         6iVVFzxYIiO79o1X/DNw8/SN9YnKoxcl+xTzbj7DGP6IQNQuKK6MG+PRg9t05S7YG6r4
         grp0YUHc2X1nA4PjUbb7z839uwNdRJ+sTI8/WYEKi/nYYLEqRuEJl8i2iceBGFmS8D07
         40dcV0V1WgqexcojzV0BaB5aoh/u8xPsGT01p9+SQxhWGamiB28jeQDTxAycEzHPySjr
         jBpNwzy2HYQYHqaRxGaGm9lZa76CI4eNXssINGWnV7MZSyjlOsPu2jOuOwp9NXH4uU/d
         5RaA==
X-Gm-Message-State: AOAM5323D9bRTKmMlAMQKCUj7bNa/9zyemQZEkpYQFbZPTvOjuFZSaDJ
        sepeUpa1rGPzHkXEoKpxNHvJyw==
X-Google-Smtp-Source: ABdhPJzlv7yypz8IgEV+keyAaNbPrHzp6pONdPfR+C8DFaDsE4tBHu5OZJ1BjBdBmyaOKKcQIqRAyw==
X-Received: by 2002:a05:6e02:50e:: with SMTP id d14mr10479599ils.216.1619530812483;
        Tue, 27 Apr 2021 06:40:12 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w4sm1413916ilj.12.2021.04.27.06.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 06:40:12 -0700 (PDT)
Subject: Re: [PATCH v3] io_uring: maintain drain logic for multishot poll
 requests
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1618298439-136286-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f5978035-bdf9-1a6f-7855-3f21241fea2a@kernel.dk>
Date:   Tue, 27 Apr 2021 07:40:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1618298439-136286-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/21 1:20 AM, Hao Xu wrote:
> Now that we have multishot poll requests, one SQE can emit multiple
> CQEs. given below example:
>     sqe0(multishot poll)-->sqe1-->sqe2(drain req)
> sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
> is a multishot poll request, sqe2 may be issued after sqe0's event
> triggered twice before sqe1 completed. This isn't what users leverage
> drain requests for.
> Here the solution is to wait for multishot poll requests fully
> completed.
> To achieve this, we should reconsider the req_need_defer equation, the
> original one is:
> 
>     all_sqes(excluding dropped ones) == all_cqes(including dropped ones)
> 
> This means we issue a drain request when all the previous submitted
> SQEs have generated their CQEs.
> Now we should consider multishot requests, we deduct all the multishot
> CQEs except the cancellation one, In this way a multishot poll request
> behave like a normal request, so:
>     all_sqes == all_cqes - multishot_cqes(except cancellations)
> 
> Here we introduce cq_extra for it.

Thanks, applied this and the test case.

-- 
Jens Axboe

