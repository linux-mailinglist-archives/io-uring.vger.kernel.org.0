Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07951ED25A
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgFCOsr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 10:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgFCOsq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 10:48:46 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D512C08C5C0
        for <io-uring@vger.kernel.org>; Wed,  3 Jun 2020 07:48:46 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d128so2382856wmc.1
        for <io-uring@vger.kernel.org>; Wed, 03 Jun 2020 07:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mh7yn2qyU/wzgh8U9mypIRH5omnF9plX/CSlpAfBL+w=;
        b=XYDo7SoYVam/TcupipIeYLx6sn7cujayg7GnxYGmIj11O5wOJVSFuB7mclXwfZDf8H
         TsFNRjxdU59FQFAzWCsYsmbwsGskbegwMpFPBVYT6gdyHpUQe5W+y4u3aZh/hGSVOyqm
         lnGZzdex6opHOsyDKlShIPgZw5cTxNEI56xqbRntO4e02STHmdCci+Rdk3Q5/3gkersg
         FgblEdpOm6mWQUQhy3Ud5mjEpgQ/MA26anvO+lRFG2+Xwa6Jf+cxGbSw+ZyCDVl2d2mr
         tk2YHNB2ns1L6qMcUuKIGYaqbWa3whyn+c36cbcbzMUgdXZWJdTupTUDl73yCsB7bt4X
         mxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mh7yn2qyU/wzgh8U9mypIRH5omnF9plX/CSlpAfBL+w=;
        b=fSwPBjO7SD6QiPDkkA88FP+4GgQXroRqKWgj8RUQ48ufv8j4w+8dg2uDG04hycmDTo
         w9Xm59jbBiKCFiZ4LKlr2WGA0IYXY5Xc0JbM3A1tFF9BgBRIZDEBWt29qUifhVV/k6gG
         3ScTp8azE2nrqpZ1w+jBDqUiqJ5lk+N+LNAJUoGhpVzIYulWphUUHKlpkKENjSsRz+Y1
         8ZW8nOgMvXxrzIQynLNtvjy0LyQfT9AmgQRTpCXro0TbA2FDjZqzAEYp2OERvwDbhSdB
         v4xLzSpdYuRcGTXcyFTYTIGH6Pxzr3QA5WUPLeNvpVm1bdKw8vi7iH8FEN/KbM0NOks9
         I6Eg==
X-Gm-Message-State: AOAM530m4MyP99Z+a7LHHXQ+bPvh3kP/a3ReZ/O7ZtX+PAPweMyL1yGI
        JY8PMdlrkHkoV+uexFU+Rxg=
X-Google-Smtp-Source: ABdhPJxOVB4DQgyS1D+1J5L2VwyDeKs1IpiWRfp6ZzKQckMJhzBdKYFC2otSXUqcqU/i90k4Pw/HAQ==
X-Received: by 2002:a1c:b7d5:: with SMTP id h204mr9055910wmf.100.1591195724780;
        Wed, 03 Jun 2020 07:48:44 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id u4sm3509326wmb.48.2020.06.03.07.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 07:48:44 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com, yujian.wu1@gmail.com
References: <20200520115648.6140-1-xiaoguang.wang@linux.alibaba.com>
 <3bea8be7-2a82-cf24-a8b6-327672a64535@gmail.com>
 <242c17f3-b9b3-30cb-ff3d-a33aeef36ad1@linux.alibaba.com>
 <13dd7a1f-63df-6a0c-74ed-d5ff12a0bf96@gmail.com>
 <c077a2dc-7b69-5ee4-24a3-3dd3df57b201@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: create percpu io sq thread when
 IORING_SETUP_SQ_AFF is flagged
Message-ID: <e3c81737-ef46-37a1-9c64-b307278ca65f@gmail.com>
Date:   Wed, 3 Jun 2020 17:47:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c077a2dc-7b69-5ee4-24a3-3dd3df57b201@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/05/2020 17:42, Xiaoguang Wang wrote:
> Yes, I don't try to make all io_uring instances in the system share threads, I just
> make io_uring instances which are bound to same cpu core, share one io_sq_thread that
> only is created once for every cpu core.
> Otherwise in current io_uring mainline codes, we'd better not bind different io_uring
> instances to same cpu core,  some instances' busy loop in its sq_thread_idle period will
> impact other instanes who currently there are reqs to handle.

I got a bit carried away from your initial case, but there is the case:
Let's we have 2 unrelated apps that create SQPOLL io_uring instances. Let's say they are
in 2 different docker container for the argument (and let's just assume a docker container
user can create such).

The first app1 submits 32K fat requests as described before. The second one (app2) is a
low-latency app, submits reqs by 1, but expects it to be picked really fast. And let's
assume their SQPOLL threads pinned to the same CPU.

1. old version:
The CPU spends some time allocated by a scheduler on 32K requests of app1,
probably not issuing them all but that's fine. And then it goes to the app2.
So, the submit-to-pickup latency for app2 is capped by a task scheduler.
That's somewhat fair. 

2. your version:
io_sq_thread first processes all 32K of requests of app1, and only then goes to app2.
app2 is screwed, unfair as life can be. And a malicious user can create many io_uring
instances as in app1. So the latency will be further multiplied.


Any solution I can think of is ugly and won't ever land upstream. Like creating your
own scheduling framework for io_uring, wiring kindof cgroups, etc. And actually SQPOLL
shouldn't be so ubiquitous (+needs privileges). E.g. I expect there will be a single
app per system using it, e.g. a database consuming most of the resources anyway.
And that's why I think it's better to not trying to solve your original issue.


However, what the patch can be easily remade into is sharing an SQPOLL thread between
io_uring instances of a single app/user, like passing fd described before.
The most obvious example is to share 1 SQPOLL thread (or N << num_cpus) between all
user threads, so
- still creating io_uring per thread to not synchronise SQ
- retaining CPU time for real user work (instead of having N SQPOLL threads)
- increasing polling efficiency (more work -- less idle polling)
- and scheduling/task migration, etc.


note: would be great to check, that it has all necessary cond_resched()

> 
>> specified set of them. In other words, making yours @percpu_threads not global,
>> but rather binding to a set of io_urings.
>>
>> e.g. create 2 independent per-cpu sets of threads. 1st one for {a1,a2,a3}, 2nd
>> for {b1,b2,b3}.
>>
>> a1 = create_uring()
>> a2 = create_uring(shared_sq_threads=a1)
>> a3 = create_uring(shared_sq_threads=a1)
>>
>> b1 = create_uring()
>> b2 = create_uring(shared_sq_threads=b1)
>> b3 = create_uring(shared_sq_threads=b1)
> Thanks your suggestions, I'll try to consider it in V2 patch.
> 
> But I still have one question: now "shared_sq_threads=a1" and "shared_sq_threads=b1"
> can be bound to same cpu core? I think it's still not efficient. E.g. "shared_sq_threads=a1"
> busy loop in its sq_thread_idle period will impact shared_sq_threads=b1 who currently
> there are reqs to handle.
> 
> Now I also wonder whether a io_uring instance,which has SQPOLL enabed and does not
> specify a sq_thread_cpu, can be used in real business environment, the io_sq_thread
> may run in any cpu cores, which may affect any other application, e.g. cpu resource
> contend. So if trying to use SQPOLL, we'd better allocate specified cpu.

I think it's ok.
- needs privileges to create SQPOLL
- don't expect it used without thinking twice
- for not-pinned case everything will be rescheduled to other cpus as appropriate
  It shouldn't affect much in normal circumstances.

-- 
Pavel Begunkov
