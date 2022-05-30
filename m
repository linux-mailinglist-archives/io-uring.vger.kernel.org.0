Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8479A537836
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 12:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiE3Jjh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 05:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiE3Jje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 05:39:34 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB5E75233
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 02:39:33 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id r123-20020a1c2b81000000b0039c1439c33cso542295wmr.5
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 02:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=nEV4CtmN4w2+n34bZWgHS4/bNCiKLosgPnj/LReaCcc=;
        b=jXQAUXTjtIc1/6kMQdeCpi69hUGxIKlc/qfTQedJdi+C8mAGp8V1wR1S8zyFfPVOUL
         oa13uABnAc0QTcehKElW9Hs0cMafASJca1Mss8i4zdHRbl2WVsV9btiX4UURIo8OvGo3
         odhxeq+6caZa5OfRbfkB+vr6gS9wSGhl2HJvIFe2TfGyR4gN4+SIG+JjAbR1y2+2Kzvw
         8KeX2ds5sFoYNf/ntoS0APQ+TzbBN4dL80KXR6YnJKC4asatTldQe5br7yJgRiSismMm
         3YVoDVm5yBRQo+jGg45Cg3vgpu1RlSrmOTepoF5ZHH202nBxnPqWYReslyaJz18fif6C
         HMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nEV4CtmN4w2+n34bZWgHS4/bNCiKLosgPnj/LReaCcc=;
        b=3lLnEPe6VDGnmpr6A971970nTxLPuRkjyikkxAA7lEj6AsZY+2u2cT8sJtKMf3r+nV
         TPehVcmU36xn3vfBNXaQIm55QunOM3D9fzm+Xd0zN3OnSJkT5F6IiHtE3TaDrmt16Orz
         +9Qn2tGPe95FSH7HB2s6PW/SD0irr8EBh8nILHIvJc1K5Rhpj+CitIR+vr91vy5bq2qG
         dlSxgPNsyPnpIdg8aUq8c1V95kqDBrxfkYC1V42Hd/xd6r26mogltUb/Qz9MFd0/F6m6
         bpiKCEBwZVf5hoFSvdSfsDQyozVRm73bImntemgAIPuobb4k/x+sSEJvRriuqgiMDTvt
         rCQg==
X-Gm-Message-State: AOAM530I+8kP33TNqt35kBC1ZJJ9bFUg+QgB0jtU5/hgPYVNWR17Ml8k
        N9AIEerycaiJGC/oV8ThAnIBIEIhRuo=
X-Google-Smtp-Source: ABdhPJwchi6Ep6AM61nYWPkcZ38kI2vlLyExD2smEcnx/OHiMUsCRQGq28d3dcRJ/iKbYsG62XbqEA==
X-Received: by 2002:a05:600c:384c:b0:398:e5d2:bfc9 with SMTP id s12-20020a05600c384c00b00398e5d2bfc9mr10109786wmr.180.1653903572044;
        Mon, 30 May 2022 02:39:32 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id o12-20020a05600c4fcc00b003942a244f2esm10295265wmq.7.2022.05.30.02.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 02:39:31 -0700 (PDT)
Message-ID: <05d07601-d3b0-17c9-6a83-d14221f66f5e@gmail.com>
Date:   Mon, 30 May 2022 10:39:10 +0100
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
 <5aa1d864-f4ee-643d-500d-0542d6fb72f3@icloud.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5aa1d864-f4ee-643d-500d-0542d6fb72f3@icloud.com>
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

On 5/30/22 07:38, Hao Xu wrote:
> On 5/30/22 06:50, Pavel Begunkov wrote:
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
>>>>>      spinlock_t lock;
>>>>>      struct hlist_head list;
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
>>
>> @@ -7332,9 +7345,13 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>>           return 0;
>>       }
>>
>> -    spin_lock(&ctx->completion_lock);
>> -    io_poll_req_insert(req);
>> -    spin_unlock(&ctx->completion_lock);
>> +    if (ctx->flags & IORING_MUTEX_HASH) {
> 
> Does IORING_MUTEX_HASH exclude IOSQE_ASYNC as well? though IOSQE_ASYNC
> is uncommon but users may do that.

It should, io-wq -> arm_poll() doesn't hold uring_lock, good point


-- 
Pavel Begunkov
