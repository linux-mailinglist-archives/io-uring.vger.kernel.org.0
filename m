Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B593433FF00
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhCRFnM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:43:12 -0400
Received: from verein.lst.de ([213.95.11.211]:40050 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhCRFm5 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Mar 2021 01:42:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CEB1068C7B; Thu, 18 Mar 2021 06:42:54 +0100 (CET)
Date:   Thu, 18 Mar 2021 06:42:54 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, hch@lst.de,
        kbusch@kernel.org, linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 4/8] io_uring: add support for IORING_OP_URING_CMD
Message-ID: <20210318054254.GC28063@lst.de>
References: <20210317221027.366780-1-axboe@kernel.dk> <20210317221027.366780-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221027.366780-5-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 04:10:23PM -0600, Jens Axboe wrote:
> +/*
> + * Called by consumers of io_uring_cmd, if they originally returned
> + * -EIOCBQUEUED upon receiving the command.
> + */
> +void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
> +{
> +	struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
> +
> +	if (ret < 0)
> +		req_set_fail_links(req);
> +	io_req_complete(req, ret);
> +}
> +EXPORT_SYMBOL(io_uring_cmd_done);

This really should be EXPORT_SYMBOL_GPL. But more importantly I'm not
sure it is an all that useful interface.  All useful non-trivial ioctls
tend to access user memory, so something that queues up work in the task
context like in Joshis patch should really be part of the documented
interface.

> +
> +static int io_uring_cmd_prep(struct io_kiocb *req,
> +			     const struct io_uring_sqe *sqe)
> +{
> +	const struct io_uring_cmd_sqe *csqe = (const void *) sqe;

We really should not need this casting.  The struct io_uring_sqe
usage in io_uring.c needs to be replaced with a union or some other
properly type safe way to handle this.

> +	ret = file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
> +	/* queued async, consumer will call io_uring_cmd_done() when complete */
> +	if (ret == -EIOCBQUEUED)
> +		return 0;
> +	io_uring_cmd_done(&req->uring_cmd, ret);
> +	return 0;

This can be simplified to:

	if (ret != -EIOCBQUEUED)
		io_uring_cmd_done(&req->uring_cmd, ret);
	return 0;


> +/*
> + * Note that the first member here must be a struct file, as the
> + * io_uring command layout depends on that.
> + */
> +struct io_uring_cmd {
> +	struct file	*file;
> +	__u16		op;
> +	__u16		unused;
> +	__u32		len;
> +	__u64		pdu[5];	/* 40 bytes available inline for free use */
> +};

I am a little worried about exposting this internal structure to random
drivers.  OTOH we need something that eventually allows a container_of
to io_kiocb for the completion, so I can't think of anything better
at the moment either.
