Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC4B12101E
	for <lists+io-uring@lfdr.de>; Mon, 16 Dec 2019 17:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLPQwB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 11:52:01 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46261 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQwB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 11:52:01 -0500
Received: by mail-io1-f66.google.com with SMTP id t26so7244714ioi.13
        for <io-uring@vger.kernel.org>; Mon, 16 Dec 2019 08:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cSYB4VDYBn9+UOY67DLcEBptjFhY+ZTaH1LL49YdtyE=;
        b=BRZqrodXA5SCaDVjC2jOyoJzx31f79hHYU0D5pX0lEM6Rfv1r0XajCAN44q4UZbtfD
         HsMCewg+vlraUjyReNSq0xV0eBLrBkYFhKPUxkOhFNHQDpKBC/7eRvQXkCTcEpcKv1bH
         zC6yZd+9vp5VM7/O0rpcCPT5vsK6PJZwtEc9TFt7pBUUZTjod9ILLCUzS2ynnsptDHXY
         nZoTXe2PCFHgpuH89YD5tXT/+Obj5nK2mlfPLQ5RK2D9MgZqNLllq+/S7WEiz1LUiE3q
         B9eSaA8NCTS6wMZEXrHoZBFaVyiwEzLnAZ8aRQi8pB0+wnY5cIFvwl/5vLZBE7GS4hEN
         I1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cSYB4VDYBn9+UOY67DLcEBptjFhY+ZTaH1LL49YdtyE=;
        b=r53Oa/2z4t3b98DhGL2PbSpodEANfm8SfGa6EI+AUSEV1TyWK94e9aDyKYesHkhfvF
         /qztMMgPHlmcd20KsMYYiUU0UwLhJ17NnrL43XDSUeQCdC70/TqbYW/Nfe3xn9bPYPPu
         TaWsU8l1spw9BaPzkn1jXRA2R4pOWoig5H2TIf3ZT5oBU8XS6pmBhofcwHtnQySm/VZO
         yVH8SGry1h6tnF41u1lE5ZgsE0btDeBBzN1DLcg0KFUrYoUy5dpznH+fW/YINYxwxbDG
         Q+oBCexLiSyVQAhH/RNR8SmMPhJFniy2VURBCbfCp/WN2qHNV10OfcsdXknvPgT2IO2Q
         TxfA==
X-Gm-Message-State: APjAAAWcOc/V8CUZ/BQd3jA4nHw2Ov+0rVt3AWNAhbpfn4dsPK7mdGKa
        4pHBjn1iYw/DSdnaIcJ/B4Mihw==
X-Google-Smtp-Source: APXvYqyM3ZBL4qMsfF/1+963iDOGt0Z7NbVXph1BwFYa4ifzVCJCuiHtTadM0lmyITafZI42K9FWww==
X-Received: by 2002:a5d:9eda:: with SMTP id a26mr19373162ioe.238.1576515120598;
        Mon, 16 Dec 2019 08:52:00 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b145sm3648590iof.60.2019.12.16.08.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:52:00 -0800 (PST)
Subject: Re: [PATCH v3] io_uring: don't wait when under-submitting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <c6f625bdb27ea3b929d0717ebf2aaa33ad5410da.1576335142.git.asml.silence@gmail.com>
 <a1f0a9ed-085f-dd6f-9038-62d701f4c354@kernel.dk>
 <3a102881-3cc3-ba05-2f86-475145a87566@kernel.dk>
 <900dbb63-ae9e-40e6-94f9-8faa1c14389e@gmail.com>
 <9b422273-cee6-8fdb-0108-dc304e4b5ccb@kernel.dk>
 <279b9435-6050-c15a-440d-c196c6184556@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff49ace9-9d9a-a760-7fc0-325631a8b87c@kernel.dk>
Date:   Mon, 16 Dec 2019 09:51:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <279b9435-6050-c15a-440d-c196c6184556@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/19 9:47 AM, Pavel Begunkov wrote:
> On 16/12/2019 00:33, Jens Axboe wrote:
>> On 12/15/19 8:48 AM, Pavel Begunkov wrote:
>>> On 15/12/2019 08:42, Jens Axboe wrote:
>>>> On 12/14/19 11:43 AM, Jens Axboe wrote:
>>>>> On 12/14/19 7:53 AM, Pavel Begunkov wrote:
>>>>>> There is no reliable way to submit and wait in a single syscall, as
>>>>>> io_submit_sqes() may under-consume sqes (in case of an early error).
>>>>>> Then it will wait for not-yet-submitted requests, deadlocking the user
>>>>>> in most cases.
>>>>>>
>>>>>> In such cases adjust min_complete, so it won't wait for more than
>>>>>> what have been submitted in the current call to io_uring_enter(). It
>>>>>> may be less than totally in-flight including previous submissions,
>>>>>> but this shouldn't do harm and up to a user.
>>>>>
>>>>> Thanks, applied.
>>>>
>>>> This causes a behavioral change where if you ask to submit 1 but
>>>> there's nothing in the SQ ring, then you would get 0 before. Now
>>>> you get -EAGAIN. This doesn't make a lot of sense, since there's no
>>>> point in retrying as that won't change anything.
>>>>
>>>> Can we please just do something like the one I sent, instead of trying
>>>> to over-complicate it?
>>>>
>>>
>>> Ok, when I get to a compiler.
>>
>> Great, thanks. BTW, I noticed when a regression test failed.
>>
> 
> Yeah, I properly tested only the first one. Clearly, not as easy as
> I thought, and there were more to consider.
> 
> I sent the next version, but that's odd basically taking your code.
> Probably, it would have been easier for you to just commit it yourself.

Nah, I'll keep you attribution, the hard part is finding/spotting the
issue, not the actual fix. I've applied v4, thanks Pavel!

-- 
Jens Axboe

