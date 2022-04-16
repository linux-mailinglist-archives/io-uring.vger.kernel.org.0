Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A330503539
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 10:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiDPIiM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Apr 2022 04:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiDPIiL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Apr 2022 04:38:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10834A937
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 01:35:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b15so12280167edn.4
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 01:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=tJYLLfSj5mfRHYaP85yaL+KqmE3bZcNBZg1N/oK4hIc=;
        b=I8ZSmmEZwN/2CcsuPHRWpKyBojanBitnfClBfJQwRxZfIIZEVNGGhNQPw6fWXL2Em9
         ItyMA8gi8jjDzsTiiagWEW5bq0MO2KPxDtqNI7wHaQHxGP9hp7SprFB4PyEpxoBqT6Tq
         vpkn2sVh02bhHOvQOtGfcOL/Z2Jzt2m1szce735/dYK8azeFRDa5DGQ8nRLk0S87sYLT
         d75+m/K2hr+DdJArtRsATU9bw7MJW0F24OZhqjHekru8xPqiRs30mbzYFKBd0xCrjx/P
         iJUjYfSb3XdEeB2zazdkA79M7XDRPHffU5XdvGbsJQRWfppjgq1wYYPpcNbgyQ6fvDiH
         M9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=tJYLLfSj5mfRHYaP85yaL+KqmE3bZcNBZg1N/oK4hIc=;
        b=wpu6SAfVPV71dvCmAX/YSm+kWbKMNGOdsbzZIW7dArYXVpHFWW+/tLHbr2nyBfRMIB
         B19EQmsmX34hzcdIZ4y4dWdLBhqnZd2rCrp51t+cmeW7W6QkUlUlEScdDWBkl9eLiO1h
         8ihUgeBt8HSLYvDovoRWxcs9gow81Mydt0g476kQCLdHT2sRr8icgaAh+Mn2o5oRfvc9
         wrlCVxSLY266l/WuNsaWcHweZ2kVh7eN2bkC1E9N+MDjcgfqXJ2kOgze6DjkBWFvPzIa
         YpL2Is0LVZhtZ7atRngON0gYnmP6v0NYjhnojMSZHqGtWuRszrnYDcp1t15SSYKkxG0o
         3UwQ==
X-Gm-Message-State: AOAM533sJ4kEQClH22rOdomBNjk4Jjcw1Rf5auHea3B62yG8lg1pxNON
        Vc62ilJ+2+jl1Z1ffYjpwTA1JDzjqmg=
X-Google-Smtp-Source: ABdhPJyU0EJeRoZDqRPEyyFdCZJXeAgDYElWOtws3Co4gFRfND/wuqwkRfylLe1X04jpONpIMH9d1g==
X-Received: by 2002:a05:6402:442:b0:416:14b7:4d55 with SMTP id p2-20020a056402044200b0041614b74d55mr2809888edw.183.1650098138275;
        Sat, 16 Apr 2022 01:35:38 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id p22-20020aa7c4d6000000b004209e0deb3esm3873142edr.30.2022.04.16.01.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 01:35:37 -0700 (PDT)
Message-ID: <073a5570-3d42-87f1-6a92-b43e83369753@gmail.com>
Date:   Sat, 16 Apr 2022 09:34:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
 <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
 <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
 <b837025e-4c18-322b-094c-6f518335c8ca@gmail.com>
 <aea01fb7-fa4f-c61a-2655-92129d727a74@kernel.dk>
 <e1b351c3-f18e-f3ce-f526-970447389a2d@gmail.com>
In-Reply-To: <e1b351c3-f18e-f3ce-f526-970447389a2d@gmail.com>
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

On 4/15/22 23:41, Pavel Begunkov wrote:
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

s/communication/notification/

> replacement for completion events.

-- 
Pavel Begunkov
