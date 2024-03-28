Return-Path: <io-uring+bounces-1281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB1E88FBC6
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 10:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BAE71C28911
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 09:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAD756441;
	Thu, 28 Mar 2024 09:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fx3LWnEF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D4753E3B;
	Thu, 28 Mar 2024 09:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711618829; cv=none; b=Ta0jTAEZrzqhOeJqynEmInsLxPmwKTERqcx4WltGo/W2vd9AcNdLmHztlL82CH6Yy7/NCWX1WCki6jO9nZsydPIaGotliYa1uQE3xpGknr89ou+IXi+9WQgNk6wMOhoBkLMWPPDN0j3s8n7tyONA/TEyCCdyaOtpnzC6X6MfWEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711618829; c=relaxed/simple;
	bh=BwM7hmAoGHKDtsYXvAWErwT0H5qUuXX596xj5qdXHz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/0I0QndGRmJQh4owZy7XrI+qJgDNYP2+dJYN52ptLhn+iy+b9utkAenAfrMZ2eTWChwABbxp7Zle3QiHF3DxU7BvLULjmCMH72KUyT6TNObAiqyAHH6haycuv4pBwomTKXrPbinBEJ/o445aDlg+AyQOoWQyYxIMLUkzWDIVhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fx3LWnEF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344DBC433F1;
	Thu, 28 Mar 2024 09:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711618828;
	bh=BwM7hmAoGHKDtsYXvAWErwT0H5qUuXX596xj5qdXHz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fx3LWnEFs+Ut2Bx/vC23d78Urb1LMXXPcWpiolMQm1uuejKC5g8mtZf0D1NdqTSHg
	 /c+QjYG4fREYgd4RvvIWUv/DulPYzAjGoZEKlUQ75hHec9r/dmTOKLzxFRP0tBUe+r
	 Nn8SvKW4yqkCSzjWzPsT38B9Wsuv/DZB/ChVzXaTFKpiFDWpoLrLTKnH4z/1/bMlbV
	 b3TsmJ2XhUSAs7hM/TTCaUnOHj7mDiFeepQzcTh+7Eo2x4OcHMS9SPFoEYlpsNNE3B
	 Dh78qIc7cS53mYr+7idFF8ce9i0tEUVM2vpurhE6cjWns90Sjs1s1ZSYtxhDQmtnva
	 7WCr5TNByspng==
Date: Thu, 28 Mar 2024 10:40:24 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH] [RFC]: fs: claw back a few FMODE_* bits
Message-ID: <20240328-ritualisieren-darum-9e500adaeaab@brauner>
References: <20240327-begibt-wacht-b9b9f4d1145a@brauner>
 <e6a61c54-6b8d-45e0-add3-3bb645466cbf@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e6a61c54-6b8d-45e0-add3-3bb645466cbf@kernel.dk>

On Wed, Mar 27, 2024 at 11:19:06AM -0600, Jens Axboe wrote:
> On 3/27/24 10:45 AM, Christian Brauner wrote:
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
> 
> Not doing that extra dereference is kind of the point of the FMODE_*
> flags, at least the ones that I care about. Probably not a huge deal for
> these cases though, as we're generally going to call one of the f_op
> handlers shortly anyway. The cases where we don't, at least for
> io_uring, we already cache the state separately.
> 
> Hence more of a general observation than an objection to the patch. I do
> like freeing up FMODE space, as it's (pretty) full.

Yes, I'm actuely aware that for some flags having them FMODE_* bits
might be performance sensitive. Moving FMODE_PATH would probably be very
noticeable due to it's use in __fget_files_rcu() and there might be
other cases like FMODE_NOWAIT and so on.

So I was delibaretely moving flags that really remain static and that
are unlikely to be in a hot path. And we certainly need to be careful
about this.

I think in the long-run it can bring us benefits for new flag proposals
that we wouldn't be willing to accept if they had to live in FMODE_*
space. Either because they're a one-off (the MAP_SYNC flag comes to
mind) or because they're not performance sensitive and of course only if
they're static.

We should still push back on unnecessary FMODE_* bit additions but we
may be able to be a little less stingy with FOP_* bits for a bit.

