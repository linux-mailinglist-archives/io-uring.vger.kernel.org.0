Return-Path: <io-uring+bounces-1698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D1F8B8664
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 09:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BE7DB22211
	for <lists+io-uring@lfdr.de>; Wed,  1 May 2024 07:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FEF4D58A;
	Wed,  1 May 2024 07:50:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1B14CE0F;
	Wed,  1 May 2024 07:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549845; cv=none; b=id12WyfRKG8sd0c2oM5yw4RhLaTVKjPdLlb7XtyFlzfsLk9pSfBI4lrgmuvOzycpBod9jBQiiTULM90E/8AdQR5giW4g3rhMxcJ5lToDWRK8Hm0rsuqNVRAGtsmRCmv80Cp9wgfLec9er5lBJnySWUviglzaMVc4vh33aPyHq8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549845; c=relaxed/simple;
	bh=OSCYqZIptNvx/l+Ny4gIdR5v6gijMJQbWcNNCtgtJOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPPsliFTHP64uCfLOT6vXTrS4bm43TD+iwHgfIZZEJP+/UZgKYI6S6TYaYghZYIfqmQ6trrZz3unZTMiRZyq2lpfrBNKTcdxU2SA5DCkeP9dq5tLEIyTcEdSCjnyw4hsZLvGR6Pm3eICxq0F+NqHLRDks18uIKl7G8RTd0ukY94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 214B5227A87; Wed,  1 May 2024 09:50:40 +0200 (CEST)
Date: Wed, 1 May 2024 09:50:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	martin.petersen@oracle.com, kbusch@kernel.org, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 02/10] block: copy bip_max_vcnt vecs instead of
 bip_vcnt during clone
Message-ID: <20240501075039.GC2325@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7@epcas5p2.samsung.com> <20240425183943.6319-3-joshi.k@samsung.com> <20240427070331.GB3873@lst.de> <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 04:58:37PM +0530, Kanchan Joshi wrote:
> On 4/27/2024 12:33 PM, Christoph Hellwig wrote:
> >> If bio_integrity_copy_user is used to process the meta buffer, bip_max_vcnt
> >> is one greater than bip_vcnt. In this case bip_max_vcnt vecs needs to be
> >> copied to cloned bip.
> > Can you explain this a bit more?  The clone should only allocate what
> > is actually used, so this leaves be a bit confused.
> > 
> 
> Will expand the commit description.
> 
> Usually the meta buffer is pinned and used directly (say N bio vecs).
> In case kernel has to make a copy (in bio_integrity_copy_user), it 
> factors these N vecs in, and one extra for the bounce buffer.
> So for read IO, bip_max_vcnt is N+1, while bip_vcnt is N.
> 
> The clone bio also needs to be aware of all N+1 vecs, so that we can 
> copy the data from the bounce buffer to pinned user pages correctly 
> during read-completion.

No.  The underlying layer below the clone/split/etc should never have
to care about your bounce buffer.  The bvecs are just data containers,
and if they are mapped, copied or used in any other way should remain
entirely encapsulated in the caller.

