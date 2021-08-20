Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB793F3673
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhHTWbM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhHTWbL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:31:11 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8701CC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:30:33 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id j15so10990298ila.1
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gOaZyDFVIT12Yw4Y7QOv2itnmEmI5B+3V3kDWmYbtmk=;
        b=B6xEvSmGqyrsUJJ8iknSR3vzs8tVSsF4wptxpAAR9pPPGXwZxm28u9towTiyxfyraI
         ofVJkSPkZNwilWWWzefSEQvW5k1mwg6bCcjydw+fXE2Fy6awInqmXfiE0yeWlPNXmodg
         DjDVp4/OfKpODRPnx7RuSZiebmrAf7sNkG8GWiBHllmmBQgFLvNJEYc00O+7qnm4zKbq
         ONYnTuP21pEL+OzRZbVe/eN//0LLC2zBvEwbFLspf8EmMPuvSs03LiwgQO/4V1QN1XLM
         Y4U0soZzTzKOP6UjZJnPj5xzcPb6q6NPzB0QKq8cA1HUtqI7eR+GfalAiu66pER0s+fP
         Q/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gOaZyDFVIT12Yw4Y7QOv2itnmEmI5B+3V3kDWmYbtmk=;
        b=hw2DTsynqEFJkngRRFvV0/exACfRHQERxTfy/eaYxg63y4A1pNuOwT9LVrzAT5MG8u
         lZYOf9qELwtzj8bWTy/aL4Doput6F2XWx8hUixzJvUvXKirBorH3p5FZr67sg/ebL+Sv
         +JHAGQzVOXFAXj4xMtXukmUDWEPXCcwTWIGaIT455Gc/g8+vg8z64A6lahjd4k7ne0G8
         6kxOHUR3+vFLYibdJpm7pOSPz3B+udzmCT1CpAWT51LvX5L1hRoR4W+DjZK7fhJBSFDU
         AnJZFgWnynZmhx0zrcrZ/kWAXwElBmxAECln4DQ5OtBe3pPnxYGkZ/X94H/oi8LhDGhQ
         kEEQ==
X-Gm-Message-State: AOAM532VhAOgWG2NggNzzJPATQh39+GmLPdw05tWGeD9XSqy/bRopSOh
        y8g4E9Yh4lp4A7VF/pLrO0jDpw==
X-Google-Smtp-Source: ABdhPJzJ/IsZxJ/ZYWWsVIc0N7wg8Kqzmj2cXbETvu6bLluZCWC5lH81akWtkNsE8BUNhbNVF3xGBg==
X-Received: by 2002:a05:6e02:1b05:: with SMTP id i5mr920342ilv.5.1629498632896;
        Fri, 20 Aug 2021 15:30:32 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z15sm3987977ioh.28.2021.08.20.15.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:30:32 -0700 (PDT)
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
 <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
 <8ab470e7-83f1-a0ef-f43b-29af8f84d229@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3cae21c2-5db7-add1-1587-c87e22e726dc@kernel.dk>
Date:   Fri, 20 Aug 2021 16:30:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8ab470e7-83f1-a0ef-f43b-29af8f84d229@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 4:28 PM, Pavel Begunkov wrote:
> On 8/20/21 11:09 PM, Jens Axboe wrote:
>> On 8/20/21 3:32 PM, Pavel Begunkov wrote:
>>> On 8/20/21 9:39 PM, Hao Xu wrote:
>>>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>>>> may cause problems when accessing it parallelly.
>>>>>
>>>>> Did you hit any problem? It sounds like it should be fine as is:
>>>>>
>>>>> The trick is that it's only responsible to flush requests added
>>>>> during execution of current call to tctx_task_work(), and those
>>>>> naturally synchronised with the current task. All other potentially
>>>>> enqueued requests will be of someone else's responsibility.
>>>>>
>>>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>>>> 0 there, but actually enqueued a request, it means someone
>>>>> actually flushed it after the request had been added.
>>>>>
>>>>> Probably, needs a more formal explanation with happens-before
>>>>> and so.
>>>> I should put more detail in the commit message, the thing is:
>>>> say coml_nr > 0
>>>>
>>>>   ctx_flush_and put                  other context
>>>>    if (compl_nr)                      get mutex
>>>>                                       coml_nr > 0
>>>>                                       do flush
>>>>                                           coml_nr = 0
>>>>                                       release mutex
>>>>         get mutex
>>>>            do flush (*)
>>>>         release mutex
>>>>
>>>> in (*) place, we do a bunch of unnecessary works, moreover, we
>>>
>>> I wouldn't care about overhead, that shouldn't be much
>>>
>>>> call io_cqring_ev_posted() which I think we shouldn't.
>>>
>>> IMHO, users should expect spurious io_cqring_ev_posted(),
>>> though there were some eventfd users complaining before, so
>>> for them we can do
>>
>> It does sometimes cause issues, see:
> 
> I'm used that locking may end up in spurious wakeups. May be
> different for eventfd, but considering that we do batch
> completions and so might be calling it only once per multiple
> CQEs, it shouldn't be.

The wakeups are fine, it's the ev increment that's causing some issues.

>> commit b18032bb0a883cd7edd22a7fe6c57e1059b81ed0
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Sun Jan 24 16:58:56 2021 -0700
>>
>>     io_uring: only call io_cqring_ev_posted() if events were posted
>>
>> I would tend to agree with Hao here, and the usual optimization idiom
>> looks like:
>>
>> if (struct->nr) {
>> 	mutex_lock(&struct->lock);
>> 	if (struct->nr)
>> 		do_something();
>> 	mutex_unlock(&struct->lock);
>> }
>>
>> like you posted, which would be fine and avoid this whole discussion :-)
> 
> Well, until the Hao's message explaining the concerns, I was thinking
> it's about potential hangs because of not flushing requests. I'd rather
> say the discussion was fruitful and naturally came to the conclusion.

Oh for sure, didn't mean to imply it was useless. At least it's in the
archives :)

-- 
Jens Axboe

