Return-Path: <io-uring+bounces-122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EDF7F32AF
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 16:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF541282A6D
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 15:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF80F4317B;
	Tue, 21 Nov 2023 15:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBKskHHZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCC858125;
	Tue, 21 Nov 2023 15:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FFBC433C8;
	Tue, 21 Nov 2023 15:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700581788;
	bh=w3W5UVYnDU5SknGmgkYDoqIuEo08Ln34K8LjDwMjRM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JBKskHHZ9bM8ojDRB0pTKGpJrBDeIh1Pg4PcJFuKF07T7/obBuJbrK61V+lmPRF1l
	 jqa3PPHIbOjoL20uWpX0GwAGOL/UxtMJekbQpC4xLuF175W5JdfsZcDDYeAmXdig10
	 Nx5U/RN7eWJY1NbsRdEI+4nQ9rQjTvvci3cUWf2qtl3uMsKHhc+No+1P1A7YVNOOyR
	 cEObz9yjYJmMwmgpX7iiV1P09YQqjixs/FXmPIAHAsAgw75f4khdZu2+a+dXgrZDrC
	 UBWV9J6AIk7S/dFHFhE258fZg/fbnC5x8VrX82wkFm4R4swzvFja/M/bkVLDM3T0zk
	 rjll7TU1zHriQ==
Date: Tue, 21 Nov 2023 08:49:45 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, joshi.k@samsung.com,
	martin.petersen@oracle.com
Subject: Re: [PATCHv3 1/5] bvec: introduce multi-page bvec iterating
Message-ID: <ZVzRmQ66yRDJWMiZ@kbusch-mbp>
References: <20231120224058.2750705-1-kbusch@meta.com>
 <20231120224058.2750705-2-kbusch@meta.com>
 <ZVxsLYj9oH+j3RQ8@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVxsLYj9oH+j3RQ8@fedora>

On Tue, Nov 21, 2023 at 04:37:01PM +0800, Ming Lei wrote:
> On Mon, Nov 20, 2023 at 02:40:54PM -0800, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Some bio_vec iterators can handle physically contiguous memory and have
> > no need to split bvec consideration on page boundaries.
> 
> Then I am wondering why this helper is needed, and you can use each bvec
> directly, which is supposed to be physically contiguous.

It's just a helper function to iterate a generic bvec.
 
> > diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> > index 555aae5448ae4..9364c258513e0 100644
> > --- a/include/linux/bvec.h
> > +++ b/include/linux/bvec.h
> > @@ -184,6 +184,12 @@ static inline void bvec_iter_advance_single(const struct bio_vec *bv,
> >  		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
> >  	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
> >  
> > +#define for_each_mp_bvec(bvl, bio_vec, iter, start)			\
> > +	for (iter = (start);						\
> > +	     (iter).bi_size &&						\
> > +		((bvl = mp_bvec_iter_bvec((bio_vec), (iter))), 1);	\
> > +	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
> > +
> 
> We already have bio_for_each_bvec() to iterate over (multipage)bvecs
> from bio.

Right, but we are not dealing with a bio here. We have a bip bvec
instead, so can't use bio_for_each_bvec().

