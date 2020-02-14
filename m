Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D4D15E790
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 17:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392882AbgBNQya (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 11:54:30 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:35171 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404800AbgBNQSg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 11:18:36 -0500
Received: by mail-il1-f194.google.com with SMTP id g12so8535336ild.2
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 08:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z9P/Y+enuy4+WhGq54d3PXKKxAo3LuGHm9nuMbBESM4=;
        b=x/G9mTzAyUzibp4+Bs1GpJaY3loL3fhMEExLppqNGb0UKA/ncEKiDfFU/Z9T0g7DqW
         LlB/hvAiKwVOyNN49HIbPiKLDgg1srdL/1AsYZzaMv/IcGrnl+ZBO7akj7mEBuiEDrPE
         GEwCRXZF7kmgrpdTo3PQbULJfUDvheovH8LLc+P1gXgrHkT+HjY6tk293bMZk1+Hjzkm
         0qsXWp0Bf5P+zOyFv3jSliDSmbNwztpcXrjCgYFyD8KvLpp1W1HBUbLcYWo4gW+d9zAG
         NH3EOqNb6n2HMJe4g+JRlQDIy5WVEII/fGYQgcHXRLhgsmFyefXh+gJiHzeoJxZJz6oP
         4ZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z9P/Y+enuy4+WhGq54d3PXKKxAo3LuGHm9nuMbBESM4=;
        b=Zfpd7WRj4WKqsNxsdxYOLa72PyADaVAucv3MK0MPhy1cFP8Af++3iiIXcLByIdvlkD
         uL7NbKsXt6wiQM/RJhPXRfucvNV/6fyPrm02wxUtEbdenQtBh4bB88sPHHuVZsSEU45H
         ymfgCCUPOKPDZOXDax00P4Uf6s9NenalwYhL4xqgAg1bTy1MLxtYXRCJpIdNOI7ogWg+
         OAFtjZ/6MH1LHU0hQnPvzmDsxxJnCuSJR9jV+DW62lfYavGsdVVR58v76Hz+SZsfM63A
         A7E4ROeRlPqnykdLMjDid/6efEmY1pw/yDGkjv/3+sP0EamQoK6i+HElV6JObw7NcHTv
         TtVg==
X-Gm-Message-State: APjAAAWnrmUYNGRSPpU9nlN106dPzDOHvHXSXhQh6bLvb7KmGYabnt8D
        01xwHGk6MnOfC1lw1mtoycosocxPrl8=
X-Google-Smtp-Source: APXvYqyJ3BgirJr27Am/xVPib87ORQpPga+dk4gquKy2pRR/UmUwaUUFgczqh3Q/ODIYJQdwbX6hPw==
X-Received: by 2002:a92:ba8d:: with SMTP id t13mr3655228ill.207.1581697115490;
        Fri, 14 Feb 2020 08:18:35 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w15sm1566713iol.86.2020.02.14.08.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 08:18:34 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
Message-ID: <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
Date:   Fri, 14 Feb 2020 09:18:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 8:47 AM, Jens Axboe wrote:
>> I suspect you meant to put that in finish_task_switch() which is the
>> tail end of every schedule(), schedule_tail() is the tail end of
>> clone().
>>
>> Or maybe you meant to put it in (and rename) sched_update_worker() which
>> is after every schedule() but in a preemptible context -- much saner
>> since you don't want to go add an unbounded amount of work in a
>> non-preemptible context.
>>
>> At which point you already have your callback: io_wq_worker_running(),
>> or is this for any random task?
> 
> Let me try and clarify - this isn't for the worker tasks, this is for
> any task that is using io_uring. In fact, it's particularly not for the
> worker threads, just the task itself.
> 
> I basically want the handler to be called when:
> 
> 1) The task is scheduled in. The poll will complete and stuff some items
>    on that task list, and I want to task to process them as it wakes up.
> 
> 2) The task is going to sleep, don't want to leave entries around while
>    the task is sleeping.
> 
> 3) I need it to be called from "normal" context, with ints enabled,
>    preempt enabled, etc.
> 
> sched_update_worker() (with a rename) looks ideal for #1, and the
> context is sane for me. Just need a good spot to put the hook call for
> schedule out. I think this:
> 
> 	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
> 		preempt_disable();
> 		if (tsk->flags & PF_WQ_WORKER)
> 			wq_worker_sleeping(tsk);
> 		else
> 			io_wq_worker_sleeping(tsk);
> 		preempt_enable_no_resched();
> 	}
> 
> just needs to go into another helper, and then I can call it there
> outside of the preempt.
> 
> I'm sure there are daemons lurking here, but I'll test and see how it
> goes...

Here's a stab at cleaning it up:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll

top two patches. First one simply cleans up the sched_update_worker(),
so we now have sched_in_update() and sched_out_update(). No changes in
this patch, just moves the worker sched-out handling into a helper.

2nd patch then utilizes this to flush the per-task requests that may
have been queued up.

-- 
Jens Axboe

