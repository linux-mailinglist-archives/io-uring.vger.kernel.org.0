Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B8C513DCF
	for <lists+io-uring@lfdr.de>; Thu, 28 Apr 2022 23:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352379AbiD1VsJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Apr 2022 17:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiD1VsI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Apr 2022 17:48:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFA4AC0D33;
        Thu, 28 Apr 2022 14:44:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-32-1.pa.nsw.optusnet.com.au [49.180.32.1])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3C0335346DB;
        Fri, 29 Apr 2022 07:44:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nkBwQ-005hUG-6G; Fri, 29 Apr 2022 07:44:50 +1000
Date:   Fri, 29 Apr 2022 07:44:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 06/18] xfs: add iomap async buffered write support
Message-ID: <20220428214450.GV1098723@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-7-shr@fb.com>
 <20220426225436.GQ1544202@dread.disaster.area>
 <8b71929a-895d-fdab-468d-541eaa8b4128@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b71929a-895d-fdab-468d-541eaa8b4128@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=626b0ad3
        a=0Ysg4n7SwsYHWQMxibB6iw==:117 a=0Ysg4n7SwsYHWQMxibB6iw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8
        a=mWO3IjDmtEUxHnED9hsA:9 a=CjuIK1q_8ugA:10 a=L5iZDtUwO0cA:10
        a=i3VuKzQdj-NEYjvDI-p3:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 28, 2022 at 01:03:49PM -0700, Stefan Roesch wrote:
> 
> 
> On 4/26/22 3:54 PM, Dave Chinner wrote:
> > On Tue, Apr 26, 2022 at 10:43:23AM -0700, Stefan Roesch wrote:
> >> This adds the async buffered write support to the iomap layer of XFS. If
> >> a lock cannot be acquired or additional reads need to be performed, the
> >> request will return -EAGAIN in case this is an async buffered write request.
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> ---
> >>  fs/xfs/xfs_iomap.c | 33 +++++++++++++++++++++++++++++++--
> >>  1 file changed, 31 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> >> index e552ce541ec2..80b6c48e88af 100644
> >> --- a/fs/xfs/xfs_iomap.c
> >> +++ b/fs/xfs/xfs_iomap.c
> >> @@ -881,18 +881,28 @@ xfs_buffered_write_iomap_begin(
> >>  	bool			eof = false, cow_eof = false, shared = false;
> >>  	int			allocfork = XFS_DATA_FORK;
> >>  	int			error = 0;
> >> +	bool			no_wait = (flags & IOMAP_NOWAIT);
> >>  
> >>  	if (xfs_is_shutdown(mp))
> >>  		return -EIO;
> >>  
> >>  	/* we can't use delayed allocations when using extent size hints */
> >> -	if (xfs_get_extsz_hint(ip))
> >> +	if (xfs_get_extsz_hint(ip)) {
> >> +		if (no_wait)
> >> +			return -EAGAIN;
> >> +
> >>  		return xfs_direct_write_iomap_begin(inode, offset, count,
> >>  				flags, iomap, srcmap);
> > 
> > Why can't we do IOMAP_NOWAIT allocation here?
> > xfs_direct_write_iomap_begin() supports IOMAP_NOWAIT semantics just
> > fine - that's what the direct IO path uses...
> 
> I'll make that change in the next version.
> > 
> >> +	}
> >>  
> >>  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> >>  
> >> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >> +	if (no_wait) {
> >> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> >> +			return -EAGAIN;
> >> +	} else {
> >> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> >> +	}
> > 
> > handled by xfs_ilock_for_iomap().
> 
> The helper xfs_ilock_for_iomap cannot be used for this purpose. The function
> xfs_ilock_for_iomap tries to deduce the lock mode. For the function xfs_file_buffered_write()
> the lock mode must be exclusive. However this is not always the case when the
> helper xfs_ilock_for_iomap is used. There are cases where xfs_is_cow_inode(() is not
> true.

That's trivially fixed by having the caller initialise the lock_mode
to what they want, rather than have the function set the initial
type to SHARED....

> I'll add a new helper that will be used here.

... so I don't think a new helper is needed.

--Dave.
-- 
Dave Chinner
david@fromorbit.com
