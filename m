Return-Path: <io-uring+bounces-202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6B68016E0
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 23:49:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B91E1F21050
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 22:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1634138DD2;
	Fri,  1 Dec 2023 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLl2RC+R"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D80619D4;
	Fri,  1 Dec 2023 22:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1941C433C7;
	Fri,  1 Dec 2023 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701470984;
	bh=B+2oZDNTaCrSceXjfLUiK5YOjMozykyK9t8qkbIJACk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hLl2RC+RvTDwWGr8BLm+z0E+yZCFlkLNHX6kJT40SgT9IOpPZJefzw15YNsEQcRV/
	 21e8EXUDcbA3VD28Ksw4uhDMLljE/+42KJrGkGjBrtnFSBIY79v5NECG3Vn5s1EKeP
	 C9lEBQtzRXRtCpJszYIA/0QQvCiF49l4IxUYiJx/8L/PfTxBQ9H5UBzsAmQcmJS+V5
	 o2SQNKTXLWYO5xz6SjNtMGdsyP19dnvXCcbBEcVik7BZ+oRhZSOMk93IVeP0olc3U3
	 aCCrPqIK/dbb2LOd/oGc3UjQUhj5yB7NjnhQ3dDSpXPxe6p1Iq10V6qoxFdhnJ12VB
	 oELDlxtiIxlgw==
Date: Fri, 1 Dec 2023 15:49:40 -0700
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	ming.lei@redhat.com
Subject: Re: [PATCHv5 0/4] block integrity: directly map user space addresses
Message-ID: <ZWpjBCF4KueqKlPN@kbusch-mbp>
References: <CGME20231130215715epcas5p33208ca14e69a68402c04e5c743135e6c@epcas5p3.samsung.com>
 <20231130215309.2923568-1-kbusch@meta.com>
 <e3c2d527-3927-7efe-a61f-ff7e5af95d83@samsung.com>
 <ZWopLQWBIUGBad3z@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWopLQWBIUGBad3z@kbusch-mbp>

On Fri, Dec 01, 2023 at 11:42:53AM -0700, Keith Busch wrote:
> On Fri, Dec 01, 2023 at 04:13:45PM +0530, Kanchan Joshi wrote:
> > On 12/1/2023 3:23 AM, Keith Busch wrote:
> > > From: Keith Busch<kbusch@kernel.org>
> > 
> > This causes a regression (existed in previous version too).
> > System freeze on issuing single read/write io that used to work fine 
> > earlier:
> > fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -cmd_type=nvme 
> > -bs=4096 -numjobs=1 -size=4096 -filename=/dev/ng0n1 -md_per_io_size=8 
> > -name=pt
> > 
> > This is because we pin one bvec during submission, but unpin 4 on 
> > completion. bio_integrity_unpin_bvec() uses bip->bip_max_vcnt, which is 
> > set to 4 (equal to BIO_INLINE_VECS) in this case.
> > 
> > To use bip_max_vcnt the way this series uses, we need below patch/fix:
> 
> Thanks for the catch! Earlier versions of this series was capped by the
> byte count rather than the max_vcnt value, so the inline condition
> didn't matter before. I think your update looks good. I'll double check
> what's going on with my custom tests to see why it didn't see this
> problem.

Got it: I was using ioctl instead of iouring. ioctl doesn't set
REQ_ALLOC_CACHE, so we don't get a bio_set in bio_integrity_alloc(), and
that makes inline_vecs set similiar to what your diff does.

Jens already applied the latest series for the next merge. We can append
this or fold atop, or back it out and we can rework it for another
version. No rush; for your patch:

Reviewed-by: Keith Busch <kbusch@kernel.org>

Thanks again!

> > diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> > index 674a2c80454b..feef615e2c9c 100644
> > --- a/block/bio-integrity.c
> > +++ b/block/bio-integrity.c
> > @@ -69,15 +69,15 @@ struct bio_integrity_payload 
> > *bio_integrity_alloc(struct bio *bio,
> > 
> >          memset(bip, 0, sizeof(*bip));
> > 
> > +       /* always report as many vecs as asked explicitly, not inline 
> > vecs */
> > +       bip->bip_max_vcnt = nr_vecs;
> >          if (nr_vecs > inline_vecs) {
> > -               bip->bip_max_vcnt = nr_vecs;
> >                  bip->bip_vec = bvec_alloc(&bs->bvec_integrity_pool,
> >                                            &bip->bip_max_vcnt, gfp_mask);
> >                  if (!bip->bip_vec)
> >                          goto err;
> >          } else {
> >                  bip->bip_vec = bip->bip_inline_vecs;
> > -               bip->bip_max_vcnt = inline_vecs;
> >          }
> > 
> >          bip->bip_bio = bio;
> 

