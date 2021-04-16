Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56B23621EE
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244439AbhDPONk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 10:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244150AbhDPONj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 10:13:39 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6455C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 07:13:14 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id w4so23119162wrt.5
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 07:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=COAufHyHaPHxnM2sCaV8LPj9p2vDTwuKvWb26tBe8xM=;
        b=I6Q9zG0M94rv4WwjD2GIbeaguqL67YhwMMvlkufpElwhkrNH8zieLZk7oPXAm/9u58
         +689HsKCGJcbqc1Q6g0UoKSNzRQRdIkuWpY7Iq9azDPuYB/vVGpEDSLQggZIwnctva3y
         PSePq3IIU2dEExjVfDhaLOalEGgcLP6g3lcz9BqKvNKxN7yny7fvju1ufwqgEdK26vhB
         Qabe+62pY566hkWlmbR4WL01rDmaNXMDu0Beu02BDrroShtokQyjYg+0spO+q/CkdgM0
         LWk6DW+gxuXrPm02yVLiTUgZWaicpeXFsxvwmEP1m7h09Zrd1lL/CBNqwWXqv7Z940xc
         g7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=COAufHyHaPHxnM2sCaV8LPj9p2vDTwuKvWb26tBe8xM=;
        b=M343rmdMXW4mWhgR+G+sDxZQwJFHXXI93ro5VPySn3V6ZPBdvfl5yhqbtFuDRfd+9o
         pVF9LquTaFAtvQSXrMqamisfiC9U2OU030qy1uiUAwbMB3p4VTxupprbW7CUu02CJQPJ
         5lbb9wlqp2xCWeOOKVUhBEVR3gBz3IxGEhs5ZX/baG1C2qn7QxxYUnJvM+BBXVPph8H+
         Fx5o8dqT3DDnP/y780zoroQnxUW3C7ODM7wSep/1fylZMQ52HqSpuZ8rAfenzorPQUrF
         5Iafisk5sDxzly5oN5wVRieedSt3RQPUcWFPl6lq8cESqHibEbQrIztid6bkc/5QSeLg
         IMlg==
X-Gm-Message-State: AOAM531YIhwSoXstUFEKsvstJfSfM2Hw+1WwWqjxvOOOTgG96A1iRF8I
        lB4eeNrG9sV75KNkgdP+7+Zk7Ud0JYzu1g==
X-Google-Smtp-Source: ABdhPJxq3/vRruEVeJKHfqhUUPuoXvd3Svahgx7fv6Gdzh8uYq9lVAXiteGTMv99n423sFfEg2CcWA==
X-Received: by 2002:adf:f692:: with SMTP id v18mr9075129wrp.206.1618582393695;
        Fri, 16 Apr 2021 07:13:13 -0700 (PDT)
Received: from [192.168.8.191] ([148.252.132.77])
        by smtp.gmail.com with ESMTPSA id q14sm8404906wrx.40.2021.04.16.07.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 07:13:13 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <8d04fa58-d8d0-8760-a6aa-d2bd6d66d09d@gmail.com>
 <36df5986-0716-b7e7-3dac-261a483d074a@kernel.dk>
 <dd77a2f6-c989-8970-b4c4-44380124a894@gmail.com>
 <dabc5451-c184-9357-c665-697fe22c2e9e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] fix hangs with shared sqpoll
Message-ID: <1c26a568-e532-0987-158a-4cad6195f284@gmail.com>
Date:   Fri, 16 Apr 2021 15:09:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <dabc5451-c184-9357-c665-697fe22c2e9e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/04/2021 14:58, Jens Axboe wrote:
> On 4/16/21 7:12 AM, Pavel Begunkov wrote:
>> On 16/04/2021 14:04, Jens Axboe wrote:
>>> On 4/15/21 6:26 PM, Pavel Begunkov wrote:
>>>> On 16/04/2021 01:22, Pavel Begunkov wrote:
>>>>> Late catched 5.12 bug with nasty hangs. Thanks Jens for a reproducer.
>>>>
>>>> 1/2 is basically a rip off of one of old Jens' patches, but can't
>>>> find it anywhere. If you still have it, especially if it was
>>>> reviewed/etc., may make sense to go with it instead
>>>
>>> I wonder if we can do something like the below instead - we don't
>>> care about a particularly stable count in terms of wakeup
>>> reliance, and it'd save a nasty sync atomic switch.
>>
>> But we care about it being monotonous. There are nuances with it.
> 
> Do we, though? We care about it changing when something has happened,
> but not about it being monotonic.

We may find inflight == get_inflight(), when it's not really so,
and so get to schedule() awhile there are pending requests that
are not going to be cancelled by itself. And those pending requests
may have been non-discoverable and so non-cancellable, e.g. because
were a part of a ling/hardlink.

>> I think, non sync'ed summing may put it to eternal sleep.
> 
> That's what the two reads are about, that's the same as before. The
> numbers are racy in both cases, but that's why we compare after having
> added ourselves to the wait queue.
> 
>> Are you looking to save on switching? It's almost always is already
>> dying with prior ref_kill
> 
> Yep, always looking to avoid a sync switch if at all possible. For 99%
> of the cases it's fine, it's the last case in busy prod that wreaks
> havoc.

Limited to sqpoll, so I wouldn't worry. Also considering that sqpoll
doesn't have many file notes (as it was called before). We can
completely avoid it and even make faster if happens from sq_thread()
on it getting to exit, but do we want it for 5.12?

-- 
Pavel Begunkov
