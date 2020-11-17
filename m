Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D02B6BE3
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 18:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgKQRhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 12:37:32 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59342 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgKQRhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 12:37:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AHHXnYG056455;
        Tue, 17 Nov 2020 17:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IY3/6KzdYHanN7Re6CdruxnqdXw5CGdA0oxwdbfzXeM=;
 b=hxvbcotppMQ4KlaOkq9sy2shRFwCJr22LhWeLCo5Lt1SybqnlK3ma8rQwTKv6hBUm1a3
 ZfPMy7VqfNmCSvL+xZeuFgFgTBjYpEcBNkeOtttbpIJBrwXDsa1RSk3tZRQjxPZNmAM7
 twzofZJdOD6bCpBofoKjJ41HHtgsC8j4boNqSBl8dH0c8Jl4KZQ49OOmev+Mm2k3lVld
 IF9SjD/tpR8zQQtTrwdW2RK8UCciWab3FH5FjuV2fYlK5f8M6P/AdeMl7zZj2u2zr7Ar
 IqjWA34Ttw0v2/pGzYhXpp1EdFyNBoVY/u20QCVDmWDyOEL2/3vbEXeOEeDzkxbtS3rD SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vn3ueb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 17:37:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AHHZHAI016355;
        Tue, 17 Nov 2020 17:37:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34umcygcuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 17:37:21 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AHHbKuG022883;
        Tue, 17 Nov 2020 17:37:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Nov 2020 09:37:19 -0800
Date:   Tue, 17 Nov 2020 09:37:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v4 2/2] block,iomap: disable iopoll when split needed
Message-ID: <20201117173718.GB9688@magnolia>
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-3-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117075625.46118-3-jefflexu@linux.alibaba.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9808 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=2
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170127
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 17, 2020 at 03:56:25PM +0800, Jeffle Xu wrote:
> Both blkdev fs and iomap-based fs (ext4, xfs, etc.) currently support

$ ./scripts/get_maintainer.pl fs/iomap/direct-io.c
Christoph Hellwig <hch@infradead.org> (supporter:IOMAP FILESYSTEM LIBRARY)
"Darrick J. Wong" <darrick.wong@oracle.com> (supporter:IOMAP FILESYSTEM LIBRARY)
linux-xfs@vger.kernel.org (supporter:IOMAP FILESYSTEM LIBRARY)
linux-fsdevel@vger.kernel.org (supporter:IOMAP FILESYSTEM LIBRARY)
linux-kernel@vger.kernel.org (open list)

Please cc both iomap maintainers and the appropriate lists when you
propose changes to fs/iomap/.  At a bare minimum cc linux-fsdevel for
changes under fs/.

> sync iopoll. One single bio can contain at most BIO_MAX_PAGES, i.e. 256
> bio_vec. If the input iov_iter contains more than 256 segments, then
> one dio will be split into multiple bios, which may cause potential
> deadlock for sync iopoll.
> 
> When it comes to sync iopoll, the bio is submitted without REQ_NOWAIT
> flag set and the process may hang in blk_mq_get_tag() if the dio needs
> to be split into multiple bios and thus can rapidly exhausts the queue
> depth. The process has to wait for the completion of the previously
> allocated requests, which should be reaped by the following sync
> polling, and thus causing a potential deadlock.
> 
> In fact there's a subtle difference of handling of HIPRI IO between
> blkdev fs and iomap-based fs, when dio need to be split into multiple
> bios. blkdev fs will set REQ_HIPRI for only the last split bio, leaving
> the previous bios queued into normal hardware queues, and not causing
> the trouble described above. iomap-based fs will set REQ_HIPRI for all
> split bios, and thus may cause the potential deadlock described above.
> 
> Noted that though the analysis described above, currently blkdev fs and
> iomap-based fs won't trigger this potential deadlock. Because only
> preadv2(2)/pwritev2(2) are capable of *sync* polling as only these two
> can set RWF_NOWAIT. Currently the maximum number of iovecs of one single
> preadv2(2)/pwritev2(2) call is UIO_MAXIOV, i.e. 1024, while the minimum
> queue depth is BLKDEV_MIN_RQ i.e. 4. That means one
> preadv2(2)/pwritev2(2) call can submit at most 4 bios, which will fill
> up the queue depth *exactly* and thus there's no deadlock in this case.
> 
> However this constraint can be fragile. Disable iopoll when one dio need
> to be split into multiple bios.Though blkdev fs may not suffer this issue,
> still it may not make much sense to iopoll for big IO, since iopoll is
> initially for small size, latency sensitive IO.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  fs/block_dev.c       |  9 +++++++++
>  fs/iomap/direct-io.c | 10 ++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 9e84b1928b94..ed3f46e8fa91 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -436,6 +436,15 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
>  			break;
>  		}
>  
> +		/*
> +		 * The current dio needs to be split into multiple bios here.
> +		 * iopoll for split bio will cause subtle trouble such as
> +		 * hang when doing sync polling, while iopoll is initially
> +		 * for small size, latency sensitive IO. Thus disable iopoll
> +		 * if split needed.
> +		 */
> +		iocb->ki_flags &= ~IOCB_HIPRI;
> +
>  		if (!dio->multi_bio) {
>  			/*
>  			 * AIO needs an extra reference to ensure the dio
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 933f234d5bec..396ac0f91a43 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -309,6 +309,16 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
>  		copied += n;
>  
>  		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
> +		/*
> +		 * The current dio needs to be split into multiple bios here.
> +		 * iopoll for split bio will cause subtle trouble such as
> +		 * hang when doing sync polling, while iopoll is initially
> +		 * for small size, latency sensitive IO. Thus disable iopoll
> +		 * if split needed.
> +		 */
> +		if (nr_pages)
> +			dio->iocb->ki_flags &= ~IOCB_HIPRI;

Hmm, I was about to ask what happens if the user's HIPRI request gets
downgraded from polling mode, but the manpage doesn't say anything about
the kernel having to return an error if it can't use polling mode, so I
guess downgrading is...fine?

Well, maybe it isn't, since this also results in a downgrade when I send
a 1MB polled pwrite to my otherwise idle MegaSSD that has thousands of
queue depth.  I think?  <shrug> I'm not the one who uses polling mode,
fwiw.

--D

> +
>  		iomap_dio_submit_bio(dio, iomap, bio, pos);
>  		pos += n;
>  	} while (nr_pages);
> -- 
> 2.27.0
> 
