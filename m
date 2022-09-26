Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59965EB2C0
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 22:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbiIZU7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 16:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiIZU67 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 16:58:59 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A1AA032C
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 13:58:58 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so98400pjb.0
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 13:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=YS0JM37x41Hs+Zsw/Rkr6g59/J52wo2FJJr5wT1ONS4=;
        b=nBjZ3uEORo02yUpAZrYg8mKa5fzhgTcxuRcisFr9M2ijvVDEATfwfbbh+th/v3mT5b
         8i+JTV5VWk6P80cJBvNfKSzn9Tv6Hs8X9ubFlJtevii51MW6fq3Xqfgfo7cTxbwNETaX
         CGbfLx37NCo+2AnZuTIPX+8H62KX0MEftNXioQt0YPIgQGwooPKBdIFecqkyUGeuGDhM
         5wdKH7Emi9oF6cp3tMYZ54IWA/JiljCOR9FZ3kYbZYo501xJtcqzaX8ZWnggCnNlS73l
         SoGkqrQoAtzK1VPAP0BzfO92gVv4uhRQ7pZ/Hxi8bF2YaO/HPkuR4D9U83tTwc/NAxVy
         8G5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YS0JM37x41Hs+Zsw/Rkr6g59/J52wo2FJJr5wT1ONS4=;
        b=t8KPGGb7AGPq/NRjB0swc6PdjZb9rNeUcM5NBQgGRd5iPRKNkqBGykZbmH837ECCCg
         rLkIDeDUPvjcHVn+lWjFLxyGJTwir6bFbd5IObrxm15cVl+VjsuTBzfOdLV4DjqNoFmV
         UFpwOKm8A9NK0s67UfCJ2NZCFV1IBqO9jHG+2cJRgaLtJNLETO6q6Ft3iJpYYpbZSiE7
         jRvvef9z7E22l7L91A2rKzW4sX2NGgGruOZC4C2fjcmrm5hmwNfh+RwvKkI82z/VFJVM
         zUR4i9qDQQv+ACdWCjhurZqrvIfzZoSGNKiXveuhxwcuszNN2bAXMHFQixHdBJcuRT04
         hf3w==
X-Gm-Message-State: ACrzQf15/dn+p0kh6pc4327SFClBjQmLUB17YcYzo8IXU8qaah2X2qS/
        XcZ/korJroHe7Ui7UJ08IQjkxg==
X-Google-Smtp-Source: AMsMyM5nJ6tVia4CPWMNb3Hpg6BVi5OoU9J+lYWJPHaVtlSJErygqLIuF+tjAoarq2+t1jYC6fKWYg==
X-Received: by 2002:a17:90b:350d:b0:202:ff91:a0bd with SMTP id ls13-20020a17090b350d00b00202ff91a0bdmr728520pjb.46.1664225937638;
        Mon, 26 Sep 2022 13:58:57 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b130-20020a621b88000000b0053e468a78a8sm12665430pfb.158.2022.09.26.13.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 13:58:57 -0700 (PDT)
Message-ID: <9419ed33-5df2-9c4d-ae54-07bde5e3f4ff@kernel.dk>
Date:   Mon, 26 Sep 2022 14:58:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/3] io_uring: register single issuer task at creation
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
References: <20220926170927.3309091-1-dylany@fb.com>
 <20220926170927.3309091-2-dylany@fb.com>
 <35d9be6b-89ca-f2a1-ce5f-53e72610db6e@gmail.com>
 <4623be74-d877-9042-f876-09feba2f0587@kernel.dk>
 <3a582199-7ee6-caf7-0314-a8a32a17b980@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3a582199-7ee6-caf7-0314-a8a32a17b980@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 2:29 PM, Pavel Begunkov wrote:
> On 9/26/22 20:40, Jens Axboe wrote:
>> On 9/26/22 1:12 PM, Pavel Begunkov wrote:
>>> On 9/26/22 18:09, Dylan Yudaken wrote:
>>>> Instead of picking the task from the first submitter task, rather use the
>>>> creator task or in the case of disabled (IORING_SETUP_R_DISABLED) the
>>>> enabling task.
>>>>
>>>> This approach allows a lot of simplification of the logic here. This
>>>> removes init logic from the submission path, which can always be a bit
>>>> confusing, but also removes the need for locking to write (or read) the
>>>> submitter_task.
>>>>
>>>> Users that want to move a ring before submitting can create the ring
>>>> disabled and then enable it on the submitting task.
>>>
>>> I think Dylan briefly mentioned before that it might be a good
>>> idea to task limit registration as well. I can't think of a use
>>> case at the moment but I agree we may find some in the future.
>>>
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 242d896c00f3..60a471e43fd9 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3706,6 +3706,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>>       if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
>>>           return -ENXIO;
>>>   +    if (ctx->submitter_task && ctx->submitter_task != current)
>>> +        return -EEXIST;
>>> +
>>>       if (ctx->restricted) {
>>>           if (opcode >= IORING_REGISTER_LAST)
>>>               return -EINVAL;
>>
>> Yes, I don't see any reason why not to enforce this for registration
>> too. Don't think there's currently a need to do so, but it'd be easy
>> to miss once we do add that. Let's queue that up for 6.1?
> 
> 6.1 + stable sounds ok, I don't have an opinion on how to how
> to merge it.

That's the plan. If you can just send it out as a separate commit,
I'll stage it up behind the two others from Dylan.

-- 
Jens Axboe


