Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E26315DC6
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 04:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhBJDTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 22:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhBJDTV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 22:19:21 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E71C061574
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 19:18:40 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i5so593265wmq.2
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 19:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HiWk9s+naMRkWUu/3jFinmX9lzvIv8YgDBnHAIgYNeY=;
        b=FWDzvab/qLFhcYoT35AgZT5tnf1bYXXBC8XxCasaMUAgm8WePynLYjnk1/tNPBsXvb
         xCXWje9tHMeGEPmkK7IfnKp2wihrxFUOvnhE1nuH+UWfpleYrXys/+EwQF9N90OW9yD7
         hbmt2SCGo/i++QsL2h4JS8IqXzR+FcmWYG2+7PK5BLog3n8pq1iRVUST3TC0PiazwyWd
         BIy/ByMzzfAJ7IvgN1Kh5ypxwfYpti3+0lQbjDcnQKBK47BJXBlBx5lzvnnTbKTuOddG
         ObCE/Ysg3nhY+Gkmsfzux6cdMsfC01aA+leCyZhZwZOD636nDhGfOEfe4puaghpK32ZB
         Rt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HiWk9s+naMRkWUu/3jFinmX9lzvIv8YgDBnHAIgYNeY=;
        b=b2igjhZ9BAFt3rT2Arqs53Cy/znNNcHnDUcoHvzL/IKRoIjrcKInt25sllJcRkLFuM
         FXzgSgCZjtkO1HSR57usR4KNB1C5ldscF4iSiy4byyqFsBC0uq1/w/lly9hmDLrYuNi1
         GwfZ7aJaARnldB6dKh2C0JiU+3SlMN8dcROtKRcXI+20eA9xD1EO4vhEF0IeivTDgauF
         Str5MpS4WzXP9PuY42SIdt4JRO0o4tEREntGRwzQ2TtDwj6VqhB1sQ7kUwep0vW2iqUx
         57MV9vqx18ERqy2a5cnF4K57h+EMV3FeXf9RN4OBlQLsjzHAW3wQRBaGlNe4jgjQO/kf
         86pg==
X-Gm-Message-State: AOAM531bGCEviQC0aqKIiyPuC8zBwGnaLqVX51dfMDFlHj1GDJ62q3Lv
        VB41zbBoO4PHu35pxB/VzFSW8zcNN9Wezw==
X-Google-Smtp-Source: ABdhPJzlKDuZCqSMBXiL857oKTo0K9i6eSeK9cxE/DLlkyxj+k2SwsUcV4cqBaRB5OUO9szHBwHzdw==
X-Received: by 2002:a05:600c:4ec6:: with SMTP id g6mr944195wmq.2.1612927118774;
        Tue, 09 Feb 2021 19:18:38 -0800 (PST)
Received: from [192.168.8.191] ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id o124sm836230wmo.41.2021.02.09.19.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 19:18:38 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
 <ffaf0640-7747-553d-9baf-4d41777a4d4d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH RFC 00/17] playing around req alloc
Message-ID: <dcc61d65-d6e0-14e0-7368-352501fc21ea@gmail.com>
Date:   Wed, 10 Feb 2021 03:14:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ffaf0640-7747-553d-9baf-4d41777a4d4d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/02/2021 02:08, Jens Axboe wrote:
> On 2/9/21 5:03 PM, Pavel Begunkov wrote:
>> Unfolding previous ideas on persistent req caches. 4-7 including
>> slashed ~20% of overhead for nops benchmark, haven't done benchmarking
>> personally for this yet, but according to perf should be ~30-40% in
>> total. That's for IOPOLL + inline completion cases, obviously w/o
>> async/IRQ completions.
> 
> And task_work, which is sort-of inline.
> 
>> Jens,
>> 1. 11/17 removes deallocations on end of submit_sqes. Looks you
>> forgot or just didn't do that.

And without the patches I added, it wasn't even necessary, so
nevermind

>>
>> 2. lists are slow and not great cache-wise, that why at I want at least
>> a combined approach from 12/17.
> 
> This is only true if you're browsing a full list. If you do add-to-front
> for a cache, and remove-from-front, then cache footprint of lists are
> good.

Ok, good point, but still don't think it's great. E.g. 7/17 did improve
performance a bit for me, as I mentioned in the related RFC. And that
was for inline-completed nops, and going over the list/array and
always touching all reqs.

> 
>> 3. Instead of lists in "use persistent request cache" I had in mind a
>> slightly different way: to grow the req alloc cache to 32-128 (or hint
>> from the userspace), batch-alloc by 8 as before, and recycle _all_ reqs
>> right into it. If  overflows, do kfree().
>> It should give probabilistically high hit rate, amortising out most of
>> allocations. Pros: it doesn't grow ~infinitely as lists can. Cons: there
>> are always counter examples. But as I don't have numbers to back it, I
>> took your implementation. Maybe, we'll reconsider later.
> 
> It shouldn't grow bigger than what was used, but the downside is that
> it will grow as big as the biggest usage ever. We could prune, if need
> be, of course.

Yeah, that was the point. But not a deal-breaker in either case.

> 
> As far as I'm concerned, the hint from user space is the submit count.

I mean hint on setup, like max QD, then we can allocate req cache
accordingly. Not like it matters

> 
>> I'll revise tomorrow on a fresh head + do some performance testing,
>> and is leaving it RFC until then.
> 
> I'll look too and test this, thanks!
> 

-- 
Pavel Begunkov
