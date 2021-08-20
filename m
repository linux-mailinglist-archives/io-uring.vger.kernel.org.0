Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653953F366D
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 00:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhHTW3Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 18:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234739AbhHTW3X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 18:29:23 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A89C061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:28:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id f13-20020a1c6a0d000000b002e6fd0b0b3fso8345657wmc.3
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 15:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pXmNzrYwn1jiSM9xB7La2NP2CSMGK4RCMF2O7x1Ffw4=;
        b=ugNHI9ofev4SebyHBTsGC2XYbn39O3U5dQdd/7btnU7QQo+C8iAkjeoEzWOAmkmXo9
         gbjZsvarS40zvx31eV1rq4R5MZXCvoBXgOdA2s1iaTHBUX9yu415Y0WjR4txUmM5zw5V
         tgX+RoZZnhK6UtCjo/LubNqmd7jR1JY/w/v/tL0QVrZysOLJrAV9gfyFzoNPfmoyr5G7
         cSxu+f6pTUQfXkSnFJe8tAbJ3mb3s7foy9JqZ5mL0wcepHvRNOJT8reizsaCuEp+plCi
         7b8/B/YaNlejOlxyaCw3m5LSvX72YaDNVosW1Ig0aH/AsQ5Q4i19F+waa8LbIca1Ayfl
         7YjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pXmNzrYwn1jiSM9xB7La2NP2CSMGK4RCMF2O7x1Ffw4=;
        b=ueFWKeIGgfgACvBBwJjwNqgN/u+QNiIQJIgWm/iweAuqxA6aiYaswl2RXKXv3vy2Yz
         1ISmPO4FStAAhLtD/VB5zG0J6wAH8YoDXUTAVTbwPaAowT/Z4E3Rhg59U/jM89HkrwZ2
         sgN6vxzJhYAM+v/Na6/WeEGTX7QEj7NaC8eFW8qR/jqMCCHVb+ttJxgFK+Ealqc3de3x
         256xrIbvwIhpsHQITzgPqivZMhc2tUsqESYKhJu7/jUNkdl2V7aGebPIFpR3bm76AXRZ
         ig3cE2ec6sUJZMsjrWEJdneMJvv471K48dhIJz+axhMBo7oEo0rCPHU+dSGPovlTPf4j
         META==
X-Gm-Message-State: AOAM532GFsEjf5cnbB9NnXGjXw/+XVx7UM2yKUzKXjzm9qqmzzCn9DmI
        /Nm0viXo8iBsUHsZ/t73Eg0cQnH6D5E=
X-Google-Smtp-Source: ABdhPJw0Hq10+HvI9mQO5T/K0hz7Vgg+QTz4XoPdn3DJ8D8EIGZB6ZqNViH3MgriXc97hUG1uez/Mw==
X-Received: by 2002:a1c:2042:: with SMTP id g63mr5660405wmg.27.1629498523439;
        Fri, 20 Aug 2021 15:28:43 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id w18sm7709335wrg.68.2021.08.20.15.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:28:42 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
 <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
Message-ID: <8ab470e7-83f1-a0ef-f43b-29af8f84d229@gmail.com>
Date:   Fri, 20 Aug 2021 23:28:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 11:09 PM, Jens Axboe wrote:
> On 8/20/21 3:32 PM, Pavel Begunkov wrote:
>> On 8/20/21 9:39 PM, Hao Xu wrote:
>>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>>> may cause problems when accessing it parallelly.
>>>>
>>>> Did you hit any problem? It sounds like it should be fine as is:
>>>>
>>>> The trick is that it's only responsible to flush requests added
>>>> during execution of current call to tctx_task_work(), and those
>>>> naturally synchronised with the current task. All other potentially
>>>> enqueued requests will be of someone else's responsibility.
>>>>
>>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>>> 0 there, but actually enqueued a request, it means someone
>>>> actually flushed it after the request had been added.
>>>>
>>>> Probably, needs a more formal explanation with happens-before
>>>> and so.
>>> I should put more detail in the commit message, the thing is:
>>> say coml_nr > 0
>>>
>>>   ctx_flush_and put                  other context
>>>    if (compl_nr)                      get mutex
>>>                                       coml_nr > 0
>>>                                       do flush
>>>                                           coml_nr = 0
>>>                                       release mutex
>>>         get mutex
>>>            do flush (*)
>>>         release mutex
>>>
>>> in (*) place, we do a bunch of unnecessary works, moreover, we
>>
>> I wouldn't care about overhead, that shouldn't be much
>>
>>> call io_cqring_ev_posted() which I think we shouldn't.
>>
>> IMHO, users should expect spurious io_cqring_ev_posted(),
>> though there were some eventfd users complaining before, so
>> for them we can do
> 
> It does sometimes cause issues, see:

I'm used that locking may end up in spurious wakeups. May be
different for eventfd, but considering that we do batch
completions and so might be calling it only once per multiple
CQEs, it shouldn't be.


> commit b18032bb0a883cd7edd22a7fe6c57e1059b81ed0
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sun Jan 24 16:58:56 2021 -0700
> 
>     io_uring: only call io_cqring_ev_posted() if events were posted
> 
> I would tend to agree with Hao here, and the usual optimization idiom
> looks like:
> 
> if (struct->nr) {
> 	mutex_lock(&struct->lock);
> 	if (struct->nr)
> 		do_something();
> 	mutex_unlock(&struct->lock);
> }
> 
> like you posted, which would be fine and avoid this whole discussion :-)

Well, until the Hao's message explaining the concerns, I was thinking
it's about potential hangs because of not flushing requests. I'd rather
say the discussion was fruitful and naturally came to the conclusion.

-- 
Pavel Begunkov
