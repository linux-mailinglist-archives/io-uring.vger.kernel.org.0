Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7B2D1EA0
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 00:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgLGX4Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 18:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbgLGX4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 18:56:24 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C43C061793
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 15:55:44 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id m9so10517257pgb.4
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 15:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QUlGXAHsuwTJo36JMQ+yBqv1LY1Vk2SSHFUpFEj/Fno=;
        b=vjMpykBEnVURr39cKoaVECN5jo7564/B2wWYKCi++gzaUx6WGqLw6xTR7Hif4ORGuq
         WcWtpNRci3dKeCc+ocf4M2zYR4Zni9ZEiNiQVsq0BOP+CPXsWugwdcnueFiK9UTjcdz+
         CQIJgBeKpr4lbz/g+hh4LK5rL6bpGG4570irQIPHC84BTEvOZ2PZ/oLAeqT/Gdn4vGZN
         vzhmpS3wmr+sGbiVfxJF59MPqpV2DghOE5YC8hvJm8MlAGezw1YYuRsEnU2Tbbu/7ReR
         0ziNEyXgjpo3/Xyd/mhO+0w0NGMcxQNb3b6R38SH+C+YzgPpwfxZUErZgfx5x+YVG9Gc
         7YOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QUlGXAHsuwTJo36JMQ+yBqv1LY1Vk2SSHFUpFEj/Fno=;
        b=CVwf/f/1k1Y1Q50p8emssuVcvEwkErMRh/X2MD4W730Lc2Ms5Z1yWhGGOihyG9ROHi
         JtN9JO2jlgaqx7ZwdhhlgrHPV3IwmdWL5EFpWA+Lon70L1rMJftfa42fPlaIKmQW0BlY
         qACTN3+XJkESmVRZXJnvGN8FUPliVXVR/1C8UxQaJNelh7xq8UG0Tzv/NTh0ABHwilks
         XND5uZ466j6BXHRfP9ttxi+U1LfgkKs6pCgUPzG+HQrVYD72ebPgNFoKV/AY63wgXmQ6
         CeDnr2t4Ub02uw+vtZjbOFuRCo/honIdRb0zx8vlrf0x47DUjduUcmO/zTZe5eYg6z7w
         ZiuA==
X-Gm-Message-State: AOAM5322lLZ2Ps17OI3nFa9UPUCitXcpTihgdLo7AZPQRannceJUy0mt
        IG522C6dyxfXAH9+ERad9kJIKWr8Odal7Q==
X-Google-Smtp-Source: ABdhPJx44YPHqzFq/7II4h9qR6ZXjlucKbzW0B6OsD8/0Q9Bew737zD4nUqhPYNcu78nfA+asVCGEA==
X-Received: by 2002:a17:902:9891:b029:d8:fdf6:7c04 with SMTP id s17-20020a1709029891b02900d8fdf67c04mr18892097plp.54.1607385343272;
        Mon, 07 Dec 2020 15:55:43 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l3sm465798pju.44.2020.12.07.15.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 15:55:42 -0800 (PST)
Subject: Re: Zero-copy irq-driven data
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CANiDSCsXd1BLUJwgdET5XBF8wQEpbape6BoCPpG9cTGAkUJOBA@mail.gmail.com>
 <f0490f07-c59b-1dab-067f-f17dcfbb61da@gmail.com>
 <CANiDSCvyBBQyQV1PAqOGwaSRtcWn+1xXN=TLj59Gf-u3EWd49w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2925f54b-a659-5c34-137d-7e569fab1392@kernel.dk>
Date:   Mon, 7 Dec 2020 16:55:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANiDSCvyBBQyQV1PAqOGwaSRtcWn+1xXN=TLj59Gf-u3EWd49w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/20 8:07 AM, Ricardo Ribalda wrote:
> Hi Pavel
> 
> Thanks for your response
> 
> On Fri, Dec 4, 2020 at 5:09 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 03/12/2020 15:26, Ricardo Ribalda wrote:
>>> Hello
>>>
>>> I have just started using io_uring so please bear with me.
>>>
>>> I have a device that produces data at random time and I want to read
>>> it with the lowest latency possible and hopefully zero copy.
>>>
>>> In userspace:
>>>
>>> I have a sqe with a bunch of io_uring_prep_read_fixed and when they
>>> are ready I process them and push them again to the sqe, so it always
>>> has operations.
>>
>> SQ - submission queue, SQE - SQ entry.
>> To clarify misunderstanding I guess you wanted to say that you have
>> an SQ filled with fixed read requests (i.e. SQEs prep'ed with
>> io_uring_prep_read_fixed()), and so on.
> 
> 
> Sorry, I am a mess with acronyms.
> 
>>
>>
>>>
>>> In kernelspace:
>>>
>>> I have implemented the read() file operation in my driver. The data
>>
>> I'd advise you to implement read_iter() instead, otherwise io_uring
>> won't be able to get all performance out of it, especially for fixed
>> reqs.
>>
>>> handling follows this loop:
>>>
>>> loop():
>>>  1) read() gets called by io_uring
>>>  2) save the userpointer and the length into a structure
>>>  3) go to sleep
>>>  4) get an IRQ from the device, with new data
>>>  5) dma/copy the data to the user
>>>  6) wake up read() and return
>>>
>>> I guess at this point you see my problem.... What happens if I get an
>>> IRQ between 6 and 1?
>>> Even if there are plenty of read_operations waiting in the sqe, that
>>> data will be lost. :(
>>
>> Frankly, that's not related to io_uring and more rather a device driver
>> writing question. That's not the right list to ask these questions.
>> Though I don't know which would suit your case...
>>
>>> So I guess what I am asking is:
>>>
>>> A) Am I doing something stupid?
>>
>> In essence, since you're writing up your own driver from scratch
>> (not on top of some framework), all that stuff is to you to handle.
>> E.g. you may create a list and adding a short entry with an address
>> to dma on each IRQ. And then dma and serve them only when you've got
>> a request. Or any other design. But for sure there will be enough
>> of pitfalls on your way.
>>
>> Also, I'd recommend first to make it work with old good read(2) first.
>>
>>>
>>> B) Is there a way for a driver to call a callback when it receives
>>> data and push it to a read operation on the cqe?
>>
>> In short: No
>>
>> After you fill an SQE (which is also just a chunk of memory), io_uring
>> gets it and creates a request, which in your case will call ->read*().
>> So you'd get a driver-visible read request (not necessarily issued by
>> io_uring)
>>
>>>
>>> C) Can I ask the io_uring to call read() more than once if there are
>>> more read_operations in the sqe?
>>
>> "read_operations in the sqe" what it means?
> 
> Lets say I have 3 read_operations in the sq. A standard trace from the
> driver will look like
> 
> read()
>  return
> read()
>  return
> read ()
>  return
> 
> If I could get
> 
> read()
> read()
> read()
>  return
>  return
>  return

This is outside the hands of the driver, as Pavel said. If the
application is smart and knows it has 3 reads, then with io_uring it'll
submit all 3 at once. What happens after this is down to what kind of IO
it is, plugging, IO scheduling (if any), etc. The driver has no business
interfering with that, the responsibility of the driver is to do the IO
it is told to do.

-- 
Jens Axboe

