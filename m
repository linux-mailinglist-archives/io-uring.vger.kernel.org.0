Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560FF205B56
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 21:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbgFWTBd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 15:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733138AbgFWTBd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 15:01:33 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A70C061573
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 12:01:32 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b13so97141ilq.11
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 12:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fyjbQaae0NsOAvrxvCCKUMOuMj6tKFODQMatWItt/Yc=;
        b=12ocHWdATKVhsusr9pw/ZzGbXNfGtGLgEK7lm+zqveEaASn/HtWRW2GyDQmdikfU6f
         e18yFxs95bPGbophgL9JMyevGdF0L66cCZfwqInWflTALvAptqBlMIlcmAT9rkwzESoM
         0yiDj2Tk1/5aRWSXk+l/IuKOYh/sSh0syTDEFs85yK7KJV0Z4JyCBZlxLwbEALH7bXwy
         6SAlUFkaKhF60lU5GYI+5gZyRNhJIC1PcCv4+Q9Sdv2t8ofszYIOD8Ru60lcLobD290X
         Cru1NqHkveGwCFHx+evF3MGY1lyafhaeqHwASnFOO0L6qXkzBU+xIoypXABzh6GGwL16
         8OLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fyjbQaae0NsOAvrxvCCKUMOuMj6tKFODQMatWItt/Yc=;
        b=uO0xLaFGVePfcTwxng0H3j+bLNZznzHLDGbgy7wNuAZ3PoQkda9W+YpT/cySaWysDI
         AnPzCAwNAfcL9Vuzf1oXJ+dabxwvF4g1ALM+m/v7d5eHy2I5qMN4qgKhhVnpT72UEluc
         Ro+54EpBnbeMxKG/IuwYWfGbYPVDZZX7lKfaXDbuR2LsKeMTaUVD1v+TSJK+uqWGIzla
         oS9kFJU/P6W2qtkDaXRIrmdJYh9J5FLtFdW/M0pwnAVQ2b7cMcvBBbt7ml1K24q7ODco
         JeyU6zzTr6YpxmCMV9MI1nTYDXm7s6fiV19kHX1y3yQ9FeR1KMaEF39Gx0Y5lPDUv52U
         yYKA==
X-Gm-Message-State: AOAM531awpRzhI27XPFHGU4ElGqAVnExvKawBz+hq7gZlyC38d7CGW2z
        j75CNKWqyAHfkav0nM5qyNqpxA==
X-Google-Smtp-Source: ABdhPJx2qOhZ90hWWKWjZSXmgBG+jZ0cb1KjGKxfREseIBLwZFd60CYItW4YPTyH592gZ4j9aQp9kQ==
X-Received: by 2002:a92:d789:: with SMTP id d9mr12228762iln.107.1592938892319;
        Tue, 23 Jun 2020 12:01:32 -0700 (PDT)
Received: from [192.168.1.56] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t5sm10769796iov.53.2020.06.23.12.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 12:01:31 -0700 (PDT)
Subject: Re: [PATCH 1/4] io_uring: fix hanging iopoll in case of -EAGAIN
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1592863245.git.asml.silence@gmail.com>
 <0301f35644823a01cbae87e440df7d58ebcf2279.1592863245.git.asml.silence@gmail.com>
 <95b720a6-926c-a208-e929-1d0203fa8701@kernel.dk>
 <e05fc48b-684d-2980-3986-47a77af403e0@kernel.dk>
 <6714cb8f-894c-9ff1-7b3a-4f86d7dbe52a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d33e9006-b7ef-4925-ff3f-332ab655f2ae@kernel.dk>
Date:   Tue, 23 Jun 2020 13:01:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6714cb8f-894c-9ff1-7b3a-4f86d7dbe52a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/20 5:57 AM, Pavel Begunkov wrote:
> On 23/06/2020 05:18, Jens Axboe wrote:
>> On 6/22/20 8:07 PM, Jens Axboe wrote:
>>> On 6/22/20 4:16 PM, Pavel Begunkov wrote:
>>>> io_do_iopoll() won't do anything with a request unless
>>>> req->iopoll_completed is set. So io_complete_rw_iopoll() has to set
>>>> it, otherwise io_do_iopoll() will poll a file again and again even
>>>> though the request of interest was completed long ago.
>>>
>>> I need to look at this again, because with this change, I previously
>>> got various use-after-free. I haven't seen any issues with it, but
>>> I agree, from a quick look that I'm not quite sure how it's currently
>>> not causing hangs. Yet I haven't seen any, with targeted -EAGAIN
>>> testing.
> 
> Can io_complete_rw_iopoll() get -EAGAIN after being successfully enqueued
> (i.e. EIOCBQUEUED)? It's reliably fails for me, because my hacked nullblk
> _can_ (i.e. probabilistically returns BLK_STS_AGAIN from ->iopoll()).

Yes it can. The primary example would be a polled bio that gets split, into
let's say 4 bio's. First one queues fine, but one of the subsequent ones
run into request allocation failures and it gets marked as -EAGAIN.

>> Ah I think I know what it is - if we run into:
>>
>> if (req->result == -EAGAIN)
>> 	return -EAGAIN
>>
>> in io_issue_sqe() and race with it, we'll reissue twice potentially.
>> So the above isn't quite enough, we'll need something a bit broader.
> 
> I see, I'll deal with it.

Thanks!

-- 
Jens Axboe

