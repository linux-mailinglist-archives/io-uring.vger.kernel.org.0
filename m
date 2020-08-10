Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F294B241214
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 23:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgHJVGx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 17:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgHJVGw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 17:06:52 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BDAC061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:06:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z20so5740948plo.6
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=65PCk5SRNHyL/BfqXi/pgagDm9eZ2xLVmswic72CUmM=;
        b=JyQ6cmNA50SChN9ECNN/xKZ5BE0SUDDpzn4SAz+6Ctk2kbBWeP4ptboAUsrtgz9K2n
         ttiroGZlkogNrgktOcLWwUkwWllxalvQk8ih4h1bT0cbWjbyyDFlh+6g1mvIh8/rhMjg
         CA/SgMMy9omSnEdVcRaMrj+5yJXlLDqThleTfndbBZrzRMRDmX7SAxLZQDgyMmzROXcS
         IBZRiIJmuaB3IU5dP1TnmqLk8gPZjt5J411RpGtdY6vLvKzbZoX6bEzwVVmqUe0p/06V
         FIHl/9rfan9zDp5AJYZenHhPy0+/6kB/aMuLsMB3QdMvkYLi6Uej6YsEH82pBmfoHXOr
         clMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=65PCk5SRNHyL/BfqXi/pgagDm9eZ2xLVmswic72CUmM=;
        b=V7g634yr3j7PcfzyQXHB2XNk0mXNvUZiLGUFAIKSbAPk+UGEhvO1RMMtXJoLuF1iIi
         HIsvyC+vndhrYpdUvLz7cgB8N2RG9rTdPCRxqWNEKZ9WsWiwB2dgfl4JDY6xOJq4L+pw
         3DTHpHQ3TPCoY8CXDLY1xYB3sG7VgbwvlGTycq0OtQfPbUp/1aSLi3a7u+lFVmXS9fva
         n6K3iM1n12zJDgNaRJAYbWXGFK/SgFgZKWL8DRKrAF/U4+k1hJEN1PJaKNrlc78k+gQA
         f6gO6BXr93OCy+6U9fBwzA3/Q6YQqmHj0yROLLIo1rsPTAqalDdvw0PS0lOPvaOoqgaX
         j2NA==
X-Gm-Message-State: AOAM530EqlCdMzB9fb1QR6gjRIIS9Ksb9TIfjGdVbosg7LlT71CFXZVR
        2CPMM5Ov7vdxZtiBUGeiWweHDw==
X-Google-Smtp-Source: ABdhPJx7xK/i1aR83T01Xj3xe67REy62YfW96YHpiSER0dou9qmg7jobePF6SNNI8Hbkp/GDwYGfaQ==
X-Received: by 2002:a17:90a:1347:: with SMTP id y7mr1101864pjf.183.1597093611448;
        Mon, 10 Aug 2020 14:06:51 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a16sm20859079pgj.27.2020.08.10.14.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 14:06:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jann Horn <jannh@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
Date:   Mon, 10 Aug 2020 15:06:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 2:35 PM, Jann Horn wrote:
> On Mon, Aug 10, 2020 at 10:25 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 8/10/20 2:13 PM, Jens Axboe wrote:
>>>> Would it be clearer to write it like so perhaps?
>>>>
>>>>      /*
>>>>       * Optimization; when the task is RUNNING we can do with a
>>>>       * cheaper TWA_RESUME notification because,... <reason goes
>>>>       * here>. Otherwise do the more expensive, but always correct
>>>>       * TWA_SIGNAL.
>>>>       */
>>>>      if (READ_ONCE(tsk->state) == TASK_RUNNING) {
>>>>              __task_work_notify(tsk, TWA_RESUME);
>>>>              if (READ_ONCE(tsk->state) == TASK_RUNNING)
>>>>                      return;
>>>>      }
>>>>      __task_work_notify(tsk, TWA_SIGNAL);
>>>>      wake_up_process(tsk);
>>>
>>> Yeah that is easier to read, wasn't a huge fan of the loop since it's
>>> only a single retry kind of condition. I'll adopt this suggestion,
>>> thanks!
>>
>> Re-write it a bit on top of that, just turning it into two separate
>> READ_ONCE, and added appropriate comments. For the SQPOLL case, the
>> wake_up_process() is enough, so we can clean up that if/else.
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=49bc5c16483945982cf81b0109d7da7cd9ee55ed
> 
> I think I'm starting to understand the overall picture here, and I
> think if my understanding is correct, your solution isn't going to
> work properly.
> 
> My understanding of the scenario you're trying to address is:
> 
>  - task A starts up io_uring
>  - task A tells io_uring to bump the counter of an eventfd E when work
> has been completed
>  - task A submits some work ("read a byte from file descriptor X", or
> something like that)
>  - io_uring internally starts an asynchronous I/O operation, with a callback C
>  - task A calls read(E, &counter, sizeof(counter)) to wait for events
> to be processed
>  - the async I/O operation finishes, C is invoked, and C schedules
> task_work for task A
> 
> And here you run into a deadlock, because the task_work will only run
> when task A returns from the syscall, but the syscall will only return
> once the task_work is executing and has finished the I/O operation.
> 
> 
> If that is the scenario you're trying to solve here (where you're
> trying to force a task that's in the middle of some syscall that's
> completely unrelated to io_uring to return back to syscall context), I
> don't think this will work: It might well be that the task has e.g.
> just started entering the read() syscall, and is *about to* block, but
> is currently still running.

Your understanding of the scenario appears to be correct, and as far as
I can tell, also your analysis of why the existing approach doesn't
fully close it. You're right in that the task could currently be on its
way to blocking, but still running. And for that case, TWA_RESUME isn't
going to cut it.

Ugh. This basically means I have to use TWA_SIGNAL regardless of state,
unless SQPOLL is used. That's not optimal.

Alternatively:

if (tsk->state != TASK_RUNNING || task_in_kernel(tsk))
	notify = TWA_SIGNAL;
else
	notify = TWA_RESUME;

should work as far as I can tell, but I don't even know if there's a
reliable way to do task_in_kernel(). But I suspect this kind of check
would still save the day, as we're not really expecting the common case
to be that the task is in the kernel on the way to blocking. And it'd be
kind of annoying to have to cater to that scenario by slowing down the
fast path.

Suggestions?

-- 
Jens Axboe

