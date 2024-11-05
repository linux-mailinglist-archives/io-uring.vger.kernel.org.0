Return-Path: <io-uring+bounces-4461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B52B09BD238
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 17:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E614C1C22647
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 16:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D615C1D2232;
	Tue,  5 Nov 2024 16:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0lbXYQi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B02225D7;
	Tue,  5 Nov 2024 16:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823803; cv=none; b=B8+9y4AmJ40HxC5KNN4q4iHJUEJXjB9oFiQV+Ub2Ki7+L7FXhe5X4rDIkkg5i5BkJAnmxcBnvN+UokxyIRbmhj0vsJ7rLK4mOlDKpGG0L9qjCbs0RSzZL3oKJiqQp21dQMpS2MP1lMo7+h3SofK2KDV9PjI25rwlXdoxV9r1Pw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823803; c=relaxed/simple;
	bh=ZPfLD/2VaFCfV9JuHuS2PCs5o0Wj11DZmxWwPCOO9rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFkxmhI9o1FbnuX1DGygJxJHsrvK4fyFFL6P3sl3ADEAf5J1HgzKmafvd66HuGiAQEoQ+o9Rn5TEECS1Cp/kXr05eiWtx1f9Nay/+TPOrsaYY+zrVrqVTuTcvjsEJ6OrZBPUvFpSAwWBwF486T5v3UcxRJ2h11ugoDJu1wHvYyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0lbXYQi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15341C4CECF;
	Tue,  5 Nov 2024 16:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730823803;
	bh=ZPfLD/2VaFCfV9JuHuS2PCs5o0Wj11DZmxWwPCOO9rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u0lbXYQi3mp8/ZT3f6YH5dPczmOpUk6qRa/r7FDwMDi9GoulBKrmRmyG3gjBp3tgW
	 9x6KoahAWPbe/2+O8iKWUNowXkurRxeRNzpfJ6xBCVehAxuitPgAGcpQO+evpuXIwD
	 hgNHpfb8cIjgYF8W9vYILFv66VQfs3JxCVlaNJFDCZHhRdgdXllf489zEhwq/5We/3
	 umfOcclj+lsGAC5O4fwzIUcanhDD9DZYJVJOzVkGcgGEwWZrQmK+xozOddiKDk5NSm
	 Y+JVz0yQiodH+25JJgkHK7oG+vhAt4X/JfM+SKVqmo4gt+5RnkCdYUoyKlo+e6NpW+
	 kVCxHgrV/CiPA==
Date: Tue, 5 Nov 2024 09:23:19 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Anuj gupta <anuj1072538@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata along
 with read/write
Message-ID: <ZypGd_-HzEekrcMs@kbusch-mbp.dhcp.thefacebook.com>
References: <20241104140601.12239-1-anuj20.g@samsung.com>
 <CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com>
 <20241104140601.12239-7-anuj20.g@samsung.com>
 <20241105095621.GB597@lst.de>
 <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com>
 <20241105135657.GA4775@lst.de>
 <b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com>
 <20241105160051.GA7599@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105160051.GA7599@lst.de>

On Tue, Nov 05, 2024 at 05:00:51PM +0100, Christoph Hellwig wrote:
> On Tue, Nov 05, 2024 at 09:21:27PM +0530, Kanchan Joshi wrote:
> > Can add the documentation (if this version is palatable for Jens/Pavel), 
> > but this was discussed in previous iteration:
> > 
> > 1. Each meta type may have different space requirement in SQE.
> > 
> > Only for PI, we need so much space that we can't fit that in first SQE. 
> > The SQE128 requirement is only for PI type.
> > Another different meta type may just fit into the first SQE. For that we 
> > don't have to mandate SQE128.
> 
> Ok, I'm really confused now.  The way I understood Anuj was that this
> is NOT about block level metadata, but about other uses of the big SQE.
> 
> Which version is right?  Or did I just completely misunderstand Anuj?

Let's not call this "meta_type". Can we use something that has a less
overloaded meaning, like "sqe_extended_capabilities", or "ecap", or
something like that.
 
> > 2. If two meta types are known not to co-exist, they can be kept in the 
> > same place within SQE. Since each meta-type is a flag, we can check what 
> > combinations are valid within io_uring and throw the error in case of 
> > incompatibility.
> 
> And this sounds like what you refer to is not actually block metadata
> as in this patchset or nvme, (or weirdly enough integrity in the block
> layer code).
> 
> > 3. Previous version was relying on SQE128 flag. If user set the ring 
> > that way, it is assumed that PI information was sent.
> > This is more explicitly conveyed now - if user passed META_TYPE_PI flag, 
> > it has sent the PI. This comment in the code:
> > 
> > +       /* if sqe->meta_type is META_TYPE_PI, last 32 bytes are for PI */
> > +       union {
> > 
> > If this flag is not passed, parsing of second SQE is skipped, which is 
> > the current behavior as now also one can send regular (non pi) 
> > read/write on SQE128 ring.
> 
> And while I don't understand how this threads in with the previous
> statements, this makes sense.  If you only want to send a pointer (+len)
> to metadata you can use the normal 64-byte SQE.  If you want to send
> a PI tuple you need SEQ128.  Is that what the various above statements
> try to express?  If so the right API to me would be to have two flags:
> 
>  - a flag that a pointer to metadata is passed.  This can work with
>    a 64-bit SQE.
>  - another flag that a PI tuple is passed.  This requires a 128-byte
>    and also the previous flag.

I don't think anything done so far aligns with what Pavel had in mind.
Let me try to lay out what I think he's going for. Just bare with me,
this is just a hypothetical example.

  This patch adds a PI extension.
  Later, let's say write streams needs another extenion.
  Then key per-IO wants another extention.
  Then someone else adds wizbang-awesome-feature extention.

Let's say you have device that can do all 4, or any combination of them.
Pavel wants a solution that is future proof to such a scenario. So not
just a single new "meta_type" with its structure, but a list of types in
no particular order, and their structures.

That list can exist either in the extended SQE, or in some other user
address that the kernel will need copy.

