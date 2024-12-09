Return-Path: <io-uring+bounces-5316-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BA59E94B4
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 13:47:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46F24164999
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 12:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595B721B1A7;
	Mon,  9 Dec 2024 12:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NotqBDAO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D871217F46;
	Mon,  9 Dec 2024 12:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748433; cv=none; b=Lg+Z/xXuq0RvEahtvR78zLhNmkClYKrkUgrgsacdtyg9/L+DVFH3C6D8DDr46EbCl7yRmJ//HyG9J92diXfx+3Oln7N535PP//pOU13zKCS+USliubHFwo5oCp5OOa282j+SFFWUE4njEjxJsNEaXCWad6CD2YAlJs0kJPQTZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748433; c=relaxed/simple;
	bh=rx/satrX6NOMI1d5jJfnZ/jJL/Cz4Bcc5+zr+o7LYjg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=YaDYQF9RlhF//4JTpTe0wpvpDJP2K0rmTTbxIOTqq3ux6AvxpqxoVxHqT3SAPCOpE+XnKdmCpC4KDIYAjR/Uq8vgHliPGI4jddySBeFVtGqc5LOua7ZgUr1exuOe48W8+zxR3XYKUkOjvFUS0244+313cAaN05GBJf7NHVZWjWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NotqBDAO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45D1C4CED1;
	Mon,  9 Dec 2024 12:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733748432;
	bh=rx/satrX6NOMI1d5jJfnZ/jJL/Cz4Bcc5+zr+o7LYjg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=NotqBDAOEAuflm1ByoRUQUMkQM/GR5PEXG1GbWl9lNsG0DIFVBHwfaazKgSacNw4a
	 wi5+hewIptbshNnRaZhmnynUnN0rpfF6DqppylKvadwlmXOXqz9noLoUK5Y9LnMA1N
	 47lK5kmBGwNhJD2HUkfxZv6rabxYgt2JDHykOrpbGX30Q05yj8ghVba89TGniHAY4N
	 Vzi3q6IhLb3BBiSKT4vp3Opg412GKpzwG6fYq48H44n8KsYhkQW+XgBawLdsOkMCK/
	 tT5rkDDV4NB6MCRX5cDBqtns+HPgK2hZZvJueRZrTeg0y0S8YmB4xCPzZ2STvG78Cj
	 2VtKXmLdQi8QA==
Date: Mon, 9 Dec 2024 13:47:06 +0100
From: Christian Brauner <brauner@kernel.org>
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk
Cc: hch@lst.de, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com, 
	joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv12 01/12] fs: add write stream information to statx
Message-ID: <20241209-ruhezeit-stachelschwein-c49556b975e6@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241206221801.790690-2-kbusch@meta.com>
 <20241206221801.790690-3-kbusch@meta.com>

On Fri, Dec 06, 2024 at 02:17:50PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Add new statx field to report the maximum number of write streams
> supported and the granularity for them.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> [hch: rename hint to stream, add granularity]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/stat.c                 | 2 ++
>  include/linux/stat.h      | 2 ++
>  include/uapi/linux/stat.h | 7 +++++--
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/stat.c b/fs/stat.c
> index 0870e969a8a0b..00e4598b1ff25 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -729,6 +729,8 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
>  	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
>  	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
>  	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
> +	tmp.stx_write_stream_granularity = stat->write_stream_granularity;
> +	tmp.stx_write_stream_max = stat->write_stream_max;
>  
>  	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
>  }
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index 3d900c86981c5..36d4dfb291abd 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -57,6 +57,8 @@ struct kstat {
>  	u32		atomic_write_unit_min;
>  	u32		atomic_write_unit_max;
>  	u32		atomic_write_segments_max;
> +	u32		write_stream_granularity;
> +	u16		write_stream_max;
>  };
>  
>  /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 887a252864416..547c62a1a3a7c 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -132,9 +132,11 @@ struct statx {
>  	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
>  	/* 0xb0 */
>  	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
> -	__u32   __spare1[1];
> +	__u32   stx_write_stream_granularity;
>  	/* 0xb8 */
> -	__u64	__spare3[9];	/* Spare space for future expansion */
> +	__u16   stx_write_stream_max;
> +	__u16	__sparse2[3];
> +	__u64	__spare3[8];	/* Spare space for future expansion */
>  	/* 0x100 */
>  };

Once you're ready to merge, let me know so I can give you a stable
branch with the fs changes.

>  
> @@ -164,6 +166,7 @@ struct statx {
>  #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
>  #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
>  #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
> +#define STATX_WRITE_STREAM	0x00020000U	/* Want/got write_stream_* */
>  
>  #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
>  
> -- 
> 2.43.5
> 

On Fri, Dec 06, 2024 at 02:17:51PM -0800, Keith Busch wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Prepare for io_uring passthrough of write streams. The write stream
> field in the kiocb structure fits into an existing 2-byte hole, so its
> size is not changed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/fs.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2cc3d45da7b01..26940c451f319 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -373,6 +373,7 @@ struct kiocb {
>  	void			*private;
>  	int			ki_flags;
>  	u16			ki_ioprio; /* See linux/ioprio.h */
> +	u8			ki_write_stream;
>  	union {
>  		/*
>  		 * Only used for async buffered reads, where it denotes the
> -- 
> 2.43.5
> 

