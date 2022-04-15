Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C556A50319C
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356369AbiDOWpI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 18:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiDOWpH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 18:45:07 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5BE9D0C8
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 15:42:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id t11so17341539eju.13
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 15:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=vVR4GUZos0xqbsHDHxjmRXVgG3JT1e1m9wRDOq771Ww=;
        b=RJI1cmoLTs8eWhrhW/crboKKC3WA5lpHH6oke1L2Pe3RNm38d1w3Vzjp6L5BNMYhLq
         ZFJV+H3psQt+B4NakkoZ1rjcvwL8IK30CYl7NA0+6GhgfbeJaKzhqETeRP72cgj2H+8A
         ot+HivpzsPN7fOVvWMMrFo/nfwXlm7fm4jN1awjLc4RqGJYPfBKrEF15jJx16++qFfoG
         mm5YC1qpAWEpwDxWyDUAHg7SQG/IPWD42+/KlUDxRiidGap/AmIVsxmpBiJFOLtobC5f
         S4MRA8yTianw5CwZPi19lTSyGLSbADy+i9v0XQeVJIz1hc12JnKfcAQNy2IWZ3PUflkP
         T4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vVR4GUZos0xqbsHDHxjmRXVgG3JT1e1m9wRDOq771Ww=;
        b=AT2EerYVNctDbW1Stmws0Lm1EFRJPme7XmNbWFpccvAajCXka9lQS4qyZ97UQdxUIh
         Zm+R3iRCcwGbDqPs1yV6NTI2AORS9Ta/UgOQvZ/1T6W07oS1Tk1tRY3rspfNLEVS8BQ2
         hMosUgclO2Q936LtRa36/P7iZWll6DnyhjsRuFuYuUx5TAoT31phzUUp/x9FN3YnlCY7
         TKgUoNNHc+6/uBGAAMsa6t1ptboOFoMDqnGVU+4FjXFHQsR+8GnMc2kRUshg/cebq3JC
         9AknoCBXxe736SZRXDSbmL1Lcw532plkkBCTBI6AwpnWFpDgoRvcLQYFVy0999/CgnYL
         wQLQ==
X-Gm-Message-State: AOAM531xMW38JIGaJxOjuxgzp6vT5e1PsiG0QahK9i0WkwpjOjSekuk7
        kWzrLG0NUKeyUsuJuFZa0Lk=
X-Google-Smtp-Source: ABdhPJzWozaQRFR5lqHE/vtadcdZsjaf65B+AsI/HNpus2ew7wwreXXBNdq8bOmk95lite+BJrp8Mw==
X-Received: by 2002:a17:907:8a01:b0:6e8:ab42:7440 with SMTP id sc1-20020a1709078a0100b006e8ab427440mr840776ejc.324.1650062552627;
        Fri, 15 Apr 2022 15:42:32 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id v11-20020aa7dbcb000000b004232ce8656fsm603709edt.86.2022.04.15.15.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 15:42:32 -0700 (PDT)
Message-ID: <e1b351c3-f18e-f3ce-f526-970447389a2d@gmail.com>
Date:   Fri, 15 Apr 2022 23:41:50 +0100
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aea01fb7-fa4f-c61a-2655-92129d727a74@kernel.dk>
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

On 4/15/22 23:03, Jens Axboe wrote:
> On 4/15/22 3:05 PM, Pavel Begunkov wrote:
>> On 4/12/22 17:46, Jens Axboe wrote:
>>> On 4/12/22 10:41 AM, Jens Axboe wrote:
>>>> On 4/12/22 10:24 AM, Pavel Begunkov wrote:
>>>>> If all completed requests in io_do_iopoll() were marked with
>>>>> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
>>>>> io_free_batch_list() leaking memory and resources.
>>>>>
>>>>> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
>>>>> return the value greater than the real one, but iopolling will deal with
>>>>> it and the userspace will re-iopoll if needed. In anyway, I don't think
>>>>> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
>>>>
>>>> Ah good catch - yes probably not much practical concern, as the lack of
>>>> ordering for file IO means that CQE_SKIP isn't really useful for that
>>>> scenario.
>>>
>>> One potential snag is with the change we're now doing
>>> io_cqring_ev_posted_iopoll() even if didn't post an event. Again
>>> probably not a practical concern, but it is theoretically a violation
>>> if an eventfd is used.
>> Looks this didn't get applied. Are you concerned about eventfd?
> 
> Yep, was hoping to get a reply back, so just deferred it for now.
> 
>> Is there any good reason why the userspace can't tolerate spurious
>> eventfd events? Because I don't think we should care this case
> 
> I always forget the details on that, but we've had cases like this in
> the past where some applications assume that if they got N eventfd
> events, then are are also N events in the ring. Which granted is a bit
> odd, but it does also make some sense. Why would you have more eventfd
> events posted than events?

For the same reason why it can get less eventfd events than there are
CQEs, as for me it's only a communication channel but not a
replacement for completion events.

Ok, we don't want to break old applications, but it's a new most
probably not widely used feature, and we can say that the userspace
has to handle spurious eventfd.


> So while I don't think it's a huge issue, and particularly because
> IOPOLL and eventfd would be a nonsensical combo, it would still be nice
> to generally make sure it's the case.
> 
> This isn't the only one though, so maybe we just apply this fix and do
> a full check down the line. Can't see this one making issues.
> 

-- 
Pavel Begunkov
