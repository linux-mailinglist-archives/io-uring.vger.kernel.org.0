Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00132F0B2B
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 03:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhAKCxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 21:53:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbhAKCxy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 21:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610333548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NmxIKId+VX6+cTF2RHQgxXMT+Y+5Xys40++ViI5AjPc=;
        b=QSQnnjERghwcTtto6QV0IuRif+m6Dj/XXeUCh0jpoh8HY4bVSFhpIAmjoIsmKhFdbiScA2
        uY6YhzedwpIPu1Yp/1uX7ZVHe5HiI07teKDVQ7E2mjO74gVWXwoQIsQofLdtmM15YPg8FD
        TTx60bySagMkHiMIdocPEd9E6tdhSRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-PYIOgBh0OiqZjtWVS1Btig-1; Sun, 10 Jan 2021 21:52:22 -0500
X-MC-Unique: PYIOgBh0OiqZjtWVS1Btig-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ED78801817;
        Mon, 11 Jan 2021 02:52:20 +0000 (UTC)
Received: from T590 (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5C561002391;
        Mon, 11 Jan 2021 02:52:09 +0000 (UTC)
Date:   Mon, 11 Jan 2021 10:52:05 +0800
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
Subject: Re: [PATCH v3 3/7] block/psi: remove PSI annotations from direct IO
Message-ID: <20210111025205.GD4147870@T590>
References: <cover.1610170479.git.asml.silence@gmail.com>
 <faad7d7f58ff45285eaac9af7fae9a5fcca98977.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faad7d7f58ff45285eaac9af7fae9a5fcca98977.1610170479.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 09, 2021 at 04:02:59PM +0000, Pavel Begunkov wrote:
> Direct IO does not operate on the current working set of pages managed
> by the kernel, so it should not be accounted as memory stall to PSI
> infrastructure.
> 
> The block layer and iomap direct IO use bio_iov_iter_get_pages()
> to build bios, and they are the only users of it, so to avoid PSI
> tracking for them clear out BIO_WORKINGSET flag. Do same for
> dio_bio_submit() because fs/direct_io constructs bios by hand directly
> calling bio_add_page().
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  block/bio.c    | 6 ++++++
>  fs/direct-io.c | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 1f2cc1fbe283..9f26984af643 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1099,6 +1099,9 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>   * fit into the bio, or are requested in @iter, whatever is smaller. If
>   * MM encounters an error pinning the requested pages, it stops. Error
>   * is returned only if 0 pages could be pinned.
> + *
> + * It's intended for direct IO, so doesn't do PSI tracking, the caller is
> + * responsible for setting BIO_WORKINGSET if necessary.
>   */
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  {
> @@ -1123,6 +1126,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  
>  	if (is_bvec)
>  		bio_set_flag(bio, BIO_NO_PAGE_REF);
> +
> +	/* don't account direct I/O as memory stall */
> +	bio_clear_flag(bio, BIO_WORKINGSET);
>  	return bio->bi_vcnt ? 0 : ret;
>  }
>  EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index d53fa92a1ab6..0e689233f2c7 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -426,6 +426,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
>  	unsigned long flags;
>  
>  	bio->bi_private = dio;
> +	/* don't account direct I/O as memory stall */
> +	bio_clear_flag(bio, BIO_WORKINGSET);
>  
>  	spin_lock_irqsave(&dio->bio_lock, flags);
>  	dio->refcount++;
> -- 
> 2.24.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

