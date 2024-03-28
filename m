Return-Path: <io-uring+bounces-1278-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCA388F9B4
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 09:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3E021F30225
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 08:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033AC53E05;
	Thu, 28 Mar 2024 08:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+Nx6q2O"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C616653805;
	Thu, 28 Mar 2024 08:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711613208; cv=none; b=QR9g65D+f68q/ONEjRbL8noDa0zuxpZliUvgPVdP9mdg2sNVToe9CPWWLW3KGhEAWWu4C/uGrO1q7VQRFn3DJ92JodBXrpsUoyp1jYp+qFjskdk2SJZudud4UScXBCOSInnSBwlzIEowz1vj+gqInY8eIai7GjL2Nk4I6e5N//A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711613208; c=relaxed/simple;
	bh=8ifH77V237YZfCRSTfO+Mw1b/oRyHxNocR6fQC5VdBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7Qc/OOc3QC9qshIbgsQCgEwYUpNACPrW2k2mx9Tt6qvL+XDWTsU5lRb5cgFOfVxLGhmHyjtmmT4Kh/lGbBsUNCQ5iGOtzNxISN1XA+Ec9mg0xfgF1eEXaDE1SRowgwXeKQwGLy3AwRwtQFyIvLh08IHKhLto4ALjLXCA7v/KzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+Nx6q2O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E70C433C7;
	Thu, 28 Mar 2024 08:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711613208;
	bh=8ifH77V237YZfCRSTfO+Mw1b/oRyHxNocR6fQC5VdBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+Nx6q2OYUokfxjffE/pshRTHA/t6v90rzAo9tsvumPGMqbO3nEJryOBajsoUXZr3
	 VTscRvcJh8WKxLgeFfBWCxWmWqVMkZqtcnzhxe6occimXWvS52WzRZn+iOAQLdwyuD
	 zxZlJCsK6iAmCxKEsvvDmf9ObjZv4yoP2lKFHzFcm5iDOZV/y1RNju9D5dIGdyiNnK
	 FJ4GeWAFnDrjMp7n0lrMq3UXzNIj28MLOwVO+Yp2RLVwaUx2AeK5/lVgevm8LGj3kW
	 Y2XHeklVQEFtzCiBM1u0tasBXq6ZXaPBTTaCKxPjEHvFSUKpctpEhA9z3ou14vJ9DH
	 tk8ZEkOvffdSA==
Date: Thu, 28 Mar 2024 09:06:43 +0100
From: Christian Brauner <brauner@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <20240328-palladium-getappt-ce6ae1dc17aa@brauner>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
 <ZgTFTu8byn0fg9Ld@dread.disaster.area>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgTFTu8byn0fg9Ld@dread.disaster.area>

On Thu, Mar 28, 2024 at 12:18:06PM +1100, Dave Chinner wrote:
> On Wed, Mar 27, 2024 at 05:45:09PM +0100, Christian Brauner wrote:
> > There's a bunch of flags that are purely based on what the file
> > operations support while also never being conditionally set or unset.
> > IOW, they're not subject to change for individual file opens. Imho, such
> > flags don't need to live in f_mode they might as well live in the fops
> > structs itself. And the fops struct already has that lonely
> > mmap_supported_flags member. We might as well turn that into a generic
> > fops_flags member and move a few flags from FMODE_* space into FOP_*
> > space. That gets us four FMODE_* bits back and the ability for new
> > static flags that are about file ops to not have to live in FMODE_*
> > space but in their own FOP_* space. It's not the most beautiful thing
> > ever but it gets the job done. Yes, there'll be an additional pointer
> > chase but hopefully that won't matter for these flags.
> > 
> > If this is palatable I suspect there's a few more we can move into there
> > and that we can also redirect new flag suggestions that follow this
> > pattern into the fops_flags field instead of f_mode. As of yet untested.
> > 
> > (Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fops_flags as
> >  well because they're also completely static but they aren't really
> >  about file operations so they're better suited for FMODE_* imho.)
> > 
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> .....
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 632653e00906..d13e21eb9a3c 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1230,8 +1230,7 @@ xfs_file_open(
> >  {
> >  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
> >  		return -EIO;
> > -	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
> > -			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
> > +	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
> >  	return generic_file_open(inode, file);
> >  }
> >  
> > @@ -1490,7 +1489,6 @@ const struct file_operations xfs_file_operations = {
> >  	.compat_ioctl	= xfs_file_compat_ioctl,
> >  #endif
> >  	.mmap		= xfs_file_mmap,
> > -	.mmap_supported_flags = MAP_SYNC,
> >  	.open		= xfs_file_open,
> >  	.release	= xfs_file_release,
> >  	.fsync		= xfs_file_fsync,
> > @@ -1498,6 +1496,8 @@ const struct file_operations xfs_file_operations = {
> >  	.fallocate	= xfs_file_fallocate,
> >  	.fadvise	= xfs_file_fadvise,
> >  	.remap_file_range = xfs_file_remap_range,
> > +	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
> > +			  FOP_DIO_PARALLEL_WRITE,
> >  };
> >  
> >  const struct file_operations xfs_dir_file_operations = {
> > @@ -1510,4 +1510,6 @@ const struct file_operations xfs_dir_file_operations = {
> >  	.compat_ioctl	= xfs_file_compat_ioctl,
> >  #endif
> >  	.fsync		= xfs_dir_fsync,
> > +	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
> > +			  FOP_DIO_PARALLEL_WRITE,
> >  };
> 
> Why do we need to set any of these for directory operations now that
> we have a clear choice? i.e. we can't mmap directories, and the rest
> of these flags are for read() and write() operations which we also
> can't do on directories...

Yeah, I know but since your current implementation raises them for both
I just did it 1:1:

STATIC int
xfs_file_open(
        struct inode    *inode,
        struct file     *file)
{
        if (xfs_is_shutdown(XFS_M(inode->i_sb)))
                return -EIO;
        file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
                        FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
        return generic_file_open(inode, file);
}

STATIC int
xfs_dir_open(
        struct inode    *inode,
        struct file     *file)
{
        struct xfs_inode *ip = XFS_I(inode);
        unsigned int    mode;
        int             error;

        error = xfs_file_open(inode, file);
        if (error)
                return error;

	<snip>
}

> 
> ....
> 
> > @@ -1024,7 +1024,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
> >  
> >  		/* File path supports NOWAIT for non-direct_IO only for block devices. */
> >  		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
> > -			!(kiocb->ki_filp->f_mode & FMODE_BUF_WASYNC) &&
> > +			!fops_buf_wasync(kiocb->ki_filp) &&
> >  			(req->flags & REQ_F_ISREG))
> >  			goto copy_iov;
> 
> You should probably also fix that comment - WASYNC is set when the
> filesystem supports NOWAIT for buffered writes.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

