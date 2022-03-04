Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B63D4CCBEC
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 03:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiCDCpU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 21:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiCDCpT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 21:45:19 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D0817E34B
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 18:44:33 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id hw13so14535739ejc.9
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 18:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=rGfV6WOSc/UQCN4o2sE8kQmrJgLr/PB+qi7VrEO2ezQ=;
        b=m+3AqKUmVNWgtkJkt64/N0IppknkU68tAnVttOi2tDNz00wV2qH17cwAlLACNB1Dh2
         muA/6/PXyP7D5BYU3NjCyaUasGhkUCc+FrGqoF+oCT9zhQQgmh8yyGY6qA0y2JzQZGQG
         AXT0n0CmGoLaBVmLs3aD1h853Yl2b47MImAoTRNaM0+KLVq4eLMUXpLH0/vBYciwJOvE
         4NFdYYHoQWjNzJUDpACm40g1ZVY/BzzKKmC/rTcj0eBxXzzKhaexBENmWIq1Te/DI4rl
         gONM8DqMHhgDCtnLx6ZZoPcpKLC2eAXlZjR3fTLu2aAD/6fQ52H4FFUFS/TlK/Zx5+xY
         eXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rGfV6WOSc/UQCN4o2sE8kQmrJgLr/PB+qi7VrEO2ezQ=;
        b=7+Pheg+K/N6yRsoZlPTnCFCyaZN2eHNKns/eAd3kylzAOT8nlkoF9ZOkw8J+oXi7ha
         MuEZGC8KqGmtvrkykQ77omxwH5vNkszB+lwBvFORWMT9bWzeWxWiHRzi/RzVDAagit1K
         K49Z6qknXGpqxXIZ1Q/Xk2F22Ca6v/k441Wff1pVVaeZNnrdqgFy9eHvbrH8gpSJB+IE
         gngQ84VFjK2Yw4bT7pyXgU42Bwtc92CwGd5qQIwMglklDma2SzH30YE1EPGmBbRzDwsh
         CueSQPobssTSyuiiXFg54uY3P3jv2ABmoY3XtTA7tNk5WAycf8mf8nWfKKH1GWpZNzjV
         t8bg==
X-Gm-Message-State: AOAM5333qtP9LrVsoIS7QF8qQn7qDrY6WRIxp5plKirS7mlqHGSeJwx4
        06fbgRKWUwodpToRQbo6LklOlaD8pOA=
X-Google-Smtp-Source: ABdhPJxkgNW1K7mim4roKkGBX3wrA4wp7EB/0GRm2gyr7RvX31KHiEVicPU8W1sP6Fd/630ikxqWkg==
X-Received: by 2002:a17:906:c0d6:b0:6ca:457e:f1b7 with SMTP id bn22-20020a170906c0d600b006ca457ef1b7mr29383868ejb.399.1646361871649;
        Thu, 03 Mar 2022 18:44:31 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.114])
        by smtp.gmail.com with ESMTPSA id fb21-20020a1709073a1500b006da6eefdf11sm1265722ejc.49.2022.03.03.18.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 18:44:31 -0800 (PST)
Message-ID: <69e494cc-a199-db59-ecc0-4b430ac35bb5@gmail.com>
Date:   Fri, 4 Mar 2022 02:39:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <8e4ce4da-040f-70e6-8a9d-54e25c71222f@gmail.com>
 <69ef4007-45d6-3b15-022b-b00fc7182499@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <69ef4007-45d6-3b15-022b-b00fc7182499@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/22 02:19, Jens Axboe wrote:
> On 3/3/22 6:52 PM, Pavel Begunkov wrote:
>> On 3/3/22 16:31, Jens Axboe wrote:
>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
[...]
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index ad3e0b0ab3b9..8a1f97054b71 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>> [...]
>>>    static void *io_uring_validate_mmap_request(struct file *file,
>>>                            loff_t pgoff, size_t sz)
>>>    {
>>> @@ -10191,12 +10266,23 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>>        io_run_task_work();
>>>          if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
>>> -                   IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
>>> +                   IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
>>> +                   IORING_ENTER_REGISTERED_RING)))
>>>            return -EINVAL;
>>>    -    f = fdget(fd);
>>> -    if (unlikely(!f.file))
>>> -        return -EBADF;
>>> +    if (flags & IORING_ENTER_REGISTERED_RING) {
>>> +        struct io_uring_task *tctx = current->io_uring;
>>> +
>>> +        if (fd >= IO_RINGFD_REG_MAX || !tctx)
>>> +            return -EINVAL;
>>> +        f.file = tctx->registered_rings[fd];
>>
>> btw, array_index_nospec(), possibly not only here.
> 
> Yeah, was thinking that earlier too in fact but forgot about it. Might
> as well, though I don't think it's strictly required as it isn't a user
> table.

I may have missed in what cases it's used, but shouldn't it be
in all cases when we use a user passed index for array addressing?
e.g. to protect from pre-caching a chunk of memory computed from
an out-of-array malevolent index

I just don't see any relevant difference from normal file tables

-- 
Pavel Begunkov
