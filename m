Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7732C2F0B41
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 03:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbhAKC5h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 21:57:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726599AbhAKC5g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 21:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610333770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=onQJfcnQZI3n0IRzA+3EOlwFWN/kJ/oGb4nFVWDRu08=;
        b=IwNmyD//TCSuVb8x9cJDSVwjdCTNkCv2i1030FyL9Z2bYHa3IuYX+YuNro34sHPA+9jZph
        /6/GOSuSCApKQi/DGEMxxc56Q2455d0olV8RzUTmJIf5hFkrr7hThwk6DwFsOyR24Toctw
        vcByfTgO3EKDTPOyKrJfuOn/xvwTPCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-aAU8l4gwN5eYyxUAeqTxTA-1; Sun, 10 Jan 2021 21:56:06 -0500
X-MC-Unique: aAU8l4gwN5eYyxUAeqTxTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28920180A093;
        Mon, 11 Jan 2021 02:56:04 +0000 (UTC)
Received: from T590 (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4910A36807;
        Mon, 11 Jan 2021 02:55:52 +0000 (UTC)
Date:   Mon, 11 Jan 2021 10:55:48 +0800
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
Subject: Re: [PATCH v3 5/7] iov_iter: optimise bvec iov_iter_advance()
Message-ID: <20210111025548.GF4147870@T590>
References: <cover.1610170479.git.asml.silence@gmail.com>
 <58552e3ba333650ccd425823cb9dc0b949350959.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58552e3ba333650ccd425823cb9dc0b949350959.1610170479.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 09, 2021 at 04:03:01PM +0000, Pavel Begunkov wrote:
> iov_iter_advance() is heavily used, but implemented through generic
> means. For bvecs there is a specifically crafted function for that, so
> use bvec_iter_advance() instead, it's faster and slimmer.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  lib/iov_iter.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 7de304269641..9b1c109dc8a9 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -1065,6 +1065,21 @@ static void pipe_advance(struct iov_iter *i, size_t size)
>  	pipe_truncate(i);
>  }
>  
> +static void iov_iter_bvec_advance(struct iov_iter *i, size_t size)
> +{
> +	struct bvec_iter bi;
> +
> +	bi.bi_size = i->count;
> +	bi.bi_bvec_done = i->iov_offset;
> +	bi.bi_idx = 0;
> +	bvec_iter_advance(i->bvec, &bi, size);
> +
> +	i->bvec += bi.bi_idx;
> +	i->nr_segs -= bi.bi_idx;
> +	i->count = bi.bi_size;
> +	i->iov_offset = bi.bi_bvec_done;
> +}
> +
>  void iov_iter_advance(struct iov_iter *i, size_t size)
>  {
>  	if (unlikely(iov_iter_is_pipe(i))) {
> @@ -1075,6 +1090,10 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
>  		i->count -= size;
>  		return;
>  	}
> +	if (iov_iter_is_bvec(i)) {
> +		iov_iter_bvec_advance(i, size);
> +		return;
> +	}
>  	iterate_and_advance(i, size, v, 0, 0, 0)
>  }
>  EXPORT_SYMBOL(iov_iter_advance);
> -- 
> 2.24.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

