Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210DE65DDCF
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 21:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbjADUqj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 15:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjADUqi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 15:46:38 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C4813EB1
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 12:46:37 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id ay40so26616931wmb.2
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 12:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EfooqjGkto4a/dXf0LvkZ08vcrFxXrz/mFn4bwpM1S8=;
        b=Pk/+L5IEcVJ9zZjmx3mfg/ABxK378XFgzm9OTqiESAR8cAxbe8qVF0gSaQk2cNLUuG
         svApUNzO/gFBd4vh7VpwQX4pVZpe8iwA3aj19/4U/z96Ia6a1x7yJbXzqgK2KJhHZUem
         daXs2DbkHvH1OQPqdNyX/QGsh9Dc7mZTMX9ZmQI0rgnUeNfP4at8zPW8+UyLf/HLzWGy
         2FoO4Tw7gQahqNncgyYht/Ec2Ed8HeMxGTtrDGHJDwIHbE5LetrthK/YGBEs5wBibv0X
         LO0PSybI6D+3PYgQ+ZeN1FoF1g3eE3unMBpQAk2zp01xlINUtRz/mVO1ed/oLUpGVEyq
         TheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EfooqjGkto4a/dXf0LvkZ08vcrFxXrz/mFn4bwpM1S8=;
        b=z9d1pBSqqTPSrKksmbqooBUQO610aQR3Xx7rvAVXDxmQvukhHyYWkvDWIpoeCV/7TI
         TjKcG5E9AcH/wFhayQGFiyZE6bimwmAhJF+4ty9q4CLiI1Wn0w4Q3UeePQC49r4nlBcP
         1ZRGgAY+WsJNuGjp+h8AtMk1VMfmOmjozDI2bXpfb8gseqipMbpnoqr+txouk77HVejd
         JiM/obHy3VOi8x0Elt7x7amF+oU1pZXWPr/xPxg4/t91N2Ev+Re5+VOV0WrQta+d6k+E
         LzMyvOuEDdGIziVC/4WmIxYwppug1UytUO5tI2Ht+mMHl7ogTTj1/JeNw0ksHSEEbOo2
         iiTw==
X-Gm-Message-State: AFqh2kqFnJK+Me+Ww6RN0pK63UfuOw+PomcQl0FR8oJ41lBhDl1eRA0C
        ppqlTZ3COFJxdeLjx7bzL9eUvw3hwnM=
X-Google-Smtp-Source: AMrXdXsPbM3jHId1i6fBQAoA4OfAaBP5jMraX6JIxCd1YXQqiMSz97zQ3OUmeDrt47wBkoXlFkwu/w==
X-Received: by 2002:a05:600c:1f18:b0:3cf:5583:8b3f with SMTP id bd24-20020a05600c1f1800b003cf55838b3fmr33476718wmb.20.1672865195976;
        Wed, 04 Jan 2023 12:46:35 -0800 (PST)
Received: from [192.168.8.100] (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m22-20020a05600c4f5600b003d995a704fdsm31296920wmq.33.2023.01.04.12.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:46:35 -0800 (PST)
Message-ID: <9638d8ff-6995-c7f4-1bbc-dccae70eb936@gmail.com>
Date:   Wed, 4 Jan 2023 20:45:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC v2 09/13] io_uring: separate wq for ring polling
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1672713341.git.asml.silence@gmail.com>
 <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
 <1968c5b9-dd2b-4ed1-14a0-8f78b302bf2d@kernel.dk>
 <894c3092-9561-1a32-fb4c-8bf33e3667a1@gmail.com>
 <75dcfbaf-5822-0b20-5580-1f6ac3ba7f20@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <75dcfbaf-5822-0b20-5580-1f6ac3ba7f20@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/23 20:34, Jens Axboe wrote:
> On 1/4/23 1:28?PM, Pavel Begunkov wrote:
>> On 1/4/23 18:08, Jens Axboe wrote:
>>> On 1/2/23 8:04?PM, Pavel Begunkov wrote:
>>>> Don't use ->cq_wait for ring polling but add a separate wait queue for
>>>> it. We need it for following patches.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    include/linux/io_uring_types.h | 1 +
>>>>    io_uring/io_uring.c            | 3 ++-
>>>>    io_uring/io_uring.h            | 9 +++++++++
>>>>    3 files changed, 12 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>>> index dcd8a563ab52..cbcd3aaddd9d 100644
>>>> --- a/include/linux/io_uring_types.h
>>>> +++ b/include/linux/io_uring_types.h
>>>> @@ -286,6 +286,7 @@ struct io_ring_ctx {
>>>>            unsigned        cq_entries;
>>>>            struct io_ev_fd    __rcu    *io_ev_fd;
>>>>            struct wait_queue_head    cq_wait;
>>>> +        struct wait_queue_head    poll_wq;
>>>>            unsigned        cq_extra;
>>>>        } ____cacheline_aligned_in_smp;
>>>>    
>>>
>>> Should we move poll_wq somewhere else, more out of the way?
>>
>> If we care about polling perf and cache collisions with
>> cq_wait, yeah we can. In any case it's a good idea to at
>> least move it after cq_extra.
>>
>>> Would need to gate the check a flag or something.
>>
>> Not sure I follow
> 
> I guess I could've been a bit more verbose... If we consider poll on the
> io_uring rather uncommon, then moving the poll_wq outside of the hotter
> cq_wait cacheline(s) would make sense. Each wait_queue_head is more than
> a cacheline.

Looks it's 24B, and wait_queue_entry is uncomfortable 40B.

> Then we could have a flag in a spot that's hot anyway
> whether to check it or not, eg in that same section as cq_wait.
> Looking at the layout right now, we're at 116 bytes for that section, or
> two cachelines with 12 bytes to spare. If we add poll_wq, then we'll be
> at 196 bytes, which is 4 bytes over the next cacheline. So it'd
> essentially double the size of that section. If we moved it outside of
> the aligned sections, then it'd pack better.

Than it's not about hotness and caches but rather memory
consumption due to padding, which is still a good argument.

-- 
Pavel Begunkov
