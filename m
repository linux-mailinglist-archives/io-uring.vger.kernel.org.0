Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5775C4024B7
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 09:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhIGHwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 03:52:04 -0400
Received: from verein.lst.de ([213.95.11.211]:34982 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233626AbhIGHwD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 7 Sep 2021 03:52:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B256D67373; Tue,  7 Sep 2021 09:50:55 +0200 (CEST)
Date:   Tue, 7 Sep 2021 09:50:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de
Subject: Re: [RFC PATCH 6/6] nvme: enable passthrough with fixed-buffer
Message-ID: <20210907075055.GE29874@lst.de>
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125937epcas5p15667b460e28d87bd40400f69005aafe3@epcas5p1.samsung.com> <20210805125539.66958-7-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805125539.66958-7-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +/*
> + * Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough.
> + * And hopefully faster as well.
> + */

This belongs into io_uring.c.  And that hopeful comment needs to be
validated and removed.

> +int nvme_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
> +		     void __user *ubuf, unsigned long len, gfp_t gfp_mask,
> +		     struct io_uring_cmd *ioucmd)
> +{
> +	struct iov_iter iter;
> +	size_t iter_count, nr_segs;
> +	struct bio *bio;
> +	int ret;
> +
> +	/*
> +	 * Talk to io_uring to obtain BVEC iterator for the buffer.
> +	 * And use that iterator to form bio/request.
> +	 */
> +	ret = io_uring_cmd_import_fixed(ubuf, len, rq_data_dir(rq), &iter,
> +			ioucmd);

io_uring_cmd_import_fixed takes a non-__user pointer, so this will cause
a sparse warning.
