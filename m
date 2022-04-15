Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC58E5031CA
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354140AbiDOVIz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354014AbiDOVIu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:08:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2B36583F
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:06:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bv19so17123406ejb.6
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3Pb3Z/1iIHNkhauImccNmRZv8jyd/5zGH18C8kFd9G0=;
        b=P9hONBc9kSYkmZktqHwN78mGpymGf1B1sbEiZYeyhH80bjXYHyk8PXjbJ3t74oSgfo
         0visl7xX7CcBTJJ0LXVw8UPBK013FhaM7LiXEmG3bGHYP7ZXOOCWbHe4NKKOwc+0+AKi
         3KzMbU9waBwZq829anaeO/kVOdVng1uRpTaopIfrTZ01kk/iV/xZCQ5IR58zhUs3by0v
         TKn5kK2lpK1Rrd4kXpdzjmdHVUJOn3gz8qHKO0HAoRLy/Fmv4uL2L3YPrI8ElO4U8bB/
         Hi68WrcUJIda1R6UFqw/Dyi/dbVHhEp5zT4f2TGQrzLgJA1AZHbXY0VGSz3ZSVCG86zg
         uKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3Pb3Z/1iIHNkhauImccNmRZv8jyd/5zGH18C8kFd9G0=;
        b=ir+SvCxWaiSnOlJJb4mi4pVJrNYKNaGqYzN2lc4RDO7u2fm7C6yM6LGHDw1A6PG9Gc
         1UKY7zBn5DRKP+S9HRRrwUu7E1WgTo3gOZkQMZIqfp5tqImhQgR5rJKEBT+K3iiC8wz9
         EeGxtfvoZ2FZKcpcLGMMIfR8gIj7/IwpAKrj67LLLKFb0BT3ffzg5HH44SvQs7AXQ2xL
         PP0kJgydB5WIowA7b0RFrOGD+gN2Lt6dkhmjGA6RtamwbTW+PlomIMA9tPg0m84fALiE
         J+6eO/B9iYvnSnL34v5M2igU4wJHWqZ52t76BdOdFjDRaDxGugA94/79s6Sl1DHF75Z6
         710A==
X-Gm-Message-State: AOAM533hZPGfLsCXVtJY509qNRYFPdUNLcFHXOAjPKQ+6NznoMvNvvv8
        24oAv+rz+DFGqO3jN/CB6KL3krPvYm4=
X-Google-Smtp-Source: ABdhPJzsdJCocNulceB4aVR9yymUC1WL/NziPV/PEy4cUvl+fZTftAwgPFNh/nelvpYEK0LMtH+zQQ==
X-Received: by 2002:a17:906:4408:b0:6da:bec1:2808 with SMTP id x8-20020a170906440800b006dabec12808mr641131ejo.543.1650056779076;
        Fri, 15 Apr 2022 14:06:19 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id c4-20020a170906170400b006e87c7b8ffasm2023182eje.32.2022.04.15.14.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 14:06:18 -0700 (PDT)
Message-ID: <b837025e-4c18-322b-094c-6f518335c8ca@gmail.com>
Date:   Fri, 15 Apr 2022 22:05:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
 <7a6eef8a-d09b-89b2-f261-506ae6dae413@kernel.dk>
 <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <760bb119-6147-99b9-7e5a-c9c3566bfbfc@kernel.dk>
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

On 4/12/22 17:46, Jens Axboe wrote:
> On 4/12/22 10:41 AM, Jens Axboe wrote:
>> On 4/12/22 10:24 AM, Pavel Begunkov wrote:
>>> If all completed requests in io_do_iopoll() were marked with
>>> REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
>>> io_free_batch_list() leaking memory and resources.
>>>
>>> Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
>>> return the value greater than the real one, but iopolling will deal with
>>> it and the userspace will re-iopoll if needed. In anyway, I don't think
>>> there are many use cases for REQ_F_CQE_SKIP + IOPOLL.
>>
>> Ah good catch - yes probably not much practical concern, as the lack of
>> ordering for file IO means that CQE_SKIP isn't really useful for that
>> scenario.
> 
> One potential snag is with the change we're now doing
> io_cqring_ev_posted_iopoll() even if didn't post an event. Again
> probably not a practical concern, but it is theoretically a violation
> if an eventfd is used.
Looks this didn't get applied. Are you concerned about eventfd?
Is there any good reason why the userspace can't tolerate spurious
eventfd events? Because I don't think we should care this case

-- 
Pavel Begunkov
