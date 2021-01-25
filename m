Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6577730284F
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 17:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbhAYQ5O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 11:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbhAYQ5D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 11:57:03 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519F6C0613D6
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:56:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id j18so11688825wmi.3
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 08:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kOHOtM0pF7SjSUWGWK5iiNH6RGf2GWgJgztqqPClEFs=;
        b=ALqkqKIgAcOa2oE1KrIOKny3esZ8v6M5rOOU/9aTDri2MqRGY2fDUxq3OMTG1hMSLD
         pgBKq5Mp1dnSKqIVZCyrFHLc1kJ1LBUV7YXRm8GSd3qfblk3RQmRi4dO93832R5kBacE
         OrYSE2JRtrDG44Iqtc67TuIO/AAaUKeNadjbAfYIn3y26dRfmHtyMxS47mw7VasggInc
         kScb2Im6jeK/pUro3cLVoaVilWV14Fck3L3zhmolrLZ6hmjf3V0GJphR0nKMG79WptsM
         v/ep2pOoWGOxElDXA1mgeLi6WjJ4Y3YbE6Hc9/AazEjbKswDcA4h6z4XRkOluXCBWKiV
         46dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kOHOtM0pF7SjSUWGWK5iiNH6RGf2GWgJgztqqPClEFs=;
        b=Br7EFd7kQZar3i0I631N6OO+co0fXMW2Ym83Ul7opCcAzqdALcUQlSF17RAH7+kzVr
         IF/wIlTZQaWDLZLEdj3cf1oviJYlFuBGdXXKWXsU4OMQ3dtIcJzgc0EaujVxF3AG1hnv
         gLkfXIrGM6SI61osJXgq+vJeiNStiGr1m0oN2kUGk1LbwxI7G2L1lbjwA3wVsBf1K4IY
         BIyfnyPDE5W+V/VQmpbYFJNirYk9cmc1lwNFPwy5mM1MtdwHCIOA47CYGXRr5ElTMplX
         2V90ftaq3jkQ4xRUSUEuGnBGqQmfzSuAu/gN9fDtg55Olvbco96znkPPh6qehcBDWjYp
         Z8og==
X-Gm-Message-State: AOAM5329i99KsP82fHlT5j2+np4WPx4FLqemx+tSJl4XILUFIgDhvFWM
        H0DtJf8D2Pd29Lw/CyTajyO/UVRpHKyD+g==
X-Google-Smtp-Source: ABdhPJxIU5Sl3eQcgOP+YxXumpoIlpWWnvZG2AUtRft9t96d5WAQ7P5ZZGqR1Z27V19nK2lkqboKog==
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr993398wmc.184.1611593778883;
        Mon, 25 Jan 2021 08:56:18 -0800 (PST)
Received: from [192.168.8.154] ([85.255.234.28])
        by smtp.gmail.com with ESMTPSA id b7sm23260707wru.33.2021.01.25.08.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:56:18 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
 <dc52b7b5761ad78f0883ec7ca433c0a8d7089285.1611573970.git.asml.silence@gmail.com>
 <d802eb6f-f491-d35c-f556-c7d0285c6974@kernel.dk>
 <86406a3b-7d8e-5521-f6b5-f3a940a0565d@gmail.com>
 <db57bed7-40ad-0251-941c-60ab6c872baa@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/8] io_uring: don't keep submit_state on stack
Message-ID: <8d4db99a-9086-ef20-ba94-11ae0cdaafb0@gmail.com>
Date:   Mon, 25 Jan 2021 16:52:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <db57bed7-40ad-0251-941c-60ab6c872baa@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/01/2021 16:31, Jens Axboe wrote:
> On 1/25/21 9:25 AM, Pavel Begunkov wrote:
>> On 25/01/2021 16:00, Jens Axboe wrote:
>>> On 1/25/21 4:42 AM, Pavel Begunkov wrote:
>>>> struct io_submit_state is quite big (168 bytes) and going to grow. It's
>>>> better to not keep it on stack as it is now. Move it to context, it's
>>>> always protected by uring_lock, so it's fine to have only one instance
>>>> of it.
>>>
>>> I don't like this one. Unless you have plans to make it much bigger,
>>> I think it should stay on the stack. On the stack, the ownership is
>>> clear.
>>
>> Thinking of it, it's not needed for this series, just traversing a list
>> twice is not nice but bearable.
>>
>> For experiments I was using its persistency across syscalls + grew it
>> to 32 to match up completion flush (allocating still by 8) to add req
>> memory reuse, but that's out of scope of these patches.
>> I haven't got a strong opinion on that one yet, even though
>> alloc/dealloc are pretty heavy, this approach may loose allocation
>> locality. 
> 
> Agree on all of that. Locality is important, but reuse usually gets
> pretty useful as long as the total number (and life time) can be
> managed.

That all was about reqs completed inline, and for those it is pretty
easy and without any extra synchronisation. Depending on QD/etc.
it slashes 5-25% of overhead (~5-33% t-put boost), from what's left
with this series.

There are also other tricks extending it to async reqs, but that's
rather for hi QD with plugging off and ultra-fast devices.

Let's forget about these patches for now and I'll wrap experiments
into a patchset sometime later.

-- 
Pavel Begunkov
