Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F152B73D6
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 02:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgKRBnC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 20:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgKRBnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 20:43:01 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E315C061A48
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 17:43:01 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id l11so130237plt.1
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 17:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c9Nn4KAPLTZSFDSsWUpcxg2E22usnYQB7t6Fs663lCw=;
        b=t7CTo0gdB7vXExrGI8NBBGdUc+np7s4/nCX8AETq2aLfUOgL0BdeDLCKCpch5j75pY
         laHBrETFKUTJyr6zm7di7/YHsZk3viQlNcBNW6ig36xVxwgIyTw42jLw2PU0+vQ97gOv
         N2yZNw0e2KEJYbtTMe+5M95iBHo7yCRGVQ9N7Pd8zOAu25jIamBa0dr5w+4p5k5pP/QY
         u++w3QKQ2CIFrp12fIL0sF9U/1XYBlWZHT5+IUsZjvkfROFGBjr4f46zIaYMI8BtsQVl
         3Op8gsm3oh/QhYDnm+0jqvmfjXeylvcI13ZhLTefzy68fCmrnC/OtXBzRMq3tKhCi292
         Pmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c9Nn4KAPLTZSFDSsWUpcxg2E22usnYQB7t6Fs663lCw=;
        b=AuilXq0ExdxE2kjl/RdPM+3kiZix4wXgul3NdPYb83Yzndp9euErxNgnSo5eYBhf7b
         Oito+Q7w33Bt80dYu/VOh2CPsuTbsb+snPsSRKXeSiS+19mxU/sWMk2N7eFC8H8NqUgR
         hD5dS8nRIkVCYkCDz1W/BMh/Ks5RBOWjvqcwHU93DQBUHS1Nj0vCuZ7Fh+Za740JNKZf
         yRkq/SVumtNkFM2Fe3Tr5Mfm4uXvfFNXxJmgBZvuJcz+RMY9OY8Uhr5VxUaGRijY5XgO
         fDYw9nRZjx5UHkgyBoQCTKrgoguD3AkirXy6Npf8aIGqI8MXevL4m62Oi5zUeXTtBDFp
         7WwA==
X-Gm-Message-State: AOAM532uMFzdQdzwGVIFUDznN12ZfcGcz9f991cFUCw11n+DI1/ZWDIp
        BFX5m1sMXylrHeVVraiaSSUCGdvswoNuUw==
X-Google-Smtp-Source: ABdhPJx8n/NyNx4Y4hTXl/QmoZb7VmuHfrWFJVWnC2+XgtNqxfT/04WsPknK+F3CN/eV7f0Mtrz+xA==
X-Received: by 2002:a17:90b:1258:: with SMTP id gx24mr1797199pjb.194.1605663780900;
        Tue, 17 Nov 2020 17:43:00 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y16sm23687372pfl.144.2020.11.17.17.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 17:43:00 -0800 (PST)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <148a36f1-ff60-4af6-7683-8849c9973010@kernel.dk>
Date:   Tue, 17 Nov 2020 18:42:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <82116595-2e57-525b-0619-2d71e874bd88@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/17/20 9:58 AM, Pavel Begunkov wrote:
> On 17/11/2020 16:30, Jens Axboe wrote:
>> On 11/17/20 3:43 AM, Pavel Begunkov wrote:
>>> On 17/11/2020 06:17, Xiaoguang Wang wrote:
>>>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>>>> percpu_ref_put() for registered files, but it's hard to say they're very
>>>> light-weight synchronization primitives. In one our x86 machine, I get below
>>>> perf data(registered files enabled):
>>>> Samples: 480K of event 'cycles', Event count (approx.): 298552867297
>>>> Overhead  Comman  Shared Object     Symbol
>>>>    0.45%  :53243  [kernel.vmlinux]  [k] io_file_get
>>>
>>> Do you have throughput/latency numbers? In my experience for polling for
>>> such small overheads all CPU cycles you win earlier in the stack will be
>>> just burned on polling, because it would still wait for the same fixed*
>>> time for the next response by device. fixed* here means post-factum but
>>> still mostly independent of how your host machine behaves. 
>>
>> That's only true if you can max out the device with a single core.
>> Freeing any cycles directly translate into a performance win otherwise,
>> if your device isn't the bottleneck. For the high performance testing
> 
> Agree, that's what happens if a host can't keep up with a device, or e.g.

Right, and it's a direct measure of the efficiency. Moving cycles _to_
polling is a good thing! It means that the rest of the stack got more
efficient. And if the device is fast enough, then that'll directly
result in higher peak IOPS and lower latencies.

> in case 2. of my other reply. Why don't you mention throwing many-cores
> into a single many (poll) queue SSD?

Not really relevant imho, you can obviously always increase performance
if you are core limited by utilizing multiple cores. 

I haven't tested these patches yet, will try and see if I get some time
to do so tomorrow.

-- 
Jens Axboe

