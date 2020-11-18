Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440BF2B7FEF
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 16:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgKRO7V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 09:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRO7V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 09:59:21 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10325C0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 06:59:21 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id l11so1125853plt.1
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 06:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mf5HgChMx8YHdKA3psMqyIGM3nXLl4yzWNbBTnxp040=;
        b=J0pvayhMYq8xjnd6/KOgRhflJOm5791mWubVEGGr/cHnhQBwGewTPiksEGklWhiBxF
         AdZS9FGF/RT0qT6SnifP79PgKO4C+CRJwZBr+s/okolmzEYm3bM7dMIWOjgTS7Swocps
         GbG1txrSzJNwi+MQ6D8NUO1ztiKdRUXmPQJxYmGXpsvjEJ7xErw0wxtAf6BD3GXtZaf8
         Wlw6m6YyyLUuL4JTOdUMBYr8N+dfsM4E6brpYqV4tum7IyW5KdiUsZIn3dn40g0LvuVE
         mF6xTUithoIExFoWuL9AqK2ThKhlARcFKknGpd2BJJDfc7/XiX4OxtHyrgycUBwQISOq
         bIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mf5HgChMx8YHdKA3psMqyIGM3nXLl4yzWNbBTnxp040=;
        b=azyUDYmuWWKxM21qD9ffF1j0YZ2202d8EUQX5HzhoiCC9rmoBqLC8bpWrsodgDFvud
         foOlYPnFxP67B59W7VsUAsF4HW2lCQ92fC6aJDMyplfX8/V4cQzT+RKkYJrtTVFG6d+7
         /DMQkaKIsdpBgcE1ginYyPd4yZ6uuNAOP7d2nkE+N3EaPxq4dPQm4Wsb1Y7Aa3G/HP8X
         TM6cqx/Qi+ADEj198OnqNqPDskc1UZT2O/V/VSDNx/xpwfJF70Ba8ytYO6XmrOoLieM3
         cyb+mUqSUobrvwdUc159DYZJPhgC0Hx1FHWg9RjFYoPnNn63bc48a3EE/CC+Cxf49pjT
         qfEA==
X-Gm-Message-State: AOAM530ivGnT8NEmtrImy5V95PQGp48/sS9h1A/XXonie26YBnvkmgz0
        HdARG3sXjKidBpER02U1RkEMhX8EZtkFpw==
X-Google-Smtp-Source: ABdhPJxobL0/DH4Mk6i/2jrQFM1NXcFHB+NSNnoNkwX+c4X26eZ2YGlGv29iqmuJTJ8zT8lJ9AP94Q==
X-Received: by 2002:a17:90a:f3d1:: with SMTP id ha17mr368326pjb.164.1605711560476;
        Wed, 18 Nov 2020 06:59:20 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m6sm25381534pfa.61.2020.11.18.06.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 06:59:19 -0800 (PST)
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
 <9713dc32-8aea-5fd2-8195-45ceedcb74dd@kernel.dk>
 <82116595-2e57-525b-0619-2d71e874bd88@gmail.com>
 <148a36f1-ff60-4af6-7683-8849c9973010@kernel.dk>
 <f8e59ed9-4329-dada-cf16-329bdb7335be@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <12c010e5-d298-c48a-1841-ff0da39e2306@kernel.dk>
Date:   Wed, 18 Nov 2020 07:59:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f8e59ed9-4329-dada-cf16-329bdb7335be@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/20 6:59 AM, Pavel Begunkov wrote:
> On 18/11/2020 01:42, Jens Axboe wrote:
>> On 11/17/20 9:58 AM, Pavel Begunkov wrote:
>>> On 17/11/2020 16:30, Jens Axboe wrote:
>>>> On 11/17/20 3:43 AM, Pavel Begunkov wrote:
>>>>> On 17/11/2020 06:17, Xiaoguang Wang wrote:
>>>>>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>>>>>> percpu_ref_put() for registered files, but it's hard to say they're very
>>>>>> light-weight synchronization primitives. In one our x86 machine, I get below
>>>>>> perf data(registered files enabled):
>>>>>> Samples: 480K of event 'cycles', Event count (approx.): 298552867297
>>>>>> Overhead  Comman  Shared Object     Symbol
>>>>>>    0.45%  :53243  [kernel.vmlinux]  [k] io_file_get
>>>>>
>>>>> Do you have throughput/latency numbers? In my experience for polling for
>>>>> such small overheads all CPU cycles you win earlier in the stack will be
>>>>> just burned on polling, because it would still wait for the same fixed*
>>>>> time for the next response by device. fixed* here means post-factum but
>>>>> still mostly independent of how your host machine behaves. 
>>>>
>>>> That's only true if you can max out the device with a single core.
>>>> Freeing any cycles directly translate into a performance win otherwise,
>>>> if your device isn't the bottleneck. For the high performance testing
>>>
>>> Agree, that's what happens if a host can't keep up with a device, or e.g.
>>
>> Right, and it's a direct measure of the efficiency. Moving cycles _to_
>> polling is a good thing! It means that the rest of the stack got more
> 
> Absolutely, but the patch makes code a bit more complex and adds some
> overhead for non-iopoll path, definitely not huge, but the showed overhead
> reduction (i.e. 0.20%) doesn't do much either. Comparing with left 0.25%
> it costs just a couple of instructions.
> 
> And that's why I wanted to see if there is any real visible impact.

Definitely, it's always a tradeoff between the size of the win and
complexity and other factors. Especially adding to io_kiocb is a big
negative in my book.

>> efficient. And if the device is fast enough, then that'll directly
>> result in higher peak IOPS and lower latencies.
>>
>>> in case 2. of my other reply. Why don't you mention throwing many-cores
>>> into a single many (poll) queue SSD?
>>
>> Not really relevant imho, you can obviously always increase performance
>> if you are core limited by utilizing multiple cores. 
>>
>> I haven't tested these patches yet, will try and see if I get some time
>> to do so tomorrow.
> 
> Great

Ran it through the polled testing which is core limited, and I didn't
see any changes...

-- 
Jens Axboe

