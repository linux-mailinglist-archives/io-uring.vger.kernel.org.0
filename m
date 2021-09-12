Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A5F4081E0
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 23:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhILVgE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 17:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbhILVgD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 17:36:03 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAE7C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 14:34:49 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id a1so8012599ilj.6
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 14:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pdKw5k7ecp4XENL98dMLYLW7VzG3PaPRoy2VonmyzMQ=;
        b=T1pow4nGZOPgIOUTAGDIWxr5pjW+RcPuQZfKXDUf4ECPxq414G6apYctCEfrXM0S6K
         MIy5dMirObKiOQoDsa+GkOmo9z7WuhDcxln12ReUSjAPaFTaQRELTtGFpjjkrPgeTA+T
         RTX6MOhMgRKwS/ahDmjeHxF1k4F7aL82W4hiRWbfJOuj4WfVWcDeSsyOf/en14AE8xtW
         Zec0Z4NDQWJpi3VXILMuqT2Xay2/xeqN440RA78kZsRx4MZiIWbb5VSv/vYQ0RQSZMeF
         F+86h9cNSekdt6PhYyN4aaoJTakEaZ2+t0//7qfYypUh3L8Wl2Y9DFhfxyiOwOPyKPEQ
         1VFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pdKw5k7ecp4XENL98dMLYLW7VzG3PaPRoy2VonmyzMQ=;
        b=0uRtjU1VIGB1cjXGuT49GysHg0L1Ujz/CqyIRnwJCtzcX3RqeEVqC3afdnTl+tLfYg
         fNggR1KQtclE8RM4RVjNSJ0RgZAY+ez5F4EB6e85g3ENA9jS6OhFqzRUdtCYKqfoj31m
         D1y9C89FCXY+5PJxNTt9mDpyyIhDLj4LbVLZckSOnEcOWw0kBNC/0ZbMN1oOc33cAM4/
         /ZBW6juvg3qtLYTXbCICtCUMK+BoBaoC9Si9HpgXhvUNTzWxC2TMZi1zZjGv9KWvMqGs
         sItJJamRZ7uBstJl40d4fLxKoOX8sWrlzWY1f/WGGq0LOSMJVU2Da8ojXduwfuP7XreP
         YD0A==
X-Gm-Message-State: AOAM533XQGWlZEHHOND00WigdAE86+utDmMANQZB/9HkEbevuxxIRuo6
        +SD48xLIEaybxZKYdIVwwlMH4w==
X-Google-Smtp-Source: ABdhPJySWiZPf8wL0N51di3XU/k/6u/Z+bzTjKQdwIMiQwyGZuRIOwi60nsH8NTmisZt9h7RAFy4kQ==
X-Received: by 2002:a92:ca82:: with SMTP id t2mr1566378ilo.151.1631482488498;
        Sun, 12 Sep 2021 14:34:48 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t25sm3329310ioh.51.2021.09.12.14.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 14:34:47 -0700 (PDT)
Subject: Re: [PATCH 1/4] io-wq: tweak return value of io_wqe_create_worker()
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-2-haoxu@linux.alibaba.com>
 <9c01cd26-a569-7a99-964a-9436c8baa57f@kernel.dk>
 <1175a5b4-5c95-ff84-22cd-355590946e87@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06e27618-8b47-f926-5c7e-5346423006ea@kernel.dk>
Date:   Sun, 12 Sep 2021 15:34:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1175a5b4-5c95-ff84-22cd-355590946e87@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 1:02 PM, Hao Xu wrote:
> 在 2021/9/13 上午2:10, Jens Axboe 写道:
>> On 9/11/21 1:40 PM, Hao Xu wrote:
>>> The return value of io_wqe_create_worker() should be false if we cannot
>>> create a new worker according to the name of this function.
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io-wq.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index 382efca4812b..1b102494e970 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -267,7 +267,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>>>   		return create_io_worker(wqe->wq, wqe, acct->index);
>>>   	}
>>>   
>>> -	return true;
>>> +	return false;
>>>   }
>>
>> I think this is just a bit confusing. It's not an error case, we just
>> didn't need to create a worker. So don't return failure, or the caller
>> will think that we failed while we did not.
> hmm, I think it is an error case----'we failed to create a new worker
> since nr_worker == max_worker'. nr_worker == max_worker doesn't mean
> 'no need', we may meet situation describled in 4/4: max_worker is 1,

But that's not an error case in the sense of "uh oh, we need to handle
this as an error". If we're at the max worker count, the work simply has
to wait for another work to be done and process it.

> currently 1 worker is running, and we return true here:
> 
>            did_create = io_wqe_create_worker(wqe, acct);
> 
>               //*******nr_workers changes******//
> 
>            if (unlikely(!did_create)) {
>                    raw_spin_lock(&wqe->lock);
>                    /* fatal condition, failed to create the first worker */
>                    if (!acct->nr_workers) {
>                            raw_spin_unlock(&wqe->lock);
>                            goto run_cancel;
>                    }
>                    raw_spin_unlock(&wqe->lock);
>            }
> 
> we will miss the next check, but we have to do the check, since
> number of workers may decrease to 0 in //******// place.

If that happens, then the work that we have inserted has already been
run. Otherwise how else could we have dropped to zero workers?

-- 
Jens Axboe

