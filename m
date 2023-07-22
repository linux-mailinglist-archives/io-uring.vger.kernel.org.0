Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF57A75D953
	for <lists+io-uring@lfdr.de>; Sat, 22 Jul 2023 05:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjGVDLC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 23:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGVDLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 23:11:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D403A9C
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 20:11:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b7dfb95761so3724095ad.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 20:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689995459; x=1690600259;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nzD8h+GwyArXDhfpcQO8wd+7un729WJ8EWUmxFUSUHc=;
        b=wGBhM+v9x3tEZgy6I5GwbdRj9RqnkrEy6RiQ6w3f7SsKidZWNdURZZaFqhe2VgH3cG
         jPWk7g+NjyxhF0x2ZykLR3avTQ6nJmjE1xzEzuWw4auQXacS5hg24CuZKBSRohVZ8jcp
         0yp8hjZllWYfpa3EFkcwemIqzI1elrrPinsIfspccydwlgQKeczRNUqwdBHzvOXaN9OM
         8I99t9+tfdXZgByWmhERALyggUAPJQlkFk3ya6veEOPL8xISNpPTw4UImqcs0vpQ+r2N
         vuONPS+zzNucQCWX0HXKA8EGZOiNb3RUItwPhnJ1OqGQ9oKyt1nkNDtlOC3Yno6mTxY1
         PXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689995459; x=1690600259;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzD8h+GwyArXDhfpcQO8wd+7un729WJ8EWUmxFUSUHc=;
        b=T44R93RnIEhCEFEIIGL/9px1iRQlTONkxsfWsIFR/A5H/BwGaxqJm9gnA3rLULHtj4
         CfRAG/v4PNT9/lLHgu2XqZapTdyVbNPyeSsR/FC9GswoU7WOCiF9WMnsIxU8cvC527h2
         zb7Igr3dF4N2WjhRIGKBPdLwmNw1p0H+y7pGwr/NzGcd4xdjjt+dO8xPRrWj7P+c9jw9
         gSMOolF4kX+a7TvoPnq5Y9qWB48GsvZRGG8QWwyeBn/ohA9b8VwjWiBrf17jjyiq0ken
         4Zt+hWWRmOEcmT17a26OpO/brQJqIBIzjKflMcomxGTlr49AImTbTtRjQ/eUmQeVWXNr
         KSDA==
X-Gm-Message-State: ABy/qLacx93ReyLWTzrJF+nK4TJZiy8Jh3Gne9dJ/vexnsLBNX6gOPhm
        ktgmozPqN4jzSBmpuZ+CFSU7gQ==
X-Google-Smtp-Source: APBJJlGesHgFnHc3PjEGdimhOrUEdUNQhsriHW52enU1h7pYUW+XIBPMZr58lMjxTjpvR4ymb2iSmQ==
X-Received: by 2002:a17:902:dacf:b0:1b8:9215:9163 with SMTP id q15-20020a170902dacf00b001b892159163mr4638991plx.6.1689995459573;
        Fri, 21 Jul 2023 20:10:59 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902bd0400b001ab2b4105ddsm4238595pls.60.2023.07.21.20.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 20:10:58 -0700 (PDT)
Message-ID: <fe2754d6-04d0-ce69-d7b2-6e6af7cfb140@kernel.dk>
Date:   Fri, 21 Jul 2023 21:10:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/8] iomap: completed polled IO inline
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-5-axboe@kernel.dk>
 <ZLr8D60gYqDrHl21@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZLr8D60gYqDrHl21@dread.disaster.area>
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

On 7/21/23 3:43?PM, Dave Chinner wrote:
> On Thu, Jul 20, 2023 at 12:13:06PM -0600, Jens Axboe wrote:
>> Polled IO is only allowed for conditions where task completion is safe
>> anyway, so we can always complete it inline. This cannot easily be
>> checked with a submission side flag, as the block layer may clear the
>> polled flag and turn it into a regular IO instead. Hence we need to
>> check this at completion time. If REQ_POLLED is still set, then we know
>> that this IO was successfully polled, and is completing in task context.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/iomap/direct-io.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index 9f97d0d03724..c3ea1839628f 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -173,9 +173,19 @@ void iomap_dio_bio_end_io(struct bio *bio)
>>  	}
>>  
>>  	/*
>> -	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline
>> +	 * Flagged with IOMAP_DIO_INLINE_COMP, we can complete it inline.
>> +	 * Ditto for polled requests - if the flag is still at completion
>> +	 * time, then we know the request was actually polled and completion
>> +	 * is called from the task itself. This is why we need to check it
>> +	 * here rather than flag it at issue time.
>>  	 */
>> -	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>> +	if ((dio->flags & IOMAP_DIO_INLINE_COMP) || (bio->bi_opf & REQ_POLLED)) {
> 
> This still smells wrong to me. Let me see if I can work out why...
> 
> <spelunk!>
> 
> When we set up the IO in iomap_dio_bio_iter(), we do this:
> 
>         /*
>          * We can only poll for single bio I/Os.
>          */
>         if (need_zeroout ||
>             ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
>                 dio->iocb->ki_flags &= ~IOCB_HIPRI;
> 
> The "need_zeroout" covers writes into unwritten regions that require
> conversion at IO completion, and the latter check is for writes
> extending EOF. i.e. this covers the cases where we have dirty
> metadata for this specific write and so may need transactions or
> journal/metadata IO during IO completion.
> 
> The only case it doesn't cover is clearing IOCB_HIPRI for O_DSYNC IO
> that may require a call to generic_write_sync() in completion. That
> is, if we aren't using FUA, will not have IOMAP_DIO_INLINE_COMP set,
> but still do polled IO.
> 
> I think this is a bug. We don't want to be issuing more IO in
> REQ_POLLED task context during IO completion, and O_DSYNC IO
> completion for non-FUA IO requires a journal flush and that can
> issue lots of journal IO and wait on it in completion process.
> 
> Hence I think we should only be setting REQ_POLLED in the cases
> where IOCB_HIPRI and IOMAP_DIO_INLINE_COMP are both set.  If
> IOMAP_DIO_INLINE_COMP is set on the dio, then it doesn't matter what
> context we are in at completion time or whether REQ_POLLED was set
> or cleared during the IO....
> 
> That means the above check should be:
> 
>         /*
>          * We can only poll for single bio I/Os that can run inline
> 	 * completion.
>          */
>         if (need_zeroout ||
> 	    (iocb_is_dsync(dio->iocb) && !use_fua) ||
>             ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
>                 dio->iocb->ki_flags &= ~IOCB_HIPRI;

Looks like you are right, it would not be a great idea to handle that
off polled IO completion. It'd work just fine, but anything generating
more IO should go to a helper. I'll make that change.

> or if we change the logic such that calculate IOMAP_DIO_INLINE_COMP
> first:
> 
> 	if (!(dio->flags & IOMAP_DIO_INLINE_COMP))
> 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
> 
> Then we don't need to care about polled IO on the completion side at
> all at the iomap layer because it doesn't change the completion
> requirements at all...

That still isn't true, because you can still happily issue as polled IO
and get it cleared and now have an IRQ based completion. This would work
for most cases, but eg xfs dio end_io handler will grab:

spin_lock(&ip->i_flags_lock);

if the inode got truncated. Maybe that can't happen because we did
inode_dio_begin() higher up? Still seems saner to check for the polled
flag at completion to me...

-- 
Jens Axboe

