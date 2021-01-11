Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FDA2F0B52
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 04:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAKDCM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 22:02:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726494AbhAKDCL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 22:02:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610334045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8jASGmhPqP7RCSguFeH346nWqDqUB4CAsxCgAKu7Vfk=;
        b=MBDBeZYFfQ8S7LIWyGwTcswiCPo/koRVFgFADDBLNBSmYVt4n2sU312sDeR//2Rq3/MpdV
        f2hLJ5xNhhpbKfYnNq4BXMyUWN0zr7YQqHu5CInFOB2mErN8ywccGKAf3Vo8ScpQgN3YZK
        eaFGz5nKTMJLqaeuBlB9Hax1wQmDUR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-qjc6OIoQOX25COSuu0IfnA-1; Sun, 10 Jan 2021 22:00:40 -0500
X-MC-Unique: qjc6OIoQOX25COSuu0IfnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F2A7100C62C;
        Mon, 11 Jan 2021 03:00:28 +0000 (UTC)
Received: from T590 (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C971836807;
        Mon, 11 Jan 2021 03:00:19 +0000 (UTC)
Date:   Mon, 11 Jan 2021 11:00:14 +0800
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
Subject: Re: [PATCH v3 7/7] bio: don't copy bvec for direct IO
Message-ID: <20210111030014.GH4147870@T590>
References: <cover.1610170479.git.asml.silence@gmail.com>
 <69fef253b37fc44dd28c43398715e27cee5e0fe0.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69fef253b37fc44dd28c43398715e27cee5e0fe0.1610170479.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 09, 2021 at 04:03:03PM +0000, Pavel Begunkov wrote:
> The block layer spends quite a while in blkdev_direct_IO() to copy and
> initialise bio's bvec. However, if we've already got a bvec in the input
> iterator it might be reused in some cases, i.e. when new
> ITER_BVEC_FLAG_FIXED flag is set. Simple tests show considerable
> performance boost, and it also reduces memory footprint.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/filesystems/porting.rst |  9 ++++
>  block/bio.c                           | 67 ++++++++++++---------------
>  include/linux/bio.h                   |  5 +-
>  3 files changed, 42 insertions(+), 39 deletions(-)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index c722d94f29ea..1f8cf8e10b34 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -872,3 +872,12 @@ its result is kern_unmount() or kern_unmount_array().
>  
>  zero-length bvec segments are disallowed, they must be filtered out before
>  passed on to an iterator.
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
> index 9f26984af643..6f031a04b59a 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -960,21 +960,17 @@ void bio_release_pages(struct bio *bio, bool mark_dirty)
>  }
>  EXPORT_SYMBOL_GPL(bio_release_pages);
>  
> -static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
> +static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
>  {
> -	const struct bio_vec *bv = iter->bvec;
> -	unsigned int len;
> -	size_t size;
> -
> -	if (WARN_ON_ONCE(iter->iov_offset > bv->bv_len))
> -		return -EINVAL;
> -
> -	len = min_t(size_t, bv->bv_len - iter->iov_offset, iter->count);
> -	size = bio_add_page(bio, bv->bv_page, len,
> -				bv->bv_offset + iter->iov_offset);
> -	if (unlikely(size != len))
> -		return -EINVAL;
> -	iov_iter_advance(iter, size);
> +	WARN_ON_ONCE(BVEC_POOL_IDX(bio) != 0);
> +
> +	bio->bi_vcnt = iter->nr_segs;
> +	bio->bi_max_vecs = iter->nr_segs;
> +	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
> +	bio->bi_iter.bi_bvec_done = iter->iov_offset;
> +	bio->bi_iter.bi_size = iter->count;
> +
> +	iov_iter_advance(iter, iter->count);
>  	return 0;
>  }
>  
> @@ -1088,12 +1084,12 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>   * This takes either an iterator pointing to user memory, or one pointing to
>   * kernel pages (BVEC iterator). If we're adding user pages, we pin them and
>   * map them into the kernel. On IO completion, the caller should put those
> - * pages. If we're adding kernel pages, and the caller told us it's safe to
> - * do so, we just have to add the pages to the bio directly. We don't grab an
> - * extra reference to those pages (the user should already have that), and we
> - * don't put the page on IO completion. The caller needs to check if the bio is
> - * flagged BIO_NO_PAGE_REF on IO completion. If it isn't, then pages should be
> - * released.
> + * pages. For bvec based iterators bio_iov_iter_get_pages() uses the provided
> + * bvecs rather than copying them. Hence anyone issuing kiocb based IO needs
> + * to ensure the bvecs and pages stay referenced until the submitted I/O is
> + * completed by a call to ->ki_complete() or returns with an error other than
> + * -EIOCBQUEUED. The caller needs to check if the bio is flagged BIO_NO_PAGE_REF
> + * on IO completion. If it isn't, then pages should be released.
>   *
>   * The function tries, but does not guarantee, to pin as many pages as
>   * fit into the bio, or are requested in @iter, whatever is smaller. If
> @@ -1105,27 +1101,22 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>   */
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  {
> -	const bool is_bvec = iov_iter_is_bvec(iter);
> -	int ret;
> -
> -	if (WARN_ON_ONCE(bio->bi_vcnt))
> -		return -EINVAL;
> +	int ret = 0;
>  
> -	do {
> -		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
> -			if (WARN_ON_ONCE(is_bvec))
> -				return -EINVAL;
> -			ret = __bio_iov_append_get_pages(bio, iter);
> -		} else {
> -			if (is_bvec)
> -				ret = __bio_iov_bvec_add_pages(bio, iter);
> +	if (iov_iter_is_bvec(iter)) {
> +		if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
> +			return -EINVAL;
> +		bio_iov_bvec_set(bio, iter);
> +		bio_set_flag(bio, BIO_NO_PAGE_REF);
> +		return 0;
> +	} else {
> +		do {
> +			if (bio_op(bio) == REQ_OP_ZONE_APPEND)
> +				ret = __bio_iov_append_get_pages(bio, iter);
>  			else
>  				ret = __bio_iov_iter_get_pages(bio, iter);
> -		}
> -	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
> -
> -	if (is_bvec)
> -		bio_set_flag(bio, BIO_NO_PAGE_REF);
> +		} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
> +	}
>  
>  	/* don't account direct I/O as memory stall */
>  	bio_clear_flag(bio, BIO_WORKINGSET);
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index d8f9077c43ef..1d30572a8c53 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -444,10 +444,13 @@ static inline void bio_wouldblock_error(struct bio *bio)
>  
>  /*
>   * Calculate number of bvec segments that should be allocated to fit data
> - * pointed by @iter.
> + * pointed by @iter. If @iter is backed by bvec it's going to be reused
> + * instead of allocating a new one.
>   */
>  static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
>  {
> +	if (iov_iter_is_bvec(iter))
> +		return 0;
>  	return iov_iter_npages(iter, max_segs);
>  }
>  
> -- 
> 2.24.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

