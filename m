Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CACE74FC8B
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 03:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjGLBRu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 21:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGLBRs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 21:17:48 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86809ED
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 18:17:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-66d6a9851f3so1021066b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 18:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689124666; x=1691716666;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VGkTC8Gj/gfYNbDNWTQmXKgHFOdtSXd2APw2ttqbxOE=;
        b=5gVnq2uSnSnj+pxBw+jJRhxaDg2WfindRgD9xptAakFOuQ9SqF11kbB0lfjuUuPS5m
         xQiGP+DWnq0Sn4S5APHO7GfhEZrVC5qK1Kfvrt+3//XRaNKHIb/Kx+Hk2ikhobgVhHdt
         YFBbDaWYLaznRfCr+fYzQg1EcGyeSLadMThYXl8yucO45qGYVn3gpjYoggdyMErayszL
         l6ak+02WFxKSYM4oa391m/ACEkp7Q7sHeLDeZqyu1Co9Sfcda14ZNgQLa0zd0vDUWJw0
         lvQm5XfxcLGBOAG17rYCt9ngRv5tSSdziKb9B4h7cn3IytEKB4Mjm3Zo+zxNdxpfOXaC
         Q89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689124666; x=1691716666;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGkTC8Gj/gfYNbDNWTQmXKgHFOdtSXd2APw2ttqbxOE=;
        b=Rg3R13xOb3xx0+Vxt7XTrqLHqJdMABaTCpzBdtAaH6ypcLbDaBXlzdNylPJ3/OF98Q
         McLeznMBkgFn9TebR0ZjQCUrae4Y+Ua8PvX99jubv6cUhvL/NCurxJ4uoHeUiGQTMIgr
         kkkitYHZJNoy5NI/BEJk0AsAPuCWR9quS6/PNmN0QHZR/tRzITJwx0huvSiISFTQuuo5
         l0/uyXt9G/FA++nTxDF4tNQyZb7cPjU+AtyOEaeDl+mRCm8KdSds8Nu9+7TGfTrWJzxi
         0h2GjEHbA5oNN1vPzgSxmEbUtHs++Vqkry3BlwfApgp0eZotKTmCb9MfXE+piSWm75mQ
         RD4Q==
X-Gm-Message-State: ABy/qLbo/ORxHEDekxHpIDRKAZMEBOsGyxVizezo5PRAU0Do3hG9/RLu
        3nnAOH7v7ATcSBRrRO8ejz2J6w==
X-Google-Smtp-Source: APBJJlEu5eSE3FjTGTXXIvsyNYXPP719bWFLbHfMUFeU92jir+RXX11lZ3/mU3OAH4Dp/6EvxECXSA==
X-Received: by 2002:a05:6a20:4424:b0:111:a0e5:d2b7 with SMTP id ce36-20020a056a20442400b00111a0e5d2b7mr24528179pzb.4.1689124665855;
        Tue, 11 Jul 2023 18:17:45 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f21-20020aa782d5000000b006829b27f252sm2370115pfn.93.2023.07.11.18.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 18:17:45 -0700 (PDT)
Message-ID: <2c412c93-b197-b504-bfc5-433621a11ec5@kernel.dk>
Date:   Tue, 11 Jul 2023 19:17:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/5] iomap: complete polled writes inline
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
References: <20230711203325.208957-1-axboe@kernel.dk>
 <20230711203325.208957-2-axboe@kernel.dk>
 <ZK37j/BqFYXLjV/B@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZK37j/BqFYXLjV/B@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/23 7:02?PM, Dave Chinner wrote:
> On Tue, Jul 11, 2023 at 02:33:21PM -0600, Jens Axboe wrote:
>> Polled IO is always reaped in the context of the process itself, so it
>> does not need to be punted to a workqueue for the completion. This is
>> different than IRQ driven IO, where iomap_dio_bio_end_io() will be
>> invoked from hard/soft IRQ context. For those cases we currently need
>> to punt to a workqueue for further processing. For the polled case,
>> since it's the task itself reaping completions, we're already in task
>> context. That makes it identical to the sync completion case.
>>
>> Testing a basic QD 1..8 dio random write with polled IO with the
>> following fio job:
>>
>> fio --name=polled-dio-write --filename=/data1/file --time_based=1 \
>> --runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
>> --cpus_allowed=4 --ioengine=io_uring --iodepth=$depth --hipri=1
> 
> Ok, so this is testing pure overwrite DIOs as fio pre-writes the
> file prior to starting the random write part of the test.

Correct.

>> yields:
>>
>> 	Stock	Patched		Diff
>> =======================================
>> QD1	180K	201K		+11%
>> QD2	356K	394K		+10%
>> QD4	608K	650K		+7%
>> QD8	827K	831K		+0.5%
>>
>> which shows a nice win, particularly for lower queue depth writes.
>> This is expected, as higher queue depths will be busy polling
>> completions while the offloaded workqueue completions can happen in
>> parallel.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/iomap/direct-io.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index ea3b868c8355..343bde5d50d3 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -161,15 +161,16 @@ void iomap_dio_bio_end_io(struct bio *bio)
>>  			struct task_struct *waiter = dio->submit.waiter;
>>  			WRITE_ONCE(dio->submit.waiter, NULL);
>>  			blk_wake_io_task(waiter);
>> -		} else if (dio->flags & IOMAP_DIO_WRITE) {
>> +		} else if ((bio->bi_opf & REQ_POLLED) ||
>> +			   !(dio->flags & IOMAP_DIO_WRITE)) {
>> +			WRITE_ONCE(dio->iocb->private, NULL);
>> +			iomap_dio_complete_work(&dio->aio.work);
> 
> I'm not sure this is safe for all polled writes. What if the DIO
> write was into a hole and we have to run unwritten extent
> completion via:
> 
> iomap_dio_complete_work(work)
>   iomap_dio_complete(dio)
>     dio->end_io(iocb)
>       xfs_dio_write_end_io()
>         xfs_iomap_write_unwritten()
>           <runs transactions, takes rwsems, does IO>
>   .....
>   ki->ki_complete()
>     io_complete_rw_iopoll()
>   .....
> 
> I don't see anything in the iomap DIO path that prevents us from
> doing HIPRI/REQ_POLLED IO on IOMAP_UNWRITTEN extents, hence I think
> this change will result in bad things happening in general.

There is a check related to writing beyond the size of the inode:

        if (need_zeroout ||                                                     
            ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
                dio->iocb->ki_flags &= ~IOCB_HIPRI;

but whether that is enough of what, I'm not so sure.

>> +		} else {
>>  			struct inode *inode = file_inode(dio->iocb->ki_filp);
>>  
>>  			WRITE_ONCE(dio->iocb->private, NULL);
>>  			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
>>  			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
>> -		} else {
>> -			WRITE_ONCE(dio->iocb->private, NULL);
>> -			iomap_dio_complete_work(&dio->aio.work);
>>  		}
>>  	}
> 
> Regardless of the correctness of the code, I don't think adding this
> special case is the right thing to do here.  We should be able to
> complete all writes that don't require blocking completions directly
> here, not just polled writes.
> 
> We recently had this discussion over hacking a special case "don't
> queue for writes" for ext4 into this code - I had to point out the
> broken O_DSYNC completion cases it resulted in there, too. I also
> pointed out that we already had generic mechanisms in iomap to
> enable us to make a submission time decision as to whether
> completion needed to be queued or not. Thread here:
> 
> https://lore.kernel.org/linux-xfs/20230621174114.1320834-1-bongiojp@gmail.com/
> 
> Essentially, we shouldn't be using IOMAP_DIO_WRITE as the
> determining factor for queuing completions - we should be using
> the information the iocb and the iomap provides us at submission
> time similar to how we determine if we can use REQ_FUA for O_DSYNC
> writes to determine if iomap IO completion queuing is required.
> 
> This will do the correct *and* optimal thing for all types of
> writes, polled or not...

There's a fundamental difference between "cannot block, ever" as we have
from any kind of irq/rcu/preemption context, and the "we should not
block waiting for unrelated IO" which is really what the NOIO kind of
issue that async dio or polled async dio is. This obviously goes beyond
just this single patch and addresses the whole patchset, but it applies
equally to the polled completions here and the task punted callbacks for
the dio async writes. For the latter, we can certainly grab a mutex, for
the former we cannot, ever.

I do hear your point that gating this on writes is somewhat odd, but
that's mostly because the read completions don't really need to do
anything. Would you like it more if we made that explicit with another
IOMAP flag? Only concern here for the polled part is that REQ_POLLED may
be set for submission on the iomap side, but then later cleared through
the block stack if we cannot do polled IO for this bio. This means it
really has to be checked on the completion side, you cannot rely on any
iocb or iomap flags set at submission time.

For the write checking, that's already there... And while I'm all for
making that code cleaner, I don't necessarily think cleaning that up
first is a fair ask. At least not without more details on what you want,
specifically?

-- 
Jens Axboe

