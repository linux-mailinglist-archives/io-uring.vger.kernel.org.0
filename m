Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385BF51E4A9
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 08:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbiEGGqh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 02:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbiEGGqg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 02:46:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7014863C5;
        Fri,  6 May 2022 23:42:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e24so8855783pjt.2;
        Fri, 06 May 2022 23:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=uDYYK0Fj+uUZkjFzaGqTdzReaL9mPitJtDVBnfx9TFE=;
        b=RWj10dAM7328cITCqLPZxKNBHiIP2VBhiOG0YbCUEPdCXsxUPB1J/sqmftI0u+WJ++
         dXXeCpO6ybZsS4h6QuKTCUQP/yq4tEaoVjJU/Di6BrSTV4yw/eFqmoH6tZ4mwmQP4wBT
         JFMWfpJiQInyVlCaOmP9yvUwI8m5P4LnxAKkYrcTQdc7PaYXf3p2ss8KTjOMF3MltHBC
         eChj6UB8R8fwYYsrugsHDRb+p4G/AjR6YlVMpq7dIDfMRygTOFuanOHqREpX7I1yfyVU
         X5d7MQzG9PnQhnpU1tXJ9PihzNmJ6X4L/ltepjVlX/+mXqjKv8H4EmeL6eNzfcaYP/+m
         VszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uDYYK0Fj+uUZkjFzaGqTdzReaL9mPitJtDVBnfx9TFE=;
        b=HvUa/ROALwTa+uHuxshljNPbckRCgCSNMpdY8+MQ9TyMHoEhfSWBD9BvhVD6JxAxQc
         CHWmcnb2SB89h37ZnQM5fRxOIeDJNLgXE7jUtkApCOFR1ZS1hAWDbyeKaA2n5id2Ygk3
         4QqzMn7LfJM63jr7FyfALynHZIuwWZSd0s+glOxUbb3Nq4/cjSnncAirUxauGsMSwOm/
         HMU0VRZ8dpBnRmbgwuA5NFzXJA+kV3UXLybex/Ca40Hk7XlIYw5ceracepsSkTzsZIfF
         kLMO9o0SMd/xx+uvxEkp/8j547gM1wpEMVyEkHLEvDQHb3C5cAeeTI7631nswmJiQgSy
         cmbA==
X-Gm-Message-State: AOAM531HA+cmKl2pXJ1+YmvttTlLi5x3jpmOGA/BiJDK1e9gu/TwytmP
        YA6l/WjylYFytsxm6h3nu8I=
X-Google-Smtp-Source: ABdhPJwpfPeuLpzXH4PC/892IW17e6XhasjpGT05YKNXunBiBaCaRDQIiPjYPa3x6ViD9m9ENDeUIQ==
X-Received: by 2002:a17:902:9a4c:b0:156:6735:b438 with SMTP id x12-20020a1709029a4c00b001566735b438mr7340365plv.46.1651905770975;
        Fri, 06 May 2022 23:42:50 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id ev17-20020a17090aead100b001cb6527ca39sm8660296pjb.0.2022.05.06.23.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 23:42:50 -0700 (PDT)
Message-ID: <6f59afd3-a591-90fd-0428-3572d910b689@gmail.com>
Date:   Sat, 7 May 2022 14:43:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 4/5] io_uring: add a helper for poll clean
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-5-haoxu.linux@gmail.com>
 <28b1901e-3eb2-2a50-525c-62e1aa39eaac@gmail.com>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <28b1901e-3eb2-2a50-525c-62e1aa39eaac@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 上午12:22, Pavel Begunkov 写道:
> On 5/6/22 08:01, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Add a helper for poll clean, it will be used in the multishot accept in
>> the later patches.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   fs/io_uring.c | 23 ++++++++++++++++++-----
>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index d33777575faf..0a83ecc457d1 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5711,6 +5711,23 @@ static int io_accept_prep(struct io_kiocb *req, 
>> const struct io_uring_sqe *sqe)
>>       return 0;
>>   }
>> +static inline void __io_poll_clean(struct io_kiocb *req)
>> +{
>> +    struct io_ring_ctx *ctx = req->ctx;
>> +
>> +    io_poll_remove_entries(req);
>> +    spin_lock(&ctx->completion_lock);
>> +    hash_del(&req->hash_node);
>> +    spin_unlock(&ctx->completion_lock);
>> +}
>> +
>> +#define REQ_F_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
>> +static inline void io_poll_clean(struct io_kiocb *req)
>> +{
>> +    if ((req->flags & REQ_F_APOLL_MULTI_POLLED) == 
>> REQ_F_APOLL_MULTI_POLLED)
> 
> So it triggers for apoll multishot only when REQ_F_POLLED is _not_ set,
> but if it's not set it did never go through arm_poll / etc. and there is
> nothing to clean up. What is the catch?

No, it is triggered for apoll multishot only when REQ_F_POLLED is set..
> 
> btw, don't see the function used in this patch, better to add it later
> or at least mark with attribute unused, or some may get build failures.
Gotcha.
> 
> 
>> +        __io_poll_clean(req);
>> +}
>> +
>>   static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>>   {
>>       struct io_accept *accept = &req->accept;
>> @@ -6041,17 +6058,13 @@ static void io_poll_task_func(struct io_kiocb 
>> *req, bool *locked)
>>   static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>>   {
>> -    struct io_ring_ctx *ctx = req->ctx;
>>       int ret;
>>       ret = io_poll_check_events(req, locked);
>>       if (ret > 0)
>>           return;
>> -    io_poll_remove_entries(req);
>> -    spin_lock(&ctx->completion_lock);
>> -    hash_del(&req->hash_node);
>> -    spin_unlock(&ctx->completion_lock);
>> +    __io_poll_clean(req);
>>       if (!ret)
>>           io_req_task_submit(req, locked);
> 

