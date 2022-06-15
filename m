Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1D654C788
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347683AbiFOLbW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbiFOLbS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:31:18 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B1953A52
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:31:17 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q15so14919947wrc.11
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=uzVTwI+Uk7ULZCZUZQ4OjcJoO0gov1XnfSdbyac9PCU=;
        b=eLUm5H7ok+NIHm+z4fqLPdkHQ6mGf7mmsl7EhNpBILdYu8AlKVccu0renTDItAYkgy
         1oFAUl6aFtz6lleyB5E718hc/WI/S1SNT3g6pUuZBlp8rr1/ZaUo4DCG5f0O7pdbtdC4
         dxdSXKfQ3Y5x4U01MjNF3omhsuANm7wWfTuK3wwcH2w+0n+mCKJgL+IWAiJp8U3tuFw8
         anx2ye/GBUK38Lw78pqPwIZENcGSyxqJsoX2JPLJiTLkmnKbV5G8QZsmQH4VfCvrdT4K
         qDiX2a4MSW8EheHpz1urFIPjmzwaXx9M8oNBvyZyyS4ac9cEjTTkTRr7zXjp7UF9fKrU
         ufZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uzVTwI+Uk7ULZCZUZQ4OjcJoO0gov1XnfSdbyac9PCU=;
        b=bGl7vuptWQgEyZBDJeAKnxtTxBusVqjaowFBJwY8qw0BnAKumVk1atk9Kw2tLYbjkA
         jO2bpt4qw71s0ZmSQpDocKLj4pemY5pmngnekQda1QCFMJuPqEe/Nb6iUfm5x9SxBOZK
         10VMzkqiQc84l9X6wfAKSA5I9xkohgal3wUK8vMreI7yG/wmC4wJZnTmtTlDvPPe8gGN
         yZjWKc24vMejNvmQ22hZHzguVUbhRjtY7wpiVuvyMP5N8H7QcQ2/2dmZsHR063yCajqD
         1xUQDzyQsYJ1qbVamXyFuNkeNuIuRrALpA9RLbqscwy43zNJYaCm8M0KgB8xr6ZmxOaq
         kYuA==
X-Gm-Message-State: AJIora/VIlcBHPa1FJmbKJr4aFUENuE59ZQvbTZY9+jzBhrN5NpLK3vi
        dp0S0f7LdzQv+VtpYFogOvBh7V7JLP4t+A==
X-Google-Smtp-Source: AGRyM1uY37zHsU/9S4Hje6+AH0FCHNMp0Eg9C0ZdXw9pp5PJStolad3zcMTvtL1KpW5nMdWBrV1+Dw==
X-Received: by 2002:a05:6000:ce:b0:211:7f0b:a679 with SMTP id q14-20020a05600000ce00b002117f0ba679mr9507393wrx.261.1655292676183;
        Wed, 15 Jun 2022 04:31:16 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id f7-20020a5d50c7000000b0021031c894d3sm14684844wrt.94.2022.06.15.04.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 04:31:15 -0700 (PDT)
Message-ID: <7b275cab-07a3-2399-cbcd-2de8864af97b@gmail.com>
Date:   Wed, 15 Jun 2022 12:30:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
 <1d79b0e6-ee65-6eab-df64-3987a7f7f4e7@scylladb.com>
 <95bfb0d1-224b-7498-952a-ea2464b353d9@gmail.com>
 <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 12:04, Avi Kivity wrote:
> 
> On 15/06/2022 13.48, Pavel Begunkov wrote:
>> On 6/15/22 11:12, Avi Kivity wrote:
>>>
>>> On 19/04/2022 20.14, Jens Axboe wrote:
>>>> On 4/19/22 9:21 AM, Jens Axboe wrote:
>>>>> On 4/19/22 6:31 AM, Jens Axboe wrote:
>>>>>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>>>>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>>>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>>>>>>>> inline completion vs workqueue completion:
>>>>>>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>>>>>>> completions.
>>>>>>>>> I measured this:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>    Performance counter stats for 'system wide':
>>>>>>>>>
>>>>>>>>>            1,273,756 io_uring:io_uring_task_add
>>>>>>>>>
>>>>>>>>>         12.288597765 seconds time elapsed
>>>>>>>>>
>>>>>>>>> Which exactly matches with the number of requests sent. If that's the
>>>>>>>>> wrong counter to measure, I'm happy to try again with the correct
>>>>>>>>> counter.
>>>>>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>>>>>> expected.
>>>>> Might actually be implicated. Not because it's a async worker, but
>>>>> because I think we might be losing some affinity in this case. Looking
>>>>> at traces, we're definitely bouncing between the poll completion side
>>>>> and then execution the completion.
>>>>>
>>>>> Can you try this hack? It's against -git + for-5.19/io_uring. If you let
>>>>> me know what base you prefer, I can do a version against that. I see
>>>>> about a 3% win with io_uring with this, and was slower before against
>>>>> linux-aio as you saw as well.
>>>> Another thing to try - get rid of the IPI for TWA_SIGNAL, which I
>>>> believe may be the underlying cause of it.
>>>>
>>>
>>> Resurrecting an old thread. I have a question about timeliness of completions. Let's assume a request has completed. From the patch, it appears that io_uring will only guarantee that a completion appears on the completion ring if the thread has entered kernel mode since the completion happened. So user-space polling of the completion ring can cause unbounded delays.
>>
>> Right, but polling the CQ is a bad pattern, io_uring_{wait,peek}_cqe/etc.
>> will do the polling vs syscalling dance for you.
> 
> 
> Can you be more explicit?
> 
> 
> I don't think peek is enough. If there is a cqe pending, it will return it, but will not cause compeleted-but-unqueued events to generate completions.
> 
> 
> And wait won't enter the kernel if a cqe is pending, IIUC.

Right, usually it won't, but works if you eventually end up
waiting, e.g. by waiting for all expected cqes.


>> For larger audience, I'll remind that it's an opt-in feature
>>
> 
> I don't understand - what is an opt-in feature?

The behaviour that you worry about when CQEs are not posted until
you do syscall, it's only so if you set IORING_SETUP_COOP_TASKRUN.


>>> If this is correct (it's not unreasonable, but should be documented), then there should also be a simple way to force a kernel entry. But how to do this using liburing? IIUC if I the following apply:
>>>
>>>
>>>   1. I have no pending sqes
>>>
>>>   2. There are pending completions
>>>
>>>   3. There is a completed event for which a completion has not been appended to the completion queue ring
>>>
>>>
>>> Then io_uring_wait_cqe() will elide io_uring_enter() and the completed-but-not-reported event will be delayed.
>>
>> One way is to process all CQEs and then it'll try to enter the
>> kernel and do the job.
>>
>> Another way is to also set IORING_SETUP_TASKRUN_FLAG, then when
>> there is work that requires to enter the kernel io_uring will
>> set IORING_SQ_TASKRUN in sq_flags.
>> Actually, I'm not mistaken io_uring has some automagic handling
>> of it internally
>>
>> https://github.com/axboe/liburing/blob/master/src/queue.c#L36
>>
>>
>>

-- 
Pavel Begunkov
