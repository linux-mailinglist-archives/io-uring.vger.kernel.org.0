Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CFD53C34A
	for <lists+io-uring@lfdr.de>; Fri,  3 Jun 2022 04:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiFCCng (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 22:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiFCCnf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 22:43:35 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C4C62F398;
        Thu,  2 Jun 2022 19:43:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AAE3710E6D17;
        Fri,  3 Jun 2022 12:43:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nwxHd-0021or-An; Fri, 03 Jun 2022 12:43:29 +1000
Date:   Fri, 3 Jun 2022 12:43:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v7 00/15] io-uring/xfs: support async buffered writes
Message-ID: <20220603024329.GI1098723@dread.disaster.area>
References: <20220601210141.3773402-1-shr@fb.com>
 <545ab14b-a95a-de2e-dbc6-f5688b09b47c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545ab14b-a95a-de2e-dbc6-f5688b09b47c@kernel.dk>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62997554
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=STQVsATjAyQOeSVB2IsA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 02, 2022 at 02:09:00AM -0600, Jens Axboe wrote:
> On 6/1/22 3:01 PM, Stefan Roesch wrote:
> > This patch series adds support for async buffered writes when using both
> > xfs and io-uring. Currently io-uring only supports buffered writes in the
> > slow path, by processing them in the io workers. With this patch series it is
> > now possible to support buffered writes in the fast path. To be able to use
> > the fast path the required pages must be in the page cache, the required locks
> > in xfs can be granted immediately and no additional blocks need to be read
> > form disk.
> 
> This series looks good to me now, but will need some slight rebasing
> since the 5.20 io_uring branch has split up the code a bit. Trivial to
> do though, I suspect it'll apply directly if we just change
> fs/io_uring.c to io_uring/rw.c instead.
> 
> The bigger question is how to stage this, as it's touching a bit of fs,
> mm, and io_uring...

What data integrity testing has this had? Has it been run through a
few billion fsx operations with w/ io_uring read/write enabled?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
