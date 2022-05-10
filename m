Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568A6520C0F
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 05:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiEJDeE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 23:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiEJDdx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 23:33:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076BE6D97B
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 20:29:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i17so15621099pla.10
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 20:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fxdtTp3M8aUfDAUSZiH+3vfMAMB7VhyCU2mEh+hK6Ew=;
        b=4sHLng4o/86uE+nfqNXIXDE5L+7p2bPFktoPF881vrndtItm5dFj+t2Gz8/SgvvKLe
         G2TZRt64QCDdts+BM5JOfQ8f8vffhbevbejdIrjh44I2tvoR/YKynPJi06vlBgrp4n1r
         /5LxwwBq+U9Nk46R34kbzREGjxz708XH4DawA/1voll+RpxbotzdfGj1w5TzGaaG0qPR
         KUQjYUZjfoJ3j4Q8/lfgcWLAO7QklBVO2c/ZmQDmduvgvgQUBdxgFJvnpqnoXMCZnUVZ
         xN62e9k5vuHu9gwbzE2/ETiRosRWXrfa6ZjvomGW8LXXVONocBKtNmY3lGj5GatkR1ee
         FAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fxdtTp3M8aUfDAUSZiH+3vfMAMB7VhyCU2mEh+hK6Ew=;
        b=lA1p2j3hWiRMdIo28Um30MBt5k4rDm7+VtdSwqnH9e9bgGjrP7AeEnrkyXLzyoV8ev
         a35nIVpqcNPNTI3THR1TRlsI2BmDgn8NhFxXrpcH8yu2JZZBZKI4VBn++Us61eMibH/s
         YqrNxSs+YBcn83cm9Uy0W0JLzwe9qB2mmWMAzxu/TsN0LPxuwCXppljJuLe6ESJLxGj0
         FyDWzbj9+ZINbDwHE49pnrKQWwEfjMoxklxjLILJWbaCDwzxnT2Cvjne3KZhHo51cSMZ
         UXa1b7YWqEoginNFMf2ZGDejR4V5odVYNQKrubc4qX8zfh6Eo756dJyb4QacAW4yWqsi
         2uJw==
X-Gm-Message-State: AOAM532bTcZgUg5iKz3AxrXHucrd9vQczbrQYCtpk/ZNH1aGfXyQSMzf
        cWbChY29AowTZHixwzr6vPsix9gKoxszZMnF
X-Google-Smtp-Source: ABdhPJwV4PmwcQY4MScIOkWZ3RK8xFz4p9aXLt1+NZARu9n25aZZ1Nik595PT53Cm1fFtUitXi/xOg==
X-Received: by 2002:a17:902:74c5:b0:15f:1388:53eb with SMTP id f5-20020a17090274c500b0015f138853ebmr7521990plt.39.1652153388271;
        Mon, 09 May 2022 20:29:48 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g7-20020a17090a578700b001d25dfb9d39sm535687pji.14.2022.05.09.20.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 20:29:47 -0700 (PDT)
Message-ID: <5ac7c54a-e82b-9d28-9761-446a644e181c@kernel.dk>
Date:   Mon, 9 May 2022 21:29:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220509092312.254354-1-ming.lei@redhat.com>
 <9c833e12-fd09-fe7d-d4f2-e916c6ce4524@kernel.dk> <YnnUuZve2b2LmInc@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YnnUuZve2b2LmInc@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 8:58 PM, Ming Lei wrote:
> On Mon, May 09, 2022 at 10:09:10AM -0600, Jens Axboe wrote:
>> On 5/9/22 3:23 AM, Ming Lei wrote:
>>> This is the driver part of userspace block driver(ubd driver), the other
>>> part is userspace daemon part(ubdsrv)[1].
>>>
>>> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
>>> shared cmd buffer for storing io command, and the buffer is read only for
>>> ubdsrv, each io command is indexed by io request tag directly, and
>>> is written by ubd driver.
>>>
>>> For example, when one READ io request is submitted to ubd block driver, ubd
>>> driver stores the io command into cmd buffer first, then completes one
>>> IORING_OP_URING_CMD for notifying ubdsrv, and the URING_CMD is issued to
>>> ubd driver beforehand by ubdsrv for getting notification of any new io request,
>>> and each URING_CMD is associated with one io request by tag.
>>>
>>> After ubdsrv gets the io command, it translates and handles the ubd io
>>> request, such as, for the ubd-loop target, ubdsrv translates the request
>>> into same request on another file or disk, like the kernel loop block
>>> driver. In ubdsrv's implementation, the io is still handled by io_uring,
>>> and share same ring with IORING_OP_URING_CMD command. When the target io
>>> request is done, the same IORING_OP_URING_CMD is issued to ubd driver for
>>> both committing io request result and getting future notification of new
>>> io request.
>>>
>>> Another thing done by ubd driver is to copy data between kernel io
>>> request and ubdsrv's io buffer:
>>>
>>> 1) before ubsrv handles WRITE request, copy the request's data into
>>> ubdsrv's userspace io buffer, so that ubdsrv can handle the write
>>> request
>>>
>>> 2) after ubsrv handles READ request, copy ubdsrv's userspace io buffer
>>> into this READ request, then ubd driver can complete the READ request
>>>
>>> Zero copy may be switched if mm is ready to support it.
>>>
>>> ubd driver doesn't handle any logic of the specific user space driver,
>>> so it should be small/simple enough.
>>
>> This is pretty interesting! Just one small thing I noticed, since you
>> want to make sure batching is Good Enough:
>>
>>> +static blk_status_t ubd_queue_rq(struct blk_mq_hw_ctx *hctx,
>>> +		const struct blk_mq_queue_data *bd)
>>> +{
>>> +	struct ubd_queue *ubq = hctx->driver_data;
>>> +	struct request *rq = bd->rq;
>>> +	struct ubd_io *io = &ubq->ios[rq->tag];
>>> +	struct ubd_rq_data *data = blk_mq_rq_to_pdu(rq);
>>> +	blk_status_t res;
>>> +
>>> +	if (ubq->aborted)
>>> +		return BLK_STS_IOERR;
>>> +
>>> +	/* this io cmd slot isn't active, so have to fail this io */
>>> +	if (WARN_ON_ONCE(!(io->flags & UBD_IO_FLAG_ACTIVE)))
>>> +		return BLK_STS_IOERR;
>>> +
>>> +	/* fill iod to slot in io cmd buffer */
>>> +	res = ubd_setup_iod(ubq, rq);
>>> +	if (res != BLK_STS_OK)
>>> +		return BLK_STS_IOERR;
>>> +
>>> +	blk_mq_start_request(bd->rq);
>>> +
>>> +	/* mark this cmd owned by ubdsrv */
>>> +	io->flags |= UBD_IO_FLAG_OWNED_BY_SRV;
>>> +
>>> +	/*
>>> +	 * clear ACTIVE since we are done with this sqe/cmd slot
>>> +	 *
>>> +	 * We can only accept io cmd in case of being not active.
>>> +	 */
>>> +	io->flags &= ~UBD_IO_FLAG_ACTIVE;
>>> +
>>> +	/*
>>> +	 * run data copy in task work context for WRITE, and complete io_uring
>>> +	 * cmd there too.
>>> +	 *
>>> +	 * This way should improve batching, meantime pinning pages in current
>>> +	 * context is pretty fast.
>>> +	 */
>>> +	task_work_add(ubq->ubq_daemon, &data->work, TWA_SIGNAL);
>>> +
>>> +	return BLK_STS_OK;
>>> +}
>>
>> It'd be better to use bd->last to indicate what kind of signaling you
>> need here. TWA_SIGNAL will force an immediate transition if the app is
>> running in userspace, which may not be what you want. Also see:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=e788be95a57a9bebe446878ce9bf2750f6fe4974
>>
>> But regardless of signaling needed, you don't need it except if bd->last
>> is true. Would need a commit_rqs() as well, but that's trivial.
> 
> Good point, I think we may add non-last request via task_work_add(TWA_NONE),
> and only notify via TWA_SIGNAL_NO_IPI for bd->last.

Yep, I think that'd be the way to go.

>> More importantly, what prevents ubq->ubq_daemon from going away after
>> it's been assigned? I didn't look at the details, but is this relying on
>> io_uring being closed to cancel pending requests? That should work, but
> 
> I think no way can prevent ubq->ubq_daemon from being killed by 'kill -9',
> even though ubdsrv has handled SIGTERM. That is why I suggest to add
> one service for removing all ubd devices before shutdown:
> 
> https://github.com/ming1/ubdsrv/blob/devel/README

Right, you can't prevent a task from getting killed. But what you do
know is that file descriptors get closed when the task goes away, and if
you're integrated into io_uring in terms of how request are handled,
then the closing of the io_ring ring descriptor should wait-for/cancel
pending requests. If done right, that could perhaps exclude the issue of
having the stored task become invalid.

I haven't looked too closely at it all yet, so the above may not be a
viable approach. Or maybe it will... It's how io_uring itself does it.

> All the commands of UBD_IO_FETCH_REQ or UBD_IO_COMMIT_AND_FETCH_REQ have
> been submitted to driver, I understand io_uring can't cancel them,
> please correct me if it is wrong.

Right, any storage IO can't get canceled if it's already hit the block
layer or further down. So you end up waiting for them, which is fine
too.

> One solution I thought of is to use one watchdog to check if ubq->ubq_daemon
> is dead, then abort whole device if yes. Or any suggestion?

You'd still need to ensure that it remains valid.

>> we need some way to ensure that ->ubq_daemon is always valid here.
> 
> Good catch.
> 
> get_task_struct() should be used for assigning ubq->ubq_daemon.

Yep, that could work too as long as it doesn't introduce a weird loopy
dependency. Since it's just the task_struct itself, I think it'd be fine
and the simplest solution. This is a setup thing, and not per-io?

-- 
Jens Axboe

