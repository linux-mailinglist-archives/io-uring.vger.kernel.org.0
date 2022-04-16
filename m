Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FCE5036BE
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 15:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiDPN0e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Apr 2022 09:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiDPN0d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Apr 2022 09:26:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BB74EDC9
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 06:24:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso10333066pjf.5
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 06:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=RSj6XyuDvhoxAHNbA3Cet4oTEX4htKCvEYjT5yPqk6I=;
        b=PWgjRYTu6AsVQRV626LP7QMU7TR0PWcUFoK6544w1+VozsiCQNYLoVXbL4cBjF+J0e
         5EcXoR09tKowz18EAOUl5ecNqwkMB9rWPYUyLWio2zt8nAZj6132Xr0AeqUsbqaQZPMM
         lL91pBHFdnek0ZNJIdBZmnrXOmAgKaEsZivrKNje554SzqUn4tZwpRjywH7zMyAD4gPv
         En7UsJtsX6Y/JOTUGE0nfCLFgc4D/7InYuSQpHB/clLKbHumt+c1/yQCqNNg6zzCPqvG
         olb2dqEZ3YBNJgjejBWliqcuaeIm70m29C1ZGC1LoLRbOP7D7nIczzLOAh6DJ1nAG4y8
         Z7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RSj6XyuDvhoxAHNbA3Cet4oTEX4htKCvEYjT5yPqk6I=;
        b=1UgIhxlGV4g85U+iquNzhj9qKKYJ8Y2mEJNDHP5d1+VHiG2CNYiiD/cqFaHeTUHJYZ
         6SKxzSthHhZl+ewC8aqwVCC8pbSCT5d0RLv46j5g9HXVSEig5ZdfDHj0o0i4TExlYt4v
         uO67ySAYuDTTdekpTWp3wNvDXXgDjGyFUiKEn/Uz+OTCA/Q9gFQx/AMnRndki+ciRiwj
         AFP2WAY2ICgDgklt59uKHfZAs1EUqU7JIlIYeTrDA3tJ3IWk3/DKH21D84QQnouaRcID
         yaDtdbF8S9bDmx12dSJQPuwp6Zen4oIZcqGRRLmzWMVZKhk8ouUKJ42KTIgWOP7RR1VF
         JEbA==
X-Gm-Message-State: AOAM532RP0QM6z0LTScX89MEeK81OQI5vl4kpbnIR/idrT0h7LJaU0tA
        R2iLco0o7e8nKyx8nix1DVnkZDoYx4UFNQ==
X-Google-Smtp-Source: ABdhPJwAG/63AiINTSikYsI8doUivUX6P3IV5QNoDavz7yeMjUXwcDVMCU75WCGoQb+hD2+FVLzUXg==
X-Received: by 2002:a17:90b:4f4e:b0:1cd:5dd3:d684 with SMTP id pj14-20020a17090b4f4e00b001cd5dd3d684mr3897648pjb.129.1650115440122;
        Sat, 16 Apr 2022 06:24:00 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j6-20020aa79286000000b004fdf02851eesm6097970pfa.4.2022.04.16.06.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 06:23:59 -0700 (PDT)
Message-ID: <91f3c310-0952-0434-fa25-f85f6dd91bcf@kernel.dk>
Date:   Sat, 16 Apr 2022 07:23:57 -0600
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
 <ef406bf3-bdad-ca4e-257b-80dc148f4f1f@kernel.dk>
 <30fda41b-88c2-b194-fbf8-29ebe1240ee8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <30fda41b-88c2-b194-fbf8-29ebe1240ee8@gmail.com>
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

On 4/16/22 2:39 AM, Pavel Begunkov wrote:
> On 4/15/22 23:53, Jens Axboe wrote:
>> On 4/15/22 4:41 PM, Pavel Begunkov wrote:
>>> On 4/15/22 23:03, Jens Axboe wrote:
>>>> On 4/15/22 3:05 PM, Pavel Begunkov wrote:
>>>>> On 4/12/22 17:46, Jens Axboe wrote:
>>>>>> On 4/12/22 10:41 AM, Jens Axboe wrote:
>>>>>>> On 4/12/22 10:24 AM, Pavel Begunkov wrote:
>>>>>>>> If all completed requests in io_do_iopoll() were marked with
>>>>>>>> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
>>>>>>>> io_free_batch_list() leaking memory and resources.
>>>>>>>>
>>>>>>>> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
>>>>>>>> return the value greater than the real one, but iopolling will deal with
>>>>>>>> it and the userspace will re-iopoll if needed. In anyway, I don't think
>>>>>>>> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
>>>>>>>
>>>>>>> Ah good catch - yes probably not much practical concern, as the lack of
>>>>>>> ordering for file IO means that CQE_SKIP isn't really useful for that
>>>>>>> scenario.
>>>>>>
>>>>>> One potential snag is with the change we're now doing
>>>>>> io_cqring_ev_posted_iopoll() even if didn't post an event. Again
>>>>>> probably not a practical concern, but it is theoretically a violation
>>>>>> if an eventfd is used.
>>>>> Looks this didn't get applied. Are you concerned about eventfd?
>>>>
>>>> Yep, was hoping to get a reply back, so just deferred it for now.
>>>>
>>>>> Is there any good reason why the userspace can't tolerate spurious
>>>>> eventfd events? Because I don't think we should care this case
>>>>
>>>> I always forget the details on that, but we've had cases like this in
>>>> the past where some applications assume that if they got N eventfd
>>>> events, then are are also N events in the ring. Which granted is a bit
>>>> odd, but it does also make some sense. Why would you have more eventfd
>>>> events posted than events?
>>>
>>> For the same reason why it can get less eventfd events than there are
>>> CQEs, as for me it's only a communication channel but not a
>>> replacement for completion events.
>>
>> That part is inherently racy in that we might get some CQEs while we
>> respond to the initial eventfd notifications. But I'm totally agreeing
>> with you, and it doesn't seem like a big deal to me.
>>
>>> Ok, we don't want to break old applications, but it's a new most
>>> probably not widely used feature, and we can say that the userspace
>>> has to handle spurious eventfd.
>>
>> If I were to guess, I'd say it's probably epoll + eventfd conversions.
>> But it should just be made explicit. Since events reaped and checked
> 
> Didn't get it, what should be made explicit? Do you mean documenting
> that there might be spurious eventfd events or something else?

Right, we basically have both cases:

- A batch of completions are done, silly to do more than one eventfd
  notification for that.

- Spurious notifications, like this example with polling and CQE_SKIP.
  This one means that we may post a notification, but there are no
  events to be found.

It just needs to be clear that an eventfd notification just means that
you can check for events, it doesn't tell you anything about the number
of events that may be available.

Spurious events should be avoid, if possible, and are worse than batched
ones imho. Getting an eventfd notification yet having no events
available is silly.

-- 
Jens Axboe

