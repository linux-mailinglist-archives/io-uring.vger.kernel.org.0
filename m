Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF121E68E9
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2020 19:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405676AbgE1R4D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 13:56:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405666AbgE1R4C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 13:56:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SHWB8p183841;
        Thu, 28 May 2020 17:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Vtk1hI60ceUqtfvvIssc64/X2M+5Zc6s3CCA7Ch7H/s=;
 b=t561ZdNZeLWgHo2cppHZZ2OxxnqjM2w7fvoAFV+MC5hwpEERhkGN1RmVOKh6/8aaSmLV
 qnKQ/myHGb2j4QKdDSn1MPPhFkPCuImNQ/Sk4KtXxdpZ3OX5eka/KOJ90SkXxWzshIbG
 q+gJHZmlV12SbSDhoDeZsjA3BCJQjTv+s5AhKLhyfsNxcsowVnUZGmfmzTyWUu5Z8xIx
 3n4GOKYo7/bu86kDsgB3eGjnOI1h21F0fCtb9TbCJx8XdAvLswCSrJNEo3JJTAi8t88f
 lvDCuprlYo2sRg92M1LeBj4rEccjwJYJA+4ViKUKjdQElobaLrcg6sHOZkYFr7bo+xtJ Ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 318xe1peqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 17:55:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SHWwPL158636;
        Thu, 28 May 2020 17:53:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 317ds30m4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 17:53:56 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04SHrtAe010100;
        Thu, 28 May 2020 17:53:55 GMT
Received: from localhost (/10.159.250.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 May 2020 10:53:54 -0700
Date:   Thu, 28 May 2020 10:53:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 09/12] xfs: flag files as supporting buffered async reads
Message-ID: <20200528175353.GB8204@magnolia>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-10-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-10-axboe@kernel.dk>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=1 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280122
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:20PM -0600, Jens Axboe wrote:
> XFS uses generic_file_read_iter(), which already supports this.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Er... I guess that looks ok?  Assuming you've done enough qa on
io_uring to be able to tell if this breaks anything, since touching the
mm always feels murky to me:

Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4b8bdecc3863..97f44fbf17f2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1080,7 +1080,7 @@ xfs_file_open(
>  		return -EFBIG;
>  	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
>  		return -EIO;
> -	file->f_mode |= FMODE_NOWAIT;
> +	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
>  	return 0;
>  }
>  
> -- 
> 2.26.2
> 
