Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EAD7CEF1A
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 07:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjJSFjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 01:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjJSFjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 01:39:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661A5106;
        Wed, 18 Oct 2023 22:39:09 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6D0D467373; Thu, 19 Oct 2023 07:39:05 +0200 (CEST)
Date:   Thu, 19 Oct 2023 07:39:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@meta.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        joshi.k@samsung.com, martin.petersen@oracle.com,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/4] block: bio-integrity: add support for user buffers
Message-ID: <20231019053905.GC14346@lst.de>
References: <20231018151843.3542335-1-kbusch@meta.com> <20231018151843.3542335-2-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231018151843.3542335-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

int bio_integrity_map_user(struct bio *bio, void __user *ubuf, unsigned int len,
> +			   u32 seed, u32 maxvecs)
> +{
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +	unsigned long align = q->dma_pad_mask | queue_dma_alignment(q);
> +	struct page *stack_pages[UIO_FASTIOV];
> +	size_t offset = offset_in_page(ubuf);
> +	unsigned long ptr = (uintptr_t)ubuf;
> +	struct page **pages = stack_pages;
> +	struct bio_integrity_payload *bip;
> +	int npages, ret, i;
> +
> +	if (bio_integrity(bio) || ptr & align || maxvecs > UIO_FASTIOV)
> +		return -EINVAL;

We also need to check the length for the dma alignment/pad, not
just the start.  (The undocumented iov_iter_alignment_iovec helper
obsfucateѕ this for the data path).

> +	bip = bio_integrity_alloc(bio, GFP_KERNEL, maxvecs);
> +	if (IS_ERR(bip))
> +		return PTR_ERR(bip);
> +
> +	ret = pin_user_pages_fast(ptr, UIO_FASTIOV, FOLL_WRITE, pages);
> +	if (unlikely(ret < 0))
> +		goto free_bip;
> +
> +	npages = ret;
> +	for (i = 0; i < npages; i++) {
> +		u32 bytes = min_t(u32, len, PAGE_SIZE - offset);
> +		ret = bio_integrity_add_page(bio, pages[i], bytes, offset);
> +		if (ret != bytes) {
> +			ret = -EINVAL;
> +			goto release_pages;
> +		}
> +		len -= ret;
> +		offset = 0;
> +	}

Any reason to not use the bio_vec array as the buffer, similar to the
data size here?

> +EXPORT_SYMBOL(bio_integrity_map_user);

Everything that just thinly wraps get_user_pages_fast needs to be
EXPORT_SYMBOL_GPL.

