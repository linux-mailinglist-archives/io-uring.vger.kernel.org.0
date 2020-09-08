Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A9F262344
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 00:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIHWyv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 18:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgIHWyu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 18:54:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CA1C061573
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 15:54:50 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so414773pff.6
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 15:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1ysC2IkdV6cGCsIiy06GR85oBuHTvW0j5QcGpJgCOsE=;
        b=SO4NKUATjaaQrQsQTi7m78ra4uw6dOdxaeHbNsMLyFZ8GyKU4Rvhbdty6JCAloEAvX
         kPWGWDka7sjwKlIiVjM36lBYB8OOWfPGudbs2mitglCnlWZpUkXH0oFulItY0BrwPVq8
         plyfrTcTs6Lnk6m8DvEZaWyQBFEKef4q9WXnn/LhtURcLTwUWBXF9oLJ6+mEkuV8yuXH
         a3fPrWvADDwRg5akRM251nbLIkTy1wqeayS0up00IlBJtAui9tvJVPlxkS/hLxoj/0iN
         BY5/lzZ4IBt06GRNCbZXjiozCCjGxQ/fimoX0KMvxCFF8qOtIAUUoBL4gJ8VhNTDWTnP
         RFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ysC2IkdV6cGCsIiy06GR85oBuHTvW0j5QcGpJgCOsE=;
        b=ihq003HvAz8Qhs5QzjgAvRAc3uFMjYfZsp4EvSs2XYiy8eL8H9wrdVXmzW6gN3xRhn
         Ki/Tkz06sUKrY7UXGdxdhA/L55MDOynLEtLNhTH8uxFNSxAWT2BgZdAFZ7A3VbyOHSky
         N/ugk7naqind1rSpbC8+q2V7g3eTSsF5uYqtzhXs165tyVq5Z8ANFZHBV3sQDrZ1hBJa
         nqj/6nMqV7Xgu/MPYD6Ynzlq3koT+u5bzfjoY/UnbDjFdsvIYdO7zX52YzQObZGkplLa
         7CMO7EMR4MpBOfD7cQiZ8S2bEq8QlcjTCt5MVc/r/5FTFwRcCNTbc8gMauPPJa6mx2OO
         op8Q==
X-Gm-Message-State: AOAM532SdwyDhY7xt/uteX13Li/ikuCzIk3BkfpvmfBzHgB6gZqumI/J
        bCbi6qGqT60F+ix9JCW6zt2O5vRQMQK1hei6
X-Google-Smtp-Source: ABdhPJw5vaGnlV5ij4CwGDmBMWL8922HjOsfgNztvldPyQnJNh3HhFnaaTU63ZLawgMdQbAZl2mCiQ==
X-Received: by 2002:a17:902:a509:b029:d0:cb2d:f26e with SMTP id s9-20020a170902a509b02900d0cb2df26emr1189430plq.7.1599605689576;
        Tue, 08 Sep 2020 15:54:49 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y128sm435488pfy.74.2020.09.08.15.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 15:54:49 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
 <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
Message-ID: <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
Date:   Tue, 8 Sep 2020 16:54:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 3:22 PM, Jens Axboe wrote:
> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>> On 08/09/2020 20:48, Jens Axboe wrote:
>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>> the ring fd/file appropriately so we can defer grab them.
>>
>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>> that isn't the case with SQPOLL threads. Am I mistaken?
>>
>> And it looks strange that the following snippet will effectively disable
>> such requests.
>>
>> fd = dup(ring_fd)
>> close(ring_fd)
>> ring_fd = fd
> 
> Not disagreeing with that, I think my initial posting made it clear
> it was a hack. Just piled it in there for easier testing in terms
> of functionality.
> 
> But the next question is how to do this right...

Looking at this a bit more, and I don't necessarily think there's a
better option. If you dup+close, then it just won't work. We have no
way of knowing if the 'fd' changed, but we can detect if it was closed
and then we'll end up just EBADF'ing the requests.

So right now the answer is that we can support this just fine with
SQPOLL, but you better not dup and close the original fd. Which is not
ideal, but better than NOT being able to support it.

Only other option I see is to to provide an io_uring_register()
command to update the fd/file associated with it. Which may be useful,
it allows a process to indeed to this, if it absolutely has to.

-- 
Jens Axboe

