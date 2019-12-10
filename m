Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C3119EAB
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 23:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLJWzJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 17:55:09 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35999 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfLJWzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 17:55:09 -0500
Received: by mail-pl1-f195.google.com with SMTP id d15so487105pll.3
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 14:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K560JhN8jjr2klsKF9w2lMytMSQAi8SNYSkAmDUvHLo=;
        b=d2py0cvzfnsbNyUDrtVzKgSJWvhm8kxMowvABHkfsSsgwQbUG2CiBIVO2T2uANuZod
         k9bUCXc7tw8c2LiiEZksQoAOG+iMBfg6g2SZQqvGrz/lp/vKz4RfYIW56G8Z0mZJ6GJS
         Soq728u1FMuTAiVsiiR0NTc7qKBQEmyn1soma03BgVzJ2a23QfqBDM/Qx3d6fNxviEAH
         jQ1pYzJ2rcZFdrC9pkt8vd/MC9SC0Yi772lhAbxMEKwth4+VWCVRnCo52QIOLvieSob0
         apevRHXoI13Zd+CPVtcSyDFuBDA9b53plI99DzXNmXPf/7jytHGy67YLHQUj0Q8emAFQ
         qTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K560JhN8jjr2klsKF9w2lMytMSQAi8SNYSkAmDUvHLo=;
        b=PR8PItRDcZzp2TbF+Zh/LoxCrmJygyLMnsO6/HLIldb4qw4/jKNvM007yYBmyTOrvL
         XKv7+LtxGHRv0Fj/ws/2KR1wGZahOJ2YzQTYZ1I+mqqHmkx0lU8cswNNGj/TG0Q8bbx1
         EtstzEn3VZtVqp5vPGG94cRu2fJ27TeTTkoZP7pNtf7naPIlfUeWYYB9lhMypYDOmbpa
         3G6dGIz845D8tPMW1eLUgDn4ZvUH3gsDIHOrj4hKUm/DM1N5dsAT7gBdxy1l9jpAynaO
         hzvRTg8O8KxfzWoOHF14nIOWxpffbqwZoRByGspVdz6za8pYWVkhi4ZpBC6O4CtsyV5A
         ktwA==
X-Gm-Message-State: APjAAAVf/wTAePJT+C/5BGEm4KZT/tlonnSSakf9zbHUStcaoUz5xDeA
        xVICjKjaoVUT/zshleqKUwAkeQ==
X-Google-Smtp-Source: APXvYqyxzzVD3MrlcD7MqBqyebaS33cuqvNUhV/9QBTalYssrGV5bjjfLSxN/qrslOYwh7rGVWjTfQ==
X-Received: by 2002:a17:902:ac88:: with SMTP id h8mr37617802plr.131.1576018508279;
        Tue, 10 Dec 2019 14:55:08 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1215? ([2620:10d:c090:180::4a7a])
        by smtp.gmail.com with ESMTPSA id q11sm80841pff.111.2019.12.10.14.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:55:07 -0800 (PST)
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
To:     Kees Cook <keescook@chromium.org>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
 <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
 <201912101445.CF208B717@keescook>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d6ff9af3-5e72-329c-4aed-cbe6d9373235@kernel.dk>
Date:   Tue, 10 Dec 2019 15:55:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <201912101445.CF208B717@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/19 3:46 PM, Kees Cook wrote:
> On Tue, Dec 10, 2019 at 03:21:04PM -0700, Jens Axboe wrote:
>> On 12/10/19 3:04 PM, Jann Horn wrote:
>>> [context preserved for additional CCs]
>>>
>>> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> Recently had a regression that turned out to be because
>>>> CONFIG_REFCOUNT_FULL was set.
>>>
>>> I assume "regression" here refers to a performance regression? Do you
>>> have more concrete numbers on this? Is one of the refcounting calls
>>> particularly problematic compared to the others?
>>
>> Yes, a performance regression. io_uring is using io-wq now, which does
>> an extra get/put on the work item to make it safe against async cancel.
>> That get/put translates into a refcount_inc and refcount_dec per work
>> item, and meant that we went from 0.5% refcount CPU in the test case to
>> 1.5%. That's a pretty substantial increase.
>>
>>> I really don't like it when raw atomic_t is used for refcounting
>>> purposes - not only because that gets rid of the overflow checks, but
>>> also because it is less clear semantically.
>>
>> Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
>> could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
>> that's what I should do. But I'd prefer to just drop the refcount on the
>> io_uring side and keep it on for other potential useful cases.
> 
> There is no CONFIG_REFCOUNT_FULL any more. Will Deacon's version came
> out as nearly identical to the x86 asm version. Can you share the
> workload where you saw this? We really don't want to regression refcount
> protections, especially in the face of new APIs.
> 
> Will, do you have a moment to dig into this?

Ah, hopefully it'll work out ok, then. The patch came from testing the
full backport on 5.2.

Do you have a link to the "nearly identical"? I can backport that
patch and try on 5.2.


-- 
Jens Axboe

