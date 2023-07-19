Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAE875999B
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 17:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjGSPYP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjGSPYF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 11:24:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7587619A3
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 08:24:00 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7748ca56133so47331539f.0
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 08:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689780239; x=1692372239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rsmw396UyGg9KI2OxjnWSL3C8+sAXu99zZ/mRUVEeQI=;
        b=a0Ny9jepRR1yW8Tr5V5FOcP29BSI3qvArsOR6oIL2V+QMaveMAHLbCeL4IXC6HiCN4
         aa3OKByHI/nGfqwHNTo46s7Tk25p75q2eCf08rRnrDmhjczTruiv/RSQ3FE5FoKEDq/p
         xgeV9Lzcj2KRnTRuUx9Luj+Cak/uxJMFwxfxtcN8XlGKbkjvfLzM8Rnc0CjDt67mD1Vc
         ua8efj2E6X4PjzUMsZBlnrpfRp0cI4lfD7jSEW+jCzq6LJ2y7IbzU9DqF5DekJ32+9oO
         xRGnKt5tINEIrUpEYY+NE+4DksgrcMWB/QbCvXdwEip3FpFUT1gqRCLVA6G9S8xrhJ5G
         LQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689780239; x=1692372239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rsmw396UyGg9KI2OxjnWSL3C8+sAXu99zZ/mRUVEeQI=;
        b=ALEZzlBpUe+QF3X07UGcXyI3npaMM9FAPP9cakVKgMZD3BcPbnLFR0+nGEyNDqRx/D
         zD3UlM3edOkCQxRPmbQPLm6gE80e7mUj4jwOvXS830J+9lB+wSCd8VRBh6d/WMtd14k0
         4kBojKV4i2G+YojLimfWAep2s2zyO+NsKMtCl8uuhF5wY9bpm4gL/A9SGolwjdGmzxYN
         9Rts5u+1LM4xmNXlPjK8uB8Zai6vVOe8nLiPbuEL4TyKuHb7kARkhUUcLmXyTDRD4gx/
         5/TATDj0UYJVgHJTBoIRxhzylLBnCgvJbLPse/Tx0+LIF48g8BWyt1oHSpedjuTIy11f
         N0iw==
X-Gm-Message-State: ABy/qLb01tU4JuV6Djt0bH4NRJY4ESPP2NSiua2LICNwnOejqrM8OPzL
        qI18aCPAflZgvjphtakWedzlXWv7RlZZhs2Yf4s=
X-Google-Smtp-Source: APBJJlEtKxmCvgVMkfiujpUOZGAmVwNVd0aqz/4C7hzBnfmq7TSo5+cK/lWh2iEZiMIR+OcRzMKrpQ==
X-Received: by 2002:a6b:c992:0:b0:77a:ee79:652 with SMTP id z140-20020a6bc992000000b0077aee790652mr4425333iof.1.1689780239460;
        Wed, 19 Jul 2023 08:23:59 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k9-20020a5e8909000000b00786ea00bdb5sm1422931ioj.2.2023.07.19.08.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 08:23:58 -0700 (PDT)
Message-ID: <11151547-1bea-7c92-31b6-2d4250ada604@kernel.dk>
Date:   Wed, 19 Jul 2023 09:23:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/5] iomap: simplify logic for when a dio can get
 completed inline
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
References: <20230718194920.1472184-1-axboe@kernel.dk>
 <20230718194920.1472184-3-axboe@kernel.dk>
 <ZLcYjW6vJhEXy7hU@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZLcYjW6vJhEXy7hU@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/23 4:56?PM, Dave Chinner wrote:
> On Tue, Jul 18, 2023 at 01:49:16PM -0600, Jens Axboe wrote:
>> Currently iomap gates this on !IOMAP_DIO_WRITE, but this isn't entirely
>> accurate. Some writes can complete just fine inline. One such example is
>> polled IO, where the completion always happens in task context.
>>
>> Add IOMAP_DIO_INLINE_COMP which tells the completion side if we can
>> complete this dio inline, or if it needs punting to a workqueue. We set
>> this flag by default for any dio, and turn it off for unwritten extents
>> or blocks that require a sync at completion time.
> 
> Ignoring the O_DSYNC case (I'll get to that at the end), this is
> still wrong - it misses extending writes that need to change file
> size at IO completion. For some filesystems, file extension at IO
> completion has the same constraints as unwritten extent conversion
> (i.e. requires locking and transactions), but the iomap
> infrastructure has no idea whether the filesystem performing the IO
> requires this or not.
> 
> i.e. if iomap always punts unwritten extent IO to a workqueue, we
> also have to punt extending writes to a workqueue.  Fundamentally,
> the iomap code itself cannot make a correct determination of whether
> IO completion of any specific write IO requires completion in task
> context.
> 
> Only the filesystem knows that,
> 
> However, the filesystem knows if the IO is going to need IO
> completion processing at submission time. It tells iomap that it
> needs completion processing via the IOMAP_F_DIRTY flag. This allows
> filesystems to determine what IOs iomap can consider as "writes that
> don't need filesystem completion processing".
> 
> With this flag, iomap can optimise the IO appropriately. We can use
> REQ_FUA for O_DSYNC writes if IOMAP_F_DIRTY is not set. We can do
> inline completion if IOMAP_F_DIRTY is not set. But if IOMAP_F_DIRTY
> is set, the filesystem needs to run it's own completion processing,
> and so iomap cannot run that write with an inline completion.

Gotcha, so we need to gate INLINE_COMP on !IOMAP_F_DIRTY as well. I'll
make that change.

>> Gate the inline completion on whether we're in a task or not as well.
>> This will always be true for polled IO, but for IRQ driven IO, the
>> completion context may not allow for inline completions.
> 
> Again, context does not matter for pure overwrites - we can complete
> them inline regardless of completion context. The task context only
> matters when the filesystem needs to do completion work, and we've
> already established that we are not doing inline completion
> for polled IO for unwritten, O_DSYNC or extending file writes.

Right, looks like I was just missing that bit as well, I assumed that
the previous case would co er it.

> IOWs, we already avoid polled completions for all the situations
> where IOMAP_F_DIRTY is set by the filesystem to indicate the
> operation is not a pure overwrite....

Yep

>>  fs/iomap/direct-io.c | 14 +++++++++-----
>>  1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index ea3b868c8355..6fa77094cf0a 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -20,6 +20,7 @@
>>   * Private flags for iomap_dio, must not overlap with the public ones in
>>   * iomap.h:
>>   */
>> +#define IOMAP_DIO_INLINE_COMP	(1 << 27)
>>  #define IOMAP_DIO_WRITE_FUA	(1 << 28)
>>  #define IOMAP_DIO_NEED_SYNC	(1 << 29)
>>  #define IOMAP_DIO_WRITE		(1 << 30)
>> @@ -161,15 +162,15 @@ void iomap_dio_bio_end_io(struct bio *bio)
>>  			struct task_struct *waiter = dio->submit.waiter;
>>  			WRITE_ONCE(dio->submit.waiter, NULL);
>>  			blk_wake_io_task(waiter);
>> -		} else if (dio->flags & IOMAP_DIO_WRITE) {
>> +		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) && in_task()) {
> 
> Regardless of whether the code is correct or not, this needs a
> comment explaining what problem the in_task() check is working
> around...

It's meant to catch cases where we're doing polled IO, but it got
cleared/disabled in the block layer. We cannot catch this at submission
time, it has to be checked at completion time. There are a few ways we
could check for that, one would be in_task(), another would be to check
the bio REQ_POLLED flag like v1 did. I don't have a strong preference
here, though it did seem like a saner check to use in_task() as generic
catch-all for if we're doing this from soft/hard irq processing or not,
unexpectedly.


>> +			WRITE_ONCE(dio->iocb->private, NULL);
>> +			iomap_dio_complete_work(&dio->aio.work);
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
>>  
>> @@ -244,6 +245,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  
>>  	if (iomap->type == IOMAP_UNWRITTEN) {
>>  		dio->flags |= IOMAP_DIO_UNWRITTEN;
>> +		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
>>  		need_zeroout = true;
>>  	}
>>  
>> @@ -500,7 +502,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>  	dio->i_size = i_size_read(inode);
>>  	dio->dops = dops;
>>  	dio->error = 0;
>> -	dio->flags = 0;
>> +	/* default to inline completion, turned off when not supported */
>> +	dio->flags = IOMAP_DIO_INLINE_COMP;
>>  	dio->done_before = done_before;
> 
> I think this is poorly coded. If we get the clearing logic
> wrong (as is the case in this patch) then bad things will
> happen when we run inline completion in an irq context when
> the filesystem needs to run a transaction. e.g. file extension.

Agree, it seems a bit fragile. The alternative is doing it the other way
around, enabling it for cases that we know it'll work for instead. I'll
take a stab at that approach along with the other changes.

> It looks to me like you hacked around this "default is wrong" case
> with the "in_task()" check in completion, but given that check is
> completely undocumented....

It's not a hacky work-around, it's a known case that could go wrong.
> 
>>  	dio->submit.iter = iter;
>> @@ -535,6 +538,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>  		/* for data sync or sync, we need sync completion processing */
>>  		if (iocb_is_dsync(iocb)) {
>>  			dio->flags |= IOMAP_DIO_NEED_SYNC;
>> +			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> 
> This is looks wrong, too. We set IOMAP_DIO_WRITE_FUA ca couple of
> lines later, and during bio submission we check if REQ_FUA can be
> used if IOMAP_F_DIRTY is not set. If all the bios we submit use
> REQ_FUA, then we clear IOMAP_DIO_NEED_SYNC before we drop the dio
> submission reference.
> 
> For such a REQ_FUA bio chains, we can now safely do inline
> completion because we don't run generic_write_sync() in IO
> completion now. The filesystem does not need to perform blocking or
> IO operations in completion, either, so these IOs can be completed
> in line like any other pure overwrite DIO....

True, non-extending FUA writes would be fine as well.

Thanks for the review!

-- 
Jens Axboe

