Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EBF2A887B
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 22:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgKEVAr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 16:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEVAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 16:00:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF776C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 13:00:46 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id h62so2934128wme.3
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 13:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xX9BClt51HdUsyVLrPcexPjtfElifdOIrrI2sd8swHA=;
        b=niU7Olc2c62tKwFgEeEIbSZhwDhUmfS02bpVpUQNnxUfPfSaY/NYD8vHvRjlqgUsu7
         3xZzwep6egsIHjjxRSs5QjWr1SU0eGaf+dnVEg/zGBg0N+8UDtk0KUOYd2kAbG9Kc5VJ
         yITq64UzT9oGguZx1JLmo1YCcG0kduEydAi2HWjtInNnyVvcCpphwbpoRCapGSpu4wVr
         hZvq0OXSihDiNkrMU94KctC6QKwg77OlTIYMdjsW2NPiPnhF8mx4EQHr3JttT7bfDDwj
         KJoAnOhvhCeBLGzMwNnGlZqZG8qZNpoFnsEIaVyAQsQTTMg7olhGUOSHURVlBwlEDLlF
         HazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xX9BClt51HdUsyVLrPcexPjtfElifdOIrrI2sd8swHA=;
        b=WIvKQbqZg4N9TeB6udEa8wLVcEpPezOtHQWbNSP62c2+ukPWzqx3+lZgtB8pFtEY+j
         hVaSLoSpXcOZPJmh8UUxTsO67au5bIvHDERWL3G3c80yzzVLTXDbHoiHh2gwL8OkVzmj
         SdfZkjmRRksCjk9eRgBtXh/NJOiLxXs9m6n+EBQQNtFE9Ej54t9kBYVW7owxTnrGjfbj
         PTmj5GKkA3zmEpEObS71UwKzCQwd4Zc9CGvREvIQx6AJPYgH+p8kSRFyEiWR3PEuJcv6
         q4UL45s/YXU/Tx8ovREGGoxhcvck8XQ5c8y4Bp2LLHEwzRHOzMI3QMLvjHQe6k7DuUen
         3gSw==
X-Gm-Message-State: AOAM531wJQDDxmcNn/JUrSRD7LVmZ1ujhnyp96yzETI3WcbZ7PnNp1rx
        DdiuZSXytbZoBCYQG3Lako+QGetUan8=
X-Google-Smtp-Source: ABdhPJxVBo2WvXWQTnJfSW1z0Fqcq7TsVT5WM0tb1wY5Rm2P14K25t5OIHF2pg8wrKGYxsLYQPbBfA==
X-Received: by 2002:a1c:4c05:: with SMTP id z5mr4621280wmf.122.1604610045500;
        Thu, 05 Nov 2020 13:00:45 -0800 (PST)
Received: from [192.168.1.47] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id t2sm4633462wrq.56.2020.11.05.13.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 13:00:44 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>,
        Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
 <361ab9fb-a67b-5579-3e7b-2a09db6df924@kernel.dk>
 <9b52b4b1-a243-4dc0-99ce-d6596ca38a58@gmail.com>
 <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <ae71b04d-b490-7055-900b-ebdbe389c744@gmail.com>
Date:   Thu, 5 Nov 2020 20:57:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <266e0d85-42ed-e0f8-3f0b-84bcda0af912@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/11/2020 20:49, Jens Axboe wrote:
> On 11/5/20 1:35 PM, Pavel Begunkov wrote:
>> On 05/11/2020 20:26, Jens Axboe wrote:
>>> On 11/5/20 1:04 PM, Pavel Begunkov wrote:
>>>> On 05/11/2020 19:37, Jens Axboe wrote:
>>>>> On 11/5/20 7:55 AM, Pavel Begunkov wrote:
>>>>>> On 05/11/2020 14:22, Pavel Begunkov wrote:
>>>>>>> On 05/11/2020 12:36, Dmitry Kadashev wrote:
>>>>>> Hah, basically filename_parentat() returns back the passed in filename if not
>>>>>> an error, so @oldname and @from are aliased, then in the end for retry path
>>>>>> it does.
>>>>>>
>>>>>> ```
>>>>>> put(from);
>>>>>> goto retry;
>>>>>> ```
>>>>>>
>>>>>> And continues to use oldname. The same for to/newname.
>>>>>> Looks buggy to me, good catch!
>>>>>
>>>>> How about we just cleanup the return path? We should only put these names
>>>>> when we're done, not for the retry path. Something ala the below - untested,
>>>>> I'll double check, test, and see if it's sane.
>>>>
>>>> Retry should work with a comment below because it uses @oldname
>>>> knowing that it aliases to @from, which still have a refcount, but I
>>>> don't like this implicit ref passing. If someone would change
>>>> filename_parentat() to return a new filename, that would be a nasty
>>>> bug.
>>>
>>> Not a huge fan of how that works either, but I'm not in this to rewrite
>>> namei.c...
>>
>> There are 6 call sites including do_renameat2(), a separate patch would
>> change just ~15-30 lines, doesn't seem like a big rewrite.
> 
> It just seems like an utterly pointless exercise to me, something you'd
> go through IFF you're changing filename_parentat() to return a _new_
> entry instead of just the same one. And given that this isn't the only
> callsite, there's precedence there for it working like that. I'd
> essentially just be writing useless code.
> 
> I can add a comment about it, but again, there are 6 other call sites.

Ok, but that's how things get broken. There is one more idea then,
instead of keeping both oldname and from, just have from. May make
the whole thing easier.

int do_renameat2(struct filename *from)
{
...
retry:
    from = filename_parentat(from, ...);
...
exit:
    if (!IS_ERR(from))
        putname(from);
}


-- 
Pavel Begunkov
