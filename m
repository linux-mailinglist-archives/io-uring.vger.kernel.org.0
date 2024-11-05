Return-Path: <io-uring+bounces-4460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C28BA9BD1A3
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 17:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88C2B2856EF
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 16:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF20185B69;
	Tue,  5 Nov 2024 16:00:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3390D1552F6;
	Tue,  5 Nov 2024 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730822459; cv=none; b=mTO2J1fb0eteNY5iVQXrchzldrPq99dbW1A/a+x+MkLHhvVI/QWXenvKO4GK1uc1sUZXFH4qsq83TpSqNyZr4Sidxw2p7xGfC6E+ZaUTRqz44lOnKJxT8XCuK2de42FGapGTZIc5V1Dz7PQIq8P51gp/l6I+FLVgdBexDXussUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730822459; c=relaxed/simple;
	bh=0hFYpv05gf9VcHrx0UUx/n/00VxqWSThLGDwJAV0lm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDqHusfOyI5CrJClASLa0PTZGePFTuFyV2+KhaUGFPwvixJFbJiVJEw8Gse4HFTpHhxvjcJAy8KRvoPXHFzf7wpTg1+hszIQ4SAT/kVQL2ZJDZyS3hCH/sxpjm5Jhv1etDK4kzb1/LLPWP3m+mvUDfCUBjLM8U/n32fMFi3ndwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD1D5227AAC; Tue,  5 Nov 2024 17:00:51 +0100 (CET)
Date: Tue, 5 Nov 2024 17:00:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj gupta <anuj1072538@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk,
	kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241105160051.GA7599@lst.de>
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com> <20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de> <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com> <20241105135657.GA4775@lst.de> <b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 05, 2024 at 09:21:27PM +0530, Kanchan Joshi wrote:
> Can add the documentation (if this version is palatable for Jens/Pavel), 
> but this was discussed in previous iteration:
> 
> 1. Each meta type may have different space requirement in SQE.
> 
> Only for PI, we need so much space that we can't fit that in first SQE. 
> The SQE128 requirement is only for PI type.
> Another different meta type may just fit into the first SQE. For that we 
> don't have to mandate SQE128.

Ok, I'm really confused now.  The way I understood Anuj was that this
is NOT about block level metadata, but about other uses of the big SQE.

Which version is right?  Or did I just completely misunderstand Anuj?

> 2. If two meta types are known not to co-exist, they can be kept in the 
> same place within SQE. Since each meta-type is a flag, we can check what 
> combinations are valid within io_uring and throw the error in case of 
> incompatibility.

And this sounds like what you refer to is not actually block metadata
as in this patchset or nvme, (or weirdly enough integrity in the block
layer code).

> 3. Previous version was relying on SQE128 flag. If user set the ring 
> that way, it is assumed that PI information was sent.
> This is more explicitly conveyed now - if user passed META_TYPE_PI flag, 
> it has sent the PI. This comment in the code:
> 
> +       /* if sqe->meta_type is META_TYPE_PI, last 32 bytes are for PI */
> +       union {
> 
> If this flag is not passed, parsing of second SQE is skipped, which is 
> the current behavior as now also one can send regular (non pi) 
> read/write on SQE128 ring.

And while I don't understand how this threads in with the previous
statements, this makes sense.  If you only want to send a pointer (+len)
to metadata you can use the normal 64-byte SQE.  If you want to send
a PI tuple you need SEQ128.  Is that what the various above statements
try to express?  If so the right API to me would be to have two flags:

 - a flag that a pointer to metadata is passed.  This can work with
   a 64-bit SQE.
 - another flag that a PI tuple is passed.  This requires a 128-byte
   and also the previous flag.


> 
> 
> 
> 
> 
---end quoted text---

