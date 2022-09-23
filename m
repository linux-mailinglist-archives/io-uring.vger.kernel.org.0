Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE0C5E7E65
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 17:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiIWP3t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 11:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiIWP3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 11:29:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B34A26110;
        Fri, 23 Sep 2022 08:29:45 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9479867373; Fri, 23 Sep 2022 17:29:41 +0200 (CEST)
Date:   Fri, 23 Sep 2022 17:29:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v7 4/5] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220923152941.GA21275@lst.de>
References: <20220909102136.3020-1-joshi.k@samsung.com> <CGME20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd@epcas5p2.samsung.com> <20220909102136.3020-5-joshi.k@samsung.com> <20220920120802.GC2809@lst.de> <20220922152331.GA24701@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922152331.GA24701@test-zns>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 22, 2022 at 08:53:31PM +0530, Kanchan Joshi wrote:
>> blk_rq_map_user_iov really should be able to detect that it is called
>> on a bvec iter and just do the right thing rather than needing different
>> helpers.
>
> I too explored that possibility, but found that it does not. It maps the
> user-pages into bio either directly or by doing that copy (in certain odd
> conditions) but does not know how to deal with existing bvec.

What do you mean with existing bvec?  We allocate a brand new bio here
that we want to map the next chunk of the iov_iter to, and that
is exactly what blk_rq_map_user_iov does.  What blk_rq_map_user_iov
currently does not do is to implement this mapping efficiently
for ITER_BVEC iters, but that is something that could and should
be fixed.

> And it really felt cleaner to me write a new function rather than 
> overloading the blk_rq_map_user_iov with multiple if/else canals.

No.  The whole point of the iov_iter is to support this "overload".

> But iov_iter_gap_alignment does not work on bvec iters. Line #1274 below

So we'll need to fix it.

> 1264 unsigned long iov_iter_gap_alignment(const struct iov_iter *i)
> 1265 {
> 1266         unsigned long res = 0;
> 1267         unsigned long v = 0;
> 1268         size_t size = i->count;
> 1269         unsigned k;
> 1270
> 1271         if (iter_is_ubuf(i))
> 1272                 return 0;
> 1273
> 1274         if (WARN_ON(!iter_is_iovec(i)))
> 1275                 return ~0U;
>
> Do you see a way to overcome this. Or maybe this can be revisted as we
> are not missing a lot?

We just need to implement the equivalent functionality for bvecs.  It
isn't really hard, it just wasn't required so far.
