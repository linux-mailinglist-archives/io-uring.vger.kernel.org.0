Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047D64A8C43
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 20:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353705AbiBCTMP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 14:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240035AbiBCTMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 14:12:14 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0A6C061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 11:12:14 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id w5so2969199ilo.2
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 11:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KHa5Z8+68bn7uZrutpzvRnuaK8kqTA9LB4xk56iIo78=;
        b=yQzTR2zzEeoMC6bmKrWEE8wKGlKLH7RL8pwP7TAhzFIfyTXzVPCNsx/62P+2Obl36E
         TAKMe1TN46PpkB2UPgNikVo4XJp7V+hMV2dEGmw0j+Nt1SOHoD8FLIFaw1lnyZp6eq5j
         GgX/xI2Me8WuBaLnAD+Dd+tF2hjgZ0qIHMNn79IuxiqLvmbC1HNl25yLfB7UYA6OWEpU
         m+/dv+ihxHm/nObleL5XZPVVX0yp8h24SKpSBtB7V2HM4x7NZcLYFyaCzMGRa1gfZYDb
         ++biIfyGzV5tBQFeGmAtEAF/sCGryzl4VnLNYYXSJBxImc5CJTtcNZ79Pj+vigWzjZN1
         zXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KHa5Z8+68bn7uZrutpzvRnuaK8kqTA9LB4xk56iIo78=;
        b=vLmHcgs1LPJdsw8dYMU5Jv4owahNRXE9WKmfWtoLkLbM05WHAnYsSGZgCQMBmscaEx
         NDpOqCn0zADuvkDGuv/Sztuty5W+4t9hCnzwJ4LAVWVYdZ5UL8VPMh90A82tSEVrWIDd
         zE9HKmevz5a+yGRdgx4CMM4/wt1G8wzUNhvh8lyZfcyCcK3HgPiJCNXrmXfixZ7MO4pg
         YROOrsVnfOhAjB5koKoqL3lGZk525MBadEWksOdOk84gsy+0EZEIL7IHJuJoc1KlXItY
         rLlf9+mpHPXb8kbnOj6xrehDePM0f14emov2HH1uNRUlptQdASrGp7FjbAJoE1HDN93P
         LusQ==
X-Gm-Message-State: AOAM531CqPJ/C3rYrHJcBCtvmm4GxfGcHx0Iu1e5vdssnGsFsSUkpZ3/
        TbqmUSL+gHUu9Nah9g7QqK6T4g==
X-Google-Smtp-Source: ABdhPJzMD+DNONLaLZPjq9r8IOLB6GrCNlR/V3V/Emu7U7QW4F4CR1iw7alDrKXsJmlfHLFvDaZVOg==
X-Received: by 2002:a05:6e02:1908:: with SMTP id w8mr20292289ilu.56.1643915533759;
        Thu, 03 Feb 2022 11:12:13 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e17sm22248182ilm.67.2022.02.03.11.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 11:12:13 -0800 (PST)
Subject: Re: [External] Re: [PATCH v4 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203182441.692354-1-usama.arif@bytedance.com>
 <20220203182441.692354-3-usama.arif@bytedance.com>
 <8369e0be-f922-ba6b-ceed-24886ebcdb78@kernel.dk>
 <d390f325-0f5b-a321-841d-36ac873358f9@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <11e423ca-4272-86cf-8d51-2620094cfe29@kernel.dk>
Date:   Thu, 3 Feb 2022 12:12:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d390f325-0f5b-a321-841d-36ac873358f9@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 12:05 PM, Usama Arif wrote:
> 
> 
> On 03/02/2022 18:49, Jens Axboe wrote:
>> On 2/3/22 11:24 AM, Usama Arif wrote:
>>> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>>> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
>>>   {
>>> -	if (likely(!ctx->cq_ev_fd))
>>> -		return false;
>>> +	struct io_ev_fd *ev_fd;
>>> +
>>> +	rcu_read_lock();
>>> +	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
>>> +	ev_fd = rcu_dereference(ctx->io_ev_fd);
>>> +
>>> +	if (likely(!ev_fd))
>>> +		goto out;
>>>   	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>>> -		return false;
>>> -	return !ctx->eventfd_async || io_wq_current_is_worker();
>>> +		goto out;
>>> +
>>> +	if (!ctx->eventfd_async || io_wq_current_is_worker())
>>> +		eventfd_signal(ev_fd->cq_ev_fd, 1);
>>> +
>>> +out:
>>> +	rcu_read_unlock();
>>>   }
>>
>> This still needs what we discussed in v3, something ala:
>>
>> /*
>>   * This will potential race with eventfd registration, but that's
>>   * always going to be the case if there is IO inflight while an eventfd
>>   * descriptor is being registered.
>>   */
>> if (!rcu_dereference_raw(ctx->io_ev_fd))
>> 	return;
>>
>> rcu_read_lock();
> 
> Hmm, so i am not so worried about the registeration, but actually 
> worried about unregisteration.
> If after the check and before the rcu_read_lock, the eventfd is 
> unregistered won't we get a NULL pointer exception at 
> eventfd_signal(ev_fd->cq_ev_fd, 1)?

You need to check it twice, that's a hard requirement. The first racy
check is safe because we don't care if we miss a notification, once
inside rcu_read_lock() it needs to be done properly of course. Like you
do below, that's how it should be done.

>> I wonder if we can get away with assigning ctx->io_ev_fd to NULL when we
>> do the call_rcu(). The struct itself will remain valid as long as we're
>> under rcu_read_lock() protection, so I think we'd be fine? If we do
>> that, then we don't need any rcu_barrier() or synchronize_rcu() calls,
>> as we can register a new one while the previous one is still being
>> killed.
>>
>> Hmm?
>>
> 
> We would have to remove the check that ctx->io_ev_fd != NULL. That we 
> would also result in 2 successive calls to io_eventfd_register without 
> any unregister in between being successful? Which i dont think is the 
> right behaviour?
> 
> I think the likelihood of hitting the rcu_barrier itself is quite low, 
> so probably the cost is low as well.

Yeah it might very well be. To make what I suggested work, we'd need a
way to mark the io_ev_fd as going away. Which would be feasible, as we
know the memory will remain valid for us to check. So it could
definitely work, you'd just need a check for that.

> Thanks, will do that this in the next patchset with the above 
> io_eventfd_signal changes if those look ok as well?

The code you pasted looked good. Consider the "is unregistration in
progress" suggestion as well, as it would be nice to avoid any kind of
rcu synchronization if at all possible.

-- 
Jens Axboe

