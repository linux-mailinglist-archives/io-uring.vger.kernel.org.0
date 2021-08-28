Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5F73FA60F
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 15:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhH1Nk6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 09:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhH1Nk5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 09:40:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BD6C061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 06:40:07 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n5so14867592wro.12
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 06:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=L6jgNqen6Uw9u0PCim8MtnHB5gLwoAO+taLFs8Xm1IY=;
        b=qG4RztOo5rLr1dZ/7oWSQaI57FzvYEVB3iX2nu5MRihlKkDZ6lVd67j5qOQSxrXB5u
         kttqmYBFUWpn0srCxgRYpx9C/SvUyLl+BRMozRyqmCmGBjfnQ8vXFSlBkMT7N9iQ/OOp
         DO1Os18jVGFqYAG0kSjItNjaqSW7u9dBXUIfiEYMf0X+LH2xbFDaey6SFwQ0CkgasLqJ
         Wodh/vhe9EE5WXKM/RjUElMrJSlC0sgmRyQAE7rOp/GS2TgFf3YmCYUD3O4QCtOFFhR+
         pqbEyAndInQL4mmBPwRwpL4n8IX/4jGjy0IYQMUozDbqH7rmYq8OUszrRwxoxZt534RB
         hCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L6jgNqen6Uw9u0PCim8MtnHB5gLwoAO+taLFs8Xm1IY=;
        b=YzzequIoM68wDC8Iu7NYN0FN3p2qao7sxWhyMbtzUJoopHY4hVILOExi30vCXSrXyF
         rLVtpe4KWq6pPsUO8UWmN0NmsGirpRgYGtLFqd+7oDwofM19QIN7LeijTNOfhf8B3HHW
         SvBwdRE7wpfczIJ70D++3fhQAmyxc3c79FeVHrFPRcv+wMlvkUhpI1H1k3Fm+5Fn+Gwl
         JcYcaQU1ZrhQh6d40JPVB2lMOW6QlCT5Wugx4U9PMwxXNwX7TzKSDs2P6cPyPV4qBwS1
         Omfy3bzxnAzSD8gWTzC3OhrLcf6Pt36SgICV0caNQgvc/SbfMe6sJPqmHhUQMiO6Uf+I
         gCvQ==
X-Gm-Message-State: AOAM531+OQeLUn52PdMde0VkbyPJm/EIErgMdc4E3FqJcSi+YPKQBJ0N
        L9ulAc6ygi/Y8h5iKzgsI+07ITkdYBo=
X-Google-Smtp-Source: ABdhPJw0lnnGf14pSqvc7wK0G6uZtrtW6ocRYusab5D0p8/hiEKrQHQOV2PacbJmu2GaHTVnWxPjrg==
X-Received: by 2002:adf:a44d:: with SMTP id e13mr15552002wra.177.1630158005785;
        Sat, 28 Aug 2021 06:40:05 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.102])
        by smtp.gmail.com with ESMTPSA id u8sm14540339wmq.45.2021.08.28.06.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Aug 2021 06:40:05 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
 <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: io_uring_prep_timeout_update on linked timeouts
Message-ID: <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
Date:   Sat, 28 Aug 2021 14:39:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/21 4:22 AM, Jens Axboe wrote:
> On 8/26/21 7:40 PM, Victor Stewart wrote:
>> On Wed, Aug 25, 2021 at 2:27 AM Victor Stewart <v@nametag.social> wrote:
>>>
>>> On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
>>>>
>>>> we're able to update timeouts with io_uring_prep_timeout_update
>>>> without having to cancel
>>>> and resubmit, has it ever been considered adding this ability to
>>>> linked timeouts?
>>>
>>> whoops turns out this does work. just tested it.
>>
>> doesn't work actually. missed that because of a bit of misdirection.
>> returns -ENOENT.
>>
>> the problem with the current way of cancelling then resubmitting
>> a new a timeout linked op (let's use poll here) is you have 3 situations:
>>
>> 1) the poll triggers and you get some positive value. all good.
>>
>> 2) the linked timeout triggers and cancels the poll, so the poll
>> operation returns -ECANCELED.
>>
>> 3) you cancel the existing poll op, and submit a new one with
>> the updated linked timeout. now the original poll op returns
>> -ECANCELED.
>>
>> so solely from looking at the return value of the poll op in 2) and 3)
>> there is no way to disambiguate them. of course the linked timeout
>> operation result will allow you to do so, but you'd have to persist state
>> across cqe processings. you can also track the cancellations and know
>> to skip the explicitly cancelled ops' cqes (which is what i chose).
>>
>> there's also the problem of efficiency. you can imagine in a QUIC
>> server where you're constantly updating that poll timeout in response
>> to idle timeout and ACK scheduling, this extra work mounts.
>>
>> so i think the ability to update linked timeouts via
>> io_uring_prep_timeout_update would be fantastic.
> 
> Hmm, I'll need to dig a bit, but whether it's a linked timeout or not
> should not matter. It's a timeout, it's queued and updated the same way.
> And we even check this in some of the liburing tests.

We don't keep linked timeouts in ->timeout_list, so it's not
supported and has never been. Should be doable, but we need
to be careful synchronising with the link's head.

> Do you have a test case that doesn't work for you? Always easier to
> reason about a test case.
> 

-- 
Pavel Begunkov
