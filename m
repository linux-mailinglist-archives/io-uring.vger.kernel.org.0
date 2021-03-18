Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE133FF02
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCRFoQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:44:16 -0400
Received: from verein.lst.de ([213.95.11.211]:40062 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCRFoJ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Mar 2021 01:44:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 89D8868C8C; Thu, 18 Mar 2021 06:44:07 +0100 (CET)
Date:   Thu, 18 Mar 2021 06:44:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, hch@lst.de,
        kbusch@kernel.org, linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 5/8] block: wire up support for
 file_operations->uring_cmd()
Message-ID: <20210318054407.GD28063@lst.de>
References: <20210317221027.366780-1-axboe@kernel.dk> <20210317221027.366780-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221027.366780-6-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +int blk_uring_cmd(struct block_device *bdev, struct io_uring_cmd *cmd,
> +		  enum io_uring_cmd_flags issue_flags)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (!q->mq_ops || !q->mq_ops->uring_cmd)
> +		return -EOPNOTSUPP;
> +
> +	return q->mq_ops->uring_cmd(q, cmd, issue_flags);
> +}

This has absilutely not business in blk-mq.  It is a plain
block_device_operation that has nothing to do with requests or
blk-mq.
