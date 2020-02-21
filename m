Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7E1680BD
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBUOuY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 09:50:24 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51963 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgBUOuY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 09:50:24 -0500
Received: by mail-pj1-f66.google.com with SMTP id fa20so834491pjb.1
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 06:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qTfI57giDxpyLpBItGwn/lvIyRPYDb0KAVKeX4KqBbw=;
        b=olmlZOP/volGnj1AU/1ZJhbUJ2RavhLtjjoV4l5E1Ecc8RZYVAKjEVFxDoBqdUt6js
         HSB2i/LKT07SUBPyEVMlDUvUuWMKB2FsiZd77i8z/XCuF0k60+Q0oN6b7A/HUG9+RfFS
         j4QLHBESITRG5kvohjYK/zdUD8MYKyAdMudPsQc1rMH7Zoeny5PQ3qKhiA1CmHl5WTkD
         4I45lNdc9207UTZ5/ObQr447LaXWkY3Q/v5c9t+wBNKXELCR9nyoysEffH576/HdkVpl
         Q6hds1jSzH0+BQB6SLOq0lH/Q9D9Kkx8L7siPm6HMJrSm9dzNH2fl8jRxxoWwGJTBOf9
         DRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qTfI57giDxpyLpBItGwn/lvIyRPYDb0KAVKeX4KqBbw=;
        b=WJSqaG8jYvyu8XTSebdesTKX5JevCY0Vk7Xxb/2Sp2pdr/E6rr7rD5WNe2dRJp56ZS
         hD0wFygKy5amRU5X2ZSsQnSBofTVZW6aa/0AEXh/trC5HnFEMj/pQ15NGK3bx0yUbUy+
         lzV5LUEuhRvWcAcezPmSGzp6qZmEzPeCa2SlKyyWZzD2FBlfRRub3Ori+JO7yeceS8s5
         drMsOizevM7BqQ0ZJvGRSqP0ANTiS8qQ6XrssIbL7PpvVpZvR/GJ2LXRvpowNnQ81hUs
         gsdY4Tloy7zWOaZnDi1Z/wkWsklr2uFuIMZKfVJfSr2A4iOKrVMvaeOl7sbsDRO6/w4Y
         JIOw==
X-Gm-Message-State: APjAAAViVR4TKiYBUtMpXjU5zRrtNPRfIndoRilAoFHMYXkbwzrmZIgJ
        TqbHMayUAtG7bmdIBJMhtzCNkQ==
X-Google-Smtp-Source: APXvYqz/p06kKZncAh5XpOmN4lc9FO/kJPYPZSIEb7je0hwvPQyQgnrEWoIlb7rf3kh/sEX9C9e42g==
X-Received: by 2002:a17:902:302:: with SMTP id 2mr37599986pld.58.1582296622692;
        Fri, 21 Feb 2020 06:50:22 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:fdca:2b3c:ac97:51da? ([2605:e000:100e:8c61:fdca:2b3c:ac97:51da])
        by smtp.gmail.com with ESMTPSA id k5sm2809621pju.29.2020.02.21.06.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 06:50:22 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
Date:   Fri, 21 Feb 2020 06:50:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 6:51 AM, Pavel Begunkov wrote:
> On 20/02/2020 23:31, Jens Axboe wrote:
>> For poll requests, it's not uncommon to link a read (or write) after
>> the poll to execute immediately after the file is marked as ready.
>> Since the poll completion is called inside the waitqueue wake up handler,
>> we have to punt that linked request to async context. This slows down
>> the processing, and actually means it's faster to not use a link for this
>> use case.
>>
>> We also run into problems if the completion_lock is contended, as we're
>> doing a different lock ordering than the issue side is. Hence we have
>> to do trylock for completion, and if that fails, go async. Poll removal
>> needs to go async as well, for the same reason.
>>
>> eventfd notification needs special case as well, to avoid stack blowing
>> recursion or deadlocks.
>>
>> These are all deficiencies that were inherited from the aio poll
>> implementation, but I think we can do better. When a poll completes,
>> simply queue it up in the task poll list. When the task completes the
>> list, we can run dependent links inline as well. This means we never
>> have to go async, and we can remove a bunch of code associated with
>> that, and optimizations to try and make that run faster. The diffstat
>> speaks for itself.
> 
> So, it piggybacks request execution onto a random task, that happens
> to complete a poll. Did I get it right?
> 
> I can't find where it setting right mm, creds, etc., or why it have
> them already.

Not a random task, the very task that initially tried to do the receive
(or whatever the operation may be). Hence there's no need to set
mm/creds/whatever, we're still running in the context of the original
task once we retry the operation after the poll signals readiness.

-- 
Jens Axboe

