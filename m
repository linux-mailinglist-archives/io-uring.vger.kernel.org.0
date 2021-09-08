Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7164C40402C
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 22:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbhIHUZy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 16:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhIHUZy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 16:25:54 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E049C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 13:24:44 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id v16so3659414ilo.10
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 13:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=F2maXO1cteux1obZPDgFnfhF7yGXljFYr2kiqmnP9sg=;
        b=wlTl6gnCw7luKAmY3jNwLZXJxp6HpMJqI70mwLHvY5f2jVZHz/uEDM4AtHES8qMwg2
         2logSljiXojgLnIp85zzJJX//cpI6RAcu6ixtAD6DCHqORd9sf1lWk7ERG41N/y07vSE
         hiQ/FUIOUM3gEt4YDfo4t/V1TpESMAE20na6rkmAdNe+PVHH3BrG4AnZ/+Ol3ZxWz00e
         tTkSpF3bk60OuQvaTBwOLT/lFKLVt8DUX8i3rvjUQhPdDms3Ta46zqs/OkIAnoj0wnOI
         CaON8UD6OSSJeue789Tp2ZdvpxN6gYYcP6Z7ouDZIzPyZjSLsCEqvhJL/vVVsKFLn4en
         Y8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F2maXO1cteux1obZPDgFnfhF7yGXljFYr2kiqmnP9sg=;
        b=8Ko4wwG+1sdYO/JGZEQxLQx+n+ZMQGbJnxOlyauXdc24u1VhsGyk5USg1qDhG1oSaI
         zEDuaUXaihMMTR74gjQytyippjlMSDgUNAwWK9dBiQ2kVK53EVqvaqu+EI5RWS0+MsgC
         tS7A14JEYIEu6AhGvtVgjlPg730fRX9JRNZKCxcmqizZOuO/l9WHcwbd5RY+b8lvynRW
         HtOSmeenu6CAx4BUBm1edyjIa8rL+5fqYY7/gCOyJDLcY2HI4p8/4kaRaT0up2/SzccH
         S1IKl1NFDUNAlw5lBELmrs8tTbZ/8jIAF0VnVflLi8OHtUSWrS/ttMjzu32/zhZeDgnx
         nJQg==
X-Gm-Message-State: AOAM532jZUDaf7ojPqSlj/5IbObu9sVb1NzsrW2UmocmkH0YZsIVR5UZ
        7ihcWIdRzC9aQcKzi7omZivCERsV4CKEZA==
X-Google-Smtp-Source: ABdhPJzYhLoWhsfJ7zhpowYKYzAUbSzYD6qt651/Q9iW1DYNCxiZqf39NZwVXa2dGlqykvtXIizCuA==
X-Received: by 2002:a92:c80e:: with SMTP id v14mr58675iln.57.1631132683290;
        Wed, 08 Sep 2021 13:24:43 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 9sm72551ily.9.2021.09.08.13.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 13:24:42 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix missing mb() before waitqueue_active
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2982e53bcea2274006ed435ee2a77197107d8a29.1631130542.git.asml.silence@gmail.com>
 <bd0b0727-d0ac-7f2a-323d-39411edbe45d@kernel.dk>
 <34219094-7e90-a665-2998-4658f3becdff@gmail.com>
 <8d2a7c4e-67d3-681b-bf54-f0409cff672f@kernel.dk>
 <c6fa008c-2705-90cf-b3ff-31b9b58e323b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1c8641b7-9817-e611-0cc9-d98ff551e13c@kernel.dk>
Date:   Wed, 8 Sep 2021 14:24:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c6fa008c-2705-90cf-b3ff-31b9b58e323b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 2:22 PM, Pavel Begunkov wrote:
> On 9/8/21 9:15 PM, Jens Axboe wrote:
>> On 9/8/21 2:09 PM, Pavel Begunkov wrote:
>>> On 9/8/21 8:57 PM, Jens Axboe wrote:
>>>> On 9/8/21 1:49 PM, Pavel Begunkov wrote:
>>>>> In case of !SQPOLL, io_cqring_ev_posted_iopoll() doesn't provide a
>>>>> memory barrier required by waitqueue_active(&ctx->poll_wait). There is
>>>>> a wq_has_sleeper(), which does smb_mb() inside, but it's called only for
>>>>> SQPOLL.
>>>>
>>>> We can probably get rid of the need to even do so by having the slow
>>>> path (eg someone waiting on cq_wait or poll_wait) a bit more expensive,
>>>> but this should do for now.
>>>
>>> You have probably seen smp_mb__after_spin_unlock() trick [1], easy way
>>> to get rid of it for !IOPOLL. Haven't figured it out for IOPOLL, though
>>>
>>> [1] https://github.com/isilence/linux/commit/bb391b10d0555ba2d55aa8ee0a08dff8701a6a57
>>
>> We can just synchronize the poll_wait() with a spinlock. It's kind of silly,
>> and it's especially silly since I bet nobody does poll(2) on the ring fd for
>> IOPOLL, but...
> 
> fwiw, for the ebpf cat ev_posted() -> smb_mb() for taking ~3-5%.
> And there are non-bpf cases that may benefit from it.
> 
> On my list to publish a refined version of the patch.  

Maybe let's postpone this patch then and see if we can't do better...

-- 
Jens Axboe

