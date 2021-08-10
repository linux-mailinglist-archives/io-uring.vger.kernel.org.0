Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17B93E7C6B
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 17:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbhHJPgR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 11:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243431AbhHJPfc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 11:35:32 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09400C0617A3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 08:35:07 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t3so21577046plg.9
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 08:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nR8YctFL5B0SSsa7y1WkY61j6y5/YrI3CCuj+ivqB6g=;
        b=s4HDcpICxGOo9X3YnyGDyflzaU/7wIIvfntKWqOuQIOuDSW9MQ740mFHR3wbTwDxpZ
         dyTOnzE+3MT3SfW+wYNGA5S4uz0Tp6W7rSh63WprNa7qqpE1Joss+PvmojyrO48ScgEO
         cAhYOHiSUITz2isZLFdKobeh5tCPN6g6cDeyYeO/A98nPph4WMgf/LHBFo6VNFc3SdNk
         Ltm+9m9sRYCLFOE035M64+zB+9EMmIoarM3YiGGnnJViD3OsGswZtRPIUmld5pO1BkD0
         KjftX7v6lwIVRQqqc4g24+iRMbkje4qsgvWDhHh8jeX2NoA0x7X58XEVaIwThc2OJTPC
         0gJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nR8YctFL5B0SSsa7y1WkY61j6y5/YrI3CCuj+ivqB6g=;
        b=NSwtbDbhi41QR/mj9uUCVENdMOhkrtR0xvWaFahRGA4Q1tkZLpjXa6hl82gz8JBK9E
         hkcQEGomUGCOhcn62s4CVn9wHAYSlUaUcDCkoee+mnL+y6qHp7lHgO/F9rk7Vwetb1Nt
         v4nfgfZGnThO+6OYbgdeV0EqkQkMn7/J17S7ZAH6TKCDQSS666GtqbW14h0icZv/HIgs
         z28CzTb3AYpZFATMCS2hh0Xhy7AdZc/ko0SsSCuyO6xMdKSn+FOMlQkU+qV/R4IbMsRQ
         DBrL0/NDp2/7Z9JLoxV9fCF7qtGYUxrvAvTcLt9IxsIB2sELYVPbzZ4u7Z6L0tft5REF
         Y0aQ==
X-Gm-Message-State: AOAM533DeFA9vRiyTqRtMHPZK6/JjWEV69De4heNIcXTHBbl5UIGMJ7f
        SL3BVWewtKo3pLtEjhDLRx73xw==
X-Google-Smtp-Source: ABdhPJwYQ1J/WRWbXYZJ47wy5zG3kRG3JktyeO/40nU12gmx+bi67uzOoUshTsf12LiDTlyjkYfShA==
X-Received: by 2002:a63:788e:: with SMTP id t136mr41067pgc.374.1628609706372;
        Tue, 10 Aug 2021 08:35:06 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g6sm24266512pfh.111.2021.08.10.08.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 08:35:06 -0700 (PDT)
Subject: Re: [PATCH 1/4] bio: add allocation cache abstraction
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-2-axboe@kernel.dk> <YRJ74uUkGfXjR52l@T590>
 <79511eac-d5f2-2be3-f12c-7e296d9f1a76@kernel.dk>
 <6c06ac42-bda4-cef6-6b8e-7c96eeeeec47@kernel.dk>
 <6f57bfcd-a080-8f3e-63c7-ab40296390a6@kernel.dk>
Message-ID: <50967d4e-a482-35b8-86d1-78ed7ebc11d5@kernel.dk>
Date:   Tue, 10 Aug 2021 09:35:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6f57bfcd-a080-8f3e-63c7-ab40296390a6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 8:48 AM, Jens Axboe wrote:
> On 8/10/21 8:24 AM, Jens Axboe wrote:
>> On 8/10/21 7:53 AM, Jens Axboe wrote:
>>> On 8/10/21 7:15 AM, Ming Lei wrote:
>>>> Hi Jens,
>>>>
>>>> On Mon, Aug 09, 2021 at 03:23:58PM -0600, Jens Axboe wrote:
>>>>> Add a set of helpers that can encapsulate bio allocations, reusing them
>>>>> as needed. Caller must provide the necessary locking, if any is needed.
>>>>> The primary intended use case is polled IO from io_uring, which will not
>>>>> need any external locking.
>>>>>
>>>>> Very simple - keeps a count of bio's in the cache, and maintains a max
>>>>> of 512 with a slack of 64. If we get above max + slack, we drop slack
>>>>> number of bio's.
>>>>>
>>>>> The cache is intended to be per-task, and the user will need to supply
>>>>> the storage for it. As io_uring will be the only user right now, provide
>>>>> a hook that returns the cache there. Stub it out as NULL initially.
>>>>
>>>> Is it possible for user space to submit & poll IO from different io_uring
>>>> tasks?
>>>>
>>>> Then one bio may be allocated from bio cache of the submission task, and
>>>> freed to cache of the poll task?
>>>
>>> Yes that is possible, and yes that would not benefit from this cache
>>> at all. The previous version would work just fine with that, as the
>>> cache is just under the ring lock and hence you can share it between
>>> tasks.
>>>
>>> I wonder if the niftier solution here is to retain the cache in the
>>> ring still, yet have the pointer be per-task. So basically the setup
>>> that this version does, except we store the cache itself in the ring.
>>> I'll give that a whirl, should be a minor change, and it'll work per
>>> ring instead then like before.
>>
>> That won't work, as we'd have to do a ctx lookup (which would defeat the
>> purpose), and we don't even have anything to key off of at that point...
>>
>> The current approach seems like the only viable one, or adding a member
>> to kiocb so we can pass in the cache in question. The latter did work
>> just fine, but I really dislike the fact that it's growing the kiocb to
>> more than a cacheline.
> 
> One potential way around this is to store the bio cache pointer in the
> iov_iter. Each consumer will setup a new struct to hold the bio etc, so
> we can continue storing it in there and have it for completion as well.
> 
> Upside of that is that we retain the per-ring cache, instead of
> per-task, and iov_iter has room to hold the pointer without getting near
> the cacheline size yet.
> 
> The downside is that it's kind of odd to store it in the iov_iter, and
> I'm sure that Al would hate it. Does seem like the best option though,
> in terms of getting the storage for the cache "for free".

Here's that approach:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-bio-cache.3

totally untested so far.

-- 
Jens Axboe

