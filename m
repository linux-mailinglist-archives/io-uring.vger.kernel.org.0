Return-Path: <io-uring+bounces-1359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37351894791
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 01:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61048283710
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 23:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B7E56B65;
	Mon,  1 Apr 2024 23:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dn9DP0MM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC5856B64
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 23:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712013405; cv=none; b=uOCgkokhSAWBaD0Tv/31qFKR11jYnHgY1oncqG4xftX7/AkZBxhgVL5+Fm1BRMV+PNQxnbUjrf7RqW5r0F5zjgTUtaBeVxhQ+TqnrnWAl3wZcTZVl9DFcSMLPRPviLbzSq1UzazVzZk2+ydng4KvYoeeE4upg4NU8VSlA1elmC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712013405; c=relaxed/simple;
	bh=osncRN4tYxLbtZld8h+GbrFPLrEK0+/3LpZNNGr0blY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGIlmeiF5a4sFFGVYzOzfNwmLcDNmZsQ4WzTO/bqN0dy5ZAoyb1SRgbctFhRr2gaiok1U+qHp22cg07DO6CF6ooPy0tIEB3M29TEMxvWm5mbqpPPDMWWEyH2yUzk+CAMojeUs2+8oQAhsAtUN1UlUla6ifHoIAZOd056VFvh4qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dn9DP0MM; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e6ee9e3cffso3065155b3a.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 16:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712013403; x=1712618203; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CDR3Aa6NUHOENbTkzMz3q62+qrOtn48rborVlPPdVvo=;
        b=dn9DP0MMHIZJHXn/6Ykw2rjQbX+PnwKUF3eLqBi6ahkYJNZaG6AGtaljTQSGxXecHO
         zieVZJeRGZuQdQo0h688K1B4IW3SClO68ddVnHBex6qH2BarArNDAn/JfO4rI39AMbP4
         hQHn5F9l+Xbw26VmpafMVU7+6885igxXvLIb6gx2tLNyahN1cS1xMTDC/2R6Z3H7evCM
         jciKL3DLkmPnEzgVclGI0D/7xGifZo35Zu/lLA1NegkjO4zc7rol1kVqnEqRyFQRDdUl
         1UkQXEiTNx9Ob7MJsrZ9dW3zIFYS+oG/7D46q90P07awbJF/UTYzVqGzC8Zgm44hjzaz
         rPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712013403; x=1712618203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDR3Aa6NUHOENbTkzMz3q62+qrOtn48rborVlPPdVvo=;
        b=E3FC/yRq0AM0QGWQSHJ3qP9c3JTYrqiLD9SqucasWwwKbq4tMLJQ5kmBrza/oqVC+G
         +nd69C5D/uP0PWKIMPTcGTya5LNVXNMp49M3feTnTzj1ZjCvI65l1Xl5mxCxYSQiqkSI
         XUYP+5etqXG+yNesb4vWTuEcCckKzRZfvoz5ttQO+Ds2nD7xuCPnborO2cw+sqxFLDYO
         CkVn8A7QUP+7h4D36dmGt/lB2jbQo9yPlbcmudRe55tfOWjGJUqOvUxtijwgBBrzz6M8
         YO5Q1kckNhVqzFJZXfVn7DlQhmoUjiOE/JKsXADhsUp24EBTE0yeP0IUXGZUtCw22OND
         K1CQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhIf4FXYVniBSKyFqIjfGDqfX9jA2aqfEOpLlB3abXNO0TBFH1tBWBkMpJSnWXq3XtNeMD+zmiddF7RWJpHBVXsuhv3YU96kc=
X-Gm-Message-State: AOJu0Yw46zg4okVhzlwCRC8pVeSkgFb7dBUpesADYDJbJjvE4ZVsVm8v
	6PFiGZ25FuBIY59NTTqRkae1Tft5WvjLKr4sup4mgzQzu9onBink1rD6odaDfMdby/oUL0LO4ou
	9
X-Google-Smtp-Source: AGHT+IFv7uLsBupB0FVHVsfk7Y0obiDQr8sOK/Rv3+BpUdWvZ5/xKo5wDkQoV7rrXq6Euk5mRu3djQ==
X-Received: by 2002:a05:6a00:1411:b0:6eb:3b8c:8ea5 with SMTP id l17-20020a056a00141100b006eb3b8c8ea5mr6407820pfu.15.1712013402568;
        Mon, 01 Apr 2024 16:16:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id v17-20020aa78091000000b006e6a684a6ddsm8428590pff.220.2024.04.01.16.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 16:16:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrQtL-000hKj-2J;
	Tue, 02 Apr 2024 10:16:39 +1100
Date: Tue, 2 Apr 2024 10:16:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <ZgtAVz+oI4WYUxDE@dread.disaster.area>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
 <ZgTFTu8byn0fg9Ld@dread.disaster.area>
 <20240328-palladium-getappt-ce6ae1dc17aa@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328-palladium-getappt-ce6ae1dc17aa@brauner>

On Thu, Mar 28, 2024 at 09:06:43AM +0100, Christian Brauner wrote:
> On Thu, Mar 28, 2024 at 12:18:06PM +1100, Dave Chinner wrote:
> > On Wed, Mar 27, 2024 at 05:45:09PM +0100, Christian Brauner wrote:
> > > There's a bunch of flags that are purely based on what the file
> > > operations support while also never being conditionally set or unset.
> > > IOW, they're not subject to change for individual file opens. Imho, such
> > > flags don't need to live in f_mode they might as well live in the fops
> > > structs itself. And the fops struct already has that lonely
> > > mmap_supported_flags member. We might as well turn that into a generic
> > > fops_flags member and move a few flags from FMODE_* space into FOP_*
> > > space. That gets us four FMODE_* bits back and the ability for new
> > > static flags that are about file ops to not have to live in FMODE_*
> > > space but in their own FOP_* space. It's not the most beautiful thing
> > > ever but it gets the job done. Yes, there'll be an additional pointer
> > > chase but hopefully that won't matter for these flags.
> > > 
> > > If this is palatable I suspect there's a few more we can move into there
> > > and that we can also redirect new flag suggestions that follow this
> > > pattern into the fops_flags field instead of f_mode. As of yet untested.
> > > 
> > > (Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fops_flags as
> > >  well because they're also completely static but they aren't really
> > >  about file operations so they're better suited for FMODE_* imho.)
> > > 
> > > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > .....
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 632653e00906..d13e21eb9a3c 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -1230,8 +1230,7 @@ xfs_file_open(
> > >  {
> > >  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
> > >  		return -EIO;
> > > -	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
> > > -			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
> > > +	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
> > >  	return generic_file_open(inode, file);
> > >  }
> > >  
> > > @@ -1490,7 +1489,6 @@ const struct file_operations xfs_file_operations = {
> > >  	.compat_ioctl	= xfs_file_compat_ioctl,
> > >  #endif
> > >  	.mmap		= xfs_file_mmap,
> > > -	.mmap_supported_flags = MAP_SYNC,
> > >  	.open		= xfs_file_open,
> > >  	.release	= xfs_file_release,
> > >  	.fsync		= xfs_file_fsync,
> > > @@ -1498,6 +1496,8 @@ const struct file_operations xfs_file_operations = {
> > >  	.fallocate	= xfs_file_fallocate,
> > >  	.fadvise	= xfs_file_fadvise,
> > >  	.remap_file_range = xfs_file_remap_range,
> > > +	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
> > > +			  FOP_DIO_PARALLEL_WRITE,
> > >  };
> > >  
> > >  const struct file_operations xfs_dir_file_operations = {
> > > @@ -1510,4 +1510,6 @@ const struct file_operations xfs_dir_file_operations = {
> > >  	.compat_ioctl	= xfs_file_compat_ioctl,
> > >  #endif
> > >  	.fsync		= xfs_dir_fsync,
> > > +	.fops_flags	= FOP_MMAP_SYNC | FOP_BUF_RASYNC | FOP_BUF_WASYNC |
> > > +			  FOP_DIO_PARALLEL_WRITE,
> > >  };
> > 
> > Why do we need to set any of these for directory operations now that
> > we have a clear choice? i.e. we can't mmap directories, and the rest
> > of these flags are for read() and write() operations which we also
> > can't do on directories...
> 
> Yeah, I know but since your current implementation raises them for both
> I just did it 1:1:

Sure, that's fine. I asked the question because your patch made the
issue obvious, regardless of the current state of the code.

i.e. a patch adding a flag to xfs_file_open() (e.g.  adding
FMODE_DIO_PARALLEL_WRITE had nothing to do with XFS) does not touch
xfs_dir_open() and so it is not immediately clear from the diff that
it also affects directories as well. So it's not until someone
actually notices that flags only relevant to regular files are being
set on directories that someone comments and it becomes clear we
need to fix this...

As Christoph said, it doesn't need to be fixed in this patch, but we
should address this properly. The next question is this: how many
other filesystem implementations do the same thing?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

