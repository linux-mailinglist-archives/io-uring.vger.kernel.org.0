Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4E324D768
	for <lists+io-uring@lfdr.de>; Fri, 21 Aug 2020 16:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgHUOgR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Aug 2020 10:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHUOgN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Aug 2020 10:36:13 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30028C061573
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 07:36:13 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 77so1568114ilc.5
        for <io-uring@vger.kernel.org>; Fri, 21 Aug 2020 07:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QdyFsVgr3GxSlF6AHmh/HVXkbY0Ylz66QoEzCIisUvU=;
        b=xl79/1g5Md8uczZr/3h5XdMQhAb2Mu/vRSjmj1BoGW3z3kHe+NXZxld5+9ygY/9RIf
         JJLIcCCKOW48pLKAavqcvS8Wq+6+LBXWeqbrtIOTVbxJetr5yiR7SaIbD/EbB7MJeulU
         VXt2Jx6Oii9ObD6mbkY2UNhbx2+HHfQtcnufBWz3/5BU3yarMnr2c2eeiZGhtAjD4Zgb
         UlE/5uIlcksxsKyWiQTEr+gCnxK28dCrqU0OpcUKBbskUHKENVKg79A227fBy8u0nmwj
         G8RSuQFjcE7qm+/tYHwMvWu2GOzU1aQFk0R3zjh+JlXTcgnDZn+PtCTPphGLYabzoC9U
         TABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdyFsVgr3GxSlF6AHmh/HVXkbY0Ylz66QoEzCIisUvU=;
        b=ZZbFwI/uU3NuAshFSo+qBEf78MesxBWbtSkbXsFmDq+i3Fn9VS1q3bGNYv8Koea5K/
         2bz4kMGVXnlneJv175wRbN7nknLnhtaUhpvcT+DfAZyS3061FOnzr1MoVsL7BIfEgOaM
         XzoOtmN3KnGznSA5u9quPhCsBwke9Tr27gLb0VVru//panZGCNGlFIhuwssQ/u0LmB0j
         xS+VCiuCJfNOngk2BmiWXX6JDOTddFTOiklxho9XKXQOt+DKtC3vUTmC7TNXz42ZR1kP
         fZQg5wBFtgFAUssxjzQrXfzVPmuWz+q8CLY+Qjt2GNOh9m15TkJ52pQ7sdVFfO+uqx5p
         l7Tg==
X-Gm-Message-State: AOAM530iLQfoM/JQPtCy054rTVKLdj2O1ibuxRoENqSWEmgcaBQWQRwU
        ZvWCCe7MdxsY6HS5UoarwAEdPJ/KYwPw/qWB
X-Google-Smtp-Source: ABdhPJzdXk/v+zCSO/5QY3MeA8oA/3Ub63i2uwU9xCebvE4FdMnO0n1sqHJz00J/WLJwjYFX8Mcomw==
X-Received: by 2002:a05:6e02:c28:: with SMTP id q8mr2838161ilg.256.1598020571686;
        Fri, 21 Aug 2020 07:36:11 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o2sm1316108ili.83.2020.08.21.07.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 07:36:10 -0700 (PDT)
Subject: Re: Poll ring behavior broken by
 f0c5c54945ae92a00cdbb43bdf3abaeab6bd3a23
To:     Glauber Costa <glauber.costa@datadoghq.com>
Cc:     io-uring@vger.kernel.org, xiaoguang.wang@linux.alibaba.com
References: <CAMdqtNXQbQazseOuyNC_p53QjstsVqUz_6BU2MkAWMMrxEuJ=A@mail.gmail.com>
 <8d8870de-909a-d05d-51a5-238f5c59764d@kernel.dk>
 <CAMdqtNWVRrej-57v+rXhStPzLBh7kuocPpzJ0R--A3AcG36YAQ@mail.gmail.com>
 <8f509999-bfe3-c99b-6e82-dc604865ce9e@kernel.dk>
 <CAMdqtNWVgd4-X3t3WNZJdAcSqm9g_Bc3QYdJSCUBitz0j5xEOw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9054c5b4-a072-866f-2af7-5d77c1e90d4d@kernel.dk>
Date:   Fri, 21 Aug 2020 08:36:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMdqtNWVgd4-X3t3WNZJdAcSqm9g_Bc3QYdJSCUBitz0j5xEOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/20 7:55 AM, Glauber Costa wrote:
> On Thu, Aug 20, 2020 at 11:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/20/20 8:24 PM, Glauber Costa wrote:
>>> On Thu, Aug 20, 2020 at 9:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 8/20/20 6:46 PM, Glauber Costa wrote:
>>>>> I have just noticed that the commit in $subject broke the behavior I
>>>>> introduced in
>>>>> bf3aeb3dbbd7f41369ebcceb887cc081ffff7b75
>>>>>
>>>>> In this commit, I have explained why and when it does make sense to
>>>>> enter the ring if there are no sqes to submit.
>>>>>
>>>>> I guess one could argue that in that case one could call the system
>>>>> call directly, but it is nice that the application didn't have to
>>>>> worry about that, had to take no conditionals, and could just rely on
>>>>> io_uring_submit as an entry point.
>>>>>
>>>>> Since the author is the first to say in the patch that the patch may
>>>>> not be needed, my opinion is that not only it is not needed but in
>>>>> fact broke applications that relied on previous behavior on the poll
>>>>> ring.
>>>>>
>>>>> Can we please revert?
>>>>
>>>> Yeah let's just revert it for now. Any chance you can turn this into
>>>> a test case for liburing? Would help us not break this in the future.
>>>
>>> would be my pleasure.
>>>
>>> Biggest issue is that poll mode really only works with ext4 and xfs as
>>> far as I know. That may mean it won't get as much coverage, but maybe
>>> that's not relevant.
>>
>> And raw nvme too, of course. But I'd say coverage is pretty decent with
>> those two, in reality that's most likely what people would use for
>> polling anyway. So not too concerned about that, and it'll hit multiple
>> items in my test suite.
>>
>> I reverted the change manually, it didn't revert cleanly. Please test
>> current -git, thanks!
>>
> 
> Just tested (through a new unit test) and it works, thanks.
> 
> I wrote a unit test that works on HEAD but not on HEAD^.

Perfect, thanks!

> However you will have to excuse my lack of manners, but in my new work
> account I can't have app passwords for GSuite so I am unable to
> git-send-email it without talking to a host of corporate IT people...
> I'll have to send a ... urgh... PR

No worries, I don't mind GH PRs, as long as the patch looks good. The
problem is that lots of GH PRs end up being done poorly.

-- 
Jens Axboe

