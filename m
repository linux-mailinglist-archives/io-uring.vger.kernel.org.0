Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D057483F5
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 14:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjGEMOV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 08:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjGEMOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 08:14:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D281BE3;
        Wed,  5 Jul 2023 05:14:06 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-992ace062f3so793684666b.2;
        Wed, 05 Jul 2023 05:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688559245; x=1691151245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qVCmFjHaC5Q7tgfQxLEj1IWtVdSN5OY45YY+cpq9sww=;
        b=rwoEVsxKkkb/pahIh4lS36eyTXKcTBxzwrbvGsewBgsbQlHuXRzaPNhO8Dlvtah6ky
         /O8NwYvnVhiKod6rPUdn7LuOPr+B0t/w2gX8v3lgCQozp2ZmCbYGIzah71WrJQuKA+Wb
         MC981jbVfI9i1x134iszUuyw3EzJm7zGWi4Eod7iKxkEHzB/+iDjh1T2NR0OCspPcYQT
         5yLlRTRwF/RY2jKqLg0S6A19lh8rtFKdGmPCXUlEYbAY6AbCeNyG300GRU/J1a56ZpJf
         Ue98YYU6Hbl6RHLWXBbapx7ZvwpjlXnUT1ACRr2JzQYH3qZC4otkmXy23sxJWiSFzcy+
         3ZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688559245; x=1691151245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qVCmFjHaC5Q7tgfQxLEj1IWtVdSN5OY45YY+cpq9sww=;
        b=D2leYW/jUQZlbNlEotYKhjEHnMk9jFETIZXKP0jXC/RHACoyoh1xn70m9WWY8Fz29c
         Gmck1DltUcb0fo2N0CVoke9dJFBdedFaOWhsR1KviemZHNunMN+AxvnqspYHAddYJaNh
         TV2qh7+hmmPtMvG3IrPmRQrWfsB28PmC9F4yZd0BDX5CbvBodRuMu4gyJEmDqFiUaCCK
         oKZ5vr9ap4U4Q+HV2u+FiLiSonOJDhvfboylPAOS35Jbxx1o3aBud2n4wPpyoVN6fMgR
         C+r5dToXzElITVDP7+86nSOY0YzfoXpltRzlTh3CZFFncAAJz2mtw3c0pn8mUBOsqDXR
         MAxA==
X-Gm-Message-State: AC+VfDzpGHzTTNNdjxyL9/FAjLQ8pim+zsT7Hdy2UMp/zJmFw907CzSb
        CG8OJPr+I9Rv/dsH9cG2zt0=
X-Google-Smtp-Source: APBJJlFYUYLTONYdXrktuv8ySB1OKfabZ3M5jyHBco12c9u5mJC4PwQn0Q+adwj/3bePcJfflxMYwg==
X-Received: by 2002:a17:906:e48:b0:978:a186:464f with SMTP id q8-20020a1709060e4800b00978a186464fmr13000508eji.39.1688559244603;
        Wed, 05 Jul 2023 05:14:04 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709063e4d00b00992ae4cf3c1sm8244801eji.186.2023.07.05.05.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 05:14:04 -0700 (PDT)
Message-ID: <f549492d-a4af-f517-7f12-9d469067a235@gmail.com>
Date:   Wed, 5 Jul 2023 13:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 01/11] io-wq: fix worker counting after worker received
 exit signal
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-2-hao.xu@linux.dev>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-2-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/23 13:20, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> acct->nr_workers should be decremented when we break the loop in
> io_wq_worker().
> 
> Fixes: 78f8876c2d9f ("io-wq: exclusively gate signal based exit on get_signal() return")
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/io-wq.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index b2715988791e..b70eebec2845 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -634,6 +634,10 @@ static int io_wq_worker(void *data)
>   
>   			if (!get_signal(&ksig))
>   				continue;
> +
> +			raw_spin_lock(&wq->lock);
> +			acct->nr_workers--;
> +			raw_spin_unlock(&wq->lock);

Wouldn't it suffer the same race you fixed with the following?

commit 767a65e9f31789d80e41edd03a802314905e8fbf
Author: Hao Xu <haoxu@linux.alibaba.com>
Date:   Sun Sep 12 03:40:52 2021 +0800

     io-wq: fix potential race of acct->nr_workers



Even more, seems we fail to decrement nr_workers when the loop condition
fails, i.e.

	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {


I.e. the patch looks legit, but what we currently have is a mess and we
have more work to do.

-- 
Pavel Begunkov
