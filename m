Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5723D2F8FA4
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 23:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbhAPWMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 17:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbhAPWMt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 17:12:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29583C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 14:12:05 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id p15so6976893pjv.3
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 14:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=d88cp73oEPBlHRmVJUUxxFG6UPKkicALwKZ+8XK5yjc=;
        b=qJUpJpJY7UXxQ3Zxh/6T7e1YJYs2kLmTNbhinfFfVeY5pp0S9P+D2ZBhq12v6ufXJB
         4Y4/deXqDzrho7m2u7beH7uBfaEDQ/yMycB1KQDpYWVzRGB6MU25VXTdhiKQZccBvurs
         9nHgxWhrEVhH0lfFFAF5CUnveVgoK6W+TctsaNmLtNS+4gbEG/drqnBTZUD49jjJ/0BF
         MOFDqYJeUOOxUCS3sgybVbhnc+JJzZBdA+3mHenvDLJcAZEAEVIcQNLTZb83ZxaLiDu5
         +Jk4otDFHW7kaIgAK876bskwQhIPr/KYF01SKWt1k9IDuxRslv2wNcIzbcLhZlzlZegJ
         2Y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d88cp73oEPBlHRmVJUUxxFG6UPKkicALwKZ+8XK5yjc=;
        b=gStNhlUh+DNI1f5Ea919lQO05mlkod84pcHl1oSO3+nFBYE6ZoFgSOVmr9rP4yGzBC
         WxAGFqYSVAJxWZw52FEO0iPGP+K5Lb1Zprk0msSxnjCkkKw2k0JicsRvhpXy7z4ys6Z+
         vtbBFmQnEBNAJVXVppju+L2LPb4OCDkiVnHKsYxCO/VC5Y4qI0R5mHFjgy+rmWZRn/0h
         WepOm7r1cQX46QB0zb9sSOTSRmJgG1ULKxaqTWSzFx5KYlfX8489DK4ZqqnK/l2Jyn9y
         xid3tAFE0mx7oCUGf5Lq9M59CqOcD3xyuGfpm/5MLLRqWNUZD9kR7IMauKKbtEpKuyXf
         xovQ==
X-Gm-Message-State: AOAM532ajKUy2AtsHhVBs6CkyBroTBDomkYfEkZz4pZ9ew6ZOG2GfObc
        NQc7fUPvVXxIGtgwdV6g29f7x0VKEHUxJw==
X-Google-Smtp-Source: ABdhPJxkAXqvSeT+W1LzcyGh8gRX3JUxykl/+gC2J+fxQ/5gywi4YZ6V7Q0KwyCsO6YkXqH/nfd8cQ==
X-Received: by 2002:a17:90a:a60d:: with SMTP id c13mr17964810pjq.11.1610835124662;
        Sat, 16 Jan 2021 14:12:04 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id k4sm3176919pfk.44.2021.01.16.14.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 14:12:04 -0800 (PST)
Subject: Re: Fixed buffers have out-dated content
To:     Martin Raiber <martin@urbackup.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
 <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com>
 <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
 <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <61566b44-fe88-03b0-fd94-70acfc82c093@kernel.dk>
Date:   Sat, 16 Jan 2021 15:12:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/14/21 2:50 PM, Martin Raiber wrote:
> On 10.01.2021 17:50 Martin Raiber wrote:
>> On 09.01.2021 21:32 Pavel Begunkov wrote:
>>> On 09/01/2021 16:58, Martin Raiber wrote:
>>>> On 09.01.2021 17:23 Jens Axboe wrote:
>>>>> On 1/8/21 4:39 PM, Martin Raiber wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I have a gnarly issue with io_uring and fixed buffers (fixed
>>>>>> read/write). It seems the contents of those buffers contain old 
>>>>>> data in
>>>>>> some rare cases under memory pressure after a read/during a write.
>>>>>>
>>>>>> Specifically I use io_uring with fuse and to confirm this is not some
>>>>>> user space issue let fuse print the unique id it adds to each 
>>>>>> request.
>>>>>> Fuse adds this request data to a pipe, and when the pipe buffer is 
>>>>>> later
>>>>>> copied to the io_uring fixed buffer it has the id of a fuse request
>>>>>> returned earlier using the same buffer while returning the size of 
>>>>>> the
>>>>>> new request. Or I set the unique id in the buffer, write it to 
>>>>>> fuse (via
>>>>>> writing to a pipe, then splicing) and then fuse returns with e.g.
>>>>>> ENOENT, because the unique id is not correct because in kernel it 
>>>>>> reads
>>>>>> the id of the previous, already completed, request using this buffer.
>>>>>>
>>>>>> To make reproducing this faster running memtester (which mlocks a
>>>>>> configurable amount of memory) with a large amount of user memory 
>>>>>> every
>>>>>> 30s helps. So it has something to do with swapping? It seems to not
>>>>>> occur if no swap space is active. Problem occurs without warning when
>>>>>> the kernel is build with KASAN and slab debugging.
>>>>>>
>>>>>> If I don't use the _FIXED opcodes (which is easy to do), the problem
>>>>>> does not occur.
>>>>>>
>>>>>> Problem occurs with 5.9.16 and 5.10.5.
>>>>> Can you mention more about what kind of IO you are doing, I'm assuming
>>>>> it's O_DIRECT? I'll see if I can reproduce this.
>>>> It's writing to/reading from pipes (nonblocking, no O_DIRECT).
>>> A blind guess, does it handle short reads and writes? If not, can you
>>> check whether they happen or not?
>>
>> Something like this was what I suspected at first as well. It does 
>> check for short read/writes and I added (unnecessary -- because the 
>> fuse request structure is 40 bytes and it does io in page sizes) code 
>> for retrying short reads at some point. I also checked for the pipes 
>> to be empty before they are used at some point and let the kernel log 
>> allocation failures (idea was that it was short pipe read/writes 
>> because of allocation failure or that something doesn't get rewound 
>> properly in this case). Beyond that three things that make a user 
>> space problem unlikely:
>>
>>  - occurs only when using fixed buffers and does not occur when 
>> running same code without fixed buffer opcodes
>>  - doesn't occur when there is no memory pressure
>>  - I added print(k/f) logging that pointed me in this direction as well
>>
>>>> I can reproduce it with https://github.com/uroni/fuseuring on e.g. a 
>>>> 2GB VPS. Modify bench.sh so that fio loops. Add swap, then run 1400M 
>>>> memtester while it runs (so it swaps, I guess). I can try further 
>>>> reducing the reproducer, but I wanted to avoid that work in case it 
>>>> is something obvious. The next step would be to remove fuse from the 
>>>> equation -- it does try to move the pages from the pipe when 
>>>> splicing to it, for example.
> 
> When I use 5.10.7 with 09854ba94c6aad7886996bfbee2530b3d8a7f4f4 ("mm: 
> do_wp_page() simplification"), 1a0cf26323c80e2f1c58fc04f15686de61bfab0c 
> ("mm/ksm: Remove reuse_ksm_page()") and 
> be068f29034fb00530a053d18b8cf140c32b12b3 ("mm: fix misplaced unlock_page 
> in do_wp_page()") reverted the issue doesn't seem to occur.

Linus, I'm looking into the above report, all of it should still be
intact in the quoted section. Figured it would not hurt to loop you in,
in case this is a generic problem and since Martin identified that
reverting the above changes on the mm side makes it go away. Maybe
there's already some discussion elsewhere about it that I'm not privy
to.

-- 
Jens Axboe

