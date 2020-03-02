Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4F175D5D
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 15:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgCBOjK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 09:39:10 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:44497 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgCBOjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 09:39:10 -0500
Received: by mail-io1-f66.google.com with SMTP id u17so6781473iog.11
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 06:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VF4NFZmN5o/HRzGoFEDSL5KAYzABdGMBxEm52R7GbTc=;
        b=OGDWm1iEUdp2JmA24XXx32+8bhLiI0aeWpsUVLVV08trU/8bxFz8gZA88Y0rJUoxc3
         NX7NaMUkAkW0l27/InvwueG6kdzoO60vUELABusPUeae9iRP7pv97GXg6pkdjzMZNS32
         kWKe+0JdNkDXnzvv/cZX/G2CTbQwau7FiskmcUWtx7DN+231YDZJ3BUBO/A0d6IMnN5c
         ry2bRg91AZ7KKysvI3g5iwWlGqQY0/lzA4BTPUQiC/f17hnjwL3Mtmkya8AcCgymKBMd
         L+yYDP8FsSwyNyMVts79wNcAEWGHM8U46GIKcwxc+IqUjGyFPqKwHwhZuKHfsjhSYCZ9
         NREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VF4NFZmN5o/HRzGoFEDSL5KAYzABdGMBxEm52R7GbTc=;
        b=elds11fZnL89csG+MBAULSV5F5NECGvEXu9YNyAGjOkfT8ebolIc8GGDy5aoBP01Fd
         40Lie+VuhJWWNg+Odu/uedJ7sG3znYglA8LsFJPyxxG+kHOO9oENkEbbog0f9+YB4S2W
         xf66Qzt8AJOGvr0Co713HR+nKPDrEVSFffYihjbxTW4LkJmLWXp3y+rk1369u13+oOQh
         7GztMT8VEmvVURwWvR+rqlNKEFNj9+ZY/nBUdhw7hiU3tX3CyO8JD4t8bpvILMC+lMls
         GB7+DmsWz7XBUxDzx+QRDqWHZD9w3b+dWK/zVXQuYyIl30+IhLlWg2xMLtcmDrB9DKnX
         DF8Q==
X-Gm-Message-State: APjAAAVDgXEaAZme8acoSzyu483S1BLAmziQ0Ec5k0+APY4ZFUr7/W4V
        49wePQGyFRak6K7yuQhezcd6GSWWQrY=
X-Google-Smtp-Source: APXvYqyGxOkQmtUr5WLL2P8ZNd/bicDvtZpWSMvqDHmEvVINVFPmRv9aABrGn9xbzpIs9zlcOxWibA==
X-Received: by 2002:a5d:8b11:: with SMTP id k17mr13402720ion.290.1583159949731;
        Mon, 02 Mar 2020 06:39:09 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u15sm3656525iog.15.2020.03.02.06.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 06:39:09 -0800 (PST)
Subject: Re: [PATCH RFC 0/9] nxt propagation + locking optimisation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <d54ddeae-ad02-6232-36f3-86d09105c7a4@kernel.dk>
 <cab8e903-fb6f-eae5-68a6-2a467160997e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2f974d5e-8aa4-5b12-d70e-668384b4a94c@kernel.dk>
Date:   Mon, 2 Mar 2020 07:39:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cab8e903-fb6f-eae5-68a6-2a467160997e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/20 1:33 PM, Pavel Begunkov wrote:
> On 01/03/2020 22:14, Jens Axboe wrote:
>> On 3/1/20 9:18 AM, Pavel Begunkov wrote:
>>> There are several independent parts in the patchset, but bundled
>>> to make a point.
>>> 1-2: random stuff, that implicitly used later.
>>> 3-5: restore @nxt propagation
>>> 6-8: optimise locking in io_worker_handle_work()
>>> 9: optimise io_uring refcounting
>>>
>>> The next propagation bits are done similarly as it was before, but
>>> - nxt stealing is now at top-level, but not hidden in handlers
>>> - ensure there is no with REQ_F_DONT_STEAL_NEXT
>>>
>>> [6-8] is the reason to dismiss the previous @nxt propagation appoach,
>>> I didn't found a good way to do the same. Even though it looked
>>> clearer and without new flag.
>>>
>>> Performance tested it with link-of-nops + IOSQE_ASYNC:
>>>
>>> link size: 100
>>> orig:  501 (ns per nop)
>>> 0-8:   446
>>> 0-9:   416
>>>
>>> link size: 10
>>> orig:  826
>>> 0-8:   776
>>> 0-9:   756
>>
>> This looks nice, I'll take a closer look tomorrow or later today. Seems
>> that at least patch 2 should go into 5.6 however, so may make sense to
>> order the series like that.
> 
> It's the first one modifying io-wq.c, so should be fine to pick from
> the middle as is.

Yep, just did.

>> BTW, Andres brought up a good point, and that's hashed file write works.
>> Generally they complete super fast (just copying into the page cache),
>> which means that that worker will be hammering the wq lock a lot. Since
>> work N+1 can't make any progress before N completes (since that's how
>> hashed work works), we should pull a bigger batch of these work items
>> instead of just one at the time. I think that'd potentially make a huge
>> difference for the performance of buffered writes.
> 
> Flashed the same thought. It should be easy enough for hashed
> requests. Though, general batching would make us to think about
> fairness, work stealing, etc.

There's only the one list anyway, so the work is doing to be processed
in order to begin with. Hence I don't think there's a lot of fairness to
be worried about here, we're just going to be processing the existing
work in the same order, but more efficiently. We should be getting both
better throughput and fairness if we remove all items hashed to the same
key for that one worker, only stopping if we encounter a non-hashed work
or work hashed to a different key. Because if we do, if any of that
hashed work ever needs to sleep, the next independent work can proceed
in a different worker.

> BTW, what's the point of hashing only heads of a link? Sounds like it
> can lead to the write-write collisions, which it tries to avoid.

Yeah, the linked items should be hashed as well, not sure why that isn't
done.

>> Just throwing it out there, since you're working in that space anyway
>> and the rewards will be much larger.
> 
> I will take a look, but not sure when, I yet have some hunches myself.

Thanks!

-- 
Jens Axboe

