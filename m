Return-Path: <io-uring+bounces-4478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 306549BDE9E
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 07:12:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9B53284A52
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 06:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE241922E6;
	Wed,  6 Nov 2024 06:12:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBE71922D8;
	Wed,  6 Nov 2024 06:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730873568; cv=none; b=J/nT3be0hSreGwLAcyu5uITL+LBJiqXmqi0VUP/ljrlO2uPxkkLtTlz5ebhdIiAtwNwM1qSGr1ucFMtb64HhKeJZy0nkDCLFZMOYprZ1evjt1U8CJXPrnjkToBaQPyZ64hdcfTUk/3Pv2XL+b+lu3e+20bflA73l9KokizQ9kWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730873568; c=relaxed/simple;
	bh=7wESXxZaC99QSJ5TyLrHyHFhckEOGKb5htJZ2OOVQAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hESM2BmRKxuqfROBAwxw/+IIWXqeeKLb/Gxncq8i/4QZIH6yHy4hp86cKhrUh6wiuBORjaXlkCoBO3g4kyi9B0YZSd0JGdQO18gkk5K/HqBYHZBqMoMzu7Cdtm3D7mfL/iKXVFdRXXnyXWzdFj90LiYCJax6tWB+RMtzljAhcks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E012268AFE; Wed,  6 Nov 2024 07:12:41 +0100 (CET)
Date: Wed, 6 Nov 2024 07:12:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20241106061241.GA32101@lst.de>
References: <CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com> <20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de> <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com> <20241105135657.GA4775@lst.de> <b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com> <20241105160051.GA7599@lst.de> <ZypGd_-HzEekrcMs@kbusch-mbp.dhcp.thefacebook.com> <20241106052927.GA31192@lst.de> <e68f0127-a8a8-46da-8e68-7a2f3af73627@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68f0127-a8a8-46da-8e68-7a2f3af73627@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 06, 2024 at 11:30:45AM +0530, Kanchan Joshi wrote:
> >   1) some space to actually store the extra fields
> >   2) a flag that the additional values are passed
> 
> Yes, this is exactly how the patch is implemented. 'meta-type' is the 
> flag that tells additional values (representing PI info) are passed.
> 
> > any single value is not going to help with supporting arbitrary
> > combinations,
> 
> Not a single value. It is a u16 field, so it can represent 16 possible 
> flags.
> This part in the patch:
> 
> +enum io_uring_sqe_meta_type_bits {
> +       META_TYPE_PI_BIT,
> +       /* not a real meta type; just to make sure that we don't overflow */
> +       META_TYPE_LAST_BIT,
> +};

Well, then it's grossly misnamed and underdocumented.  For one the
meta name simply is wrong because it's about all extra features.
Second a type implies an enumeration of types, not a set of flags.

So if you actually name this extended_features or similar and clearly
document it might actually make sense.


