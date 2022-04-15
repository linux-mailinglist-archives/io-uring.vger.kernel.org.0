Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39A150316B
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiDOW4K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 18:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiDOW4J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 18:56:09 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0137A443EC
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 15:53:38 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t12so8088367pll.7
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 15:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3oRSnrVvStlpdMj/J2AK0hx/geB/9Y/IDE2GqIzqH+U=;
        b=lVvj36ABdUUI0AKVJBm5LMeRH57mYVuGs9QN7awv3/B8GgsOUf3/K4ui4LjCBW3XqP
         ASWJ5YqQTJeItYkFVpMqz/7wEz0LJcOZgEH2aJzQeUQE05eOG20b2cP0vEl+QxGKEFCB
         mt3bWsDdrF102tWMEgK0kkrtKgEiOkmZNpoxiFvoKqudUmr87tcxSafD+rjUAURHC9Lb
         tOFk3Fe16dzC4XS9vfehL6DnXdRoTRXPwN25Tjy5ZshdVifJJhgZPQd7JHE2qEIP+vVX
         mMPbcx8DIuKXU3WUFXEk5IKPpJISzXmmH1FnaGZ6aiqcWmKbiNa45Tn2STJCPkuR30Dd
         plIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3oRSnrVvStlpdMj/J2AK0hx/geB/9Y/IDE2GqIzqH+U=;
        b=j5Qb/+j9sk62eiAGPsmmH7KtmwfHXU4AFFndnUn/OdpVFh6L7uIsbHFjkQdYptyS6k
         pU397e2vY4IGv8GIexJvJQuomg0CdTzgrBnodO/4O2+3B/oHamTCYQM7H9lspXNPHEgD
         FHb4gJUBwZMcxXzhGvb2xC/QvHnqVL+si2MSXjMMMPhgPEe3zzcf79TG9jNUUtD4IgJt
         TidQ2ztWsXQL6H4aDGnBaobDJSTNdFK4q5MHnVO89CbYpDPyh1RRYfQwvH3rkQO2M80M
         zomERwyGjYZ1ySG/EW/qx3qm8bPC6nEGzpIzOvtH4ZOt0XejYIFFIlVwUMvlGoiU8qCr
         2ISA==
X-Gm-Message-State: AOAM531jrmuByNEKAnt6j6PeBfN8TxmhdFrkoqbneVzb9vbEX/i0LtyY
        q6ybBAqYRtLFRRwTdFduPY1nRvqOiCUXEg==
X-Google-Smtp-Source: ABdhPJzr2U/NH6N4sfspC8ythiFZ3tPr48DitgN3zxXqK80b2IifrqP4rowoo8HUQ6V8znReckniaQ==
X-Received: by 2002:a17:902:7d81:b0:14f:e18b:2b9e with SMTP id a1-20020a1709027d8100b0014fe18b2b9emr1168653plm.160.1650063218317;
        Fri, 15 Apr 2022 15:53:38 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id p11-20020a17090a748b00b001d221a7134fsm50608pjk.15.2022.04.15.15.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 15:53:37 -0700 (PDT)
Message-ID: <ef406bf3-bdad-ca4e-257b-80dc148f4f1f@kernel.dk>
Date:   Fri, 15 Apr 2022 16:53:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
 <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
 <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
 <b837025e-4c18-322b-094c-6f518335c8ca@gmail.com>
 <aea01fb7-fa4f-c61a-2655-92129d727a74@kernel.dk>
 <e1b351c3-f18e-f3ce-f526-970447389a2d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e1b351c3-f18e-f3ce-f526-970447389a2d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/22 4:41 PM, Pavel Begunkov wrote:
> On 4/15/22 23:03, Jens Axboe wrote:
>> On 4/15/22 3:05 PM, Pavel Begunkov wrote:
>>> On 4/12/22 17:46, Jens Axboe wrote:
>>>> On 4/12/22 10:41 AM, Jens Axboe wrote:
>>>>> On 4/12/22 10:24 AM, Pavel Begunkov wrote:
>>>>>> If all completed requests in io_do_iopoll() were marked with
>>>>>> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
>>>>>> io_free_batch_list() leaking memory and resources.
>>>>>>
>>>>>> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
>>>>>> return the value greater than the real one, but iopolling will deal with
>>>>>> it and the userspace will re-iopoll if needed. In anyway, I don't think
>>>>>> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
>>>>>
>>>>> Ah good catch - yes probably not much practical concern, as the lack of
>>>>> ordering for file IO means that CQE_SKIP isn't really useful for that
>>>>> scenario.
>>>>
>>>> One potential snag is with the change we're now doing
>>>> io_cqring_ev_posted_iopoll() even if didn't post an event. Again
>>>> probably not a practical concern, but it is theoretically a violation
>>>> if an eventfd is used.
>>> Looks this didn't get applied. Are you concerned about eventfd?
>>
>> Yep, was hoping to get a reply back, so just deferred it for now.
>>
>>> Is there any good reason why the userspace can't tolerate spurious
>>> eventfd events? Because I don't think we should care this case
>>
>> I always forget the details on that, but we've had cases like this in
>> the past where some applications assume that if they got N eventfd
>> events, then are are also N events in the ring. Which granted is a bit
>> odd, but it does also make some sense. Why would you have more eventfd
>> events posted than events?
> 
> For the same reason why it can get less eventfd events than there are
> CQEs, as for me it's only a communication channel but not a
> replacement for completion events.

That part is inherently racy in that we might get some CQEs while we
respond to the initial eventfd notifications. But I'm totally agreeing
with you, and it doesn't seem like a big deal to me.

> Ok, we don't want to break old applications, but it's a new most
> probably not widely used feature, and we can say that the userspace
> has to handle spurious eventfd.

If I were to guess, I'd say it's probably epoll + eventfd conversions.
But it should just be made explicit. Since events reaped and checked
happen differently anyway, it seems like a bad assumption to make that
eventfd notifications == events available.

-- 
Jens Axboe

