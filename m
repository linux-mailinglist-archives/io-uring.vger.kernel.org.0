Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6DC2F6CE1
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbhANVIl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 16:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbhANVIk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 16:08:40 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C5C0613CF
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 13:08:00 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id h17so5481106wmq.1
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 13:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x/K/xy4S9Ac/2YK3NqY8WEIsTTdB98OO3NN3+VMz3oA=;
        b=Jv+0AUT55zBkefq0IuGtFwYefFG1fsEPg++BRxFvoGRCbiwjUd9L0zN2eWas8R7MPE
         Z3uCpHOxv/OwEGzf5lMYd0acPjSvOEoAsdMIeP8j/HgwuAtY4w6tGbQ8VQUefT044sXM
         U8USWCiXMp8rrwdmhj7nXRMYYXhVGsDLT6xUcrgN4VeVjPgQi8cpMyY7c6VRTO0/2bTM
         3JWdhoZDHHWBO9T8oltTM300W9COgmeN5gjU+V0GgUEQYWSg9YQ+C2hrhhLAjV8ZVN/m
         UHX18Iirw037hY25X/dSwZk//rRWHujLGBuPiI5YpdsrCUqTXQpDMAvcbNV36A8Dg3YP
         QOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=x/K/xy4S9Ac/2YK3NqY8WEIsTTdB98OO3NN3+VMz3oA=;
        b=c8M2u+d9XuScSOh3FCCFwd4GhNQhgyuGkTxdUQYzdggx2LSQpxIuCqtRnAfTdCbwda
         byp5MED4qq5w8ky2uU7lXkXUdv5zkG9G4CbTD9zwqxPvkF85cflVITFvMhyO6mHoKW6z
         VbI1W4JZUurgNYn+pVM+HvSAqBOmdR7xCVVw6blYa5uhbQNohfO282axJ/Y/8+Rg0upH
         VBa5YyePe0dlJ7EKAw2uCDMcWEerq0g8jUbUAvd3fPRkl/LYx22Q5WkmF3qSSAHLxKPC
         WbgfWcz5Usg1MV1gqlJwuzI7Pqg4vyIwq9buOzzKFM2Z2WKzKGqphMNZ1EAI8bb79aah
         N/Yg==
X-Gm-Message-State: AOAM533IGMMNaMTEtmSCkfSOfPHzvl5bDhO0oDOo/cXjYnwFJ28OnFnl
        LdT1q28KcWgC10OprWTsqdSPs2OzOcVNqw==
X-Google-Smtp-Source: ABdhPJwJcsOxmagcA58Gd8VV6jxuFe8Z7N2cWNnfjhPiB61KsjbIdIXjs7wnCquKTDrGBCS8Eqdg6g==
X-Received: by 2002:a1c:b78a:: with SMTP id h132mr5540146wmf.141.1610658478688;
        Thu, 14 Jan 2021 13:07:58 -0800 (PST)
Received: from [192.168.8.122] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id 94sm13462086wrq.22.2021.01.14.13.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:07:58 -0800 (PST)
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
 <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
 <20210108155726.GA8655@marcelo-debian.domain>
 <257c0977-2546-adeb-5e04-6b41ced792c7@gmail.com>
 <20210114004655.GA115522@marcelo-debian.domain>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <234af81b-2764-3e9e-6fb1-770877135ccc@gmail.com>
Date:   Thu, 14 Jan 2021 21:04:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210114004655.GA115522@marcelo-debian.domain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/01/2021 00:46, Marcelo Diop-Gonzalez wrote:
> On Tue, Jan 12, 2021 at 08:47:11PM +0000, Pavel Begunkov wrote:
>> On 08/01/2021 15:57, Marcelo Diop-Gonzalez wrote:
>>> On Sat, Jan 02, 2021 at 08:26:26PM +0000, Pavel Begunkov wrote:
>>>> On 02/01/2021 19:54, Pavel Begunkov wrote:
>>>>> On 19/12/2020 19:15, Marcelo Diop-Gonzalez wrote:
>>>>>> Right now io_flush_timeouts() checks if the current number of events
>>>>>> is equal to ->timeout.target_seq, but this will miss some timeouts if
>>>>>> there have been more than 1 event added since the last time they were
>>>>>> flushed (possible in io_submit_flush_completions(), for example). Fix
>>>>>> it by recording the starting value of ->cached_cq_overflow -
>>>>>> ->cq_timeouts instead of the target value, so that we can safely
>>>>>> (without overflow problems) compare the number of events that have
>>>>>> happened with the number of events needed to trigger the timeout.
>>>>
>>>> https://www.spinics.net/lists/kernel/msg3475160.html
>>>>
>>>> The idea was to replace u32 cached_cq_tail with u64 while keeping
>>>> timeout offsets u32. Assuming that we won't ever hit ~2^62 inflight
>>>> requests, complete all requests falling into some large enough window
>>>> behind that u64 cached_cq_tail.
>>>>
>>>> simplifying:
>>>>
>>>> i64 d = target_off - ctx->u64_cq_tail
>>>> if (d <= 0 && d > -2^32)
>>>> 	complete_it()
>>>>
>>>> Not fond  of it, but at least worked at that time. You can try out
>>>> this approach if you want, but would be perfect if you would find
>>>> something more elegant :)
>>>>
>>>
>>> What do you think about something like this? I think it's not totally
>>> correct because it relies on having ->completion_lock in io_timeout() so
>>> that ->cq_last_tm_flushed is updated, but in case of IORING_SETUP_IOPOLL,
>>> io_iopoll_complete() doesn't take that lock, and ->uring_lock will not
>>> be held if io_timeout() is called from io_wq_submit_work(), but maybe
>>> could still be worth it since that was already possibly a problem?
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index cb57e0360fcb..50984709879c 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -353,6 +353,7 @@ struct io_ring_ctx {
>>>  		unsigned		cq_entries;
>>>  		unsigned		cq_mask;
>>>  		atomic_t		cq_timeouts;
>>> +		unsigned		cq_last_tm_flush;
>>
>> It looks like that "last flush" is a good direction.
>> I think there can be problems at extremes like completing 2^32
>> requests at once, but should be ok in practice. Anyway better
>> than it's now.
>>
>> What about the first patch about overflows and cq_timeouts? I
>> assume that problem is still there, isn't it?
>>
>> See comments below, but if it passes liburing tests, please send
>> a patch.
>>
>>>  		unsigned long		cq_check_overflow;
>>>  		struct wait_queue_head	cq_wait;
>>>  		struct fasync_struct	*cq_fasync;
>>> @@ -1633,19 +1634,26 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
>>>  
>>>  static void io_flush_timeouts(struct io_ring_ctx *ctx)
>>>  {
>>> +	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
>>> +
>>
>> a nit, 
>>
>> if (list_empty()) return; + do {} while();
> 
> Ah btw, so then we would have to add ->last_flush = seq in
> io_timeout() too? I think that should be correct but just wanna make
> sure that's what you meant.  Because otherwise if list_empty() is true
> for a while without updating ->last_flush then there could be
> problems. Like for example if there are no timeouts for a while, and
> seq == 2^32-2, then we add a timeout with off == 4. If last_flush is
> still 0 then target-last_flush == 2, but seq - last_flush == 2^32-2

You've just answered your question :) You need to update it somehow,
either unconditionally in commit, or in io_timeout(), or anyhow else.

btw, I like your idea to do it in io_timeout(), because it adds a
timeout anyway, so makes that list_empty() fails and kind of
automatically pushes all that tracking.

-- 
Pavel Begunkov
