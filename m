Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592C4520D39
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 07:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiEJFip (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 01:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236731AbiEJFio (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 01:38:44 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEC92AEDB9
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 22:34:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 7so13752303pga.12
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 22:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=vOF1waNIZXGVbYLsPJhNg9VDczBO5F3APQBwh4efJ/c=;
        b=VljvgHftZXfIrR+E7LnEAB2ZoJVjl+GY7ucXHxeNC0t0g3h8DL+hd6uYt1klcyezdD
         xgmKUuNubpDWblIdnhDJ7fXgxvcx/MsIdZPGYAdJKry1ZKime2SxWwV0ECl4wX38MHz3
         wLfkWoSFu4fuKaoL9JgjKwuc64cK1S9DSCVotsRRf8GmrItUZGMYxAeSpM6SKVA6cQwm
         17s8Ppqy6HNLdj0nAOgMrIBNVhd+onSg8YuQxtHQY00+rCVsD5hKw6hXAVUrjF5KPZz/
         TaUF4vQQJ4fu0Z8nWtW8PcacceWhzq/BVj568pVJFOe+xSLW8MsTD189rhuR+SvWFBTx
         ApZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vOF1waNIZXGVbYLsPJhNg9VDczBO5F3APQBwh4efJ/c=;
        b=e8TkbB+XNEK7NLD4nGMHsgj4bhHSyxz970ARvN+KjfJAjIZqLeoSj9/smQapoaLfdy
         Ibg9m+iVS1E0YH32XkLDFxfsa2wTWymP1aPiadvZmEvNDjuMyudYpQNdhzudBKXgdhFk
         nhps0DrabYtSnvDQM5XhNPix29OcncM7iZPCyA40AbhJCURW8eVS18DQhJeOb7cbOBm0
         SNo9v5sEPHcRjdq9GjRl8IpADxT/it7P2ibsptlNXQzS/d9sqz/qrI4MbsxIPAO+w7TB
         UcxT6UwK11U327msba9fZOa76QKQRMFvYD09zKHcoefzPJj8Q03ymvIAb9fns0TQ/5xa
         Z55Q==
X-Gm-Message-State: AOAM532txeEOe4MtvoHWrunwcNv3W8YoFe//FLSciy8KCrY5xuqIzQ2N
        bb3HJj7xSq1IYznyqZVlSSw=
X-Google-Smtp-Source: ABdhPJx4KnBE5LWtlWp197s7yo3EcORqB701ml3Q5YdkV7/GevmreZQsPrtVj1adkVL7qVGsjM50Pg==
X-Received: by 2002:a63:6846:0:b0:3c6:cb42:cdb2 with SMTP id d67-20020a636846000000b003c6cb42cdb2mr5669919pgc.511.1652160888392;
        Mon, 09 May 2022 22:34:48 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id 12-20020aa7910c000000b0050dc76281c4sm9506592pfh.158.2022.05.09.22.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 22:34:48 -0700 (PDT)
Message-ID: <50a1fa53-08cd-e7e7-a2da-e628c582e857@gmail.com>
Date:   Tue, 10 May 2022 13:35:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCHSET 0/4] Allow allocated direct descriptors
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220508234909.224108-1-axboe@kernel.dk>
 <a5ec8825-8dc3-c030-ac46-7ad08f296206@gmail.com>
 <ba139690-e223-8b99-4aa3-5d3336f25386@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <ba139690-e223-8b99-4aa3-5d3336f25386@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/9 下午10:49, Jens Axboe 写道:
> On 5/9/22 7:20 AM, Hao Xu wrote:
>> ? 2022/5/9 ??7:49, Jens Axboe ??:
>>> Hi,
>>>
>>> Currently using direct descriptors with open or accept requires the
>>> application to manage the descriptor space, picking which slot to use
>>> for any given file. However, there are cases where it's useful to just
>>> get a direct descriptor and not care about which value it is, instead
>>> just return it like a normal open or accept would.
>>>
>>> This will also be useful for multishot accept support, where allocated
>>> direct descriptors are a requirement to make that feature work with
>>> these kinds of files.
>>>
>>> This adds support for allocating a new fixed descriptor. This is chosen
>>> by passing in UINT_MAX as the fixed slot, which otherwise has a limit
>>> of INT_MAX like any file descriptor does.
>>>
>>>    fs/io_uring.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++---
>>>     1 file changed, 94 insertions(+), 6 deletions(-)
>>>
>> Hi Jens,
>> I've read this idea of leveraging bitmap, it looks great. a small flaw
>> of it is that when the file_table is very long, the bitmap searching
>> seems to be O({length of table}/BITS_PER_LONG), to make the time
>> complexity stable, I did a linked list version, could you have a look
>> when you're avalible. totally untested, just to show my idea. Basically
>> I use a list to link all the free slots, when we need a slot, just get
>> the head of it.
>> https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v5
>>
>> (borrowed some commit message from your patches)
> 
> While that's certainly true, I'm skeptical that the list management will
> be faster for most cases. It's worth nothing that the regular file
> allocator is very much the same thing. A full scan is unlikely unless
> you already got -ENFILE. Any clear in between will reset the hint and
> it'll be O(1) again. So yes, the pathological case of having no

it's not O(1) actually, and a full bitmap is not the only worst case.
For instance, the bitmap is like:
                              hint
                               |
    1111111111111111111111111110000

then a bit is cleared and hint is updated:
      hint
       |
    1110111111111111111111111110000

then next time the complexity is high

So in this kind of scenario(first allocate many in order, then clear
low bit and allocation goes on in turn), it would be slow. And I think
these cases are not rare since people usually allocate many fds then
free the early used fds from time to time.

I haven't look through the regular file allocator carefully, I'll look
into it later if I got some time.

> descriptors left and repeatedly trying to get one isn't optimal, but no
> application should be running in that mode.
> 
> The downside is also that now each fixed file will take up 4 times as
> much space (8 bytes -> 32 bytes), and that's a resource we'll
> potentially have a lot of.

Agree, This is definitely a disadvantage of it which I should consider
when coding it..

> 
> If the case of finding a new descriptor is slow for a mostly full space,
> in the past I've done something like axmap [1] in fio, where you each
> 64-bit entry is representing by a single bit a layer up. That still has
> very good space utilization and good cache layout, which the list very
> much does not. But given the above, I don't think we need to worry about
> that really.
> 
> As a side note, I do think we need to just bump the size of the max
> direct descriptors we can have. With the file table potentially being
> vmalloc backed, there's no reason to limit it to the current 32K.

Agree.

> 
> [1] https://git.kernel.dk/cgit/fio/tree/lib/axmap.c
> 
Cool, I'll have a look.

Regards,
Hao

