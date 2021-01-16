Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1574E2F8EF1
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 20:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhAPTki (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 14:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbhAPTki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 14:40:38 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CC4C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 11:39:57 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y205so1874139pfc.5
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 11:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+zHZSPCh4F9Red86InPjr1ElViuJ0pXU9j2NycwlLj8=;
        b=B7qGow3CZ9VvwzUzFL4T6MleTzDxCMAcX7Wk51kkAFBXQlHymLI5ei8Ltit/t1sB4b
         JIYcO6KKhITRslO8WHZUjC4eALVM1Sh9qjLN4MSdNGaR4BCb9/tqeCC5Wn/pNl2JZlcP
         4XUi8exffZrnHl8S471Jy5t23ZRPLIS1d/GTUMlrfjwZALrHlE/QqtBmJ/LAAletxlTv
         BWL/hcS2rq9Z5+N8G9hzFe4q6pTPcX9uwpq6HW04Aj1YG9JC3Bu9Pz8xx+ti+B3NxyTB
         Z7Ecg0MRESkqcGVWKa471xqCf3ZS2lIRODtzKRJ/gP8VET9aXG7jvsICIe9KySDkdV5w
         zYeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+zHZSPCh4F9Red86InPjr1ElViuJ0pXU9j2NycwlLj8=;
        b=ud8oJnQl/NjeSRNMIdxBPUR4cA6Cde6GSxmibmZai2ybwkyW1acGnugP6SFYnyQydg
         gKoqZBFXuJMlIxBPurspn6/oGnO9JGzpo8ZXWlc9qhPizX9zRaFwW8Iwa2hVpTg5Wuoz
         k+/tq/M4ir3GoBLU7Z+6GZqWzuO85aXsMj6jDg4pD48fLYXsLTuOSUQXrbII+7dVSv/b
         RVqvjGAuId4Eg4K4lFdGOS8DhMEHA6fVc9ZdVD+Pxrw9na9BiLzuNuTwVOvhT2WcIpJm
         FZneRn0oZtancmy8CvztiYahzaeH+7kP+MhdkvwuaA2GH4yJjNBVTHurRqERKYqtH4qC
         yFKg==
X-Gm-Message-State: AOAM531xz5QSyAMrHUC2lCHwnSPRC26Ri/ihri4KIOXH3PfhWX1pjJOK
        +5n9/szF5XvHVDU6CdbQ17P3SMQzF5Nuaw==
X-Google-Smtp-Source: ABdhPJwtQmSF8lyMF0ry8AjrrBDMTAkD6f5qa4KEcBc9zrbm2QGWL9QAlhgy9rhH8f/EEaIMVgA9Vg==
X-Received: by 2002:a62:920c:0:b029:1ae:89f2:8c69 with SMTP id o12-20020a62920c0000b02901ae89f28c69mr19066730pfd.56.1610825996700;
        Sat, 16 Jan 2021 11:39:56 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id r20sm12013985pgb.3.2021.01.16.11.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 11:39:56 -0800 (PST)
Subject: Re: Fixed buffers have out-dated content
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Martin Raiber <martin@urbackup.org>, io-uring@vger.kernel.org
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
 <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com>
 <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
 <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
 <25f75e49-9d5e-fcab-e24b-8ad908254c2e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fb386017-3362-9cc6-8a9a-fe2233c9525d@kernel.dk>
Date:   Sat, 16 Jan 2021 12:39:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <25f75e49-9d5e-fcab-e24b-8ad908254c2e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/21 12:30 PM, Pavel Begunkov wrote:
> On 14/01/2021 21:50, Martin Raiber wrote:
>> On 10.01.2021 17:50 Martin Raiber wrote:
>>> On 09.01.2021 21:32 Pavel Begunkov wrote:
>>>> On 09/01/2021 16:58, Martin Raiber wrote:
>>>>> On 09.01.2021 17:23 Jens Axboe wrote:
>>>>>> On 1/8/21 4:39 PM, Martin Raiber wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I have a gnarly issue with io_uring and fixed buffers (fixed
>>>>>>> read/write). It seems the contents of those buffers contain old data in
>>>>>>> some rare cases under memory pressure after a read/during a write.
>>>>>>>
>>>>>>> Specifically I use io_uring with fuse and to confirm this is not some
>>>>>>> user space issue let fuse print the unique id it adds to each request.
>>>>>>> Fuse adds this request data to a pipe, and when the pipe buffer is later
>>>>>>> copied to the io_uring fixed buffer it has the id of a fuse request
>>>>>>> returned earlier using the same buffer while returning the size of the
>>>>>>> new request. Or I set the unique id in the buffer, write it to fuse (via
>>>>>>> writing to a pipe, then splicing) and then fuse returns with e.g.
>>>>>>> ENOENT, because the unique id is not correct because in kernel it reads
>>>>>>> the id of the previous, already completed, request using this buffer.
>>>>>>>
>>>>>>> To make reproducing this faster running memtester (which mlocks a
>>>>>>> configurable amount of memory) with a large amount of user memory every
>>>>>>> 30s helps. So it has something to do with swapping? It seems to not
>>>>>>> occur if no swap space is active. Problem occurs without warning when
>>>>>>> the kernel is build with KASAN and slab debugging.
>>>>>>>
>>>>>>> If I don't use the _FIXED opcodes (which is easy to do), the problem
>>>>>>> does not occur.
>>>>>>>
>>>>>>> Problem occurs with 5.9.16 and 5.10.5.
>>>>>> Can you mention more about what kind of IO you are doing, I'm assuming
>>>>>> it's O_DIRECT? I'll see if I can reproduce this.
>>>>> It's writing to/reading from pipes (nonblocking, no O_DIRECT).
>>>> A blind guess, does it handle short reads and writes? If not, can you
>>>> check whether they happen or not?
>>>
>>> Something like this was what I suspected at first as well. It does check for short read/writes and I added (unnecessary -- because the fuse request structure is 40 bytes and it does io in page sizes) code for retrying short reads at some point. I also checked for the pipes to be empty before they are used at some point and let the kernel log allocation failures (idea was that it was short pipe read/writes because of allocation failure or that something doesn't get rewound properly in this case). Beyond that three things that make a user space problem unlikely:
>>>
>>>  - occurs only when using fixed buffers and does not occur when running same code without fixed buffer opcodes
>>>  - doesn't occur when there is no memory pressure
>>>  - I added print(k/f) logging that pointed me in this direction as well
>>>
>>>>> I can reproduce it with https://github.com/uroni/fuseuring on e.g. a 2GB VPS. Modify bench.sh so that fio loops. Add swap, then run 1400M memtester while it runs (so it swaps, I guess). I can try further reducing the reproducer, but I wanted to avoid that work in case it is something obvious. The next step would be to remove fuse from the equation -- it does try to move the pages from the pipe when splicing to it, for example.
>>
>> When I use 5.10.7 with 09854ba94c6aad7886996bfbee2530b3d8a7f4f4 ("mm: do_wp_page() simplification"), 1a0cf26323c80e2f1c58fc04f15686de61bfab0c ("mm/ksm: Remove reuse_ksm_page()") and be068f29034fb00530a053d18b8cf140c32b12b3 ("mm: fix misplaced unlock_page in do_wp_page()") reverted the issue doesn't seem to occur.
> 
> Thanks for tracking it down. Was it reported to Linus and Peter?

That seems very strange and should then affect a bunch of other stuff,
too... Do you have a test case? I'd love to dive into this and figure
out what is going on, and would save me a lot of time.

-- 
Jens Axboe

