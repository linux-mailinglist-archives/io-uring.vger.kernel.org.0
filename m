Return-Path: <io-uring+bounces-4247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0DD9B6E6B
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 22:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0382B281EA9
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30E42139A4;
	Wed, 30 Oct 2024 21:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAKgH6Pm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718D01F4700;
	Wed, 30 Oct 2024 21:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730322570; cv=none; b=q044QovSFzGS4i3QcUigopXhNUdJD8TWUtvM+DDGXxdZB3BAQSdYdjRZsEXp+OilqRhoFYWAxu+DxIsnX6lERQ9CFWkKtNh7co2+SmCgFXKWfts1g1of0WLuKhbXQoavK685tcQ9XgDCKGzlR0LTXWHrqUTSDn4/XeK5PS9Ll5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730322570; c=relaxed/simple;
	bh=NBQ38qs+AbyE0Vr5iDj8caZDO5/MYkzq0hD2+YnFywI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWnPPSFRoEsbWYyXlhdX04gCrjZx1YdsCuO+tXGcWSbpB8QTje1yYk/bEyC1uuN3q9twFG8TrRG77Az89WLkcOKIWch11E4tWYPdTDwI3p/aSfkY3P237Qe9/OVig+hJsLMfLc14+yFLlJiM6enHHXxUt+ix7ZNEj5neCqlcP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAKgH6Pm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A5AC4CECE;
	Wed, 30 Oct 2024 21:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730322569;
	bh=NBQ38qs+AbyE0Vr5iDj8caZDO5/MYkzq0hD2+YnFywI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DAKgH6Pmk7D2XBp3rQzuXx0gmeaTve7/Q+dbQ3Anyg2ljqQvRnSqbacrTvbXsN5ou
	 G8Fy8GdyHdrOacMUD2zMcHK37+gABPdJQGK2G/IWs5WhA4GRqbtM1Ns39tPviPAUCG
	 UTsIBn5/d6xL267h9o1ECYi7+hqDK5lg0UVxm6czQgLXVjp9IhV3NNbPrErHeEYNsT
	 hvxg4BlgiQ/CzplHAPDdiljSmVNrlRtXAZUimsNWCyZOl72QdmWE/5ETP0yc2xp3Ty
	 MvW5EpmRDHStTsQrPev91kCO7hV9wdC4WP/F+aLzDNHfCuKb1kegKtFtE+T2b9PQ++
	 BJArTVNMCczvQ==
Date: Wed, 30 Oct 2024 15:09:26 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	gost.dev@samsung.com, vishak.g@samsung.com, anuj1072538@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata along
 with read/write
Message-ID: <ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
References: <20241030180112.4635-1-joshi.k@samsung.com>
 <CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>
 <20241030180112.4635-7-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030180112.4635-7-joshi.k@samsung.com>

On Wed, Oct 30, 2024 at 11:31:08PM +0530, Kanchan Joshi wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 024745283783..48dcca125db3 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -105,6 +105,22 @@ struct io_uring_sqe {
>  		 */
>  		__u8	cmd[0];
>  	};
> +	/*
> +	 * If the ring is initialized with IORING_SETUP_SQE128, then
> +	 * this field is starting offset for 64 bytes of data. For meta io
> +	 * this contains 'struct io_uring_meta_pi'
> +	 */
> +	__u8	big_sqe[0];
> +};
> +
> +/* this is placed in SQE128 */
> +struct io_uring_meta_pi {
> +	__u16		pi_flags;
> +	__u16		app_tag;
> +	__u32		len;
> +	__u64		addr;
> +	__u64		seed;
> +	__u64		rsvd[2];
>  };

On the previous version, I was more questioning if it aligns with what
Pavel was trying to do here. I didn't quite get it, so I was more
confused than saying it should be this way now.

But I personally think this path makes sense. I would set it up just a
little differently for extended sqe's so that the PI overlays a more
generic struct that other opcodes might find a way to use later.
Something like:

struct io_uring_sqe_ext {
	union {
		__u32	rsvd0[8];
		struct {
			__u16		pi_flags;
			__u16		app_tag;
			__u32		len;
			__u64		addr;
			__u64		seed;
		} rw_pi;
	};
	__u32	rsvd1[8];
};
  
> @@ -3902,6 +3903,9 @@ static int __init io_uring_init(void)
>  	/* top 8bits are for internal use */
>  	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
>  
> +	BUILD_BUG_ON(sizeof(struct io_uring_meta_pi) >
> +		     sizeof(struct io_uring_sqe));

Then this check would become:

	BUILD_BUG_ON(sizeof(struct io_uring_sqe_ext) != sizeof(struct io_uring_sqe));

