Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4481703BB
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 17:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgBZQFD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 11:05:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44148 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgBZQFD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 11:05:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QFxPmQ164659;
        Wed, 26 Feb 2020 16:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/op6eB0GJIWmE5awTMCc59CC2KBIYmyjFl9AwZ4pu7w=;
 b=naP77yd3khxdk8GZLMAnBM9+66OE1nM0HX9YOPaVPvTUQo9FTpSZjsgCb1sZtAzHHi6x
 +kDw7rKpPQIdmkLUvH6IU0z6hIYhhULzizHu+ucWvFb3oZvOrrm0V8/kbD1Hf0T3FfLN
 VcL6ltG/47H6Sx5U0QYXGacqht02A9lPE/L2W4DlWAIrqpfXQRdB+deYNxf5NYOrieem
 NiyovZXLaLu9BnshaWlzd117Ba2M+ruKZsbZdcOrnENLFuhG5wVUvQw8+PU23pJlXxK9
 Uk9A/kkBqQKclzVZ4dh5Fn2C3CFkBgaFFmIDg0doMj9Cl4j7XgHHsYENi565rXlHGkF4 zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsncmny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:04:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QFwHOr052230;
        Wed, 26 Feb 2020 16:04:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcs5c4ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 16:04:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01QG4vYs020904;
        Wed, 26 Feb 2020 16:04:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 08:04:57 -0800
Date:   Wed, 26 Feb 2020 08:04:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Bob Liu <bob.liu@oracle.com>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 3/4] block_dev: support protect information passthrough
Message-ID: <20200226160456.GC8044@magnolia>
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-4-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226083719.4389-4-bob.liu@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260111
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 26, 2020 at 04:37:18PM +0800, Bob Liu wrote:
> Support protect information passed from use sapce, on direct io
> is considered now.
> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  fs/block_dev.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 69bf2fb..10e3299 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -348,6 +348,13 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
>  	loff_t pos = iocb->ki_pos;
>  	blk_qc_t qc = BLK_QC_T_NONE;
>  	int ret = 0;
> +	struct iovec *pi_iov;
> +
> +	if (iocb->ki_flags & IOCB_USE_PI) {
> +		ret = iter_slice_protect_info(iter, nr_pages, &pi_iov);
> +		if (ret)
> +			return -EINVAL;
> +	}
>  
>  	if ((pos | iov_iter_alignment(iter)) &
>  	    (bdev_logical_block_size(bdev) - 1))
> @@ -411,6 +418,16 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
>  				polled = true;
>  			}
>  
> +			/* Add protection information to bio */
> +			if (iocb->ki_flags & IOCB_USE_PI) {
> +				ret = bio_integrity_prep_from_iovec(bio, pi_iov);
> +				if (ret) {
> +					bio->bi_status = BLK_STS_IOERR;
> +					bio_endio(bio);

If you're just going to mash all the error codes into IOERR, then this
could very well become bio_io_error() ?

--D

> +					break;
> +				}
> +			}
> +
>  			qc = submit_bio(bio);
>  
>  			if (polled)
> -- 
> 2.9.5
> 
