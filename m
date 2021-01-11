Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454C42F0B47
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 03:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbhAKC65 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 21:58:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbhAKC65 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 21:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610333850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ty7GFnFeJc6jZbRimFvcSxwHhWMZKBFI3wOaZ1vJeGo=;
        b=QSXTeRCwuXF+EQGvDvlSeTV6F9+UQ4+h+4xphu+zBzE4HVd2f4lGMZ+VqO1kPvemC6IZCh
        5X8Br8Qn9sklnlsn/EQya6BKDw+sFt+z8LOkdrU3D4FXAsNdZROuoy340m0tVaKBUybnNJ
        q5cPkmaVuT/DVNI59oa1CLCJfl8M1lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-lfrDpYNaMcuSG9HvsZrXJA-1; Sun, 10 Jan 2021 21:57:28 -0500
X-MC-Unique: lfrDpYNaMcuSG9HvsZrXJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7949180A09E;
        Mon, 11 Jan 2021 02:57:25 +0000 (UTC)
Received: from T590 (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 208EF19D9D;
        Mon, 11 Jan 2021 02:57:14 +0000 (UTC)
Date:   Mon, 11 Jan 2021 10:57:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 6/7] bio: add a helper calculating nr segments to alloc
Message-ID: <20210111025710.GG4147870@T590>
References: <cover.1610170479.git.asml.silence@gmail.com>
 <cde94f6cc32bd8a899129575678c4195f7cb187b.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cde94f6cc32bd8a899129575678c4195f7cb187b.1610170479.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 09, 2021 at 04:03:02PM +0000, Pavel Begunkov wrote:
> Add a helper function calculating the number of bvec segments we need to
> allocate to construct a bio. It doesn't change anything functionally,
> but will be used to not duplicate special cases in the future.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/block_dev.c       |  7 ++++---
>  fs/iomap/direct-io.c |  9 ++++-----
>  include/linux/bio.h  | 10 ++++++++++
>  3 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 3b8963e228a1..6f5bd9950baf 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -416,7 +416,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
>  		dio->size += bio->bi_iter.bi_size;
>  		pos += bio->bi_iter.bi_size;
>  
> -		nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES);
> +		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_PAGES);
>  		if (!nr_pages) {
>  			bool polled = false;
>  
> @@ -481,9 +481,10 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  {
>  	int nr_pages;
>  
> -	nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES + 1);
> -	if (!nr_pages)
> +	if (!iov_iter_count(iter))
>  		return 0;
> +
> +	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_PAGES + 1);
>  	if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
>  		return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
>  
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 933f234d5bec..ea1e8f696076 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -250,11 +250,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  	orig_count = iov_iter_count(dio->submit.iter);
>  	iov_iter_truncate(dio->submit.iter, length);
>  
> -	nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
> -	if (nr_pages <= 0) {
> -		ret = nr_pages;
> +	if (!iov_iter_count(dio->submit.iter))
>  		goto out;
> -	}
>  
>  	if (need_zeroout) {
>  		/* zero out from the start of the block to the write offset */
> @@ -263,6 +260,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  			iomap_dio_zero(dio, iomap, pos - pad, pad);
>  	}
>  
> +	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_PAGES);
>  	do {
>  		size_t n;
>  		if (dio->error) {
> @@ -308,7 +306,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		dio->size += n;
>  		copied += n;
>  
> -		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
> +		nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter,
> +						 BIO_MAX_PAGES);
>  		iomap_dio_submit_bio(dio, iomap, bio, pos);
>  		pos += n;
>  	} while (nr_pages);
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 1edda614f7ce..d8f9077c43ef 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -10,6 +10,7 @@
>  #include <linux/ioprio.h>
>  /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
>  #include <linux/blk_types.h>
> +#include <linux/uio.h>
>  
>  #define BIO_DEBUG
>  
> @@ -441,6 +442,15 @@ static inline void bio_wouldblock_error(struct bio *bio)
>  	bio_endio(bio);
>  }
>  
> +/*
> + * Calculate number of bvec segments that should be allocated to fit data
> + * pointed by @iter.
> + */
> +static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
> +{
> +	return iov_iter_npages(iter, max_segs);
> +}
> +
>  struct request_queue;
>  
>  extern int submit_bio_wait(struct bio *bio);
> -- 
> 2.24.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

