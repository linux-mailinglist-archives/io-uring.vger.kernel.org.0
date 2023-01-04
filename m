Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720A465DDDF
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 21:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbjADUwI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 15:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjADUwH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 15:52:07 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2881C938
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 12:52:05 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id g20so18647226iob.2
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 12:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6XLMBe9Z2KydQeAtvRZhTHMyhNgVY4ujP2LjOuKqD7w=;
        b=pcaFiTz1lhV7ahCA2PYTZ3T/LBw5UlncgRyexjVdetC2Kj1JYXxgtmGPi5wWRgtsAx
         9nBfCpH6LqqtjlL0cDJg8UawNcAwnRMjkOQkkuSJoCODxcVhLZhoG+JZAHBEFpScPFUe
         5CLECOk4tUAgbaMLrZ9dZxYpJw5JhU2SHHXHwLK6Dl1nNtrLXp3NNHeW9dzhLP8Hk/F7
         1qxVK5Sxc+C88tb51+STbqcEsb0BYpCMZnk4Y80uUYHInQkJ28evMptHdXbs1rrcuWpp
         TFpwHlaI2MsHiG/b3YQSFRqf3jFTFFQBPaF2ccTC8G7sUdDhjCcdRneGpZTVHeTK3zXq
         VOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6XLMBe9Z2KydQeAtvRZhTHMyhNgVY4ujP2LjOuKqD7w=;
        b=c9zvHkw37YktV1LxITkEFwyArXqbuBVDKen+x+vKI6WvbKMLvHDu8oW6BdT/m6eiQz
         elxiVlJiVOHN8IV5dV7vvk8jS1NFtMBxZtFUF8oKE+pIBvNul8ONUXxsFm1MD/97D1Zp
         Qu2u4IjKJFIWZ6zTS0xsNLyLAIWYkeMYUNlSd4WX1F82aIFDlfax2DZYTqD2zPMHxnhC
         LjnPz74iZUhwqdpnYndWz7HP+gd5lvbRZHAe1WnaCjLb9rbnXJtsWsJ0gZtdped0hOjL
         3J+Xh7t4Yqy/Na09p6wmNfDTGVs8rPx+vbfwzDnHRy9ii6AuG+xh+5DvrSoy6YeqtyAR
         upyQ==
X-Gm-Message-State: AFqh2kqfBJRRrGVPgdcOp2WLRtQJo9PPH5iPBD+zvyzmqWfWf7/CnJp2
        KBdO0Lmd7Qg4OgnAL/6aeStwJO48O//Ncfbp
X-Google-Smtp-Source: AMrXdXswfku7MBXLpG1H7+DVyQx72AKAll331K1pMQAs0TP7NTvOly3l7ndUKTbGYS/rvC7+QapRyQ==
X-Received: by 2002:a6b:7808:0:b0:6db:3123:261 with SMTP id j8-20020a6b7808000000b006db31230261mr6150596iom.2.1672865525035;
        Wed, 04 Jan 2023 12:52:05 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z22-20020a056638215600b00363c2c5f229sm11396402jaj.128.2023.01.04.12.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:52:04 -0800 (PST)
Message-ID: <34026fb8-8efe-ffca-2d9c-5c1ec7d2560b@kernel.dk>
Date:   Wed, 4 Jan 2023 13:52:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC v2 09/13] io_uring: separate wq for ring polling
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1672713341.git.asml.silence@gmail.com>
 <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
 <1968c5b9-dd2b-4ed1-14a0-8f78b302bf2d@kernel.dk>
 <894c3092-9561-1a32-fb4c-8bf33e3667a1@gmail.com>
 <75dcfbaf-5822-0b20-5580-1f6ac3ba7f20@kernel.dk>
In-Reply-To: <75dcfbaf-5822-0b20-5580-1f6ac3ba7f20@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/23 1:34?PM, Jens Axboe wrote:
> On 1/4/23 1:28?PM, Pavel Begunkov wrote:
>> On 1/4/23 18:08, Jens Axboe wrote:
>>> On 1/2/23 8:04?PM, Pavel Begunkov wrote:
>>>> Don't use ->cq_wait for ring polling but add a separate wait queue for
>>>> it. We need it for following patches.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>   include/linux/io_uring_types.h | 1 +
>>>>   io_uring/io_uring.c            | 3 ++-
>>>>   io_uring/io_uring.h            | 9 +++++++++
>>>>   3 files changed, 12 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>>> index dcd8a563ab52..cbcd3aaddd9d 100644
>>>> --- a/include/linux/io_uring_types.h
>>>> +++ b/include/linux/io_uring_types.h
>>>> @@ -286,6 +286,7 @@ struct io_ring_ctx {
>>>>           unsigned        cq_entries;
>>>>           struct io_ev_fd    __rcu    *io_ev_fd;
>>>>           struct wait_queue_head    cq_wait;
>>>> +        struct wait_queue_head    poll_wq;
>>>>           unsigned        cq_extra;
>>>>       } ____cacheline_aligned_in_smp;
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
> a cacheline. Then we could have a flag in a spot that's hot anyway
> whether to check it or not, eg in that same section as cq_wait.
> 
> Looking at the layout right now, we're at 116 bytes for that section, or
> two cachelines with 12 bytes to spare. If we add poll_wq, then we'll be
> at 196 bytes, which is 4 bytes over the next cacheline. So it'd
> essentially double the size of that section. If we moved it outside of
> the aligned sections, then it'd pack better.

Just after writing this, I noticed that a spinlock took 64 bytes... In
other words, I have LOCKDEP enabled. The correct number is 24 bytes for
wait_queue_head which is obviously a lot more reasonable. It'd still
make that section one more cacheline since it's now at 60 bytes and
would grow to 84 bytes. But it's obviously not as big of a problem as I
had originally assumed.

-- 
Jens Axboe

