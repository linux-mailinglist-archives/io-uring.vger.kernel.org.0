Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42C533FF06
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCRFpV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:45:21 -0400
Received: from verein.lst.de ([213.95.11.211]:40069 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhCRFpJ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Mar 2021 01:45:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A87CA68CEC; Thu, 18 Mar 2021 06:45:07 +0100 (CET)
Date:   Thu, 18 Mar 2021 06:45:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, hch@lst.de,
        kbusch@kernel.org, linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 6/8] block: add example ioctl
Message-ID: <20210318054506.GE28063@lst.de>
References: <20210317221027.366780-1-axboe@kernel.dk> <20210317221027.366780-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221027.366780-7-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 04:10:25PM -0600, Jens Axboe wrote:
> +static int blkdev_uring_ioctl(struct block_device *bdev,
> +			      struct io_uring_cmd *cmd)
> +{
> +	struct block_uring_cmd *bcmd = (struct block_uring_cmd *) &cmd->pdu;
> +
> +	switch (bcmd->ioctl_cmd) {
> +	case BLKBSZGET:
> +		return block_size(bdev);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
>  static int blkdev_uring_cmd(struct io_uring_cmd *cmd,
>  			    enum io_uring_cmd_flags flags)
>  {
>  	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
>  
> +	switch (cmd->op) {
> +	case BLOCK_URING_OP_IOCTL:
> +		return blkdev_uring_ioctl(bdev, cmd);

I don't think the two level dispatch here makes any sense.  Then again
I don't think this code makes sense either except as an example..
