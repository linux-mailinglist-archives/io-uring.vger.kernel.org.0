Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C262B6A28
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 17:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgKQQan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 11:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgKQQam (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 11:30:42 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9C2C0613CF
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 08:30:42 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id n12so21796691ioc.2
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 08:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BvnLgfinEhMSq8XYJCYgClsGBjlAZ8Z5XmZ47/Nk33Q=;
        b=X3h2xeDGoF970RrjsaHwL3NLIn6dvb+ygIScBH1jPKP1XQ8plkFjbxud4ecM2ZdP3U
         J/49w4GQjAlAAq4T/mP6tRZ9mNeHqPU0h7BfDLn/fYiUUXvt2sbYQQbAPjMSaBcaXLPA
         ESRh5K9FvBbdVPHYRMx+BTKwSAAz6aBjILFqNMLA+g69IlVW8zm6BcI4yP6DTH71wfwc
         pUgIMJPcEj9XgdQ8rCMyAXh0/ubTosdHI7kcCSdsZ5oHHdJ6UtgXhd4+fmVep9nAtJkq
         KYF5cILIFAonzCbIHVQx0kAXNZcNTPyv09PP+GWsyBSNiFCE5AglP6MRR/qRDboPzLMN
         9lTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BvnLgfinEhMSq8XYJCYgClsGBjlAZ8Z5XmZ47/Nk33Q=;
        b=rMEFbwnT2eG2LAtZtI3CRwm2v1qZuy3WK2AYlACRDBpN7Ti6QlBQVb/sWhtiHI0XPb
         VT6SugF/+e8n10Pbkbn3KA7fM/tOTLeBJXvrfrknMwg5Se6PG67tMFZgd+ycVKBzKCUw
         SuOxCEJm6HLWJh814OJCWm28gchHrD9jdCJv9kHWwPCjF+CIUdsRNHtfAAh+CR64lBmB
         kVkvUGC6n7nKFYz4DHmNVGz8PrbfBtsDy6mVO7MUu7kGVu9G0U2UML4LGJErGY7vyvOA
         6io0vBt1m/2nNIaKd9WmqUFZSxc1/TqlwL56wTmseMf5UhBWtOqLan0duTKWCEJoUa4r
         bEPg==
X-Gm-Message-State: AOAM530nXQ28cgkWwgR22HU+DOaW4nC0rcVkJSM6DZ8WTjA8cqLJ1QoZ
        dPuE0wnZvN8yPzhy6p2/fnn5mf5u686drA==
X-Google-Smtp-Source: ABdhPJxQoBuKdqad2aAmB8ZF5b2A3MT+50Eo3TpVo9bnSWXYFEBTmeK2nCnrov4/KayPsGK+1TVS1g==
X-Received: by 2002:a02:90ca:: with SMTP id c10mr4460013jag.115.1605630641857;
        Tue, 17 Nov 2020 08:30:41 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p24sm13974182ill.59.2020.11.17.08.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 08:30:41 -0800 (PST)
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9713dc32-8aea-5fd2-8195-45ceedcb74dd@kernel.dk>
Date:   Tue, 17 Nov 2020 09:30:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/17/20 3:43 AM, Pavel Begunkov wrote:
> On 17/11/2020 06:17, Xiaoguang Wang wrote:
>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>> percpu_ref_put() for registered files, but it's hard to say they're very
>> light-weight synchronization primitives. In one our x86 machine, I get below
>> perf data(registered files enabled):
>> Samples: 480K of event 'cycles', Event count (approx.): 298552867297
>> Overhead  Comman  Shared Object     Symbol
>>    0.45%  :53243  [kernel.vmlinux]  [k] io_file_get
> 
> Do you have throughput/latency numbers? In my experience for polling for
> such small overheads all CPU cycles you win earlier in the stack will be
> just burned on polling, because it would still wait for the same fixed*
> time for the next response by device. fixed* here means post-factum but
> still mostly independent of how your host machine behaves. 

That's only true if you can max out the device with a single core.
Freeing any cycles directly translate into a performance win otherwise,
if your device isn't the bottleneck. For the high performance testing
I've done, the actual polling isn't the bottleneck, it's the rest of the
stack.

-- 
Jens Axboe

