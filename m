Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF493A9CBD
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 15:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhFPN4h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 09:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbhFPN4T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 09:56:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA99C0613A4;
        Wed, 16 Jun 2021 06:54:11 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q5so2823864wrm.1;
        Wed, 16 Jun 2021 06:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CjaXbP53aJpeDXopOkh5k4d6j3XgRz6Sqz8UUucJyuo=;
        b=ZeClm2sTZg0Yvf6HBpdVSk2Ls6ELscaYz4zfGD8RSlA1mal7XZ3048jopi7NZA1sNV
         rTXs0N79074re78HIIOdCdghTH4KkikxdvZNIox2OM2kW/Z9zQQtHqMOtW9oc5hq7qYy
         8AT36ranb+ZChiZcLMcJ0XaXE03qoMQa65secGa6Un5CZIilAhQcSuIWffx9Nf2YeoBu
         cs2lVv3McmvKdO6ktalbpe/NoP9CFL2lbX6bgQvwecFdc3eAbreo/LvQR+zA4SS60fS5
         D3fo7wDpLDbNkp+izeXLGJcBjMxaK7jdmmFLTyY9mWvEO3fMJAU6wrGulxOrnP755xqW
         Qm5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CjaXbP53aJpeDXopOkh5k4d6j3XgRz6Sqz8UUucJyuo=;
        b=ZkocqJcelSTx3HJX8Se2PUWu0B5znHNLHvg8kvlpsGAGvRlS3cwLNtKtXAKk6HI213
         iKAImgIKyKSCvJ8xyV+VBvDE4frq8HIYobAgDKxckHMx4ouZy9fo7FoKlTiPCg/peLSk
         Xw5dj7zqoERe6DdPJDtil3OfNh7c9e4MNcyt2uszjhoc+X50QlpPwszWDXGpMPaAJCpx
         fggxWpFoMViBJM3STviSYQ4+hBPmaBwKi+RBaUE6EzXv0na9GPN8bAHmlBsNtuPqzbus
         +uLLlfDwl9xHoWsVhUwC48jfdg7p4QZS2Z8v+sUmeGMQXWAIm+o9sqEOqY0xUQmLk3JQ
         u3RQ==
X-Gm-Message-State: AOAM532QWGvOVoh1tkktvjcpdvl10sNOi9ZpfxYwM2sgvtD7hjnQrORU
        HYfhFKu7Pov1C+wFwfh5Sqqj1SgBT5gI0Q==
X-Google-Smtp-Source: ABdhPJzByKP90c8XXkxAzoXfGYzPwDUFFoa/IawCi4xilny7WvH10oyRu7ddZ1AoxgDJO7FhxOFveA==
X-Received: by 2002:a05:6000:184c:: with SMTP id c12mr5733547wri.196.1623851649660;
        Wed, 16 Jun 2021 06:54:09 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id x7sm2396089wre.8.2021.06.16.06.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 06:54:09 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
 <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
 <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
 <f3cf3dc047dcee400423f526c1fe31510c5bcf61.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <92ed952f-9de9-108c-a48e-93321b59cfab@gmail.com>
Date:   Wed, 16 Jun 2021 14:53:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f3cf3dc047dcee400423f526c1fe31510c5bcf61.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/21 2:33 PM, Olivier Langlois wrote:
> On Tue, 2021-06-15 at 15:50 -0600, Jens Axboe wrote:
>> On 6/15/21 3:48 AM, Pavel Begunkov wrote:
>>> On 5/31/21 7:54 AM, Olivier Langlois wrote:
>>>> Fix tabulation to make nice columns
>>>
>>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> I don't have any of the original 1-3 patches, and don't see them on the
>> list either. I'd love to apply for 5.14, but...
>>
>> Olivier, are you getting any errors sending these out?Usually I'd
>> expect
>> them in my inbox as well outside of the list, but they don't seem to
>> have
>> arrived there either.
>>
>> In any case, please resend. As Pavel mentioned, a cover letter is
>> always
>> a good idea for a series of more than one patch.
>>
> I do not get any errors but I have noticed too that my emails weren't
> accepted by the lists.
> 
> They will accept replies in already existing threads but they won't let
> me create new ones. ie: accepting my patches.
> 
> I'll learn how create a cover email and I will resend the series of
> patches later today.

"--cover-letter" to "git format-patch" will create a cover template
to fill in. Depends on patches, but can be a small description of the
series.

Regarding resending, Jens already took/applied them today, see
a reply to 1/3. You can find them queued at

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.14/io_uring

> one thing that I can tell, it is that Pavel and you are always
> recipients along with the lists for my patches... So you should have a
> private copy somewhere in your mailbox...
> 
> The other day, I even got this:
> -------- Forwarded Message --------
> From: Mail Delivery System <Mailer-Daemon@cloud48395.mywhc.ca>
> To: olivier@trillion01.com
> Subject: Mail delivery failed: returning message to sender
> Date: Thu, 10 Jun 2021 11:38:51 -0400
> 
> This message was created automatically by mail delivery software.
> 
> A message that you sent could not be delivered to one or more of its
> recipients. This is a permanent error. The following address(es)
> failed:
> 
>   linux-kernel@vger.kernel.org
>     host vger.kernel.org [23.128.96.18]
>     SMTP error from remote mail server after end of data:
>     550 5.7.1 Content-Policy accept-into-freezer-1 msg:
>     Bayes Statistical Bogofilter considers this message SPAM.  BF:<S
> 0.9924>  In case you disagree, send the ENTIRE message plus this error
> message to <postmaster@vger.kernel.org> ; S230153AbhFJPkq
>   io-uring@vger.kernel.org
>     host vger.kernel.org [23.128.96.18]
>     SMTP error from remote mail server after end of data:
>     550 5.7.1 Content-Policy accept-into-freezer-1 msg:
>     Bayes Statistical Bogofilter considers this message SPAM.  BF:<S
> 0.9924>  In case you disagree, send the ENTIRE message plus this error
> message to <postmaster@vger.kernel.org> ; S230153AbhFJPkq
> 
> There is definitely something that the list software doesn't like in my
> emails but I don't know what...
> 
> I did send an email to postmaster@vger.kernel.org to tell them about
> the problem but I didn't hear back anything from the postmaster... (My
> email probably went to the SPAM folder as well!)
> 

-- 
Pavel Begunkov
