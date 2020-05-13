Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC601D1FD7
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 22:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgEMUJT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 16:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387445AbgEMUJT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 16:09:19 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D37C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 13:09:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f4so221594pgi.10
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 13:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=odPRiSe8khfy7ohFJpbmDMC5PLQjZ5y6DzMomFbp5xg=;
        b=oongAyt3NKd1MX3jceVXwpIIs/tDMSoN/vZ+BCakcME7NWPegVCaXLOVudhhtViiKn
         V+mK3IJ3NkY3pN8P1P1uAt6B+IWRtjNFTeW6NPp5pTurY7o7s3t+4ra7FqumyiIOJMSD
         1d3bdPwrP3aBXRUW1fWmMCz5Rx9616s/vdG68ZDH7EzF1GN4WOS1WRqgYLbEZodeqG7I
         BTKcE4l//fpkJz9Ny8FbEABbJN/L6nDtXhOD5A3SFtal4lzDJjhpMukrjx3sOB84sWdh
         cenhbeBxIL4QQiMMZcvDOHaiUdqp/KhV+jgwtUqogNNBKIHO2ODmwbmI93nmgrARkW/a
         MiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=odPRiSe8khfy7ohFJpbmDMC5PLQjZ5y6DzMomFbp5xg=;
        b=GsYNS1NBmEOxxKv0q6HiWGnVDRKP9LKF+tPInijEuiavaqEMmvrez0J8B0TFFK1aE8
         KbjQzbfM06OSyZJbyGQ5+4DgF/dRsQqD5sVcGHbYtjKBdUF4d6e6k3/HWNtjv1T1cXLI
         SOzirizdMqQ3PUcBXtAkBnF0w4RyFMod980msh9grggbDuta6Nb3A2fYgeLSIk6xMQOD
         lpkafp0iSk9C9vkqyVhF2jP2iPtf8nczBPJKH/OL5/p3iqcyissSP9MXh7KXHOHBOuSU
         4U+TvYe44r42SmX3K2Kdzp5dw8Zum8NVTdYUvhQF/ENhtzSq2RdrE/1vMJWh3nG3/5M/
         lY+A==
X-Gm-Message-State: AOAM530KSUsnOudsmN10czvgbya8YFLygfzi2G0QB1hAb2ip+dfFAlK4
        H10UyV1lTA2dqdFskKO+SCzh1A==
X-Google-Smtp-Source: ABdhPJwWIOjg3aOHPqEIvBsOXRgpDMjdwvsb2/ZpQfOL2+I1C9kGu2JAv9l5CnHrHdF7vxnyZx1XBg==
X-Received: by 2002:a63:1348:: with SMTP id 8mr929534pgt.350.1589400557214;
        Wed, 13 May 2020 13:09:17 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4833:bff6:8281:ef26? ([2605:e000:100e:8c61:4833:bff6:8281:ef26])
        by smtp.gmail.com with ESMTPSA id j5sm342442pfa.37.2020.05.13.13.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 13:09:16 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Pekka Enberg <penberg@iki.fi>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <CAG48ez0eGT60a50GAkL3FVvRzpXwhufdr+68k_X_qTgxyZ-oQQ@mail.gmail.com>
 <20200513191919.GA10975@nero>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fb43ddb4-693b-5c07-775f-3142502495de@kernel.dk>
Date:   Wed, 13 May 2020 14:09:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200513191919.GA10975@nero>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/20 1:20 PM, Pekka Enberg wrote:
> 
> Hi,
> 
> On Wed, May 13, 2020 at 6:30 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> I turned the quick'n dirty from the other day into something a bit 
>>> more done. Would be great if someone else could run some
>>> performance testing with this, I get about a 10% boost on the pure
>>> NOP benchmark with this. But that's just on my laptop in qemu, so
>>> some real iron testing would be awesome.
> 
> On 5/13/20 8:42 PM, Jann Horn wrote:> +slab allocator people
>> 10% boost compared to which allocator? Are you using CONFIG_SLUB?
>  
> On Wed, May 13, 2020 at 6:30 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> The idea here is to have a percpu alloc cache. There's two sets of 
>>> state:
>>>
>>> 1) Requests that have IRQ completion. preempt disable is not
>>> enough there, we need to disable local irqs. This is a lot slower
>>> in certain setups, so we keep this separate.
>>>
>>> 2) No IRQ completion, we can get by with just disabling preempt.
> 
> On 5/13/20 8:42 PM, Jann Horn wrote:> +slab allocator people
>> The SLUB allocator has percpu caching, too, and as long as you don't 
>> enable any SLUB debugging or ASAN or such, and you're not hitting
>> any slowpath processing, it doesn't even have to disable interrupts,
>> it gets away with cmpxchg_double.
> 
> The struct io_kiocb is 240 bytes. I don't see a dedicated slab for it in
> /proc/slabinfo on my machine, so it likely got merged to the kmalloc-256
> cache. This means that there's 32 objects in the per-CPU cache. Jens, on
> the other hand, made the cache much bigger:

Right, it gets merged with kmalloc-256 (and 5 others) in my testing.

> +#define IO_KIOCB_CACHE_MAX 256
> 
> So I assume if someone does "perf record", they will see significant
> reduction in page allocator activity with Jens' patch. One possible way
> around that is forcing the page allocation order to be much higher. IOW,
> something like the following completely untested patch:

Now tested, I gave it a shot. This seems to bring performance to
basically what the io_uring patch does, so that's great! Again, just in
the microbenchmark test case, so freshly booted and just running the
case.

Will this patch introduce latencies or non-deterministic behavior for a
fragmented system?

-- 
Jens Axboe

