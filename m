Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249AC3F3643
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhHTWK1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbhHTWKZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:10:25 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DF9C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:09:47 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id s16so10908564ilo.9
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3sqjf9VxLjK+MDaP0BXLm9lMJdVOX/YWtEut6X9GlT8=;
        b=c7GZ8O23erIiQgtV/h5773HKLiChI/JBQeRaJPQhXpQ/xr78Kk7erclCb2KehivRsm
         y4dVgbFYjItkKEgjSEebSRQAYrC4HSUQmjheEVV49jpp0rco1aqXOlFP4ODSYFtOyIIw
         4J8hsDjxq80Dsst/Ad8Lb1OfCb4dd5JHv/bx1AZGEx70pastPv261f6IL9w2R0Zh7Wl8
         ZG3lLrQmtDDQlgAyanORZ/x9h9HXOX2+9Lx3lUJlDMIBdATjSJ7kdLzWz86h5388Vkhy
         XuqmOAIK2poU4D2qcxUUu/3O6GeYmlz7qb5w7yUa489Jn27X/MRGBrkjOataoHTh1TbH
         oi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3sqjf9VxLjK+MDaP0BXLm9lMJdVOX/YWtEut6X9GlT8=;
        b=WYYbFmjVU6d2rXHR+KdNVUaByqTaEMx1EdMWxCrVQ4IOThR3MDQpEk5CqAtdOwVAEp
         qMWsQMpHCdRCPTZ5wrQkFAhsrXR7lfFcpyx/sqc/LVj+gYuf9XRrJUcBclh5mtKms/dh
         TNI+FO6VHIlWVZoNFvbiWQjJuRDKG3dGvKt/q94BSHQ7KMsX3MT3JU08SUP8HQvgxJ8H
         VaI9kWzNQf1MQ1Ax07IGCH3HVcsC+Sy8K5MBq1X7L+3vuf4PxxvoSGCYnc8BlUCN3p4e
         UeSVdNFMzrZvcFNv7ZvWvXBPx74BSpQdtJ+7CyaPScN8P0r+IK+6nRuo9nJWQwK52+ZO
         h3Zw==
X-Gm-Message-State: AOAM530rwHFk4DeXDNUyo3BR9/dMY6oWAvmAeB5rS8X89aY9LffDtf9s
        dB2YgxfWYjq3Q7VFOiae5g1YF9QhBK6tWnKy
X-Google-Smtp-Source: ABdhPJyygP7t01JKfYBbC4yQb9sfnu8l8bix04DnE0BFSN8HlO+d6jTVnDnM4vv4+LHwsJ4SKo4/pg==
X-Received: by 2002:a05:6e02:f91:: with SMTP id v17mr10112122ilo.0.1629497386803;
        Fri, 20 Aug 2021 15:09:46 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s6sm3960905iow.1.2021.08.20.15.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:09:46 -0700 (PDT)
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
Date:   Fri, 20 Aug 2021 16:09:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 3:32 PM, Pavel Begunkov wrote:
> On 8/20/21 9:39 PM, Hao Xu wrote:
>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>> may cause problems when accessing it parallelly.
>>>
>>> Did you hit any problem? It sounds like it should be fine as is:
>>>
>>> The trick is that it's only responsible to flush requests added
>>> during execution of current call to tctx_task_work(), and those
>>> naturally synchronised with the current task. All other potentially
>>> enqueued requests will be of someone else's responsibility.
>>>
>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>> 0 there, but actually enqueued a request, it means someone
>>> actually flushed it after the request had been added.
>>>
>>> Probably, needs a more formal explanation with happens-before
>>> and so.
>> I should put more detail in the commit message, the thing is:
>> say coml_nr > 0
>>
>>   ctx_flush_and put                  other context
>>    if (compl_nr)                      get mutex
>>                                       coml_nr > 0
>>                                       do flush
>>                                           coml_nr = 0
>>                                       release mutex
>>         get mutex
>>            do flush (*)
>>         release mutex
>>
>> in (*) place, we do a bunch of unnecessary works, moreover, we
> 
> I wouldn't care about overhead, that shouldn't be much
> 
>> call io_cqring_ev_posted() which I think we shouldn't.
> 
> IMHO, users should expect spurious io_cqring_ev_posted(),
> though there were some eventfd users complaining before, so
> for them we can do

It does sometimes cause issues, see:

commit b18032bb0a883cd7edd22a7fe6c57e1059b81ed0
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Jan 24 16:58:56 2021 -0700

    io_uring: only call io_cqring_ev_posted() if events were posted

I would tend to agree with Hao here, and the usual optimization idiom
looks like:

if (struct->nr) {
	mutex_lock(&struct->lock);
	if (struct->nr)
		do_something();
	mutex_unlock(&struct->lock);
}

like you posted, which would be fine and avoid this whole discussion :-)

Hao, care to spin a patch that does that?

-- 
Jens Axboe

