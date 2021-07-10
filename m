Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA243C3530
	for <lists+io-uring@lfdr.de>; Sat, 10 Jul 2021 17:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhGJPjF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Jul 2021 11:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhGJPjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Jul 2021 11:39:05 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B42C0613DD
        for <io-uring@vger.kernel.org>; Sat, 10 Jul 2021 08:36:20 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id j12so14056114ils.5
        for <io-uring@vger.kernel.org>; Sat, 10 Jul 2021 08:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b7Lc1iLrx/e154sCsDjQpLM5Z3Sx/iaS2CEzB5/sIwc=;
        b=AIIrBrQMOtV6H/nAXgyrzzDb2C4zzA/FQj027dw7kPAyaRF3guq7SeKjDW9ljxsose
         XSRt8LotQCLTzTKXVLoMQlk4lrOtkKfrJn2SuL8tMuzLC5b/CzYxzXaVo+HFsRPL/tsS
         tWUJ6IZRVDGMvjA5yDnYJMgX+4D3XSut+TE2TWoy+utcdWExb2NOOVJvd8JpAe+FpkgX
         hJfYt1+hSRwgVb0g1/gyNwyAxeZIDEYZLbKh/cAT7FrjKfTG55DcgLv3ORs69mwkkTmL
         HR+TKlog0nZq/36S+dc7aba8RlEijAxxjgOm4rouXGK+BdAno377MHcBYs4ueXz/gv/6
         KVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b7Lc1iLrx/e154sCsDjQpLM5Z3Sx/iaS2CEzB5/sIwc=;
        b=rI4ihh5/hj3BmFNCPSNV12VkHqDU/tuSxdq3fnLfX8nQ4hyRPWBl9rfiMvzMV/TDgN
         ijpMdkQn7LJm2V69+amOf9yc2eQGEKtPS6FADA71BYqlJUL4RQVkEOoP2RmIjxM5S2le
         1vvxE77ye9gVQS6TO3bTdLf75QHh7fzub880G2RtGvTcyVuSZMx3vOx1osTwJSWJV2Vk
         HyjJ71YmOL0ySck06sO9cyt/QZ3ioKxC8k0zx+e3z9uBw1YcSTKBl7ForsbPvO9MyxKV
         QGvai1u//vysWMjgpH1viOBVHApZQR6S/nlXtmpqzpBgd6BO4HN5gEZ41qLvD0W6pB8G
         uzsA==
X-Gm-Message-State: AOAM533L6POseyI9pQVBBlrONrAAtFwlav54YPZGukw71YqeycOpHg2g
        K9sIiSnyX/ynrVdoCFcb0izzrg9yqvQQPw==
X-Google-Smtp-Source: ABdhPJwjqZXTvvBcpEeS0B9cFY7BrIpUWiHQg0dn9NmFI6WiS4RKt4PD54RGmEAVLJZSiZ4IN+HLzw==
X-Received: by 2002:a92:c150:: with SMTP id b16mr4749449ilh.54.1625931379533;
        Sat, 10 Jul 2021 08:36:19 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id i7sm4566789ilb.67.2021.07.10.08.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jul 2021 08:36:19 -0700 (PDT)
Subject: Re: [PATCH 5.14] io_uring: use right task for exiting checks
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <cb413c715bed0bc9c98b169059ea9c8a2c770715.1625881431.git.asml.silence@gmail.com>
 <7b465849-f046-530f-42a2-8e42d54bdca7@kernel.dk>
 <211e5eb7-7af0-0e15-5a03-4b1fd4958875@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb26d9cc-9d82-a82e-3fd1-03f3fec48a8a@kernel.dk>
Date:   Sat, 10 Jul 2021 09:36:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <211e5eb7-7af0-0e15-5a03-4b1fd4958875@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/10/21 8:07 AM, Pavel Begunkov wrote:
> On 7/10/21 2:40 PM, Jens Axboe wrote:
>> On Fri, Jul 9, 2021 at 7:46 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> When we use delayed_work for fallback execution of requests, current
>>> will be not of the submitter task, and so checks in io_req_task_submit()
>>> may not behave as expected. Currently, it leaves inline completions not
>>> flushed, so making io_ring_exit_work() to hang. Use the submitter task
>>> for all those checks.
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 7167c61c6d1b..770fdcd7d3e4 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2016,7 +2016,7 @@ static void io_req_task_submit(struct io_kiocb *req)
>>>
>>>         /* ctx stays valid until unlock, even if we drop all ours ctx->refs */
>>>         mutex_lock(&ctx->uring_lock);
>>> -       if (!(current->flags & PF_EXITING) && !current->in_execve)
>>> +       if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
>>>                 __io_queue_sqe(req);
>>>         else
>>>                 io_req_complete_failed(req, -EFAULT);
>>
>> I don't think that ->in_execve check is useful anymore now that we don't
>> have weak references to the files table, so it should probably just go
>> away.
> 
> Had such a thought but from the premise that on exec we wait / cancel
> all requests. But I'd rather to leave it to a separate commit for-next,
> don't you think so?

Yes, probably best left for for-next. I'll apply this one as-is, thanks.

-- 
Jens Axboe

