Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90093166AAA
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 00:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgBTXCd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 18:02:33 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33679 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 18:02:32 -0500
Received: by mail-pf1-f193.google.com with SMTP id n7so153270pfn.0
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 15:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fs8uD06ytAhXaumufAPREalc0pEXG6XEfVfx2oai/PY=;
        b=KjkuC1Nh9spDmHModye4YQEvDWvqteCQ7TYeLGTIes4ksePSzrNsf6HyT1vLjO11X9
         HjW/pVIMKsJr6BZFBjEH2Yccvb6yXh1wrhFvth9lL2qygCFHCyJbhiNQvJRrzv3WNxFW
         BMfOUUTTtZ69bNjB+uEnvaLtWklTwa9OTEeYeJvhRnZVteS3Hbq6bsKW2wxQdUiSeOML
         yUhwOb5SVweCgS1LJ8lEf7edBdetbg153bAkSuCVgZ7dS1KY7sxyEzJlPiyTi+cleI/+
         6Y4HyL1JNA3O3VN2aLoUCPILdd4fGBRNBX+K7yrIextyL86yBDmFUaY33VCc5UZSFzKF
         lghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fs8uD06ytAhXaumufAPREalc0pEXG6XEfVfx2oai/PY=;
        b=F0Wju3i4I5t0/V0cNb/VHb1BSLbfo/28FtW/RQ4OKwX/dctUlZ4GDrzI14qpXwynLu
         bjyuFOUxhLHcqlyaMb1cQ4jgYmYXg9zPzfH6UmWkCnnkyWbXIWQoVtqLeNUQa38FrAFZ
         Y+oQM4NhSfM+Oowc8xoMtlzFtRN3ayan/bBY/JnckDuJFYq6BkPGl1maTlblu26o/Unk
         zqQA5GdNW3p8ETop+9REcqqt375sBCslWGcmG/6/4+S1nijuGu51cT+MJUDAYrFw/c+d
         TEDl557FbyxstzyLWl6V3RJiGzM4kOsaLhwB7e0ULa3VqfeQSJgFS3eVTOTG+/JWbtMA
         Aw8g==
X-Gm-Message-State: APjAAAUMmnd3XknJDVXHISmiIIdSuQaBQi/7HzByuK9r65nIdf3h3rXV
        ZPdmTIO8XODs7scESiw2KBtbnw==
X-Google-Smtp-Source: APXvYqwGvhYfRLZTo6eWZnzU7us1lo/K/tTGBtSdrvpmOOCaxsB7VS6X8+eqchwkT06gB92L/VaFbg==
X-Received: by 2002:a63:1044:: with SMTP id 4mr36561001pgq.412.1582239751479;
        Thu, 20 Feb 2020 15:02:31 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id o6sm347247pgg.37.2020.02.20.15.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 15:02:30 -0800 (PST)
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
 <67a62039-0cb0-b5b2-d7f8-fade901c59f4@kernel.dk>
 <CAG48ez3R3DWLry_aRAt47BQ05Y4Mr9yVXq49yuiRGNoyRMr3Lg@mail.gmail.com>
 <1658b860-6419-fac9-8ec3-b2d91d74b293@kernel.dk>
 <CAG48ez3jS0VbeaW2VYBoGBKHDzkYaR-f_wA69TPFrWdz9iwmdA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c148ffe7-2c8d-f350-392f-81b34fcb90fb@kernel.dk>
Date:   Thu, 20 Feb 2020 15:02:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez3jS0VbeaW2VYBoGBKHDzkYaR-f_wA69TPFrWdz9iwmdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 3:58 PM, Jann Horn wrote:
> On Thu, Feb 20, 2020 at 11:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/20/20 3:38 PM, Jann Horn wrote:
>>> On Thu, Feb 20, 2020 at 11:23 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/20/20 3:14 PM, Jens Axboe wrote:
>>>>>>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>>>>>
>>>>>>>         list_del_init(&poll->wait.entry);
>>>>>>>
>>>>>> [...]
>>>>>>> +       tsk = req->task;
>>>>>>> +       req->result = mask;
>>>>>>> +       init_task_work(&req->sched_work, io_poll_task_func);
>>>>>>> +       sched_work_add(tsk, &req->sched_work);
>>>>>>
>>>>>> Doesn't this have to check the return value?
>>>>>
>>>>> Trying to think if we can get here with TASK_EXITING, but probably safer
>>>>> to just handle it in any case. I'll add that.
>>>>
>>>> Double checked this one, and I think it's good as-is, but needs a
>>>> comment. If the sched_work_add() fails, then the work item is still in
>>>> the poll hash on the ctx. That work is canceled on exit.
>>>
>>> You mean via io_poll_remove_all()? That doesn't happen when a thread
>>> dies, right?
>>
>> Off of io_uring_flush, we do:
>>
>> if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
>>         io_uring_cancel_task_poll(current);
>>         io_uring_cancel_task_async(current);
>>         io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
>> }
>>
>> to cancel _anything_ that the task has pending.
> 
> ->flush() is only for when the uring instance is dropped from a file
> descriptor table; threads typically share their file descriptor
> tables, and therefore won't ->flush() until the last one dies.

True, then I guess I'll need some other notifier for that particular
case. Might be able to use sched_work_run() for that, since we know
that'll definitely get called when the task exits.

-- 
Jens Axboe

