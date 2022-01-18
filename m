Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93FE492E22
	for <lists+io-uring@lfdr.de>; Tue, 18 Jan 2022 20:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348600AbiARTHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 14:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245012AbiARTHK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 14:07:10 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBCEC061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 11:07:09 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id e8so44178ilm.13
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 11:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dNK6rBrV40unzK6TfeQV3UQ+3nCqCvUrvhZ3T9fykQ0=;
        b=tngyroXSQX7ZuG3xoLptp7AyKeAEX5o+HyHBZ6xWwJlz7UxuSSrsWD96T/cQB+stRC
         YSZDRIw+8OCJ5+GfVaotPod4xLRiOrEvXeba/0TAp/zoGKFBEnuTse8grXfO793OBveR
         7LsYRGnCZeTBHx3J4rHpK6TTS/3jaZKJspuLg+RwdU8FpC5IS3p31UyVQrfzcuXXtSk7
         M3lIyFIiF+RjMg9stDqtUdNCGuT5aGk1XRKb8SB9TmbF/Cm26lGlLnWbMyyvhdQharvN
         W7H5OXFRY890BoYgxA/T7e0Lfq12QMf65TfSG0IvfMvZlHpgH/kDnc4mmtXAFMsO4U9d
         aqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dNK6rBrV40unzK6TfeQV3UQ+3nCqCvUrvhZ3T9fykQ0=;
        b=fRJ1CCY1neW8szkMxwRc4L7NjQx18GF0V1lmDd3NXknh64ug4t+t19Om/kMQrsQo/o
         kGhxuTdwyd6EIf1Vf8gbRfYSL1AqC1YyDw2wEEZPPMBQWZSZGeZYhzTEjbWfT1/PkteT
         8SNSc26LpzM3r6lFu2sDmI/KNsc6QvtMhoH8bEXZXXGrGoguxJepd/sOwI9p6uhDlGzA
         LjQTV8nRBmki+eoGnEvkyHPS+B7XL9MaiAxAAs3GXDhv875PFxAEk/Rt1utceT0ADIej
         f9FFkJuJjiXw0b3XQDreTrb3Xaby8kpDLuWyV1ljAfqB8JyridwZfUhV0KoSNMaydEtg
         6lIw==
X-Gm-Message-State: AOAM530ujtXbOunWUmMSODk4z+bD9G/QHj9zweHik7DAkWEDYakuS42y
        3Cj4ADI5nllHalvmYJxr/vme0E5M79m1Gw==
X-Google-Smtp-Source: ABdhPJwOy9Ls7jj8uArbQbYGj6CisNXn3YMGq1qLsSUjsSwjiODqEUaeF6xqiuw1NViX/o3Oj0MlSw==
X-Received: by 2002:a05:6e02:1c02:: with SMTP id l2mr15118023ilh.239.1642532828950;
        Tue, 18 Jan 2022 11:07:08 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p2sm6704206ilh.56.2022.01.18.11.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 11:07:07 -0800 (PST)
Subject: Re: Canceled read requests never completed
To:     io-uring@vger.kernel.org, flow@cs.fau.de
References: <20220118151337.fac6cthvbnu7icoc@pasture>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <81656a38-3628-e32f-1092-bacf7468a6bf@kernel.dk>
Date:   Tue, 18 Jan 2022 12:07:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220118151337.fac6cthvbnu7icoc@pasture>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/18/22 8:13 AM, Florian Fischer wrote:
> Hello,
> 
> during our research on entangling io_uring and parallel runtime systems one of our test
> cases results in situations where an `IORING_OP_ASYNC_CANCEL` request can not find (-ENOENT)
> or not cancel (EALREADY) a previously submitted read of an event file descriptor. 
> However, the previously submitted read also never generates a CQE.
> We now wonder if this is a bug in the kernel, or, at least in the case of EALRADY, works as intended.
> Our current architecture expects that a request eventually creates a CQE when canceled.
> 
> 
> # Reproducer pseudo-code:
> 
> create N eventfds
> create N threads
>   
> thread_function:
>   create thread-private io_uring queue pair
>   for (i = 0, i < ITERATIONS, i++)
>     submit read from eventfd n
>     submit read from eventfd (n + 1) % N
>     submit write to eventfd (n + 2) % N
>     await completions until the write completion was reaped
>     submit cancel requests for the two read requests
>     await all outstanding requests (minus a possible already completed read request)
>   
> Note that:
> - Each eventfd is read twice but only written once.
> - The read requests are canceled independently of their state. 
> - There are five io_uring requests per loop iteration
> 
> 
> # Expectation
> 
> Each of the five submitted request should be completed:
> * Write is always successful because writing to an eventfd only blocks
>   if the counter reaches 0xfffffffffffffffe and we add only 1 in each iteration.
>   Furthermore the read from the file descriptor resets the counter to 0.
> * The cancel requests are always completed with different return values
>   dependent on the state of the read request to cancel.
> * The read requests should always be completed either because some data is available
>   to read or because they are canceled.
> 
> 
> # Observation:
> 
> Sometimes threads block in io_uring_enter forever because one read request
> is never completed and the cancel of such read returned with -ENOENT or -EALREADY.
> 
> A C program to reproduce this situation is attached.
> It contains the essence of the previously mentioned test case with instructions
> how to compile and execute it.
> 
> The following log excerpt was generated using a version of the reproducer
> where each write adds 0 to the eventfd count and thus not completing read requests.
> This means all read request should be canceled and all cancel requests should either
> return with 0 (the request was found and canceled) or -EALREADY the read is already
> in execution and should be interrupted.
> 
>   0 Prepared read request (evfd: 0, tag: 1)
>   0 Submitted 1 requests -> 1 inflight
>   0 Prepared read request (evfd: 1, tag: 2)
>   0 Submitted 1 requests -> 2 inflight
>   0 Prepared write request (evfd: 2)
>   0 Submitted 1 requests -> 3 inflight
>   0 Collect write completion: 8
>   0 Prepared cancel request for 1
>   0 Prepared cancel request for 2
>   0 Submitted 2 requests -> 4 inflight
>   0 Collect read 1 completion: -125 - Operation canceled
>   0 Collect cancel read 1 completion: 0
>   0 Collect cancel read 2 completion: -2 - No such file or directory
>   
> Thread 0 blocks forever because the second read could not be
> canceled (-ENOENT in the last line) but no completion is ever created for it.
> 
> The far more common situation with the reproducer and adding 1 to the eventfds in each loop
> is that a request is not canceled and the cancel attempt returned with -EALREADY.
> There is no progress because the writer has already finished its loop and the cancel
> apparently does not really cancel the request.
> 
>   1 Starting iteration 996
>   1 Prepared read request (evfd: 1, tag: 1)
>   1 Submitted 1 requests -> 1 inflight
>   1 Prepared read request (evfd: 2, tag: 2)
>   1 Submitted 1 requests -> 2 inflight
>   1 Prepared write request (evfd: 0)
>   1 Submitted 1 requests -> 3 inflight
>   1 Collect write completion: 8
>   1 Prepared cancel request for read 1
>   1 Prepared cancel request for read 2
>   1 Submitted 2 requests -> 4 inflight
>   1 Collect read 1 completion: -125 - Operation canceled
>   1 Collect cancel read 1 completion: 0
>   1 Collect cancel read 2 completion: -114 - Operation already in progress
> 
> After reading the io_uring_enter(2) man page a IORING_OP_ASYNC_CANCEL's return value of -EALREADY apparently
> may not cause the request to terminate. At least that is our interpretation of "…res field will contain -EALREADY.
> In this case, the request may or may not terminate."
> 
> I could reliably reproduce the behavior on different hardware, linux versions
> from 5.9 to 5.16 as well as liburing versions 0.7 and 2.1.
> 
> With linux 5.6 I was not able to reproduce this cancel miss.
> 
> So is the situation we see intended behavior of the API or is it a faulty race in the
> io_uring cancel code?
> If it is intended then it becomes really hard to build reliable abstractions
> using io_uring's cancellation.
> We really like to have the invariant that a canceled io_uring operation eventually
> generates a cqe, either completed or canceled/interrupted.

I took a look at this, and my theory is that the request cancelation
ends up happening right in between when the work item is moved between
the work list and to the worker itself. The way the async queue works,
the work item is sitting in a list until it gets assigned by a worker.
When that assignment happens, it's removed from the general work list
and then assigned to the worker itself. There's a small gap there where
the work cannot be found in the general list, and isn't yet findable in
the worker itself either.

Do you always see -ENOENT from the cancel when you get the hang
condition?

I'll play with this a bit and see if we can't close this hole so the
work is always reliably discoverable (and hence can get canceled).

-- 
Jens Axboe

