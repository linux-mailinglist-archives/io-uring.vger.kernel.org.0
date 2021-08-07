Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B0A3E35C1
	for <lists+io-uring@lfdr.de>; Sat,  7 Aug 2021 15:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhHGNv5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Aug 2021 09:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhHGNvv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Aug 2021 09:51:51 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A71C061798
        for <io-uring@vger.kernel.org>; Sat,  7 Aug 2021 06:51:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t3so11098288plg.9
        for <io-uring@vger.kernel.org>; Sat, 07 Aug 2021 06:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yu5DkAPxZAmQsSkYbTiUTibl3qSkdXEajYFtFy+DWpE=;
        b=GwMFdP7rhq7R+TXDHd8MyO9YHh3G/qEaXsuFngTAmb0yLUMZa912rsQl421OwYuc+g
         TWVF+ogjBxcwSBSQ2Yau5MZqY+2SRpHIh6Y5+ksXRIBrVmTcRK5X/6v8+8NW+RIZ8sJZ
         +sJdqzgAh8HyGmkh4PhgZFOFDUpaDHt/j050sW2PPHVGEMYyNHy5Z9KSiJ8d4Zfpk5Zs
         oIj4CmAZiECkav3pNW9BmcMCNFl0ZrNFGLnCtc1/wD7+oPW+dktq7ap452XfF7RtFdgN
         7rVdx5ZB0kv4t8tyWpSDmhNrtvdrVt/TcI8nB5Q5sUBaVCEF4ivmqHrNG8eMej6fw2Yz
         PyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yu5DkAPxZAmQsSkYbTiUTibl3qSkdXEajYFtFy+DWpE=;
        b=F7tFBLqhyFrQhRm6y5zj0BC1A7YP7Ljdw7bErvaOxFxjTdnNFcpJg2mwrBCeOk7bnH
         8uD635q/Gh/W/DXa1xEVHlueoX7axARArif6JlQgW/V7AS4iszIrr/CtX82fD45bBoyx
         IPene/cZaYzrfy+MN/Dzhg/W5Lm2pJch3ic45ptAElwVgI57VVQirN3aYCEi0CgKx6jB
         ZnR7LRP5JURNnFuoy5RZvtPm2BPwBkOtIxQS3EDyWbtJGOhXcE0wk+eCQ5J2vEmA7hZj
         mLsu91W/913eUi5DkqdMS07iGytd6iN0LGU/+9itCCxL91M00AgRhoftpNN1f+uJItQ6
         uJIQ==
X-Gm-Message-State: AOAM5336wDA54qUbqAcF/OBMqiWrKw5l+92AS1Hj0UVTHvfK2W+RFHF4
        PbERBnDqyJviEaPuTbf++mQQYw==
X-Google-Smtp-Source: ABdhPJzgGSI0mHAVl4tWu3ryoz8CW2olRLjJ+BA9+kBEjCV7uva0Pq9kMP8emaTY4MSDPj4MmayGMA==
X-Received: by 2002:a17:90a:7447:: with SMTP id o7mr13752096pjk.35.1628344293378;
        Sat, 07 Aug 2021 06:51:33 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id l13sm12473650pjh.15.2021.08.07.06.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Aug 2021 06:51:32 -0700 (PDT)
Subject: Re: [PATCH 2/3] io-wq: fix no lock protection of acct->nr_worker
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
 <20210805100538.127891-3-haoxu@linux.alibaba.com>
 <cc9e61da-6591-c257-6899-d2afa037b2ad@kernel.dk>
 <1f795e93-c137-439e-b02c-b460cb38bb14@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5f4b7861-de78-8b45-644f-3a9efe3af964@kernel.dk>
Date:   Sat, 7 Aug 2021 07:51:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1f795e93-c137-439e-b02c-b460cb38bb14@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/21 3:56 AM, Hao Xu wrote:
> 在 2021/8/6 下午10:27, Jens Axboe 写道:
>> On Thu, Aug 5, 2021 at 4:05 AM Hao Xu <haoxu@linux.alibaba.com> wrote:
>>>
>>> There is an acct->nr_worker visit without lock protection. Think about
>>> the case: two callers call io_wqe_wake_worker(), one is the original
>>> context and the other one is an io-worker(by calling
>>> io_wqe_enqueue(wqe, linked)), on two cpus paralelly, this may cause
>>> nr_worker to be larger than max_worker.
>>> Let's fix it by adding lock for it, and let's do nr_workers++ before
>>> create_io_worker. There may be a edge cause that the first caller fails
>>> to create an io-worker, but the second caller doesn't know it and then
>>> quit creating io-worker as well:
>>>
>>> say nr_worker = max_worker - 1
>>>          cpu 0                        cpu 1
>>>     io_wqe_wake_worker()          io_wqe_wake_worker()
>>>        nr_worker < max_worker
>>>        nr_worker++
>>>        create_io_worker()         nr_worker == max_worker
>>>           failed                  return
>>>        return
>>>
>>> But the chance of this case is very slim.
>>>
>>> Fixes: 685fe7feedb9 ("io-wq: eliminate the need for a manager thread")
>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>> ---
>>>   fs/io-wq.c | 17 ++++++++++++-----
>>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index cd4fd4d6268f..88d0ba7be1fb 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -247,9 +247,14 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
>>>          ret = io_wqe_activate_free_worker(wqe);
>>>          rcu_read_unlock();
>>>
>>> -       if (!ret && acct->nr_workers < acct->max_workers) {
>>> -               atomic_inc(&acct->nr_running);
>>> -               atomic_inc(&wqe->wq->worker_refs);
>>> +       if (!ret) {
>>> +               raw_spin_lock_irq(&wqe->lock);
>>> +               if (acct->nr_workers < acct->max_workers) {
>>> +                       atomic_inc(&acct->nr_running);
>>> +                       atomic_inc(&wqe->wq->worker_refs);
>>> +                       acct->nr_workers++;
>>> +               }
>>> +               raw_spin_unlock_irq(&wqe->lock);
>>>                  create_io_worker(wqe->wq, wqe, acct->index);
>>>          }
>>>   }
>>
>> There's a pretty grave bug in this patch, in that you no call
>> create_io_worker() unconditionally. This causes obvious problems with
>> misaccounting, and stalls that hit the idle timeout...
>>
> This is surely a silly mistake, I'll check this patch and the 3/3 again.

Please do - and please always run the full set of tests before sending
out changes like this, you would have seen the slower runs and/or
timeouts from the regression suite. I ended up wasting time on this
thinking it was a change I made that broke it, before then debugging
this one.

-- 
Jens Axboe

