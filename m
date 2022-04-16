Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FE4503545
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 10:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiDPIm4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Apr 2022 04:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiDPImz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Apr 2022 04:42:55 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461279D0C0
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 01:40:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r13so18922239ejd.5
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 01:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=h4gArwyEaxpMbH+V9ouiXRrDz8CW+c7BkeAZ49m3RLw=;
        b=P84uQfEpFHdl7cL/Sr+hEz5exhhkYIoYIa5FakLroWL0StND6Qb77gdS0+ITp5lNuH
         dLnUFCD3MeXa/4shsl0MrXgQ1Xh05l+sr+oKwmwe+JAxOIkQ/KDtllKXZkOHA22VatRH
         mCtM3cWAOpcPyfydb9+kGLbLn6AUadkF+uyNCfHdfOHnwkoMnFXpn5kutLy8Vi770vRg
         ZgVf7OgaHMc7u+fyyb7Y7mj8tOWRhiMZ3Idc63wwuNTeaZr8ouNB1UNcDRb3MXZPYD0i
         DttiRUW/mz/tHQCp3yWlrh1AldQqwKDQ3OxYcCSErMSJr89HAVe0F49AzEzAYKpbW73d
         1NLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h4gArwyEaxpMbH+V9ouiXRrDz8CW+c7BkeAZ49m3RLw=;
        b=R0LFVZ3wes0zzMDHJ9ccs8fOd04F3ImlftdlvBUjy2a8tq+dl02vid7Z/4dRCy5kPG
         Efajb6jYVUoQyuuw2e1srRlyHHKl4Y4ZnuT31reD1/dhkzJuthBv8EtSbn5Pu7y4Lv6r
         5S3h8ICecstrWFAuttnoyKUlQqsPhjKJl4IcQZkoGc4xOyuxYty1Wh77ZaE82zmpX9A2
         hHjL703YE9qBo/XcVuR6EtVuXWqjxekYdcdYdq9u6j2as1cP3Wzgpvd2XhaqV8omPXGl
         IdrSJFcvfcp5t3aHTShmQ/dxOTNaBJsKak+Ebsf441t/GY32veH1v0Gx7wMPn6FNC1F6
         xEIg==
X-Gm-Message-State: AOAM530JYLMLUPi3ZIbAUxytYMRudvSRsSAjhB5jhGe8ArIDHgvvBJvp
        KfpzYTB//mTVtY12AUcIe9Ci4S+/5O0=
X-Google-Smtp-Source: ABdhPJzEryoCSMVqy8xrtWc1pYelDbbNDEJCAp1Q/T65wx29WejTw9p5rCUSurCaO4SUF2Jnt2YrXw==
X-Received: by 2002:a17:907:1b09:b0:6d8:faa8:4a06 with SMTP id mp9-20020a1709071b0900b006d8faa84a06mr2026943ejc.701.1650098422801;
        Sat, 16 Apr 2022 01:40:22 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id lc3-20020a170906dfe300b006e8a859ead3sm2437730ejc.39.2022.04.16.01.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 01:40:22 -0700 (PDT)
Message-ID: <30fda41b-88c2-b194-fbf8-29ebe1240ee8@gmail.com>
Date:   Sat, 16 Apr 2022 09:39:32 +0100
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ef406bf3-bdad-ca4e-257b-80dc148f4f1f@kernel.dk>
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

On 4/15/22 23:53, Jens Axboe wrote:
> On 4/15/22 4:41 PM, Pavel Begunkov wrote:
>> On 4/15/22 23:03, Jens Axboe wrote:
>>> On 4/15/22 3:05 PM, Pavel Begunkov wrote:
>>>> On 4/12/22 17:46, Jens Axboe wrote:
>>>>> On 4/12/22 10:41 AM, Jens Axboe wrote:
>>>>>> On 4/12/22 10:24 AM, Pavel Begunkov wrote:
>>>>>>> If all completed requests in io_do_iopoll() were marked with
>>>>>>> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
>>>>>>> io_free_batch_list() leaking memory and resources.
>>>>>>>
>>>>>>> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
>>>>>>> return the value greater than the real one, but iopolling will deal with
>>>>>>> it and the userspace will re-iopoll if needed. In anyway, I don't think
>>>>>>> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
>>>>>>
>>>>>> Ah good catch - yes probably not much practical concern, as the lack of
>>>>>> ordering for file IO means that CQE_SKIP isn't really useful for that
>>>>>> scenario.
>>>>>
>>>>> One potential snag is with the change we're now doing
>>>>> io_cqring_ev_posted_iopoll() even if didn't post an event. Again
>>>>> probably not a practical concern, but it is theoretically a violation
>>>>> if an eventfd is used.
>>>> Looks this didn't get applied. Are you concerned about eventfd?
>>>
>>> Yep, was hoping to get a reply back, so just deferred it for now.
>>>
>>>> Is there any good reason why the userspace can't tolerate spurious
>>>> eventfd events? Because I don't think we should care this case
>>>
>>> I always forget the details on that, but we've had cases like this in
>>> the past where some applications assume that if they got N eventfd
>>> events, then are are also N events in the ring. Which granted is a bit
>>> odd, but it does also make some sense. Why would you have more eventfd
>>> events posted than events?
>>
>> For the same reason why it can get less eventfd events than there are
>> CQEs, as for me it's only a communication channel but not a
>> replacement for completion events.
> 
> That part is inherently racy in that we might get some CQEs while we
> respond to the initial eventfd notifications. But I'm totally agreeing
> with you, and it doesn't seem like a big deal to me.
> 
>> Ok, we don't want to break old applications, but it's a new most
>> probably not widely used feature, and we can say that the userspace
>> has to handle spurious eventfd.
> 
> If I were to guess, I'd say it's probably epoll + eventfd conversions.
> But it should just be made explicit. Since events reaped and checked

Didn't get it, what should be made explicit? Do you mean documenting
that there might be spurious eventfd events or something else?

> happen differently anyway, it seems like a bad assumption to make that
> eventfd notifications == events available.

-- 
Pavel Begunkov
