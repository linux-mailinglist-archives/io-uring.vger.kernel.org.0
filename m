Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F6C59BF06
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 13:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiHVLyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 07:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiHVLx7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 07:53:59 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B84A1EC69
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 04:53:45 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id k9so12912565wri.0
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 04:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=mDWV17WTrbRiFGQAzMvBm+wSuCm/m0ADxHNgtnL4HO8=;
        b=DUtg7QbH4E5GnP0o0tqyevDy96uGpUrVt12pVnZeuW4Jhn6vY8D+7UHW1lHgC4PPm6
         WyJyGtYRmV4La6S1mDiPd53ZkbCaeAlgt9n93b5ycKHIBFqpTrp+0dtEE+B5VTHZtKNJ
         UCF/sGyOQhGmYbxO9WAmFvhb+gB9ItE2fHDk6K4u4k3/MoqTqh41he6b2Nn/XRjmG480
         mIKlrGmxFAeEZ/QU2sHYqPBOz9CbtlMDi9+lkalwtzMFH3S98r9/8l/YnrETzqbH9lY/
         LFw9VC1w50AqxSPaqGXhMB0Z1e86zYCA7Zu8ZX3tQiWYuACNXLhc96W9BCnhUwCkfHKc
         5+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=mDWV17WTrbRiFGQAzMvBm+wSuCm/m0ADxHNgtnL4HO8=;
        b=1qzxWM5eh8SIBYscw48PazxyH+UAJIvvHMs1QqAEDDbBGOXthhps3U0MZPzmGfgjED
         q8s4sT3fYYVvKkxL/jN4Zi8XmN9+a9sUxqhOYY4KGabyZ99yDB9WHVvuzoRKoFDEtaUJ
         qTImS0zrzxm5MiPKzLSyl11BKWMaLX+MrplLTuHOY3dLML7M60Ws5QeuBGL4X1eezLf+
         n379N4W7PRPRqi/aYdyHX4nb2WeSar6v4PJG3LsWhlLJ/LnojZHVS8NLXV1WfPO7R6q5
         ZCb4/abanYlW5EdnWOrz2njMxjg63pFZB9odp/WxAouoOzaBVPhQp5LWfyqwtnTdKGe3
         EzOg==
X-Gm-Message-State: ACgBeo2NH3rG50++1Y1cWI4G6UhqaafF0DnIAEj7W708avSK3iQZgwhw
        mqVmbHsNKQEwrbplVNgzn+E=
X-Google-Smtp-Source: AA6agR4okDfsSYr2dEkB5y4+Wf4BrKBQolBHyn9IurDFCkI+WTmkXBRTTlRbaopsVnRolydxFe4uMg==
X-Received: by 2002:a5d:5228:0:b0:225:5858:b7d3 with SMTP id i8-20020a5d5228000000b002255858b7d3mr3263254wra.591.1661169223575;
        Mon, 22 Aug 2022 04:53:43 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id c7-20020adffb07000000b0021d6924b777sm11491725wrr.115.2022.08.22.04.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 04:53:43 -0700 (PDT)
Message-ID: <9711adcc-6de7-d891-e52d-448594f459e9@gmail.com>
Date:   Mon, 22 Aug 2022 12:49:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
 <bf3d5a0f-c337-f6f3-8bf4-b8665f92acaa@samba.org>
 <9b998187-b985-2938-1494-0bc8c189a3b6@gmail.com>
 <5fc449bd-9625-4ff0-5f1b-a9fbea721716@samba.org>
 <a5fc6451-94a8-edbf-d9f7-a05eb49b0113@gmail.com>
 <697172bd-24fa-966c-e76d-f52812f9a4b0@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <697172bd-24fa-966c-e76d-f52812f9a4b0@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/22 13:36, Stefan Metzmacher wrote:
[...]
>>>>> What do you think? It would remove the whole notif slot complexity
>>>>> from caller using IORING_RECVSEND_NOTIF_FLUSH for every request anyway.
>>>>
>>>> The downside is that requests then should be pretty large or it'll
>>>> lose in performance. Surely not a problem for 8MB per request but
>>>> even 4KB won't suffice. And users may want to put in smaller chunks
>>>> on the wire instead of waiting for mode data to let tcp handle
>>>> pacing and potentially improve latencies by sending earlier.
>>>
>>> If this is optional applications can decide what fits better.
>>>
>>>> On the other hand that one notification per request idea mentioned
>>>> before can extended to 1-2 CQEs per request, which is interestingly
>>>> the approach zc send discussions started with.
>>>
>>> In order to make use of any of this I need any way
>>> to get 2 CQEs with user_data being the same or related.
>>
>> The idea described above will post 2 CQEs (mostly) per request
>> as you want with an optional way to have only 1 CQE. My current
>> sentiment is to kill all the slot business, leave this 1-2 CQE
>> per request and see if there are users for whom it won't be
>> enough. It's anyway just a slight deviation from what I wanted
>> to push as a complimentary interface.
> 
> Ah, ok, removing the slot stuff again would be fine for me...
> 
>>> The only benefit for with slots is being able to avoid or
>>> batch additional CQEs, correct? Or is there more to it?
>>
>> CQE batching is a lesser problem, I'm more concerned of how
>> it sticks with the network. In short, it'll hugely underperform
>> with TCP if requests are not large enough.
>>
>> A simple bench with some hacks, localhost, TCP, run by
>>
>> ./msg_zerocopy -6 -r tcp -s <size> &
>> ./io_uring_zerocopy_tx -6 -D "::1" -s <size> -m <0,2> tcp
>>
>>
>> non-zerocopy:
>> 4000B:  tx=8711880 (MB=33233), tx/s=1742376 (MB/s=6646)
>> 16000B: tx=3196528 (MB=48775), tx/s=639305 (MB/s=9755)
>> 60000B: tx=1036536 (MB=59311), tx/s=207307 (MB/s=11862)
>>
>> zerocopy:
>> 4000B:  tx=3003488 (MB=11457), tx/s=600697 (MB/s=2291)
>> 16000B: tx=2940296 (MB=44865), tx/s=588059 (MB/s=8973)
>> 60000B: tx=2621792 (MB=150020), tx/s=524358 (MB/s=30004)
> 
> So with something between 16k and 60k we reach the point where
> ZC starts to be faster, correct?

For this setup -- yes, should be somewhat around 16-20K,
don't remember numbers for real hw, but I saw similar
tendencies.

> Did you remove the loopback restriction as described in
> Documentation/networking/msg_zerocopy.rst ?

right, it wouldn't outperform even with large payload otherwise

> Are the results similar when using ./msg_zerocopy -6 tcp -s <size>
> as client?

Shouldn't be, it also batches multiple requests to a single
(internal) notification and also exposes it to the userspace
differently.

> And the reason is some page pinning overhead from iov_iter_get_pages2()
> in __zerocopy_sg_from_iter()?

No, I was using registered buffers here, so instead of
iov_iter_get_pages2() business zerocopy was doing
io_uring/net.c:io_sg_from_iter(). And in any case overhead on pinning
wouldn't drastically change it.

>> Reusing notifications with slots will change the picture.
>> And it this has nothing to do with io_uring overhead like
>> CQE posting and so on.
> 
> Hmm I don't understand how the number of notif structures
> would have any impact? Is it related to io_sg_from_iter()?

It comes from TCP stack force changing an skbuff every time
it meets a new ubuf_info (i.e. a notification handle for
simplicity), there is a slight bump on skb allocation overhead
but the main problem is seemingly comes from tcp_push and so,
feeding it down the stack. I don't think there is any fundamental
reason for why it should be working so much slower but might
be problematic from engineering perspective. I'll ask a bit
around or maybe look myself if find time for that.

-- 
Pavel Begunkov
