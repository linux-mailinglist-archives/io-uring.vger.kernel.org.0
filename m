Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DD752157B
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 14:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiEJMb6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 08:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241842AbiEJMbF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 08:31:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D2C2A1FDE
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 05:26:50 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i24so14800538pfa.7
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 05:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8RC+HvsATEcDZ/wFMN5wBhFYl/yzpaz8ARR9H2I/z+4=;
        b=cn+VI+/DxazrcUxrXP8uaMZpCTmnrEGz4dcJoTvx81j8l0WNADQBOg8NzcUN+NcGRU
         L2WnuHltjCiip999764FOcSYrqjZ++5I8B5CY+McD/7fVXwXVHtIGUl26KMravQsNbqh
         7p3bKaH1Cp3QvYbKfbcKrVsf81+Rju11aJeBaarTRq4ASyN496rg328hZQe2HxrsJrfv
         wcSF1YVZ3nqXNo3FA66uB6IPrhWdGO7edcFqLrui2QNXGmVbbz0e9XK1Lyb3P4iA2HLc
         OeF8JSgeKlkXkaQGJbtLEufWet+Rn+ubIM7eZUxxXEJtPAP+Am0t38L/RNdErmMUTeGP
         wzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8RC+HvsATEcDZ/wFMN5wBhFYl/yzpaz8ARR9H2I/z+4=;
        b=6Uc4jHRSNHUzQTHFEkGWrPXr8N+A8M8D8dHpbkZwHVbX7xpjJcxYsHPqUBIL9Ujwr7
         mU3Pk3Mz5ZYZ9ONwd2d0+XFcPON1xCGwn14ZlwslTNb4E/vQpA7uWVZY7DA4niwhodN3
         fcOeI4lpCEZD4il7C/vBNmuGxsgY4nGk/x5WFV5opCtnnN/Nc+bctygRpUL3MwnoST9E
         s1tN5w4fD4LB8h4NLjeRFgOT5DtQD6E84bP8MUrVuQZq/Es9EjCn0cD6ssFE8ShMzGFV
         oRAFa1G44gimmRo4ruWOc7PkuuM1Pf1P5kn8Wg/65HEJCQW4Ye/nnoMRc8gfEX5FrQ7f
         fWeQ==
X-Gm-Message-State: AOAM532vhLxYDzfEkq3vY79yFGjyzXD1yHHzWpJqx4wwIrLYQJvATYxT
        tZub947mmN/PMCOb6LVLu66Lcw==
X-Google-Smtp-Source: ABdhPJzQDZX53WjxlO+gpiButx4v26L6EyMqSifbEfEMMFWdiDrdkL16IhXJvSGEdCNKBg317zTVnQ==
X-Received: by 2002:a63:a513:0:b0:3c6:1845:b778 with SMTP id n19-20020a63a513000000b003c61845b778mr16486557pgf.532.1652185609911;
        Tue, 10 May 2022 05:26:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o186-20020a625ac3000000b00510952c52e3sm6471886pfb.180.2022.05.10.05.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 05:26:49 -0700 (PDT)
Message-ID: <4f68ef54-ecc9-402d-9c1f-379451e8fc32@kernel.dk>
Date:   Tue, 10 May 2022 06:26:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET 0/4] Allow allocated direct descriptors
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220508234909.224108-1-axboe@kernel.dk>
 <a5ec8825-8dc3-c030-ac46-7ad08f296206@gmail.com>
 <ba139690-e223-8b99-4aa3-5d3336f25386@kernel.dk>
 <50a1fa53-08cd-e7e7-a2da-e628c582e857@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <50a1fa53-08cd-e7e7-a2da-e628c582e857@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 11:35 PM, Hao Xu wrote:
> ? 2022/5/9 ??10:49, Jens Axboe ??:
>> On 5/9/22 7:20 AM, Hao Xu wrote:
>>> ? 2022/5/9 ??7:49, Jens Axboe ??:
>>>> Hi,
>>>>
>>>> Currently using direct descriptors with open or accept requires the
>>>> application to manage the descriptor space, picking which slot to use
>>>> for any given file. However, there are cases where it's useful to just
>>>> get a direct descriptor and not care about which value it is, instead
>>>> just return it like a normal open or accept would.
>>>>
>>>> This will also be useful for multishot accept support, where allocated
>>>> direct descriptors are a requirement to make that feature work with
>>>> these kinds of files.
>>>>
>>>> This adds support for allocating a new fixed descriptor. This is chosen
>>>> by passing in UINT_MAX as the fixed slot, which otherwise has a limit
>>>> of INT_MAX like any file descriptor does.
>>>>
>>>>    fs/io_uring.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++---
>>>>     1 file changed, 94 insertions(+), 6 deletions(-)
>>>>
>>> Hi Jens,
>>> I've read this idea of leveraging bitmap, it looks great. a small flaw
>>> of it is that when the file_table is very long, the bitmap searching
>>> seems to be O({length of table}/BITS_PER_LONG), to make the time
>>> complexity stable, I did a linked list version, could you have a look
>>> when you're avalible. totally untested, just to show my idea. Basically
>>> I use a list to link all the free slots, when we need a slot, just get
>>> the head of it.
>>> https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v5
>>>
>>> (borrowed some commit message from your patches)
>>
>> While that's certainly true, I'm skeptical that the list management will
>> be faster for most cases. It's worth nothing that the regular file
>> allocator is very much the same thing. A full scan is unlikely unless
>> you already got -ENFILE. Any clear in between will reset the hint and
>> it'll be O(1) again. So yes, the pathological case of having no
> 
> it's not O(1) actually, and a full bitmap is not the only worst case.
> For instance, the bitmap is like:
>                              hint
>                               |
>    1111111111111111111111111110000
> 
> then a bit is cleared and hint is updated:
>      hint
>       |
>    1110111111111111111111111110000
> 
> then next time the complexity is high

Next time it's fine, since the hint is that bit. If you do do, then yes
the second would be a slower.

> So in this kind of scenario(first allocate many in order, then clear
> low bit and allocation goes on in turn), it would be slow. And I think
> these cases are not rare since people usually allocate many fds then
> free the early used fds from time to time.

It's by no means perfect, but if it's good enough for the normal file
allocator, then I don't think it'd be wise to over-engineer this one
until there's a proven need to do so.

The single list items tracking free items is most certainly a LOT slower
for the common cases, so I don't think that's a good approach at all.

My suggestion would be to stick with the proposed approach until there's
evidence that the allocator needs improving. I did write a benchmark
that uses a 500K map and does opens and closes, and I don't see anything
to worry about in terms of overhead. The bitmap handling doesn't even
really register, dwarfed by the rest of the open path.

>> If the case of finding a new descriptor is slow for a mostly full space,
>> in the past I've done something like axmap [1] in fio, where you each
>> 64-bit entry is representing by a single bit a layer up. That still has
>> very good space utilization and good cache layout, which the list very
>> much does not. But given the above, I don't think we need to worry about
>> that really.
>>
>> As a side note, I do think we need to just bump the size of the max
>> direct descriptors we can have. With the file table potentially being
>> vmalloc backed, there's no reason to limit it to the current 32K.
> 
> Agree.
> 
>>
>> [1] https://git.kernel.dk/cgit/fio/tree/lib/axmap.c
>>
> Cool, I'll have a look.

It can get boiled down to something a bit simpler as the fio
implementation supports a variety of different use cases. For example, I
think it should be implemented as a single indexed array that holds all
the levels, rather than separate is it's done there. In short, it just
condenses everything down to one qword eventually, and finding a free
bit is always O(log64(N)).

-- 
Jens Axboe

