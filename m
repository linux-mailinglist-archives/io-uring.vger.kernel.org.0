Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A917E32DAC3
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 21:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhCDUBz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 15:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbhCDUBX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 15:01:23 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C60C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 12:00:43 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id d5so26031827iln.6
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 12:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vnnfbY1dHQVZWqhyNZ9ClxeS2MngEd18zqGuQcrT/QM=;
        b=Xz6ORQ1fL8B28sCqtFic+sI+a9L8LHnBvtKszQqbqVySW8sI2PeCv//2DUfAagzeID
         /jejqvd9kQYnoFiXe8UNfiMDfofAiLVLa+M3yzCHmvXVNUAv11w0FnsLmOiUalzjSFm9
         DXbfrQukuKS4KDm03k7m/VSWtMnEXtJJSvFX+iioiS4l3ixw2OA6Xj/oUbtteySn3JGQ
         txy1rm4dAfjEFhA5PvBIp1JAwDDRzKRrWHn5m0EGsCJo1VGt0NZSv28btZ6rsQKftLcM
         ohcrXgg/BRMdFu85FOhAKLltHitIIQ/c3YDe/6YMQXlcbTAFs3+s+ypYbK3JQNAJ1iua
         Lmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vnnfbY1dHQVZWqhyNZ9ClxeS2MngEd18zqGuQcrT/QM=;
        b=jGDCFT/LxYYhlevdhb/AczcIhuwjwZK1D+G7a0jGhH79w2h/4vFza7Xm0RpVVQJN1p
         SZekd9+kFVOGfy+TnkidWy1ruQoNAhG6j6WbLJaWH/mJRUT9/USeuO/ScFN4ICqQ4rC1
         yQbNRW66IFR9CWxY4wM50KxFR4c6gWprDDaD+Puv7Yn5+hkHkfBvfPVavbcJnrXzLhzC
         XgViK3eh/0EIy8kczRKffiPsfha8CFO+HHwffVhiHhwX/M5LgGnZrDrxvIAIFLgHHV+U
         3bDXeSx8yCvxvqgoTZOIdAmITNFMr4HRsF266fm8ivUj7dcp5YVeAgLSA/AGRAdREtLE
         78FA==
X-Gm-Message-State: AOAM531gRyWYlK0krhm8GGkWj1tm3BOhrA7W7bEmUfGEkOZI4SctnyeQ
        W8Cd9dnEOwi78vp6pxOo6OS0mzC5XklFdg==
X-Google-Smtp-Source: ABdhPJwTwM5xMl5agUFvkOJWYviLsMqkq8GuxM5zM85IvT/fx44MPMa+ELYkyDrySJD78id7s8XDpQ==
X-Received: by 2002:a92:ce84:: with SMTP id r4mr5302316ilo.112.1614888042712;
        Thu, 04 Mar 2021 12:00:42 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a15sm214637iln.87.2021.03.04.12.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 12:00:42 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
 <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
 <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk>
 <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
 <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
 <f42dcb4e-5044-33ed-9563-c91b9f8b7e64@kernel.dk>
 <CAHk-=wj8BnbsSKWx=kUFPqpoohDdPchsW00c4L-x6ES8bOWLSg@mail.gmail.com>
 <bcab873a-eced-b906-217f-c52a113a95a9@kernel.dk>
Message-ID: <7dc54165-ac8a-ab3b-c03d-9e696b8a577e@kernel.dk>
Date:   Thu, 4 Mar 2021 13:00:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bcab873a-eced-b906-217f-c52a113a95a9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 12:54 PM, Jens Axboe wrote:
> On 3/4/21 12:46 PM, Linus Torvalds wrote:
>> On Thu, Mar 4, 2021 at 11:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> Took a quick look at this, and I agree that's _much_ better. In fact, it
>>> boils down to just calling copy_process() and then having the caller do
>>> wake_up_new_task(). So not sure if it's worth adding an
>>> create_io_thread() helper, or just make copy_process() available
>>> instead. This is ignoring the trace point for now...
>>
>> I really don't want to expose copy_process() outside of kernel/fork.c.
>>
>> The whole three-phase "copy - setup - activate" model is a really
>> really good thing, and it's how we've done things internally almost
>> forever, but I really don't want to expose those middle stages to any
>> outsiders.
>>
>> So I'd really prefer a simple new "create_io_worker()", even if it's
>> literally just some four-line function that does
>>
>>    p = copy_process(..);
>>    if (!IS_ERR(p)) {
>>       block all signals in p
>>       set PF_IO_WORKER flag
>>       wake_up_new_task(p);
>>    }
>>    return p;
>>
>> I very much want that to be inside kernel/fork.c and have all these
>> rules about creating new threads localized there.
> 
> I agree, here are the two current patches. Just need to add the signal
> blocking, which I'd love to do in create_io_thread(), but seems to
> require either an allocation or provide a helper to do it in the thread
> itself (with an on-stack mask).

Nevermind, it's actually copied, so we can do it in create_io_thread().
I know you'd prefer not to expose the 'task created but not active' state,
but:

1) That allows us to do further setup in the creator and hence eliminate
   wait+complete for that

2) It's not exported, so not available to drivers etc.

-- 
Jens Axboe

