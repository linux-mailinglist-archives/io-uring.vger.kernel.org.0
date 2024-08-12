Return-Path: <io-uring+bounces-2701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B3D94EBC2
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 13:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B63B11F22339
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 11:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C72171066;
	Mon, 12 Aug 2024 11:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eI1k8baS"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADDD130495;
	Mon, 12 Aug 2024 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723462023; cv=none; b=YpVQ+7bLbPKA1jMPhK62eKvhfXAxSwFFEHSvh7dHY1fLbEgeyXlSQ2QXL9002ZDLCzR+nC2pHJbtIBFREwZ8zkYmhP6bA72C2Tyz8b40gJj4NrjQ0/ceBZXDrgCuYmTmwHsQYvwuP5amLgc19i/y6BVZGO55MwLqopjAYiBjRrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723462023; c=relaxed/simple;
	bh=F8I1SY3rXlC2gfcrEh1GD/M48WGX4duQA0Xf3cSqbW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhqkAzMtDKbF8QZ2muCX3QqsXqxaK7xAnhnlSjJ4QN0EedfzPhCMYFPX6ZnnGKdEvl6MmBZrkho5be9BahWZA+K7hERRdpXxbfOE3P4H7BzCZIIbQCkE2we2ECjUbblq/7vFIvZtTMd3lH6cmYrCvn9AjagztiJMGG/iIz3RBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eI1k8baS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XzgLkolRhPVwGss834FlidYVeS9OBsZfq9KH2KXQ19k=; b=eI1k8baSAk30s74B+KSj0Di1Nw
	YMy1P2zjaVEO3vBEFRQeOxm23hnck1GfNbFzBQ/MqzCdpkt4FzNTgeNSos1Buv2XILIkSA564nMmE
	z1entxSJiQM9WnedTTat+niPg/yUGGLnuUaH0N8QWQ9cKtwEjAjcjNBQFxRi/XGU6RIufGZ1bd3q/
	D4fui/ujT+/eRxUYQvLVfR/i/U8v3qrI7QeTuqNDXIF0V8ZCQX5hliiE/f9fr4cio/QDP5RYJX8NY
	HHDvq61QTJGAy6YJKdSl4OyzzsgtBT5llZYfTYb2IQm6W4ztBLHkZh55goyFNQnniQJ0+8Qax1DI2
	gdu5rV/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdTCU-000000008Fu-0yts;
	Mon, 12 Aug 2024 11:26:58 +0000
Date: Mon, 12 Aug 2024 04:26:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
Message-ID: <Zrnxgu7vkVDgI6VU@infradead.org>
References: <20240809173552.929988-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809173552.929988-1-maharmstone@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 09, 2024 at 06:35:27PM +0100, Mark Harmstone wrote:
> Adds an io_uring interface for asynchronous encoded reads, using the
> same interface as for the ioctl. To use this you would use an SQE opcode
> of IORING_OP_URING_CMD, the cmd_op would be BTRFS_IOC_ENCODED_READ, and
> addr would point to the userspace address of the
> btrfs_ioctl_encoded_io_args struct. As with the ioctl, you need to have
> CAP_SYS_ADMIN for this to work.

What is the point if this doesn't actually do anything but returning
-EIOCBQUEUED?

Note that that the internals of the btrfs encoded read is built
around kiocbs anyway, so you might as well turn things upside down,
implement a real async io_uring cmd and just wait for it to complete
to implement the existing synchronous ioctl.

> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>  fs/btrfs/file.c  |  1 +
>  fs/btrfs/ioctl.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |  1 +
>  3 files changed, 50 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f9d76072398d..974f9e85b46e 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3850,6 +3850,7 @@ const struct file_operations btrfs_file_operations = {
>  	.compat_ioctl	= btrfs_compat_ioctl,
>  #endif
>  	.remap_file_range = btrfs_remap_file_range,
> +	.uring_cmd	= btrfs_uring_cmd,
>  };
>  
>  int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end)
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0493272a7668..8f5cc7d1429c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -29,6 +29,7 @@
>  #include <linux/fileattr.h>
>  #include <linux/fsverity.h>
>  #include <linux/sched/xacct.h>
> +#include <linux/io_uring/cmd.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "export.h"
> @@ -4648,6 +4649,53 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
>  	return ret;
>  }
>  
> +static void btrfs_uring_encoded_read_cb(struct io_uring_cmd *cmd,
> +					unsigned int issue_flags)
> +{
> +	int ret;
> +
> +	ret = btrfs_ioctl_encoded_read(cmd->file, (void __user *)cmd->sqe->addr,
> +				       false);
> +
> +	io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +}
> +
> +static void btrfs_uring_encoded_read_compat_cb(struct io_uring_cmd *cmd,
> +					       unsigned int issue_flags)
> +{
> +	int ret;
> +
> +	ret = btrfs_ioctl_encoded_read(cmd->file, (void __user *)cmd->sqe->addr,
> +				       true);
> +
> +	io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +}
> +
> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	if (issue_flags & IO_URING_F_COMPAT)
> +		io_uring_cmd_complete_in_task(cmd, btrfs_uring_encoded_read_compat_cb);
> +	else
> +		io_uring_cmd_complete_in_task(cmd, btrfs_uring_encoded_read_cb);
> +
> +	return -EIOCBQUEUED;
> +}
> +
> +int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	switch (cmd->cmd_op) {
> +	case BTRFS_IOC_ENCODED_READ:
> +#if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
> +	case BTRFS_IOC_ENCODED_READ_32:
> +#endif
> +		return btrfs_uring_encoded_read(cmd, issue_flags);
> +	}
> +
> +	io_uring_cmd_done(cmd, -EINVAL, 0, issue_flags);
> +	return -EIOCBQUEUED;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 2c5dc25ec670..33578f4b5f46 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -22,5 +22,6 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode);
>  int __pure btrfs_is_empty_uuid(u8 *uuid);
>  void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
>  				     struct btrfs_ioctl_balance_args *bargs);
> +int btrfs_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>  
>  #endif
> -- 
> 2.44.2
> 
> 
---end quoted text---

