Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0ACC2DA563
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 02:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgLOBKI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 20:10:08 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44670 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728471AbgLOBKH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 20:10:07 -0500
X-Greylist: delayed 740 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2020 20:10:04 EST
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 456D0866D0;
        Tue, 15 Dec 2020 12:09:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1koyq9-0043JU-Or; Tue, 15 Dec 2020 12:09:21 +1100
Date:   Tue, 15 Dec 2020 12:09:21 +1100
From:   Dave Chinner <david@fromorbit.com>
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
Message-ID: <20201215010921.GH632069@dread.disaster.area>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <498b34d746627e874740d8315b2924880c46dbc3.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498b34d746627e874740d8315b2924880c46dbc3.1607976425.git.asml.silence@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=b_qWX-_W1d2Y0MqGxV0A:9 a=CjuIK1q_8ugA:10
        a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
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

This doesn't touch iomap code, so the title of the patch seems
wrong...

> +For bvec based itererators bio_iov_iter_get_pages() now doesn't copy bvecs but
> +uses the one provided. Anyone issuing kiocb-I/O should ensure that the bvec and
> +page references stay until I/O has completed, i.e. until ->ki_complete() has
> +been called or returned with non -EIOCBQUEUED code.

This is hard to follow. Perhaps:

bio_iov_iter_get_pages() uses the bvecs  provided for bvec based
iterators rather than copying them. Hence anyone issuing kiocb based
IO needs to ensure the bvecs and pages stay referenced until the
submitted I/O is completed by a call to ->ki_complete() or returns
with an error other than -EIOCBQUEUED.

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 2a9f3f0bbe0a..337f4280b639 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -444,6 +444,9 @@ static inline void bio_wouldblock_error(struct bio *bio)
>  
>  static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
>  {
> +	/* reuse iter->bvec */
> +	if (iov_iter_is_bvec(iter))
> +		return 0;
>  	return iov_iter_npages(iter, max_segs);

Ah, I'm a blind idiot... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
