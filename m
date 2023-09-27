Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6545A7AFF6B
	for <lists+io-uring@lfdr.de>; Wed, 27 Sep 2023 11:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjI0JFI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Sep 2023 05:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjI0JFH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Sep 2023 05:05:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5CD97;
        Wed, 27 Sep 2023 02:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JZwlwyqIhAavKAeesviQI5m0Pljvol49GznkZA5S3GE=; b=kNjSv4QIELlngKXZOG9fSnslQL
        ojpkSA1yW9aHT067t22AqdH1KTyVY85/7ezR9UZU1hDgGbeprGboVA3Rlf2EZ4p1Xi8zZH7jy0BWN
        V17MX9IR8/9s4XlOR/cX/x8sZvI3+fj3mSJF95gqQG2DT7pYjHa4jgQhdMZl/HywaUge/cy20Gwc0
        hqkew1E2t2cuS0q+60iUI8F9yQLj8HfCa3p6BPriSP3U4UZolR1x03JURS4we+ZIZxlnzkdQJZm++
        EKB2OIY+NcCKquMVk5Crfnho5ps9mrYbPlI2CwT4wKxgSvBoXqyq6SQeVrj5qDKZbhMk/FjIOnsfZ
        xr+tcWDA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qlQTd-00CxXe-IZ; Wed, 27 Sep 2023 09:05:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3EFA83002E3; Wed, 27 Sep 2023 11:05:01 +0200 (CEST)
Date:   Wed, 27 Sep 2023 11:05:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        andres@anarazel.de, tglx@linutronix.de
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Message-ID: <20230927090501.GB21810@noisy.programming.kicks-ass.net>
References: <20230921182908.160080-1-axboe@kernel.dk>
 <20230921182908.160080-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921182908.160080-5-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 21, 2023 at 12:29:04PM -0600, Jens Axboe wrote:

> +int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> +	u32 flags;
> +
> +	if (unlikely(sqe->fd || sqe->len || sqe->buf_index || sqe->file_index))
> +		return -EINVAL;
> +
> +	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	iof->futex_val = READ_ONCE(sqe->addr2);
> +	iof->futex_mask = READ_ONCE(sqe->addr3);
> +	flags = READ_ONCE(sqe->futex_flags);
> +
> +	if (flags & ~FUTEX2_VALID_MASK)
> +		return -EINVAL;
> +
> +	iof->futex_flags = futex2_to_flags(flags);

So prep does the flags conversion..

> +	if (!futex_flags_valid(iof->futex_flags))
> +		return -EINVAL;
> +
> +	if (!futex_validate_input(iof->futex_flags, iof->futex_val) ||
> +	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
> +		return -EINVAL;
> +
> +	return 0;
> +}

> +int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_futex_data *ifd = NULL;
> +	struct futex_hash_bucket *hb;
> +	int ret;
> +
> +	if (!iof->futex_mask) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +	ifd = io_alloc_ifd(ctx);
> +	if (!ifd) {
> +		ret = -ENOMEM;
> +		goto done_unlock;
> +	}
> +
> +	req->async_data = ifd;
> +	ifd->q = futex_q_init;
> +	ifd->q.bitset = iof->futex_mask;
> +	ifd->q.wake = io_futex_wake_fn;
> +	ifd->req = req;
> +
> +	ret = futex_wait_setup(iof->uaddr, iof->futex_val,
> +			       futex2_to_flags(iof->futex_flags), &ifd->q, &hb);

But then wait and..

> +	if (!ret) {
> +		hlist_add_head(&req->hash_node, &ctx->futex_list);
> +		io_ring_submit_unlock(ctx, issue_flags);
> +
> +		futex_queue(&ifd->q, hb);
> +		return IOU_ISSUE_SKIP_COMPLETE;
> +	}
> +
> +done_unlock:
> +	io_ring_submit_unlock(ctx, issue_flags);
> +done:
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, 0);
> +	kfree(ifd);
> +	return IOU_OK;
> +}
> +
> +int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> +	int ret;
> +
> +	ret = futex_wake(iof->uaddr, futex2_to_flags(iof->futex_flags),

... wake do it both again?

Also, I think we want wake to have wake do: 

  'FLAGS_STRICT | iof->futex_flags'

See 43adf8449510 ("futex: FLAGS_STRICT"), I'm thinking that waking 0
futexes should honour that request by waking 0, not 1 :-)

> +			 iof->futex_val, iof->futex_mask);
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_set_res(req, ret, 0);
> +	return IOU_OK;
> +}
