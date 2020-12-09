Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACF22D477B
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 18:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbgLIRHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 12:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731151AbgLIRHK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 12:07:10 -0500
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD2C0613CF;
        Wed,  9 Dec 2020 09:06:29 -0800 (PST)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn2v4-0006Lh-BZ; Wed, 09 Dec 2020 17:06:26 +0000
Date:   Wed, 9 Dec 2020 17:06:26 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/2] nocopy bvec for direct IO
Message-ID: <20201209170626.GO3579531@ZenIV.linux.org.uk>
References: <cover.1607477897.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1607477897.git.asml.silence@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 09, 2020 at 02:19:50AM +0000, Pavel Begunkov wrote:
> The idea is to avoid copying, merging, etc. bvec from iterator to bio
> in direct I/O and use the one we've already got. Hook it up for io_uring.
> Had an eye on it for a long, and it also was brought up by Matthew
> just recently. Let me know if I forgot or misplaced some tags.
> 
> A benchmark got me 430KIOPS vs 540KIOPS, or +25% on bare metal. And perf
> shows that bio_iov_iter_get_pages() was taking ~20%. The test is pretty
> silly, but still imposing. I'll redo it closer to reality for next
> iteration, anyway need to double check some cases.
> 
> If same applied to iomap, common chunck can be moved from block_dev
> into bio_iov_iter_get_pages(), but if there any benefit for filesystems,
> they should explicitly opt in with ITER_BVEC_FLAG_FIXED.

To reiterate what hch said - this "opt in" is wrong.  Out-of-tree
code that does async IO on bvec-backed iov_iter, setting it up on
its own will have to adapt, that all.

iov_iter and its users are already in serious need of simplification
and cleanups; piling more on top of that would be a bloody bad idea.

Proposed semantics change for bvec-backed iov_iter makes a lot of sense,
so let's make sure that everything in tree can live with it, document
the change and switch to better semantics.

This thing should be unconditional.  Document it in D/f/porting and
if something out of tree complains, it's their problem - not ours.
