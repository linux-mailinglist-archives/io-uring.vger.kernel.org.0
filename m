Return-Path: <io-uring+bounces-197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8F18012F1
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 19:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04FF1281E45
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 18:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837D749F8A;
	Fri,  1 Dec 2023 18:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBJ3atBQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6212D54BC2;
	Fri,  1 Dec 2023 18:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A93C433C7;
	Fri,  1 Dec 2023 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701456176;
	bh=Lr/5S23HyH9+H9WBmLOsJqtgoXJc2MP8bGmF/5tuDPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DBJ3atBQofnN7kHgb7nGGuIxXBhLEQNPI/JC7u8XvCJsrBHEWFYm/AX9okviwg5cZ
	 Du3rCyxCwQt+kWP31FM8YAF1jY6k+SkjrR7v50ydPZyPjp8pmcilHAXnc8pcrVHZgx
	 K5i5gvhFHjUVznARCN9u1d6EqnKhgjvflcX7A4Rcdumrnl+QKTvqhGkH+f047eB0pk
	 kNOfYfnZeeSbI3TRdguPB/hAiV/kdXTIwasdy1XwVvsS1pGRRyU1zOngjDz7tAo88J
	 OnYbGNX19fXfcBN/xNp9tpldAW6Pn2yjzEvMTz7YKBaD0/hUIzVTIbqLXLyKrJJ9h0
	 urxmA8yoEahhA==
Date: Fri, 1 Dec 2023 11:42:53 -0700
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	ming.lei@redhat.com
Subject: Re: [PATCHv5 0/4] block integrity: directly map user space addresses
Message-ID: <ZWopLQWBIUGBad3z@kbusch-mbp>
References: <CGME20231130215715epcas5p33208ca14e69a68402c04e5c743135e6c@epcas5p3.samsung.com>
 <20231130215309.2923568-1-kbusch@meta.com>
 <e3c2d527-3927-7efe-a61f-ff7e5af95d83@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3c2d527-3927-7efe-a61f-ff7e5af95d83@samsung.com>

On Fri, Dec 01, 2023 at 04:13:45PM +0530, Kanchan Joshi wrote:
> On 12/1/2023 3:23 AM, Keith Busch wrote:
> > From: Keith Busch<kbusch@kernel.org>
> 
> This causes a regression (existed in previous version too).
> System freeze on issuing single read/write io that used to work fine 
> earlier:
> fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -cmd_type=nvme 
> -bs=4096 -numjobs=1 -size=4096 -filename=/dev/ng0n1 -md_per_io_size=8 
> -name=pt
> 
> This is because we pin one bvec during submission, but unpin 4 on 
> completion. bio_integrity_unpin_bvec() uses bip->bip_max_vcnt, which is 
> set to 4 (equal to BIO_INLINE_VECS) in this case.
> 
> To use bip_max_vcnt the way this series uses, we need below patch/fix:

Thanks for the catch! Earlier versions of this series was capped by the
byte count rather than the max_vcnt value, so the inline condition
didn't matter before. I think your update looks good. I'll double check
what's going on with my custom tests to see why it didn't see this
problem.
 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 674a2c80454b..feef615e2c9c 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -69,15 +69,15 @@ struct bio_integrity_payload 
> *bio_integrity_alloc(struct bio *bio,
> 
>          memset(bip, 0, sizeof(*bip));
> 
> +       /* always report as many vecs as asked explicitly, not inline 
> vecs */
> +       bip->bip_max_vcnt = nr_vecs;
>          if (nr_vecs > inline_vecs) {
> -               bip->bip_max_vcnt = nr_vecs;
>                  bip->bip_vec = bvec_alloc(&bs->bvec_integrity_pool,
>                                            &bip->bip_max_vcnt, gfp_mask);
>                  if (!bip->bip_vec)
>                          goto err;
>          } else {
>                  bip->bip_vec = bip->bip_inline_vecs;
> -               bip->bip_max_vcnt = inline_vecs;
>          }
> 
>          bip->bip_bio = bio;

