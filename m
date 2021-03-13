Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3F7339B5F
	for <lists+io-uring@lfdr.de>; Sat, 13 Mar 2021 03:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhCMCol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 21:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbhCMCo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 21:44:28 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA07FC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 18:44:26 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso9361016pjb.4
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 18:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2MzvofFGuyerpqsyMOU/XPBcRozoswpnV1DGHYbRxx0=;
        b=OuXcXT6vsBi10nmDfWQ469ds2sy06bzH8+RxrSrrLG2uBVyQlSSYUFnA05EZTSQHHj
         jav+GOKCuUhGYiCYA9/QUkE0NcCjqmXCOvPHi39t2kXq4x9CA1zv3EN8LaNKHLZe6YbT
         QoCeXbSp5aT40E0heJTSk4cZhvSSfWV/FgGGGsJBBBCQyQN58NBWWj5CjS0VxGZWaroF
         n+1KyylVSlanUY1OatkC/JaO1vaL7fw5E8uJ6PbwMdhbPeqXxiLA5zk78C54rnnjvGh6
         GJqKHgHfZhZ7Vet3bgSnHo7Gx1w/5havnmUCSJZYkzQSdWZ/5NMClPiDmrQ52QlyRUi3
         5ZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2MzvofFGuyerpqsyMOU/XPBcRozoswpnV1DGHYbRxx0=;
        b=fx6uHYJQdrBImPLETeXnfXYHEKw/NpsECA19GMIxEffLks6QnirtIvbLMF28PTRQy+
         mqU03bD/ZhooYaMR1svHZWuedVaLFYG15EnyCrbPArX8kItLrVTjGSvryXJwiC6JBwTs
         yjl/JMvk6cGvug5Ij5bd1OII4FPPKg4m1jkOvG7CP+eigLdSdiTIyflvvXFOMc9cgAEH
         h3Bizy25bSIKdV4TuCJzGKvVmaMXOazCO8k9wF3Erl1J5IHgjUZeCblkSOJsiDESTML3
         Dh0jv8B3zr+CHTLIdI1GoGJJKMOslmZQJouOAzeWc77kSaDVLFIpFjfxlR6Q0014q6yg
         cD7w==
X-Gm-Message-State: AOAM530x3bQ5U/sQE2JGonvO2Sa5njCy6yvi0ENsgumyaMnldbe+BdG0
        UQR0yZhwoSw4TJ0EkBG4m+fbS17e5p37Rg==
X-Google-Smtp-Source: ABdhPJy/lMw77bd1cgnAbBvToq71Q7IYTiZ0cb0TpYr9WYkfdKkP3fIq+u58bRdP3m1BXg4TJYQEyg==
X-Received: by 2002:a17:90a:e60b:: with SMTP id j11mr1337895pjy.42.1615603465757;
        Fri, 12 Mar 2021 18:44:25 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z24sm6386534pge.71.2021.03.12.18.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 18:44:25 -0800 (PST)
Subject: Re: [PATCH 4/4] io_uring: cancel sqpoll via task_work
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615504663.git.asml.silence@gmail.com>
 <6501248c79d9c73e0424cb59b74c03d72b30be62.1615504663.git.asml.silence@gmail.com>
 <d7515d66-0ac7-ce48-7194-00e8bde0595b@gmail.com>
 <86c120c4-cc2b-d19b-d0c9-42fc27aae749@kernel.dk>
 <3a69b2bc-44f4-f3f2-5b4d-ae86303e0aeb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c23ceed9-0a14-601a-2a1e-4555fa2ff75c@kernel.dk>
Date:   Fri, 12 Mar 2021 19:44:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3a69b2bc-44f4-f3f2-5b4d-ae86303e0aeb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 2:41 PM, Pavel Begunkov wrote:
> On 12/03/2021 19:40, Jens Axboe wrote:
>> On 3/12/21 12:35 PM, Pavel Begunkov wrote:
>>> On 11/03/2021 23:29, Pavel Begunkov wrote:
>>>> 1) The first problem is io_uring_cancel_sqpoll() ->
>>>> io_uring_cancel_task_requests() basically doing park(); park(); and so
>>>> hanging.
>>>>
>>>> 2) Another one is more subtle, when the master task is doing cancellations,
>>>> but SQPOLL task submits in-between the end of the cancellation but
>>>> before finish() requests taking a ref to the ctx, and so eternally
>>>> locking it up.
>>>>
>>>> 3) Yet another is a dying SQPOLL task doing io_uring_cancel_sqpoll() and
>>>> same io_uring_cancel_sqpoll() from the owner task, they race for
>>>> tctx->wait events. And there probably more of them.
>>>>
>>>> Instead do SQPOLL cancellations from within SQPOLL task context via
>>>> task_work, see io_sqpoll_cancel_sync(). With that we don't need temporal
>>>> park()/unpark() during cancellation, which is ugly, subtle and anyway
>>>> doesn't allow to do io_run_task_work() properly.> 
>>>> io_uring_cancel_sqpoll() is called only from SQPOLL task context and
>>>> under sqd locking, so all parking is removed from there. And so,
>>>> io_sq_thread_[un]park() and io_sq_thread_stop() are not used now by
>>>> SQPOLL task, and that spare us from some headache.
>>>>
>>>> Also remove ctx->sqd_list early to avoid 2). And kill tctx->sqpoll,
>>>> which is not used anymore.
>>>
>>>
>>> Looks, the chunk below somehow slipped from the patch. Not important
>>> for 5.12, but can can be folded anyway
>>>
>>> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>>> index 9761a0ec9f95..c24c62b47745 100644
>>> --- a/include/linux/io_uring.h
>>> +++ b/include/linux/io_uring.h
>>> @@ -22,7 +22,6 @@ struct io_uring_task {
>>>  	void			*io_wq;
>>>  	struct percpu_counter	inflight;
>>>  	atomic_t		in_idle;
>>> -	bool			sqpoll;
>>>  
>>>  	spinlock_t		task_lock;
>>>  	struct io_wq_work_list	task_list;
>>
>> Let's do it as a separate patch instead.
> 
> Ok, I'll send it for-5.13 when it's appropriate.

Yeah that's fine, obviously no rush. I'll rebase for-5.13/io_uring
when -rc3 is out.


-- 
Jens Axboe

