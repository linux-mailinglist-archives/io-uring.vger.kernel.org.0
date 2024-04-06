Return-Path: <io-uring+bounces-1423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED35C89A93E
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 08:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C5681C20E97
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 06:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD90200DE;
	Sat,  6 Apr 2024 06:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="bA/MrIl1"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3592901;
	Sat,  6 Apr 2024 06:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712383808; cv=none; b=sPv2JB3JeiFkBHxbT1S2NswdckLMtXPZCQGeykgI5z6k8mGqW9pxnHWOCZ3yhTunw+Vg/80VQYsUDc7hJEt66DknMDGgJvxJK1+zJuVZWS381dwXDvDUkVwVZLmdBpUJHsKxitwKeSUJEjdr6lNNNV3CFU9g5t0UbC6zMl+xH/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712383808; c=relaxed/simple;
	bh=LrjggOAkQqv1jjeTeYa3eXtR4W2xHCz30uyzsxXJzrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYz33/FPVNjj6wZaE6yEOe3vkFkCKMbo8uhmI2AaEys7un8SswyT7s0H6RvA5g+HQ2CwqsmciKif/3JLNHPcL2jv1+NJdToHmE71lQd5oa43q+BIm1jZnhslx3PECA+p6m+cCedFZzRTnSpKSPcSKguyb/uphLMnBcZLsU9hjs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=bA/MrIl1; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3nFbYDYnTI1H3VdPaJvKNd8Ntp5Zmcp9s5TsVT6v3F8=; b=bA/MrIl1lUVfUJ1RdLfXIejrJI
	c3VPD9+mApkhC8GfGS8SNKII6nbvYnQr2QKpbO+8HdaipqTLJT67iimEWlfgOfq/nYOb9g5pPj6v8
	6G4bbzx8zX8p0guxqrsq7sMXuiu0YPVMOsKpad2afM5rnbjg7Oa4bbRtM4sn1niugZVa4o6dU9yq2
	PxLKKFQ3/LYHQrxfE0yjg0PgQle4VaPlEdfyqTFhZAkYvkxpFrXFxbdo0YpADtIjAPzlGouUWYBW2
	/ww6iPWe9ItIXsAbnu+I/jYnii1Zg6TFn1ZEVPC8ggygmfLY1ghTXFFUK3vFb7Yn435U3ALK3ZDQ8
	6kmwuUjg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rszFa-006vzB-24;
	Sat, 06 Apr 2024 06:10:02 +0000
Date: Sat, 6 Apr 2024 07:10:02 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] fs: claw back a few FMODE_* bits
Message-ID: <20240406061002.GZ538574@ZenIV>
References: <20240328-gewendet-spargel-aa60a030ef74@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328-gewendet-spargel-aa60a030ef74@brauner>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Mar 28, 2024 at 01:27:24PM +0100, Christian Brauner wrote:
> There's a bunch of flags that are purely based on what the file
> operations support while also never being conditionally set or unset.
> IOW, they're not subject to change for individual files. Imho, such
> flags don't need to live in f_mode they might as well live in the fops
> structs itself. And the fops struct already has that lonely
> mmap_supported_flags member. We might as well turn that into a generic
> fop_flags member and move a few flags from FMODE_* space into FOP_*
> space. That gets us four FMODE_* bits back and the ability for new
> static flags that are about file ops to not have to live in FMODE_*
> space but in their own FOP_* space. It's not the most beautiful thing
> ever but it gets the job done. Yes, there'll be an additional pointer
> chase but hopefully that won't matter for these flags.
> 
> I suspect there's a few more we can move into there and that we can also
> redirect a bunch of new flag suggestions that follow this pattern into
> the fop_flags field instead of f_mode.

Looks sane; one suggestion, though - if we are going to try and free
bits, etc., it might be a good idea to use e.g.
#define FMODE_NOACCOUNT         ((__force fmode_t)BIT(29))
instead of hex constants.  IME it's easier to keep track of, especially
if we have comments between the definitions.

