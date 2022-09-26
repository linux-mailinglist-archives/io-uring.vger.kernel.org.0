Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E08D5EABE7
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 18:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbiIZQDJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbiIZQCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 12:02:35 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DD97E83C;
        Mon, 26 Sep 2022 07:50:44 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AA18068AFE; Mon, 26 Sep 2022 16:50:40 +0200 (CEST)
Date:   Mon, 26 Sep 2022 16:50:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v7 4/5] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220926145040.GA20424@lst.de>
References: <20220909102136.3020-1-joshi.k@samsung.com> <CGME20220909103147epcas5p2a83ec151333bcb1d2abb8c7536789bfd@epcas5p2.samsung.com> <20220909102136.3020-5-joshi.k@samsung.com> <20220920120802.GC2809@lst.de> <20220922152331.GA24701@test-zns> <20220923152941.GA21275@lst.de> <20220923184349.GA3394@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923184349.GA3394@test-zns>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Sep 24, 2022 at 12:13:49AM +0530, Kanchan Joshi wrote:
> And efficency is the concern as we are moving to more heavyweight
> helper that 'handles' weird conditions rather than just 'bails out'.
> These alignment checks end up adding a loop that traverses
> the entire ITER_BVEC.
> Also blk_rq_map_user_iov uses bio_iter_advance which also seems
> cycle-consuming given below code-comment in io_import_fixed():

No one says you should use the existing loop in blk_rq_map_user_iov.
Just make it call your new helper early on when a ITER_BVEC iter is
passed in.

> Do you see good way to trigger this virt-alignment condition? I have
> not seen this hitting (the SG gap checks) when running with fixebufs.

You'd need to make sure the iovec passed to the fixed buffer
registration is chunked up smaller than the nvme page size.

E.g. if you pass lots of non-contiguous 512 byte sized iovecs to the
buffer registration.

>> We just need to implement the equivalent functionality for bvecs.  It
>> isn't really hard, it just wasn't required so far.
>
> Can the virt-boundary alignment gap exist for ITER_BVEC iter in first
> place?

Yes.  bvecs are just a way to represent data.  If the individual
segments don't fit the virt boundary you still need to deal with it.
