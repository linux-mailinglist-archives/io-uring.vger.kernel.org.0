Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B044BD284
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 00:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbiBTXKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Feb 2022 18:10:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiBTXKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Feb 2022 18:10:46 -0500
X-Greylist: delayed 1935 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Feb 2022 15:10:24 PST
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C7AE24088
        for <io-uring@vger.kernel.org>; Sun, 20 Feb 2022 15:10:24 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2A65810C9283;
        Mon, 21 Feb 2022 09:38:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nLuqD-00ERtO-Bj; Mon, 21 Feb 2022 09:38:05 +1100
Date:   Mon, 21 Feb 2022 09:38:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/13] Support sync buffered writes for io-uring
Message-ID: <20220220223805.GA3061737@dread.disaster.area>
References: <20220218195739.585044-1-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218195739.585044-1-shr@fb.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6212c2cf
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=GGqh16oi515Bfc_p9agA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 18, 2022 at 11:57:26AM -0800, Stefan Roesch wrote:
> This patch series adds support for async buffered writes. Currently
> io-uring only supports buffered writes in the slow path, by processing
> them in the io workers. With this patch series it is now possible to
> support buffered writes in the fast path. To be able to use the fast
> path the required pages must be in the page cache or they can be loaded
> with noio. Otherwise they still get punted to the slow path.

Where's the filesystem support? You need to plumb in ext4 to this
bufferhead support, and add iomap/xfs support as well so we can
shake out all the problems with APIs and fallback paths that are
needed for full support of buffered writes via io_uring.

> If a buffered write request requires more than one page, it is possible
> that only part of the request can use the fast path, the resst will be
> completed by the io workers.

That's ugly, especially at the filesystem/iomap layer where we are
doing delayed allocation and so partial writes like this could have
significant extra impact. It opens up the possibility of things like
ENOSPC/EDQUOT mid-way through the write instead of being an up-front
error, and so there's lots more complexity in the failure/fallback
paths that the io_uring infrastructure will have to handle
correctly...

Also, it breaks the "atomic buffered write" design of iomap/XFS
where other readers and writers will only see whole completed writes
and not intermediate partial writes. This is where a lot of the bugs
in the DIO io_uring support were found (deadlocks, data corruptions,
etc), so there's a bunch of semantic and API issues that filesystems
require from io_uring that need to be sorted out before we think
about merge buffered write support...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
