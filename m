Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1860114CFD0
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 18:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgA2RqV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 12:46:21 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:43543 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgA2RqV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 12:46:21 -0500
Received: by mail-lj1-f169.google.com with SMTP id a13so244189ljm.10;
        Wed, 29 Jan 2020 09:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QS9r6Pw3kjijpdm49BCeHOyhsA9XNtzwCyIFlvRSyMA=;
        b=D37nBQNH5impZ1FUQu16DzoaBYe3rJPpMMnFn99HZRX9UW0t4Mrd1bcrtwe0/KcQAn
         +cwe+VQ1cu66lN4Fvw9sZOITgrNIWmH6zHRjvQJZkpZlLhrzmLlZohn5cSmRYCg6fvjc
         /6I0ZX3OfvEJCUSVb6WveDRs7BkVSuaNbTLcFyqtyUFCj026BvIi/DuZlD0n1gIss3KI
         JDhY3TaxASaScAVqOsEfAXmuSZ4qEeB9GIT6Ui2njBRRL3fMwVQv7b1oDo87JtccNMeA
         dGC85wS+dRCXQe45uZBhy61Chwj+WsoJdOOB2FL7yHSDD65kg+L24jY+9B7Z91fGWv4E
         NLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QS9r6Pw3kjijpdm49BCeHOyhsA9XNtzwCyIFlvRSyMA=;
        b=TeUID1nHpgxZcSsc67Qp0XIRak+WGJUSIFr+qjll2UBM3feXz5qNj8nNbu6zU993Uo
         I9MnrusdZ/J/8au5EhD8EJGlaQvg+udb5sUqPgJ2jfFplZDuJWCE37urfyGASLwp6atz
         KLre0ZCWaJEspc1YjenwSdOMosp2t5fx0PW35sGUbV752RojCu7V0di8NUPa7XgQ8kQi
         NbGdV4l9JoygFpOG4DWVXfsGci/LDzoaRQ8MfYrhVHscmP0wlHLBWotHCVOjfyNFd08f
         +fvUzmih8kHlqGwrX7bKzS64GA0wawyyY2azTyMrRioEolsLyMX/VaGfpJkTCLYhKcHY
         VY5w==
X-Gm-Message-State: APjAAAXWdTr7lppT0sfL4zJ73iiwj3wXnrCHPJU5h8vyqnDb2QVFtSww
        KlWk7HaW4LaD7uqL/WUB99m3FgEl5Fs=
X-Google-Smtp-Source: APXvYqxCiKlvgF9UCVjzi1PsVxKNsiV6KSf8cb1GHAGKwOUPpNLNULgLRDS2kJ+Pc/xrYP0X5atHwQ==
X-Received: by 2002:a2e:3504:: with SMTP id z4mr145824ljz.273.1580319978398;
        Wed, 29 Jan 2020 09:46:18 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id z205sm1366096lfa.52.2020.01.29.09.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 09:46:17 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d27dce12-66b9-9389-871e-714299270809@gmail.com>
Date:   Wed, 29 Jan 2020 20:46:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <9aef3b3b-7e71-f7f1-b366-2517b4d52719@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/2020 8:34 PM, Jens Axboe wrote:
> On 1/29/20 7:23 AM, Pavel Begunkov wrote:
>>>>> The override_creds(personality_creds) has changed current->cred
>>>>> and get_current_cred() will just pick it up as in the default case.
>>>>>
>>>>> This would make the patch much simpler and allows put_cred() to be
>>>>> in io_put_work() instead of __io_req_aux_free() as explained above.
>>>>>
>>>>
>>>> It's one extra get_current_cred(). I'd prefer to find another way to
>>>> clean this up.
>>>
>>> As far as I can see it avoids a get_cred() in the IOSQE_PERSONALITY case
>>> and the if (!req->work.creds) for both cases.
>>
>> Great, that you turned attention to that! override_creds() is already
>> grabbing a ref, so it shouldn't call get_cred() there.
>> So, that's a bug.
> 
> It's not though - one is dropped in that function, the other when the
> request is freed. So we do need two references to it. With the proposed
> change to keep the override_creds() variable local for that spot we
> don't, and the get_cred() can then go.

You're right here. It seems, it was too much looking at the same code :)

> 
>> It could be I'm wrong with the statement above, need to recheck all this
>> code to be sure.
> 
> I think you are :-)

Considering above, there shouldn't be much difference indeed.
One extra rcu_dereference() in get_current_creds() instead of
get_cred(), but that's nothing.

Later we can hide one get by using submission state from the long
patchset, I sent a while ago.

> 
>> BTW, io_req_defer_prep() may be called twice for a req, so you will
>> reassign it without putting a ref. It's safer to leave NULL checks. At
>> least, until I've done reworking and fixing preparation paths.
> 
> Agree, the NULL checks are safer and we should keep them.
> 
> Going through the rest of this thread, I'm making the following changes:
> 
> - ID must be > 0. I like that change, as we don't need an sqe flag to
>   select personality then, and it also makes it obvious that id == 0 is
>   just using current creds.
> 
> - Fixed the missing put_cred() in the teardown
> 
> - Use a local variable in io_submit_sqe() instead of assigning the
>   creds to req->work.creds there
> 
> - Use cyclic idr allocation
> 
> I'm going to fold in as appropriate. If there are fixes needed on top of
> that, let's do them separately.
> 

-- 
Pavel Begunkov
