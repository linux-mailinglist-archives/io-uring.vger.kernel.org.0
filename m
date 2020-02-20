Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346DE166AE5
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 00:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgBTXW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 18:22:58 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33856 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXW6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 18:22:58 -0500
Received: by mail-pg1-f195.google.com with SMTP id j4so27251pgi.1
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 15:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tUw8MKrXVuu7FayPw9hmWhf45VNAGRPzeGODnuDRpVs=;
        b=zTUJHp4avtADWm3FMKZVdDzu9/CxFp84Q+wcIghBScknIi8LHyMShGcOP3vZqvi6zy
         1/97rRZlbIDxoMjr54jvoDv6FPh9F2Ku83vnBzqcFo7uZylmYwCmk1WjPFPwbQPsdK87
         cktUWZzXpjW80mDj46noaHHPO3Bl0uffoLOjGtx2d4tWGkeSbzOQAnF5Xi/ILqAOmNm5
         pojkytOBKhhgOdoxCgPXzjZ1ZKk25WH38fUPEcONRRtroebMYQPqJreh4Y8dTiVvy94M
         zKks5jGzXSRrjzQCnTlsWzv0HM4M/YyuQ6/4dQ8GzUAIBdnzbtaWuKH62f/xzlvQDJ3F
         WMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tUw8MKrXVuu7FayPw9hmWhf45VNAGRPzeGODnuDRpVs=;
        b=pQ02tddMJ5IJqfHcJqFtl6Ylh2iHMENdys3xxkHYu6jWucSMK1gYV5wz8ZrxNKoc4I
         3kf8w8W/1E2pb27AK3+iVQzlHxeoZpDHsgTKeBxm9sGRAHYp0SeRTAYOwP/q5HoHD1K9
         CTt71Jc91aAOlLvdHJ8aC4XwV6nzQn6+OjAmgDTFvP/Kr37ifhfh6/CEmRFfUifBWbga
         Y6zKaxlg7XeSlxKn6DUuQXdv6WXpqehmU+hOEFjZuRBJp5UNjLZnksc9rrgfFKd5/+aX
         eiI5G5e+HaHD7xYdtgaCTLtL/gHsTMzmCrfhsA9Nun6I3LyjSNy2Jww7VumLPINDqCUV
         TtYg==
X-Gm-Message-State: APjAAAUaEu2NMDF+2LgrKrqL6SLyUsFkPIS99TW+Fy9ssnqT8F62Kh2z
        S0nYy6Tu7huuA4qB3f7P0ogifQ==
X-Google-Smtp-Source: APXvYqzi0VgtCRKD1HaxEKE5Ooc7kLk+3eu7mP+/+2OJ/yXpPmI31HYO9kAbxcz+vqWpF1JynIs5Xw==
X-Received: by 2002:a63:e30a:: with SMTP id f10mr34517690pgh.331.1582240975691;
        Thu, 20 Feb 2020 15:22:55 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id g19sm639996pfh.134.2020.02.20.15.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 15:22:54 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
 <CAG48ez37KerMukJ6zU=VQPtHsxo29S7TxqcqvU=Bs7Lfxtfdcg@mail.gmail.com>
 <4caec29c-469d-7448-f779-af3ba9c6c6a9@kernel.dk>
 <CAG48ez2vXYgW8WqBxeb=A=+_2WRL98b_Heoe8rPeXOMXuuf4oQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bdf25a89-fedd-06b4-58ba-103170bcde06@kernel.dk>
Date:   Thu, 20 Feb 2020 15:22:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez2vXYgW8WqBxeb=A=+_2WRL98b_Heoe8rPeXOMXuuf4oQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 4:12 PM, Jann Horn wrote:
> On Fri, Feb 21, 2020 at 12:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/20/20 3:23 PM, Jann Horn wrote:
>>> On Thu, Feb 20, 2020 at 11:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/20/20 3:02 PM, Jann Horn wrote:
>>>>> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> For poll requests, it's not uncommon to link a read (or write) after
>>>>>> the poll to execute immediately after the file is marked as ready.
>>>>>> Since the poll completion is called inside the waitqueue wake up handler,
>>>>>> we have to punt that linked request to async context. This slows down
>>>>>> the processing, and actually means it's faster to not use a link for this
>>>>>> use case.
> [...]
>>>>>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
>>>>>> +static void io_poll_task_func(struct callback_head *cb)
>>>>>>  {
>>>>>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>>>>>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
>>>>>> +       struct io_kiocb *nxt = NULL;
>>>>>>
>>>>> [...]
>>>>>> +       io_poll_task_handler(req, &nxt);
>>>>>> +       if (nxt)
>>>>>> +               __io_queue_sqe(nxt, NULL);
>>>>>
>>>>> This can now get here from anywhere that calls schedule(), right?
>>>>> Which means that this might almost double the required kernel stack
>>>>> size, if one codepath exists that calls schedule() while near the
>>>>> bottom of the stack and another codepath exists that goes from here
>>>>> through the VFS and again uses a big amount of stack space? This is a
>>>>> somewhat ugly suggestion, but I wonder whether it'd make sense to
>>>>> check whether we've consumed over 25% of stack space, or something
>>>>> like that, and if so, directly punt the request.
> [...]
>>>>> Also, can we recursively hit this point? Even if __io_queue_sqe()
>>>>> doesn't *want* to block, the code it calls into might still block on a
>>>>> mutex or something like that, at which point the mutex code would call
>>>>> into schedule(), which would then again hit sched_out_update() and get
>>>>> here, right? As far as I can tell, this could cause unbounded
>>>>> recursion.
>>>>
>>>> The sched_work items are pruned before being run, so that can't happen.
>>>
>>> And is it impossible for new ones to be added in the meantime if a
>>> second poll operation completes in the background just when we're
>>> entering __io_queue_sqe()?
>>
>> True, that can happen.
>>
>> I wonder if we just prevent the recursion whether we can ignore most
>> of it. Eg never process the sched_work list if we're not at the top
>> level, so to speak.
>>
>> This should also prevent the deadlock that you mentioned with FUSE
>> in the next email that just rolled in.
> 
> But there the first ->read_iter could be from outside io_uring. So you
> don't just have to worry about nesting inside an already-running uring
> work; you also have to worry about nesting inside more or less
> anything else that might be holding mutexes. So I think you'd pretty
> much have to whitelist known-safe schedule() callers, or something
> like that.

I'll see if I can come up with something for that. Ideally any issue
with IOCB_NOWAIT set should be honored, and trylock etc should be used.
But I don't think we can fully rely on that, we need something a bit
more solid...

> Taking a step back: Do you know why this whole approach brings the
> kind of performance benefit you mentioned in the cover letter? 4x is a
> lot... Is it that expensive to take a trip through the scheduler?
> I wonder whether the performance numbers for the echo test would
> change if you commented out io_worker_spin_for_work()...

If anything, I expect the spin removal to make it worse. There's really
no magic there on why it's faster, if you offload work to a thread that
is essentially sync, then you're going to take a huge hit in
performance. It's the difference between:

1) Queue work with thread, wake up thread
2) Thread wakes, starts work, goes to sleep.
3) Data available, thread is woken, does work
4) Thread signals completion of work

versus just completing the work when it's ready and not having any
switches to a worker thread at all. As the cover letter mentions, the
single client case is a huge win, and that is of course the biggest win
because everything is idle. If the thread doing the offload can be kept
running, the gains become smaller as we're not paying those wake/sleep
penalties anymore.

-- 
Jens Axboe

