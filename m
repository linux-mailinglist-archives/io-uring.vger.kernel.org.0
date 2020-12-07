Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3B32D0929
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 03:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgLGCWS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 21:22:18 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56600 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgLGCWR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 21:22:17 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F17033C27C7;
        Mon,  7 Dec 2020 13:21:31 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1km69a-001IYe-K5; Mon, 07 Dec 2020 13:21:30 +1100
Date:   Mon, 7 Dec 2020 13:21:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v3 RESEND] iomap: set REQ_NOWAIT according to IOCB_NOWAIT
 in Direct IO
Message-ID: <20201207022130.GC4170059@dread.disaster.area>
References: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=SRrdq9N9AAAA:8 a=6R7veym_AAAA:8
        a=7-415B0cAAAA:8 a=sZL_5JkcuqqlGEs8XqMA:9 a=CjuIK1q_8ugA:10
        a=ILCOIF4F_8SzUMnO7jNM:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 04, 2020 at 05:44:56PM +0800, Hao Xu wrote:
> Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
> when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
> IOCB_NOWAIT is set.
> 
> Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi all,
> I tested fio io_uring direct read for a file on ext4 filesystem on a
> nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
> means REQ_NOWAIT is not set in bio->bi_opf.

What iomap is doing is correct behaviour. IOCB_NOWAIT applies to the
filesystem behaviour, not the block device.

REQ_NOWAIT can result in partial IO failures because the error is
only reported to the iomap layer via IO completions. Hence we can
split a DIO into multiple bios and have random bios in that IO fail
with EAGAIN because REQ_NOWAIT is set. This error will
get reported to the submitter via completion, and it will override
any of the partial IOs that actually completed.

Hence, like the recently reported multi-mapping IOCB_NOWAIT bug
reported by Jens and fixed in commit 883a790a8440 ("xfs: don't allow
NOWAIT DIO across extent boundaries") we'll get silent partial
writes occurring because the second submitted bio in an IO can
trigger EAGAIN errors with partial IO completion having already
occurred.

Further, we don't allow partial IO completion for DIO on XFS at all.
DIO must be completely submitted and completed or return an error
without having issued any IO at all.  Hence using REQ_NOWAIT for
DIO bios is incorrect and not desirable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
