Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC2914FB4E
	for <lists+io-uring@lfdr.de>; Sun,  2 Feb 2020 04:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgBBD3m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 22:29:42 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44420 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgBBD3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 22:29:42 -0500
Received: by mail-pl1-f193.google.com with SMTP id d9so4421263plo.11
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 19:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YBIXjIqgaXFsUqKN5BtwpscrVymGECQYBGc96ukAT1E=;
        b=dlCGRvnXqcPtYNJfSVRHsdCmQqnWfyqC4muQ1l3TB655FsWS7WQcxNEJXvBgw7zkcp
         2H6qTwfhrTOsoW5yOYpXQ/so+nEkvwhDHjznTPHhPAJ3xG+aIA6c6DyiaxwQIE7Skojl
         gwqUq2yaciMdUy5kp2DcWPqvSpWNEvqpKuIVQfEa6WR+9Q8UgByDnrCG+lOdd+Dl6W6l
         O7h6NqQ6YCINw0TEX2BCudXtbETRa5NNFpItr9wvqCOkPvYQbq0q/lS/lu3FL4jqxueE
         yCPzAI1SrW/0fEVlYYnPPU/XDNNQHu5JpbfAdmmM3uvXNfMUGnCXIcB2TifLRhL+hqdM
         7M9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YBIXjIqgaXFsUqKN5BtwpscrVymGECQYBGc96ukAT1E=;
        b=k2Rn1pGthOTLk/pJWGBY4Jx/JsNVDSxmF9O2W54yIgsXFuWxn3vtI3GBl8D93rIBpa
         bnP5VUfWaX+r4pYaSxthunwRF1KycbCdmFUOpff8VYW/pa0rHch4D6MG9IyXoVtkFWxQ
         5VAq+eB9izR2wOkj2WrUmWon6/oF9DigDenwxdXFyLEjF6dHqM+zRXovICRyZYRL6wpE
         gh2KNNdVk6oYPlYtgNOnxsgIw/VEkruGksbdQmMR+pePl547kRA9m+0l8o6rxKoWxGmA
         E4bS9MaoG/C85YHTwMZ6Jd84lYED3KU/khCwUqN0/K+imcL4vAqghHyQaMpUlnXFfiNF
         mFjw==
X-Gm-Message-State: APjAAAUshiYRcieKEwHLdpPZMItkRnMs6ZmNlUhis0nPpxJ3O7n5AQMe
        NwFRNwwERWJAXNgUAVPPyUbuuSi9RGE=
X-Google-Smtp-Source: APXvYqz4mP3xmhhIUXR7/ipNuBFO8jq8kIvil+yGANTXOFuIJBUJuSUJ8ivt99InAuTPlUTQCp65HQ==
X-Received: by 2002:a17:90a:b010:: with SMTP id x16mr22346061pjq.130.1580614181389;
        Sat, 01 Feb 2020 19:29:41 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a195sm15305784pfa.120.2020.02.01.19.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 19:29:40 -0800 (PST)
Subject: Re: liburing: expose syscalls?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
 <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
 <6f5abe8a-1897-123d-d01d-d8c7c5fba7c4@gmail.com>
 <e57109e7-357f-3ab5-4fd5-0488cf2021a0@kernel.dk>
 <9644308d-ef0e-1b94-9a3b-1a4e03bfd314@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <502b2b01-d691-b7bf-53f1-e7a24fb4c6d9@kernel.dk>
Date:   Sat, 1 Feb 2020 20:29:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9644308d-ef0e-1b94-9a3b-1a4e03bfd314@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/20 4:30 PM, Pavel Begunkov wrote:
> On 02/02/2020 01:51, Jens Axboe wrote:
>>>> So you just want to have them exposed? I'd be fine with that. I'll
>>>> take a patch :-)
>>>>
>>>
>>> Depends on how it's used, but I'd strive to inline
>>> __sys_io_uring_enter() to remove the extra indirect call into the
>>> shared lib. Though, not sure about packaging and all this stuff. May
>>> be useful to do that for liburing as well.
>>
>> Not sure that actually matters when you're doing a syscall anyway, that
>> should be the long pole for the operation.
>>
> 
> Yeah, but they are starting to stack up (+syscall() from glibc) and can became
> even more layered on the user side.

Not saying it's free, just that I expect the actual system call to dominate.
But I hear what you are saying, this is exactly why the liburing hot path
resides in static inline code, and doesn't require library calls. I did
draw the line on anything that needs a system call, figuring that wasn't
worth over-optimizing.

I could be full of shit, numbers talk!

-- 
Jens Axboe

