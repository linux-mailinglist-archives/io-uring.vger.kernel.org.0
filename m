Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF02F3AE022
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 22:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFTUFs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 16:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhFTUFn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 16:05:43 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0A7C0617A8;
        Sun, 20 Jun 2021 13:03:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i94so17160492wri.4;
        Sun, 20 Jun 2021 13:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EwyKqaRxeYNXPvgmLrKeEBRMUOesPHXIwB6NPa1h74g=;
        b=RAh8YHJpq7+5MDP8I8+8R84RFoTyyqHvNKZqP9R/0KrGq0A/WrzJnCI6xfRFU8zaVF
         otGedyXQouwnLnSDwApDEpNIiM2hCMlRgSkBHwoHsybcocoTBm3LRJJbx1wbUSVnLnH4
         mPi3A84mRJs9VSDAAJqbYoFjLsjwYBzS5QRRrsOrzM2hRc/N6ioW4fW/NzKak1MOZaFl
         fD1PcqNo4TxnV2eu+w7Hyq5hfRfXVRFbbCulVLEBwPPOIRcaon+Nzkkg3nT6FnlyMpfu
         qxBaACANQCMq9HrUg2euBtEH5j9sH2pDVDEUcUJShbVfMWAE6hia9RNGETN8VwQPhdHs
         Ul5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EwyKqaRxeYNXPvgmLrKeEBRMUOesPHXIwB6NPa1h74g=;
        b=QP0jeNMaw5Oa2OcQxppcVqUoU4oZxpVm6Z/MS8rlYRtS3ZYm1ME4lE80Iqu3ngSzjQ
         5s2Wj6GDD+vUtWe17cMnQpVFFGNUx8onv4f0cqEA3D98hAvs+ddJD8jxTjJsgdJXkhYI
         8C0EMhclNmh2FPUEFLWqaxZVp6NFvoX0dDNMZ5mLiOUkhzFYSlaS1iXdXDRkRsUQdIQR
         5TxCjB801S0+KxMPleiWEv/YJ7/aLdty2cWB7g68bGc52oXyA86Cir3TWMw0t3bsUnQT
         N2YJKbQcQgYnVySpjQK4Pf6IiHhs62GrmZdpApFzk649dUp/i7N/NgKXWSjDBxa8R+Dc
         3q9Q==
X-Gm-Message-State: AOAM531uu3Jn81nKI4rlKxVmz8637om0Ebn3zxLDsYx+QLSAu8Dt1qR/
        vDXKKBfgaf6C+sjIN8BSU4DR/RWO1XGnUw==
X-Google-Smtp-Source: ABdhPJxP540JwfVMoXvPcT5pRfRDEmOWsCRp3dP62ia4CJHsRZzt1rEC87lwsfbZAXRi881Me3JnCA==
X-Received: by 2002:adf:f68a:: with SMTP id v10mr662812wrp.366.1624219406735;
        Sun, 20 Jun 2021 13:03:26 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.72])
        by smtp.gmail.com with ESMTPSA id y20sm2398997wmi.31.2021.06.20.13.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 13:03:26 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
 <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
Message-ID: <7ed2ecd3-6335-7c47-5915-054b811f92e5@gmail.com>
Date:   Sun, 20 Jun 2021 21:03:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 8:56 PM, Pavel Begunkov wrote:
> On 6/20/21 8:05 PM, Olivier Langlois wrote:
>> It is quite frequent that when an operation fails and returns EAGAIN,
>> the data becomes available between that failure and the call to
>> vfs_poll() done by io_arm_poll_handler().
>>
>> Detecting the situation and reissuing the operation is much faster
>> than going ahead and push the operation to the io-wq.
>>
>> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>> ---
>>  fs/io_uring.c | 26 +++++++++++++++++---------
>>  1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index fa8794c61af7..6e037304429a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5143,7 +5143,10 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>>  	return mask;
>>  }
>>  
>> -static bool io_arm_poll_handler(struct io_kiocb *req)
>> +#define IO_ARM_POLL_OK    0
>> +#define IO_ARM_POLL_ERR   1
>> +#define IO_ARM_POLL_READY 2
> 
> Please add a new line here. Can even be moved somewhere
> to the top, but it's a matter of taste.
> 
> Also, how about to rename it to apoll? io_uring internal
> rw/send/recv polling is often abbreviated as such around
> io_uring.c
> IO_APOLL_OK and so on.
> 
>> +static int io_arm_poll_handler(struct io_kiocb *req)
>>  {
>>  	const struct io_op_def *def = &io_op_defs[req->opcode];
>>  	struct io_ring_ctx *ctx = req->ctx;
>> @@ -5153,22 +5156,22 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>>  	int rw;
>>  
>>  	if (!req->file || !file_can_poll(req->file))
>> -		return false;
>> +		return IO_ARM_POLL_ERR;
> 
> It's not really an error. Maybe IO_APOLL_ABORTED or so?

fwiw, I mean totally replacing *_ERR, not only this return

> 
>>  	if (req->flags & REQ_F_POLLED)
>> -		return false;
>> +		return IO_ARM_POLL_ERR;
>>  	if (def->pollin)
>>  		rw = READ;
>>  	else if (def->pollout)
>>  		rw = WRITE;
>>  	else
>> -		return false;
>> +		return IO_ARM_POLL_ERR;
>>  	/* if we can't nonblock try, then no point in arming a poll handler */
>>  	if (!io_file_supports_async(req, rw))
>> -		return false;
>> +		return IO_ARM_POLL_ERR;
>>  
>>  	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
>>  	if (unlikely(!apoll))
>> -		return false;
>> +		return IO_ARM_POLL_ERR;
>>  	apoll->double_poll = NULL;
>>  
>>  	req->flags |= REQ_F_POLLED;
>> @@ -5194,12 +5197,12 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>>  	if (ret || ipt.error) {
>>  		io_poll_remove_double(req);
>>  		spin_unlock_irq(&ctx->completion_lock);
>> -		return false;
>> +		return ret?IO_ARM_POLL_READY:IO_ARM_POLL_ERR;
> 
> spaces would be great.
> 
>>  	}
>>  	spin_unlock_irq(&ctx->completion_lock);
>>  	trace_io_uring_poll_arm(ctx, req->opcode, req->user_data, mask,
>>  					apoll->poll.events);
>> -	return true;
>> +	return IO_ARM_POLL_OK;
>>  }
>>  
>>  static bool __io_poll_remove_one(struct io_kiocb *req,
>> @@ -6416,6 +6419,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
>>  	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
>>  	int ret;
>>  
>> +issue_sqe:
>>  	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>>  
>>  	/*
>> @@ -6435,12 +6439,16 @@ static void __io_queue_sqe(struct io_kiocb *req)
>>  			io_put_req(req);
>>  		}
>>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
>> -		if (!io_arm_poll_handler(req)) {
>> +		switch (io_arm_poll_handler(req)) {
>> +		case IO_ARM_POLL_READY:
>> +			goto issue_sqe;
> 
> Checked assembly, the fast path looks ok (i.e. not affected).
> Also, a note, linked_timeout is handled correctly.
> 
>> +		case IO_ARM_POLL_ERR:
>>  			/*
>>  			 * Queued up for async execution, worker will release
>>  			 * submit reference when the iocb is actually submitted.
>>  			 */
>>  			io_queue_async_work(req);
>> +			break;
>>  		}
>>  	} else {
>>  		io_req_complete_failed(req, ret);
>>
> 

-- 
Pavel Begunkov
