Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7E24A8A95
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 18:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiBCRra (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 12:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiBCRra (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 12:47:30 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2782C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 09:47:29 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id f17so6549019wrx.1
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 09:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=znrMKNBSHwt+8IF1HzGLf7jCvuakzuIz97mrn0VfQe4=;
        b=JKxxG0M/WmTjYUFgUOM0/taTapCtvV5FzO6Rv1QN+oZhkFb4tAutRK2wDWZbUlMRxq
         F7QK4ZjqnR4SQ2BWzbfM4XhLvTkCNiW8RiGXG1O0J6y4MOTV8EI9kXXHeG1TUR72+1vY
         8b4JetAjwbbCgcwNo0RAZlstnSp01CopodmD3Uo4uH+EOD8m36EMBjDC4oALOBkqiYAR
         vKgRUZUqXz4PlsCowoYfB6x9UvIfxFN3hL6g9m0UAf6lW8zG/NzBhbX1l2AnAOZDvEKv
         qWnGzIcYL5jy1lZ7AyjNVRGGTFKM3EPMDmLnaHfP73xfOj4qV70IY7B5RWVTaVIWMG3G
         m/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=znrMKNBSHwt+8IF1HzGLf7jCvuakzuIz97mrn0VfQe4=;
        b=cJyZrHzqBlvNmLJA1SV6afIjz46kUZr5jN6CuRKKyYFQ41Lhn86x/kdNYvD8nDAysO
         NgOue+tH9x2Hg1ZMjXIccMkE/nNlGSV8TVSKAajgc2wI2kwUzirjLMN/JTykJRQYl9/v
         SFraLC3GyHfyblwe0/jAVCiBB6DCcq3z2OisHYR8moxsdLV4Q6DbOsGT13yjztzQnp8T
         UbtYIwxpk0RPkoGl+cPxzSnyMiAvZ31lMl6DNu1Utn4aikPclMKuA8v9wEIpin1D7qEH
         aCrSwwb5dbWNZFGhTk8bdCZLrkYzkp5HX4gw0ktFuFlX/SLEXq4e/JiRzsNdClE5k3jz
         +M3w==
X-Gm-Message-State: AOAM53274MePwDqtW59rBE8zQJ1wzSLFbGyKFplRUBBq3OWPU9NBipQb
        rsfNG6QKmaEQTuBwlH0kIhlPQA==
X-Google-Smtp-Source: ABdhPJxaMocHiPYFyIi2qLgsf/YM7iw1VmTOkuhEQYkZ/daIxL0KzWIbd+foVuT9R5jkU86H+UdFAQ==
X-Received: by 2002:adf:dcc9:: with SMTP id x9mr29421769wrm.591.1643910448288;
        Thu, 03 Feb 2022 09:47:28 -0800 (PST)
Received: from ?IPv6:2a02:6b6d:f804:0:28c2:5854:c832:e580? ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id u7sm7794525wml.7.2022.02.03.09.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 09:47:27 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203151153.574032-1-usama.arif@bytedance.com>
 <20220203151153.574032-2-usama.arif@bytedance.com>
 <f8ff62bf-4435-5da3-949a-fd337a9dfaf7@gmail.com>
From:   Usama Arif <usama.arif@bytedance.com>
Message-ID: <5df97fbf-cea5-c740-ae62-d75cb9390a0d@bytedance.com>
Date:   Thu, 3 Feb 2022 17:47:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f8ff62bf-4435-5da3-949a-fd337a9dfaf7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 03/02/2022 15:48, Pavel Begunkov wrote:
> On 2/3/22 15:11, Usama Arif wrote:
>> This is done by creating a new RCU data structure (io_ev_fd) as part of
>> io_ring_ctx that holds the eventfd_ctx.
>>
>> The function io_eventfd_signal is executed under rcu_read_lock with a
>> single rcu_dereference to io_ev_fd so that if another thread unregisters
>> the eventfd while io_eventfd_signal is still being executed, the
>> eventfd_signal for which io_eventfd_signal was called completes
>> successfully.
>>
>> The process of registering/unregistering eventfd is done under a lock
>> so multiple threads don't enter a race condition while
>> registering/unregistering eventfd.
>>
>> With the above approach ring quiesce can be avoided which is much more
>> expensive then using RCU lock. On the system tested, io_uring_reigster 
>> with
>> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 
>> 15ms
>> before with ring quiesce.
>>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> ---
>>   fs/io_uring.c | 103 +++++++++++++++++++++++++++++++++++++++-----------
>>   1 file changed, 80 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 2e04f718319d..f07cfbb387a6 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -326,6 +326,12 @@ struct io_submit_state {
>>       struct blk_plug        plug;
>>   };
> 
>> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>> +static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx, 
>> struct io_ev_fd *ev_fd)
>>   {
>> -    if (likely(!ctx->cq_ev_fd))
>> +    if (likely(!ev_fd))
>>           return false;
>>       if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>>           return false;
>>       return !ctx->eventfd_async || io_wq_current_is_worker();
>>   }
>> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
>> +{
>> +    struct io_ev_fd *ev_fd;
>> +
>> +    rcu_read_lock();
> 
> Please always think about the fast path, which is not set eventfd.
> We don't want extra overhead here.
> 

I guess this should be ok now from v3?

Thanks,
Usama
> if (ctx->ev_fd) {
>      rcu_read_lock();
>          ev_fd = rcu_deref(...);
>          ...
>          rcu_read_unlock();
> }
> 
