Return-Path: <io-uring+bounces-5251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 305FF9E5DEE
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 19:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA62B18856E0
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 18:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CF4225797;
	Thu,  5 Dec 2024 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m07EyLZj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510901922FB;
	Thu,  5 Dec 2024 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733421894; cv=none; b=eVwKy84WFoklo4rjfR7a71QEec9im5NJ/x3NdDxbd/tOpH000dP7AUITKK2j1qKl7UbmUE6RlpXDVZcUXBW1nLT9NA1mxCOxQ97acKhPOLl/wwv185XgGy+SUkbbD6s6f5XzkoaCIPhdPjT7YjIUqADU5P1HTZBKBDBAxI3RXUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733421894; c=relaxed/simple;
	bh=hZtXBo2jdC7H9GEX5zEd/6dIqnpMpPqcvFJELa7vEWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgxpPad9GhnEqH5i9qeUiNTVII3g6IMgZWAruNI1NONfts/Pbsssg+ahbFowfltCq+kXkbpLm/y7Jm/kXQLEXuyPS5UaubnB5VBJFakjbXFs1lZIFYYIApz3WTP/oz70q8azsW2E6580JiVmjEgn/bsOUSobIGFd06lXvGgCuM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m07EyLZj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BABDC4CED1;
	Thu,  5 Dec 2024 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733421894;
	bh=hZtXBo2jdC7H9GEX5zEd/6dIqnpMpPqcvFJELa7vEWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m07EyLZjU+dhfWLP/mB5cAFfr5igeKowggMRD3cYlKDgXfxZkhZ5UddV/46QQlF6z
	 3E4O4Yv25mh6PBav+Mh9A+tIqOGX6rB51txBav+RdsY3sXHL7VPamNp3fev0mPSIr/
	 EiSfDKKiu6JAyc+1LIEfqY/srROvlqGGEpS0TnuAIDfASOtP/L47igrhICFsgzikjx
	 t7/ilUJdJwCI1gR3UJ9f0DRBQ9+ZyQViV90RV1AiR5PR4j5c5lryss5/V9N6oiDi/T
	 TkfiY4HaT8ymdtViw6Q8FIW7IVA1N98wQCFfh6IRys0BOdsiLDPuJz+dNvsbX71KkX
	 +t4SMo43J9pUA==
Date: Thu, 5 Dec 2024 10:04:51 -0800
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 06/10] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <Z1HrQ8lz7vYlRUtX@kbusch-mbp.dhcp.thefacebook.com>
References: <20241128112240.8867-1-anuj20.g@samsung.com>
 <CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>
 <20241128112240.8867-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241128112240.8867-7-anuj20.g@samsung.com>

On Thu, Nov 28, 2024 at 04:52:36PM +0530, Anuj Gupta wrote:
> Add the ability to pass additional attributes along with read/write.
> Application can prepare attibute specific information and pass its
> address using the SQE field:
> 	__u64	attr_ptr;
> 
> Along with setting a mask indicating attributes being passed:
> 	__u64	attr_type_mask;
> 
> Overall 64 attributes are allowed and currently one attribute
> 'IORING_RW_ATTR_FLAG_PI' is supported.
> 
> With PI attribute, userspace can pass following information:
> - flags: integrity check flags IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
> - len: length of PI/metadata buffer
> - addr: address of metadata buffer
> - seed: seed value for reftag remapping
> - app_tag: application defined 16b value
> 
> Process this information to prepare uio_meta_descriptor and pass it down
> using kiocb->private.
> 
> PI attribute is supported only for direct IO.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/uapi/linux/io_uring.h | 16 +++++++
>  io_uring/io_uring.c           |  2 +
>  io_uring/rw.c                 | 83 ++++++++++++++++++++++++++++++++++-
>  io_uring/rw.h                 | 14 +++++-
>  4 files changed, 112 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index aac9a4f8fa9a..38f0d6b10eaf 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -98,6 +98,10 @@ struct io_uring_sqe {
>  			__u64	addr3;
>  			__u64	__pad2[1];
>  		};
> +		struct {
> +			__u64	attr_ptr; /* pointer to attribute information */
> +			__u64	attr_type_mask; /* bit mask of attributes */
> +		};

I can't say I'm a fan of how this turned out. I'm merging up the write
hint stuff, and these new fields occupy where that 16-bit value was
initially going. Okay, so I guess I need to just add a new attribute
flag? That might work if I am only appending exactly one extra attribute
per SQE, but what if I need both PI and Write Hint? Do the attributes
need to appear in a strict order?

