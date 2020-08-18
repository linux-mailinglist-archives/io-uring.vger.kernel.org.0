Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33057248DA2
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 20:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHRSA7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 14:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHRSA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 14:00:56 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FF1C061389
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 11:00:56 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d19so10097684pgl.10
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 11:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xFxaZrktigujPyKdHXWsUudJt3SvpJAyXfhnJ5d+0bE=;
        b=vD8rgHvsQHfcZepaA3QNP83DpCIXWT8Vlx2rw+ww6BnmPXRUhROe89gTU2LCwpktc5
         Tz4ELTgOv58Tl5toKT3BPbSsUOkpcIe+XGMgwZcF4Ydwe4JjL2nHwrr6eIJ/vqEbbstO
         Lw3gk8tCnrmR7XR1yIEzUR+hdoqcmbYJN9d0WLW75BfhdT4/IiD7ZJ7ZMUlMAQ+f+EcK
         h5YDvyB0rwEo1UhqOgM3mWl4GK8pPbBaKS6Rz/dobdQhyQJY4QsaIsI5oSL6IOl7mCfF
         RaIr6bw8OKu6/mIXQaJLjNwWC/9nH3TpqHBankLSipFKGT5SwXp8X3aovPsZAuRn51SZ
         g3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xFxaZrktigujPyKdHXWsUudJt3SvpJAyXfhnJ5d+0bE=;
        b=IbSpvQJBX+nMXDwXxvTpJHtT22fClC9hu2+6bEBxQPGP7A91/AhcxnZ2OGFAn8SvsB
         nQ4TOV9mjzvuxK9zZqrBEm6p3GpXzDtY+x/IzBcj3KQ/vk7RNkFknfVUGmbeXM1D4vi4
         J6LD1bHaB/JsyP89tS4OJWVTVXfZuSH5uEWbkuzDMKnQ4CfAgGj6OmO93dZk5yApUoYU
         u5oo+XdJeL1jnPmTjqbjT0fGC9dbyuDbTVpAqF6tGvNeyB29CTjn021LNk58Wukv29TT
         vhHGCBBm2Whq9EA5qq7ay+YPni/X+is8iON9VuBpUN/Gf5kBGAxT30O+4/XXPoIOKP6O
         emIQ==
X-Gm-Message-State: AOAM533VosSpcw9WLrF4jsJpxBmAOgCZ38B9URues4tWaLI67LUt4HKi
        RfyY+6hVcSMyK4OdG6sq0wlw3g==
X-Google-Smtp-Source: ABdhPJy0xP1Gg+Fw3A693jm716FNBWMyHpcR6am3wAHKKihatO8oOxh+gNOVfuWKvJ6P5AFfEt1jPQ==
X-Received: by 2002:a63:1d23:: with SMTP id d35mr13588111pgd.291.1597773655850;
        Tue, 18 Aug 2020 11:00:55 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:9214:36a5:5cec:a06d? ([2605:e000:100e:8c61:9214:36a5:5cec:a06d])
        by smtp.gmail.com with ESMTPSA id y79sm24540757pfb.65.2020.08.18.11.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 11:00:54 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
 <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
 <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
 <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
 <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
 <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk>
 <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
 <aadb4728-abc5-b070-cd3b-02f480f27d61@kernel.dk>
 <x49sgclf0w8.fsf@segfault.boston.devel.redhat.com>
 <8cc4bc11-eb56-63e1-bb5c-702b75068462@kernel.dk>
 <x49blj7x2hh.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <56f5cc5c-e915-60be-4e25-4a22ec734612@kernel.dk>
Date:   Tue, 18 Aug 2020 11:00:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x49blj7x2hh.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/20 10:55 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 8/17/20 1:55 PM, Jeff Moyer wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> On 8/13/20 4:21 PM, Jeff Moyer wrote:
>>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>>
>>>>>>>>> BTW, what git sha did you run?
>>>>>>>>
>>>>>>>> I do see a failure with dm on that, I'll take a look.
>>>>>>>
>>>>>>> I ran it on a file system atop nvme with 8 poll queues.
>>>>>>>
>>>>>>> liburing head: 9e1d69e078ee51f253a829ff421b17cfc996d158
>>>>>>> linux-block head: ff1353802d86a9d8e40ef1377efb12a1d3000a20
>>>>>>
>>>>>> Fixed it, and actually enabled a further cleanup.
>>>>>
>>>>> Great, thanks!  Did you push that out somewhere?
>>>>
>>>> It's pushed to io_uring-5.9, current sha is:
>>>>
>>>> ee6ac2d3d5cc50d58ca55a5967671c9c1f38b085
>>>>
>>>> FWIW, the issue was just for fixed buffers. It's running through the
>>>> usual testing now.
>>>
>>> OK.  Since it was an unrelated problem, I was expecting a separate
>>> commit for it.  What was the exact issue?  Is it something that needs
>>> backporting to -stable?
>>
>> No, it was a bug in the posted patch, so I just folded in the fix.
> 
> We must be hitting different problems, then.  I just tested your
> 5.7-stable branch (running the test suite from an xfs file system on an
> nvme partition with polling enabled), and the read-write test fails:
> 
> Running test read-write:
> Non-vectored IO not supported, skipping
> cqe res -22, wanted 2048
> test_buf_select_short vec failed
> Test read-write failed with ret 1
> 
> That's with this head: a451911d530075352fbc7ef9bb2df68145a747ad

Not sure what this is, haven't seen that here and my regular liburing
runs include both xfs-on-nvme(with poll queues) as one of the test
points. Seems to me like there's two oddities in the above:

1) Saying that Non-vectored isn't supported, that is not true on 5.7.
   This is due to an -EINVAL return.
2) The test_buf_select_short_vec failure

I'll see if I can reproduce this. Anything special otherwise enabled?
Scheduler on the nvme device? nr_requests? XFS options?

-- 
Jens Axboe

