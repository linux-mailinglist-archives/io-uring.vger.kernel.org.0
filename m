Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359D143187F
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhJRMME (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJRMME (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:12:04 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E261AC06161C
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:09:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m22so41155418wrb.0
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TFuv9exM7OkP61snDhoz2jH88cod/tOM788OnelR/8Y=;
        b=erontA5anwxzC5YrjRuLIKrboChph+3MJkN/id+UPTmlMHLclFKJNzGKxE/lUaPR13
         BkZVYF+FyRuttr+nX6BepnsCIZ/EnTUEQqN2Twzr2PYsJHuAgAt22wUWOg92HPSjpOQm
         89fNekRAyEoMfzWDVdaI0d9MRyLf9czLALNrH98R2zyOHUQXfMjzrW/Cvc6FJCT3kuk8
         OSQjwviXEH9QdFE8MsYirqr5+SMETL04nf7inHtu7sEQVtBoRbIVB2syi38X0KHC9Q0U
         RMgdlZrdg0Fu/rlf3rWoZUzDq6BqfgIuQRjmr7S20pNCkRIpQmRMC6prrz8HHq1ljeH6
         u8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TFuv9exM7OkP61snDhoz2jH88cod/tOM788OnelR/8Y=;
        b=qpzF4WHI9stqxDAtRrN6JrKSzIQmKjHDHwkUG7uSKwVcQlY3bgPiUjU8uQn7ZqvNSg
         j+cTWttFvdtCyUGa2aqmxJqWgNe4MbTGca0SrACbwIUg1napmcVELXxttcf36f58cxyh
         BKVFLz/gL8+vCFfcEw27oCKvAUFlATE5i3p/iV2JCKSN/k/OA6FAuQF8DTzUrQzxUpGM
         rrvzKkdFO1lyyyqdmN/qGIc9IXovYXareG5aEAXqSQveYIshQljBz+HNQ7HYkT5BWD5f
         +g6oHzwsBMSYFwCqCd+lRW9If18+iYuPmuljmFQCb1Gp53SOo8euT5A+GBsYr8lAXphU
         aUEw==
X-Gm-Message-State: AOAM533Bq9Gl+KOzs70wtjs05oMyyuVwUvfvUGs/Ey//GbHKq5sNsoyk
        mrTzGbtML0RGTZiTE3vtQZgcOOynFLg=
X-Google-Smtp-Source: ABdhPJz6HwULpff5ixq5mJsm5d8T91U2ukfTzsB3ijCgagowY2dZopIpCPi2ZQSzp9xNFrn7XGW41w==
X-Received: by 2002:a5d:598a:: with SMTP id n10mr35197836wri.81.1634558991451;
        Mon, 18 Oct 2021 05:09:51 -0700 (PDT)
Received: from [192.168.43.77] (82-132-230-135.dab.02.net. [82.132.230.135])
        by smtp.gmail.com with ESMTPSA id t11sm12399424wrz.65.2021.10.18.05.09.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:09:51 -0700 (PDT)
Message-ID: <30f3642e-972b-fa0f-6ce5-2208a29dad4d@gmail.com>
Date:   Mon, 18 Oct 2021 12:10:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/2] io_uring: implement async hybrid mode for pollable
 requests
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018112923.16874-1-haoxu@linux.alibaba.com>
 <20211018112923.16874-3-haoxu@linux.alibaba.com>
 <07ecb722-bf42-b785-2064-79221a3362cc@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <07ecb722-bf42-b785-2064-79221a3362cc@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/21 11:34, Hao Xu wrote:
> 在 2021/10/18 下午7:29, Hao Xu 写道:
>> The current logic of requests with IOSQE_ASYNC is first queueing it to
>> io-worker, then execute it in a synchronous way. For unbound works like
>> pollable requests(e.g. read/write a socketfd), the io-worker may stuck
>> there waiting for events for a long time. And thus other works wait in
>> the list for a long time too.
>> Let's introduce a new way for unbound works (currently pollable
>> requests), with this a request will first be queued to io-worker, then
>> executed in a nonblock try rather than a synchronous way. Failure of
>> that leads it to arm poll stuff and then the worker can begin to handle
>> other works.
>> The detail process of this kind of requests is:
>>
>> step1: original context:
>>             queue it to io-worker
>> step2: io-worker context:
>>             nonblock try(the old logic is a synchronous try here)
>>                 |
>>                 |--fail--> arm poll
>>                              |
>>                              |--(fail/ready)-->synchronous issue
>>                              |
>>                              |--(succeed)-->worker finish it's job, tw
>>                                             take over the req
>>
>> This works much better than the old IOSQE_ASYNC logic in cases where
>> unbound max_worker is relatively small. In this case, number of
>> io-worker eazily increments to max_worker, new worker cannot be created
>> and running workers stuck there handling old works in IOSQE_ASYNC mode.
>>
>> In my 64-core machine, set unbound max_worker to 20, run echo-server,
>> turns out:
>> (arguments: register_file, connetion number is 1000, message size is 12
>> Byte)
>> original IOSQE_ASYNC: 76664.151 tps
>> after this patch: 166934.985 tps
>>
>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> An irrelevant question: why do we do linked timeout logic in
> io_wq_submit_work() again regarding that we've already done it in
> io_queue_async_work().

Because io_wq_free_work() may enqueue new work (by returning it)
without going through io_queue_async_work(), and we don't care
enough to split those cases.

-- 
Pavel Begunkov
