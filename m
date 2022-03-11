Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CB64D5BD7
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 08:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346894AbiCKHC6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 02:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346905AbiCKHC5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 02:02:57 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D6A1AC2AB;
        Thu, 10 Mar 2022 23:01:55 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1BBA868BEB; Fri, 11 Mar 2022 08:01:49 +0100 (CET)
Date:   Fri, 11 Mar 2022 08:01:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220311070148.GA17881@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com> <20220308152105.309618-6-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-6-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:50:53PM +0530, Kanchan Joshi wrote:
> +/*
> + * This overlays struct io_uring_cmd pdu.
> + * Expect build errors if this grows larger than that.
> + */
> +struct nvme_uring_cmd_pdu {
> +	u32 meta_len;
> +	union {
> +		struct bio *bio;
> +		struct request *req;
> +	};
> +	void *meta; /* kernel-resident buffer */
> +	void __user *meta_buffer;
> +} __packed;

Why is this marked __packed?

In general I'd be much more happy if the meta elelements were a
io_uring-level feature handled outside the driver and typesafe in
struct io_uring_cmd, with just a normal private data pointer for the
actual user, which would remove all the crazy casting.

> +static void nvme_end_async_pt(struct request *req, blk_status_t err)
> +{
> +	struct io_uring_cmd *ioucmd = req->end_io_data;
> +	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> +	/* extract bio before reusing the same field for request */
> +	struct bio *bio = pdu->bio;
> +
> +	pdu->req = req;
> +	req->bio = bio;
> +	/* this takes care of setting up task-work */
> +	io_uring_cmd_complete_in_task(ioucmd, nvme_pt_task_cb);

This is a bit silly.  First we defer the actual request I/O completion
from the block layer to a different CPU or softirq and then we have
another callback here.  I think it would be much more useful if we
could find a way to enhance blk_mq_complete_request so that it could
directly complet in a given task.  That would also be really nice for
say normal synchronous direct I/O.

> +	if (ioucmd) { /* async dispatch */
> +		if (cmd->common.opcode == nvme_cmd_write ||
> +				cmd->common.opcode == nvme_cmd_read) {

No we can't just check for specific commands in the passthrough handler.

> +			nvme_setup_uring_cmd_data(req, ioucmd, meta, meta_buffer,
> +					meta_len);
> +			blk_execute_rq_nowait(req, 0, nvme_end_async_pt);
> +			return 0;
> +		} else {
> +			/* support only read and write for now. */
> +			ret = -EINVAL;
> +			goto out_meta;
> +		}

Pleae always handle error in the first branch and don't bother with an
else after a goto or return.

> +static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
> +{
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
> +
> +	switch (ioucmd->cmd_op) {
> +	case NVME_IOCTL_IO64_CMD:
> +		ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
> +		break;
> +	default:
> +		ret = -ENOTTY;
> +	}
> +
> +	if (ret >= 0)
> +		ret = -EIOCBQUEUED;

That's a weird way to handle the returns.  Just return -EIOCBQUEUED
directly from the handler (which as said before should be split from
the ioctl handler anyway).
