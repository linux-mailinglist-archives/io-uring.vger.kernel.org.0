Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A6C262EF5
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 15:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbgIINKS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730288AbgIINKK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 09:10:10 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02605C061573
        for <io-uring@vger.kernel.org>; Wed,  9 Sep 2020 06:10:16 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b17so2255152ilh.4
        for <io-uring@vger.kernel.org>; Wed, 09 Sep 2020 06:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JIwMMJvy8NSR72GjBzf/1/n1e32e3HoQ0TG7hZ1Z8iY=;
        b=1fqoKCS93zomLAPLYFvtAADRsHANxVXZwhlJs4tKEkEQ6NgNLNx44zLMvPqRizkaB/
         b353JlemoegUZRgbeuZgIdY70GYzGeNYmhouqB014tqkp81r2xPaGP4WISGueCic1R/x
         Gyts3eWmogG8gT4sJhrTfZHMxmeUIGhevruSBQ00BXbP+D5vZxmARtbeitKoV+wPAOfJ
         bQJ3QlU89dGcOtoySKm1UF+dYaPEelrsUZFlQYpoRKRfMAwU+HRsOZ4OaP1Ca7pXkgWY
         6zLhclNIMuaKzIHe3thwgUtkW40osedNEdl0985S5lBwtEVbUtpz1jLgFMCg4BmMr3DG
         AKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JIwMMJvy8NSR72GjBzf/1/n1e32e3HoQ0TG7hZ1Z8iY=;
        b=PAXJgwkHr0zV3ZNXa2JIsq2cP3olvRjkAw+yO34JojQFHqzLEv4TrpV1nNen2rInVk
         n1WHWOtEK2ewaW6rrSeAIVMz0tW12k1SsJy6RgpiI7zf3hsHZ2wNDi2rE9T8aqrs7UO4
         x4v0JXElZBpjyNPlXL3zLC4XW5HuHxmwwntJbMQaKUhtREgpnCj+2v/8jAVilSPaSASU
         IBLo3I5cidX3gR/J3B7HT6a+XBZWB/6HWMKR2u90Rxxq2cjMwLYjfE5YHBPdKM5g2g8o
         3bcpOF7gGfhisZNcMS9P1yHtnu1N3G4jd9MbxcNuBU2pjX+LQXlejiW4537v2AwiYPjJ
         vBrg==
X-Gm-Message-State: AOAM53343cT9cCF8MqhaB2DwHFxJTEAutoUX0Ko4zI0a8zPUK/SY1ztO
        frZc7vDcgoMOMUlT1upRtqicXhfpp3iX7ita
X-Google-Smtp-Source: ABdhPJzbEeD9ds27pvC9J/pkP6BaSGrAh+j7vhjgy/O+QrbmWJMvj2AzjOp44FvsnATm1GRiKcAMDA==
X-Received: by 2002:a92:9986:: with SMTP id t6mr3565849ilk.28.1599657014332;
        Wed, 09 Sep 2020 06:10:14 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c12sm1337000ilm.17.2020.09.09.06.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 06:10:12 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
 <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
 <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
 <801ed334-54ea-bdee-4d81-34b7e358b506@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <370c055e-fa8d-0b80-bd34-ba3ba9bc6b37@kernel.dk>
Date:   Wed, 9 Sep 2020 07:10:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <801ed334-54ea-bdee-4d81-34b7e358b506@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/20 1:09 AM, Pavel Begunkov wrote:
> On 09/09/2020 01:54, Jens Axboe wrote:
>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>
>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>
>>>> And it looks strange that the following snippet will effectively disable
>>>> such requests.
>>>>
>>>> fd = dup(ring_fd)
>>>> close(ring_fd)
>>>> ring_fd = fd
>>>
>>> Not disagreeing with that, I think my initial posting made it clear
>>> it was a hack. Just piled it in there for easier testing in terms
>>> of functionality.
>>>
>>> But the next question is how to do this right...> 
>> Looking at this a bit more, and I don't necessarily think there's a
>> better option. If you dup+close, then it just won't work. We have no
>> way of knowing if the 'fd' changed, but we can detect if it was closed
>> and then we'll end up just EBADF'ing the requests.
>>
>> So right now the answer is that we can support this just fine with
>> SQPOLL, but you better not dup and close the original fd. Which is not
>> ideal, but better than NOT being able to support it.
>>
>> Only other option I see is to to provide an io_uring_register()
>> command to update the fd/file associated with it. Which may be useful,
>> it allows a process to indeed to this, if it absolutely has to.
> 
> Let's put aside such dirty hacks, at least until someone actually
> needs it. Ideally, for many reasons I'd prefer to get rid of

BUt it is actually needed, otherwise we're even more in a limbo state of
"SQPOLL works for most things now, just not all". And this isn't that
hard to make right - on the flush() side, we just need to park/stall the
thread and clear the ring_fd/ring_file, then mark the ring as needing a
queue enter. On the queue enter, we re-set the fd/file if they're NULL,
unpark/unstall the thread. That's it. I'll write this up and test it.

> fcheck(ctx->ring_fd) in favour of synchronisation in io_grab_files(),
> but I wish I knew how.

That'd be nice, and apply equally to all cases as the SQPOLL case isn't
special at all anymore.

-- 
Jens Axboe

