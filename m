Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CBF2B7EF6
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 15:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgKROCa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 09:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgKROCa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 09:02:30 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF79C0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 06:02:28 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id d18so2103063edt.7
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 06:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bmT7V57mMC8K8DnygmUSpDvWfoD4p6VjVGiTiJ4iy5w=;
        b=l6u6TNyazejiIx9XLA8cpwFL/8cd9p1VOHk+SbZb+/W5Xc5ZKc1TANR1tM9DeBte7R
         OF1m3kgcnFVRw8G4vhwxywc6dQDLLlIkJrFr3AZShoOKZWFjCpHeV7BtdcQVE63NszOm
         XSV+KMZKNOT7xoO4ETHL1iTS7PhhquGEFi446CxUc/JpCYrPL2cN7Eq45PTujKVGHz4H
         MNkpj4P6tVzNNswaR6YVvAvPMkgRHlx1kcTeAkt0QIkyHg07NHjHoQxDPB5vxaGaa/e1
         wSptnVJPdGorqepMFplGN59L41Xr3zokzceHc+0Zz4r1n93jSbqcdKqyn8uDJoXBvJ8R
         srwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bmT7V57mMC8K8DnygmUSpDvWfoD4p6VjVGiTiJ4iy5w=;
        b=XFycZMjZPZMAEzpvIh2zDBjZpJ0LhAhtsKnOdWe1tun3ulrUtBgYuE43vDmzrP2Sq5
         7wlyPMt3JY2w8v8h08o4o1+yYI9JEVQcOEvplnroFWcKoFAqjaQSf44TMXtl4XayLXb2
         8xebKknvPIjUyyhHx8WZB/mCgsguvUDi9Yhl/6hzkNuI7k/aj/koL/sGbx/kYbSgW938
         pg+xN2KDti7FeDq+QmnkeXEmqckUaLHf1WljmYnLP+pirdp/qX31bN5eWIyLnLAcnttB
         mzy/0a2CNMGsu+8KKKXcZREG6BvdnlUFboGayA2LDN7sRNe9a1npJqxTT3Hn5cmNzS1w
         iuwQ==
X-Gm-Message-State: AOAM533X85JWQJ4L1bTmUDG8OlAUJGvpJNPJgCoDzzK24rddugTEw9F3
        EswtgDDgpg+nFvS473Brm/AobSFvkgJLtg==
X-Google-Smtp-Source: ABdhPJx0cATZvNXUA3fktFQzy8tgUarw5TIOAAY9Yeiu02UTWnai7zVDpGJExerOIrnF2YeZQDLVxw==
X-Received: by 2002:a05:6402:1c0c:: with SMTP id ck12mr26536576edb.327.1605708147037;
        Wed, 18 Nov 2020 06:02:27 -0800 (PST)
Received: from [192.168.1.125] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id z14sm1727569ejx.58.2020.11.18.06.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 06:02:26 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
 <9713dc32-8aea-5fd2-8195-45ceedcb74dd@kernel.dk>
 <82116595-2e57-525b-0619-2d71e874bd88@gmail.com>
 <148a36f1-ff60-4af6-7683-8849c9973010@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
Message-ID: <f8e59ed9-4329-dada-cf16-329bdb7335be@gmail.com>
Date:   Wed, 18 Nov 2020 13:59:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <148a36f1-ff60-4af6-7683-8849c9973010@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/11/2020 01:42, Jens Axboe wrote:
> On 11/17/20 9:58 AM, Pavel Begunkov wrote:
>> On 17/11/2020 16:30, Jens Axboe wrote:
>>> On 11/17/20 3:43 AM, Pavel Begunkov wrote:
>>>> On 17/11/2020 06:17, Xiaoguang Wang wrote:
>>>>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>>>>> percpu_ref_put() for registered files, but it's hard to say they're very
>>>>> light-weight synchronization primitives. In one our x86 machine, I get below
>>>>> perf data(registered files enabled):
>>>>> Samples: 480K of event 'cycles', Event count (approx.): 298552867297
>>>>> Overhead  Comman  Shared Object     Symbol
>>>>>    0.45%  :53243  [kernel.vmlinux]  [k] io_file_get
>>>>
>>>> Do you have throughput/latency numbers? In my experience for polling for
>>>> such small overheads all CPU cycles you win earlier in the stack will be
>>>> just burned on polling, because it would still wait for the same fixed*
>>>> time for the next response by device. fixed* here means post-factum but
>>>> still mostly independent of how your host machine behaves. 
>>>
>>> That's only true if you can max out the device with a single core.
>>> Freeing any cycles directly translate into a performance win otherwise,
>>> if your device isn't the bottleneck. For the high performance testing
>>
>> Agree, that's what happens if a host can't keep up with a device, or e.g.
> 
> Right, and it's a direct measure of the efficiency. Moving cycles _to_
> polling is a good thing! It means that the rest of the stack got more

Absolutely, but the patch makes code a bit more complex and adds some
overhead for non-iopoll path, definitely not huge, but the showed overhead
reduction (i.e. 0.20%) doesn't do much either. Comparing with left 0.25%
it costs just a couple of instructions.

And that's why I wanted to see if there is any real visible impact.

> efficient. And if the device is fast enough, then that'll directly
> result in higher peak IOPS and lower latencies.
> 
>> in case 2. of my other reply. Why don't you mention throwing many-cores
>> into a single many (poll) queue SSD?
> 
> Not really relevant imho, you can obviously always increase performance
> if you are core limited by utilizing multiple cores. 
> 
> I haven't tested these patches yet, will try and see if I get some time
> to do so tomorrow.

Great

-- 
Pavel Begunkov
