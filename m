Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC76254C795
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 13:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiFOLgz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 07:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiFOLgz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 07:36:55 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B344553E10
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:36:53 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id s12so22654795ejx.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 04:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=7xrYysmZbqZAQsJ/K50VFYqcLhYm2OqNlgkyG0E4kzw=;
        b=foVUbJ/BXUM3ECpgAfNZtaDgoIPvtXZTGsooBwi2wnf2DYEDgiD6xSyO849ZxC1rB8
         bvJnKLHFMVAvG6E0Tsw2FvjeK88AWHXYVNP94mXJiAlZXHmKNmitmmm397jnVvmeET1f
         ftrDyUueXPdlU1ajNLqoiobexEtr+xUPXEr9DcrUHUZwOEIMSJFtxXjtMsw8Nu2Fk6n2
         b2MomFWD7OeGdxyDD30ae/BeLV5+mAUbZG7TTd2bdI7Tb+USMemmwAbbKRTGhtfvN3RR
         J1xgPXeiKS5ydXybAvLk7Cb5hX5N2JCnMESxZDqRqVp3N3om2HALzhp+9sOxHREp/++m
         Itpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=7xrYysmZbqZAQsJ/K50VFYqcLhYm2OqNlgkyG0E4kzw=;
        b=54sdJaNzk7izUx6tv2GXaNVppCE2OlDN7H1QXHE/RfJZoZt0Hr0T49i/Ra0MMj6L7v
         zJCGkzebXwkgqhQ/ZUR8LtZK2pQOhW+ZZ2xby/w/wJMFPfaHtOCPDq6zR+PWNm+7Smdk
         uLV/mvg8U+q1E/MS3y+NjruaLwZV9THQjpGuotaeWDLR75l46liHhUeaE+XFpEnICZ7B
         TB3hNMkR5/9wCTW2YSkLAl0eQtVFH/+woAQoQyJ+5XuZbQsytZGpAaickoEevRCEX426
         qJJwpmnyyp/0kW2g/+u048xQ1kVCW9kvBMkgZ8ThEVdjXXb93/nzBxrdWrEZhItkucXT
         xaGQ==
X-Gm-Message-State: AJIora9l38B2yPA+hTkc+5qzEshfB/IXwEFEfbZt6DYIX6dpLEF7MFCR
        NCua41PKYU45+MADErO2H3WOUw==
X-Google-Smtp-Source: ABdhPJwDvWHwAXW42BZavO9RDtomqsMukLxcKKqLuSTHyWJUXEBDfnk1IbMq1eTvBYELlGVs02eQ3A==
X-Received: by 2002:a17:907:6ea4:b0:711:d106:b93a with SMTP id sh36-20020a1709076ea400b00711d106b93amr8702508ejc.189.1655293012228;
        Wed, 15 Jun 2022 04:36:52 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id v13-20020a17090606cd00b0070d742804a5sm6185597ejb.150.2022.06.15.04.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 04:36:50 -0700 (PDT)
Message-ID: <a85a3ad7-a010-bdd5-0479-b5b415654cc1@scylladb.com>
Date:   Wed, 15 Jun 2022 14:36:48 +0300
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
 <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
 <7b275cab-07a3-2399-cbcd-2de8864af97b@gmail.com>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <7b275cab-07a3-2399-cbcd-2de8864af97b@gmail.com>
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


On 15/06/2022 14.30, Pavel Begunkov wrote:
> On 6/15/22 12:04, Avi Kivity wrote:
>>
>> On 15/06/2022 13.48, Pavel Begunkov wrote:
>>> On 6/15/22 11:12, Avi Kivity wrote:
>>>>
>>>> On 19/04/2022 20.14, Jens Axboe wrote:
>>>>> On 4/19/22 9:21 AM, Jens Axboe wrote:
>>>>>> On 4/19/22 6:31 AM, Jens Axboe wrote:
>>>>>>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>>>>>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>>>>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>>>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> I expect the loss is due to an optimization that io_uring 
>>>>>>>>>>>> lacks -
>>>>>>>>>>>> inline completion vs workqueue completion:
>>>>>>>>>>> I don't think that's it, io_uring never punts to a workqueue 
>>>>>>>>>>> for
>>>>>>>>>>> completions.
>>>>>>>>>> I measured this:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>    Performance counter stats for 'system wide':
>>>>>>>>>>
>>>>>>>>>>            1,273,756 io_uring:io_uring_task_add
>>>>>>>>>>
>>>>>>>>>>         12.288597765 seconds time elapsed
>>>>>>>>>>
>>>>>>>>>> Which exactly matches with the number of requests sent. If 
>>>>>>>>>> that's the
>>>>>>>>>> wrong counter to measure, I'm happy to try again with the 
>>>>>>>>>> correct
>>>>>>>>>> counter.
>>>>>>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>>>>>>> expected.
>>>>>> Might actually be implicated. Not because it's a async worker, but
>>>>>> because I think we might be losing some affinity in this case. 
>>>>>> Looking
>>>>>> at traces, we're definitely bouncing between the poll completion 
>>>>>> side
>>>>>> and then execution the completion.
>>>>>>
>>>>>> Can you try this hack? It's against -git + for-5.19/io_uring. If 
>>>>>> you let
>>>>>> me know what base you prefer, I can do a version against that. I see
>>>>>> about a 3% win with io_uring with this, and was slower before 
>>>>>> against
>>>>>> linux-aio as you saw as well.
>>>>> Another thing to try - get rid of the IPI for TWA_SIGNAL, which I
>>>>> believe may be the underlying cause of it.
>>>>>
>>>>
>>>> Resurrecting an old thread. I have a question about timeliness of 
>>>> completions. Let's assume a request has completed. From the patch, 
>>>> it appears that io_uring will only guarantee that a completion 
>>>> appears on the completion ring if the thread has entered kernel 
>>>> mode since the completion happened. So user-space polling of the 
>>>> completion ring can cause unbounded delays.
>>>
>>> Right, but polling the CQ is a bad pattern, 
>>> io_uring_{wait,peek}_cqe/etc.
>>> will do the polling vs syscalling dance for you.
>>
>>
>> Can you be more explicit?
>>
>>
>> I don't think peek is enough. If there is a cqe pending, it will 
>> return it, but will not cause compeleted-but-unqueued events to 
>> generate completions.
>>
>>
>> And wait won't enter the kernel if a cqe is pending, IIUC.
>
> Right, usually it won't, but works if you eventually end up
> waiting, e.g. by waiting for all expected cqes.
>
>
>>> For larger audience, I'll remind that it's an opt-in feature
>>>
>>
>> I don't understand - what is an opt-in feature?
>
> The behaviour that you worry about when CQEs are not posted until
> you do syscall, it's only so if you set IORING_SETUP_COOP_TASKRUN.
>

Ah! I wasn't aware of this new flag. This is exactly what I want - 
either ask for timely completions, or optimize for throughput.


Of course, it puts me in a dilemma because I want both, but that's my 
problem.


Thanks!


