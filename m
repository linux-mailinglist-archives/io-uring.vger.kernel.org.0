Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF1E247D85
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 06:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgHREaw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 00:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgHREav (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 00:30:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789FBC061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 21:30:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p37so9166670pgl.3
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 21:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gjqn2Iykhy24y8R30kY3wUEgiYcH+rjHKaCdUccoIuw=;
        b=I5+Hx+1ENN7KqIJ5YX4TjWT24Vw5Apm6fZL6DVejgX+kRkeqZPDbe4T+xkdam3ld+C
         L1JpS5GeUzPAv7Ggup3+HHaXqjhIEfUlLi72ikHLrWrpPtHugAV1jTaFcN7dCH4vPW08
         LT3VXVeX6ws8jNpEnzbo0bxVBwsV2LdqE+rh/5/6E8mc+lypjv1ecyMy2JEAygft48SY
         4bqw3eROpqmbgfi5S2e1GJ+QtnKRsq76LixBljEcS/o5c8KhHlac4qRjcf47HgRaJt/v
         V3AwUlqYz0UUXL5N2fvHqGsgEkrpjcNhFrtk+YTv2Q4Fkg8xpilAHs8hNofD2HfM4UzI
         LnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gjqn2Iykhy24y8R30kY3wUEgiYcH+rjHKaCdUccoIuw=;
        b=hqXL1oqk+hDeMxRLEw8ne22k6Wlx4ytE276MG4eoYlZHxdzIgD6Ivo33DahUIA08h1
         6IuJ0wpzTc5zoKF6JZHVDeln3rlFbFqCoIy5poSMSkNBKlTWaFuGnUI40i/MIvn7V7fK
         DPT5Mr5DmrC6Q5DS/oIaJSyIBo6TQOuVC5iQtIVWF+qM45eIYc7Xag8NQVdyYhvQar05
         jufXWCkVNT8waxkcp/jtqg6TJGYuLrkTafmys9fQHi8roaFGJagPcE92zcAF3RlZJfVO
         Zl+xxoN2NQKA9F92eI42wdYWKHPJxYu5GO7TECamDYPTRd4vIQ1zRKnnzJ07SdIeQufw
         roSA==
X-Gm-Message-State: AOAM532UVV3VxhcpyI62jz3SvY6rhrWO2S5LOMeSXXxOJTKUz4InBghg
        uJd+Y2i+Fz5PVBCDvcIJuEbTK20nAeHsWMZrk2o=
X-Google-Smtp-Source: ABdhPJyKh2pHHoRU0M2OYC0Taex4NqWVZqTOawFmgwJyTINo/A3fsmeJSnYD4H+C2QoE5fZiPCTpng==
X-Received: by 2002:a63:e703:: with SMTP id b3mr12043683pgi.39.1597725050287;
        Mon, 17 Aug 2020 21:30:50 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:cef9:e56c:5fb2:d956? ([2605:e000:100e:8c61:cef9:e56c:5fb2:d956])
        by smtp.gmail.com with ESMTPSA id x9sm22474940pff.145.2020.08.17.21.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 21:30:49 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com
References: <20200814195449.533153-1-axboe@kernel.dk>
 <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
 <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
 <97c2c3ab-d25b-e6bb-e8aa-a551edecc7b5@kernel.dk>
Message-ID: <e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk>
Date:   Mon, 17 Aug 2020 21:30:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <97c2c3ab-d25b-e6bb-e8aa-a551edecc7b5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/20 9:12 PM, Jens Axboe wrote:
> On 8/17/20 8:29 PM, Jens Axboe wrote:
>> On 8/17/20 2:25 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>>> Since we've had a few cases of applications not dealing with this
>>>> appopriately, I believe the safest course of action is to ensure that
>>>> we don't return short reads when we really don't have to.
>>>>
>>>> The first patch is just a prep patch that retains iov_iter state over
>>>> retries, while the second one actually enables just doing retries if
>>>> we get a short read back.
>>>>
>>>> This passes all my testing, both liburing regression tests but also
>>>> tests that explicitly trigger internal short reads and hence retry
>>>> based on current state. No short reads are passed back to the
>>>> application.
>>>
>>> Thanks! I was going to ask about exactly that :-)
>>>
>>> It wasn't clear why returning short reads were justified by resulting
>>> in better performance... As it means the application needs to do
>>> a lot more work and syscalls.
>>
>> It mostly boils down to figuring out a good way to do it. With the
>> task_work based retry, the async buffered reads, we're almost there and
>> the prep patch adds the last remaining bits to retain the iov_iter state
>> across issues.
>>
>>> Will this be backported?
>>
>> I can, but not really in an efficient manner. It depends on the async
>> buffered work to make progress, and the task_work handling retry. The
>> latter means it's 5.7+, while the former is only in 5.9+...
>>
>> We can make it work for earlier kernels by just using the thread offload
>> for that, and that may be worth doing. That would enable it in
>> 5.7-stable and 5.8-stable. For that, you just need these two patches.
>> Patch 1 would work as-is, while patch 2 would need a small bit of
>> massaging since io_read() doesn't have the retry parts.
>>
>> I'll give it a whirl just out of curiosity, then we can debate it after
>> that.
> 
> Here are the two patches against latest 5.7-stable (the rc branch, as
> we had quite a few queued up after 5.9-rc1). Totally untested, just
> wanted to see if it was doable.
> 
> First patch is mostly just applied, with various bits removed that we
> don't have in 5.7. The second patch just does -EAGAIN punt for the
> short read case, which will queue the remainder with io-wq for
> async execution.
> 
> Obviously needs quite a bit of testing before it can go anywhere else,
> but wanted to throw this out there in case you were interested in
> giving it a go...

Actually passes basic testing, and doesn't return short reads. So at
least it's not half bad, and it should be safe for you to test.

I quickly looked at 5.8 as well, and the good news is that the same
patches will apply there without changes.

-- 
Jens Axboe

