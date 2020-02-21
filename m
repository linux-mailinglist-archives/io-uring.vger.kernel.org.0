Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5861816873D
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 20:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBUTKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 14:10:19 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33414 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgBUTKT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 14:10:19 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay11so1263413plb.0
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 11:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ISkjbma8ZREgcg3QidTJaSGP73GftzBtSYucivIAsM=;
        b=wcgBXegMQETTnmzk8XpwxGQn1AL4Fy8eP6pNtcv0/7EtsfyhpsGljc708KyIp5ZOO5
         ZUy7r9CLhi1mu2BjpV1bmYwtpiZwHpW2D9cOxrirQQN9fGBGYZGwmtV7xT26rSKSPZg3
         enU9ususIxeYn/ucKVzkcEYluh0H+bwjHXjpdsSpd2ZU0uLzU954mYUbSDx4fKxTeE3C
         zz7yd8VaKyKJkkiBuCUdV6SjsQCqFfKtVBo0pOlRupyw7HYFjqMDNuFI9E+8QKKOM06Z
         ist1xTTbglI+2NN6wHmkZLV3S3j4v15qH92FO2Y1GgiYUEEI4PYpIlgVyrSs7bx0g13S
         dQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ISkjbma8ZREgcg3QidTJaSGP73GftzBtSYucivIAsM=;
        b=lDv20JuioKVA6hbgy+8zaBZ7xsUaoQnSQrHMzawg/j8zoMkXkZ/WXHhibAje89An8l
         ZCO6SowyIoNOx7h3I/T9/Cmt65kBCirzvuB6IeVkbG750OAsU2IaftKh/CSwJZ8gERkN
         M0M2wFklb4E29sh42kXw2yuN0WUPbrFZK3sCrH5b/I48PEwtqwxr4pbRj4nI5Eidl14V
         ZD6rPKPGy16fMFV0eLFus05RJ4Y+Rxr9L/9ylbQcqu0jsLYdTS6yQENelHSdzsxZyblq
         8zfQQlwxILhQP7bIzG4qOCL7gZePRtw6KG7SHqABqI/F0zXuvZgnJPM9zZW4cbFFdEIN
         i39A==
X-Gm-Message-State: APjAAAX2HTYCaHW68YbaW/AdSNK6AezoiLolxLS5AzmilYrdAZagSBcs
        65aNZz8avHomCiQLCwI1kKs6Aw==
X-Google-Smtp-Source: APXvYqxZg0iX87Jw3tN4LwMacT4LkQepLXuysun5GJzpcdbsuEm6acUJnJpeeNf28WPsIXXgqs9fiA==
X-Received: by 2002:a17:90a:804a:: with SMTP id e10mr4810076pjw.41.1582312218640;
        Fri, 21 Feb 2020 11:10:18 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:91ff:e31e:f68d:32a9? ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id i27sm3177541pgn.76.2020.02.21.11.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 11:10:18 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
Date:   Fri, 21 Feb 2020 11:10:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 11:30 AM, Pavel Begunkov wrote:
> On 21/02/2020 17:50, Jens Axboe wrote:
>> On 2/21/20 6:51 AM, Pavel Begunkov wrote:
>>> On 20/02/2020 23:31, Jens Axboe wrote:
>>>> For poll requests, it's not uncommon to link a read (or write) after
>>>> the poll to execute immediately after the file is marked as ready.
>>>> Since the poll completion is called inside the waitqueue wake up handler,
>>>> we have to punt that linked request to async context. This slows down
>>>> the processing, and actually means it's faster to not use a link for this
>>>> use case.
>>>>
>>>> We also run into problems if the completion_lock is contended, as we're
>>>> doing a different lock ordering than the issue side is. Hence we have
>>>> to do trylock for completion, and if that fails, go async. Poll removal
>>>> needs to go async as well, for the same reason.
>>>>
>>>> eventfd notification needs special case as well, to avoid stack blowing
>>>> recursion or deadlocks.
>>>>
>>>> These are all deficiencies that were inherited from the aio poll
>>>> implementation, but I think we can do better. When a poll completes,
>>>> simply queue it up in the task poll list. When the task completes the
>>>> list, we can run dependent links inline as well. This means we never
>>>> have to go async, and we can remove a bunch of code associated with
>>>> that, and optimizations to try and make that run faster. The diffstat
>>>> speaks for itself.
>>>
>>> So, it piggybacks request execution onto a random task, that happens
>>> to complete a poll. Did I get it right?
>>>
>>> I can't find where it setting right mm, creds, etc., or why it have
>>> them already.
>>
>> Not a random task, the very task that initially tried to do the receive
>> (or whatever the operation may be). Hence there's no need to set
>> mm/creds/whatever, we're still running in the context of the original
>> task once we retry the operation after the poll signals readiness.
> 
> Got it. Then, it may happen in the future after returning from
> __io_arm_poll_handler() and io_uring_enter(). And by that time io_submit_sqes()
> should have already restored creds (i.e. personality stuff) on the way back.
> This might be a problem.

Not sure I follow, can you elaborate? Just to be sure, the requests that
go through the poll handler will go through __io_queue_sqe() again. Oh I
guess your point is that that is one level below where we normally
assign the creds.

> BTW, Is it by design, that all requests of a link use personality creds
> specified in the head's sqe?

No, I think that's more by accident. We should make sure they use the
specified creds, regardless of the issue time. Care to clean that up?
Would probably help get it right for the poll case, too.

-- 
Jens Axboe

