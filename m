Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9910B5033CB
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 07:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241069AbiDOXxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 19:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiDOXxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 19:53:53 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD80F954B6
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 16:51:22 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id u2so8971073pgq.10
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 16:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=tuyHE65Jh6X7NSujJbaDSg85VsJl9QAlWvwmoi5NTsI=;
        b=MPWNqALsaEYFUNNWVp0ltJZBSgS9MALKCBimG0Dvww+kqmuDXJbi7wTfmH4UGjOsH3
         KzWw0Ag8i1Hvlr2di4/at3PCbiLrRPVp5sGd41fAEqgzpKg0tklH7w+SSrVIVF40L4Cq
         b93njyC6ILy/nWHKr9mGMLCUUZvoqiDi48dQKanorOR3VcmjIcMbL3H70ve5urF2X45y
         AONhQj8d+3Aib6ab3V/A/qR9QILyDF+ZgUuD1gBPxavhQs1QU2o8BcAHY8qcb8uxsVue
         +OA8gaSG0OYb1s11iW1zJxKT6ujAZsLnftxydCi9PbhuwnZN2fN1R/mQlj+DXy8wztM7
         muXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=tuyHE65Jh6X7NSujJbaDSg85VsJl9QAlWvwmoi5NTsI=;
        b=OPqhLQw2+3C5jyErYL/yxE4D1dnDeJ+4BQ4cXLu/lravqq5XvMrM5MHi+ZchbDVCLy
         moh9yVyTRGBC9+yI5VHBiFacEGMwxVzE82SZhpVbZZSZCg2K5HUmzFiVUcaF0dz4ci8K
         dGU5t/ak4+MfB5cvyNDPRixzya59EQFsZ3GHip8HznWhPsNmoctD5PFgnKKyCWW2/Tuo
         QnTHrwZdTB+K026CruHnVtnWiVGeBiAu8U59UsVa9f11LPzJBngAbs+fx2Ci+cuLtb8z
         JhkACJP5WW9P+aydlNArVlvw3ESkFV0UYAuRgTCnm6tbBFrqXA9EckuSbFL0/eFswM8D
         BhnA==
X-Gm-Message-State: AOAM5328pyAVbS4KIrO/cCsvGJLTQXP1RIgrg4ov/QzuhLdzPkQRE9rQ
        VZt6VOLmKlMlE1GTlyCKb801AsLiLcSmaQ==
X-Google-Smtp-Source: ABdhPJyCoC+nXv4EWlcwgMrgkOk9TxfJ3NUN01uG1q7Rk0P6u5Owi80CZTZ+BuZBOfgtbO1OUTLi/w==
X-Received: by 2002:a62:ed0e:0:b0:4fa:11ed:2ad1 with SMTP id u14-20020a62ed0e000000b004fa11ed2ad1mr1260739pfh.34.1650066682251;
        Fri, 15 Apr 2022 16:51:22 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm3838352pfm.207.2022.04.15.16.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 16:51:21 -0700 (PDT)
Message-ID: <c3cd7418-a8d4-456f-0ae1-a1b2b8750e5b@kernel.dk>
Date:   Fri, 15 Apr 2022 17:51:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
 <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
 <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
 <b837025e-4c18-322b-094c-6f518335c8ca@gmail.com>
 <aea01fb7-fa4f-c61a-2655-92129d727a74@kernel.dk>
 <e1b351c3-f18e-f3ce-f526-970447389a2d@gmail.com>
 <ef406bf3-bdad-ca4e-257b-80dc148f4f1f@kernel.dk>
In-Reply-To: <ef406bf3-bdad-ca4e-257b-80dc148f4f1f@kernel.dk>
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

On 4/15/22 4:53 PM, Jens Axboe wrote:
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
> happen differently anyway, it seems like a bad assumption to make that
> eventfd notifications == events available.

The patch is against the 5.19 branch, but it might be a better idea
to do this for 5.18 as the 5.17 backport will then not need
assistance. Can you send it against io_uring-5.18?

-- 
Jens Axboe

