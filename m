Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74162510C4E
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 00:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbiDZW6d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 18:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiDZW6c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 18:58:32 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C1F8FD2C;
        Tue, 26 Apr 2022 15:55:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C2E635358F5;
        Wed, 27 Apr 2022 08:55:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njU5X-004vXS-6A; Wed, 27 Apr 2022 08:55:19 +1000
Date:   Wed, 27 Apr 2022 08:55:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 10/18] xfs: Enable async write file modification
 handling.
Message-ID: <20220426225519.GR1544202@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-11-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426174335.4004987-11-shr@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62687858
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8
        a=MVNmPsfJR0OwgcQHr6QA:9 a=CjuIK1q_8ugA:10 a=i3VuKzQdj-NEYjvDI-p3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 26, 2022 at 10:43:27AM -0700, Stefan Roesch wrote:
> This modifies xfs write checks to return -EAGAIN if the request either
> requires to remove privileges or needs to update the file modification
> time. This is required for async buffered writes, so the request gets
> handled in the io worker.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/xfs/xfs_file.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5bddb1e9e0b3..6f9da1059e8b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -299,6 +299,43 @@ xfs_file_read_iter(
>  	return ret;
>  }
>  
> +static int xfs_file_modified(struct file *file, int flags)
> +{
> +	int ret;
> +	struct dentry *dentry = file_dentry(file);
> +	struct inode *inode = file_inode(file);
> +	struct timespec64 now = current_time(inode);
> +
> +	/*
> +	 * Clear the security bits if the process is not being run by root.
> +	 * This keeps people from modifying setuid and setgid binaries.
> +	 */
> +	ret = need_file_remove_privs(inode, dentry);
> +	if (ret < 0) {
> +		return ret;
> +	} else if (ret > 0) {
> +		if (flags & IOCB_NOWAIT)
> +			return -EAGAIN;
> +
> +		ret = do_file_remove_privs(file, inode, dentry, ret);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = need_file_update_time(inode, file, &now);
> +	if (ret <= 0)
> +		return ret;
> +	if (flags & IOCB_NOWAIT) {
> +		if (IS_PENDING_TIME(inode))
> +			return 0;
> +
> +		inode->i_flags |= S_PENDING_TIME;
> +		return -EAGAIN;
> +	}
> +
> +	return do_file_update_time(inode, file, &now, ret);
> +}

This has nothing XFS specific in it. It belongs in the VFS code.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
