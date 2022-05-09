Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8D8520050
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 16:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbiEIOyB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 10:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiEIOx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 10:53:58 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F5724DC4C
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 07:50:00 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id f2so15539968ioh.7
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 07:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z/ZmGJVD0DjsL888JLe2cknZPlHnARnL6oMP2wgPnLM=;
        b=Rbf6Tjjr3CMiudAGgDCzxnxkwQZRXufb7ot1HASSSMbOJEOKnLgv3PwlibAjVGMqWu
         jFLuC7RMf7hZLvyW5Fm9yTjXcOL2dyqd42WilD3cQeh+Ci0RhNFBDpfnRaCOIUHqZ4yN
         nkcv4nJsdShbpVKM6YvteRMdtsyn0pcRgfxw1J3MZ3eEGG4uccGyVkexGAEf3pEWdszf
         6Eq3oYHXJvIAGxDUjLcQt/SkdK7lvCss0FQOaoUv1oDWJ5uGxYZEG/OrX90vGMGJ2Pw3
         J7k1ch+E/FVUjD6oUk7QFPw6iaEXegvA/j/sheHqII0qj9VCbsjG7Ya1DpUr6XNt4nNk
         sUUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z/ZmGJVD0DjsL888JLe2cknZPlHnARnL6oMP2wgPnLM=;
        b=z0GnBH8WoH7NnUiwybByzfLaaI/vn3KjR8J2yNyKzsABb3QieV1GpttVXfEOJfJR99
         3n0fAObXocGYbGGnKNG+qdsH1mLhTnVObVgxBdvTjtr3zW550/kQVR9XPdg/YR7GQLsJ
         P74I8n+PXqd7aKi+VhB9q97cwliv8cQABjjdVhtXRPB8I9CknYp5nZAzbWRhpSlKnuxT
         I745fiGSiUNrBiyWorV1oC+DIgs/dwaXrt1Rf7ywJAwU6/+3vwyfGZ7ndxZDh39VCfgJ
         k26DbLvST5kwyqP0qmQBLCe0v+OiVMX0ociUsvkFHihZ6yU6ygYFtrA/+EqtmZirXdhU
         hd6Q==
X-Gm-Message-State: AOAM531NIzRyVaHgFtCDnlwSGnlL6Kz8kmOKT02h89foq5JouxxfL7Z2
        Dvo5S/y97PljXF1un672E8R05g==
X-Google-Smtp-Source: ABdhPJzPIL9M3tigXG6HM1ZLuK98XSV/yR/m6Qs7EiAu/CXY5eClAEJ8zd+eE2gTAf2l1mkNh6lY9Q==
X-Received: by 2002:a5d:9318:0:b0:649:a18:dab8 with SMTP id l24-20020a5d9318000000b006490a18dab8mr6963541ion.96.1652107800197;
        Mon, 09 May 2022 07:50:00 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q21-20020a056638345500b0032b74686763sm3666840jav.76.2022.05.09.07.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 07:49:58 -0700 (PDT)
Message-ID: <ba139690-e223-8b99-4aa3-5d3336f25386@kernel.dk>
Date:   Mon, 9 May 2022 08:49:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET 0/4] Allow allocated direct descriptors
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220508234909.224108-1-axboe@kernel.dk>
 <a5ec8825-8dc3-c030-ac46-7ad08f296206@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a5ec8825-8dc3-c030-ac46-7ad08f296206@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 7:20 AM, Hao Xu wrote:
> ? 2022/5/9 ??7:49, Jens Axboe ??:
>> Hi,
>>
>> Currently using direct descriptors with open or accept requires the
>> application to manage the descriptor space, picking which slot to use
>> for any given file. However, there are cases where it's useful to just
>> get a direct descriptor and not care about which value it is, instead
>> just return it like a normal open or accept would.
>>
>> This will also be useful for multishot accept support, where allocated
>> direct descriptors are a requirement to make that feature work with
>> these kinds of files.
>>
>> This adds support for allocating a new fixed descriptor. This is chosen
>> by passing in UINT_MAX as the fixed slot, which otherwise has a limit
>> of INT_MAX like any file descriptor does.
>>
>>   fs/io_uring.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++---
>>    1 file changed, 94 insertions(+), 6 deletions(-)
>>
> Hi Jens,
> I've read this idea of leveraging bitmap, it looks great. a small flaw
> of it is that when the file_table is very long, the bitmap searching
> seems to be O({length of table}/BITS_PER_LONG), to make the time
> complexity stable, I did a linked list version, could you have a look
> when you're avalible. totally untested, just to show my idea. Basically
> I use a list to link all the free slots, when we need a slot, just get
> the head of it.
> https://github.com/HowHsu/linux/commits/for-5.19/io_uring_multishot_accept_v5
> 
> (borrowed some commit message from your patches)

While that's certainly true, I'm skeptical that the list management will
be faster for most cases. It's worth nothing that the regular file
allocator is very much the same thing. A full scan is unlikely unless
you already got -ENFILE. Any clear in between will reset the hint and
it'll be O(1) again. So yes, the pathological case of having no
descriptors left and repeatedly trying to get one isn't optimal, but no
application should be running in that mode.

The downside is also that now each fixed file will take up 4 times as
much space (8 bytes -> 32 bytes), and that's a resource we'll
potentially have a lot of.

If the case of finding a new descriptor is slow for a mostly full space,
in the past I've done something like axmap [1] in fio, where you each
64-bit entry is representing by a single bit a layer up. That still has
very good space utilization and good cache layout, which the list very
much does not. But given the above, I don't think we need to worry about
that really.

As a side note, I do think we need to just bump the size of the max
direct descriptors we can have. With the file table potentially being
vmalloc backed, there's no reason to limit it to the current 32K.

[1] https://git.kernel.dk/cgit/fio/tree/lib/axmap.c

-- 
Jens Axboe

