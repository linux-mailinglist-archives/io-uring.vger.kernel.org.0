Return-Path: <io-uring+bounces-3759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A91C9A1C06
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 09:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 249EF283832
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 07:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760331C3037;
	Thu, 17 Oct 2024 07:54:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607A8192594;
	Thu, 17 Oct 2024 07:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729151642; cv=none; b=EBcyEx7VgkzA68c7Yxk713hwn5hWwfu5HxJSUmtHiqsEoomqI4/tKPNrIIwXBdHptHrohYJLdz7Www2oCQcRgreGjTj3besJSEISHjtkZJ7zSHwnYzITRWYGelQhOmc0fnt/ksNTjikM5fphPyhRY9gAgZiRB7QS7WDzKuihV3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729151642; c=relaxed/simple;
	bh=cPiELhUyGgGDrv1yJgMiy73bgJ1Wvf58R02+f21J5o8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0yZIz+al+Lt6ZgAiSsvdYG2I3fiBEGxfNS+WHpfT3z/SYAtU7XJvrmKwpioe/LKeBGGW4CRvRRInA3KJJtkBtAcq9EoqKKYN6OSV/3f/CwapejkYLQXzoot3/MamasHIvqS7J6vyOD1smXxWt5CYdhgvdu4fBbCmksFTh03BLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 051CF227A87; Thu, 17 Oct 2024 09:53:55 +0200 (CEST)
Date: Thu, 17 Oct 2024 09:53:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 02/11] block: copy back bounce buffer to user-space
 correctly in case of split
Message-ID: <20241017075354.GA25343@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113736epcas5p3a03665bf0674e68a8f95bbd5f3607357@epcas5p3.samsung.com> <20241016112912.63542-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 16, 2024 at 04:59:03PM +0530, Anuj Gupta wrote:
> Copy back the bounce buffer to user-space in entirety when the parent
> bio completes.

This commit message is a bit sparse..

> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -119,8 +119,8 @@ static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
>  static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
>  {
>  	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
> -	struct bio_vec *copy = &bip->bip_vec[1];
> -	size_t bytes = bip->bip_iter.bi_size;
> +	struct bio_vec *copy = &bip->bip_vec[1], *bvec = &bip->bip_vec[0];
> +	size_t bytes = bvec->bv_len;
>  	struct iov_iter iter;
>  	int ret;

And while trying to understand what this code does I keep getting
confused by what bio_integrity_uncopy_user actually does.

And I think a bit part of that is the "creative" abuse of bip_vec
by the copy-based integrity code, where bip_vec[0] is the vector
passed to the block layer, and the rest contains the user buffer.

Maybe it's just me, but not stashing the user pages in the bvecs
but just stasing away the actual iov_iter would be much preferable
for this code?

Either way, back to the code.  The existing code uses
bip_iter.bi_size for sizing the copy, and that can be modified when
the bio is cloned (or at least by the rules for the bio data) be
modified by the driver.  So yes, switching away from that is
good and the change looks correct.  That being said, even if we
aren't going to fix up the logic as mentioned above instantly,
can we pick better names for the variables?

static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
{
 	unsigned short orig_nr_vecs = bip->bip_max_vcnt - 1;
	struct bio_vec *orig_bvecs = &bip->bip_vec[1];
	struct bio_vec *bounce_bvec = &bip->bip_vec[0];
	size_t bytes = boune_bvec->bv_len;
 	struct iov_iter orig_iter;
	int ret;

	iov_iter_bvec(&orig_iter, ITER_DEST, orig_bvecs, orig_nr_vecs, bytes);
	ret = copy_to_iter(bvec_virt(bounce_bvec), bytes, &orig_iter);
	WARN_ON_ONCE(ret != bytes);

	bio_integrity_unpin_bvec(orig_bvecs, orig_nr_vecs, true);
}

?

Also please add a Fixes tag.

