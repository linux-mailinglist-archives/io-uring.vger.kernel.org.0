Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439A03B104F
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 01:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhFVXFo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 19:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhFVXFo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 19:05:44 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC54C061574;
        Tue, 22 Jun 2021 16:03:27 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a11so425124wrt.13;
        Tue, 22 Jun 2021 16:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XVYxcHVzt+iAuoqfNZVohTGFnRlGMfbTT5NEuJe+pr8=;
        b=WgEzmwQiDWFMuGYxdip6AR6E/ELKH+rcNOkf6NEqoodXMynYxKBv7TVWMzFm2wzFEB
         6aHyRpgazRiPEedFYYYGGH3pEjpmgvaKsx7NTYmpR5Poa0Ra8RrvCzCHEoLLXoV/8X3w
         OdDvs1sBOMb7+JOC7ibSxAqaqp3ic+pL5VeMPwc4RATQ7ecvDIR4lBcpnKSO9K2C0Pqo
         Vi1dYPH/NpFbcxWwswJvDyh7zXFdPJ+twV6IyqOyvGq2fENPuEGIm79FZtRjzeG33A1Z
         4mvt4eQg3iAR61bhQLDzaChmOk/h+Hmx4ibcl/Hpd6032pHV8MPlENE2Ij2Vi7/6Ka97
         6lEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVYxcHVzt+iAuoqfNZVohTGFnRlGMfbTT5NEuJe+pr8=;
        b=uGQ3PWYhxfSL+BShxPFwe7Vo6dmO1uaRRZ8IGxe15dxV/aJTA/6qlTV3pV7G5Q7Agf
         noKKpOt8HEGqEFTEYUG1X3eJO+dOekMj3EiVVgVKstogh4Fqdq7tuidBhS4Yvenoajwv
         qYGTDNbq19KK9F5o9B9W84VMGN9p5zymkyl2xFSeZxWU/Lgo9cIBmh3W2r+RkMCCgyLY
         v+mjqbmiWTA1jID+9g+nQfw7Zyqz3Mq4Pewu59Ssv31Yt5/xBG1zKk5NqkoAA9ikSLKe
         LCsUvMjpEgfcO75Z07c4o/i06JVcxqyacIhty4PPsO2LNcJvagXDYCg4mxUJtxWzrRCD
         RAGg==
X-Gm-Message-State: AOAM532njhmfBvClNCQT2RZxfvW5IcGgA/xFy6CKBfNn6PEg7ovEbPiL
        fprOvWUeMftPw+WOMDLukkgJk9LoIJZv01vy
X-Google-Smtp-Source: ABdhPJzqetf9JyitNVT8f1LtagVRS71lv34mGeA2VWLlJnKJe5fAleilOdyE3vFgmVq4CSKp9Sjkag==
X-Received: by 2002:adf:cd88:: with SMTP id q8mr7836908wrj.181.1624403005589;
        Tue, 22 Jun 2021 16:03:25 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id x18sm769703wrw.19.2021.06.22.16.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 16:03:25 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
 <60d23218.1c69fb81.79e86.f345SMTPIN_ADDED_MISSING@mx.google.com>
 <dcc24da6-33d6-ce71-8c87-f0ef4e7f8006@gmail.com>
 <b00eb9407276f54e94ec80e6d80af128de97f10c.camel@trillion01.com>
 <169899caad96c3214d6e380ac7686d054eed3b12.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/2 v2] io_uring: Fix race condition when sqp thread goes
 to sleep
Message-ID: <2603ffd4-c318-66ed-9807-173159536f6a@gmail.com>
Date:   Wed, 23 Jun 2021 00:03:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <169899caad96c3214d6e380ac7686d054eed3b12.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 11:42 PM, Olivier Langlois wrote:
> On Tue, 2021-06-22 at 18:37 -0400, Olivier Langlois wrote:
>> On Tue, 2021-06-22 at 21:45 +0100, Pavel Begunkov wrote:
>>> On 6/22/21 7:55 PM, Olivier Langlois wrote:
>>>> If an asynchronous completion happens before the task is
>>>> preparing
>>>> itself to wait and set its state to TASK_INTERRUPTIBLE, the
>>>> completion
>>>> will not wake up the sqp thread.
>>>>
>>>> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>>>> ---
>>>>  fs/io_uring.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index fc8637f591a6..02f789e07d4c 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -6902,7 +6902,7 @@ static int io_sq_thread(void *data)
>>>>                 }
>>>>  
>>>>                 prepare_to_wait(&sqd->wait, &wait,
>>>> TASK_INTERRUPTIBLE);
>>>> -               if (!io_sqd_events_pending(sqd)) {
>>>> +               if (!io_sqd_events_pending(sqd) && !current-
>>>>> task_works) {
>>>
>>> Agree that it should be here, but we also lack a good enough
>>> task_work_run() around, and that may send the task burn CPU
>>> for a while in some cases. Let's do
>>>
>>> if (!io_sqd_events_pending(sqd) && !io_run_task_work())
>>>    ...
>>
>> I can do that if you want but considering that the function is inline
>> and the race condition is a relatively rare occurence, is the cost
>> coming with inline expansion really worth it in this case?
>>>
> On hand, there is the inline expansion concern.
> 
> OTOH, the benefit of going with your suggestion is that completions
> generally precedes new submissions so yes, it might be better that way.
> 
> I'm really unsure about this. I'm just raising the concern and I'll let
> you make the final decision...

It seems it may actually loop infinitely until it gets a signal,
so yes. And even if not, rare stalls are nasty, they will ruin
some 9s of latency and hard to catch.

That part is quite cold anyway, would generate some extra cold
instructions, meh

-- 
Pavel Begunkov
