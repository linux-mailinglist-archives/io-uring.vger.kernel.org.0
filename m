Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D553B0F07
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 22:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFVUzJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 16:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFVUzI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 16:55:08 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE64C061574;
        Tue, 22 Jun 2021 13:52:52 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a11so124534wrt.13;
        Tue, 22 Jun 2021 13:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yO+UtMV4S0iaGuCkmp1qmwqtSoq6ABWJClMRuQMocdY=;
        b=GtL2h2yDpdNEnZUCLwVb/CSlr9f4wkoFGiuRuZ4iu7qnSA5sl8Pomnn8OurR0hEnX6
         o5MYWkg+mMFsGCTh7eYC7L0VEUIBYSo4vBKJe+Kp9Iyd50K08Yp8ALYO9+/YvfWGDRqZ
         c0/TIFwMqHNvGiFeDanOkV6DU23G+am3w7Dbx7bn/o50OX23Gto3k8KakUxJ7I9ocBbZ
         IZlvTGOMCSvMk28VLn9gQ7i2QC8nK/eYCl9uFeLGg8sY3iiYA8dKV1+KUvzmQxYQLJ+r
         a/gBARgtXda124LKHp5buQESCuaXhyCM7D627CrcuEI6mj/A3q8XdMm2mo8Dt5bItW2S
         jHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yO+UtMV4S0iaGuCkmp1qmwqtSoq6ABWJClMRuQMocdY=;
        b=PygErogtTot1xVyoQsKM3QPfsFxJALzOP3vQobdyM4jgFl2qOLWmqseiPPF0km08yD
         jmEheCjQDNPRIeHTVTDqoP4PXZM28kxUtyPMnJ2PDg/NX5T0ebqW0sqb+QdQTAteluqA
         DjPnQsnaymeB4kX3JE86pvSKviK0OLUNaM0NTnzIQzTNCbD/iw46O4XndS7RnkTA38Vk
         KMCtJA2oN+TRSdboeo0GyJfwAI/HHJ7wGh/H/UrfoNGst3AcpznnEk4tsAv11Gota3ws
         natTq5dWIUy/EF/msnyf+J8PRc/1XKragnfSF5wM0ZZ0VH1MmQc4TYub1GlG50tpmiGS
         n1BQ==
X-Gm-Message-State: AOAM53262FIyqFqgUPKBrCJwr8KWPsJWHRIyHFOtYOBxpeksP6DvJzYj
        4Lx8p+3p97Ve9FQaGaAQ4N4Ms6QuIYuhADCN
X-Google-Smtp-Source: ABdhPJwcNx+UGi+gwo8RIrt3hNZRWK+mj8rOCKoZmSSrrRkUTcAPP2UZXDwNtS1Nq0GOI5qBrmZ5FQ==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr7244976wrv.343.1624395170925;
        Tue, 22 Jun 2021 13:52:50 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id o203sm3803624wmo.36.2021.06.22.13.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 13:52:50 -0700 (PDT)
Subject: Re: [PATCH v4] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e733144b-6bb1-af05-ce7e-7e142b4d7b35@gmail.com>
Date:   Tue, 22 Jun 2021 21:52:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 1:17 PM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().

Looks good

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.
> 
> Performance improvement testing has been performed with:
> Single thread, 1 TCP connection receiving a 5 Mbps stream, no sqpoll.
> 
> 4 measurements have been taken:
> 1. The time it takes to process a read request when data is already available
> 2. The time it takes to process by calling twice io_issue_sqe() after vfs_poll() indicated that data was available
> 3. The time it takes to execute io_queue_async_work()
> 4. The time it takes to complete a read request asynchronously
> 
> 2.25% of all the read operations did use the new path.
> 
> ready data (baseline)
> avg	3657.94182918628
> min	580
> max	20098
> stddev	1213.15975908162
> 
> reissue	completion
> average	7882.67567567568
> min	2316
> max	28811
> stddev	1982.79172973284
> 
> insert io-wq time
> average	8983.82276995305
> min	3324
> max	87816
> stddev	2551.60056552038
> 
> async time completion
> average	24670.4758861127
> min	10758
> max	102612
> stddev	3483.92416873804
> 
> Conclusion:
> On average reissuing the sqe with the patch code is 1.1uSec faster and
> in the worse case scenario 59uSec faster than placing the request on
> io-wq
> 
> On average completion time by reissuing the sqe with the patch code is
> 16.79uSec faster and in the worse case scenario 73.8uSec faster than
> async completion.
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fc8637f591a6..5efa67c2f974 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5152,7 +5152,13 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>  	return mask;
>  }
>  
> -static bool io_arm_poll_handler(struct io_kiocb *req)
> +enum {
> +	IO_APOLL_OK,
> +	IO_APOLL_ABORTED,
> +	IO_APOLL_READY
> +};
> +
> +static int io_arm_poll_handler(struct io_kiocb *req)
>  {
>  	const struct io_op_def *def = &io_op_defs[req->opcode];
>  	struct io_ring_ctx *ctx = req->ctx;
> @@ -5162,22 +5168,22 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  	int rw;
>  
>  	if (!req->file || !file_can_poll(req->file))
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	if (req->flags & REQ_F_POLLED)
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	if (def->pollin)
>  		rw = READ;
>  	else if (def->pollout)
>  		rw = WRITE;
>  	else
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	/* if we can't nonblock try, then no point in arming a poll handler */
>  	if (!io_file_supports_async(req, rw))
> -		return false;
> +		return IO_APOLL_ABORTED;
>  
>  	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
>  	if (unlikely(!apoll))
> -		return false;
> +		return IO_APOLL_ABORTED;
>  	apoll->double_poll = NULL;
>  
>  	req->flags |= REQ_F_POLLED;
> @@ -5203,12 +5209,14 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  	if (ret || ipt.error) {
>  		io_poll_remove_double(req);
>  		spin_unlock_irq(&ctx->completion_lock);
> -		return false;
> +		if (ret)
> +			return IO_APOLL_READY;
> +		return IO_APOLL_ABORTED;
>  	}
>  	spin_unlock_irq(&ctx->completion_lock);
>  	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
>  				mask, apoll->poll.events);
> -	return true;
> +	return IO_APOLL_OK;
>  }
>  
>  static bool __io_poll_remove_one(struct io_kiocb *req,
> @@ -6437,6 +6445,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
>  	int ret;
>  
> +issue_sqe:
>  	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>  
>  	/*
> @@ -6456,12 +6465,16 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  			io_put_req(req);
>  		}
>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
> -		if (!io_arm_poll_handler(req)) {
> +		switch (io_arm_poll_handler(req)) {
> +		case IO_APOLL_READY:
> +			goto issue_sqe;
> +		case IO_APOLL_ABORTED:
>  			/*
>  			 * Queued up for async execution, worker will release
>  			 * submit reference when the iocb is actually submitted.
>  			 */
>  			io_queue_async_work(req);
> +			break;
>  		}
>  	} else {
>  		io_req_complete_failed(req, ret);
> 

-- 
Pavel Begunkov
