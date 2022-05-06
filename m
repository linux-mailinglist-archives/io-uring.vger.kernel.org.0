Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C610B51D4AB
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 11:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390653AbiEFJdt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 05:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390575AbiEFJde (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 05:33:34 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A350B65D27;
        Fri,  6 May 2022 02:29:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D916110E6631;
        Fri,  6 May 2022 19:29:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmuGx-008fB5-EV; Fri, 06 May 2022 19:29:15 +1000
Date:   Fri, 6 May 2022 19:29:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <20220506092915.GI1098723@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-12-shr@fb.com>
 <20220426225652.GS1544202@dread.disaster.area>
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
 <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6274ea6f
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8
        a=y0LPT60VOqdp-VbHO3cA:9 a=CjuIK1q_8ugA:10 a=i3VuKzQdj-NEYjvDI-p3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 02, 2022 at 02:21:17PM -0700, Stefan Roesch wrote:
> 
> 
> On 4/28/22 2:54 PM, Dave Chinner wrote:
> > On Thu, Apr 28, 2022 at 12:58:59PM -0700, Stefan Roesch wrote:
> >>
> >>
> >> On 4/26/22 3:56 PM, Dave Chinner wrote:
> >>> On Tue, Apr 26, 2022 at 10:43:28AM -0700, Stefan Roesch wrote:
> >>>> This adds the async buffered write support to XFS. For async buffered
> >>>> write requests, the request will return -EAGAIN if the ilock cannot be
> >>>> obtained immediately.
> >>>>
> >>>> Signed-off-by: Stefan Roesch <shr@fb.com>
> >>>> ---
> >>>>  fs/xfs/xfs_file.c | 10 ++++++----
> >>>>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> >>>> index 6f9da1059e8b..49d54b939502 100644
> >>>> --- a/fs/xfs/xfs_file.c
> >>>> +++ b/fs/xfs/xfs_file.c
> >>>> @@ -739,12 +739,14 @@ xfs_file_buffered_write(
> >>>>  	bool			cleared_space = false;
> >>>>  	int			iolock;
> >>>>  
> >>>> -	if (iocb->ki_flags & IOCB_NOWAIT)
> >>>> -		return -EOPNOTSUPP;
> >>>> -
> >>>>  write_retry:
> >>>>  	iolock = XFS_IOLOCK_EXCL;
> >>>> -	xfs_ilock(ip, iolock);
> >>>> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> >>>> +		if (!xfs_ilock_nowait(ip, iolock))
> >>>> +			return -EAGAIN;
> >>>> +	} else {
> >>>> +		xfs_ilock(ip, iolock);
> >>>> +	}
> >>>
> >>> xfs_ilock_iocb().
> >>>
> >>
> >> The helper xfs_ilock_iocb cannot be used as it hardcoded to use iocb->ki_filp to
> >> get a pointer to the xfs_inode.
> > 
> > And the problem with that is?
> > 
> > I mean, look at what xfs_file_buffered_write() does to get the
> > xfs_inode 10 lines about that change:
> > 
> > xfs_file_buffered_write(
> >         struct kiocb            *iocb,
> >         struct iov_iter         *from)
> > {
> >         struct file             *file = iocb->ki_filp;
> >         struct address_space    *mapping = file->f_mapping;
> >         struct inode            *inode = mapping->host;
> >         struct xfs_inode        *ip = XFS_I(inode);
> > 
> > In what cases does file_inode(iocb->ki_filp) point to a different
> > inode than iocb->ki_filp->f_mapping->host? The dio write path assumes
> > that file_inode(iocb->ki_filp) is correct, as do both the buffered
> > and dio read paths.
> > 
> > What makes the buffered write path special in that
> > file_inode(iocb->ki_filp) is not correctly set whilst
> > iocb->ki_filp->f_mapping->host is?
> > 
> 
> In the function xfs_file_buffered_write() the code calls the function 
> xfs_ilock(). The xfs_inode pointer that is passed in is iocb->ki_filp->f_mapping->host.
> The one used in xfs_ilock_iocb is ki_filp->f_inode.
> 
> After getting the lock, the code in xfs_file_buffered_write calls the
> function xfs_buffered_write_iomap_begin(). In this function the code
> calls xfs_ilock() for ki_filp->f_inode in exclusive mode.
> 
> If I replace the first xfs_ilock() call with xfs_ilock_iocb(), then it looks
> like I get a deadlock.
> 
> Am I missing something?

Yes. They take different locks. xfs_file_buffered_write() takes the
IOLOCK, xfs_buffered_write_iomap_begin() takes the ILOCK....

> I can:
> - replace the pointer to iocb with pointer to xfs_inode in the function xfs_ilock_iocb()
>   and also pass in the flags value as a parameter.
> or
> - create function xfs_ilock_inode(), which xfs_ilock_iocb() calls. The existing
>   calls will not need to change, only the xfs_ilock in xfs_file_buffered_write()
>   will use xfs_ilock_inode().

You're making this way more complex than it needs to be. As I said:

> > Regardless, if this is a problem, then just pass the XFS inode to
> > xfs_ilock_iocb() and this is a moot point.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
