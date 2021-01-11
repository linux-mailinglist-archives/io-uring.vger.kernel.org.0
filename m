Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D602F0B24
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 03:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbhAKCvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 21:51:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727157AbhAKCvL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 21:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610333384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zxAid7WiPvqjKj8F4tMeWzHfvAFa68eNjv+UadafvBY=;
        b=BNG31rWxdwxWY0+aCnpz0V5l/N95w+8jhEBvnrpOU4S8jI/Afs/TsuDXN69aS+2fpWQT6T
        +o2kIGkN3eqQo/IFQgLW4jYSwpJBXVAmDmqPeJZqJTWiDJz5138xSrlG5qUTuE19GV4Ui1
        3lb4xL3NiSZNkuQdsgkQu+pSVUMNp7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-j1tcgOlhP2iXb2n7lzgDXQ-1; Sun, 10 Jan 2021 21:49:40 -0500
X-MC-Unique: j1tcgOlhP2iXb2n7lzgDXQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7BB4180A093;
        Mon, 11 Jan 2021 02:49:37 +0000 (UTC)
Received: from T590 (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20AFC36807;
        Mon, 11 Jan 2021 02:49:25 +0000 (UTC)
Date:   Mon, 11 Jan 2021 10:49:20 +0800
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
Subject: Re: [PATCH v3 2/7] bvec/iter: disallow zero-length segment bvecs
Message-ID: <20210111024920.GC4147870@T590>
References: <cover.1610170479.git.asml.silence@gmail.com>
 <4570836cc62137a9ee788d9c820f58ed8efe9b37.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4570836cc62137a9ee788d9c820f58ed8efe9b37.1610170479.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 09, 2021 at 04:02:58PM +0000, Pavel Begunkov wrote:
> zero-length bvec segments are allowed in general, but not handled by bio
> and down the block layer so filtered out. This inconsistency may be
> confusing and prevent from optimisations. As zero-length segments are
> useless and places that were generating them are patched, declare them
> not allowed.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/block/biovecs.rst       | 2 ++
>  Documentation/filesystems/porting.rst | 7 +++++++
>  lib/iov_iter.c                        | 2 --
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/block/biovecs.rst b/Documentation/block/biovecs.rst
> index 36771a131b56..ddb867e0185b 100644
> --- a/Documentation/block/biovecs.rst
> +++ b/Documentation/block/biovecs.rst
> @@ -40,6 +40,8 @@ normal code doesn't have to deal with bi_bvec_done.
>     There is a lower level advance function - bvec_iter_advance() - which takes
>     a pointer to a biovec, not a bio; this is used by the bio integrity code.
>  
> +As of 5.12 bvec segments with zero bv_len are not supported.
> +
>  What's all this get us?
>  =======================
>  
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index 867036aa90b8..c722d94f29ea 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -865,3 +865,10 @@ no matter what.  Everything is handled by the caller.
>  
>  clone_private_mount() returns a longterm mount now, so the proper destructor of
>  its result is kern_unmount() or kern_unmount_array().
> +
> +---
> +
> +**mandatory**
> +
> +zero-length bvec segments are disallowed, they must be filtered out before
> +passed on to an iterator.
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 1635111c5bd2..7de304269641 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -72,8 +72,6 @@
>  	__start.bi_bvec_done = skip;			\
>  	__start.bi_idx = 0;				\
>  	for_each_bvec(__v, i->bvec, __bi, __start) {	\
> -		if (!__v.bv_len)			\
> -			continue;			\
>  		(void)(STEP);				\
>  	}						\
>  }
> -- 
> 2.24.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

