Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6154C54C5F3
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347458AbiFOKWM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348301AbiFOKVw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:21:52 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3D14CD62
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:20:48 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id a10so6044296wmj.5
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9UM8IQYrAZfWJT9VJPt22C4nX7BfIu6qh03YcerYMl0=;
        b=C2iBOlsY7ACLC51jgC4leQ9qAu8SXqO6+kdOe0bX0w7t+DXUVZr0RWHs60R2zMWZAO
         om+xRhRkLX3LNKHS1j/SukGvdZdXh/xzDFxpI+ob29UPKUztj7jlCPxvUtRt3B8tMscP
         bxb9Wb+NDIlohvBcfrZLvQQ6sNccwLDwzRX712xoQYdXSw0ahgJN8SmCJGZ6Bl0iFCIC
         PJR+NFCfGZHn5PtW1Legba6+QMoqiyuBZm+f4aPA3AFWYedzfE1wlXznmmsuycvlneF/
         fC+o1FwXCBsttQIufh3oP/YoUbI2ju48GqQEMszgg6Ghutfm4PR2CPCMR5C42ZC2GviJ
         PWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9UM8IQYrAZfWJT9VJPt22C4nX7BfIu6qh03YcerYMl0=;
        b=2z+ZlGq2YD3IIa4QLx+gjgRVZDMk3lCVNBSu77WORifHYKiLsZ56KGoX5/LLnTATRv
         BIwOIdEYS8NOx2x3gFxAoi3M1Hc7WxuuzuyaRA197tmeO5x41GNLquxKHj7li2wV1agq
         lsV0zdnzUxHxrou6QcBadGBOZB0WJKgsIqmGxwvQc2cU8CQkhrDnP6rVoq9iUdCjZSeH
         rlHSQ2Y9h8VZG7hO9+A0wpX8d5LoKAsp+RizhCSjPWUw5bqN6V8H7dGKw8cNCN8IuK+y
         CNgXhjkc9RRNXdUinoSMwbI/ZyMdXIXFbzpxnQj/oSXyFVNSLxGQC7c9oQATLy5B7T6S
         9QXw==
X-Gm-Message-State: AOAM530GUOqupOf9vWBSKULAiKBkAOzTLjSpoRjhLi/Z5DZaMf+k7niU
        C2e9nMeP+Up97F20bks4Y+59vwCzytDTaw==
X-Google-Smtp-Source: ABdhPJy8GJS5Ixp7/0pzk92FHkv36XYRzz3b7x11yViDPKMJ5cO18qGP38GKJXNXsYrPu/02hlozvQ==
X-Received: by 2002:a1c:f701:0:b0:39c:5539:cc4f with SMTP id v1-20020a1cf701000000b0039c5539cc4fmr9166311wmh.163.1655288446871;
        Wed, 15 Jun 2022 03:20:46 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id l125-20020a1c2583000000b0039c4d9737f3sm1916326wml.34.2022.06.15.03.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:20:46 -0700 (PDT)
Message-ID: <d8683dc2-aad1-dde7-298d-e44772bf0aa6@gmail.com>
Date:   Wed, 15 Jun 2022 11:20:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v2 21/25] io_uring: add
 IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
 <f08c10da-5dac-a704-6c61-395f290b2ef8@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f08c10da-5dac-a704-6c61-395f290b2ef8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 10:34, Hao Xu wrote:
> On 6/14/22 22:37, Pavel Begunkov wrote:
>> @@ -228,7 +249,7 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
>>           return -EINVAL;
>>       mutex_unlock(&ctx->uring_lock);
>> -    ret = io_uring_add_tctx_node(ctx);
>> +    ret = __io_uring_add_tctx_node(ctx, false);
> 
> An question unrelated with this patch: why do we need this, since anyway
> we will do it in later io_uring_enter() this task really submits reqs.

At least we need to allocate a tctx as the files are stored in there


>>       mutex_lock(&ctx->uring_lock);
>>       if (ret)
>>           return ret;

-- 
Pavel Begunkov
