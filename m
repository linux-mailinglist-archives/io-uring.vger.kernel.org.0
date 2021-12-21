Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8E447C2D4
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 16:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239342AbhLUPdP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 10:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239307AbhLUPdP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 10:33:15 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F390C061574
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 07:33:15 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id b187so18152869iof.11
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 07:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PlDLVF0Dz1UVSQes5eiEEzhfQ5nRJg89itgPR9RUD4g=;
        b=SkkmiwEQBHZGm/zjG/WZ3hqH6ExjfPdkW0tN6TWMeG0KiaB+fJVkDTflIXzXkwNysG
         Y9R0cNC3lXeFNVpayBeRLezN1Qq6UgiyIP70V0QVGD2h0bb9cuAxCYv4TnxDuImseLsM
         49ClZ69/SJ9acr1Ri87BkbNRMiraopPuTTqS+xzZzQa61nI+NS3GAph/8fquIer9xKpv
         e63MbINaxCnxi1I+ekhkwmD8QPvAFC5630cMTCZqNm5yQNM89VKCTE4YyEg7Qdd4EOyk
         hk/77v+j/Ul43WLH8rEWCZnucG4AiGeerMSEckZJlqn71L5xSkA6uGR1MuapnNWhcKe5
         rQdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PlDLVF0Dz1UVSQes5eiEEzhfQ5nRJg89itgPR9RUD4g=;
        b=yRIAV8PD6bz8arumbS0bi6AqvdptvpeJlOqycSm14mu0qIghZk1W8gQJEjN3d4vUTO
         fLfhEWuvaLENZALDlIDBxeT12UHqeJIzUUer6ROptylCkZmV0Y1Rz7Jfg0yErgG+OvFx
         3mN4YgWDPWB6EpssrE4CndY8F/zP1s43CMUJEw/d+A21xaIgl0y2ZP6MTjNr23sFUj/g
         SLudLF/rYmUtc5HEp2ojCg9Xqh/BhQoBw19VnwSFzFqiEBdV895arzm8rc325hfcDRAi
         rm0vEiW2xAlOUDN5sN8Yb56AYloUcxLpiX1BYK/lpkRhKtANbtiy9nsZgJXFkWUk3PrO
         tzbg==
X-Gm-Message-State: AOAM530iX+kM2CKhWGZm93Jree+aOAX1zTvDMGGFm4k8JTvP0+IM4KNk
        PeHsfLqqhHYZXVxnVAuf0W+iPxwRmiJguw==
X-Google-Smtp-Source: ABdhPJxgNxDg6EPBy2UwskEIsk4ypZBzkVeVl9NtTL/aU7PTX7nfx7Jc0JhGB4EC96XxJbHp6XY1XA==
X-Received: by 2002:a02:c90c:: with SMTP id t12mr2226434jao.247.1640100794638;
        Tue, 21 Dec 2021 07:33:14 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e9sm10238415ilm.44.2021.12.21.07.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 07:33:14 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <9b4202b4-192a-6611-922e-0b837e2b97c3@nvidia.com>
 <5f249c03-5cb2-9978-cd2c-669c0594d1c0@kernel.dk>
 <d1613b7f-342d-08ad-d655-a6afb89e1847@nvidia.com>
 <a159220b-6e0c-6ee9-f8e2-c6dc9f6dfaed@kernel.dk>
 <3474493a-a04d-528c-7565-f75db5205074@nvidia.com>
 <87e3a197-e8f7-d8d6-85b6-ce05bf1f35cd@kernel.dk>
 <5ee0e257-651a-ec44-7ca3-479438a737fb@nvidia.com>
 <e3974442-3b3f-0419-519c-7360057c4603@kernel.dk>
 <01f9ce91-d998-c823-f2f2-de457625021e@nvidia.com>
 <573bbe72-d232-6063-dd34-2e12d8374594@kernel.dk>
 <4fbf2936-8e4c-9c04-e5a9-10eae387b562@nvidia.com>
 <6ca82929-7e70-be15-dcbb-1e68a02dd933@kernel.dk>
 <e1afcf34-a283-a88a-fa0b-26c7c1094e74@nvidia.com>
 <92c5065e-dc2a-9e3f-404a-64c6e22624b7@kernel.dk>
 <5b001e0f-cec0-112d-533a-d71684eb1d2e@nvidia.com>
 <7cbaa97b-4d79-82ca-d037-7d47f089ba8a@kernel.dk>
 <caee56c1-604a-be64-5b34-93f32c4de621@nvidia.com>
 <c437d44f-6309-9e18-edc1-7bb0da4a54e2@kernel.dk>
 <460ad0f5-7fb5-85c4-2718-20eeefe2050c@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b8b62607-4b2d-9b3f-4cd6-6d66defb078c@kernel.dk>
Date:   Tue, 21 Dec 2021 08:33:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <460ad0f5-7fb5-85c4-2718-20eeefe2050c@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/21 8:29 AM, Max Gurtovoy wrote:
> 
> On 12/21/2021 5:23 PM, Jens Axboe wrote:
>> On 12/21/21 3:20 AM, Max Gurtovoy wrote:
>>> On 12/20/2021 8:58 PM, Jens Axboe wrote:
>>>> On 12/20/21 11:48 AM, Max Gurtovoy wrote:
>>>>> On 12/20/2021 6:34 PM, Jens Axboe wrote:
>>>>>> On 12/20/21 8:29 AM, Max Gurtovoy wrote:
>>>>>>> On 12/20/2021 4:19 PM, Jens Axboe wrote:
>>>>>>>> On 12/20/21 3:11 AM, Max Gurtovoy wrote:
>>>>>>>>> On 12/19/2021 4:48 PM, Jens Axboe wrote:
>>>>>>>>>> On 12/19/21 5:14 AM, Max Gurtovoy wrote:
>>>>>>>>>>> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>>>>>>>>>>>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>>>>>>>>>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>>>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>>>>>>>>>>>> error?
>>>>>>>>>>>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>>>>>>>>>>>> algorithm ?
>>>>>>>>>>>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>>>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>>>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>>>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>>>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>>>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>>>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>>>>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>>>>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>>>>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>>>>>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>>>>>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>>>>>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>>>>>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>>>>>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>>>>>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>>>>>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>>>>>>>>>>>> will result in a plug flush to begin with.
>>>>>>>>>>>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>>>>>>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>>>>>>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>>>>>>>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>>>>>>>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>>>>>>>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>>>>>>>>>>>> requests are issued.
>>>>>>>>>>>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>>>>>>>>>>>> of 28 ? or 1 by 1 ?
>>>>>>>>>>>>>> --iodepth just controls the overall depth, the batch submit count
>>>>>>>>>>>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>>>>>>>>>>>> one at the time, then you'll get one at the time further down too. Hence
>>>>>>>>>>>>>> the batching is directly driven by what the application is already
>>>>>>>>>>>>>> doing.
>>>>>>>>>>>>> I see. Thanks for the explanation.
>>>>>>>>>>>>>
>>>>>>>>>>>>> So it works only for io_uring based applications ?
>>>>>>>>>>>> It's only enabled for io_uring right now, but it's generically available
>>>>>>>>>>>> for anyone that wants to use it... Would be trivial to do for aio, and
>>>>>>>>>>>> other spots that currently use blk_start_plug() and has an idea of how
>>>>>>>>>>>> many IOs will be submitted
>>>>>>>>>>> Can you please share an example application (or is it fio patches) that
>>>>>>>>>>> can submit batches ? The same that was used to test this patchset is
>>>>>>>>>>> fine too.
>>>>>>>>>>>
>>>>>>>>>>> I would like to test it with our NVMe SNAP controllers and also to
>>>>>>>>>>> develop NVMe/RDMA queue_rqs code and test the perf with it.
>>>>>>>>>> You should just be able to use iodepth_batch with fio. For my peak
>>>>>>>>>> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
>>>>>>>>>> and do batches of 32 for complete and submit. You can just run:
>>>>>>>>>>
>>>>>>>>>> t/io_uring <dev or file>
>>>>>>>>>>
>>>>>>>>>> maybe adding -p0 for IRQ driven rather than polled IO.
>>>>>>>>> I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA
>>>>>>>>> but it was never called using the t/io_uring test nor fio with
>>>>>>>>> iodepth_batch=32 flag with io_uring engine.
>>>>>>>>>
>>>>>>>>> Any idea what might be the issue ?
>>>>>>>>>
>>>>>>>>> I installed fio from sources..
>>>>>>>> The two main restrictions right now are a scheduler and shared tags, are
>>>>>>>> you using any of those?
>>>>>>> No.
>>>>>>>
>>>>>>> But maybe I'm missing the .commit_rqs callback. is it mandatory for this
>>>>>>> feature ?
>>>>>> I've only tested with nvme pci which does have it, but I don't think so.
>>>>>> Unless there's some check somewhere that makes it necessary. Can you
>>>>>> share the patch you're currently using on top?
>>>>> The attached POC patches apply cleanly on block/for-next branch
>>>> Looks reasonable to me from a quick glance. Not sure why you're not
>>>> seeing it hit, maybe try and instrument
>>>> block/blk-mq.c:blk_mq_flush_plug_list() and find out why it isn't being
>>>> called? As mentioned, no elevator or shared tags, should work for
>>>> anything else basically.
>>> Yes. I saw that the blk layer converted the original non-shared tagset
>>> of NVMe/RDMA to a shared one because of the nvmf connect request queue
>>> that is using the same tagset (uses only the reserved tag).
>>>
>>> So I guess this is the reason that the I couldn't reach the new code of
>>> queue_rqs.
>>>
>>> The question is how we can overcome this ?
>> Do we need to mark it shared for just the reserved tags? I wouldn't
>> think so...
> 
> We don't mark it. The block layer does it in blk_mq_add_queue_tag_set:
> 
> if (!list_empty(&set->tag_list) &&
>              !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED))

Yes, that's what I meant, do we need to mark it as such for just the
reserved tags?

-- 
Jens Axboe

