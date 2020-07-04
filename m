Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1296214464
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 08:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGDGvX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jul 2020 02:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgGDGvX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jul 2020 02:51:23 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91740C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 23:51:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e15so29688422edr.2
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 23:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HgPBzFkh1NPb7AFEr2he57Dvd4apOc9O6FpNpI/lUtY=;
        b=Efsuec3Tj7Hx4Ci/VzSp+NBBIZJc4QcrmHyvRtuYtqlSB8mYp/dSjekLQ4TGPdhY1t
         tOrW7mBegsh+zoFcyJVAFIC+NlfuBWR7Gg8QmaVcetnAd++nhBMF7kiVW0+OtDXQUruC
         ElyomVqo9+LtT/Xyp/Z3HxZZthpmKdZ42smGKT5eD/6tG7UPB8UztFp5/NIpIfynM3Vj
         rP9ijN7dKRvH3JCPrNF/1SknM6Ck2UJ+vCGP8/bpaZfltROkPiJydnjtxgPtVoYXPyCB
         q7MOmed9UeSia4QY+wrp7kv5Q5YfOtHhydwrF4Bzt0pCLQW5NdNRZgtyFFrDhIfe9LNt
         z3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HgPBzFkh1NPb7AFEr2he57Dvd4apOc9O6FpNpI/lUtY=;
        b=UD8TaD4rdityFOR44K9/5yVxVJOCGHr7TEm2/onorUKMFtk0YZG6oZJuprv5mfsPst
         l/htZIXU+7ETUp70wsVG3OJkSJaegv4r1sOWXIOPCpIPqa7UcYoXhgzaJgJ+0oT3w7y8
         Q+nGpjrxkIBdah+9chyg2BtEbvvakALLfKTM1222CIztElPfa71EjVohv+TR5wUE3Mwt
         i96yEYlD1LvkMZt9LDn4JLQik6Cm/O+AMTJuhioPyqkLq/yW4aIS822DDKWsGcAJOCA0
         6U75daaOm70EuP8jcVU+szYfrYKX5c+KNsjZ3seWFuDYHRS7vOyb317JvW8N9GHQa2Nk
         naqA==
X-Gm-Message-State: AOAM533n1mI7PobzCF7OYaAxTF1kOjrvHcYl1+JklzL12fmKoCMhsk9i
        YczmqhJXwx5NR7gWf089tf/JDM8s
X-Google-Smtp-Source: ABdhPJy5Ku6OBVq/CeFXc61EKvLqCuL4MoAj4LTibFSOu9lJMdGtQ8mwDmTpaZnJxIHTPvlVqk4a3A==
X-Received: by 2002:a05:6402:b84:: with SMTP id cf4mr20045122edb.21.1593845480163;
        Fri, 03 Jul 2020 23:51:20 -0700 (PDT)
Received: from [192.168.43.71] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id ck6sm13693213edb.18.2020.07.03.23.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 23:51:19 -0700 (PDT)
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <cover.1593424923.git.asml.silence@gmail.com>
 <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
 <CAG48ez2yJdH3W_PHzvEuwpORB6MoTf9M5nOm1JL3H-wAnkJBBA@mail.gmail.com>
 <f7f4724d-a869-c867-ad8e-b2a59e89c727@gmail.com>
 <CAG48ez3fR1QyVXapvwbYzbtv4AEb0BY2ebKsV7vNFLE-6NaUQA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5/5] io_uring: fix use after free
Message-ID: <4f5ecae5-8272-04aa-775e-293dfef82383@gmail.com>
Date:   Sat, 4 Jul 2020 09:49:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3fR1QyVXapvwbYzbtv4AEb0BY2ebKsV7vNFLE-6NaUQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/07/2020 00:32, Jann Horn wrote:
> On Fri, Jul 3, 2020 at 9:50 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 03/07/2020 05:39, Jann Horn wrote:
>>> On Mon, Jun 29, 2020 at 10:44 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> After __io_free_req() put a ctx ref, it should assumed that the ctx may
>>>> already be gone. However, it can be accessed to put back fallback req.
>>>> Free req first and then put a req.
>>>
>>> Please stick "Fixes" tags on bug fixes to make it easy to see when the
>>> fixed bug was introduced (especially for ones that fix severe issues
>>> like UAFs). From a cursory glance, it kinda seems like this one
>>> _might_ have been introduced in 2b85edfc0c90ef, which would mean that
>>> it landed in 5.6? But I can't really tell for sure without investing
>>> more time; you probably know that better.
>>
>> It was there from the beginning,
>> 0ddf92e848ab7 ("io_uring: provide fallback request for OOM situations")
>>
>>>
>>> And if this actually does affect existing releases, please also stick
>>> a "Cc: stable@vger.kernel.org" tag on it so that the fix can be
>>> shipped to users of those releases.
>>
>> As mentioned in the cover letter, it's pretty unlikely to ever happen.
>> No one seems to have seen it since its introduction in November 2019.
>> And as the patch can't be backported automatically, not sure it's worth
>> the effort. Am I misjudging here?
> 
> Use-after-free bugs are often security bugs; in particular when, as in
> this case, data is written through the freed pointer. That means that
> even if this is extremely unlikely to occur in practice under normal
> circumstances, you should assume that someone may invest a significant
> amount of time into engineering some way to make this bug happen. If

Good point, agree.

> you can show that the bug is _impossible_ to hit, that's fine, I
> guess. But if it's merely "it's a really tight race and unlikely to
> happen", I think we should be fixing it on the stable branches.
> For example, on kernels with PREEMPT=y (typically you get that config
> either with "lowlatency" kernels or on Android, I think), attackers
> can play games like giving their own tasks "idle" scheduling priority
> and intentionally preempting them right in the middle of a race
> window, which makes it possible to delay execution for intervals on
> the order of seconds if the attacker can manage to make the scheduler
> IPI hit in the right place.
> 
> I guess one way to hit this bug on mainline would be to go through the
> io_async_task_func() canceled==true case, right? That will drop
> references on a request at the very end, without holding any locks or
> so that might keep the context alive.

Yes, for an example, but even simpler to submit async reads/writes
(i.e. with kiocb->ki_complete set) that would trigger io_complete_rw()
from irq. Or do something with timeout or poll requests.

-- 
Pavel Begunkov
