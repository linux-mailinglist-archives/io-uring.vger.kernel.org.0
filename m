Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3D9527BDE
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 04:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiEPCYi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 22:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiEPCYh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 22:24:37 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 172786170;
        Sun, 15 May 2022 19:24:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1684810E6863;
        Mon, 16 May 2022 12:24:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nqQPO-00CUgo-7b; Mon, 16 May 2022 12:24:30 +1000
Date:   Mon, 16 May 2022 12:24:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH v1 11/18] xfs: add async buffered write support
Message-ID: <20220516022430.GN1098723@dread.disaster.area>
References: <20220426225652.GS1544202@dread.disaster.area>
 <30f2920c-5262-7cb0-05b5-6e84a76162a7@fb.com>
 <20220428215442.GW1098723@dread.disaster.area>
 <19d411e5-fe1f-a3f8-36e0-87284a1c02f3@fb.com>
 <20220506092915.GI1098723@dread.disaster.area>
 <31f09969-2277-6692-b204-f884dc65348f@fb.com>
 <20220509232425.GQ1098723@dread.disaster.area>
 <20220509234424.GX27195@magnolia>
 <20220510011205.GR1098723@dread.disaster.area>
 <YnoKnyzqe3D70zoE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnoKnyzqe3D70zoE@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6281b5e1
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=DHH_LnhFxZYg_yueRooA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 09, 2022 at 11:47:59PM -0700, Christoph Hellwig wrote:
> On Tue, May 10, 2022 at 11:12:05AM +1000, Dave Chinner wrote:
> > > I still don't understand why /any/ of this is necessary.  When does
> > > iocb->ki_filp->f_inode != iocb->ki_filp->f_mapping->host? 
> > 
> > I already asked that question because I don't know the answer,
> > either. I suspect the answer is "block dev inodes" but that then
> > just raises the question of "how do we get them here?" and I don't
> > know the answer to that, either. I don't have the time to dig into
> > this and I don't expect anyone to just pop up with an answer,
> > either. So in the mean time, we can just ignore it for the purpose
> > of this patch set...
> 
> Weird device nodes (including block device) is the answer.  It never
> happens for a normal file system file struct that we'd see in XFS.

Ok, so we can just use XFS_I(file_inode(iocb->ki_filp)) then and we
don't need to pass the xfs_inode at all. We probably should convert
the rest of the io path to do this as well so we don't end up
forgetting this again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
