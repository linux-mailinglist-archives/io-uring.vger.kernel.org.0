Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089012E0B8F
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 15:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgLVOPw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Dec 2020 09:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgLVOPv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Dec 2020 09:15:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B92EC0613D3;
        Tue, 22 Dec 2020 06:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IGeyzIyslymkVZrOh/vnAkBCRf5syQaFMRZEQvrriys=; b=p9GqVWfb1C0KSz9SZ5xoF5rfSz
        rz++tDusxtSVuHNwTrRvLHlkXdWgKSF87T+mHUcLcSiXoMl+eqyzba+9gm3Tc0+YzXhKIzKvzBUz1
        aL8g89CCgdjrRJ4J5WqlP6+8BR+y9eXBMRKR5XwNS2ua40rm7i9p5L/xlBVro3ZQ6OxaDrx/eMioJ
        IPcnOGrhse9KpwbBREggJMmpVDW17ZRkqbEf1RvumXBgWIMxYKMdl/ntzaBjIzhWzxqY+S38GZ4Jt
        ry9S+EQFO47DLJ9SMIPFrS5gFwxWREoRUjX2wUka0kuRN2NhFTlBKUFTiDUxleHJdLef89fFNXw7l
        DWVzm12Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kriRR-0004QG-41; Tue, 22 Dec 2020 14:15:09 +0000
Date:   Tue, 22 Dec 2020 14:15:09 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 6/6] block/iomap: don't copy bvec for direct IO
Message-ID: <20201222141509.GF13079@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <498b34d746627e874740d8315b2924880c46dbc3.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498b34d746627e874740d8315b2924880c46dbc3.1607976425.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 15, 2020 at 12:20:25AM +0000, Pavel Begunkov wrote:
> The block layer spends quite a while in blkdev_direct_IO() to copy and
> initialise bio's bvec. However, if we've already got a bvec in the input
> iterator it might be reused in some cases, i.e. when new
> ITER_BVEC_FLAG_FIXED flag is set. Simple tests show considerable
> performance boost, and it also reduces memory footprint.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/filesystems/porting.rst |  9 ++++
>  block/bio.c                           | 64 +++++++++++----------------
>  include/linux/bio.h                   |  3 ++
>  3 files changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index 867036aa90b8..47a622879952 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -865,3 +865,12 @@ no matter what.  Everything is handled by the caller.
>  
>  clone_private_mount() returns a longterm mount now, so the proper destructor of
>  its result is kern_unmount() or kern_unmount_array().
> +
> +---
> +
> +**mandatory**
> +
> +For bvec based itererators bio_iov_iter_get_pages() now doesn't copy bvecs but
> +uses the one provided. Anyone issuing kiocb-I/O should ensure that the bvec and
> +page references stay until I/O has completed, i.e. until ->ki_complete() has
> +been called or returned with non -EIOCBQUEUED code.
> diff --git a/block/bio.c b/block/bio.c
> index 3192358c411f..f8229be24562 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -960,25 +960,16 @@ void bio_release_pages(struct bio *bio, bool mark_dirty)
>  }
>  EXPORT_SYMBOL_GPL(bio_release_pages);
>  
> +static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
>  {
> +	WARN_ON_ONCE(BVEC_POOL_IDX(bio) != 0);
> +	bio->bi_vcnt = iter->nr_segs;
> +	bio->bi_max_vecs = iter->nr_segs;
> +	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
> +	bio->bi_iter.bi_bvec_done = iter->iov_offset;
> +	bio->bi_iter.bi_size = iter->count;

Nit: I find an empty liner after WARN_ON_ONCE that assert the caller
state very helpful when reading the code.

>  static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
>  {
> +	/* reuse iter->bvec */

Maybe add a ", see bio_iov_bvec_set for details" here?
