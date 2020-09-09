Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD626328F
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 18:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730425AbgIIQIU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 12:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730777AbgIIQH4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 12:07:56 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9547FC061757
        for <io-uring@vger.kernel.org>; Wed,  9 Sep 2020 09:07:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t16so2806696ilf.13
        for <io-uring@vger.kernel.org>; Wed, 09 Sep 2020 09:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=G1D1Vpt/KOtbDnArb1y4gAgtJ0Ksq0SkcOUoEVTGqiE=;
        b=vz6kb1uVsNcqi3fE8n4AzTVpqFDoL9h7zBfPWT2OuDxPEEWfJ1ZWisRPGrZgM9VsYl
         XlQHUxvYta1exWWDei5EC97gNCZ5pzBqCTKXGoY2CYBUbVJkbnokwePV6zIge2mV924M
         mwCYLzU/oXo1mMeKSTTXKTEKVbnUla5H+z4n4V6d0AmLkS+bGeXJlLUVeoQHN1QQEyqR
         HzrKa9jQx1iSQvoHlpCoWrorDt0iKqxsY8DgUJ8mT1CNhGTGCq8LatTu+OaSZyd2X0pz
         ZiwKTJ+nCI9660VmbnjhKPvHIaDqQMff/LohLBu1YaNKO9Em/eHCQMHTDM2NuKn35L5/
         +37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G1D1Vpt/KOtbDnArb1y4gAgtJ0Ksq0SkcOUoEVTGqiE=;
        b=n5bEJoC1lVlJRkPRcMA9lKgmWtGLm4RjI5ec7GNg98uxa1u8FRz6nzXW7xu6JTmAll
         HNzIQxz/Y78m2h0jS5fNQQy82BDPGBQ5imgDaKI3jowZzMhyBhFY+esAmF5ycYmme6vV
         nPNL61aO4rC+D9yzb19d411LdT68J6bbNB8On5rxUn6CNkcjUqfoawjU4NkVhg8hba19
         nDQHIYsBtGU8iDlh421JSYwwG5/rB/315KMDxJumZGX9NQfQyrwWHn0ck+AIwefg0kjD
         BGaZSWh78POonZr7in4SxWEAttUcNU2mUud5n/ff4/irj55cblrp68r9Ht72r/I9JAbv
         bklA==
X-Gm-Message-State: AOAM5339uA0I5iUvJuQ9+CLh9asSAyhFVGVh3ly6VcyiZIFLoay9DlIl
        ynsV23WoJ1LQLCQIkENHsNOLwlLgOmF0Ih3C
X-Google-Smtp-Source: ABdhPJw/6MSFE5MxTyjA4MubRpZcep7ID5sKnRFe9BBh2ZQKsX6lYtVHWDVm6K3kc3V34zeCj28rXw==
X-Received: by 2002:a92:4f:: with SMTP id 76mr4115839ila.11.1599667661238;
        Wed, 09 Sep 2020 09:07:41 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i73sm1531379ild.61.2020.09.09.09.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 09:07:40 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
 <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
 <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
 <801ed334-54ea-bdee-4d81-34b7e358b506@gmail.com>
 <370c055e-fa8d-0b80-bd34-ba3ba9bc6b37@kernel.dk>
 <74c2802e-788e-d6b2-3ee6-5ef67950dc94@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b52f5068-8e03-22a9-cf7d-c3e77fc8282f@kernel.dk>
Date:   Wed, 9 Sep 2020 10:07:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <74c2802e-788e-d6b2-3ee6-5ef67950dc94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/20 9:48 AM, Pavel Begunkov wrote:
> On 09/09/2020 16:10, Jens Axboe wrote:
>> On 9/9/20 1:09 AM, Pavel Begunkov wrote:
>>> On 09/09/2020 01:54, Jens Axboe wrote:
>>>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>>>
>>>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>>>
>>>>>> And it looks strange that the following snippet will effectively disable
>>>>>> such requests.
>>>>>>
>>>>>> fd = dup(ring_fd)
>>>>>> close(ring_fd)
>>>>>> ring_fd = fd
>>>>>
>>>>> Not disagreeing with that, I think my initial posting made it clear
>>>>> it was a hack. Just piled it in there for easier testing in terms
>>>>> of functionality.
>>>>>
>>>>> But the next question is how to do this right...> 
>>>> Looking at this a bit more, and I don't necessarily think there's a
>>>> better option. If you dup+close, then it just won't work. We have no
>>>> way of knowing if the 'fd' changed, but we can detect if it was closed
>>>> and then we'll end up just EBADF'ing the requests.
>>>>
>>>> So right now the answer is that we can support this just fine with
>>>> SQPOLL, but you better not dup and close the original fd. Which is not
>>>> ideal, but better than NOT being able to support it.
>>>>
>>>> Only other option I see is to to provide an io_uring_register()
>>>> command to update the fd/file associated with it. Which may be useful,
>>>> it allows a process to indeed to this, if it absolutely has to.
>>>
>>> Let's put aside such dirty hacks, at least until someone actually
>>> needs it. Ideally, for many reasons I'd prefer to get rid of
>>
>> BUt it is actually needed, otherwise we're even more in a limbo state of
>> "SQPOLL works for most things now, just not all". And this isn't that
>> hard to make right - on the flush() side, we just need to park/stall the
> 
> I understand that it isn't hard, but I just don't want to expose it to
> the userspace, a) because it's a userspace API, so couldn't probably be
> killed in the future, b) works around kernel's problems, and so
> shouldn't really be exposed to the userspace in normal circumstances.
> 
> And it's not generic enough because of a possible "many fds -> single
> file" mapping, and there will be a lot of questions and problems.
> 
> e.g. if a process shares a io_uring with another process, then
> dup()+close() would require not only this hook but also additional
> inter-process synchronisation. And so on.

I think you're blowing this out of proportion. Just to restate the
goal, but it's to have SQPOLL be as useful as the other modes. One of
those things is making non-registered files work. For some use cases,
registered files is fine, for others it's basically a non-starter.

With that out of the way, the included patch handles the "close ring
fd case". You're talking about the dup or receive case, or anything
that doesn't close an existing ring. And yes, that won't work as-is,
because we know have multiple fds for that particular ring. That boils
the case down to "we're now using this fd for the ring", and the only
requirement here would be to ensure you do a io_uring_enter() if you
decide to swap fds or use a new fd. Only caveat here is that we can't
make it automatic like we can for the "old fd gets closed" case, so
the app would absolutely have to ensure it enters the kernel if it
uses a new fd.

Not really a huge deal imho in terms of API, especially since this
is into the realm of "nobody probably ever does this, or if they do,
then this requirement isn't really a problem".

>> thread and clear the ring_fd/ring_file, then mark the ring as needing a
>> queue enter. On the queue enter, we re-set the fd/file if they're NULL,
>> unpark/unstall the thread. That's it. I'll write this up and test it.
>>
>>> fcheck(ctx->ring_fd) in favour of synchronisation in io_grab_files(),
>>> but I wish I knew how.
>>
>> That'd be nice, and apply equally to all cases as the SQPOLL case isn't
>> special at all anymore.
> 
> I miss the whole story, have you asked fs guys about the problem?
> Or is it known that nothing would work?

I haven't looked into it.

-- 
Jens Axboe

