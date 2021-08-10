Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B11C3E5E61
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 16:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbhHJOvL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 10:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241650AbhHJOtS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 10:49:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D8AC0613C1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 07:48:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so5752241pjb.3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 07:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D7b0H/WI2oJ3v/Z3U82xDpo/pUUk6BOu/D4wZSYWfJI=;
        b=ruhUrdhbeRv1BCcwEegnma6exIMv5ambqQIbor9NofU/pQxrqV4Lp4Fz/ZHRbHJrB+
         Wr3LTU8nS9Q3foE80dHnSOv6ofHSloKvFBE01ptbqxHF1GCIQLpVo7ceVp5ueYSegQD8
         gCqXbj9iYGxhDuiLBgrBwqsnbnO29z5LL/q9VkdxfAp/DJGSxPANU/PdVrQ+BA+gAHfG
         RFq51lPPdoZ4G/uo6gs9R/UzutpzUCtQ10IdgjZ7GFA8x2T/CR1/XMu/mheuaQ4llXkR
         4JmPrbb9b3AOAvNTEpP8VCAEcUByM4cCJas/5J2da9tZM4AUCxXBiEMjmQDEFpQMjtD8
         cKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D7b0H/WI2oJ3v/Z3U82xDpo/pUUk6BOu/D4wZSYWfJI=;
        b=WSPBjs+4mhIeOAdiRBZ23HV1fojWdA/zP1EBNZrgWfWSEJrAJAfklZNZx42pzrKluc
         byv/McqC0Nsd0wtnrEyR0OzNbTbLQV21BoOfnSmbeh9gVy4erTU2fsPOMB1jnpIckvCY
         4LaNw0IBpqsP/FZ5B7H+y1xBRJ+E0PSYp3yWqERhn1zSZw7er0Jr0dhQTmtWi0aGv5sB
         c9XE49drJWIEEXTN60SB7XfXpQjNEKf0HAx5oecpG2LA3eUc9nIBcfe7w2aNzvEE7zlY
         y6Ro+gwll/fYRp3R0GZnkf/b0Fmad9/y5n2tvqg2CIvSWt4GpJ3RdZhm6LpzhW4vyLot
         hhPQ==
X-Gm-Message-State: AOAM5301Q6COje/YABY1YraSqkqd2r5ihwL6G6FTVnXf21uw6uJY2orI
        WdahYCp4XNnN7TmbUsd4ZLRZXA==
X-Google-Smtp-Source: ABdhPJwksFrQV1HSSbVL7IsIXtXscoa/fFeQJAFYGPMmNWU4tlHgsY3YYCDr7XhZlpJ+hh4Hr8xypQ==
X-Received: by 2002:a17:90a:65cc:: with SMTP id i12mr32099059pjs.36.1628606920039;
        Tue, 10 Aug 2021 07:48:40 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id u18sm15839648pfg.25.2021.08.10.07.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 07:48:39 -0700 (PDT)
Subject: Re: [PATCH 1/4] bio: add allocation cache abstraction
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-2-axboe@kernel.dk> <YRJ74uUkGfXjR52l@T590>
 <79511eac-d5f2-2be3-f12c-7e296d9f1a76@kernel.dk>
 <6c06ac42-bda4-cef6-6b8e-7c96eeeeec47@kernel.dk>
Message-ID: <6f57bfcd-a080-8f3e-63c7-ab40296390a6@kernel.dk>
Date:   Tue, 10 Aug 2021 08:48:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6c06ac42-bda4-cef6-6b8e-7c96eeeeec47@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 8:24 AM, Jens Axboe wrote:
> On 8/10/21 7:53 AM, Jens Axboe wrote:
>> On 8/10/21 7:15 AM, Ming Lei wrote:
>>> Hi Jens,
>>>
>>> On Mon, Aug 09, 2021 at 03:23:58PM -0600, Jens Axboe wrote:
>>>> Add a set of helpers that can encapsulate bio allocations, reusing them
>>>> as needed. Caller must provide the necessary locking, if any is needed.
>>>> The primary intended use case is polled IO from io_uring, which will not
>>>> need any external locking.
>>>>
>>>> Very simple - keeps a count of bio's in the cache, and maintains a max
>>>> of 512 with a slack of 64. If we get above max + slack, we drop slack
>>>> number of bio's.
>>>>
>>>> The cache is intended to be per-task, and the user will need to supply
>>>> the storage for it. As io_uring will be the only user right now, provide
>>>> a hook that returns the cache there. Stub it out as NULL initially.
>>>
>>> Is it possible for user space to submit & poll IO from different io_uring
>>> tasks?
>>>
>>> Then one bio may be allocated from bio cache of the submission task, and
>>> freed to cache of the poll task?
>>
>> Yes that is possible, and yes that would not benefit from this cache
>> at all. The previous version would work just fine with that, as the
>> cache is just under the ring lock and hence you can share it between
>> tasks.
>>
>> I wonder if the niftier solution here is to retain the cache in the
>> ring still, yet have the pointer be per-task. So basically the setup
>> that this version does, except we store the cache itself in the ring.
>> I'll give that a whirl, should be a minor change, and it'll work per
>> ring instead then like before.
> 
> That won't work, as we'd have to do a ctx lookup (which would defeat the
> purpose), and we don't even have anything to key off of at that point...
> 
> The current approach seems like the only viable one, or adding a member
> to kiocb so we can pass in the cache in question. The latter did work
> just fine, but I really dislike the fact that it's growing the kiocb to
> more than a cacheline.

One potential way around this is to store the bio cache pointer in the
iov_iter. Each consumer will setup a new struct to hold the bio etc, so
we can continue storing it in there and have it for completion as well.

Upside of that is that we retain the per-ring cache, instead of
per-task, and iov_iter has room to hold the pointer without getting near
the cacheline size yet.

The downside is that it's kind of odd to store it in the iov_iter, and
I'm sure that Al would hate it. Does seem like the best option though,
in terms of getting the storage for the cache "for free".

-- 
Jens Axboe

