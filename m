Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A22537313
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 02:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiE3ATP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 20:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiE3ATO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 20:19:14 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D71AD88
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 17:19:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h62-20020a1c2141000000b0039aa4d054e2so1445540wmh.1
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 17:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lph4m0eXflHdDfwc99S0cyz0XrLGM4IDY//ktoFpoLw=;
        b=qczLWnNFWg7gJy6RAGjvKPR9Xrwd7DdPLhSO4/3RLdS5XcHasGTjMuvIXI+bRe4Em8
         llENcz6KlsazhfeLXumejuQJnrA0G6LPbt5C1w9ZUDAISEGrLKgeWyO1pcCisLzg1qEF
         Tdz/Gt5xPvoFeqICykZlYwo6TgYhcUNgiX9Z2d4RfCaDIkizZzXN3v9jqwDVsJL4WuLK
         y2PTwUafSQn57y2QIWDP7R4/gZoePjpJlsh5KRsuwa25XLCr4cmgKh+3pfc8ad4uUMW2
         jwhZV3IPU92rCGWmPxRSj34vIyRpktQ9dC2ozghGjUCseOHtg5E+dpF9Zyi7fyGzcjFa
         C8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lph4m0eXflHdDfwc99S0cyz0XrLGM4IDY//ktoFpoLw=;
        b=woXs1XAH2PHDKrwQIfry1x5UWOifurcVKmfr31067DabR2QW6qE31laUmsz2ioTeNK
         wXINmNV+QrwQrcAEAqdGlTaLNVrmjxZtqwRUKH5ZgGh2hy8VAf4XPrbJAYHBKQH5L45W
         okSeEXd7NP0voYxNRkEfnk7mRBKBdLF6uqNs3CTdcSHJTUlPz+px4uoHdFd7mzQkQfNj
         1i9bLKWwaHuwmP2jpybJ+FIZt5Y25v6UWulX+QsHxPRevD0ZoyRe/X00jMs+JIXm7g6l
         5fjYj0TLw+R7vXVciYkgsoBN4n6SNXNUImXfVO1gq5t48BPQMoOxj/al7EKu2Vm7q3vf
         3low==
X-Gm-Message-State: AOAM533aR1gQRmdGEY7E85O4BkwlhH/g4aAR9WD/1R0t9+X3HpKXy2FM
        Ou+ZnoFNX5AWR+q5W4q6HNI=
X-Google-Smtp-Source: ABdhPJzk1trBRjpTy1pjDJcacRq3FTgN1dcUGTXuV7/8/tOvE81HWdBjJUtu9qhptlo9zCIopuRxKg==
X-Received: by 2002:a7b:c410:0:b0:397:40e9:bc82 with SMTP id k16-20020a7bc410000000b0039740e9bc82mr17178752wmi.42.1653869952020;
        Sun, 29 May 2022 17:19:12 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id l1-20020a5d6d81000000b0020d02262664sm7310019wrs.25.2022.05.29.17.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 May 2022 17:19:11 -0700 (PDT)
Message-ID: <97ebdccc-0c19-7019-fba7-4a1e5298c78f@gmail.com>
Date:   Mon, 30 May 2022 01:18:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu.linux@icloud.com>,
        io-uring@vger.kernel.org
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
 <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
 <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
 <d476c344-56ea-db57-052a-876605662362@gmail.com>
 <a939481d-98b5-2c40-4b76-74b89319ddba@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a939481d-98b5-2c40-4b76-74b89319ddba@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 00:34, Jens Axboe wrote:
> On 5/29/22 4:50 PM, Pavel Begunkov wrote:
>> On 5/29/22 19:40, Jens Axboe wrote:
>>> On 5/29/22 12:07 PM, Hao Xu wrote:
>>>> On 5/30/22 00:25, Jens Axboe wrote:
>>>>> On 5/29/22 10:20 AM, Hao Xu wrote:
>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>
>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>
>>>>>> Use per list lock for cancel_hash, this removes some completion lock
>>>>>> invocation and remove contension between different cancel_hash entries
>>>>>
>>>>> Interesting, do you have any numbers on this?
>>>>
>>>> Just Theoretically for now, I'll do some tests tomorrow. This is
>>>> actually RFC, forgot to change the subject.
>>>>
>>>>>
>>>>> Also, I'd make a hash bucket struct:
>>>>>
>>>>> struct io_hash_bucket {
>>>>>       spinlock_t lock;
>>>>>       struct hlist_head list;
>>>>> };
>>>>>
>>>>> rather than two separate structs, that'll have nicer memory locality too
>>>>> and should further improve it. Could be done as a prep patch with the
>>>>> old locking in place, making the end patch doing the per-bucket lock
>>>>> simpler as well.
>>>>
>>>> Sure, if the test number make sense, I'll send v2. I'll test the
>>>> hlist_bl list as well(the comment of it says it is much slower than
>>>> normal spin_lock, but we may not care the efficiency of poll
>>>> cancellation very much?).
>>>
>>> I don't think the bit spinlocks are going to be useful, we should
>>> stick with a spinlock for this. They are indeed slower and generally not
>>> used for that reason. For a use case where you need a ton of locks and
>>> saving the 4 bytes for a spinlock would make sense (or maybe not
>>> changing some struct?), maybe they have a purpose. But not for this.
>>
>> We can put the cancel hashes under uring_lock and completely kill
>> the hash spinlocking (2 lock/unlock pairs per single-shot). The code
>> below won't even compile and missing cancellation bits, I'll pick it
>> up in a week.
>>
>> Even better would be to have two hash tables, and auto-magically apply
>> the feature to SINGLE_SUBMITTER, SQPOLL (both will have uring_lock held)
>> and apoll (need uring_lock after anyway).
> 
> My hope was that it'd take us closer to being able to use more granular
> locking for hashing in general. I don't care too much about the
> cancelation, but the normal hash locking would be useful to do.
> 
> However, for cancelations, under uring_lock would indeed be preferable
> to doing per-bucket locks there. Guess I'll wait and see what your final
> patch looks like, not sure why it'd be a ctx conditional?

It replaces 2 spin lock/unlock with one io_tw_lock() in the completion
path, which is done once per tw batch and grabbed anyway if
there is no contention (see handle_tw_list()).

It could be unconditional, but I'd say for those 3 cases we have
non-existing chance to regress perf/latency, but I can think of
some cases where it might screw latencies, all share io_uring
b/w threads.

Should benefit the cancellation path as well, but I don't care
about it as well.

> What about io_poll_remove_all()?

As mentioned, it's not handled in the diff, but easily doable,
it should just traverse both hash tables.

-- 
Pavel Begunkov
