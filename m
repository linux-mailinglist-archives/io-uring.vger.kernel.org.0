Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E802DA52C
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 02:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgLOBBj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 20:01:39 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44978 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730152AbgLOBBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 20:01:32 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 8A91C767651;
        Tue, 15 Dec 2020 12:00:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1koyhT-0043Dr-1k; Tue, 15 Dec 2020 12:00:23 +1100
Date:   Tue, 15 Dec 2020 12:00:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 5/6] bio: add a helper calculating nr segments to alloc
Message-ID: <20201215010023.GG632069@dread.disaster.area>
References: <cover.1607976425.git.asml.silence@gmail.com>
 <94b6f76d2d47569742ee47caede1504926f9807a.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b6f76d2d47569742ee47caede1504926f9807a.1607976425.git.asml.silence@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=PygYhtxudd0edJU1dj0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 15, 2020 at 12:20:24AM +0000, Pavel Begunkov wrote:
> A preparation patch. It adds a simple helper which abstracts out number
> of segments we're allocating for a bio from iov_iter_npages().

Preparation for what? bio_iov_vecs_to_alloc() doesn't seem to be
used outside this specific patch, so it's not clear what it's
actually needed for...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
