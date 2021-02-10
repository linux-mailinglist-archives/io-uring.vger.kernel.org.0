Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA1F31691E
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhBJO2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 09:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhBJO2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 09:28:05 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F3AC061574
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 06:27:24 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id o15so992278ilt.6
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 06:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=r35bJ24M7EKbRfNRfGvpSel3Q7Ah/3uTrXqPC5CT0xU=;
        b=G0ffB6PEDfDxbk4/w87ZurplzyWzFaYhu5IPxij9Oih5o+7OP63JiHzPOFVxw6Iiup
         yvZ4ZXjmw/vHns2S7m6eXzUyB8VWR+wLF9um7T94fk9PTkzN+4h3fRjaUKn4WoW0afBJ
         8kb05QGvt0lGTt6g0Mv25k+9V+OSCJttiPu3scQhBrn1XOGjM0WyCBLmUPuaBvQeNbT1
         KWyogEmU46QdMpvEhGH72HqaeV7VN5VzDrki/IketEcOK8qKgD9JLGlOwr0B6pJ40VRF
         76ZBNkmnWhPBuPdp4tlCFo68ZEZrYEGpSLY/J40DCZoIDQs/rkNbno1QiO/0KJgThvCd
         X0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r35bJ24M7EKbRfNRfGvpSel3Q7Ah/3uTrXqPC5CT0xU=;
        b=oL6Zu1332gRJFqt/X9+MsYGCgEYmuhQ6cICyZhIuXW41Tjlx9kBd2bApvFWHUHAW+9
         WEFvgX7Z3DaUKZ+7tzV5Tkwf/QyaPXATbq0izIOFdMfT6fANof4jPTmSOENt9MzUr7d7
         qu9l1ocXAfWqmEjrQGnGIt0S7gD+askVQ2Xrws0PfUn99CW5+EVPflv1YGVmXtiOP6Pn
         yYu+U4hnbkZdTDsV86MNaWsb08g9v/Dgo7For7Sn5aC0xFmu1siIWBe3FbDt+8MyKOuH
         IUaSsKtVoyHMnfhoyOXH+mQrram7jQDQV52uGayRhk2LoFJnQRdZGiFaQOJXPqHfM1AC
         BcsA==
X-Gm-Message-State: AOAM531VmUo6aAfNtH0JJKtamxrfDfN52DKBQtaH+e1X+cOdKy+XHyM+
        RvdSGVK/mrfxnDf4IXTfd6iWsDu0mX0VM6A5
X-Google-Smtp-Source: ABdhPJxTsjxUqIxYhmmUYNrrMCxctLj08G6ZgdKUsV6Yac47Pe1B9+UWxd/+rTLYGE9NBvSMqEvyXQ==
X-Received: by 2002:a92:db12:: with SMTP id b18mr1338879iln.261.1612967243439;
        Wed, 10 Feb 2021 06:27:23 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d2sm1085938ilr.66.2021.02.10.06.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:27:23 -0800 (PST)
Subject: Re: [PATCH RFC 00/17] playing around req alloc
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
 <ffaf0640-7747-553d-9baf-4d41777a4d4d@kernel.dk>
 <dcc61d65-d6e0-14e0-7368-352501fc21ea@gmail.com>
 <a9a0d663-f6ac-1086-8cd7-ad4583b1cb7c@kernel.dk>
 <f9001a4a-6cc4-2346-e7b0-402a076783eb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f952b11d-514b-bb0d-ef2a-98ca669867e6@kernel.dk>
Date:   Wed, 10 Feb 2021 07:27:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f9001a4a-6cc4-2346-e7b0-402a076783eb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/21 4:53 AM, Pavel Begunkov wrote:
> On 10/02/2021 03:23, Jens Axboe wrote:
>> On 2/9/21 8:14 PM, Pavel Begunkov wrote:
>>> On 10/02/2021 02:08, Jens Axboe wrote:
>>>> On 2/9/21 5:03 PM, Pavel Begunkov wrote:
>>>>> Unfolding previous ideas on persistent req caches. 4-7 including
>>>>> slashed ~20% of overhead for nops benchmark, haven't done benchmarking
>>>>> personally for this yet, but according to perf should be ~30-40% in
>>>>> total. That's for IOPOLL + inline completion cases, obviously w/o
>>>>> async/IRQ completions.
>>>>
>>>> And task_work, which is sort-of inline.
>>>>
>>>>> Jens,
>>>>> 1. 11/17 removes deallocations on end of submit_sqes. Looks you
>>>>> forgot or just didn't do that.
>>>
>>> And without the patches I added, it wasn't even necessary, so
>>> nevermind
>>
>> OK good, I was a bit confused about that one...
>>
>>>>> 2. lists are slow and not great cache-wise, that why at I want at least
>>>>> a combined approach from 12/17.
>>>>
>>>> This is only true if you're browsing a full list. If you do add-to-front
>>>> for a cache, and remove-from-front, then cache footprint of lists are
>>>> good.
>>>
>>> Ok, good point, but still don't think it's great. E.g. 7/17 did improve
>>> performance a bit for me, as I mentioned in the related RFC. And that
>>> was for inline-completed nops, and going over the list/array and
>>> always touching all reqs.
>>
>> Agree, array is always a bit better. Just saying that it's not a huge
>> deal unless you're traversing the list, in which case lists are indeed
>> horrible. But for popping off the first entry (or adding one), it's not
>> bad at all.
> 
> btw, looks can be replaced with a singly-linked list (stack).

It could, yes.

>>>>> 3. Instead of lists in "use persistent request cache" I had in mind a
>>>>> slightly different way: to grow the req alloc cache to 32-128 (or hint
>>>>> from the userspace), batch-alloc by 8 as before, and recycle _all_ reqs
>>>>> right into it. If  overflows, do kfree().
>>>>> It should give probabilistically high hit rate, amortising out most of
>>>>> allocations. Pros: it doesn't grow ~infinitely as lists can. Cons: there
>>>>> are always counter examples. But as I don't have numbers to back it, I
>>>>> took your implementation. Maybe, we'll reconsider later.
>>>>
>>>> It shouldn't grow bigger than what was used, but the downside is that
>>>> it will grow as big as the biggest usage ever. We could prune, if need
>>>> be, of course.
>>>
>>> Yeah, that was the point. But not a deal-breaker in either case.
>>
>> Agree
>>
>>>> As far as I'm concerned, the hint from user space is the submit count.
>>>
>>> I mean hint on setup, like max QD, then we can allocate req cache
>>> accordingly. Not like it matters
>>
>> I'd rather grow it dynamically, only the first few iterations will hit
>> the alloc. Which is fine, and better than pre-populating. Assuming I
>> understood you correctly here...
> 
> I guess not, it's not about number of requests perse, but space in
> alloc cache. Like that
> 
> struct io_submit_state {
> 	...
> 	void			*reqs[userspace_hint];
> };
> 
>>
>>>>
>>>>> I'll revise tomorrow on a fresh head + do some performance testing,
>>>>> and is leaving it RFC until then.
>>>>
>>>> I'll look too and test this, thanks!
>>
>> Tests out good for me with the suggested edits I made. nops are
>> massively improved, as suspected. But also realistic workloads benefit
>> nicely.
>>
>> I'll send out a few patches I have on top tomorrow. Not fixes, but just
>> further improvements/features/accounting.
> 
> Sounds great!
> btw, "lock_free_list" which is not a "lock-free" list can be
> confusing, I'd suggest to rename it to free_list_lock.

Or maybe just locked_free_list would make it more understandable. The
current name is misleading.

-- 
Jens Axboe

