Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A119B33FEF1
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCRFi6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:38:58 -0400
Received: from verein.lst.de ([213.95.11.211]:40033 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229454AbhCRFif (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Mar 2021 01:38:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 721C268C65; Thu, 18 Mar 2021 06:38:32 +0100 (CET)
Date:   Thu, 18 Mar 2021 06:38:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, hch@lst.de,
        kbusch@kernel.org, linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 3/8] fs: add file_operations->uring_cmd()
Message-ID: <20210318053832.GB28063@lst.de>
References: <20210317221027.366780-1-axboe@kernel.dk> <20210317221027.366780-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221027.366780-4-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 04:10:22PM -0600, Jens Axboe wrote:
> This is a file private handler, similar to ioctls but hopefully a lot
> more sane and useful.

I really hate defining the interface in terms of io_uring.  This really
is nothing but an async ioctl.

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ec8f3ddf4a6a..009abc668987 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1884,6 +1884,15 @@ struct dir_context {
>  #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
>  
>  struct iov_iter;
> +struct io_uring_cmd;
> +
> +/*
> + * f_op->uring_cmd() issue flags
> + */
> +enum io_uring_cmd_flags {
> +	IO_URING_F_NONBLOCK		= 1,
> +	IO_URING_F_COMPLETE_DEFER	= 2,
> +};

I'm a little worried about exposing a complete io_uring specific
concept like IO_URING_F_COMPLETE_DEFER to random drivers.  This
needs to be better encapsulated.

>  struct file_operations {
>  	struct module *owner;
> @@ -1925,6 +1934,8 @@ struct file_operations {
>  				   struct file *file_out, loff_t pos_out,
>  				   loff_t len, unsigned int remap_flags);
>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
> +
> +	int (*uring_cmd)(struct io_uring_cmd *, enum io_uring_cmd_flags);

As of this patch io_uring_cmd is still a private structure.  In general
I'm not sure this patch makes much sense on its own either.
