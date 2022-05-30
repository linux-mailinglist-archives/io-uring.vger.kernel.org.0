Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252835378D4
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiE3JgB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 05:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiE3JgB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 05:36:01 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5865571A34
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 02:35:57 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p5-20020a1c2905000000b003970dd5404dso6095216wmp.0
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 02:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=uGoIWOHMgJ4du6Xs774rQ68l5o0pv5jctxZ4J8lN4ec=;
        b=jMM8Pnw+EG+Si+6e3+wattB3sXpI9OReYOHTLKq9QFNLQjMi8wPt3UHbpFf4EAiwn3
         Pq/C1aHxDjplj3qwK+JjXAjnFOXPb5x8GMYCKEyzViCjzSaJbT6TJy9RbzcKHyjTcYoA
         OY4ULdr8R4pQf08bOwh1WSEuLl47tfqLNZS2JgGX/dT3W/zZKrdUTOGS9ICK9ubOzM2l
         GMVjlKAnPHG10BdPLYcrXnoiuYBoydEU+RYS6/iNO2RiAEGzvst9ujaSsF4Z6Nj6RhYN
         GH9gdD+9YgcvS7kmcPH3Nim1UkvDGU+QXNQaRuQpYORwrFcwSRJ1DX/AAPZOo9Usexpx
         yYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uGoIWOHMgJ4du6Xs774rQ68l5o0pv5jctxZ4J8lN4ec=;
        b=OBIm6avDnqwdoXO730bz7HU6bCJr/n/ZmQL5lhI+G1weJ0UVnAQ3V3IH1SyV/Vwgh2
         djJ6huz8ZcwQmGhALhZrWE6HCE9xy9lLv/njVGNxU1hvGgvn0QtE7J1Del1XZ1GGWqnp
         uWcwBUWqtO8bc+ZFCU6U64i+H/iU1dE93vMCfYssqmGlsqHxV5+1QxsDW6BT+11fue5+
         ToEyiAeUDA9Ygrr8cv/mEAeaBbrbPYllhLQ7oVrAkHHZdjLehQkdBU6FF/WTe7XiEwG8
         OPIQNLlh+/rV8XGdoU39F2wbNImD/n3LQU3CFri+fzHJtKiOLCP/CjRHDQTejYeuQzGZ
         vw2Q==
X-Gm-Message-State: AOAM533MFrmpqmmfhClF7YMb2JmteaiqZGhK4k2Zpi6+2G6k1L8A9yXq
        1tEe+YB56YKqi1X0S5lepEwmbSMSRLc=
X-Google-Smtp-Source: ABdhPJxoTrVCESKkyH95UyuF22gmpvYgbwW4NTZyW3BBZ/WEBPIbpbQysfmJxRUHzHCgiDZpHcqdqA==
X-Received: by 2002:a05:600c:3549:b0:397:8f09:1abe with SMTP id i9-20020a05600c354900b003978f091abemr12481607wmq.107.1653903355868;
        Mon, 30 May 2022 02:35:55 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y4-20020a5d6144000000b0020c5253d8f7sm8380539wrt.67.2022.05.30.02.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 02:35:55 -0700 (PDT)
Message-ID: <03a049c3-4bce-694f-c55c-274d2e34f22c@gmail.com>
Date:   Mon, 30 May 2022 10:35:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
 <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
 <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
 <d476c344-56ea-db57-052a-876605662362@gmail.com>
 <a939481d-98b5-2c40-4b76-74b89319ddba@kernel.dk>
 <97ebdccc-0c19-7019-fba7-4a1e5298c78f@gmail.com>
 <d530c3ab-4aec-730c-0f44-9752303e31ce@icloud.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d530c3ab-4aec-730c-0f44-9752303e31ce@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 07:52, Hao Xu wrote:
> On 5/30/22 08:18, Pavel Begunkov wrote:
>> On 5/30/22 00:34, Jens Axboe wrote:
>>> On 5/29/22 4:50 PM, Pavel Begunkov wrote:
>>>> On 5/29/22 19:40, Jens Axboe wrote:
>>>>> On 5/29/22 12:07 PM, Hao Xu wrote:
>>>>>> On 5/30/22 00:25, Jens Axboe wrote:
>>>>>>> On 5/29/22 10:20 AM, Hao Xu wrote:
>>>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>>>
>>>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>>>
>>>>>>>> Use per list lock for cancel_hash, this removes some completion lock
>>>>>>>> invocation and remove contension between different cancel_hash entries
>>>>>>>
>>>>>>> Interesting, do you have any numbers on this?
>>>>>>
>>>>>> Just Theoretically for now, I'll do some tests tomorrow. This is
>>>>>> actually RFC, forgot to change the subject.
>>>>>>
>>>>>>>
>>>>>>> Also, I'd make a hash bucket struct:
>>>>>>>
>>>>>>> struct io_hash_bucket {
>>>>>>>       spinlock_t lock;
>>>>>>>       struct hlist_head list;
>>>>>>> };
>>>>>>>
>>>>>>> rather than two separate structs, that'll have nicer memory locality too
>>>>>>> and should further improve it. Could be done as a prep patch with the
>>>>>>> old locking in place, making the end patch doing the per-bucket lock
>>>>>>> simpler as well.
>>>>>>
>>>>>> Sure, if the test number make sense, I'll send v2. I'll test the
>>>>>> hlist_bl list as well(the comment of it says it is much slower than
>>>>>> normal spin_lock, but we may not care the efficiency of poll
>>>>>> cancellation very much?).
>>>>>
>>>>> I don't think the bit spinlocks are going to be useful, we should
>>>>> stick with a spinlock for this. They are indeed slower and generally not
>>>>> used for that reason. For a use case where you need a ton of locks and
>>>>> saving the 4 bytes for a spinlock would make sense (or maybe not
>>>>> changing some struct?), maybe they have a purpose. But not for this.
>>>>
>>>> We can put the cancel hashes under uring_lock and completely kill
>>>> the hash spinlocking (2 lock/unlock pairs per single-shot). The code
>>>> below won't even compile and missing cancellation bits, I'll pick it
>>>> up in a week.
>>>>
>>>> Even better would be to have two hash tables, and auto-magically apply
>>>> the feature to SINGLE_SUBMITTER, SQPOLL (both will have uring_lock held)
>>>> and apoll (need uring_lock after anyway).
>>>
>>> My hope was that it'd take us closer to being able to use more granular
>>> locking for hashing in general. I don't care too much about the
>>> cancelation, but the normal hash locking would be useful to do.
>>>
>>> However, for cancelations, under uring_lock would indeed be preferable
>>> to doing per-bucket locks there. Guess I'll wait and see what your final
>>> patch looks like, not sure why it'd be a ctx conditional?
>>
>> It replaces 2 spin lock/unlock with one io_tw_lock() in the completion
>> path, which is done once per tw batch and grabbed anyway if
>> there is no contention (see handle_tw_list()).
>>
>> It could be unconditional, but I'd say for those 3 cases we have
>> non-existing chance to regress perf/latency, but I can think of
>> some cases where it might screw latencies, all share io_uring
>> b/w threads.
>>
>> Should benefit the cancellation path as well, but I don't care
>> about it as well.
>>
>>> What about io_poll_remove_all()?
>>
>> As mentioned, it's not handled in the diff, but easily doable,
>> it should just traverse both hash tables.
>>
> 
> Two hash tables looks good to me. If I don't get you wrong, one table
> under uring_lock, the other one for normal handling(like per bucket
> locking)?

Right, that's the plan

-- 
Pavel Begunkov
