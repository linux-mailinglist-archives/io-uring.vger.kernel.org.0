Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5588043B4B3
	for <lists+io-uring@lfdr.de>; Tue, 26 Oct 2021 16:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbhJZOuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Oct 2021 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbhJZOuW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Oct 2021 10:50:22 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3437EC061745
        for <io-uring@vger.kernel.org>; Tue, 26 Oct 2021 07:47:59 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id i14so1900156ioa.13
        for <io-uring@vger.kernel.org>; Tue, 26 Oct 2021 07:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/K//SLo0Y+BMNWk0PxHavcMOsKu1OzHSVlLTYjFyaoU=;
        b=kny3xphQZ0klhl3nOZiiKdyA97coXOYGxuy4dKY5UkMVNoC3fdEHfhdnhqY4zQKg1u
         uk/+oSwB7UJwlnHJ0/gL867ked/NhdCDabEjJtv57n8IZ0w7cSK+V5dUGR34o7rHfVUI
         Xr8zbByZhmt+eGDj95LsBvXcGqDhGt5BhzKCYKPzAWU1DhsizaMonFuYXC6JghGrKlnX
         l3eng6OQf01I/BdN4szngckWEVAUrrNaZ6MUpWfhieTvfoU8d53qUuvinXxI8jdEFpTm
         2+Alu47TFOajwxtAGf5pZtYIUxmS7b+uFxDTbTkeexS0wJF79nCD/JC9vilc33/bTUVF
         au0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/K//SLo0Y+BMNWk0PxHavcMOsKu1OzHSVlLTYjFyaoU=;
        b=wRBGQ01QR2kHjvSDD3h97/jB1d0Ji8q+34S/ocfjQtvXMRfZLAl/gGEboIjbw1mq3a
         Ek4xWPM687Rm3AN9JWVzWMPZQ1loXHL98hn7b7WBq7nL+xpVerSBfpAsFp+78T1js0o9
         Dchf7dOWiQKv91/3CQm2f2sNAiGD7M+X69qAxOcTaQvOSedSkAHQrtq+EJregXGZ6OR0
         I3oUPIgUH7t2QJjYrGViQjKpVxe7lUhVSzIWDyY9i5pcDDAnZRp/h8ozAWh4TFGVqu/g
         VYfKeZaYAwODVJC2YpMwc9k6clPSzHxS2DxWMPwMT6FachnPB5hlpRqgntU0gJ5Kkm7C
         kXOA==
X-Gm-Message-State: AOAM5334O0yOqUQ2av7EvgkQ5R/xDvks0orQcy6AB6u/ecW/shAkuJSq
        GzDTwuIyEJs4QkuvoJqJ5JNWUA==
X-Google-Smtp-Source: ABdhPJxiSET+2dZ1htluNGBqY+Myo4q/tXjIB5JuspWVqgg9cz+jq8JjsjjKoMGbbsxFXDRUHXavWw==
X-Received: by 2002:a6b:102:: with SMTP id 2mr15394325iob.185.1635259678618;
        Tue, 26 Oct 2021 07:47:58 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s17sm9881740ioc.28.2021.10.26.07.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 07:47:57 -0700 (PDT)
Subject: Re: [PATCH] io-wq: Remove unnecessary rcu_read_lock/unlock() in raw
 spinlock critical section
To:     Muchun Song <songmuchun@bytedance.com>,
        Zqiang <qiang.zhang1211@gmail.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20211026032304.30323-1-qiang.zhang1211@gmail.com>
 <CAMZfGtUXq=nQyijktRaP7xp=sAmVCryTjU4Jo5Z=ufed8arnKQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0efbce2d-1f63-82a7-6479-d8ef062aa90d@kernel.dk>
Date:   Tue, 26 Oct 2021 08:47:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMZfGtUXq=nQyijktRaP7xp=sAmVCryTjU4Jo5Z=ufed8arnKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/26/21 4:32 AM, Muchun Song wrote:
> On Tue, Oct 26, 2021 at 11:23 AM Zqiang <qiang.zhang1211@gmail.com> wrote:
>>
>> Due to raw_spin_lock/unlock() contains preempt_disable/enable() action,
>> already regarded as RCU critical region, so remove unnecessary
>> rcu_read_lock/unlock().
>>
>> Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
>> ---
>>  fs/io-wq.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index cd88602e2e81..401be005d089 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -855,9 +855,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
>>         io_wqe_insert_work(wqe, work);
>>         clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
>>
>> -       rcu_read_lock();
> 
> Add a comment like:
> /* spin_lock can serve as an RCU read-side critical section. */

Note that it's a raw spinlock. Honestly I'd probably prefer if we just leave
it as-is. There are plans to improve the io-wq locking, and a rcu lock/unlock
is pretty cheap.

That said, if resend with a comment fully detailing why it's OK currently,
then I'd be fine with that as well.

-- 
Jens Axboe

