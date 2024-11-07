Return-Path: <io-uring+bounces-4519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC5F19BFDE0
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 06:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AAAD1F23578
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 05:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F743191496;
	Thu,  7 Nov 2024 05:55:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB3BD53F;
	Thu,  7 Nov 2024 05:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730958948; cv=none; b=SSfkDAy1CTSRZXJ8mfXW5nsRdSrTsroj75dNjhSV/veFc2e4JED9UPbdf2CWubmJYltUzdFqY4CJfWus7TLpWjTJ+0o+FCPSduRp7WoZDtW8VIWWE8NHd5N8VQCbaohLwIPmM3PAd5loUDvKYq8WzTQe9NWtIkZqBY7gcBIe5hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730958948; c=relaxed/simple;
	bh=n2kx3mjZuJJX04wkDuItp7UhYkgwwWR9CR/57QaNm84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPAI9k8zwI71bB0EbWPP0ITEZYb17MuK4X3420N21zPlT9HUWVrQi+UUPg3QqySinukSKUhlwPMvZe9ZFxuGmaMO7AuhCUzHbUHzbMJW+FLV/Q7giBHn7rP9C8ktFyeLI7FIAzM4Ab82h5gMXobFF5/1Ly+Ieb8MzjilRB10Y5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 677C5227A87; Thu,  7 Nov 2024 06:55:42 +0100 (CET)
Date: Thu, 7 Nov 2024 06:55:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v8 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241107055542.GA2483@lst.de>
References: <20241106121842.5004-1-anuj20.g@samsung.com> <CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com> <20241106121842.5004-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106121842.5004-7-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +enum io_uring_sqe_ext_cap_bits {
> +	EXT_CAP_PI_BIT,
> +	/*
> +	 * not a real extended capability; just to make sure that we don't
> +	 * overflow
> +	 */
> +	EXT_CAP_LAST_BIT,
> +};
> +
> +/* extended capability flags */
> +#define EXT_CAP_PI	(1U << EXT_CAP_PI_BIT)

This is getting into nitpicking, but is the a good reason to have that
enum, which is never used as a type and the values or only defined to
actually define the bit positions below?  That's a bit confusing to
me.

Also please document the ABI for EXT_CAP_PI, right now this is again
entirely undocumented.

> +/* Second half of SQE128 for IORING_OP_READ/WRITE */
> +struct io_uring_sqe_ext {
> +	__u64	rsvd0[4];
> +	/* if sqe->ext_cap is EXT_CAP_PI, last 32 bytes are for PI */
> +	union {
> +		__u64	rsvd1[4];
> +		struct {
> +			__u16	flags;
> +			__u16	app_tag;
> +			__u32	len;
> +			__u64	addr;
> +			__u64	seed;
> +			__u64	rsvd;
> +		} rw_pi;
> +	};

And this is not what I though we discussed before.  By having a
union here you imply some kind of "type" again that is switched
on a value, and not flags indication the presence of potential
multiple optional and combinable features.  This is what I would
have expected here based on the previous discussion:

struct io_uring_sqe_ext {
	/*
	 * Reservered for please tell me what and why it is in the beginning
	 * and not the end:
	 */
	__u64	rsvd0[4];

	/*
	 * Only valid when EXT_CAP_PI is set:
	 */
	__u16	pi_flags; /* or make this generic flags, dunno? */
	__u16	app_tag;
	__u32	pi_len;
	__u64	pi_addr;
	__u64	pi_seed;

	__u64	rsvd1;
};


