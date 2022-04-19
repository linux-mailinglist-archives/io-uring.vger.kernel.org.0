Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6214507A8B
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 21:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345719AbiDSUBV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 16:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240510AbiDSUBU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 16:01:20 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE6F26AC5
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 12:58:36 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id q22so12397596iod.2
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 12:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=m9E08e3IyrxKbJZbTNm50FCvG10QuWTPsIuQnuSBKP4=;
        b=lkwlhvLf+v7IImGZYD2bQDv7Tp9Mz19dnyVIvruadt78VTO6DqTBDmLCUJ8Ng4Lt8d
         dsmiwiFqKrMPM2mWIqjcJzy70LfeHU0R3gpnyXlgDjBsNo54VFn7jsM9WGUakob/SKCH
         ylfNVhIxAN7hMkOEK50aCKaU7FarTSfGmRlnhCeH/KQJRL/+MfbkZrPhhu/gx7qm6N0L
         SpUE0G5IlGPp6snHw+qkI2nUYZ+/fLaigQyPIxKePdrg72FGK0x0fyS3lg9k2LpJLis3
         EmVcNJ2MFgbfQXYhQqK8QbMKR8DuezHYlPoQ9ySNjCJGyG1qYGwABUYeADjSdCzFI0Im
         1vAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m9E08e3IyrxKbJZbTNm50FCvG10QuWTPsIuQnuSBKP4=;
        b=XYckLvGhfxTS+ifwcVL9zZwe0RRrvUiQGGi/M95MR4/CQS5CRQf+vBGeYykjRHsluo
         aIHG3G0kjscqh85eCGGxFyezsr1opuUgoQpB0rltg6CbzaRLG3Rue+mAl1DqRKmFYRgJ
         O6mQhpgYbjvt33MrUZxS3xJ/J2waZCWw63d2OIIKzPfHFqXp7wjHg56bJ9i+MAyAoDXP
         T7U0ONoTmcB9yZ9p/TwWS/Cr829WbcWx3CDo5ldiiSLxvSinq9Rs518OHON+ZqLyOJ0O
         mQvWEq503OILsUpWLkhqmyF+fQBetprKQoIIuqvPwT33dmsuc/bf+cdy+33exi0Dm2+f
         eEbw==
X-Gm-Message-State: AOAM532i94PPH+W2i4slPNoUsxrmfdR//YWbZJIQKPjPBj/XPjnECMAH
        S2irRODaQIqTJ6PWVFSEfnEeMA==
X-Google-Smtp-Source: ABdhPJwZQ8ff8XLtoXUYIIrMITSWuQW1/gYWuO7zeZWbjhhpAi7f+0r1/KAxuLEmf/rfhG66tilrxQ==
X-Received: by 2002:a05:6638:13c1:b0:323:cda3:d10c with SMTP id i1-20020a05663813c100b00323cda3d10cmr8429261jaj.111.1650398315918;
        Tue, 19 Apr 2022 12:58:35 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c203-20020a6bb3d4000000b0064f9d0c0da7sm10127913iof.32.2022.04.19.12.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 12:58:35 -0700 (PDT)
Message-ID: <686bb243-268d-1749-e376-873077b8f3a3@kernel.dk>
Date:   Tue, 19 Apr 2022 13:58:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
 <96cdef5a-a818-158d-f109-e96f0038bf14@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <96cdef5a-a818-158d-f109-e96f0038bf14@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/22 1:41 PM, Avi Kivity wrote:
> 
> On 19/04/2022 20.14, Jens Axboe wrote:
>> On 4/19/22 9:21 AM, Jens Axboe wrote:
>>> On 4/19/22 6:31 AM, Jens Axboe wrote:
>>>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>>>>>> inline completion vs workqueue completion:
>>>>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>>>>> completions.
>>>>>>> I measured this:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>    Performance counter stats for 'system wide':
>>>>>>>
>>>>>>>            1,273,756 io_uring:io_uring_task_add
>>>>>>>
>>>>>>>         12.288597765 seconds time elapsed
>>>>>>>
>>>>>>> Which exactly matches with the number of requests sent. If that's the
>>>>>>> wrong counter to measure, I'm happy to try again with the correct
>>>>>>> counter.
>>>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>>>> expected.
>>> Might actually be implicated. Not because it's a async worker, but
>>> because I think we might be losing some affinity in this case. Looking
>>> at traces, we're definitely bouncing between the poll completion side
>>> and then execution the completion.
>>>
>>> Can you try this hack? It's against -git + for-5.19/io_uring. If you let
>>> me know what base you prefer, I can do a version against that. I see
>>> about a 3% win with io_uring with this, and was slower before against
>>> linux-aio as you saw as well.
>> Another thing to try - get rid of the IPI for TWA_SIGNAL, which I
>> believe may be the underlying cause of it.
>>
> 
> Won't it delay notification until the next io_uring_enter? Or does
> io_uring only guarantee completions when you call it (and earlier
> completions are best-effort?)

Only if it needs to reschedule, it'll still enter the kernel if not. Or
if it's waiting in the kernel, it'll still run the task work as the
TIF_NOTIFY_SIGNAL will get that job done.

So actually not sure if we ever need the IPI, doesn't seem like we do.

> I'll try it tomorrow (also the other patch).

Thanks!

-- 
Jens Axboe

