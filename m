Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281BD16F23D
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 22:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgBYVwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 16:52:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38676 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgBYVwy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 16:52:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id e8so498900wrm.5
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 13:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mo5AP2LUD0j0MKXBnByxSGCTPxTDnRA7W6fufiR8Ggw=;
        b=QaDqqWGe+G6P5k9sc8T8vg7VAlImAeMIditoZcbqMpHvDTG9+QKxoDd8B+SJ95QB5k
         oCGismNrKpXOCzRUDNLdc317feZjRAbSvBQDLsaem3icbgmB95m+ABPXULfQmc5D+aHR
         oGhK1P9xmpqLGyu2bPgG+A8uiAISF1uOx9uLI60PVWaN3Ax21Z3FvOsG48xXLgdrKlW/
         vxaJZ9ZrEB0nTWzUFGciQwH3+elLAysrjQLqc0xRR66235nll3mTTe9UCBJGgJkgkppM
         Uhi5+AKcY1tgsh8vgp0qR1QG6QRbXjfrdz7oRSryyxR5PFqvMZtR+pxWmTfgCVOROjxH
         545Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mo5AP2LUD0j0MKXBnByxSGCTPxTDnRA7W6fufiR8Ggw=;
        b=FJCLKP4UnVJ8MTrHDluDJFKG3RqWp5kYW1KzXsAtRVkI2yNgwlZKWvdi8Hzaliv17Q
         IBUGTu12amEehQbIbmDcLVm86bYRxEdmlxRCrNqCYJTz7HIbCgnNHqLHxGwb2amEwn7o
         pS6deE6++KFJBV7V0ShvucsddMOx4y9Riewo/qwXiyzauubqXxjl/R4cXLs+qz7bS6o4
         xQWLQAOPMAUJulAc4QPMsf+QTdtaKQMDivdnPrS28tEr6NoTeXPbAD1lZgdqDhZx0ugO
         WKntLDhDCFV3226sbX0QvxnQz343RzdGFJui2pq8IlXNWCPFvTgROYsBP2MkjyYO3g/N
         VRBA==
X-Gm-Message-State: APjAAAUFSjnOlBEnqR2ncvgIWcAHCFOQK8hkHNBFjAYR0Qntaa9GbWnL
        5XZuQ0qKxGsf7H0+QDX2gF+SrZlE
X-Google-Smtp-Source: APXvYqzLo5LbaY7Rhs1HggwMXgMT0wVqtR4sj0prp9cRhFz/jkW6l7q55urUWVKv3OnEKdIdIs/PQA==
X-Received: by 2002:a5d:4dce:: with SMTP id f14mr1141251wru.65.1582667571915;
        Tue, 25 Feb 2020 13:52:51 -0800 (PST)
Received: from [192.168.43.62] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id e8sm310449wru.7.2020.02.25.13.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:52:51 -0800 (PST)
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <f5cb2e96-b30f-eec9-7a0b-68bdfcb0b8e2@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <6c476531-7ba8-1c2a-66c3-029ad399f0b1@gmail.com>
Date:   Wed, 26 Feb 2020 00:52:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f5cb2e96-b30f-eec9-7a0b-68bdfcb0b8e2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/02/2020 00:45, Pavel Begunkov wrote:
> On 26/02/2020 00:25, Jens Axboe wrote:
>> On 2/25/20 2:22 PM, Pavel Begunkov wrote:
>>> On 25/02/2020 23:27, Jens Axboe wrote:
>>>> If work completes inline, then we should pick up a dependent link item
>>>> in __io_queue_sqe() as well. If we don't do so, we're forced to go async
>>>> with that item, which is suboptimal.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> ---
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index ffd9bfa84d86..160cf1b0f478 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>>>>  		} while (1);
>>>>  	}
>>>>  
>>>> -	/* drop submission reference */
>>>> -	io_put_req(req);
>>>> +	/*
>>>> +	 * Drop submission reference. In case the handler already dropped the
>>>> +	 * completion reference, then it didn't pick up any potential link
>>>> +	 * work. If 'nxt' isn't set, try and do that here.
>>>> +	 */
>>>> +	if (nxt)
>>>
>>> It can't even get here, because of the submission ref, isn't it? would the
>>> following do?
>>>
>>> -	io_put_req(req);
>>> +	io_put_req_find_next(req, &nxt);
>>
>> I don't think it can, let me make that change. And test.
>>
>>> BTW, as I mentioned before, it appears to me, we don't even need completion ref
>>> as it always pinned by the submission ref. I'll resurrect the patches doing
>>> that, but after your poll work will land.
>>
>> We absolutely do need two references, unfortunately. Otherwise we could complete
>> the io_kiocb deep down the stack through the callback.
> 
> And I need your knowledge here to not make mistakes :)
> I remember the conversation about the necessity of submission ref, that's to
> make sure it won't be killed in the middle of block layer, etc. But what about
> removing the completion ref then?
> 
> E.g. io_read(), as I see all its work is bound by lifetime of io_read() call,
> so it's basically synchronous from the caller perspective. In other words, it
> can't complete req after it returned from io_read(). And that would mean it's
> save to have only submission ref after dealing with poll and other edge cases.
> 
> Do I miss something?

Hmm, just started to question myself, whether handlers can be not as synchronous
as described...

-- 
Pavel Begunkov
