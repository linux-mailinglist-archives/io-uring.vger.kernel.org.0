Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EA53635C6
	for <lists+io-uring@lfdr.de>; Sun, 18 Apr 2021 15:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhDRN4r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Apr 2021 09:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhDRN4r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Apr 2021 09:56:47 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AB0C06174A
        for <io-uring@vger.kernel.org>; Sun, 18 Apr 2021 06:56:18 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p19so16757278wmq.1
        for <io-uring@vger.kernel.org>; Sun, 18 Apr 2021 06:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lywoVbkc99+4ZFSf+vvv6L19uzHNEVp1vF1SDRobVB0=;
        b=YvLmqkae3MOpl6xTcPbte8nX7YEdmGAK4hObwUaxHq2ZbLBvHlp0T9ltYZjP2AMZwA
         l0srpeqtbbMgoQX6cS9YDVp49nFJZCk2yUx3BTkYPf6tPQVKKSl6CyMf+ahEA2iBTAqH
         KYLsQiB2Fpymm0RrTJkktoeOP5zlre+diaHNiyfi7S7sBAJg0dVn/IjY5kEJ1eNwm19Y
         X9IULAQgpf3VfERfUxfSH/i9htUa7iMH9Y8mIbthhiiHm0PvxhLGp69oWOIo9a0BvKUc
         /v2yWhlKaT30XuAzrxlQpujeGQoHpSXlacFGELgNEE2kcoprC8ZE34B5JcFPddKwIpG/
         aPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lywoVbkc99+4ZFSf+vvv6L19uzHNEVp1vF1SDRobVB0=;
        b=c8Cuk7SmL/shIeQtftVsTuSGUHxKcBUnGfx4NPdupqX3t5QlRQLhbS5jKpfdSOItzw
         RaooawclTS672iSAaQqwb/IQvm3IID0ElTELJmuqNjphTt/xjED1N4CUJyR++SlSVBMt
         9/U0v2OoQm9SF4U/DMuI2yPOzdVjkDB28lBqrRi4Dt89Q8r4isv4oSqVLfQacNgJhDiq
         jLKLZ5pcax4GvXGDyh8uBw18pjoez+/K0Hd+zR1rcwsNWMF/96YKs+E1Zl89sMLd+HJe
         x00ooGhwLG2/LuL/vQ6tZoxUpQsU8/hk/4Tj5vcM+hvGUz2L50SKwO8iDLRANVXhCbzM
         44cQ==
X-Gm-Message-State: AOAM531LjLOIwHHvv11mr3faCqPZJucKLsb/zxzyfvv54L+mPO6VUgLH
        /R6Gtk9B8wvIE2mbzmk2OburSgJvvY8tagWn
X-Google-Smtp-Source: ABdhPJxI4mbRFp39+TLUIJXAK5QW6BBtpZAYPFgeEnMht2hTlvZyTZyGg/9j6nelrpN1T2l7gmUOiQ==
X-Received: by 2002:a05:600c:1405:: with SMTP id g5mr17352474wmi.186.1618754176939;
        Sun, 18 Apr 2021 06:56:16 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.62])
        by smtp.gmail.com with ESMTPSA id z17sm19599091wro.1.2021.04.18.06.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 06:56:16 -0700 (PDT)
Subject: Re: [PATCH 0/2] fix hangs with shared sqpoll
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1618532491.git.asml.silence@gmail.com>
 <8d04fa58-d8d0-8760-a6aa-d2bd6d66d09d@gmail.com>
 <36df5986-0716-b7e7-3dac-261a483d074a@kernel.dk>
 <dd77a2f6-c989-8970-b4c4-44380124a894@gmail.com>
 <dabc5451-c184-9357-c665-697fe22c2e9e@kernel.dk>
 <1c26a568-e532-0987-158a-4cad6195f284@gmail.com>
 <20210417013115.15032-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <2fb7b552-6c63-9720-c184-1e54b24a62f5@gmail.com>
Date:   Sun, 18 Apr 2021 14:56:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210417013115.15032-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/17/21 2:31 AM, Hillf Danton wrote:
> On Fri, 16 Apr 2021 15:42:07 Pavel Begunkov wrote:
>> On 16/04/2021 15:09, Pavel Begunkov wrote:
>>> On 16/04/2021 14:58, Jens Axboe wrote:
>>>> On 4/16/21 7:12 AM, Pavel Begunkov wrote:
>>>>> On 16/04/2021 14:04, Jens Axboe wrote:
>>>>>> On 4/15/21 6:26 PM, Pavel Begunkov wrote:
>>>>>>> On 16/04/2021 01:22, Pavel Begunkov wrote:
>>>>>>>> Late catched 5.12 bug with nasty hangs. Thanks Jens for a reproducer.
>>>>>>>
>>>>>>> 1/2 is basically a rip off of one of old Jens' patches, but can't
>>>>>>> find it anywhere. If you still have it, especially if it was
>>>>>>> reviewed/etc., may make sense to go with it instead
>>>>>>
>>>>>> I wonder if we can do something like the below instead - we don't
>>>>>> care about a particularly stable count in terms of wakeup
>>>>>> reliance, and it'd save a nasty sync atomic switch.
>>>>>
>>>>> But we care about it being monotonous. There are nuances with it.
>>>>
>>>> Do we, though? We care about it changing when something has happened,
>>>> but not about it being monotonic.
>>>
>>> We may find inflight == get_inflight(), when it's not really so,
>>> and so get to schedule() awhile there are pending requests that
>>> are not going to be cancelled by itself. And those pending requests
>>> may have been non-discoverable and so non-cancellable, e.g. because
>>> were a part of a ling/hardlink.
>>
>> Anyway, there might be other problems because of how wake_up()'s
>> and ctx->refs putting is ordered. Needs to be remade, probably
>> without ctx->refs in the first place.
>>
> Given the test rounds in the current tree, next tree and his tree the

Whose "his" tree?

> percpu count had survived, one of the quick questions is how it fell apart
> last night?

What "percpu count had survived"? Do you mean the percpu-related patch
from the series? What fell apart?

--   
Pavel Begunkov
