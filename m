Return-Path: <io-uring+bounces-116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC077F24F5
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 06:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52E061C214A6
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 05:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1190168D2;
	Tue, 21 Nov 2023 05:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8964F4;
	Mon, 20 Nov 2023 21:04:43 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F4F96732A; Tue, 21 Nov 2023 06:04:39 +0100 (CET)
Date: Tue, 21 Nov 2023 06:04:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 2/5] block: bio-integrity: directly map user buffers
Message-ID: <20231121050438.GB2865@lst.de>
References: <20231120224058.2750705-1-kbusch@meta.com> <20231120224058.2750705-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120224058.2750705-3-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 20, 2023 at 02:40:55PM -0800, Keith Busch wrote:
> +static void bio_integrity_unmap_user(struct bio_integrity_payload *bip)
> +{
> +	bool dirty = bio_data_dir(bip->bip_bio) == READ;
> +	struct bvec_iter iter;
> +	struct bio_vec bv;
> +
> +	if (bip->bip_flags & BIP_COPY_USER) {
> +		unsigned short nr_vecs = bip->bip_max_vcnt - 1;
> +		struct bio_vec *copy = bvec_virt(&bip->bip_vec[nr_vecs]);
> +		size_t bytes = bip->bip_iter.bi_size;
> +		void *buf = bvec_virt(bip->bip_vec);
> +
> +		if (dirty) {
> +			struct iov_iter iter;
> +
> +			iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
> +			WARN_ON_ONCE(copy_to_iter(buf, bytes, &iter) != bytes);
> +		}
> +
> +		memcpy(bip->bip_vec, copy, nr_vecs * sizeof(*copy));
> +		kfree(copy);
> +		kfree(buf);

Nit: but I'd probably just split the user copy version into a separate
helper for clarity.  Nice trick with the temporary iter, we could probably
use this for the data path too.

> +extern int bio_integrity_map_user(struct bio *, void __user *, ssize_t, u32);

Can you drop the pointless extern and just spell out the paratmeters?
I know this follows the existing style, but that style is pretty
horrible :)

