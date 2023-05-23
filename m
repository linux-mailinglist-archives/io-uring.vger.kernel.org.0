Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5803A70DC37
	for <lists+io-uring@lfdr.de>; Tue, 23 May 2023 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjEWMQJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 08:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236650AbjEWMQI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 08:16:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7268D11F
        for <io-uring@vger.kernel.org>; Tue, 23 May 2023 05:15:59 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-510db954476so1268818a12.0
        for <io-uring@vger.kernel.org>; Tue, 23 May 2023 05:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684844157; x=1687436157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F5VQyfQcjo+qJ/UNL/j819CII+/oodYitiAxe+wrpM0=;
        b=KEMm52mot/hrGt6fP7ATITRLd4VF8ERe4V5WEwxfjEXCxOClBeqPeqqGNCeJfuptCn
         OjYychHReW47hdH3WddfLHmVo7XaS4dhN37linkSgDlMXHOVt3l95jb9NK6l6Bvip/jw
         OMYQ38v8OiNBLKQRr9+CzW9+oXHVmndLCgYck1EEoI9dxCpRZ8j4Iw8vWI/N37N9TyMQ
         3wPBmTC+5ZCsEiP0z1iyfOuao/o+Na7vveCpGTt+rRFLeCrZoagSpII3HkrAzjjDSbxq
         6z917cRt3dlNsYyyUTAPFn3j+QM1rdgeQ8Ekdex419PTnPIzR12Wyr9p/5sUIDwW+WIZ
         1YXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684844157; x=1687436157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F5VQyfQcjo+qJ/UNL/j819CII+/oodYitiAxe+wrpM0=;
        b=Kb2FJLf57LL+tlOiyPjFyUKfPzkdEt24xJ4jU30xbW8HDN1xlrrvYcptPClFi1WhXL
         3XaVSH+oUs9v6Fx+R8sBvMAB/sKowkW3w5ONv7KA6X+cY4Hfd8FVizG146fAosrx+w6b
         +F71nf8TAzlbYK2vLVCRlwO/rvAFas30pmE6PwpWpB9EN7gTnocGrL4T0zKEPHtEmepa
         iWLvfSssmyWOoCwVyxG4UEjbW7PS1kIcZ/01UNVlRUmmj8APQVIsjTZcE+6XRIUVVMy/
         WDRp3XxX69AVe59ele3o7TnvaM6iTbkNe92qLiycQpq5rnqaM9zveJl/eMyAWrnbLHSh
         hpWA==
X-Gm-Message-State: AC+VfDwq8BKPjig+kcNCDDnV1U5tFRwntQPsq9AxGtBPZi2mpi90b8TD
        mHkYtrpD04ng0iMmn9tU5OcGvn/UXjU=
X-Google-Smtp-Source: ACHHUZ5OkPul6VEP81xCXFnFUo/+knFqCqXyhdw7DahZ6T4Uz2i04otTeRCR4CNmB/uUX5YaeBP5jg==
X-Received: by 2002:a05:6402:2d5:b0:510:f6e0:7d9f with SMTP id b21-20020a05640202d500b00510f6e07d9fmr12268501edx.13.1684844157257;
        Tue, 23 May 2023 05:15:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:c5cf])
        by smtp.gmail.com with ESMTPSA id q5-20020aa7d445000000b00513f680d2a9sm1328958edr.28.2023.05.23.05.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 05:15:57 -0700 (PDT)
Message-ID: <700f61ec-dc97-4572-d05c-9cbddf3addc8@gmail.com>
Date:   Tue, 23 May 2023 13:08:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/1] io_uring: more graceful request alloc OOM
To:     yang lan <lanyang0908@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
 <CAAehj2nmnN98ZYzcFMR0DsKXqEM7L8DH8SM4NusPqzoHu_VNPw@mail.gmail.com>
 <4ec09942-2855-8be4-3f51-d1fedea8d2f3@gmail.com>
 <CAAehj2kOScdWU6_N+gs-Zo+yCx2Q2_x5vdX3U=Cc8R2=ruJb9Q@mail.gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAAehj2kOScdWU6_N+gs-Zo+yCx2Q2_x5vdX3U=Cc8R2=ruJb9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/22/23 08:55, yang lan wrote:
> Hi,
> 
> Thanks. I'm also analyzing the root cause of this bug.

The repro indeed triggers, this time in another place. Though
when I patch all of them it would fail somewhere else, like in
ext4 on a pagefault.

We can add a couple more those "don't oom but fail" and some
niceness around, but I think it's fine as it is as allocations
are under cgroup. If admin cares about collision b/w users there
should be cgroups, so allocations of one don't affect another. And
if a user pushes it to the limit and oom's itself and gets OOM,
that should be fine.

> By the way, can I apply for a CVE? And should I submit a request to
> some official organizations, such as Openwall, etc?

Sorry, but we cannot help you here. We don't deal with CVEs.

That aside, I'm not even sure it's CVE'able because it shouldn't
be exploitable in a configured environment (unless it is). But
I'm not an expert in that so might be wrong.



> Pavel Begunkov <asml.silence@gmail.com> 于2023年5月22日周一 08:45写道：
>>
>> On 5/20/23 10:38, yang lan wrote:
>>> Hi,
>>>
>>> Thanks for your response.
>>>
>>> But I applied this patch to LTS kernel 5.10.180, it can still trigger this bug.
>>>
>>> --- io_uring/io_uring.c.back    2023-05-20 17:11:25.870550438 +0800
>>> +++ io_uring/io_uring.c 2023-05-20 16:35:24.265846283 +0800
>>> @@ -1970,7 +1970,7 @@
>>> static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
>>>           __must_hold(&ctx->uring_lock)
>>>    {
>>>           struct io_submit_state *state = &ctx->submit_state;
>>> -       gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
>>> +       gfp_t gfp = GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY;
>>>           int ret, i;
>>>
>>>           BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
>>>
>>> The io_uring.c.back is the original file.
>>> Do I apply this patch wrong?
>>
>> The patch looks fine. I run a self-written test before
>> sending with 6.4, worked as expected. I need to run the syz
>> test, maybe it shifted to another spot, e.g. in provided
>> buffers.
>>
>> --
>> Pavel Begunkov

-- 
Pavel Begunkov
