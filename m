Return-Path: <io-uring+bounces-3441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 819509938F9
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 23:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CF59B22B21
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 21:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060BE1DE88C;
	Mon,  7 Oct 2024 21:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="RWZQrQQ2"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C41DE4D8;
	Mon,  7 Oct 2024 21:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728336038; cv=none; b=CTnfjcm9KJguxMiZbUgTntADIdZy6f5U2wd/VMNLimFAQP2FZflM6UR1Pd0S0UpBz92DLVJu5kpC1bpcpTZsKDS8tcfPjyI98sx8Iy6G+ndAeev27MonGXb9xzWQ3OdmERoNqaw92j7LXlNH9r9480WMB2biTU9IoouGcCM5+yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728336038; c=relaxed/simple;
	bh=ulNGmKR8IkHpaEiA1Q2QHKLKsymcXQYlhS3FBAr4qB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDndpmrgRGmFGzRQ7sPAp2VGpC3YejJfPTv3i1RwUbqYSrRITIKRj7GzviSu+Pw4hpO9MIJSks4RXflrb9IrRoGhHs+IfCV6+1PF2X66WFfRXse3Xh1HRPYbCS5wZ/ubBl0+AfNWe7bAYFhv1b7vJFKcXN4hiKqG+8mfmdxrpUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=RWZQrQQ2; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pQ1ColmBObMTnYdunZ9Y+88wedLoBDEP4jQTW7uiuI4=; b=RWZQrQQ2qdIRVcfj3AMv+lNoP0
	/2v/oLw5NJBJmucOrSlhk2TYI3NhT89RcTIORQpbF1ZrCYI4nXBB0A8gh5XbyqOqdqbxpym6oyXIW
	P0QUStC7+IPcWOwtr04jK2TZxccC8R4BF/pIgC2MQ7o1S2MLNASIYyDgipQU0O8kHlHTrBfTXBSu5
	DZjqorYQvxBJBtjV9SwhkRaDM1XvEG7Mjd24e1u5d+NokSXga3EYkCnPv6TppDG/Wo3FLWSz3iWcx
	5Y6ZkpWcEm4YD97+bS/Q0MD6Ktd879ZpIxhMf/nXKylKyBD9tKR+ovbC2CU/lhyRJfaO03I5lA559
	eKcY+Oag==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sxv9e-00000001hfl-0W46;
	Mon, 07 Oct 2024 21:20:34 +0000
Date: Mon, 7 Oct 2024 22:20:34 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	io-uring@vger.kernel.org, cgzones@googlemail.com
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
Message-ID: <20241007212034.GS4017910@ZenIV>
References: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
 <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
 <20241002211939.GE4017910@ZenIV>
 <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
 <20241006052859.GD4017910@ZenIV>
 <69e696d7-637a-4cb2-912c-6066d23afd72@kernel.dk>
 <965e59b5-615a-4d20-bb04-a462c33ad84b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <965e59b5-615a-4d20-bb04-a462c33ad84b@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Oct 07, 2024 at 12:20:20PM -0600, Jens Axboe wrote:
> On 10/7/24 12:09 PM, Jens Axboe wrote:
> >>>> Questions on the io_uring side:
> >>>> 	* you usually reject REQ_F_FIXED_FILE for ...at() at ->prep() time.
> >>>> Fine, but... what's the point of doing that in IORING_OP_FGETXATTR case?
> >>>> Or IORING_OP_GETXATTR, for that matter, since you pass AT_FDCWD anyway...
> >>>> Am I missing something subtle here?
> >>>
> >>> Right, it could be allowed for fgetxattr on the io_uring side. Anything
> >>> that passes in a struct file would be fair game to enable it on.
> >>> Anything that passes in a path (eg a non-fd value), it obviously
> >>> wouldn't make sense anyway.
> >>
> >> OK, done and force-pushed into #work.xattr.
> > 
> > I just checked, and while I think this is fine to do for the 'fd' taking
> > {s,g}etxattr, I don't think the path taking ones should allow
> > IOSQE_FIXED_FILE being set. It's nonsensical, as they don't take a file
> > descriptor. So I'd prefer if we kept it to just the f* variants. I can
> > just make this tweak in my io_uring 6.12 branch and get it upstream this
> > week, that'll take it out of your hands.
> > 
> > What do you think?
> 
> Like the below. You can update yours if you want, or I can shove this
> into 6.12, whatever is the easiest for you.

Can I put your s-o-b on that, with e.g.

io_uring: IORING_OP_F[GS]ETXATTR is fine with REQ_F_FIXED_FILE

Rejection of IOSQE_FIXED_FILE combined with IORING_OP_[GS]ETXATTR
is fine - these do not take a file descriptor, so such combination
makes no sense.  The checks are misplaced, though - as it is, they
triggers on IORING_OP_F[GS]ETXATTR as well, and those do take 
a file reference, no matter the origin. 

as commit message?

