Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943EF513E3A
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 23:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347944AbiD1V6B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 17:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiD1V6A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 17:58:00 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D462F46162;
        Thu, 28 Apr 2022 14:54:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-32-1.pa.nsw.optusnet.com.au [49.180.32.1])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CA0F810E5E76;
        Fri, 29 Apr 2022 07:54:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nkC5y-005hah-7B; Fri, 29 Apr 2022 07:54:42 +1000
Date:   Fri, 29 Apr 2022 07:54:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <20220428215442.GW1098723@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-12-shr@fb.com>
 <20220426225652.GS1544202@dread.disaster.area>
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=626b0d24
        a=0Ysg4n7SwsYHWQMxibB6iw==:117 a=0Ysg4n7SwsYHWQMxibB6iw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8
        a=VUOJFI46L-dW_0rXThcA:9 a=CjuIK1q_8ugA:10 a=i3VuKzQdj-NEYjvDI-p3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 28, 2022 at 12:58:59PM -0700, Stefan Roesch wrote:
> 
> 
> On 4/26/22 3:56 PM, Dave Chinner wrote:
> > On Tue, Apr 26, 2022 at 10:43:28AM -0700, Stefan Roesch wrote:
> >> This adds the async buffered write support to XFS. For async buffered
> >> write requests, the request will return -EAGAIN if the ilock cannot be
> >> obtained immediately.
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> ---
> >>  fs/xfs/xfs_file.c | 10 ++++++----
> >>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> >> index 6f9da1059e8b..49d54b939502 100644
> >> --- a/fs/xfs/xfs_file.c
> >> +++ b/fs/xfs/xfs_file.c
> >> @@ -739,12 +739,14 @@ xfs_file_buffered_write(
> >>  	bool			cleared_space = false;
> >>  	int			iolock;
> >>  
> >> -	if (iocb->ki_flags & IOCB_NOWAIT)
> >> -		return -EOPNOTSUPP;
> >> -
> >>  write_retry:
> >>  	iolock = XFS_IOLOCK_EXCL;
> >> -	xfs_ilock(ip, iolock);
> >> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> >> +		if (!xfs_ilock_nowait(ip, iolock))
> >> +			return -EAGAIN;
> >> +	} else {
> >> +		xfs_ilock(ip, iolock);
> >> +	}
> > 
> > xfs_ilock_iocb().
> > 
> 
> The helper xfs_ilock_iocb cannot be used as it hardcoded to use iocb->ki_filp to
> get a pointer to the xfs_inode.

And the problem with that is?

I mean, look at what xfs_file_buffered_write() does to get the
xfs_inode 10 lines about that change:

xfs_file_buffered_write(
        struct kiocb            *iocb,
        struct iov_iter         *from)
{
        struct file             *file = iocb->ki_filp;
        struct address_space    *mapping = file->f_mapping;
        struct inode            *inode = mapping->host;
        struct xfs_inode        *ip = XFS_I(inode);

In what cases does file_inode(iocb->ki_filp) point to a different
inode than iocb->ki_filp->f_mapping->host? The dio write path assumes
that file_inode(iocb->ki_filp) is correct, as do both the buffered
and dio read paths.

What makes the buffered write path special in that
file_inode(iocb->ki_filp) is not correctly set whilst
iocb->ki_filp->f_mapping->host is?

Regardless, if this is a problem, then just pass the XFS inode to
xfs_ilock_iocb() and this is a moot point.

> However here we need to use iocb->ki_filp->f_mapping->host.
> I'll split off new helper for this in the next version of the patch.

We don't need a new helper here, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
