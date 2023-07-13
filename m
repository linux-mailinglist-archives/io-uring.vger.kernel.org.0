Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5EF75283B
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 18:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjGMQZX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 12:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjGMQZX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 12:25:23 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825E0E65
        for <io-uring@vger.kernel.org>; Thu, 13 Jul 2023 09:25:21 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so9247039f.0
        for <io-uring@vger.kernel.org>; Thu, 13 Jul 2023 09:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689265521; x=1689870321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s0dG2H2xZvUK9eAr8EXN8mj7U0nJs7wY+tkeLzgPXkM=;
        b=32VlmzFpdfx3czU0/sS6H2Q1IepA9YnCExGVhgPRRTcN8Z1Ojq61LmUdzH21+xdDy8
         TbBwAZALZwc80QoTq5biUM6oqTH3jyFGld7ZADkH8e17QGbK0ZmXK5e7CXA4CngQTXeh
         oswHbDHgYJqJkP1SNsQe7GScBtnzl73YxrlFTyi902tOauPrD4ocnPDO4x3qHNtuiLyg
         fPqZjbYdr/6ra8YFHdHMtRmEuaKrd59Fkr+UzYgAnd8KQ/EBjdtaSLJYNYrT6/gETEzD
         coGcWioKyiemnq5Bd9RsCcScAesgPg6vJuAPDSmbvmi98zzROpxvoh+GEsSzfcZANTxf
         FY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689265521; x=1689870321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0dG2H2xZvUK9eAr8EXN8mj7U0nJs7wY+tkeLzgPXkM=;
        b=R+ZS5r/rjCoGFwBlG9vlBtU7QZyNgiNe6gUc7Fveh1pUqbM6EmQTOpU3gX4UvuI6cQ
         z8jbCZNA552pWJOEfY3O6B1cHUkBsOMy6ZEeXhd9hhAYK2y8b8wl+Ec8PRDVzJjSAc23
         qVWK0i25zkekpNHDHl64UnefMKDHk/Rp+Nq7cqglPpNCxhHZQJIhBBCLWRib83VrXXm+
         FIEhM+6Pnza2AcMo7Oq1QQaOWGO2ubo4a4IuyRnJ6UyGH15hvL53GRc0F4RO3f/h5uw+
         Hoa1Xo1SomZVy1i6oSnaGUGFNN+bM3Bu5hnOr5AEj0GUa317L5Srz2VeoVsOLBMO/W55
         ApDg==
X-Gm-Message-State: ABy/qLalY5nzIH6vv14r4JygXqUV4XO3/7/gl93kmHptKVmJ+h450iZW
        lX08wQF7P4MYlLBaYNa+a9/bux4WUkS+FpzOR4E=
X-Google-Smtp-Source: APBJJlHk/JPQdHlGkunnVUkE9IBFVBOBw5KMbzJVTmNlbHGry09SLOSB7Cu7a5Q4MOLgWr/9kQqbfw==
X-Received: by 2002:a05:6602:3ce:b0:780:c6bb:ad8d with SMTP id g14-20020a05660203ce00b00780c6bbad8dmr2464784iov.0.1689265520844;
        Thu, 13 Jul 2023 09:25:20 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j20-20020a02a694000000b0042b2d9fbbecsm1894706jam.119.2023.07.13.09.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 09:25:20 -0700 (PDT)
Message-ID: <517d0c94-5f08-6f9f-2119-6374a7d7c4b8@kernel.dk>
Date:   Thu, 13 Jul 2023 10:25:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, andres@anarazel.de
References: <20230712162017.391843-1-axboe@kernel.dk>
 <20230712162017.391843-5-axboe@kernel.dk>
 <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
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

On 7/13/23 5:15?AM, Peter Zijlstra wrote:
> On Wed, Jul 12, 2023 at 10:20:13AM -0600, Jens Axboe wrote:
> 
>> +int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>> +
>> +	if (unlikely(sqe->addr2 || sqe->buf_index || sqe->addr3))
>> +		return -EINVAL;
>> +
>> +	iof->futex_op = READ_ONCE(sqe->fd);
>> +	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +	iof->futex_val = READ_ONCE(sqe->len);
>> +	iof->futex_mask = READ_ONCE(sqe->file_index);
>> +	iof->futex_flags = READ_ONCE(sqe->futex_flags);
>> +	if (iof->futex_flags & FUTEX_CMD_MASK)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
> 
> I'm a little confused on the purpose of iof->futex_op, it doesn't appear
> to be used. Instead iof->futex_flags is used as the ~FUTEX_CMD_MASK part
> of ops.
> 
> The latter actually makes sense since you encode the actual op in the
> IOURING_OP_ space.

Yep, I think this is also a leftover from when I had it multiplexed a
bit more. The liburing side got fixed for that, but neglected this bit.
Good catch. I'll fold the below in.

> 
>> +int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct io_futex_data *ifd = NULL;
>> +	struct futex_hash_bucket *hb;
>> +	unsigned int flags;
>> +	int ret;
>> +
>> +	if (!iof->futex_mask) {
>> +		ret = -EINVAL;
>> +		goto done;
>> +	}
>> +	if (!futex_op_to_flags(FUTEX_WAIT, iof->futex_flags, &flags)) {
> 
> A little confusing since you then implement FUTEX_WAIT_BITSET, but using
> FUTEX_WAIT ensures this goes -ENOSYS when setting FUTEX_CLOCK_REALTIME,
> since you handle timeouts through the iouring thing.
> 
> Perhaps a comment?

OK, will add a comment on that.

>> +		ret = -ENOSYS;
>> +		goto done;
>> +	}
>> +
>> +	io_ring_submit_lock(ctx, issue_flags);
>> +	ifd = io_alloc_ifd(ctx);
>> +	if (!ifd) {
>> +		ret = -ENOMEM;
>> +		goto done_unlock;
>> +	}
>> +
>> +	req->async_data = ifd;
>> +	ifd->q = futex_q_init;
>> +	ifd->q.bitset = iof->futex_mask;
>> +	ifd->q.wake = io_futex_wake_fn;
>> +	ifd->req = req;
>> +
>> +	ret = futex_wait_setup(iof->uaddr, iof->futex_val, flags, &ifd->q, &hb);
>> +	if (!ret) {
>> +		hlist_add_head(&req->hash_node, &ctx->futex_list);
>> +		io_ring_submit_unlock(ctx, issue_flags);
>> +
>> +		futex_queue(&ifd->q, hb);
>> +		return IOU_ISSUE_SKIP_COMPLETE;
>> +	}
>> +
>> +done_unlock:
>> +	io_ring_submit_unlock(ctx, issue_flags);
>> +done:
>> +	if (ret < 0)
>> +		req_set_fail(req);
>> +	io_req_set_res(req, ret, 0);
>> +	kfree(ifd);
>> +	return IOU_OK;
>> +}
> 
> Other than that, I think these things are indeed transparant wrt the
> existing futex interface. If we add a flag this shouldn't care.

Not sure I follow, what kind of flag do you want/need?


diff --git a/io_uring/futex.c b/io_uring/futex.c
index df65b8f3593f..bced11c87896 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -18,7 +18,6 @@ struct io_futex {
 		u32 __user			*uaddr;
 		struct futex_waitv __user	*uwaitv;
 	};
-	int		futex_op;
 	unsigned int	futex_val;
 	unsigned int	futex_flags;
 	unsigned int	futex_mask;
@@ -173,10 +172,9 @@ int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 
-	if (unlikely(sqe->buf_index || sqe->addr3))
+	if (unlikely(sqe->fd || sqe->buf_index || sqe->addr3))
 		return -EINVAL;
 
-	iof->futex_op = READ_ONCE(sqe->fd);
 	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	iof->futex_val = READ_ONCE(sqe->len);
 	iof->futex_mask = READ_ONCE(sqe->file_index);

-- 
Jens Axboe

