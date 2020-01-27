Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46CB14AC59
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 00:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgA0XA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 18:00:57 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34256 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA0XA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 18:00:57 -0500
Received: by mail-pj1-f65.google.com with SMTP id f2so150454pjq.1
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 15:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4MOBBVS02V5W2bLmikPqriQqxXuCV0tiwehdq3Ohwx8=;
        b=0GrrG5FKkP7xs3pTyP1q/E+XW6dgmdrot8+pqLLBZjxBOZQYf/3te6PeZHpAE6ZXYy
         RA0lEmkNb244cOF1Xs3hurq63PvqqqujyRcowKqE5AHlZwaKOfzVUgTm35dDKfoMWfOZ
         42jDZ/bAZyPEK/E9mJ1mpP8CqRGhc40AJ+Fe4Z5SOgTxI6cm8q6dqbWLLhGLH3f4HVXL
         UX0Bh/ls+cBuxw6/GkZvLR/oJG2VlvwPGS/v+cG4GyqTDvQmLcXFVJZibLcESX4IO1Aj
         vCiYpaR+muNWg5iDKJ8IlvSIKycPu17mMz+z7UhwW6snOze5kQN27bPkEQwoL9oj4CPp
         YYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4MOBBVS02V5W2bLmikPqriQqxXuCV0tiwehdq3Ohwx8=;
        b=lH8HW0NcetPtZuIfvIgF+2HlheBoyNzRaAkBi9KYxG1FlEuTWkxIfcN36scEGD3V8n
         ywjO8Bg7RoGItM54cVf82+ZTsiAq4dkjQZVHdtjfVgekZAxjSYH5KfHkpfN9cV/YjXuA
         Ti3Bc4Mv62xrDgIP5kCXr6TZQGMWGDykBfq5L6WY/Ojy47hyt87NwfA2Z1xNvsbPUVdO
         v77H00i9b5awICYcnHNKdGBDP/Dl4r5WITO1mwhyNWWBychm97Od+U52386NSOvyB9FX
         JjAgAA5WQxks9qA2MOVSAGNbSsu7+auh7p1sh4QFCLajjb1RZ6NNIcENrKCkeCxhE9Bf
         oo7Q==
X-Gm-Message-State: APjAAAW0ee4D0EbjVgl6aXd2OXBcdlW1hFRt87bFZ8lpiQ7DUmzerxhT
        Azqytnbq5hySbT0Cse0gjtb7kSWEbEQ=
X-Google-Smtp-Source: APXvYqyb9GST/iZ58gUpe2B77k5xjApyRCCP+qAmFL0fgLCOV2x4gLiwU4vmbJ7hKUG5K2jRIQEJ5Q==
X-Received: by 2002:a17:902:34a:: with SMTP id 68mr19127746pld.250.1580166055782;
        Mon, 27 Jan 2020 15:00:55 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a16sm17040412pgb.5.2020.01.27.15.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 15:00:55 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
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
Message-ID: <18d3f936-c8d0-9bbb-6e9d-4c9ec579cfa4@kernel.dk>
Date:   Mon, 27 Jan 2020 16:00:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c432d4e1-9cf0-d342-3d87-84bd731e07f3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 3:40 PM, Jens Axboe wrote:
> On 1/27/20 2:45 PM, Pavel Begunkov wrote:
>> On 27/01/2020 23:33, Jens Axboe wrote:
>>> On 1/27/20 7:07 AM, Pavel Begunkov wrote:
>>>> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>>>>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>>>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> Ok. I can't promise it'll play handy for sharing. Though, you'll be out
>>>>>> of space in struct io_uring_params soon anyway.
>>>>>
>>>>> I'm going to keep what we have for now, as I'm really not imagining a
>>>>> lot more sharing - what else would we share? So let's not over-design
>>>>> anything.
>>>>>
>>>> Fair enough. I prefer a ptr to an extendable struct, that will take the
>>>> last u64, when needed.
>>>>
>>>> However, it's still better to share through file descriptors. It's just
>>>> not secure enough the way it's now.
>>>
>>> Is the file descriptor value really a good choice? We just had some
>>> confusion on ring sharing across forks. Not sure using an fd value
>>> is a sane "key" to use across processes.
>>>
>> As I see it, the problem with @mm is that uring is dead-bound to it.
>> For example, a process can create and send uring (e.g. via socket),
>> and then be killed. And that basically means
>> 1. @mm of the process is locked just because of the sent uring
>> instance.
>> 2. a process may have an io_uring, which bound to @mm of another
>> process, even though the layouts may be completely different.
>>
>> File descriptors are different here, because io_uring doesn't know
>> about them, They are controlled by the userspace (send, dup, fork,
>> etc), and don't sabotage all isolation work done in the kernel. A dire
>> example here is stealing io-wq from within a container, which is
>> trivial with global self-made id. I would love to hear, if I am
>> mistaken somewhere.
>>
>> Is there some better option?
> 
> OK, so how about this:
> 
> - We use the 'fd' as the lookup key. This makes it easy since we can
>   just check if it's a io_uring instance or not, we don't need to do any
>   tracking on the side. It also means that the application asking for
>   sharing must already have some relationship to the process that
>   created the ring.
> 
> - mm/creds must be transferred through the work item. Any SQE done on
>   behalf of io_uring_enter() directly already has that, if punted we
>   must pass the creds and mm. This means we break the static setup of
>   io_wq->mm/creds. It also means that we probably have to add that to
>   io_wq_work, which kind of sucks, but...

It'd fix Stefan's worry too.

> I think with that we have a decent setup, that's also safe. I've dropped
> the sharing patches for now, from the 5.6 tree.

So one concern might be SQPOLL, it'll have to use the ctx creds and mm
as usual. I guess that is ok.

-- 
Jens Axboe

