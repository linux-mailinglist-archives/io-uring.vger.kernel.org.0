Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42034FE5A6
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240031AbiDLQSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbiDLQSs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:18:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC6B55BED
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:16:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i20so15339725wrb.13
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MM7N+kbpLnlrJyMUJI0G0t73IamAO0gxJPQzf5EXjKg=;
        b=YgWlVGc4FjbtPpTK3paXeUKeYqwf2tdJVD9dcguM04Xydph+R64g9EQn/HfDDaB+PL
         v7Q6PBP0MAqi0FRBeUWWP6kcvuKHrOud4dgTlyzTZyKwq0P6qL4/4PUJ5R/jVrL39k6k
         HpPmv2QCZJt7NQ+4f11XC6t7n3LkrnejiXBgwp+rZnJwp2hFakHWvKZAZjDTocRNShZv
         j6SyAwMFUctwkHBOIusZ32S71CKTelcG/A5Y8vNazg2O0KNC0BXg2p6PBywNqHYw3hK5
         Rs4GLa1PY54fuKNQWlMWTXG9cTP3nAWATJ+SilB+lZ4ZfVKYnORvorRC3WgtZ7Axhrxq
         CpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MM7N+kbpLnlrJyMUJI0G0t73IamAO0gxJPQzf5EXjKg=;
        b=QosxzibVT+y2xgxYtyTCBm4cgty40l9tHD87hQkxuy6s4nsWsWQuJBc43QLyAUsl4t
         uTvXU1bLXBlHG6aOzVY11lxj7K3aKIiqHySWgH3Tl/CFBmrbc+1RLtYNL/Au19jlKD8b
         nCn40sTAkHfu5ONCnDZn5Hp05a/XeL6YMZqGAs36F6odLxaJGUYeyG17BmAkWh7n0yaP
         HP/2YMXH3e+1ex7fnDDfe94lJjVW9ql+z7u/Y3M2Rosx6Lb0v5lYwwgfbfpCxMN2AEon
         BCC129hVGVLfiGGhTtMU+iyEQC20XdkC8T/gYbrJJ2CnbvmxgThCOlGTU8s8AK+KKtLl
         Jpfg==
X-Gm-Message-State: AOAM532UxhyY4AZ7D4kUY+2oz+60f7Ko6mn/sWKcyRrBF2VU82M6NOvu
        1oIAyn7QC/hqw5vGM617fHY=
X-Google-Smtp-Source: ABdhPJxIVyJsNj4zNqQHI6B/6VXKfrouhEkMLRlntLsYfRF53uEGTmEtpI9M/QebcpqMeI12ngHNoQ==
X-Received: by 2002:a05:6000:144c:b0:204:1cc6:7194 with SMTP id v12-20020a056000144c00b002041cc67194mr29266525wrx.255.1649780187038;
        Tue, 12 Apr 2022 09:16:27 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id v188-20020a1cacc5000000b0038e9c60f0e7sm2765840wme.28.2022.04.12.09.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 09:16:26 -0700 (PDT)
Message-ID: <bfede80f-b712-f34e-47d7-a81bd7f17afb@gmail.com>
Date:   Tue, 12 Apr 2022 17:15:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 9/9] io_uring: optimise io_get_cqe()
Content-Language: en-US
To:     Florian Schmaus <flo@geekplace.eu>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1649771823.git.asml.silence@gmail.com>
 <487eeef00f3146537b3d9c1a9cef2fc0b9a86f81.1649771823.git.asml.silence@gmail.com>
 <49f6ed82-0250-bb8c-d12a-c8cce1f72ad2@geekplace.eu>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <49f6ed82-0250-bb8c-d12a-c8cce1f72ad2@geekplace.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 17:06, Florian Schmaus wrote:
> On 12/04/2022 16.09, Pavel Begunkov wrote:
>> io_get_cqe() is expensive because of a bunch of loads, masking, etc.
>> However, most of the time we should have enough of entries in the CQ,
>> so we can cache two pointers representing a range of contiguous CQE
>> memory we can use. When the range is exhausted we'll go through a slower
>> path to set up a new range. When there are no CQEs avaliable, pointers
>> will naturally point to the same address.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 46 +++++++++++++++++++++++++++++++++++-----------
>>   1 file changed, 35 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index b349a3c52354..f2269ffe09eb 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -416,6 +416,13 @@ struct io_ring_ctx {
>>       unsigned long        check_cq_overflow;
>>       struct {
>> +        /*
>> +         * We cache a range of free CQEs we can use, once exhausted it
>> +         * should go through a slower range setup, see __io_get_cqe()
>> +         */
>> +        struct io_uring_cqe    *cqe_cached;
>> +        struct io_uring_cqe    *cqe_santinel;
> 
> I think this should s/santinel/sentinel.

Indeed, thanks

-- 
Pavel Begunkov
