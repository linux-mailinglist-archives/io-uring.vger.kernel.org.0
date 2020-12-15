Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB292DA51C
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgLOA5z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:57:55 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:35785 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728773AbgLOA5z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:57:55 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 0B3671B3D05;
        Tue, 15 Dec 2020 11:57:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1koyeB-00438t-3k; Tue, 15 Dec 2020 11:56:59 +1100
Date:   Tue, 15 Dec 2020 11:56:59 +1100
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
Subject: Re: [PATCH v1 4/6] block/psi: remove PSI annotations from direct IO
Message-ID: <20201215005659.GF632069@dread.disaster.area>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <1d3cf86668e44b3a3d35b5dbe759a086a157e434.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d3cf86668e44b3a3d35b5dbe759a086a157e434.1607976425.git.asml.silence@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=JfrnYn6hAAAA:8 a=ufHFDILaAAAA:8
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=x5prtoG_kTW6hDg4jekA:9
        a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=ZmIg1sZ3JBWsdXgziEIF:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 15, 2020 at 12:20:23AM +0000, Pavel Begunkov wrote:
> As reported, we must not do pressure stall information accounting for
> direct IO, because otherwise it tells that it's thrashing a page when
> actually doing IO on hot data.
> 
> Apparently, bio_iov_iter_get_pages() is used only by paths doing direct
> IO, so just make it avoid setting BIO_WORKINGSET, it also saves us CPU
> cycles on doing that. For fs/direct-io.c just clear the flag before
> submit_bio(), it's not of much concern performance-wise.
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  block/bio.c    | 25 ++++++++++++++++---------
>  fs/direct-io.c |  2 ++
>  2 files changed, 18 insertions(+), 9 deletions(-)
.....
> @@ -1099,6 +1103,9 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>   * fit into the bio, or are requested in @iter, whatever is smaller. If
>   * MM encounters an error pinning the requested pages, it stops. Error
>   * is returned only if 0 pages could be pinned.
> + *
> + * It also doesn't set BIO_WORKINGSET, so is intended for direct IO. If used
> + * otherwise the caller is responsible to do that to keep PSI happy.
>   */
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  {
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index d53fa92a1ab6..914a7f600ecd 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -426,6 +426,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
>  	unsigned long flags;
>  
>  	bio->bi_private = dio;
> +	/* PSI is only for paging IO */
> +	bio_clear_flag(bio, BIO_WORKINGSET);

Why only do this for the old direct IO path? Why isn't this
necessary for the iomap DIO path?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
