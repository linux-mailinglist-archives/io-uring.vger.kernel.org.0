Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B394D3B1E30
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhFWQBW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 12:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhFWQBW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 12:01:22 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9A6C061574;
        Wed, 23 Jun 2021 08:59:03 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id c7so4180521edn.6;
        Wed, 23 Jun 2021 08:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CWv/xPv3FjaVxoqo3/Fi0XjrvWfRx7mkSkEQgQSVJ6A=;
        b=jM24J2Nc+37YLbqDhk4n2rfsFO72oWshQX9tz5lXi1Y1weC8y7k1Gqa2gW5pdIx3+G
         zgFrJdaE6FbbUiTokDdDgQCB/AI3b8E9p1w0k7Z0uRFgua29U2KlZ2aCpk1oCft1ROf6
         8Anpc+04DVse4ZBK2jI7Qo6pCMF3GeEBn1dw1UHFxX0tqVpxLiaHDHtuSlPGHHmf6qDk
         2XKe+td7l1uI0JTVjdNnI3eySzUHQgTHMJHZMvaLlVaIPixCDZ9VJMTByItzDCHOiqlj
         gST4oI/gRaZFHweBgvK9/d3Vh836NHIQUw6II6LOjOThe/B4DZBDYRB/Ol4aKcQltNOC
         3SuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CWv/xPv3FjaVxoqo3/Fi0XjrvWfRx7mkSkEQgQSVJ6A=;
        b=hV8afftGhAzzWkU7x7H3BUyHbRElmditOhJzxcAzfqBl0H+Ip8MIeOWJKc9zJ/1w3h
         yWPrf95PzvgSEnaKMNIYBTy1KXebSs3L1AKxoazhWjboFutUCV1SQRyGeTh8HvsBlxRZ
         nv6rkw7bmvUKhBeHXiI34D0IuoOfWUP82mxj5o0niJujXmtJXwvfp3DY++G0Ete7tVDH
         ZuXVzbCtDUTDjFfS2QruZ2Ar37KLsTVwb1yXU4Ay3y5slrHvgzAh9hp8e+UgHHrhah4P
         OYgRmfMzHIRbNUzOCbnNI0OBcAqjx6CzoohDv4y3lYOyxz3jP3x07cpcpxMyASQmznmS
         QI7Q==
X-Gm-Message-State: AOAM533O+2/mb/qRectRQG2HYCEiwOVx1ZQVDKof8Dc4pBtYohebmLcG
        b8+B8j6WQuxSMOSVBcGKLEo1j+nnda8iFI1n
X-Google-Smtp-Source: ABdhPJzH/ezic5ru0xRFlDh04+0hEsAYPTVl/1vvcA7ahOqD0d9teA9RFyJZrPlVucZ0Gk1D3LX1LA==
X-Received: by 2002:aa7:dd53:: with SMTP id o19mr549965edw.259.1624463942104;
        Wed, 23 Jun 2021 08:59:02 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:6d82])
        by smtp.gmail.com with ESMTPSA id b14sm74149ejk.120.2021.06.23.08.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 08:59:01 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
 <60d23218.1c69fb81.79e86.f345SMTPIN_ADDED_MISSING@mx.google.com>
 <dcc24da6-33d6-ce71-8c87-f0ef4e7f8006@gmail.com>
 <b00eb9407276f54e94ec80e6d80af128de97f10c.camel@trillion01.com>
 <169899caad96c3214d6e380ac7686d054eed3b12.camel@trillion01.com>
 <2603ffd4-c318-66ed-9807-173159536f6a@gmail.com>
 <a2ade714df72c0adeb19897811133a0e0244a729.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/2 v2] io_uring: Fix race condition when sqp thread goes
 to sleep
Message-ID: <6d2c2777-cce6-6633-c937-fd3a56ffbd73@gmail.com>
Date:   Wed, 23 Jun 2021 16:58:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a2ade714df72c0adeb19897811133a0e0244a729.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 2:52 PM, Olivier Langlois wrote:
> On Wed, 2021-06-23 at 00:03 +0100, Pavel Begunkov wrote:
>> On 6/22/21 11:42 PM, Olivier Langlois wrote:
>>> On Tue, 2021-06-22 at 18:37 -0400, Olivier Langlois wrote:
>>>> On Tue, 2021-06-22 at 21:45 +0100, Pavel Begunkov wrote:
>>>>
>>>>
>>>> I can do that if you want but considering that the function is
>>>> inline
>>>> and the race condition is a relatively rare occurence, is the
>>>> cost
>>>> coming with inline expansion really worth it in this case?
>>>>>
>>> On hand, there is the inline expansion concern.
>>>
>>> OTOH, the benefit of going with your suggestion is that completions
>>> generally precedes new submissions so yes, it might be better that
>>> way.
>>>
>>> I'm really unsure about this. I'm just raising the concern and I'll
>>> let
>>> you make the final decision...
>>
>> It seems it may actually loop infinitely until it gets a signal,
>> so yes. And even if not, rare stalls are nasty, they will ruin
>> some 9s of latency and hard to catch.
>>
>> That part is quite cold anyway, would generate some extra cold
>> instructions, meh
>>
> I'm not 100% sure to see the infinite loop possibility but I guess that
> with some badly placed preemptions, it could take few iterations before
> entering the block:
> 
> 		if (sqt_spin || !time_after(jiffies, timeout)) {

Had a case in mind, but looking through the branches it can't
really happen. Agree that won't be infinite in real life, until
we start using (and there was an RFC) finer grained timeouts.

In any case for several reasons think it's the right thing to do.

> So I will go ahead with your suggestion.
> 
> I'll retest the new patch version (it should be a formality) and I'll
> resend an update once done.

Perfect

-- 
Pavel Begunkov
