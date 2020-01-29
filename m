Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDCC14D210
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 21:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgA2Us5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 15:48:57 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:45092 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgA2Us4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 15:48:56 -0500
Received: by mail-io1-f45.google.com with SMTP id i11so1282074ioi.12
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 12:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LpLmv5LotsV2jApGd2L1Gsv9Bc0H6Db23oVzIURluk0=;
        b=KHkvheqK0Kj+dntNFoBdbiaTctZDxuC47LwDU/LC/FoHemCmVrwuFe2PcjXru7gBn5
         22c3iNe++Jyu95P91wlU8HaC8gnHfxp7U2jkUvz+iEKnWjp6v1z0j8kAqKhTsbsZunGx
         68QVLGkFypa+xs7ml0kb8N5FX6ZvboN85Se1ihqZT1g30Qbr0Ucngjplbkhr0wpo37Ew
         NFj0MH1IIvhsxu3uh1ajEhS4MO0ih1KEk7F5UlK7s6KbGflbRICqHabvFI80qKP+g+Mp
         eRVtAKkijLJVjXPEstXnY2678d3Tb7/YggBhwRQstDhpq7oqOVEfrjI7Yskq9r7hXO+e
         tFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LpLmv5LotsV2jApGd2L1Gsv9Bc0H6Db23oVzIURluk0=;
        b=HzOVqgtFfnaarsXijgHiQJLWecIFNACq3ochU5702mblvqFEcaqYvoxE4yOfbyIlZL
         fi7w84iw7c90Ak/gayfFEbHYkm4VJnPHUxhxeUOGk+xRT0nCHXF4zkdoPjv55jopH08i
         gGfzq7ovIwsQbEhye8dzJ2aa6RARBVzcCaXklY7wX/o4s6mdAKCgFNvomweK1I8Fl6+s
         Kky9kmDJkonrQNkfJDNFySymoZU8mZ9drxwGVPxyinFSOiiT7Z4UvlP7sgR9SKGasjsO
         1zCKKCXp56w0oofnSJto3qEscBlPegCn9lvNsWXQV4wVI0jsqR/79+nX5j2hDHtUYfUc
         AIPg==
X-Gm-Message-State: APjAAAV+o66WA1igOKsYos/23QaBJ5ry7KmORNAcvsInFVPwwbbnFKFG
        I82mDslYx391dmZSqqQG6wFAog==
X-Google-Smtp-Source: APXvYqzYSZ2jsZ7y0FPiXoTP83S2ZCoa6ypWxOR6wtdMeLvvbgurMZGC7UtOEWhYAFcRwTbHHP4LkQ==
X-Received: by 2002:a02:8282:: with SMTP id t2mr868683jag.23.1580330935610;
        Wed, 29 Jan 2020 12:48:55 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v63sm1070699ill.72.2020.01.29.12.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 12:48:55 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
 <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
 <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
 <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
 <9aef3b3b-7e71-f7f1-b366-2517b4d52719@kernel.dk>
 <b3382961-8288-ec09-9019-5248f87dd86c@kernel.dk>
 <2d20bbcf-c04a-a02d-2850-cc7cc5a439f7@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca3b1ff4-baa9-f061-feaf-29b0b47fb6bb@kernel.dk>
Date:   Wed, 29 Jan 2020 13:48:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2d20bbcf-c04a-a02d-2850-cc7cc5a439f7@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 1:09 PM, Stefan Metzmacher wrote:
> Am 29.01.20 um 18:42 schrieb Jens Axboe:
>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>> On 1/29/20 7:23 AM, Pavel Begunkov wrote:
>>>>>>> The override_creds(personality_creds) has changed current->cred
>>>>>>> and get_current_cred() will just pick it up as in the default case.
>>>>>>>
>>>>>>> This would make the patch much simpler and allows put_cred() to be
>>>>>>> in io_put_work() instead of __io_req_aux_free() as explained above.
>>>>>>>
>>>>>>
>>>>>> It's one extra get_current_cred(). I'd prefer to find another way to
>>>>>> clean this up.
>>>>>
>>>>> As far as I can see it avoids a get_cred() in the IOSQE_PERSONALITY case
>>>>> and the if (!req->work.creds) for both cases.
>>>>
>>>> Great, that you turned attention to that! override_creds() is already
>>>> grabbing a ref, so it shouldn't call get_cred() there.
>>>> So, that's a bug.
>>>
>>> It's not though - one is dropped in that function, the other when the
>>> request is freed. So we do need two references to it. With the proposed
>>> change to keep the override_creds() variable local for that spot we
>>> don't, and the get_cred() can then go.
>>>
>>>> It could be I'm wrong with the statement above, need to recheck all this
>>>> code to be sure.
>>>
>>> I think you are :-)
>>>
>>>> BTW, io_req_defer_prep() may be called twice for a req, so you will
>>>> reassign it without putting a ref. It's safer to leave NULL checks. At
>>>> least, until I've done reworking and fixing preparation paths.
>>>
>>> Agree, the NULL checks are safer and we should keep them.
>>>
>>> Going through the rest of this thread, I'm making the following changes:
>>>
>>> - ID must be > 0. I like that change, as we don't need an sqe flag to
>>>   select personality then, and it also makes it obvious that id == 0 is
>>>   just using current creds.
>>>
>>> - Fixed the missing put_cred() in the teardown
>>>
>>> - Use a local variable in io_submit_sqe() instead of assigning the
>>>   creds to req->work.creds there
>>>
>>> - Use cyclic idr allocation
>>>
>>> I'm going to fold in as appropriate. If there are fixes needed on top of
>>> that, let's do them separately.
>>
>> In particular, would love a patch that only assigns req->work.creds if
>> we do go async, so we can leave the put_cred() in io_put_work()
>> instead of needing it in __io_req_aux_free().
> 
> I made some improvements here:
> 
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-5.6/io_uring-vfs
> 
> Feel free to squash
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=ce8812c9b935467bb08ed4d528dd92b9f67e221c
> into
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=22021e95e73d4658a6c834a3276886e127ab8425
> and add my review to it.

Looks good to me, folded. Thanks!

> If you're confident that it's safe you can
> call io_req_work_drop_env() also in io_put_work(),

Let's look into that later, want to flush this out sooner rather than
later...


-- 
Jens Axboe

