Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA413EBB4D
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 19:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhHMRVV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 13:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhHMRVU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Aug 2021 13:21:20 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E1AC061756;
        Fri, 13 Aug 2021 10:20:52 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so7376072wmi.1;
        Fri, 13 Aug 2021 10:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IHcHwoO+YvyHAqpESPLSfrO5JSgyr2FJHdd37yi0v1g=;
        b=jmnNZ8IBrqfqveCnY/74OylQQ1OVLyVgSuiiQ+4pw8p9yz2FMPFKv4aj0ZEcDtCv4+
         IZ3TM8+5kYW9lhmNbqjpW2MiIoXetHivjSM5D3+ptF1/v8XLbPXAb10ivIscmZsZBhYm
         3Ynrov3pB0whCJSqHLT70CQqOjOMgBn/FRF2rT4DlHxduoMMzgagjJ9qw4OjqPsXMuV7
         Uop3AwxRmjdqGwU4SKrr+2Iob7ukF6rjG0SnK9afrjCIv3KA3VoFkcYeLVvLTZ99rvvm
         UXPEaxTJD19FQSOwK7jLSu2pVYhbf/xo5nm0HHrl/ECVDDnYLBBMnuHTn0mdlDr7jR4a
         LEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IHcHwoO+YvyHAqpESPLSfrO5JSgyr2FJHdd37yi0v1g=;
        b=GBAaAYkyGDIPr6yWaAFNTJ8tz+LuVKbseWXyyLBfkfNG9xgsOYz7wXWXmV4BtgqlfD
         YSCMTmPSKtxSXluv4Out7nZKZhH4ovLHMck8dkPPKQTaB7huaRtUEUU85wBc6KAcdGg3
         nw9gbQmbchH/U6dl/1ekH0IyiI33b7a+EQvNdDYimjck9kAoD8DoBWClkWcgPU64kM8P
         8YzpCDXp/p/BqhM9F12t2xvFX5EtEUN7u7MiBcq4+ssNR8oGNc4aBFkNEOHjn1JzzPrD
         eVhGwuUb5dmNXAM5VxaJCP2QPEnBXK2gHJxIFXNGpo8LMWNAKHDnx71SC42yyO6wtDpp
         9rHw==
X-Gm-Message-State: AOAM533MB0t/YNEbUi8YvjtrvQO4XOOCzFrnea0Ov32xZVdl25ncrEfe
        q97npey+32DlGNBdZNysxkE=
X-Google-Smtp-Source: ABdhPJyO7cQ+riv/1XGihAr8zLgoQGQ53CQe0uL62INja0KU8Je4XsNs1YjMNMJFTpqxQoPOar73AA==
X-Received: by 2002:a1c:2381:: with SMTP id j123mr33179wmj.68.1628875250690;
        Fri, 13 Aug 2021 10:20:50 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id i3sm2003543wmb.17.2021.08.13.10.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 10:20:50 -0700 (PDT)
To:     Paul Cercueil <paul@crapouillou.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-iio@vger.kernel.org, io-uring@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>
References: <2H0SXQ.2KIK2PBVRFWH2@crapouillou.net>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: IIO, dmabuf, io_uring
Message-ID: <a343b14f-6b7e-e377-9ae0-871e23b70453@gmail.com>
Date:   Fri, 13 Aug 2021 18:20:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2H0SXQ.2KIK2PBVRFWH2@crapouillou.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Paul,

On 8/13/21 12:41 PM, Paul Cercueil wrote:
> Hi,
> 
> A few months ago we (ADI) tried to upstream the interface we use with our high-speed ADCs and DACs. It is a system with custom ioctls on the iio device node to dequeue and enqueue buffers (allocated with dma_alloc_coherent), that can then be mmap'd by userspace applications. Anyway, it was ultimately denied entry [1]; this API was okay in ~2014 when it was designed but it feels like re-inventing the wheel in 2021.
> 
> Back to the drawing table, and we'd like to design something that we can actually upstream. This high-speed interface looks awfully similar to DMABUF, so we may try to implement a DMABUF interface for IIO, unless someone has a better idea.
> 
> Our first usecase is, we want userspace applications to be able to dequeue buffers of samples (from ADCs), and/or enqueue buffers of samples (for DACs), and to be able to manipulate them (mmapped buffers). With a DMABUF interface, I guess the userspace application would dequeue a dma buffer from the driver, mmap it, read/write the data, unmap it, then enqueue it to the IIO driver again so that it can be disposed of. Does that sound sane?
> 
> Our second usecase is - and that's where things get tricky - to be able to stream the samples to another computer for processing, over Ethernet or USB. Our typical setup is a high-speed ADC/DAC on a dev board with a FPGA and a weak soft-core or low-power CPU; processing the data in-situ is not an option. Copying the data from one buffer to another is not an option either (way too slow), so we absolutely want zero-copy.
> 
> Usual userspace zero-copy techniques (vmsplice+splice, MSG_ZEROCOPY etc) don't really work with mmapped kernel buffers allocated for DMA [2] and/or have a huge overhead, so the way I see it, we would also need DMABUF support in both the Ethernet stack and USB (functionfs) stack. However, as far as I understood, DMABUF is mostly a DRM/V4L2 thing, so I am really not sure we have the right idea here.
> 
> And finally, there is the new kid in town, io_uring. I am not very literate about the topic, but it does not seem to be able to handle DMA buffers (yet?). The idea that we could dequeue a buffer of samples from the IIO device and send it over the network in one single syscall is appealing, though.

You might be interested to look up zctap, previously a.k.a netgpu.

For io_uring, it's work in progress as well.

> 
> Any thoughts? Feedback would be greatly appreciated.
> 
> Cheers,
> -Paul
> 
> [1]: https://lore.kernel.org/linux-iio/20210217073638.21681-1-alexandru.ardelean@analog.com/T/#m6b853addb77959c55e078fbb06828db33d4bf3d7
> [2]: https://newbedev.com/zero-copy-user-space-tcp-send-of-dma-mmap-coherent-mapped-memory

-- 
Pavel Begunkov
