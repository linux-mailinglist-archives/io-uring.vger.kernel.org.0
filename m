Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F334C43FDAE
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 15:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhJ2OAW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhJ2OAW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 10:00:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BF2C061570
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 06:57:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u18so16324803wrg.5
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 06:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zu1HQVzk1S7MRv2jDaEGFE2LWMXbxBHr3gLFHXikkzw=;
        b=NJ6US8bRv/NI16VblLjYvjjq2P1ZrfJKhgOaCYz9bDGQk4y9JS8ZqALJC/Vf0imOnp
         h3OoN4gMIT5+ZHGZRwSYm3efieRGirCVmRCWjendkMVgW7nCoQKZC/9Gcq0tkDv50SFL
         43T3cGNJemay5TnkOTPuu+3LSLOzLMFabLrZh5rSKcM98Abd1Czi8J95L1uCZhlwG7e8
         oNbH88m/cRMsjy1mmS5BWo/xCA4zC/ghh279qazviWlv148uOfrkkzz9DCrPmtx/lW7/
         NLWdCX4li6Q9CbGki6yBkOXtH3frAa2XxQfaonCx5uVzgla10KG9nEeHMqxXGZeNosyh
         Vcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zu1HQVzk1S7MRv2jDaEGFE2LWMXbxBHr3gLFHXikkzw=;
        b=hLO+jPoyX65mJDC1P7s6XOquAnfrl/Ldhm+OJ6NphLoT0NhntJT1DcoOKhwnMaPR8P
         UNftfN6vLqTr4T7yTkNUlW4Kb2jQz65u5+ZyzW8HlLZcnjmm41jcrDQSaw8tQX+U0sxi
         aOVY8LPfmAV/B9xNZFATTYx5l3Y983Z95gQ8qX7rqxbm5N41D4b+q/KljgG2r61Gfd+2
         fy/dLSiYCa4vlwNDuaRJ92L37MIvgXeUnMIMeO5AgQgVmZmn9zra7IiCTQx6I74ysQn6
         rmEfALzBpODJUBlAMUpjiOVB9iOkWDub0+IODuRYwnyJy/5ETWwmliH0VHKnQ3cKbHKM
         XT4A==
X-Gm-Message-State: AOAM5335nAWaJhe6epb3C3jRgIJ9nFYoXXkBw8VMMeasQWU0Xvoy4E3c
        OGAKyTWojfbuYYP+4AwPUbFQNBunFeU=
X-Google-Smtp-Source: ABdhPJzklVxnwwAfEyM9I2HF9T1jZl8POyDL3ZQ7Cz3P0s1FrVyZp9Cp9V3hGX5hG5lJi9MUtc38Ig==
X-Received: by 2002:adf:e389:: with SMTP id e9mr14158695wrm.117.1635515871041;
        Fri, 29 Oct 2021 06:57:51 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id g2sm5640108wrq.62.2021.10.29.06.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 06:57:50 -0700 (PDT)
Message-ID: <172d0e03-4560-a686-82cd-f6cd6d12da6c@gmail.com>
Date:   Fri, 29 Oct 2021 14:57:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH liburing] io-cancel: add check for -ECANCELED
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211019092352.29782-1-haoxu@linux.alibaba.com>
 <ed9793a5-92e8-f5d9-3a33-d263bf5e760e@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ed9793a5-92e8-f5d9-3a33-d263bf5e760e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/29/21 13:27, Hao Xu wrote:
> ping this one since test/io-cancel will be broken
> if the async hybrid logic merges to 5.16
> 在 2021/10/19 下午5:23, Hao Xu 写道:
>> The req to be async cancelled will most likely return -ECANCELED after
>> cancellation with the new async bybrid optimization applied. And -EINTR
>> is impossible to be returned anymore since we won't be in INTERRUPTABLE
>> sleep when reading, so remove it.
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   test/io-cancel.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/test/io-cancel.c b/test/io-cancel.c
>> index b5b443dc467b..c761e126be0c 100644
>> --- a/test/io-cancel.c
>> +++ b/test/io-cancel.c
>> @@ -341,7 +341,7 @@ static int test_cancel_req_across_fork(void)
>>                   fprintf(stderr, "wait_cqe=%d\n", ret);
>>                   return 1;
>>               }
>> -            if ((cqe->user_data == 1 && cqe->res != -EINTR) ||
>> +            if ((cqe->user_data == 1 && cqe->res != -ECANCELED) ||

cqe->res != -ECANCELED && cqe->res != -EINTR?

First backward compatibility, and in case internals or the test
changes.

>>                   (cqe->user_data == 2 && cqe->res != -EALREADY && cqe->res)) {
>>                   fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
>>                   exit(1);
>>
> 

-- 
Pavel Begunkov
