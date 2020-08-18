Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3513724880F
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 16:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgHROoe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 10:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHROoe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 10:44:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62031C061389
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 07:44:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so9872794pgf.0
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 07:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wf4sgDnrBFhA4UxZfkA/pFmIuSv8kqHK3iXtJYDrJ4s=;
        b=gfKO6/d0uG1Zp4jInidLIQoV2n/e4eakWM/9j3fRJqU+gKHwRQ8BRdPNC10th4IGlo
         dD7rXF1i7qZA5og3xAyQuYfHixW3xx4sRo3oKZCwNvW0q+0RiQje6GZodjr6oWz5Ccx3
         FVetAgPDJg5/CvuC5CLqCUAGlKLJCV5D6qF7zzTN63ptlODEsHMEkpKk3fz7JsC0UXxU
         6c6bprrPvPyjriHNCe9AtWclK9DoMtLs8s+EZyMC9rkBaAlvhzgXptq+5gXQRCceHN4V
         tpOYDcOS14NR7Wk4KSNRwqZlkDL2U42+QHQZQ1rex8LncILSHMab9ICuzJ46anA513Y4
         V9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wf4sgDnrBFhA4UxZfkA/pFmIuSv8kqHK3iXtJYDrJ4s=;
        b=qWcxMFfqwkHFP9cZnqz5me+EMGXqRwv7ID7ua3k5zQlVNKu2Ak4wR4R4RsKhCPRmB7
         6X0CNq0Ldja/Q97vwUugJn2RxnfPFYGTC2SzdMPsEWMqByRcCRaXvzh0ViZk4h8ic+Jn
         45kDuv4Ct5JIBpH6CR71X5AxpIoMzitHZgBA9pQCGnDEuGLzCvrnaa6Lmjy0UftFQspn
         UnnEOAPQs7uHb6LVv3X3pUsad87PDJ3j6b1wfKUD2Hkm6IqcucNnlQ7YiAyiYypXrw58
         0dasAjpf8LvtI8z83bOf1+Q4VyI1OYi4ed+TJyuuZO8v9fN4g5Gtl2Eh94VymOxZDnPM
         KP9Q==
X-Gm-Message-State: AOAM53243ml3/rfF3iIUiJJMvSTmxdKVbozGjIkmyKpYOeGdNy7g2vaE
        JESq+hjtawlgEs4RZcL0vQWJCUCvwxuq48diDqM=
X-Google-Smtp-Source: ABdhPJw8BCJcmio6VlymsBakkkoLjEhkBIgPuDiTi3v2KyBfR5qhEdyApwvRiQ5mvPE5HP2HITrM+Q==
X-Received: by 2002:a63:8f08:: with SMTP id n8mr14143718pgd.9.1597761869829;
        Tue, 18 Aug 2020 07:44:29 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:9214:36a5:5cec:a06d? ([2605:e000:100e:8c61:9214:36a5:5cec:a06d])
        by smtp.gmail.com with ESMTPSA id c15sm24670094pfo.115.2020.08.18.07.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 07:44:28 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        Anoop C S <anoopcs@cryptolab.net>
Cc:     david@fromorbit.com, jmoyer@redhat.com
References: <20200814195449.533153-1-axboe@kernel.dk>
 <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
 <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
 <97c2c3ab-d25b-e6bb-e8aa-a551edecc7b5@kernel.dk>
 <e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk>
 <5f6d3f16-cd0c-9598-4484-6003101eb47a@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <db051fac-da0f-9546-2c32-1756d9e74529@kernel.dk>
Date:   Tue, 18 Aug 2020 07:44:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5f6d3f16-cd0c-9598-4484-6003101eb47a@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/20 12:40 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>>>>> Will this be backported?
>>>>
>>>> I can, but not really in an efficient manner. It depends on the async
>>>> buffered work to make progress, and the task_work handling retry. The
>>>> latter means it's 5.7+, while the former is only in 5.9+...
>>>>
>>>> We can make it work for earlier kernels by just using the thread offload
>>>> for that, and that may be worth doing. That would enable it in
>>>> 5.7-stable and 5.8-stable. For that, you just need these two patches.
>>>> Patch 1 would work as-is, while patch 2 would need a small bit of
>>>> massaging since io_read() doesn't have the retry parts.
>>>>
>>>> I'll give it a whirl just out of curiosity, then we can debate it after
>>>> that.
>>>
>>> Here are the two patches against latest 5.7-stable (the rc branch, as
>>> we had quite a few queued up after 5.9-rc1). Totally untested, just
>>> wanted to see if it was doable.
>>>
>>> First patch is mostly just applied, with various bits removed that we
>>> don't have in 5.7. The second patch just does -EAGAIN punt for the
>>> short read case, which will queue the remainder with io-wq for
>>> async execution.
>>>
>>> Obviously needs quite a bit of testing before it can go anywhere else,
>>> but wanted to throw this out there in case you were interested in
>>> giving it a go...
>>
>> Actually passes basic testing, and doesn't return short reads. So at
>> least it's not half bad, and it should be safe for you to test.
>>
>> I quickly looked at 5.8 as well, and the good news is that the same
>> patches will apply there without changes.
> 
> Thanks, but I was just curios and I currently don't have the environment to test, sorry.
> 
> Anoop: you helped a lot reproducing the problem with 5.6, would you be able to
> test the kernel patches against 5.7 or 5.8, while reverting the samba patches?
> See https://lore.kernel.org/io-uring/e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk/T/#t for the
> whole discussion?

I'm actually not too worried about the short reads not working, it'll
naturally fall out correctly if the rest of the path is sane. The latter
is what I'd be worried about! I ran some synthetic testing and haven't
seen any issues so far, so maybe (just maybe) it's actually good.

I can setup two branches with the 5.7-stable + patches and 5.8-stable +
patches if that helps facilitate testing?

-- 
Jens Axboe

