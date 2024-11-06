Return-Path: <io-uring+bounces-4474-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 504339BDE49
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 06:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD421284F90
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 05:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0395D19006B;
	Wed,  6 Nov 2024 05:29:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEF12F44;
	Wed,  6 Nov 2024 05:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730870977; cv=none; b=Nmg/UpjFiRnoRChrDUS+Nii1cTVivwePnNEKqNx26s1AgKfcl2e9/CoFqWuCKHiLJTZCqaYHIj3osCh2VzoeTsP9O0x7drsAqoDaFC5X799sQW+t5MoHbBGF8CtMqeptdyWU4KBlw0wc5sHoPQuefqc1b6VyAosXJqZkflW/NrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730870977; c=relaxed/simple;
	bh=G/W0FWjwz88CzxVriYuO/Agcx8YeZPgLoc8aiRbUc10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWszFIc4z911UyY93tz1nAhQWhzOatbiLJqddZwimkKkafvJgpXbbQmdnkMQW/5mv/H1q984IJVtCDK7y3MUcFAnx0wNqQtwSpNfOGNj/GvsThflUhrHbDcx6vSm0AUHW9EhVpE0RWwmJrkP17WCO9m/RGyfvaJceOdk8XfiEu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ADF7868AFE; Wed,  6 Nov 2024 06:29:28 +0100 (CET)
Date: Wed, 6 Nov 2024 06:29:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj gupta <anuj1072538@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241106052927.GA31192@lst.de>
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com> <20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de> <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com> <20241105135657.GA4775@lst.de> <b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com> <20241105160051.GA7599@lst.de> <ZypGd_-HzEekrcMs@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZypGd_-HzEekrcMs@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 05, 2024 at 09:23:19AM -0700, Keith Busch wrote:
> > > The SQE128 requirement is only for PI type.
> > > Another different meta type may just fit into the first SQE. For that we 
> > > don't have to mandate SQE128.
> > 
> > Ok, I'm really confused now.  The way I understood Anuj was that this
> > is NOT about block level metadata, but about other uses of the big SQE.
> > 
> > Which version is right?  Or did I just completely misunderstand Anuj?
> 
> Let's not call this "meta_type". Can we use something that has a less
> overloaded meaning, like "sqe_extended_capabilities", or "ecap", or
> something like that.

So it's just a flag that a 128-byte SQE is used?  Don't we know that
implicitly from the sq?

> >  - a flag that a pointer to metadata is passed.  This can work with
> >    a 64-bit SQE.
> >  - another flag that a PI tuple is passed.  This requires a 128-byte
> >    and also the previous flag.
> 
> I don't think anything done so far aligns with what Pavel had in mind.
> Let me try to lay out what I think he's going for. Just bare with me,
> this is just a hypothetical example.
> 
>   This patch adds a PI extension.
>   Later, let's say write streams needs another extenion.
>   Then key per-IO wants another extention.
>   Then someone else adds wizbang-awesome-feature extention.
> 
> Let's say you have device that can do all 4, or any combination of them.
> Pavel wants a solution that is future proof to such a scenario. So not
> just a single new "meta_type" with its structure, but a list of types in
> no particular order, and their structures.

But why do we need the type at all?  Each of them obvious needs two
things:

 1) some space to actually store the extra fields
 2) a flag that the additional values are passed

any single value is not going to help with supporting arbitrary
combinations, because well, you can can mix and match, and you need
space for all them even if you are not using all of them.


