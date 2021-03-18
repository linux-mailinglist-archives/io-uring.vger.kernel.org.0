Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5481D33FEE6
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhCRFe6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:34:58 -0400
Received: from verein.lst.de ([213.95.11.211]:40024 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhCRFe6 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Mar 2021 01:34:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0838368C4E; Thu, 18 Mar 2021 06:34:54 +0100 (CET)
Date:   Thu, 18 Mar 2021 06:34:54 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, hch@lst.de,
        kbusch@kernel.org, linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 1/8] io_uring: split up io_uring_sqe into hdr + main
Message-ID: <20210318053454.GA28063@lst.de>
References: <20210317221027.366780-1-axboe@kernel.dk> <20210317221027.366780-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221027.366780-2-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> @@ -14,11 +14,22 @@
>  /*
>   * IO submission data structure (Submission Queue Entry)
>   */
> +struct io_uring_sqe_hdr {
> +	__u8	opcode;		/* type of operation for this sqe */
> +	__u8	flags;		/* IOSQE_ flags */
> +	__u16	ioprio;		/* ioprio for the request */
> +	__s32	fd;		/* file descriptor to do IO on */
> +};
> +
>  struct io_uring_sqe {
> +#ifdef __KERNEL__
> +	struct io_uring_sqe_hdr	hdr;
> +#else
>  	__u8	opcode;		/* type of operation for this sqe */
>  	__u8	flags;		/* IOSQE_ flags */
>  	__u16	ioprio;		/* ioprio for the request */
>  	__s32	fd;		/* file descriptor to do IO on */
> +#endif
>  	union {
>  		__u64	off;	/* offset into file */
>  		__u64	addr2;

Please don't do that ifdef __KERNEL__ mess.  We never guaranteed
userspace API compatbility, just ABI compatibility.

But we really do have a biger problem here, and that is ioprio is
a field that is specific to the read and write commands and thus
should not be in the generic header.  On the other hand the
personality is.

So I'm not sure trying to retrofit this even makes all that much sense.

Maybe we should just define io_uring_sqe_hdr the way it makes
sense:

struct io_uring_sqe_hdr {
	__u8	opcode;	
	__u8	flags;
	__u16	personality;
	__s32	fd;
	__u64	user_data;
};

and use that for all new commands going forward while marking the
old ones as legacy.

io_uring_cmd_sqe would then be:

struct io_uring_cmd_sqe {
        struct io_uring_sqe_hdr	hdr;
	__u33			ioc;
	__u32 			len;
	__u8			data[40];
};

for example.  Note the 32-bit opcode just like ioctl to avoid
getting into too much trouble due to collisions.

