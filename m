Return-Path: <io-uring+bounces-1272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD82B88F470
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 02:18:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 628D6280A71
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 01:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143421804A;
	Thu, 28 Mar 2024 01:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Vtyh7fqg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBFB2F5B
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711588692; cv=none; b=tvCIkiADD+mB9HdLS0YCaLa6NCqP86AwWgGch3ygii52ufPcpfVrHk126gUFCjgcQi2qa4LGHFgo9n1eIRtxyO0o6YAtZQGKWow2oypAlEGrHQSc0FkEkS6rTt9o5hDg3lg7jpusVFtaqeV5Vr43uuE8e0axRIohAttDggqnam8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711588692; c=relaxed/simple;
	bh=dn2Ubg3Dk8Xfjau8Iw+DO+YblsdGozTmuehRwlAGRNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BllcAu+o9JIxX7Ol7FKM0o6WsrBEV9nUUn1rv+J5WOmug2+MUd3Zse6FVFpTtg22zSK2sSb5RS/xoA0+a7Tz0XITE9YzFnbjW6T0zD1Ts9MeQvFJAgfjRTFuDq18QIV76noyAon/Zprch96dKc6Lu4ezE4KUwURNQ9v+yNFy8Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Vtyh7fqg; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-22a1e72f683so319323fac.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 18:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711588689; x=1712193489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kQMAIZMHZqaonB1lOMUnjQXssTBiYQNYsZMxgebLgFk=;
        b=Vtyh7fqgso+UBCeTCa0dVAtQdpZRe5yPJdvXcYy4XfiV3vbP4YMkI3p5/yy3Y8BsTf
         qbsp+3UaGQAsNlXXbE/pIo1XuYOZHWK9RKBqo+nzmypHrV8lQXS5WNXA4kaphKXhSwPk
         refIzbRVEbNXbDZty5nZruYq+gygPoQCHJkMTR5eC6MhFcDoHOmj2VGppaQI+W0jhUlD
         OKDEzbRo5UFYd4wH/co07Y4ff3uT59h2osb0QA5D2d1RcpcFx7NUFoqOvppxn47i+gFc
         HugX+wLQxvE7zqk7wnj/AjExKXygKXW5bsdFjDU/mS4YIgRCDsTcQ6JFnvhHA4ZXOSRN
         Kymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711588689; x=1712193489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQMAIZMHZqaonB1lOMUnjQXssTBiYQNYsZMxgebLgFk=;
        b=W15eelQ01a0atW+WrPBhRUTETGDiypfW9xc8iIdUMfzQXie28dfSl+lqL/bVAHslW6
         bY19pgH5YR9eg+Pqc9THp7qLLEpnauZfsHzqYxLpAp8qdslKo35iU5IcNSrAG1bfUzsv
         WFobq9luIKUdS5OwuU+i+cffiNOkqwWzJRer2u4Ujv4rrtSoSfdHkn4pJamlju+3JDdx
         2fJn/Cu8T6APDSN9py4duOVtoeHnqtF5q/IOcdij3zOlfHGNLxxyJQGq0cuXOigkFy0L
         zmcEultEXhny3yG/sQOsWEdJzP9vPET5tzzkEiB+2tAitJhzzJNMoNObDXJ3gMKmnPuS
         dh1A==
X-Forwarded-Encrypted: i=1; AJvYcCV2lvTPv2qkG+m0E8IGL6dvWMqoQlHfeVUMGOj9j+yVWDv8ZpWtfwA7QO6YcuvCpyho1uZpwv4zY75Bwi8r6XRmHkaYprrMaSQ=
X-Gm-Message-State: AOJu0YzMVQmKPVWHMy5pdct/fj5xbjlih7FOjMLux89yDaUrrM8iR9IA
	Hq9ugTdOSsnbvBeDrEh7kXQ70/g665aY0EgD8CyyQqKtpkCdFA7vvQG9i5En8qI=
X-Google-Smtp-Source: AGHT+IHTpl6mAgSW8fTIBP+dUOM/ztz/r3gQFb/Ak+WqdhL4b1U/MHR2aFECzdEFf6RizwVZxr3V6Q==
X-Received: by 2002:a05:6870:b523:b0:22a:97bf:366 with SMTP id v35-20020a056870b52300b0022a97bf0366mr1559595oap.13.1711588689213;
        Wed, 27 Mar 2024 18:18:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id g18-20020aa78192000000b006e7324d32bbsm174549pfi.122.2024.03.27.18.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 18:18:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rpeP8-00CXAI-04;
	Thu, 28 Mar 2024 12:18:06 +1100
Date: Thu, 28 Mar 2024 12:18:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <ZgTFTu8byn0fg9Ld@dread.disaster.area>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327-begibt-wacht-b9b9f4d1145a@brauner>

On Wed, Mar 27, 2024 at 05:45:09PM +0100, Christian Brauner wrote:
> There's a bunch of flags that are purely based on what the file
> operations support while also never being conditionally set or unset.
> IOW, they're not subject to change for individual file opens. Imho, such
> flags don't need to live in f_mode they might as well live in the fops
> structs itself. And the fops struct already has that lonely
> mmap_supported_flags member. We might as well turn that into a generic
> fops_flags member and move a few flags from FMODE_* space into FOP_*
> space. That gets us four FMODE_* bits back and the ability for new
> static flags that are about file ops to not have to live in FMODE_*
> space but in their own FOP_* space. It's not the most beautiful thing
> ever but it gets the job done. Yes, there'll be an additional pointer
> chase but hopefully that won't matter for these flags.
> 
> If this is palatable I suspect there's a few more we can move into there
> and that we can also redirect new flag suggestions that follow this
> pattern into the fops_flags field instead of f_mode. As of yet untested.
> 
> (Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fops_flags as
>  well because they're also completely static but they aren't really
>  about file operations so they're better suited for FMODE_* imho.)
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>
.....
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 632653e00906..d13e21eb9a3c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1230,8 +1230,7 @@ xfs_file_open(
>  {
>  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
>  		return -EIO;
> -	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
> -			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
> +	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
>  	return generic_file_open(inode, file);
>  }
>  
> @@ -1490,7 +1489,6 @@ const struct file_operations xfs_file_operations = {
>  	.compat_ioctl	= xfs_file_compat_ioctl,
>  #endif
>  	.mmap		= xfs_file_mmap,
> -	.mmap_supported_flags = MAP_SYNC,
>  	.open		= xfs_file_open,
>  	.release	= xfs_file_release,
>  	.fsync		= xfs_file_fsync,
> @@ -1498,6 +1496,8 @@ const struct file_operations xfs_file_operations = {
>  	.fallocate	= xfs_file_fallocate,
>  	.fadvise	= xfs_file_fadvise,
>  	.remap_file_range = xfs_file_remap_range,
> +	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
> +			  FOP_DIO_PARALLEL_WRITE,
>  };
>  
>  const struct file_operations xfs_dir_file_operations = {
> @@ -1510,4 +1510,6 @@ const struct file_operations xfs_dir_file_operations = {
>  	.compat_ioctl	= xfs_file_compat_ioctl,
>  #endif
>  	.fsync		= xfs_dir_fsync,
> +	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
> +			  FOP_DIO_PARALLEL_WRITE,
>  };

Why do we need to set any of these for directory operations now that
we have a clear choice? i.e. we can't mmap directories, and the rest
of these flags are for read() and write() operations which we also
can't do on directories...

....

> @@ -1024,7 +1024,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>  
>  		/* File path supports NOWAIT for non-direct_IO only for block devices. */
>  		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
> -			!(kiocb->ki_filp->f_mode & FMODE_BUF_WASYNC) &&
> +			!fops_buf_wasync(kiocb->ki_filp) &&
>  			(req->flags & REQ_F_ISREG))
>  			goto copy_iov;

You should probably also fix that comment - WASYNC is set when the
filesystem supports NOWAIT for buffered writes.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

