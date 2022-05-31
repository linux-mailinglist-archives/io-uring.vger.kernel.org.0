Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEE7538D62
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 11:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245057AbiEaJC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 05:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbiEaJC4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 05:02:56 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E821553E3A
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:02:54 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id z17so7639612wmf.1
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ldJqV57KZDEDyhCMD9c1wAnClBeBjo5zKGSW6aR1hY8=;
        b=Yzsv41l7FyL2MIYgLFq9mR/QRgsvD+uyqkxbetePlSpBdZ9hV9kY+pJcnXKEfLOx+u
         LzWM6Djk4PFrZCnfl4P/iioASPV7p7jseqiWK9hP3Zf5uAxpONRyUrlax/AZqu2xsqbL
         H3UzoApP1M/bRo9b3O9FBELQzAXASJprSxU+t2hjn0Tqn5rWUFCT9dk4x6OwK4eOKhkS
         P71n2hi5aWVRAKBR/xNvp6lOjD616zyNY+oJWP0fCvGXp1u6nDjNdRnWpa7FNLg65oN/
         P2NhtKoemTsNnHVdJNCvmCgWIiVQ0qwtVtVFqfM6isLX6Qgnlxuu2XvW3Cm9X+IHWAOT
         UhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ldJqV57KZDEDyhCMD9c1wAnClBeBjo5zKGSW6aR1hY8=;
        b=ik3jtz3GGdbUV4Yt0ZcDwoJhfF49E5cH+1DiKce8B2CpjrgEcKcRxcFcNMXwZLWudD
         yA4weIkgI4MQY1wZzC04cv4BAWxXz0X5HM2v+sN9cMLda+VL5w0CLF7FeZshcbyjGMqB
         vc3XTgPubgoQlC+FaTZhK0xkTYJd11FVfSzYPM+tOp7g1jc2TdLhojM4xsdtBaK+BKU+
         tATP8XEPTmAsNnapC7g5oB6s34wWmPwnkTwM/53SoKVT6pOL/PZAQ1amwMTkfzyXfWtc
         Z1Uz7CtfIOvsgcl5deZihO4sLUq69YtH+iPHxDl1jaac9Tn2RfwXLfR8kF4tDjGCeztJ
         8qRQ==
X-Gm-Message-State: AOAM532IdnnbmzLvtPaWPjMU0QP6pdN1HyPhI43asYqcqHMvEYcjBfJw
        uwSqIpMUIj2cQ0Sf+bR1sWqxTg==
X-Google-Smtp-Source: ABdhPJwq1+4a1G6Yyyg3h7TY1YkqZK8c2TDjtUZIQydS5ZneNM+nqQsmhmGgivlZ7ckaNcYt2K83tQ==
X-Received: by 2002:a7b:c394:0:b0:397:32b4:76f8 with SMTP id s20-20020a7bc394000000b0039732b476f8mr22851685wmj.33.1653987773463;
        Tue, 31 May 2022 02:02:53 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c3b9600b00397342e3830sm2920452wms.0.2022.05.31.02.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 02:02:52 -0700 (PDT)
Message-ID: <fe039776-eb95-e451-b372-aafa56db45c7@kernel.dk>
Date:   Tue, 31 May 2022 03:02:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v4 00/11] fixed worker
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
 <1071c09c-8670-b883-5b64-2cd1fb69d943@icloud.com>
 <6e0e18e8-79d6-92e5-99cc-0b074a04fb69@kernel.dk>
 <2e40c83a-c482-9cbb-0319-dae47e6a966d@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2e40c83a-c482-9cbb-0319-dae47e6a966d@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/22 2:55 AM, Hao Xu wrote:
> On 5/31/22 16:46, Jens Axboe wrote:
>> On 5/31/22 1:05 AM, Hao Xu wrote:
>>> On 5/15/22 21:12, Hao Xu wrote:
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> This is the second version of fixed worker implementation.
>>>> Wrote a nop test program to test it, 3 fixed-workers VS 3 normal workers.
>>>> normal workers:
>>>> ./run_nop_wqe.sh nop_wqe_normal 200000 100 3 1-3
>>>>           time spent: 10464397 usecs      IOPS: 1911242
>>>>           time spent: 9610976 usecs       IOPS: 2080954
>>>>           time spent: 9807361 usecs       IOPS: 2039284
>>>>
>>>> fixed workers:
>>>> ./run_nop_wqe.sh nop_wqe_fixed 200000 100 3 1-3
>>>>           time spent: 17314274 usecs      IOPS: 1155116
>>>>           time spent: 17016942 usecs      IOPS: 1175299
>>>>           time spent: 17908684 usecs      IOPS: 1116776
>>>>
>>>> About 2x improvement. From perf result, almost no acct->lock contension.
>>>> Test program: https://github.com/HowHsu/liburing/tree/fixed_worker
>>>> liburing/test/nop_wqe.c
>>>>
>>>> v3->v4:
>>>>    - make work in fixed worker's private worfixed worker
>>>>    - tweak the io_wqe_acct struct to make it clearer
>>>>
>>>
>>> Hi Jens and Pavel,
>>> Any comments on this series? There are two coding style issue and I'm
>>> going to send v5, before this I'd like to get some comment if there is
>>> any.
>>
>> I'll try to find some time to review it, doing a conference this week.
> 
> No worries.
> 
>> Rebasing on the current for-5.20/io_uring branch would be a good idea
>> anyway.
> 
> I'll do that.

When you do, most/all patches also have:

From: Hao Xu <haoxu.linux@gmail.com>

From: Hao Xu <howeyxu@tencent.com>

which is a bit confusing, so probably choose one and go with that :-)

-- 
Jens Axboe

