Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7504247A104
	for <lists+io-uring@lfdr.de>; Sun, 19 Dec 2021 15:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhLSOsp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Dec 2021 09:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbhLSOso (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Dec 2021 09:48:44 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75180C061574
        for <io-uring@vger.kernel.org>; Sun, 19 Dec 2021 06:48:44 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id k21so10101879ioh.4
        for <io-uring@vger.kernel.org>; Sun, 19 Dec 2021 06:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tLslNh35lX6awF6jHiRUpCC73uOfcNwrJ0i0JnkoPqM=;
        b=RcnS8qz/lF363AxUd5nqZAEtTevwiNMgbZ8n4nqKKeaGUryiZws8/+j2rxYKj1+C8H
         m5beSqfobOYRX8x8qVmwCs2QkMEr1FzzcPLDmcjGl0251u5EnGkVrK6HmzxedL4/i/iF
         bqFO2f3jtsJrnFsyhnGg/Of3in6ixkzjY8Z4Y08Hhru3gHwxhaWvEEo7wcj8XIk3HIaY
         EYfFgWSU1NJF5R9gurpQbIfeQl8Ek+dS1pRerYK0Cw+NYlkWsHA6cmU6fJSilh6nE5Iu
         4WmX1Lu7WQaE4rKsoPoyKuORsZiwDPQ/XO2RylJEF+C9Uh2FqXpq0PZC9AgsinE7QROS
         R4Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLslNh35lX6awF6jHiRUpCC73uOfcNwrJ0i0JnkoPqM=;
        b=STLQH7LifQZN047GyPbso2+47jk81PGwi2oZiCn+oNbP+iY9phnbg9KQZ3Xn8HjVqL
         k0NBk7Z8XRjS/7EYZ9mk32IfKRt2GHi5vWuXS7W4Z2yBd3AzjITcLhGQhYqfMSjQ8FS/
         Ej7AcSCbbaNl57rKGQyNh2rNXPaftfpPpwGu+RHuM+ciQ9xWBddhtoeXHmWw5AH5aZTC
         /JDHSdEaHz/sGrnliJVgWgL9SxGYytDyj7GT4r7c+NTYFDk85jejP8Q1lXV3GuAQG3Mm
         lMjtr6W7sRbZFrN/F8ZIRWSum2iQstgR+017jcOhzgKTIBSlItTcKPRZlcsrGz3q2szN
         KK6A==
X-Gm-Message-State: AOAM533Oi2B1dfPRevnYJe/u2rsy1Vz0hSpfX6T6b5w15vLX2izimZjC
        FyYRFSLLi8VS4lDU9ZTZzULEOA==
X-Google-Smtp-Source: ABdhPJziAgLz6bBLg/megYE/ZNGKCFirQU8QOGYhJL+txqzjWPfTXZ8HQTpgssmMBN6RRMGx9fMoNw==
X-Received: by 2002:a02:6d4f:: with SMTP id e15mr7196087jaf.55.1639925323609;
        Sun, 19 Dec 2021 06:48:43 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d11sm8975240ilv.73.2021.12.19.06.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 06:48:43 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
 <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
 <9b4202b4-192a-6611-922e-0b837e2b97c3@nvidia.com>
 <5f249c03-5cb2-9978-cd2c-669c0594d1c0@kernel.dk>
 <d1613b7f-342d-08ad-d655-a6afb89e1847@nvidia.com>
 <a159220b-6e0c-6ee9-f8e2-c6dc9f6dfaed@kernel.dk>
 <3474493a-a04d-528c-7565-f75db5205074@nvidia.com>
 <87e3a197-e8f7-d8d6-85b6-ce05bf1f35cd@kernel.dk>
 <5ee0e257-651a-ec44-7ca3-479438a737fb@nvidia.com>
 <e3974442-3b3f-0419-519c-7360057c4603@kernel.dk>
 <01f9ce91-d998-c823-f2f2-de457625021e@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <573bbe72-d232-6063-dd34-2e12d8374594@kernel.dk>
Date:   Sun, 19 Dec 2021 07:48:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01f9ce91-d998-c823-f2f2-de457625021e@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/21 5:14 AM, Max Gurtovoy wrote:
> 
> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>> +
>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>
>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>
>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>
>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>> error?
>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>
>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>> algorithm ?
>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>
>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>
>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>> will result in a plug flush to begin with.
>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>
>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>
>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>> requests are issued.
>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>> of 28 ? or 1 by 1 ?
>>>> --iodepth just controls the overall depth, the batch submit count
>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>> one at the time, then you'll get one at the time further down too. Hence
>>>> the batching is directly driven by what the application is already
>>>> doing.
>>> I see. Thanks for the explanation.
>>>
>>> So it works only for io_uring based applications ?
>> It's only enabled for io_uring right now, but it's generically available
>> for anyone that wants to use it... Would be trivial to do for aio, and
>> other spots that currently use blk_start_plug() and has an idea of how
>> many IOs will be submitted
> 
> Can you please share an example application (or is it fio patches) that 
> can submit batches ? The same that was used to test this patchset is 
> fine too.
> 
> I would like to test it with our NVMe SNAP controllers and also to 
> develop NVMe/RDMA queue_rqs code and test the perf with it.

You should just be able to use iodepth_batch with fio. For my peak
testing, I use t/io_uring from the fio repo. By default, it'll run QD of
and do batches of 32 for complete and submit. You can just run:

t/io_uring <dev or file>

maybe adding -p0 for IRQ driven rather than polled IO.

-- 
Jens Axboe

