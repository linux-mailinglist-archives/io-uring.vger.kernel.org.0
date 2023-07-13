Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABF9751FAB
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 13:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjGMLPX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 07:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjGMLPW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 07:15:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43751211E;
        Thu, 13 Jul 2023 04:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xp/JG4/G1ATrTAJs+ii6ztYxtOJ+Dc811mAA+mAjxxo=; b=BTu2p49E1i+SM7USiXt11gQW/B
        Y9ogFcRONmlhAnao9/ZSC4+XzSunDGEY98wYAXye9jnRf6g/9QL2BNUPoZG85HoMqw1cK9DWQt6cO
        tMjOyHpNYxIv91/0LTagui6gwCeA0OZaJiq5BR+Y+QtPmU2nZgVm7glv7rDuk513P+yrftdnGoJaP
        OBWXYu/72ZGvg40r34uGnZCc5nfG9gyRD1U/3dF4yU57CdLh3O6sChTr3GJNUQ34okoY+JF85V5v6
        46ueeHH/IOx/rH4SVLvPV2YMIoA3et/iqIEXYhlcH6zl9KG0+TaXb8megaXbXz6vX4gXdgqaktG/Q
        0BwWrctA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJuHy-004eZW-2K;
        Thu, 13 Jul 2023 11:15:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 74CE73002CE;
        Thu, 13 Jul 2023 13:15:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 316F8245E1182; Thu, 13 Jul 2023 13:15:13 +0200 (CEST)
Date:   Thu, 13 Jul 2023 13:15:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, andres@anarazel.de
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Message-ID: <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
References: <20230712162017.391843-1-axboe@kernel.dk>
 <20230712162017.391843-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712162017.391843-5-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 12, 2023 at 10:20:13AM -0600, Jens Axboe wrote:

> +int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> +
> +	if (unlikely(sqe->addr2 || sqe->buf_index || sqe->addr3))
> +		return -EINVAL;
> +
> +	iof->futex_op = READ_ONCE(sqe->fd);
> +	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	iof->futex_val = READ_ONCE(sqe->len);
> +	iof->futex_mask = READ_ONCE(sqe->file_index);
> +	iof->futex_flags = READ_ONCE(sqe->futex_flags);
> +	if (iof->futex_flags & FUTEX_CMD_MASK)
> +		return -EINVAL;
> +
> +	return 0;
> +}

I'm a little confused on the purpose of iof->futex_op, it doesn't appear
to be used. Instead iof->futex_flags is used as the ~FUTEX_CMD_MASK part
of ops.

The latter actually makes sense since you encode the actual op in the
IOURING_OP_ space.

> +int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_futex_data *ifd = NULL;
> +	struct futex_hash_bucket *hb;
> +	unsigned int flags;
> +	int ret;
> +
> +	if (!iof->futex_mask) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +	if (!futex_op_to_flags(FUTEX_WAIT, iof->futex_flags, &flags)) {

A little confusing since you then implement FUTEX_WAIT_BITSET, but using
FUTEX_WAIT ensures this goes -ENOSYS when setting FUTEX_CLOCK_REALTIME,
since you handle timeouts through the iouring thing.

Perhaps a comment?

> +		ret = -ENOSYS;
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
> +	ret = futex_wait_setup(iof->uaddr, iof->futex_val, flags, &ifd->q, &hb);
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

Other than that, I think these things are indeed transparant wrt the
existing futex interface. If we add a flag this shouldn't care.


