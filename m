Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E013154C720
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242181AbiFOLEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344642AbiFOLEn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:04:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF98F54027
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:04:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eo8so7355307edb.0
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=AnArrOnz/uisGXJN86fJXR4mrk+ZehdVE7aQL5mzTJY=;
        b=FtXSm88I6iooRXFFO1nXefSkdygDq8PihkZgbV2j0GRgUvd74/JHDVUcsSNgRf93kK
         t99brVGd8cYj8M9bJSWIXNBr1/qITJL7ilQ/sUskpj4RbWSOWm1ygC1YFwzUTspgZcy7
         Zv5DEjKC/gbKNObf0Cj4V/xhqU10wPOdWUDwhA98sDrCK5cjIZemjlyqMmWIKmR/KhAi
         T1o2xdQwJ3Mbzl56xKkdRnNOYd3z0JFjDSJ3fTPmk66CFO3M5c92cXcU6gXN++53N/S6
         f2XTVkYFJQZcUAWMPQZTlty2wC4z53M1cbtl5kMRcfmGjAspkFcLP69XJ+vlF/jGzd+J
         GDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=AnArrOnz/uisGXJN86fJXR4mrk+ZehdVE7aQL5mzTJY=;
        b=OB3faeoOWqlu/jjYwbaOsg1p9yZUio2+hGCtfxv7KWiqOl48CITJDbk93/+NY7cl+T
         rKyZBOonqZAgaldz/iHfTmjm0JifjLMvZECqkwsJQ774HS/HycjkFbOBza1S8AZvAtlj
         zcz7OM8fsx6A1+NTFmoWLvPbYRga0C22snEwkCpczWHVxDCt+UFiAMuRW8Ftbakhqo2W
         BbTWxQFQUvORRkx9OnpHImI/MWTez7sSqBuhUZkdXaYZb+edZRSrF/icDIplIDPm+ouh
         wW0vgPkAx+uGjRn5rnXTdt17Khj2C51z6/yZvGuE4EhQK6wbRgxgRIjBP6wuSIglwtg1
         AE6w==
X-Gm-Message-State: AJIora/qoslizCRzmQfLBL6xPaYH5LtAyQQN8fhZyGGIB957QQW1fbxF
        gWCvrKt8KvF+LB9b+uhN1bnJzA==
X-Google-Smtp-Source: AGRyM1sZ760eJcoUul5JW1yibWAdHs2PhMAfwjdAdDOylP71Y/D+yNYDbN1ITWOaCKBLHJfhg0QCSA==
X-Received: by 2002:a05:6402:369b:b0:431:665e:f91a with SMTP id ej27-20020a056402369b00b00431665ef91amr12062509edb.350.1655291054273;
        Wed, 15 Jun 2022 04:04:14 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id f24-20020a170906085800b00711c7cca428sm6144417ejd.155.2022.06.15.04.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 04:04:13 -0700 (PDT)
Message-ID: <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
Date:   Wed, 15 Jun 2022 14:04:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
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
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <95bfb0d1-224b-7498-952a-ea2464b353d9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 15/06/2022 13.48, Pavel Begunkov wrote:
> On 6/15/22 11:12, Avi Kivity wrote:
>>
>> On 19/04/2022 20.14, Jens Axboe wrote:
>>> On 4/19/22 9:21 AM, Jens Axboe wrote:
>>>> On 4/19/22 6:31 AM, Jens Axboe wrote:
>>>>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>>>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I expect the loss is due to an optimization that io_uring 
>>>>>>>>>> lacks -
>>>>>>>>>> inline completion vs workqueue completion:
>>>>>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>>>>>> completions.
>>>>>>>> I measured this:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>    Performance counter stats for 'system wide':
>>>>>>>>
>>>>>>>>            1,273,756 io_uring:io_uring_task_add
>>>>>>>>
>>>>>>>>         12.288597765 seconds time elapsed
>>>>>>>>
>>>>>>>> Which exactly matches with the number of requests sent. If 
>>>>>>>> that's the
>>>>>>>> wrong counter to measure, I'm happy to try again with the correct
>>>>>>>> counter.
>>>>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>>>>> expected.
>>>> Might actually be implicated. Not because it's a async worker, but
>>>> because I think we might be losing some affinity in this case. Looking
>>>> at traces, we're definitely bouncing between the poll completion side
>>>> and then execution the completion.
>>>>
>>>> Can you try this hack? It's against -git + for-5.19/io_uring. If 
>>>> you let
>>>> me know what base you prefer, I can do a version against that. I see
>>>> about a 3% win with io_uring with this, and was slower before against
>>>> linux-aio as you saw as well.
>>> Another thing to try - get rid of the IPI for TWA_SIGNAL, which I
>>> believe may be the underlying cause of it.
>>>
>>
>> Resurrecting an old thread. I have a question about timeliness of 
>> completions. Let's assume a request has completed. From the patch, it 
>> appears that io_uring will only guarantee that a completion appears 
>> on the completion ring if the thread has entered kernel mode since 
>> the completion happened. So user-space polling of the completion ring 
>> can cause unbounded delays.
>
> Right, but polling the CQ is a bad pattern, io_uring_{wait,peek}_cqe/etc.
> will do the polling vs syscalling dance for you.


Can you be more explicit?


I don't think peek is enough. If there is a cqe pending, it will return 
it, but will not cause compeleted-but-unqueued events to generate 
completions.


And wait won't enter the kernel if a cqe is pending, IIUC.


>
> For larger audience, I'll remind that it's an opt-in feature
>

I don't understand - what is an opt-in feature?


>
>> If this is correct (it's not unreasonable, but should be documented), 
>> then there should also be a simple way to force a kernel entry. But 
>> how to do this using liburing? IIUC if I the following apply:
>>
>>
>>   1. I have no pending sqes
>>
>>   2. There are pending completions
>>
>>   3. There is a completed event for which a completion has not been 
>> appended to the completion queue ring
>>
>>
>> Then io_uring_wait_cqe() will elide io_uring_enter() and the 
>> completed-but-not-reported event will be delayed.
>
> One way is to process all CQEs and then it'll try to enter the
> kernel and do the job.
>
> Another way is to also set IORING_SETUP_TASKRUN_FLAG, then when
> there is work that requires to enter the kernel io_uring will
> set IORING_SQ_TASKRUN in sq_flags.
> Actually, I'm not mistaken io_uring has some automagic handling
> of it internally
>
> https://github.com/axboe/liburing/blob/master/src/queue.c#L36
>
>
>
