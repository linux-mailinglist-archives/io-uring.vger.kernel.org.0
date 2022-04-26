Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B15510C52
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 00:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242612AbiDZXAD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 19:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiDZXAC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 19:00:02 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59A582FFFE;
        Tue, 26 Apr 2022 15:56:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8A89410E5DF1;
        Wed, 27 Apr 2022 08:56:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njU72-004vYA-Du; Wed, 27 Apr 2022 08:56:52 +1000
Date:   Wed, 27 Apr 2022 08:56:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <20220426225652.GS1544202@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-12-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426174335.4004987-12-shr@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=626878b5
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8
        a=8LbIn2TR6hID6WZiys8A:9 a=CjuIK1q_8ugA:10 a=i3VuKzQdj-NEYjvDI-p3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 26, 2022 at 10:43:28AM -0700, Stefan Roesch wrote:
> This adds the async buffered write support to XFS. For async buffered
> write requests, the request will return -EAGAIN if the ilock cannot be
> obtained immediately.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/xfs/xfs_file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 6f9da1059e8b..49d54b939502 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -739,12 +739,14 @@ xfs_file_buffered_write(
>  	bool			cleared_space = false;
>  	int			iolock;
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT)
> -		return -EOPNOTSUPP;
> -
>  write_retry:
>  	iolock = XFS_IOLOCK_EXCL;
> -	xfs_ilock(ip, iolock);
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, iolock))
> +			return -EAGAIN;
> +	} else {
> +		xfs_ilock(ip, iolock);
> +	}

xfs_ilock_iocb().

-Dave.

-- 
Dave Chinner
david@fromorbit.com
