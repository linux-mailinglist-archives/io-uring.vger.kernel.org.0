Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C92350353C
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 10:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiDPIkG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Apr 2022 04:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiDPIkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Apr 2022 04:40:06 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07ED90CCE
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 01:37:34 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b15so12282917edn.4
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 01:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=KKci27fh9iMbbPIHTtab28OkIC2yFhTzf+nqWtu2af4=;
        b=X10gE9tytg9QlA463x3/w4ELSA/egFn1ECh/1dsABuL79lytf3/9J9QunVTbof8eUp
         fMEoJzyX9w/vThuCxZqtrIf/NP13uzy1LQPBKEloGQgJ6r2hw3KS5Fcs1rqfDWEPnd6J
         b2LXMFdAMmEPC8QqTXNthpEPBckKmTI24dNFqKHVatiFDQHSxd40ob8Hx8mImynlXVu8
         YN7PvpGZxfp7X24SxQ1t0zNBObOTU5GHeIc7kCmq0oazxriVysL4qXVEP8B/zCSEt6jj
         IMx7X3vqwvki/0eL23tbcGbMdBZsbzLfdvupZFZOgnrU6R2i4WDnuDcSpQBocJXZB/qy
         5pOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KKci27fh9iMbbPIHTtab28OkIC2yFhTzf+nqWtu2af4=;
        b=CT4tu2fQldurKp+ZUReeV6pUGiteSiouTS0eUSdMMx1gnz2AKAk2GaEUyGbcXnFcOh
         unLNcyPt1FmXb6mN4NEFEwuA8oZXBvIAkONIZAYiYWpRDM2zKpl8ExaXWhJqGurNmPNT
         efx9t8doxY/rO0qPDg0mCkDdygL5NZdI+TvSuTu1uNu3o2Oroi8bfnTyFzAFRSDwsRXR
         wia+euDMoiKfrDfwhNq5AT6tGhuuJkYe5k81OuXPXR2pGaicvrSuac1HiTs9Q62Dakgn
         tvqiuXlrdpjs8LNP49k72MUXg5mO82WxxrB3a7GIegOH9x7BgQbSXlSmNVEkLuIfAflg
         5mXA==
X-Gm-Message-State: AOAM53157UQetTHex6omvYvByYxx40mwJBYZ2cwpUKaQ2qDjxH6twAAB
        CJOWcZiDaWMCrgGNmazVSww=
X-Google-Smtp-Source: ABdhPJxFFhhvNItQ9K4Y0IyfoE/f82dybY49gZy3OreIp5ecov+dkHOZc13HolQGUxFDJO2XMCOSsw==
X-Received: by 2002:a05:6402:42cb:b0:421:c735:1fd3 with SMTP id i11-20020a05640242cb00b00421c7351fd3mr2858536edc.341.1650098253301;
        Sat, 16 Apr 2022 01:37:33 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090630cc00b006dfdfe15cf8sm2419584ejb.196.2022.04.16.01.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 01:37:32 -0700 (PDT)
Message-ID: <83dbdc21-7a68-f173-66f6-d5aeb840d9ce@gmail.com>
Date:   Sat, 16 Apr 2022 09:36:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
 <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
 <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
 <b837025e-4c18-322b-094c-6f518335c8ca@gmail.com>
 <aea01fb7-fa4f-c61a-2655-92129d727a74@kernel.dk>
 <e1b351c3-f18e-f3ce-f526-970447389a2d@gmail.com>
 <ef406bf3-bdad-ca4e-257b-80dc148f4f1f@kernel.dk>
 <c3cd7418-a8d4-456f-0ae1-a1b2b8750e5b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c3cd7418-a8d4-456f-0ae1-a1b2b8750e5b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/16/22 00:51, Jens Axboe wrote:
> On 4/15/22 4:53 PM, Jens Axboe wrote:
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
>> happen differently anyway, it seems like a bad assumption to make that
>> eventfd notifications == events available.
> 
> The patch is against the 5.19 branch, but it might be a better idea
> to do this for 5.18 as the 5.17 backport will then not need
> assistance. Can you send it against io_uring-5.18?

sure

-- 
Pavel Begunkov
