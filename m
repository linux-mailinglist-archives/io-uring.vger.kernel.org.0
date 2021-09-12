Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549F6407F21
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhILSJA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhILSI7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:08:59 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511F4C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:07:45 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a22so9122457iok.12
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EyfyLAOQayuApKCoZj0arcAIc5iI95WoGBVnvE/kIfA=;
        b=WVDczslPbMDevpZZySHYiVGR3ijejfYFBRQNEOK620QXffctAzFmOmuFl18zdI45By
         LOlZmCrPH5tY76aTxT8jARjOkNqmqtHGI19gYJjm9KeujjjLJFqL9E0dqK4qxRWCv7BO
         3Yl3tZieq/nmGVCh/txaUDjBdOLRAJKEJBD5t/6918SzXvBK/qjc38PjH3PU8Hi2X1sy
         E+xD/WI1IqO8BTDPYmTJ8LH0Mqm6Qw2EWqs5LGorW5dJdqp9+bfNjJHFrRc1gATgatMS
         lGd2rdIW0bxF7ruMP5hLlF9miiAOxnXl9vkYMssW2gN0YvOdZoKQeDCbjdMMeH3vxX+S
         5Ldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EyfyLAOQayuApKCoZj0arcAIc5iI95WoGBVnvE/kIfA=;
        b=YkZ450nIERE9hyVMS2KSZedzUb3Dq06b3W6reWqvIu4kueGUvhCWlX5KWCsKakjRJb
         5yH9QTHvoViFsjSTpjtsCULbtf17MAhMoF4yqhStj/7aFDjED8wC3bZlnMtkrYGJZT21
         WdhjIqCg9TVvFvVHcTGNhBVtgvGGrQG4WTeXNrWPjXDIiaE8p/tQGBprR4DF/GBNmYCO
         YRv7LxXeaBp3Ys+3fAVktizLH0yKYySdhcXlxUlWaEH2F3bVdYhmT5SBCQImyjXrtO++
         XLQxkeHAbYWsB4fEWiwFDo1g0ZSUtur15HHC0OlKyh3u87GQr6bFZl1naLLvuy9NVql3
         lUnw==
X-Gm-Message-State: AOAM530IWQR8yQzlCWLPBT/kckl0B22/to/Ior8siPrdr5QLOiQbfqNe
        2mxcxMDajAisnm9+Cmqt1fKi1KNnFBSmqw==
X-Google-Smtp-Source: ABdhPJw0m5TMlsXHDSdt0fvaQ1kH9NCU3NZxdY075yqkBXyhjEifxpbxRUHULidKh3pD9kphgzK7GQ==
X-Received: by 2002:a02:5d45:: with SMTP id w66mr6285442jaa.82.1631470064569;
        Sun, 12 Sep 2021 11:07:44 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e12sm3195637ile.14.2021.09.12.11.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:07:44 -0700 (PDT)
Subject: Re: [PATCH 3/4] io-wq: fix worker->refcount when creating worker in
 work exit
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
 <20210911194052.28063-4-haoxu@linux.alibaba.com>
 <e9ca65e1-46d7-de2d-e897-8cb3393c88f2@kernel.dk>
 <e84feefc-7c71-a55c-1463-e74d800162d9@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2c26f37c-6d4d-1df6-340b-c98ec8b658c6@kernel.dk>
Date:   Sun, 12 Sep 2021 12:07:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e84feefc-7c71-a55c-1463-e74d800162d9@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 3:04 AM, Hao Xu wrote:
> 在 2021/9/12 上午6:13, Jens Axboe 写道:
>> On 9/11/21 1:40 PM, Hao Xu wrote:
>>> We may enter the worker creation path from io_worker_exit(), and
>>> refcount is already zero, which causes definite failure of worker
>>> creation.
>>> io_worker_exit
>>>                                ref = 0
>>> ->io_wqe_dec_running
>>>    ->io_queue_worker_create
>>>      ->io_worker_get           failure since ref is 0
>>>
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io-wq.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index 0e1288a549eb..75e79571bdfd 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -188,7 +188,9 @@ static void io_worker_exit(struct io_worker *worker)
>>>   	list_del_rcu(&worker->all_list);
>>>   	acct->nr_workers--;
>>>   	preempt_disable();
>>> +	refcount_set(&worker->ref, 1);
>>>   	io_wqe_dec_running(worker);
>>> +	refcount_set(&worker->ref, 0);
>>
>> That kind of refcount manipulation is highly suspect. And in fact it
>> should not be needed, io_worker_exit() clears ->flags before going on
>> with worker teardown. Hence you can't hit worker creation from
>> io_wqe_dec_running().
> Doesn't see the relationship between worker->flags and the creation.
> But yes, the creation path does io_worker_get() which causes failure
> if it's from io_worker_exit(), Now I understand it is more like a
> feature, isn't it? Anyway, the issue in 4/4 seems still there.

Right, that's on purpose. In any case, the above would fail miserably
if it raced with someone trying to get a reference on the worker:

A				B
refcount_set(ref, 1)
				io_worker_get(), succeeds now 2
refcount_set(ref, 0)
oops...

-- 
Jens Axboe

