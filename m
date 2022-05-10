Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97050520A85
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 03:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiEJBQH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 21:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiEJBQF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 21:16:05 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4476A184314;
        Mon,  9 May 2022 18:12:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 97FD910E642B;
        Tue, 10 May 2022 11:12:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1noEQ1-00A6hb-TO; Tue, 10 May 2022 11:12:05 +1000
Date:   Tue, 10 May 2022 11:12:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <20220510011205.GR1098723@dread.disaster.area>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-12-shr@fb.com>
 <20220426225652.GS1544202@dread.disaster.area>
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
 <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
 <20220506092915.GI1098723@dread.disaster.area>
 <31f09969-2277-6692-b204-f884dc65348f@fb.com>
 <20220509232425.GQ1098723@dread.disaster.area>
 <20220509234424.GX27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509234424.GX27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6279bbe8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=a8yGhtGJrI05I1NV0l8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 09, 2022 at 04:44:24PM -0700, Darrick J. Wong wrote:
> On Tue, May 10, 2022 at 09:24:25AM +1000, Dave Chinner wrote:
> > On Mon, May 09, 2022 at 12:32:59PM -0700, Stefan Roesch wrote:
> > > On 5/6/22 2:29 AM, Dave Chinner wrote:
> > > > On Mon, May 02, 2022 at 02:21:17PM -0700, Stefan Roesch wrote:
> > > >> On 4/28/22 2:54 PM, Dave Chinner wrote:
> > > >>> On Thu, Apr 28, 2022 at 12:58:59PM -0700, Stefan Roesch wrote:
> > > >> - replace the pointer to iocb with pointer to xfs_inode in the function xfs_ilock_iocb()
> > > >>   and also pass in the flags value as a parameter.
> > > >> or
> > > >> - create function xfs_ilock_inode(), which xfs_ilock_iocb() calls. The existing
> > > >>   calls will not need to change, only the xfs_ilock in xfs_file_buffered_write()
> > > >>   will use xfs_ilock_inode().
> > > > 
> > > > You're making this way more complex than it needs to be. As I said:
> > > > 
> > > >>> Regardless, if this is a problem, then just pass the XFS inode to
> > > >>> xfs_ilock_iocb() and this is a moot point.
> > > > 
> > > 
> > > The function xfs_ilock_iocb() is expecting a pointer to the data structure kiocb, not
> > > a pointer to xfs_inode. I don't see how that's possible without changing the signature
> > > of xfs_ilock_iocb().
> > 
> > For the *third time*: pass the xfs_inode to xfs_ilock_iocb() and
> > update all the callers to do the same thing.
> 
> I still don't understand why /any/ of this is necessary.  When does
> iocb->ki_filp->f_inode != iocb->ki_filp->f_mapping->host? 

I already asked that question because I don't know the answer,
either. I suspect the answer is "block dev inodes" but that then
just raises the question of "how do we get them here?" and I don't
know the answer to that, either. I don't have the time to dig into
this and I don't expect anyone to just pop up with an answer,
either. So in the mean time, we can just ignore it for the purpose
of this patch set...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
