Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EE565DDB9
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 21:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjADUew (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 15:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjADUev (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 15:34:51 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEB51C924
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 12:34:50 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id g20so18622873iob.2
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 12:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O991kjq5tKUOcvjso3tSQQwS/v8//qZih16Quxe1YSs=;
        b=2tfx2tsEFkfzz0gWqUT/tOLjxnJU+w6ILDGSS+zfZcks7ukhjnbSVu2R0EmneeUN6j
         v/OgX4Dos03S/KJqRXBpsIQOAfHgbw3k0QT25QuebQpIcWXUwpNB52aVzwd3H9PEidXy
         gD5ZIGCXzn3WScez7AJnVymUoTqG9GJTncrZnt/vKdW/wPOmFvxyzVZxbJq6Nn8KU83G
         8wR6uvL+G15Rd27/PhgO3qn9ToCo6EsVoDopdysifvs83czqBSIypLg2EvuoJ23T8JLg
         XRSq8DbbSOR49a00TMmrrocyD4iAsKW0xMWyL2EBb+qu8NS1jaBInJt+3t3zWnUPGRAJ
         eO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O991kjq5tKUOcvjso3tSQQwS/v8//qZih16Quxe1YSs=;
        b=HI4qGVxNMTMD1O2pVlnSzwevyp/srYH+JJReJEjd5IN4OtoM8SycWKY81txSY2pJ0W
         n+V8xdtH63V5HTgWa+/pEQ+7XLSsqH0B5aATmi3IryKYbjVYh2OhYpBZ8g/aEu3d1veQ
         Ln+ZcsFHbwgp4QHGESsSubGsvR2gU6e1hcAg6N8x24W3VWNaa/HKcjce/YO14N0yMiG3
         kbDDm469SMtzIpWGTElrZiTZK/4DXNK+XvYXFE9ppeONZMitozJt3Nr4xUau4sC3AkLS
         ZfSogEokhkb34pLBd8WT1h3JkX62B/b6N2oAKRBuYBC/FMwVA2vXDLeB1a76B2nvdUZz
         j2LA==
X-Gm-Message-State: AFqh2kr5r4e4hoqvKE7W02EwELWzLH/8098VtWDm+OpUGObJywKhnnP0
        iMHuBSgDneFScafFtOQej0bJOw==
X-Google-Smtp-Source: AMrXdXvFboCgT8gsUf6nfHGo3ekJPxURjZVgEQEkrHQcVsSCSreus/So1cNdOLH+6+c+zFRlQ9iFRg==
X-Received: by 2002:a6b:7702:0:b0:6e2:d3f7:3b60 with SMTP id n2-20020a6b7702000000b006e2d3f73b60mr5938986iom.2.1672864489788;
        Wed, 04 Jan 2023 12:34:49 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i37-20020a026025000000b00374bf3b62a0sm11163341jac.99.2023.01.04.12.34.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:34:48 -0800 (PST)
Message-ID: <75dcfbaf-5822-0b20-5580-1f6ac3ba7f20@kernel.dk>
Date:   Wed, 4 Jan 2023 13:34:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC v2 09/13] io_uring: separate wq for ring polling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1672713341.git.asml.silence@gmail.com>
 <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
 <1968c5b9-dd2b-4ed1-14a0-8f78b302bf2d@kernel.dk>
 <894c3092-9561-1a32-fb4c-8bf33e3667a1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <894c3092-9561-1a32-fb4c-8bf33e3667a1@gmail.com>
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

On 1/4/23 1:28?PM, Pavel Begunkov wrote:
> On 1/4/23 18:08, Jens Axboe wrote:
>> On 1/2/23 8:04?PM, Pavel Begunkov wrote:
>>> Don't use ->cq_wait for ring polling but add a separate wait queue for
>>> it. We need it for following patches.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   include/linux/io_uring_types.h | 1 +
>>>   io_uring/io_uring.c            | 3 ++-
>>>   io_uring/io_uring.h            | 9 +++++++++
>>>   3 files changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>> index dcd8a563ab52..cbcd3aaddd9d 100644
>>> --- a/include/linux/io_uring_types.h
>>> +++ b/include/linux/io_uring_types.h
>>> @@ -286,6 +286,7 @@ struct io_ring_ctx {
>>>           unsigned        cq_entries;
>>>           struct io_ev_fd    __rcu    *io_ev_fd;
>>>           struct wait_queue_head    cq_wait;
>>> +        struct wait_queue_head    poll_wq;
>>>           unsigned        cq_extra;
>>>       } ____cacheline_aligned_in_smp;
>>>   
>>
>> Should we move poll_wq somewhere else, more out of the way?
> 
> If we care about polling perf and cache collisions with
> cq_wait, yeah we can. In any case it's a good idea to at
> least move it after cq_extra.
> 
>> Would need to gate the check a flag or something.
> 
> Not sure I follow

I guess I could've been a bit more verbose... If we consider poll on the
io_uring rather uncommon, then moving the poll_wq outside of the hotter
cq_wait cacheline(s) would make sense. Each wait_queue_head is more than
a cacheline. Then we could have a flag in a spot that's hot anyway
whether to check it or not, eg in that same section as cq_wait.

Looking at the layout right now, we're at 116 bytes for that section, or
two cachelines with 12 bytes to spare. If we add poll_wq, then we'll be
at 196 bytes, which is 4 bytes over the next cacheline. So it'd
essentially double the size of that section. If we moved it outside of
the aligned sections, then it'd pack better.

-- 
Jens Axboe

