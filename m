Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570641D1D8E
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 20:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbgEMSeR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 14:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730472AbgEMSeR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 14:34:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127F0C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 11:34:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so171297plr.4
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 11:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SH+sjMwZuOMM8o6r6yEzeEIldRD9YZTLwHLIdvFCJLI=;
        b=1awYWNJjGLthqdDg8sO8PfSRDks8MSzZ9Qopf8YhOB7PmVSKOiNOnqwarpt9C1LqRA
         3FDYE5WjX0+Z7z+R7haOLF8qKtXVdIxRwd19AJQ3IBMOa0eU4ZBJ656K3O65t00sRQ3y
         DVOjGp/VoPnYRM/YgOZpK+NS1vCN+8sMQZYAW6WGGHLpHmQYxghtIIZc4BfDidi8Zl7p
         n/YQtytQItl59JA7LZJEV54OEbTcFCc3/1/CF32JcrvcDepdcpwKOReP1zdu44URGuCU
         +WRrSoAQOwpCPIup1HowigObyROu3yUPQRfW3rvJM/g3Q51WGrSxz43cw+Ze+yIVrMvD
         9iTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SH+sjMwZuOMM8o6r6yEzeEIldRD9YZTLwHLIdvFCJLI=;
        b=mWDp/0Uphra9w6lQMwcJznvDnoVCDeD5h752R3kGuSh9cJgfoxFJSCDr6RuFhCuK9B
         ZnQIPFnc2dS8LK26kyz4CH04rHGkydHojq/kjvUtrCwGTi05LjGzhUxRjNovwOdoJ+Mb
         HGV0uXhie8HUIVp5iGZB1dACEPQj8jxXUk51A9shQBOjbiQ0UYa8mBER19DcsnnQGBOO
         e5qeHKlg5kZctpg8jLIBigGYQ99qx2HWCDuDKtk3RDWYZVMN+2dTlxyzDs/8COusF2Na
         ckZCBnoxAVk4KTWDavFlL3vWWeTaBSMBB/zmGK+DO3EzrUuHCmt+vT5WtKvpFVtosrhK
         NukQ==
X-Gm-Message-State: AOAM531fScFv2l3xzhMjgJ4In2mJu05vhwacaBsicyDraXn9jF5wu9OA
        fr3kwRxUxnJtHIjQQviXSvNmgYChwA0=
X-Google-Smtp-Source: ABdhPJwaWdgZJDB6FkHbh50cGMWPvrkyRzNSC4EjlEgDHl9rlJGIryZ1sfGk7fwP/kmM/1U9t+F1NQ==
X-Received: by 2002:a17:902:b58e:: with SMTP id a14mr425108pls.247.1589394855415;
        Wed, 13 May 2020 11:34:15 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:e16c:b526:b72a:3095? ([2605:e000:100e:8c61:e16c:b526:b72a:3095])
        by smtp.gmail.com with ESMTPSA id 28sm16329433pjh.43.2020.05.13.11.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 11:34:14 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Jann Horn <jannh@google.com>
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f1b2cbf8-a253-edb2-5e0a-5a1e5d45afa2@kernel.dk>
Date:   Wed, 13 May 2020 12:34:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0eGT60a50GAkL3FVvRzpXwhufdr+68k_X_qTgxyZ-oQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/20 11:42 AM, Jann Horn wrote:
> +slab allocator people
> 
> On Wed, May 13, 2020 at 6:30 PM Jens Axboe <axboe@kernel.dk> wrote:
>> I turned the quick'n dirty from the other day into something a bit
>> more done. Would be great if someone else could run some performance
>> testing with this, I get about a 10% boost on the pure NOP benchmark
>> with this. But that's just on my laptop in qemu, so some real iron
>> testing would be awesome.
> 
> 10% boost compared to which allocator? Are you using CONFIG_SLUB?

SLUB, yes.

>> The idea here is to have a percpu alloc cache. There's two sets of
>> state:
>>
>> 1) Requests that have IRQ completion. preempt disable is not enough
>>    there, we need to disable local irqs. This is a lot slower in
>>    certain setups, so we keep this separate.
>>
>> 2) No IRQ completion, we can get by with just disabling preempt.
> 
> The SLUB allocator has percpu caching, too, and as long as you don't
> enable any SLUB debugging or ASAN or such, and you're not hitting any
> slowpath processing, it doesn't even have to disable interrupts, it
> gets away with cmpxchg_double.
> 
> Have you profiled what the actual problem is when using SLUB? Have you
> tested with CONFIG_SLAB_FREELIST_HARDENED turned off,
> CONFIG_SLUB_DEBUG turned off, CONFIG_TRACING turned off,
> CONFIG_FAILSLAB turned off, and so on? As far as I know, if you
> disable all hardening and debugging infrastructure, SLUB's
> kmem_cache_alloc()/kmem_cache_free() on the fastpaths should be really
> straightforward. And if you don't turn those off, the comparison is
> kinda unfair, because your custom freelist won't respect those flags.

But that's sort of the point. I don't have any nasty SLUB options
enabled, just the default. And that includes CONFIG_SLUB_DEBUG. Which
all the distros have enabled, I believe.

So yes, I could compare to a bare bones SLUB, and I'll definitely do
that because I'm curious. And it also could be an artifact of qemu,
sometimes that behaves differently than a real host (locks/irq is more
expensive, for example). Not sure how much with SLUB in particular,
haven't done targeted benchmarking of that.

The patch is just tossed out there for experimentation reasons, in case
it wasn't clear. It's not like I'm proposing this for inclusion. But if
the wins are big enough over a _normal_ configuration, then it's
definitely tempting.

> When you build custom allocators like this, it interferes with
> infrastructure meant to catch memory safety issues and such (both pure
> debugging code and safety checks meant for production use) - for
> example, ASAN and memory tagging will no longer be able to detect
> use-after-free issues in objects managed by your custom allocator
> cache.
> 
> So please, don't implement custom one-off allocators in random
> subsystems. And if you do see a way to actually improve the
> performance of memory allocation, add that to the generic SLUB
> infrastructure.

I hear you. This isn't unique, fwiw. Networking has a page pool
allocator for example, which I did consider tapping into.

Anyway, I/we will be a lot wiser once this experiment progresses!

>> Outside of that, any freed requests goes to the ce->alloc_list.
>> Attempting to alloc a request will check there first. When freeing
>> a request, if we're over some threshold, move requests to the
>> ce->free_list. This list can be browsed by the shrinker to free
>> up memory. If a CPU goes offline, all requests are reaped.
>>
>> That's about it. If we go further with this, it'll be split into
>> a few separate patches. For now, just throwing this out there
>> for testing. The patch is against my for-5.8/io_uring branch.
> 
> That branch doesn't seem to exist on
> <https://git.kernel.dk/cgit/linux-block/>...

Oh oops, guess I never pushed that out. Will do so.

-- 
Jens Axboe

