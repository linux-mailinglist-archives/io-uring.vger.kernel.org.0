Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761CF524F6A
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 16:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354521AbiELOGl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 10:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355105AbiELOG3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 10:06:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E545220BE9
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 07:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652364387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fapy0UzsV2+71SQNFiB4udMttlhpXoFXgY5ze6Kye/Q=;
        b=JEcrYAuHkLwfcxgjzy2d7wWlgNUkLaNNDtoihLJHzJO/ilxPrpXQmRjjGEN1LAtyG5txP7
        WJYlqr48Mm17b/I3Rd3venY2ssy06iXGR4JxPbwZzDGzfJEFghOp/BuhFncmUyo52NXsYz
        ymYxvvaFoEc+aTQRzKAKBElfjjxJi9A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-PtHoMGhoPWWXSmIe7LPpsg-1; Thu, 12 May 2022 10:06:24 -0400
X-MC-Unique: PtHoMGhoPWWXSmIe7LPpsg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7193D3C92FD8;
        Thu, 12 May 2022 14:06:19 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCFDF5742E1;
        Thu, 12 May 2022 14:06:12 +0000 (UTC)
Date:   Thu, 12 May 2022 22:06:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, gost.dev@samsung.com
Subject: Re: [PATCH v5 2/6] block: wire-up support for passthrough plugging
Message-ID: <Yn0UT8/ymJPy2hBu@T590>
References: <20220511054750.20432-1-joshi.k@samsung.com>
 <CGME20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286@epcas5p4.samsung.com>
 <20220511054750.20432-3-joshi.k@samsung.com>
 <YnyaRB+u1x6nIVp1@T590>
 <20220512114623.GA11657@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512114623.GA11657@test-zns>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 12, 2022 at 05:20:47PM +0530, Anuj Gupta wrote:
> On Thu, May 12, 2022 at 01:25:24PM +0800, Ming Lei wrote:
> > Hello,
> > 
> > On Wed, May 11, 2022 at 11:17:46AM +0530, Kanchan Joshi wrote:
> > > From: Jens Axboe <axboe@kernel.dk>
> > > 
> > > Add support for plugging in passthrough path. When plugging is enabled, the
> > > requests are added to a plug instead of getting dispatched to the driver.
> > > And when the plug is finished, the whole batch gets dispatched via
> > > ->queue_rqs which turns out to be more efficient. Otherwise dispatching
> > > used to happen via ->queue_rq, one request at a time.
> > > 
> > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  block/blk-mq.c | 73 +++++++++++++++++++++++++++-----------------------
> > >  1 file changed, 39 insertions(+), 34 deletions(-)
> > > 
> > > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > > index 84d749511f55..2cf011b57cf9 100644
> > > --- a/block/blk-mq.c
> > > +++ b/block/blk-mq.c
> > > @@ -2340,6 +2340,40 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
> > >  	blk_mq_hctx_mark_pending(hctx, ctx);
> > >  }
> > >  
> > > +/*
> > > + * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
> > > + * queues. This is important for md arrays to benefit from merging
> > > + * requests.
> > > + */
> > > +static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
> > > +{
> > > +	if (plug->multiple_queues)
> > > +		return BLK_MAX_REQUEST_COUNT * 2;
> > > +	return BLK_MAX_REQUEST_COUNT;
> > > +}
> > > +
> > > +static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
> > > +{
> > > +	struct request *last = rq_list_peek(&plug->mq_list);
> > > +
> > > +	if (!plug->rq_count) {
> > > +		trace_block_plug(rq->q);
> > > +	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
> > > +		   (!blk_queue_nomerges(rq->q) &&
> > > +		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
> > > +		blk_mq_flush_plug_list(plug, false);
> > > +		trace_block_plug(rq->q);
> > > +	}
> > > +
> > > +	if (!plug->multiple_queues && last && last->q != rq->q)
> > > +		plug->multiple_queues = true;
> > > +	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
> > > +		plug->has_elevator = true;
> > > +	rq->rq_next = NULL;
> > > +	rq_list_add(&plug->mq_list, rq);
> > > +	plug->rq_count++;
> > > +}
> > > +
> > >  /**
> > >   * blk_mq_request_bypass_insert - Insert a request at dispatch list.
> > >   * @rq: Pointer to request to be inserted.
> > > @@ -2353,7 +2387,12 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
> > >  				  bool run_queue)
> > >  {
> > >  	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> > > +	struct blk_plug *plug = current->plug;
> > >  
> > > +	if (plug) {
> > > +		blk_add_rq_to_plug(plug, rq);
> > > +		return;
> > > +	}
> > 
> > This way may cause nested plugging, and breaks xfstests generic/131.
> > Also may cause io hang since request can't be polled before flushing
> > plug in blk_execute_rq().
> >
> Hi Ming,
> Could you please share your test setup.
> I tried test 131 with xfs and it passed.
> 
> I followed these steps:
> 1) mkfs.xfs -f /dev/nvme0n1
> 2) mount /dev/nvme0n1 /mnt/test
> 3) ./check tests/generic/131

It is triggered when I run xfstests over UBD & xfs:

https://github.com/ming1/linux/tree/my_for-5.18-ubd-devel_v2
https://github.com/ming1/ubdsrv/tree/devel-v2



Thanks,
Ming

