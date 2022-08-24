Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EA959FECF
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 17:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbiHXPvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 11:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbiHXPvd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 11:51:33 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B115C71983
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 08:51:28 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id o1so35915ilq.1
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 08:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=tYVEJzjcF7qi8BB8OqunFeP+mvMsHMNy/bbwsRqxhK8=;
        b=0WZZZKUUHYp0Hff75wlY6DiQ6Nz8V7pn3c5GzTZiakvNyU5y8B0uLSqpWDcK/lXosx
         3n/Vad/22juLWrgu448s5hSbng+cFmUl686UJC+QbxFVEriNOZoDe6Y5Jlohy7LTBeke
         ktfgJS/nv97nsTLbtSY6vpz/KkUCAgfwAsjGoSwEF5O1b40kHIisOjZT/dmplJ5d6LXy
         D6I8tlEuYswMST+euUPEe84siO76sHMmOiY2ndlwjHasavIPeiG4rALO8HOSnadQbzKp
         xeH3RHUw90Qlz/g4rz1jZBT+gd6FZ+Id+u4de4kPOOM2nkTMqlrqAJwCHQHfOS1NWFwB
         a8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tYVEJzjcF7qi8BB8OqunFeP+mvMsHMNy/bbwsRqxhK8=;
        b=hCtpMLuywZmrBUz2w6cRx/arvW42yPvvf8GFG5nY3bkllWMHbKwz8jZk+3CN11fvXZ
         DDrR7h8/9L1iPIH3untwPHmGmxPpxYDpDJIbNQT63JWRGZebMeoRqImRcluY4sQbR7EH
         wwIhx+DMS/UEKHGwCKiEiQD7JpepYoeBlAiZ7BMEKtBZkXGXkLW+Qck6y6tcdoi9GUer
         ljikWRMNORW1rAnWPXwtCmoZMVmZIPk3FTFAe1ulxpQy/runr11c6l90+pqJ8Capkjb4
         bvTxQe6JQzlzgz5+C7CS1JoBlG7ul/rCu2F5V5VRnPq3Ex1SXck/LrttMwngHLAIsQML
         EBxQ==
X-Gm-Message-State: ACgBeo19wOTwySQ6Gtn/Mg278obxNT4mh6T9KhQpZRPirhptDLIJV++e
        zQxBuzv7NrRuLs4M5Id9Rs+rOQ==
X-Google-Smtp-Source: AA6agR5eTchsp6PUUCcMTTRze4rccUgTrRRZeT/qvq/j8KJ0zhQY/N/wWSH4ut6GkvP9zWVClzbFxw==
X-Received: by 2002:a05:6e02:1004:b0:2e9:16f5:82b0 with SMTP id n4-20020a056e02100400b002e916f582b0mr2361906ilj.113.1661356287438;
        Wed, 24 Aug 2022 08:51:27 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a20-20020a924454000000b002dcfbf36438sm1143245ilm.12.2022.08.24.08.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 08:51:26 -0700 (PDT)
Message-ID: <0b5a5360-efd1-2d77-1dbf-b7468386d1a0@kernel.dk>
Date:   Wed, 24 Aug 2022 09:51:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 2/2] coredump: Allow coredumps to pipes to work with
 io_uring
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
 <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
 <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
 <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
 <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
 <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
 <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
 <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk>
 <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>
 <87mtd3rals.fsf_-_@email.froward.int.ebiederm.org>
 <61abfb5a517e0ee253b0dc7ba9cd32ebd558bcb0.camel@trillion01.com>
 <bb423622f97826f483100a1a7f20ce10a9090158.camel@trillion01.com>
 <875yiisttu.fsf@email.froward.int.ebiederm.org>
 <654cb5de-a563-b812-a435-d9b435cee334@kernel.dk>
 <87lerdr810.fsf@email.froward.int.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87lerdr810.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/22 9:11 AM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 8/23/22 12:22 PM, Eric W. Biederman wrote:
>>> Olivier Langlois <olivier@trillion01.com> writes:
>>>
>>>> On Mon, 2022-08-22 at 17:16 -0400, Olivier Langlois wrote:
>>>>>
>>>>> What is stopping the task calling do_coredump() to be interrupted and
>>>>> call task_work_add() from the interrupt context?
>>>>>
>>>>> This is precisely what I was experiencing last summer when I did work
>>>>> on this issue.
>>>>>
>>>>> My understanding of how async I/O works with io_uring is that the
>>>>> task
>>>>> is added to a wait queue without being put to sleep and when the
>>>>> io_uring callback is called from the interrupt context,
>>>>> task_work_add()
>>>>> is called so that the next time io_uring syscall is invoked, pending
>>>>> work is processed to complete the I/O.
>>>>>
>>>>> So if:
>>>>>
>>>>> 1. io_uring request is initiated AND the task is in a wait queue
>>>>> 2. do_coredump() is called before the I/O is completed
>>>>>
>>>>> IMHO, this is how you end up having task_work_add() called while the
>>>>> coredump is generated.
>>>>>
>>>> I forgot to add that I have experienced the issue with TCP/IP I/O.
>>>>
>>>> I suspect that with a TCP socket, the race condition window is much
>>>> larger than if it was disk I/O and this might make it easier to
>>>> reproduce the issue this way...
>>>
>>> I was under the apparently mistaken impression that the io_uring
>>> task_work_add only comes from the io_uring userspace helper threads.
>>> Those are definitely suppressed by my change.
>>>
>>> Do you have any idea in the code where io_uring code is being called in
>>> an interrupt context?  I would really like to trace that code path so I
>>> have a better grasp on what is happening.
>>>
>>> If task_work_add is being called from interrupt context then something
>>> additional from what I have proposed certainly needs to be done.
>>
>> task_work may come from the helper threads, but generally it does not.
>> One example would be doing a read from a socket. There's no data there,
>> poll is armed to trigger a retry. When we get the poll notification that
>> there's now data to be read, then we kick that off with task_work. Since
>> it's from the poll handler, it can trigger from interrupt context. See
>> the path from io_uring/poll.c:io_poll_wake() -> __io_poll_execute() ->
>> io_req_task_work_add() -> task_work_add().
> 
> But that is a task_work to the helper thread correct?

No, it goes to the task that originally allocated/issued the request.
Which would be the original task, unless the request was originally
marked as going straight to a helper (IOSQE_ASYNC). For most cases,
it'll be the original task, not a helper thread.

>> It can also happen for regular IRQ based reads from regular files, where
>> the completion is actually done via task_work added from the potentially
>> IRQ based completion path.
> 
> I can see that.
> 
> Which leaves me with the question do these task_work's directly wake up
> the thread that submitted the I/O request?   Or is there likely to be
> something for an I/O thread to do before an ordinary program thread is
> notified.
> 
> I am asking because it is only the case of notifying ordinary program
> threads that is interesting in the case of a coredump.  As I understand
> it a data to read notification would typically be handled by the I/O
> uring worker thread to trigger reading the data before letting userspace
> know everything it asked to be done is complete.

By default, it'll go back to the original task. If something is
pollable, then there's no helper thread doing the request. An issue
attempt is performed by the original task, there's no data/space there,
poll is armed to trigger a retry. Retry notification will then queue
task_work with the original task to retry.

Generally for io_uring, helper threads are a slow path and aren't used
unless we have no other options. For example, if someone has a network
IO backend and there's helper thread activity, then that's generally a
sign that something is wrong. This isn't super relevant to this
particular topic, just highlighting that normally you would not expect
to see much (if any) io-wq activity at all.

-- 
Jens Axboe
