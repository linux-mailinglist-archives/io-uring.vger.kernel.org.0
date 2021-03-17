Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC23733EBDF
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 09:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCQIx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 04:53:29 -0400
Received: from verein.lst.de ([213.95.11.211]:36055 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhCQIxB (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Mar 2021 04:53:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 95AA468BEB; Wed, 17 Mar 2021 09:52:58 +0100 (CET)
Date:   Wed, 17 Mar 2021 09:52:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
Message-ID: <20210317085258.GA19580@lst.de>
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com> <20210316140126.24900-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316140126.24900-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +/*
> + * This is carved within the block_uring_cmd, to avoid dynamic allocation.
> + * Care should be taken not to grow this beyond what is available.
> + */
> +struct uring_cmd_data {
> +	union {
> +		struct bio *bio;
> +		u64 result; /* nvme cmd result */
> +	};
> +	void *meta; /* kernel-resident buffer */
> +	int status; /* nvme cmd status */
> +};
> +
> +inline u64 *ucmd_data_addr(struct io_uring_cmd *ioucmd)
> +{
> +	return &(((struct block_uring_cmd *)&ioucmd->pdu)->unused[0]);
> +}

The whole typing is a mess, but this mostly goes back to the series
you're basing this on.  Jens, can you send out the series so that
we can do a proper review?

IMHO struct io_uring_cmd needs to stay private in io-uring.c, and
the method needs to get the file and the untyped payload in form
of a void * separately.  and block_uring_cmd should be private to
the example ioctl, not exposed to drivers implementing their own
schemes.

> +void ioucmd_task_cb(struct io_uring_cmd *ioucmd)

This should be mark static and have a much more descriptive name
including a nvme_ prefix.

> +	/* handle meta update */
> +	if (ucd->meta) {
> +		void __user *umeta = nvme_to_user_ptr(ptcmd->metadata);
> +
> +		if (!ucd->status)
> +			if (copy_to_user(umeta, ucd->meta, ptcmd->metadata_len))
> +				ucd->status = -EFAULT;
> +		kfree(ucd->meta);
> +	}
> +	/* handle result update */
> +	if (put_user(ucd->result, (u32 __user *)&ptcmd->result))

The comments aren't very useful, and the cast here is a warning sign.
Why do you need it?

> +		ucd->status = -EFAULT;
> +	io_uring_cmd_done(ioucmd, ucd->status);

Shouldn't the io-uring core take care of this io_uring_cmd_done
call?

> +void nvme_end_async_pt(struct request *req, blk_status_t err)

static?

> +{
> +	struct io_uring_cmd *ioucmd;
> +	struct uring_cmd_data *ucd;
> +	struct bio *bio;
> +	int ret;
> +
> +	ioucmd = req->end_io_data;
> +	ucd = (struct uring_cmd_data *) ucmd_data_addr(ioucmd);
> +	/* extract bio before reusing the same field for status */
> +	bio = ucd->bio;
> +
> +	if (nvme_req(req)->flags & NVME_REQ_CANCELLED)
> +		ucd->status = -EINTR;
> +	else
> +		ucd->status = nvme_req(req)->status;
> +	ucd->result = le64_to_cpu(nvme_req(req)->result.u64);
> +
> +	/* this takes care of setting up task-work */
> +	ret = uring_cmd_complete_in_task(ioucmd, ioucmd_task_cb);
> +	if (ret < 0)
> +		kfree(ucd->meta);
> +
> +	/* unmap pages, free bio, nvme command and request */
> +	blk_rq_unmap_user(bio);
> +	blk_mq_free_request(req);

How can we free the request here if the data is only copied out in
a task_work?

>  static int nvme_submit_user_cmd(struct request_queue *q,
>  		struct nvme_command *cmd, void __user *ubuffer,
>  		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
> -		u32 meta_seed, u64 *result, unsigned timeout)
> +		u32 meta_seed, u64 *result, unsigned int timeout,
> +		struct io_uring_cmd *ioucmd)
>  {
>  	bool write = nvme_is_write(cmd);
>  	struct nvme_ns *ns = q->queuedata;
> @@ -1179,6 +1278,20 @@ static int nvme_submit_user_cmd(struct request_queue *q,
>  			req->cmd_flags |= REQ_INTEGRITY;
>  		}
>  	}
> +	if (ioucmd) { /* async handling */

nvme_submit_user_cmd already is a mess.  Please split this out into
a separate function.  Maybe the logic to map the user buffers can be
split into a little shared helper.

> +int nvme_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
> +		enum io_uring_cmd_flags flags)

Another comment on the original infrastructure:  this really needs to
be a block_device_operations method taking a struct block_device instead
of being tied into blk-mq.

> +EXPORT_SYMBOL_GPL(nvme_uring_cmd);

I don't think this shoud be exported.
