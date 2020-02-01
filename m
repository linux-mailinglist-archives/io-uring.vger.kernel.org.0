Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F132E14FADD
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 23:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgBAWvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 17:51:37 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45836 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgBAWvh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 17:51:37 -0500
Received: by mail-pl1-f194.google.com with SMTP id b22so4273301pls.12
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 14:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XmdAvCMmzwowU8Ov695u2vhCPJ/73Ki/Hbnfr8rCCXQ=;
        b=e9JY9+N5MT++sBzdqyypX6Cal/qg+QdaQlC6OPGqIVsRTY5notjsEBNJ0T1fI0/SZK
         sdCSUa2wMeX72LJk77QEBNngKfSXqYhmwqV/GOL3fCV40lLgNjcbt/8GdisKSRuF8bI8
         4NGW6KK2jmNHxau4mbokXAsTbaZx1N3vXZHaNzfDvwmUG4/1k6gxI1PnKcoGJjWMWb2A
         2RAZHCye1itcHocTNuHMl3oh5YCJhQQlW7IdcCB1gu26ZTQVYnFAL3PF6EUG30gjZvXS
         ck5omUizyJLayUia0En2FZ5/CLTXKlOMr8x2392yWepNsA06fWToq98LOHX472vCjOHg
         49sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XmdAvCMmzwowU8Ov695u2vhCPJ/73Ki/Hbnfr8rCCXQ=;
        b=iJ268cDkIZVTTRtT7ZhmPs77JHWEI21exavk1OOiihguztuhM01oR+aMg6Jvl9GMXY
         Ru3+YpYjBXkLZru/ibdD2PKTEZ8iPfm5ATUWm/qo84HNkV+jsMG69G22b3D5ofYlsm+Y
         Kcm+GB5rQhArOAHTgeX5nFO7vC+YXCwuajgxlioyZqP9Y+bAbWq4GZoND6CeeMxRO/f7
         x+7Zk0g3GyWI4WNRIJVDNScwvXu+2T8ObqfX5AnAOkl5u7K0xPeR5/sbhv7Dmh1fKV8C
         IP35pt/dqV1uP6u5vqOMJ8uvDdyy9fZfJud7B04DksmgXreeVvNNQXFuv2miqmY316Xe
         yadA==
X-Gm-Message-State: APjAAAU4YYMFBXWPEbm6zNjmnE3OJuUWBKYVIiPo2zQdv+Ce7xrFFJ+5
        7Qbid450S0Q4aGzpS3jKaJZNaP2C70s=
X-Google-Smtp-Source: APXvYqwaqBonHwYnzpkEvjdbHMhlskqsYAGPoxRumdHWYlYpxvtzrtTYQmmHGVjCrazc8Bku9Gv6jA==
X-Received: by 2002:a17:90a:f0c1:: with SMTP id fa1mr8842375pjb.129.1580597488829;
        Sat, 01 Feb 2020 14:51:28 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i3sm14948477pfg.94.2020.02.01.14.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 14:51:28 -0800 (PST)
Subject: Re: liburing: expose syscalls?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
 <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
 <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e57109e7-357f-3ab5-4fd5-0488cf2021a0@kernel.dk>
Date:   Sat, 1 Feb 2020 15:51:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/20 2:16 PM, Pavel Begunkov wrote:
> On 01/02/2020 20:52, Jens Axboe wrote:
>> On 2/1/20 10:49 AM, Andres Freund wrote:
>>> Hi, 
>>>
>>> On February 1, 2020 6:39:41 PM GMT+01:00, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/1/20 5:53 AM, Andres Freund wrote:
>>>>> Hi,
>>>>>
>>>>> As long as the syscalls aren't exposed by glibc it'd be useful - at
>>>>> least for me - to have liburing expose the syscalls without really
>>>> going
>>>>> through liburing facilities...
>>>>>
>>>>> Right now I'm e.g. using a "raw"
>>>> io_uring_enter(IORING_ENTER_GETEVENTS)
>>>>> to be able to have multiple processes safely wait for events on the
>>>> same
>>>>> uring, without needing to hold the lock [1] protecting the ring [2]. 
>>>> It's
>>>>> probably a good idea to add a liburing function to be able to do so,
>>>> but
>>>>> I'd guess there are going to continue to be cases like that. In a bit
>>>>> of time it seems likely that at least open source users of uring that
>>>>> are included in databases, have to work against multiple versions of
>>>>> liburing (as usually embedding libs is not allowed), and sometimes
>>>> that
>>>>> is easier if one can backfill a function or two if necessary.
>>>>>
>>>>> That syscall should probably be under a name that won't conflict with
>>>>> eventual glibc implementation of the syscall.
>>>>>
>>>>> Obviously I can just do the syscall() etc myself, but it seems
>>>>> unnecessary to have a separate copy of the ifdefs for syscall numbers
>>>>> etc.
>>>>>
>>>>> What do you think?
>>>>
>>>> Not sure what I'm missing here, but liburing already has
>>>> __sys_io_uring_enter() for this purpose, and ditto for the register
>>>> and setup functions?
>>>
>>> Aren't they hidden to the outside by the symbol versioning script?
>>
>> So you just want to have them exposed? I'd be fine with that. I'll
>> take a patch :-)
>>
> 
> Depends on how it's used, but I'd strive to inline
> __sys_io_uring_enter() to remove the extra indirect call into the
> shared lib. Though, not sure about packaging and all this stuff. May
> be useful to do that for liburing as well.

Not sure that actually matters when you're doing a syscall anyway, that
should be the long pole for the operation.

-- 
Jens Axboe

