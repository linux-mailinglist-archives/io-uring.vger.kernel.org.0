Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFF3637FCC
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 20:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKXTwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 14:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKXTwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 14:52:40 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDA718B32
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:52:37 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d1so3833266wrs.12
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=blgZWTyC4M0pInI/5OKin9+sHfGL/5r8tfuuWektEGs=;
        b=dUi229HpRuLRrjgPh9W2Ulq+37MytxZpd4L4HMxJRB+YLoM5aZwkVpRHYC48vGqlfa
         CHUFS/AkBCw64sek9lR1mrfVSVJc3FnwlhIExFON2tluNjeoMt71vCokVbddkzCszj5J
         iqSAdkQK3iqyHLmjdIlzbb6ISeq0SKZ2rQk2axno9RKS0NckMbe6zObys/kLv+THWjUN
         XZj4ZGM1x/hOmahkSRASc0zIu4RhckLjzF1dL0wDEaJ7+3VKE1ZcXLjRfDr1anLlWyaj
         0D/nnbO9XkUQh5PY2S0wGy/sHy42WsIavMi0U03HBTDG8ZX6WhhP7KoCuNvMLFY23Mdt
         XECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=blgZWTyC4M0pInI/5OKin9+sHfGL/5r8tfuuWektEGs=;
        b=ImfyeFNA0XEietAZeFtqHxGX3YjrNw03o8GNmmK1PgzLSIFJNtHcwe2Voix4FI/Ozp
         F/Q6uzIlOxx152pO1racVW/6stYHxnkCWwNzfyT3EkfsNUjn02ytABh1oIhq3pXoHQWL
         aD6dwLH/GAwJ1bb49QyEBC4tH6jFWN6caaQiXSorziGWq9CUZTrI2U/3lcew9MWjZmyA
         gTm//+1vYLToiXhFpjsjSWBsElKYJdxFh4kCZGdjNBMNLtWg7kWfx2YnXVHrSwJmaEzw
         ArkBQtVzsii/tiBIElqBZ8IK0raflv9CGZ/OebTHMsFH2oXvcfK1UExZsfKaEdhyS5cL
         r/qQ==
X-Gm-Message-State: ANoB5pnHUB5o2KlaVTNYtOsOWuQOdM80hoRulc45bQXjbl8CH4Bof82r
        CpcYKo2ZCs4uL1YOYKScj7IDcdw6ewM=
X-Google-Smtp-Source: AA0mqf7JIGRgq9MXWTzj564dDS+/NZKgKLRh7fuSt7bDoY3G2HKKjDaSKbdV/pVUVUvaMO2gmxelfg==
X-Received: by 2002:adf:fe05:0:b0:241:fe4c:535e with SMTP id n5-20020adffe05000000b00241fe4c535emr2554869wrr.478.1669319556446;
        Thu, 24 Nov 2022 11:52:36 -0800 (PST)
Received: from [192.168.8.100] (188.28.226.30.threembb.co.uk. [188.28.226.30])
        by smtp.gmail.com with ESMTPSA id s16-20020adff810000000b002368a6deaf8sm2096465wrp.57.2022.11.24.11.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 11:52:36 -0800 (PST)
Message-ID: <0eeed468-6500-8e55-3697-986f1ba22183@gmail.com>
Date:   Thu, 24 Nov 2022 19:51:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] io_uring: kill io_cqring_ev_posted() and
 __io_cq_unlock_post()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
 <c03977b8-85a1-5984-ebda-8a0c7d0087d2@gmail.com>
 <bd80da09-a433-1ea6-6a0c-bbb335b5187d@kernel.dk>
 <40e17ac2-8c02-9d04-fab0-d7e29db89bab@gmail.com>
 <672d1714-7bf6-db8e-39ae-daa7f155d2c4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <672d1714-7bf6-db8e-39ae-daa7f155d2c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/22 19:29, Jens Axboe wrote:
> On 11/24/22 12:17?PM, Pavel Begunkov wrote:
>> On 11/24/22 18:46, Jens Axboe wrote:
>>> On 11/24/22 9:16?AM, Pavel Begunkov wrote:
>>>> On 11/21/22 14:52, Jens Axboe wrote:
>>>>> __io_cq_unlock_post() is identical to io_cq_unlock_post(), and
>>>>> io_cqring_ev_posted() has a single caller so migth as well just inline
>>>>> it there.
>>>>
>>>> It was there for one purpose, to inline it in the hottest path,
>>>> i.e. __io_submit_flush_completions(). I'll be reverting it back
>>>
>>> The compiler is most certainly already doing that, in fact even
>>
>> .L1493:
>> # io_uring/io_uring.c:631:???? io_cq_unlock_post(ctx);
>> ????movq??? %r15, %rdi??? # ctx,
>> ????call??? io_cq_unlock_post??? #
> 
> Doubled checked here, and you're actually right:
> 
>      55bc:       94000000        bl      4760 <io_cq_unlock_post>
> 
> Huh, that's very odd that it doesn't inline it. It doesn't even it I
> mark it inline, __always_inline gets it done.

That's odd as well for a function of this size

>> Even more, after IORING_SETUP_CQE32 was added I didn't see
>> once __io_fill_cqe_req actually inlined even though it's marked
>> so.
> 
> Doesn't seem to be inlined here either. Compiler:
> 
> gcc (Debian 12.2.0-9) 12.2.0
> 
>>> __io_submit_flush_completions() is inlined in
>>> io_submit_flush_completions() for me here.
>>
>> And io_submit_flush_completions is inlined as well, right?
>> That would be quite odd, __io_submit_flush_completions() is not
>> small by any means and there are 3 call sites.
> 
> io_submit_flush_completions() doesn't get inlined,
> __io_submit_flush_completions() gets inlined in
> io_submit_flush_completions().

Then the compiler is drunk. It doesn't inline the function
explicitly marked inline but does it for a non-inline one.
Unless it's PGO'ed I can't think of a sane reason for it.

-- 
Pavel Begunkov
