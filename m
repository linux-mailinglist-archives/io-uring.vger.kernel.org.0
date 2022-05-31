Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AF05398D7
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 23:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbiEaVfv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346162AbiEaVfu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 17:35:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F02A50E06
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 14:35:49 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e25so9696316wra.11
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q7cPNpK/kLXhrzfLG8hpxXs2i5SQM9UbFaXm5pBmiWk=;
        b=PV1FkrmCwNgQDmI8q8xLaJ2XXBLk0bNuhuDAAdA7z4qZycq5Kcw00mLFrAIu2AIerb
         aJ4XncmF1wRGhrUBOJwYE2sY42AwXhyxj+2MGoQf+bXIPVUkYNW77hJDONwaiqlOTO9b
         BtiMM4rWkZaUNlXNxA+N1HVP09ugDb+rIgPHBswnSKcLTO/PNaHzvTrV2tfuBryAVzBa
         TwPLTSz7WrYluB/KbKVt7WUxqS/gOs8qZeglcJFpA9cw2QEShrMQ0vFQywI7rrt0gmmZ
         htLEJNTq5WnH0e/YcE/ed7oZXgJxRwpxbG78X5YFRt1oKKpR+4Rj+cIHhSE8/puDCU6P
         kQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q7cPNpK/kLXhrzfLG8hpxXs2i5SQM9UbFaXm5pBmiWk=;
        b=jn6lpyt1R+WPoc4K6b7a2HwrRg4KIygNg7YUr7yVqqGVUvw00FXZ0vQmc6dypur9W1
         z5DIr/UNwFG1I3J/lNEu/+Tpa11wH5p8dXVI9xg6XNahokiOyoMJxm9+UFK5HcWr9PU8
         kv6jG92E/faY/icdXpyeNjYpRiwJXMogkTfYU+AIlONyFxjJIV1K10nWf7VYltwrs4GE
         yob0WhUvlJPy6dq2TpWspMk9ODGnw8Pi1AxA2wCd6K/O8sVgVjvml8m/ryBajq8/2Zjg
         xofS2wbjapv/qx32mIk2PCUxOnO4qwPuZCOrfp/msMO/CarTqMs+B4q1hXHUkv4gr3Lf
         XsQA==
X-Gm-Message-State: AOAM530VeKUVVtm6Liz3EArYrqSgwb2mP8gDbmPV49y9r5XMv0ecMguK
        4K/LZy1K8vufyJuld4bU4iuysg==
X-Google-Smtp-Source: ABdhPJw4Mim9U84gjy0lO8KtDTbCtU1/Xmv0b6riP55K6OPLXzvaiil7aFdrqwfGiT3xnn8hZaBnYg==
X-Received: by 2002:adf:d1ca:0:b0:210:1945:34c6 with SMTP id b10-20020adfd1ca000000b00210194534c6mr18528567wrd.334.1654032947950;
        Tue, 31 May 2022 14:35:47 -0700 (PDT)
Received: from ?IPV6:2a02:6b6a:b497:0:359:2800:e38d:e04f? ([2a02:6b6a:b497:0:359:2800:e38d:e04f])
        by smtp.gmail.com with ESMTPSA id s14-20020a7bc38e000000b003942a244ee7sm3138190wmj.44.2022.05.31.14.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 14:35:47 -0700 (PDT)
Message-ID: <f7a4cdf2-78f2-fead-5a10-713e3dc9ea34@bytedance.com>
Date:   Tue, 31 May 2022 22:35:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/5] io_uring: add opcodes for current working directory
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220531184125.2665210-1-usama.arif@bytedance.com>
 <da4e94f7-94ce-ad57-ad15-c9117c4fef2d@kernel.dk>
 <7a311f7e-a404-4ebe-f90b-af9068bab2fc@bytedance.com>
 <d466213e-81e0-4b0e-c1a4-824bcbe42f74@kernel.dk>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <d466213e-81e0-4b0e-c1a4-824bcbe42f74@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 31/05/2022 20:22, Jens Axboe wrote:
> On 5/31/22 1:18 PM, Usama Arif wrote:
>>
>>
>> On 31/05/2022 19:58, Jens Axboe wrote:
>>> On 5/31/22 12:41 PM, Usama Arif wrote:
>>>> This provides consistency between io_uring and the respective I/O syscall
>>>> and avoids having the user of liburing specify the cwd in sqe when working
>>>> with current working directory, for e.g. the user can directly call with
>>>> IORING_OP_RENAME instead of IORING_OP_RENAMEAT and providing AT_FDCWD in
>>>> sqe->fd and sqe->len, similar to syscall interface.
>>>>
>>>> This is done for rename, unlink, mkdir, symlink and link in this
>>>> patch-series.
>>>>
>>>> The tests for these opcodes in liburing are present at
>>>> https://github.com/uarif1/liburing/tree/cwd_opcodes. If the patches are
>>>> acceptable, I am happy to create a PR in above for the tests.
>>>
>>> Can't we just provide prep helpers for them in liburing?
>>>
>>
>> We could add a io_uring_prep_unlink with IORING_OP_UNLINKAT and
>> AT_FDCWD in liburing. But i guess adding in kernel adds a more
>> consistent interface? and allows to make calls bypassing liburing
>> (although i guess people probably don't bypass liburing that much :))
> 
> I'm not really aware of much that doesn't use the library, and even
> those would most likely use the liburing man pages as that's all we
> have. The kernel API is raw. If you use that, I would expect you to know
> that you can just use AT_FDCWD!
> 
>> Making the changes in both kernel and liburing provides more of a
>> standard interface in my opinion so maybe it looks better. But happy
>> to just create a PR in liburing only with prep helpers as you
>> suggested if you think that is better?
> 
> I don't disagree with that, but it seems silly to waste 5 opcodes on
> something that is a strict subset of something that is already there.
> Hence my suggestion would be to just add io_uring_prep_link() etc
> helpers to make it simpler to use, without having to add 5 extra
> opcodes.
> 

Thanks, I have created a PR for it on 
https://github.com/axboe/liburing/pull/588. We can review it there if it 
makes sense!
