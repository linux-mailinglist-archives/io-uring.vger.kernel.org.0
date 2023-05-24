Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BD170FD6B
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjEXSEQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 14:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjEXSEP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 14:04:15 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04273B6
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 11:04:13 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7747f082d98so9527539f.1
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 11:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684951452; x=1687543452;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pMtiJjDn35TXdmUt4yEsHCNty/b3ZW+VLF/JBRf9S/Q=;
        b=XQup62+7WOz0Fnzwrq67q89Qmad1PzcAbuvRu0l+1BlEkiwg8YTo+99RAz57YLsX+Q
         OkATcNtbNZzkN6QcDuSwdKtxMa2Fn4Sq8kIgpzOSkFzQLWuZQ1xRH53KN20La/ZwsA1x
         cZjed1LAb5nWuqLqrB00tGyme2VGRRcbZhn7mhF8eqLoftUMDtYenT+MoX1LgACqLbFe
         voQ3vgsBfNDQ9tgOHBpwNBrRIuSXA477X++ELUNN4Mo7cYyVR5yQkI/1QjOALUjt+goZ
         wxgmpKmVGxhRiUe+FydkkAOxcVwgGY9cNux/QBWsjH3naPCOeCY54PX6k3N+T+ml5Q8S
         KT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684951452; x=1687543452;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pMtiJjDn35TXdmUt4yEsHCNty/b3ZW+VLF/JBRf9S/Q=;
        b=IL5wMBKgn6M1rzv7EPw62RUHvadJMU6QEYD0kt5bvkLGcQGDVsk7tbl4hFxM1rXJWj
         XgwSFKxyRhAjl4LufITlsXytv+m+MbPM2EXPRBMxwCyLfaKzyiTfy8TMym7n9BOIie/w
         1ojh0TdCryE1Bc776C0okE/I0tEDvnrD8rw2kIGxUfdEOtXMH1Aqo8zbfJYNzGqT6WCR
         5ZhsuDSrpobPE0snt/6gnWAXBX5g82IdJ1Cud63BNV8PaMddtsYNNVkoDAETX9IVKaSi
         jswxb40wprB4JWSsOu31fdsbPHiXk6rTNrH4G5JUqaibyroZa6idI2yuyt6RR1aJcvbq
         drnA==
X-Gm-Message-State: AC+VfDwT8lFEV7wZxbZPQxoHwANZO8zUi4meRXrNEAK1PSwlm7dr0UbF
        uP6rTXrOGSzIxYbGbJsJ3/C+oO6XrZDeSpwTmTA=
X-Google-Smtp-Source: ACHHUZ5P62+x9zlLMsmyTrm3/xIRuKKGUKLfIIr0OBaGPk4ZVguM4Kj5FmFQEB/k03RNRL4OszoyzQ==
X-Received: by 2002:a92:cd8b:0:b0:332:868a:ea8 with SMTP id r11-20020a92cd8b000000b00332868a0ea8mr10935198ilb.1.1684951452241;
        Wed, 24 May 2023 11:04:12 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k44-20020a056638372c00b004164bae7535sm3286866jav.17.2023.05.24.11.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 11:04:11 -0700 (PDT)
Message-ID: <6724470e-99dd-d111-053c-5b8458730576@kernel.dk>
Date:   Wed, 24 May 2023 12:04:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Protection key in io uring kthread
Content-Language: en-US
To:     Jeff Xu <jeffxu@chromium.org>
Cc:     io-uring@vger.kernel.org
References: <CABi2SkUp45HEt7eQ6a47Z7b3LzW=4m3xAakG35os7puCO2dkng@mail.gmail.com>
 <d8af0d2b-127c-03ef-0fe6-36a633fb8b49@kernel.dk>
 <CABi2SkXyMcYEKSwtg7Acg7_j6WCYFmrOeJOLrKTMXCm4FL2fcQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CABi2SkXyMcYEKSwtg7Acg7_j6WCYFmrOeJOLrKTMXCm4FL2fcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/24/23 11:44?AM, Jeff Xu wrote:
> Hi Jens,
> Thanks for responding.
> 
> On Wed, May 24, 2023 at 8:06?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/23/23 8:48?PM, Jeff Xu wrote:
>>> Hi
>>> I have a question on the protection key in io_uring. Today, when a
>>> user thread enters the kernel through syscall, PKRU is preserved, and
>>> the kernel  will respect the PKEY protection of memory.
>>>
>>> For example:
>>> sys_mprotect_pkey((void *)ptr, size, PROT_READ | PROT_WRITE, pkey);
>>> pkey_write_deny(pkey); <-- disable write access to pkey for this thread.
>>> ret = read(fd, ptr, 1); <-- this will fail in the kernel.
>>>
>>> I wonder what is the case for io_uring, since read is now async, will
>>> kthread have the user thread's PKUR ?
>>
>> There is no kthread. What can happen is that some operation may be
>> punted to the io-wq workers, but these act exactly like a thread created
>> by the original task. IOW, if normal threads retain the protection key,
>> so will any io-wq io_uring thread. If they don't, they do not.
>>
> Does this also apply to when the IORING_SETUP_SQPOLL [1] flag is used
> ? it mentions a kernel thread is created to perform submission queue
> polling.

It doesn't matter if it's SQPOLL or one of the io-wq workers, they are
created in the same way. For all intents and purposes, they are
userspace threads, identical to one you'd get with pthread_create().
Only difference is that they never return to userspace.

>>> In theory, it is possible, i.e. from io_uring_enter syscall. But I
>>> don't know the implementation details of io_uring, hence asking the
>>> expert in this list.
>>
>> Right, if the IO is done inline, then it won't make a difference if eg
>> read(2) is used or IORING_OP_READ (or similar) with io_uring.
>>
> Can you please clarify what "IO is done inline" means ? i.e. are there
> cases that are not inline ?

I mean if the execution of it ends up being app -> io_uring_enter() ->
do io. For some operations, you could end up with:

io_uring_enter() -> punt to io_wq
	io_wq -> do io

either implicitly because the "do io" operation doesn't support
nonblocking issue (or ran out of resrouces), or explicitly if you set
IOSQE_ASYNC in the SQE you submitted.

-- 
Jens Axboe

