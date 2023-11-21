Return-Path: <io-uring+bounces-115-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A076F7F24F3
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 06:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA8C11C214A2
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 05:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 414D013AD5;
	Tue, 21 Nov 2023 05:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60E5CF;
	Mon, 20 Nov 2023 21:01:18 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4DF2E6732A; Tue, 21 Nov 2023 06:01:13 +0100 (CET)
Date: Tue, 21 Nov 2023 06:01:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 1/5] bvec: introduce multi-page bvec iterating
Message-ID: <20231121050112.GA2865@lst.de>
References: <20231120224058.2750705-1-kbusch@meta.com> <20231120224058.2750705-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120224058.2750705-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 20, 2023 at 02:40:54PM -0800, Keith Busch wrote:
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 555aae5448ae4..9364c258513e0 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -184,6 +184,12 @@ static inline void bvec_iter_advance_single(const struct bio_vec *bv,
>  		((bvl = bvec_iter_bvec((bio_vec), (iter))), 1);	\
>  	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))
>  
> +#define for_each_mp_bvec(bvl, bio_vec, iter, start)			\
> +	for (iter = (start);						\
> +	     (iter).bi_size &&						\
> +		((bvl = mp_bvec_iter_bvec((bio_vec), (iter))), 1);	\
> +	     bvec_iter_advance_single((bio_vec), &(iter), (bvl).bv_len))

Hope thjis isn't too much bike-shedding, but in the block layer
we generally used _segment for the single page bvecs and just bvec
for the not page size limited.  This isn't the best naming either,
but i wonder if it's worth to change the existing 4 callers and be
consistent.  (and maybe one or two of them doesn't want the limit anyway?)

Otherwise this looks good to me.


