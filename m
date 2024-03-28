Return-Path: <io-uring+bounces-1280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A86EF88FB75
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 10:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 624AF29059F
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 09:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAF12AD1C;
	Thu, 28 Mar 2024 09:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQdAe7/9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2859134CB;
	Thu, 28 Mar 2024 09:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711618151; cv=none; b=FhqZM3cKijceTTQcC1Gl6k1MlUUwfTNKjLeEwnCRGH1PMBd68d3A3zXFuXc/IUFE1+AoPWvaNVKjI/njiutapQgx0S7z0N5j1rjalAGklYAnmGUbLAJ5gkX6PbhX/UE6WEeU/acFfzuBIAXqR5hlN2Xamz0y5Fi/eJIcE//IPuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711618151; c=relaxed/simple;
	bh=tstE2NqDI/Vxx8vKqwGujaCnsTcUFYCwuYFiwCeEh80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PZHZoYFd2nNFXhCK8ORMcfMpGzr8AUIb8tEXS2jtepRxPkSmPduhA3N5hgspqp0Z9i1o0HBWZoIx5/tH3EgnBFQuCR272ntQ7tWPYmkLHhVpQS12JcMtSEAltuomwUBo8kLH9jXo1iNEby2WWZYNICMTfvqIb+pY5oOUycmPZaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQdAe7/9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F299C433C7;
	Thu, 28 Mar 2024 09:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711618150;
	bh=tstE2NqDI/Vxx8vKqwGujaCnsTcUFYCwuYFiwCeEh80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lQdAe7/9OTPRUEXx9tJyaK3wl7bOG731jfQ8dFD2himK+zeu0+b3pm/8cXccy105v
	 NcdFWciUVF4To/OiARHyaZzUy9Lb1vyprymg/PqTVgSMXJ8Z/l3RGlHFERBf/Ir2AC
	 NYpctZtHA4sRzYyiOEbZgjC0lxfqnzzINW0Y+eWKYdy/w2VbP6uriMDcx4SpTpkYtA
	 DCB4UOOrAIjGow0W0/FUl2SJ4UfFNOTs8HpiiOtI///CBL2YcZS/P2jE+OMAFG4M0x
	 KBrtKM7O+af/Xm5S/Dd1RUc3TB7hpiPL8LMS6dXijEwwneS7h27PXOXf3DJwc3R5jv
	 ebuZoTNVEEHvw==
Date: Thu, 28 Mar 2024 10:29:06 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <20240328-begriffen-entgleisen-2e89b8d52667@brauner>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
 <20240328053533.GA15831@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240328053533.GA15831@lst.de>

On Thu, Mar 28, 2024 at 06:35:33AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 27, 2024 at 05:45:09PM +0100, Christian Brauner wrote:
> > There's a bunch of flags that are purely based on what the file
> > operations support while also never being conditionally set or unset.
> > IOW, they're not subject to change for individual file opens. Imho, such
> > flags don't need to live in f_mode they might as well live in the fops
> > structs itself.
> 
> Yes.  I actually have a half-finished patch doing the same lying around,
> which I've not found time to rabse.
> 
> > (Fwiw, FMODE_NOACCOUNT and FMODE_BACKING could live in fops_flags as
> >  well because they're also completely static but they aren't really
> >  about file operations so they're better suited for FMODE_* imho.)
> 
> I'd still move them there.  I've also simply called fops_flags flags
> so maybe it didn't bother me too much :)

Possible that we can do that as well but I'd keep calling it fop_flags
for the sake of grepping. If you git grep \\.fop_flags you get a nice
unique match and you get an overview who uses what. I'm not married to
this but I'll keep it for now.

> 
> > +/* File ops support async buffered reads */
> > +#define FOP_BUF_RASYNC		BIT(0)
> > +/* File ops support async nowait buffered writes */
> > +#define FOP_BUF_WASYNC		BIT(1)
> 
> Can we spell out BUFFERED here when changing things?  BUF always confuses
> me as it let's me thing of the buffer cache.

Ok.

> 
> And can be please avoid this silly BIT() junk?  1u << N is shorter
> and a lot more obvious than this random macro.

Everyone and their grandmother has an opinion on this hex, <<, BIT(). :)
Fine, I don't care enough and my grandmothers aren't around anymore.

> 
> > +#define FOP_MMAP_SYNC		BIT(2)
> 
> Please throw in a comment for this one while you're at it.

Ok.

> 
> > +/* File ops support non-exclusive O_DIRECT writes from multiple threads */
> > +#define FOP_DIO_PARALLEL_WRITE	BIT(3)
> > +
> > +#define __fops_supported(f_op, flag) ((f_op)->fops_flags & (flag))
> > +#define fops_buf_rasync(file) __fops_supported((file)->f_op, FOP_BUF_RASYNC)
> > +#define fops_buf_wasync(file) __fops_supported((file)->f_op, FOP_BUF_WASYNC)
> > +#define fops_mmap_sync(file) __fops_supported((file)->f_op, FOP_MMAP_SYNC)
> > +#define fops_dio_parallel_write(file) __fops_supported((file)->f_op, FOP_DIO_PARALLEL_WRITE)
> 
> And please drop these helpers.  They just make grepping for the flags
> a complete pain.

Ok.

