Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2369014B29A
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 11:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgA1Kab (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 05:30:31 -0500
Received: from mail-lj1-f172.google.com ([209.85.208.172]:38381 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgA1Kab (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 05:30:31 -0500
Received: by mail-lj1-f172.google.com with SMTP id w1so14159545ljh.5
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 02:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hxiqWym04d6LYamKHhC4it337Vt9BRDXdfS6Nb71miA=;
        b=iNWF/FSlgaXQ7i9kyiDKxQXjPlXBZQ5tjAjrybC+3OSZsqmh22vboY2EYuW3SGzfDR
         6HDnpxFpGdSxBXBRm/pEIYqS/4J7mXQuLoItUbBz9Js4wgE1CbeoALa+3bBMHBPzEGy1
         sDDIoA1CiMG32ZlHwPo8uE+1pgsL2580Y+E7NwQClboqmGHlohIgYyJ9FQSNkICrNtEU
         Px9hkIv5rPI37v3HAcZ8FSkgYPQR4G6WLV7pbj2VCwAdpmTuB/wmNA/uXK4O5jjfF5jU
         ruK+Tq1Qs+xo72fVbIEIH8nLAKz1omTf0BFVTwiKjPWwBUhxu2PnGLpf54qNhD3rNPKE
         5m4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hxiqWym04d6LYamKHhC4it337Vt9BRDXdfS6Nb71miA=;
        b=qCvBpWs451OFesWDxuunWzmzjYLEd/ixwVuJmTqDBsyqE2HQBfF5qtWzynV7yLofEU
         UbLgMUyqtiWOA6UieS16dTC/fMVZ6e/viO9pc6exJMJ5AvnxwuC92hRH/ZgRMA8Pv5x1
         QhOI9aCLccbe/s2oWmy1MU6eMoSxKL8D+OAqgyfIRNQyojZrWoWc6rayUNhgiLGMbPIv
         yjpXsnUiJRP2Rc9ilaP22YA+xH+h19MZDx7tvcR/s1WebURmTRIT7l4Nd5U33S73oxSN
         k4gc0B1FDGt1GXy1V/SJVV4DPvUKeMVd0bUoVmEQkBvPez8lXvozw3X5llN1d+X9SZpi
         YG/g==
X-Gm-Message-State: APjAAAWM8tEJ/AoHqIBqc4mQMuxPg8JYAp+QUrpekAdzmIL/QeTU9HYN
        zx/GPX1UrbV6/Q3LlTVc/s9qqOU7fmc=
X-Google-Smtp-Source: APXvYqwCSrysRbRXu0iJ7HEhsgst46K/jMZ20CwhbfFPW6OKDjo36uL0ecIIZM1twdxwYbM67zi/rQ==
X-Received: by 2002:a2e:90f:: with SMTP id 15mr8736147ljj.120.1580207428291;
        Tue, 28 Jan 2020 02:30:28 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id g21sm631388ljj.53.2020.01.28.02.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 02:30:27 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
 <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
 <c432d4e1-9cf0-d342-3d87-84bd731e07f3@kernel.dk>
 <18d3f936-c8d0-9bbb-6e9d-4c9ec579cfa4@kernel.dk>
 <d2db974d-cb40-36eb-c13d-e0c3713e7573@gmail.com>
 <fad41959-e8e6-ff2b-47c3-528edc6009df@kernel.dk>
 <adcb5842-34c8-a433-6ee3-b160fcb24473@gmail.com>
 <965e6e04-aa4c-c179-06f2-37f0527fb5e1@kernel.dk>
 <e8219de1-5179-4a3b-68cc-d7dbf5c1fa20@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a8582809-6bf1-009a-3205-231b33ce82ed@gmail.com>
Date:   Tue, 28 Jan 2020 13:30:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e8219de1-5179-4a3b-68cc-d7dbf5c1fa20@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/2020 1:01 PM, Stefan Metzmacher wrote:
>>>>>>> OK, so how about this:
>>>>>>>
>>>>>>> - We use the 'fd' as the lookup key. This makes it easy since we can
>>>>>>>   just check if it's a io_uring instance or not, we don't need to do any
>>>>>>>   tracking on the side. It also means that the application asking for
>>>>>>>   sharing must already have some relationship to the process that
>>>>>>>   created the ring.
>>>>>>>
>>>>>>> - mm/creds must be transferred through the work item. Any SQE done on
>>>>>>>   behalf of io_uring_enter() directly already has that, if punted we
>>>>>>>   must pass the creds and mm. This means we break the static setup of
>>>>>>>   io_wq->mm/creds. It also means that we probably have to add that to
>>>>>>>   io_wq_work, which kind of sucks, but...
>>>>>> It'd fix Stefan's worry too.
>>>>>>
>>>>>>> I think with that we have a decent setup, that's also safe. I've dropped
>>>>>>> the sharing patches for now, from the 5.6 tree.
>>>>>>
>>>>>> So one concern might be SQPOLL, it'll have to use the ctx creds and mm
>>>>>> as usual. I guess that is ok.
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-wq
>>
>> Top patch there is the mm/creds passing. I kind of like it even if it
>> means we're growing io_wq_worker (and subsequently io_kiocb) by 16
>> bytes, as it means we can be more flexible. This solves it for this use
>> case, but also the case that Stefan was worried about.
> 
> Ok, that means that ctx->creds is only used in the IORING_SETUP_SQPOLL
> case and there it's used for all requests as get_current_cred() is the
> same as ctx->creds from within io_sq_thread(), correct?

Right

> And in all other cases get_current_cred() is used at io_uring_enter() time.

Exactly

> That's good in order to make the behavior consistent again and prevents
> potential random security problems.

BTW, there also can be problems with registered resources. E.g. for
buffers io_uring can get_user_pages() of one process, and then use the
pages from another process by passing a buffer index. This is not as
bad, however.

> 
> BTW: you need to revert/drop 44d282796f81eb1debc1d7cb53245b4cb3214cb5
> in that branch. Or just rebase on v5.5 final?
> 
> Thanks!
> metze
> 

-- 
Pavel Begunkov
