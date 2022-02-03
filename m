Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5704A913B
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbiBCXhX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiBCXhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:37:22 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1375C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 15:37:22 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v13so8012603wrv.10
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 15:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cMLtxoaKOMblqcoSXrvnXLJcL2/9t7S9kcEj9MMGPJY=;
        b=FYr5rXb9w8sXNRUvhTwRwCnK5L0UdP1E5QGqXF7uiMrty2lCwUv56Dbw9vokV6mV3n
         P81HRfth66vdb6VBQ+ZkcqGkF5DPIRjcJKTVBwli4m0kM8g7k7LKuhcXKCwQ6fkGEA+H
         Vhn5OfUeWVEb/qSZAm4O+OVPdPZ0ca4HBdxaMVtz1LIxEnEki8349JKgE8M2o1sdD42j
         /NzivFp4zc/xCHqaTnNxOR0htps6ZjWdGyxfbC1xhmCLrsYqHxCRY1YIWDUzlt6hI2rX
         QcUkhV+kc9s3Zo7QgCXqtG6zF4W9LGOpQE3YC2SsrP2X10di0cj041gILiQcXCvDG6rN
         SsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cMLtxoaKOMblqcoSXrvnXLJcL2/9t7S9kcEj9MMGPJY=;
        b=ophus7Mpv//9QbWWWpVylAsTyvr2FYzHuMtnr/huwb1hofqvkgD30GLsaiwyZtfwUZ
         Yz4YzVX5tnvThAzctM1K+JTzZFH66bRsO/4AUa7TkpZisqKo5BjqHg4Di4lIApOSQ3Eh
         fcbrqNwyeBSAb3UAjSmuDKX9DbJIxGWlzv21L6waiYeWvwdQL+ZOm10RTMujPrzW9L67
         JdrJOhBhh54DUAhFtB3fSvrS8abP7mzpzzFgO5zsj/s2WLej9mEpRQHU7UZbSo5UVYR8
         +O1Xe6BxQyUFHEFPpEc0nkchQhqrUOp79i7M4/lAbJcaPBJL9H5glCS98O+dNCfIEFRE
         bNgw==
X-Gm-Message-State: AOAM530KPpLDYPgeNF43CAOW/Z9BInAlqbWCnBvNyW1Tt1gkqX7dNQCi
        L3UkZDS2bhZkq5mX6weA4jzGJXHLrx/v6A==
X-Google-Smtp-Source: ABdhPJxVk3Nhi9nL/gEjf+dAOllJ3A3p26KeLw5qBu0DPUqdwZlzbHJpys3HMcADgbz1bhDOTd7aIA==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr230271wrr.220.1643931441200;
        Thu, 03 Feb 2022 15:37:21 -0800 (PST)
Received: from ?IPv6:2a02:6b6d:f804:0:28c2:5854:c832:e580? ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id g4sm202184wrd.111.2022.02.03.15.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 15:37:20 -0800 (PST)
Subject: Re: [External] Re: [PATCH v4 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203182441.692354-1-usama.arif@bytedance.com>
 <20220203182441.692354-3-usama.arif@bytedance.com>
 <8369e0be-f922-ba6b-ceed-24886ebcdb78@kernel.dk>
 <d390f325-0f5b-a321-841d-36ac873358f9@bytedance.com>
 <11e423ca-4272-86cf-8d51-2620094cfe29@kernel.dk>
From:   Usama Arif <usama.arif@bytedance.com>
Message-ID: <7e1a1452-c7be-fa98-f1b1-e19088088424@bytedance.com>
Date:   Thu, 3 Feb 2022 23:37:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <11e423ca-4272-86cf-8d51-2620094cfe29@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 03/02/2022 19:12, Jens Axboe wrote:
> On 2/3/22 12:05 PM, Usama Arif wrote:
>>
>>
>> On 03/02/2022 18:49, Jens Axboe wrote:
>>> On 2/3/22 11:24 AM, Usama Arif wrote:
>>>> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>>>> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
>>>>    {
>>>> -	if (likely(!ctx->cq_ev_fd))
>>>> -		return false;
>>>> +	struct io_ev_fd *ev_fd;
>>>> +
>>>> +	rcu_read_lock();
>>>> +	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
>>>> +	ev_fd = rcu_dereference(ctx->io_ev_fd);
>>>> +
>>>> +	if (likely(!ev_fd))
>>>> +		goto out;
>>>>    	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>>>> -		return false;
>>>> -	return !ctx->eventfd_async || io_wq_current_is_worker();
>>>> +		goto out;
>>>> +
>>>> +	if (!ctx->eventfd_async || io_wq_current_is_worker())
>>>> +		eventfd_signal(ev_fd->cq_ev_fd, 1);
>>>> +
>>>> +out:
>>>> +	rcu_read_unlock();
>>>>    }
>>>
>>> This still needs what we discussed in v3, something ala:
>>>
>>> /*
>>>    * This will potential race with eventfd registration, but that's
>>>    * always going to be the case if there is IO inflight while an eventfd
>>>    * descriptor is being registered.
>>>    */
>>> if (!rcu_dereference_raw(ctx->io_ev_fd))
>>> 	return;
>>>
>>> rcu_read_lock();
>>
>> Hmm, so i am not so worried about the registeration, but actually
>> worried about unregisteration.
>> If after the check and before the rcu_read_lock, the eventfd is
>> unregistered won't we get a NULL pointer exception at
>> eventfd_signal(ev_fd->cq_ev_fd, 1)?
> 
> You need to check it twice, that's a hard requirement. The first racy
> check is safe because we don't care if we miss a notification, once
> inside rcu_read_lock() it needs to be done properly of course. Like you
> do below, that's how it should be done.
> 
>>> I wonder if we can get away with assigning ctx->io_ev_fd to NULL when we
>>> do the call_rcu(). The struct itself will remain valid as long as we're
>>> under rcu_read_lock() protection, so I think we'd be fine? If we do
>>> that, then we don't need any rcu_barrier() or synchronize_rcu() calls,
>>> as we can register a new one while the previous one is still being
>>> killed.
>>>
>>> Hmm?
>>>
>>
>> We would have to remove the check that ctx->io_ev_fd != NULL. That we
>> would also result in 2 successive calls to io_eventfd_register without
>> any unregister in between being successful? Which i dont think is the
>> right behaviour?
>>
>> I think the likelihood of hitting the rcu_barrier itself is quite low,
>> so probably the cost is low as well.
> 
> Yeah it might very well be. To make what I suggested work, we'd need a
> way to mark the io_ev_fd as going away. Which would be feasible, as we
> know the memory will remain valid for us to check. So it could
> definitely work, you'd just need a check for that.
> 
>> Thanks, will do that this in the next patchset with the above
>> io_eventfd_signal changes if those look ok as well?
> 
> The code you pasted looked good. Consider the "is unregistration in
> progress" suggestion as well, as it would be nice to avoid any kind of
> rcu synchronization if at all possible.
> 


Thanks for the review comments! I think all of them should have been 
addressed now in v5. I also removed ring quiesce from io_uring_register 
as the remaining 2 opcodes don't need them (Thanks Pavel for confirming 
that!)

Regards,
Usama
