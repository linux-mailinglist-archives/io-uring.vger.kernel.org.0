Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55106B6E19
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 04:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjCMDqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Mar 2023 23:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCMDqs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Mar 2023 23:46:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15E93B87E;
        Sun, 12 Mar 2023 20:46:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ek18so12201718edb.6;
        Sun, 12 Mar 2023 20:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678679203;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m3ivdNPo81WizlSI2L9KYGriSsBblsDqaVgcFRLFTQc=;
        b=W4HvhwtVmo0incxQ/cFP3ekS5DgUrZ5eu95UrLEEDra5tQxQH2U+5Jgf4c0ZonLvjt
         1kroHTpQcPau7Reof0gUcp+tVrLPznVx+IvEWGpYtcTuKwUD95ywdKm3VSsYSvhbIyig
         K8r6q8JFrhKZ+744RfsngvSOJb4iK8Q0MdEBMdQ9xRghTTuNwO0kDkAZchT7tm4DA02G
         Z3BWNefV+S2bgGzLrabNQJ4Aig2UiwhAWDqpNIQFL+TchePDq/n7n8kbVOLQObWQLauI
         y0a6KOQm3Z2+7Xlvy8y8Wk2ml7cLskCqMChMQihd9TLM0NVXjNkFomYextj4H9xG34rX
         QPQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678679203;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m3ivdNPo81WizlSI2L9KYGriSsBblsDqaVgcFRLFTQc=;
        b=LnaFDM0dzh24bLZBnQuZ/9GfYjBOABQVIduzElub1tGzUEuRLES1scFIF1d5wQFuUB
         HQswJ03r3cl4pULJBa0rxjHu4nhHQZ25lGviO47s6TFWr2I7gQUQXWtt3AkmDzyala8d
         1Qh8vPAteaQ+E92fGR93ekJumt6zkrrXliFrE5pc3phJ1371Xsdt5IFX3dfk98X1/dDS
         Pcwk7ws/t5+DKhMLP188dZVWaF3oIZpCxjmVP3LVllUpPjgv+q+TlueLuvRGnHItnFDP
         3CFoZ3JAB9MIPsM9Rfrxh5gsJ/wD3we9YRkgfE3+tNjBqMkTMxJvE1wODYoMWC+ObkYX
         Fqrw==
X-Gm-Message-State: AO0yUKUyIlGXWXA4xYu4+H7PiVxyv9lg+TIMZG4I3bSnjeobfRxPrTgE
        41/09NtlyGudd3M09eXwsHML7QpUwCo=
X-Google-Smtp-Source: AK7set9ykTjacRqKV2JevFqRqTl7ARyu2wNpAiWVd48XAeTSZ66uVdneDWw5XAloCag1YKSgYpv5eQ==
X-Received: by 2002:a17:907:7d9f:b0:8b1:781d:f9a4 with SMTP id oz31-20020a1709077d9f00b008b1781df9a4mr40752415ejc.21.1678679203045;
        Sun, 12 Mar 2023 20:46:43 -0700 (PDT)
Received: from [192.168.8.100] (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id c26-20020a170906695a00b00914001c91fcsm2903986ejs.86.2023.03.12.20.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 20:46:42 -0700 (PDT)
Message-ID: <4ed9ee1e-db0f-b164-4558-f3afa279dd4f@gmail.com>
Date:   Mon, 13 Mar 2023 03:45:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
 <9322c9ab-6bf5-b717-9f25-f5e55954db7b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9322c9ab-6bf5-b717-9f25-f5e55954db7b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/23 15:30, Jens Axboe wrote:
> On 3/11/23 1:45?PM, Pavel Begunkov wrote:
>> On 3/11/23 17:24, Jens Axboe wrote:
>>> On 3/10/23 12:04?PM, Pavel Begunkov wrote:
>>>> io_uring extensively uses task_work, but when a task is waiting
>>>> for multiple CQEs it causes lots of rescheduling. This series
>>>> is an attempt to optimise it and be a base for future improvements.
>>>>
>>>> For some zc network tests eventually waiting for a portion of
>>>> buffers I've got 10x descrease in the number of context switches,
>>>> which reduced the CPU consumption more than twice (17% -> 8%).
>>>> It also helps storage cases, while running fio/t/io_uring against
>>>> a low performant drive it got 2x descrease of the number of context
>>>> switches for QD8 and ~4 times for QD32.
>>>>
>>>> Not for inclusion yet, I want to add an optimisation for when
>>>> waiting for 1 CQE.
>>>
>>> Ran this on the usual peak benchmark, using IRQ. IOPS is around ~70M for
>>> that, and I see context rates of around 8.1-8.3M/sec with the current
>>> kernel.
>>>
>>> Applied the two patches, but didn't see much of a change? Performance is
>>> about the same, and cx rate ditto. Confused... As you probably know,
>>> this test waits for 32 ios at the time.
>>
>> If I'd to guess it already has perfect batching, for which case
>> the patch does nothing. Maybe it's due to SSD coalescing +
>> small ro I/O + consistency and small latencies of Optanes,
>> or might be on the scheduling and the kernel side to be slow
>> to react.
>>
>> I was looking at trace_io_uring_local_work_run() while testing,
>> It's always should be @loop=QD (i.e. 32) for the patch, but
>> the guess is it's also 32 with that setup but without patches.
> 
> It very well could be that it's just loaded enough that we get perfect
> batching anyway. I'd need to reuse some of your tracing to know for
> sure.

I used existing trace points. If you see a pattern

trace_io_uring_local_work_run()
trace_io_uring_cqring_wait(@count=32)

trace_io_uring_local_work_run()
trace_io_uring_cqring_wait(@count=32)

...

that would mean a perfect batching. Even more so
if @loops=1


>>> Didn't take a closer look just yet, but I grok the concept. One
>>> immediate thing I'd want to change is the FACILE part of it. Let's call
>>> it something a bit more straightforward, perhaps LIGHT? Or LIGHTWEIGHT?
>>
>> I don't really care, will change, but let me also ask why?
>> They're more or less synonyms, though facile is much less
>> popular. Is that your reasoning?
> 
> Yep, it's not very common and the name should be self-explanatory
> immediately for most people.

That's exactly the problem. Someone will think that it's
like normal tw but "better" and blindly apply it. Same happened
before with priority tw lists.

-- 
Pavel Begunkov
