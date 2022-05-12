Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FFB524C85
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 14:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353589AbiELMSd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 08:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353588AbiELMSd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 08:18:33 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1304E2469F5
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 05:18:27 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220512121822epoutp016f16391f5da5f97f1e16adde176ee738~uWsIZO2dU2852528525epoutp018
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 12:18:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220512121822epoutp016f16391f5da5f97f1e16adde176ee738~uWsIZO2dU2852528525epoutp018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652357903;
        bh=rdRj1H6RQhhqPD9H/KcMD/zAmzUXc8wXmotwmhPc0k8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ckJqJgkUupS+S/0hvf2HY2vzuSA4dOBuvvQKxHDOmAYQBWV30/8c6wW6pdWG5h3pD
         P5UOU0AflSiI8EwSVualh2w7spBKnjgudcN/UJpzMlqiJHV4D1FV5EGmRPpgihwrYb
         AuIw2sCcwkn5DxIMWliMJ8b6VOWstte+KtAJG2MQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220512121822epcas5p352901ab17caca0aed72347840ceb6528~uWsH3mvhO1345613456epcas5p3V;
        Thu, 12 May 2022 12:18:22 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KzW5P5RClz4x9Pv; Thu, 12 May
        2022 12:18:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        91.F1.10063.20BFC726; Thu, 12 May 2022 21:18:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220512115606epcas5p44dc12b04dc5e5280201c783a761eafe6~uWYrmmaMW1202512025epcas5p4C;
        Thu, 12 May 2022 11:56:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220512115606epsmtrp2c6ca213698b90a79869bdb32cd48e817~uWYrlxBGE0758907589epsmtrp2i;
        Thu, 12 May 2022 11:56:06 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-b9-627cfb02a184
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.5B.08924.6D5FC726; Thu, 12 May 2022 20:56:06 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220512115604epsmtip2f3dc53d6e420382671308295eea11afe~uWYpzDTBl1924219242epsmtip2c;
        Thu, 12 May 2022 11:56:04 +0000 (GMT)
Date:   Thu, 12 May 2022 17:20:47 +0530
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, gost.dev@samsung.com
Subject: Re: [PATCH v5 2/6] block: wire-up support for passthrough plugging
Message-ID: <20220512114623.GA11657@test-zns>
MIME-Version: 1.0
In-Reply-To: <YnyaRB+u1x6nIVp1@T590>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmui7T75okg6e/1S3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLM6/PcxkMX/ZU3aLGxOeMlocmtzMZHH15QF2B26Pic3v
        2D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgjMq2yUhNTEktUkjN
        S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
        Z1OUX1qSqpCRX1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnfHsvkjBY6eKb89O
        sTcwHjbtYuTkkBAwkdh69SlTFyMXh5DAbkaJHy2LWCCcT4wS688+YIdwPjNKnO88xQzTcmbT
        DGaIxC5GiVObrrOAJIQEnjFKNJ8T7WLk4GARUJWYclgCJMwmoC5x5HkrI4gtIqAkcffuarCh
        zCDla9raWUESwgLeEqcObQCzeQV0Je7uuwRlC0qcnPkEbD6ngIrE1uXTweKiAsoSB7YdB7tb
        QmAPh8Scw/PZIa5zkZiydC3UpcISr45vgYpLSXx+t5cNws6W2DPvBwuEXSAx88h2JgjbXuLi
        nr9gNrNAhsSKxrtQcVmJqafWQcX5JHp/P4GK80rsmAdjK0m0r5wDZUtI7D3XwAQKCAkBD4lT
        TdmQwLrMKHF43Wr2CYzys5D8NgvJOghbR2LB7k9ss4DamQWkJZb/44AwNSXW79JfwMi6ilEy
        taA4Nz212LTAMC+1HB7fyfm5mxjBSVnLcwfj3Qcf9A4xMnEwHmKU4GBWEuGtaa5JEuJNSays
        Si3Kjy8qzUktPsRoCoyricxSosn5wLyQVxJvaGJpYGJmZmZiaWxmqCTOezp9Q6KQQHpiSWp2
        ampBahFMHxMHp1QDU2SgQ6/Pv2xmkzlPPtusNjRmWfpR12Rz6PYWtpS46F9rrOby3niz5aDY
        OlvWD+xbt6Vsd8/bOcPgU2mJyVKRM5cO1q+OXBke5nfeoP/ei4lbo5J4E39fsaycnF7H4/vo
        ius+9qCT5Q6Pa3sZJBgyjmuUvP5k/kEhmH+z7hlpAcGP/8Jal5os4Z4Svtq/+yQfy7R7uXPM
        71xlfKjalVuva7zB+eON7SnJwQbPmFek3n7Nb3g9rXzrWQmXp0zrr7evWrXDtK2gUrCSZ3n7
        LXfu3591jzdUhHOW7P1+ue/1xUgmrQjvG4JF+SUXvk9aqWlx7ojwc66rDyf/azWZdvqn4cR9
        Oxq+X7SqPj9Xkau9QomlOCPRUIu5qDgRACHsIdVTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXvfa15okg1tnhSzmrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLM6/PcxkMX/ZU3aLGxOeMlocmtzMZHH15QF2B26Pic3v
        2D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgjOKySUnNySxLLdK3
        S+DKaNr7lq1gsUNFy8k5TA2Mc4y7GDk5JARMJM5smsHcxcjFISSwg1Fi7sFXTBAJCYlTL5cx
        QtjCEiv/PWeHKHrCKLFl9XHWLkYODhYBVYkphyVAatgE1CWOPG8FqxcRUJK4e3c1WD2zwDNG
        iQVPvoMNFRbwljh1aAMriM0roCtxd98lVoihVxkl/j2ezAyREJQ4OfMJC4jNLKAlcePfSyaQ
        ZcwC0hLL/3GAhDkFVCS2Lp8ONkdUQFniwLbjTBMYBWch6Z6FpHsWQvcCRuZVjJKpBcW56bnF
        hgVGeanlesWJucWleel6yfm5mxjBEaWltYNxz6oPeocYmTgYDzFKcDArifDWNNckCfGmJFZW
        pRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cCkOanD+4yP5aMzGbe7
        +yfduri2/V/6dOlTcccS7x1rF5G6sVKe+8LPdqmWtos+j17vrRKz/CG9kXvzsm9zd2xP+ati
        scvxDtd0Efu3ISw2T94zRj5SqjLpNufpuBh+e8n2U+bvTd1k3weoHTs/5airm5n10n06lx9L
        bD63PEBi/sbD3ls+shqk897o/Pfg74olBc9E1u5oDLPxn1Q6XcahLHyZNmPLonU9TMtzI7dP
        5jTO5X5+cM+W8JK+Wh0H32svCl8c9v85qTFky+zFd6JyDNxNVteeXpat8+fcqpemh/9aSfrc
        /Lus/d+KwrLVWR2y6RkTRTNEM7UV4vbpSj6a2Tj5+I3VnzrXl/O2s34vUWIpzkg01GIuKk4E
        AIGvnK0XAwAA
X-CMS-MailID: 20220512115606epcas5p44dc12b04dc5e5280201c783a761eafe6
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_67a5b_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286
References: <20220511054750.20432-1-joshi.k@samsung.com>
        <CGME20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286@epcas5p4.samsung.com>
        <20220511054750.20432-3-joshi.k@samsung.com> <YnyaRB+u1x6nIVp1@T590>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_67a5b_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, May 12, 2022 at 01:25:24PM +0800, Ming Lei wrote:
> Hello,
> 
> On Wed, May 11, 2022 at 11:17:46AM +0530, Kanchan Joshi wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> > 
> > Add support for plugging in passthrough path. When plugging is enabled, the
> > requests are added to a plug instead of getting dispatched to the driver.
> > And when the plug is finished, the whole batch gets dispatched via
> > ->queue_rqs which turns out to be more efficient. Otherwise dispatching
> > used to happen via ->queue_rq, one request at a time.
> > 
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  block/blk-mq.c | 73 +++++++++++++++++++++++++++-----------------------
> >  1 file changed, 39 insertions(+), 34 deletions(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 84d749511f55..2cf011b57cf9 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -2340,6 +2340,40 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
> >  	blk_mq_hctx_mark_pending(hctx, ctx);
> >  }
> >  
> > +/*
> > + * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
> > + * queues. This is important for md arrays to benefit from merging
> > + * requests.
> > + */
> > +static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
> > +{
> > +	if (plug->multiple_queues)
> > +		return BLK_MAX_REQUEST_COUNT * 2;
> > +	return BLK_MAX_REQUEST_COUNT;
> > +}
> > +
> > +static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
> > +{
> > +	struct request *last = rq_list_peek(&plug->mq_list);
> > +
> > +	if (!plug->rq_count) {
> > +		trace_block_plug(rq->q);
> > +	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
> > +		   (!blk_queue_nomerges(rq->q) &&
> > +		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
> > +		blk_mq_flush_plug_list(plug, false);
> > +		trace_block_plug(rq->q);
> > +	}
> > +
> > +	if (!plug->multiple_queues && last && last->q != rq->q)
> > +		plug->multiple_queues = true;
> > +	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
> > +		plug->has_elevator = true;
> > +	rq->rq_next = NULL;
> > +	rq_list_add(&plug->mq_list, rq);
> > +	plug->rq_count++;
> > +}
> > +
> >  /**
> >   * blk_mq_request_bypass_insert - Insert a request at dispatch list.
> >   * @rq: Pointer to request to be inserted.
> > @@ -2353,7 +2387,12 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
> >  				  bool run_queue)
> >  {
> >  	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> > +	struct blk_plug *plug = current->plug;
> >  
> > +	if (plug) {
> > +		blk_add_rq_to_plug(plug, rq);
> > +		return;
> > +	}
> 
> This way may cause nested plugging, and breaks xfstests generic/131.
> Also may cause io hang since request can't be polled before flushing
> plug in blk_execute_rq().
>
Hi Ming,
Could you please share your test setup.
I tried test 131 with xfs and it passed.

I followed these steps:
1) mkfs.xfs -f /dev/nvme0n1
2) mount /dev/nvme0n1 /mnt/test
3) ./check tests/generic/131

Tried the same with ext4 and it passed as well.

Thanks,
Anuj

> I'd suggest to apply the plug in blk_execute_rq_nowait(), such as:
> 
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2cf011b57cf9..60c29c0229d5 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1169,6 +1169,62 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
>  	complete(waiting);
>  }
>  
> +/*
> + * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
> + * queues. This is important for md arrays to benefit from merging
> + * requests.
> + */
> +static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
> +{
> +	if (plug->multiple_queues)
> +		return BLK_MAX_REQUEST_COUNT * 2;
> +	return BLK_MAX_REQUEST_COUNT;
> +}
> +
> +static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
> +{
> +	struct request *last = rq_list_peek(&plug->mq_list);
> +
> +	if (!plug->rq_count) {
> +		trace_block_plug(rq->q);
> +	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
> +		   (!blk_queue_nomerges(rq->q) &&
> +		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
> +		blk_mq_flush_plug_list(plug, false);
> +		trace_block_plug(rq->q);
> +	}
> +
> +	if (!plug->multiple_queues && last && last->q != rq->q)
> +		plug->multiple_queues = true;
> +	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
> +		plug->has_elevator = true;
> +	rq->rq_next = NULL;
> +	rq_list_add(&plug->mq_list, rq);
> +	plug->rq_count++;
> +}
> +
> +static void __blk_execute_rq_nowait(struct request *rq, bool at_head,
> +		rq_end_io_fn *done, bool use_plug)
> +{
> +	WARN_ON(irqs_disabled());
> +	WARN_ON(!blk_rq_is_passthrough(rq));
> +
> +	rq->end_io = done;
> +
> +	blk_account_io_start(rq);
> +
> +	if (use_plug && current->plug) {
> +		blk_add_rq_to_plug(current->plug, rq);
> +		return;
> +	}
> +	/*
> +	 * don't check dying flag for MQ because the request won't
> +	 * be reused after dying flag is set
> +	 */
> +	blk_mq_sched_insert_request(rq, at_head, true, false);
> +}
> +
> +
>  /**
>   * blk_execute_rq_nowait - insert a request to I/O scheduler for execution
>   * @rq:		request to insert
> @@ -1184,18 +1240,8 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
>   */
>  void blk_execute_rq_nowait(struct request *rq, bool at_head, rq_end_io_fn *done)
>  {
> -	WARN_ON(irqs_disabled());
> -	WARN_ON(!blk_rq_is_passthrough(rq));
> -
> -	rq->end_io = done;
> -
> -	blk_account_io_start(rq);
> +	__blk_execute_rq_nowait(rq, at_head, done, true);
>  
> -	/*
> -	 * don't check dying flag for MQ because the request won't
> -	 * be reused after dying flag is set
> -	 */
> -	blk_mq_sched_insert_request(rq, at_head, true, false);
>  }
>  EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
>  
> @@ -1234,7 +1280,7 @@ blk_status_t blk_execute_rq(struct request *rq, bool at_head)
>  	unsigned long hang_check;
>  
>  	rq->end_io_data = &wait;
> -	blk_execute_rq_nowait(rq, at_head, blk_end_sync_rq);
> +	__blk_execute_rq_nowait(rq, at_head, blk_end_sync_rq, false);
>  
>  	/* Prevent hang_check timer from firing at us during very long I/O */
>  	hang_check = sysctl_hung_task_timeout_secs;
> @@ -2340,40 +2386,6 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  	blk_mq_hctx_mark_pending(hctx, ctx);
>  }
>  
> -/*
> - * Allow 2x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
> - * queues. This is important for md arrays to benefit from merging
> - * requests.
> - */
> -static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
> -{
> -	if (plug->multiple_queues)
> -		return BLK_MAX_REQUEST_COUNT * 2;
> -	return BLK_MAX_REQUEST_COUNT;
> -}
> -
> -static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
> -{
> -	struct request *last = rq_list_peek(&plug->mq_list);
> -
> -	if (!plug->rq_count) {
> -		trace_block_plug(rq->q);
> -	} else if (plug->rq_count >= blk_plug_max_rq_count(plug) ||
> -		   (!blk_queue_nomerges(rq->q) &&
> -		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
> -		blk_mq_flush_plug_list(plug, false);
> -		trace_block_plug(rq->q);
> -	}
> -
> -	if (!plug->multiple_queues && last && last->q != rq->q)
> -		plug->multiple_queues = true;
> -	if (!plug->has_elevator && (rq->rq_flags & RQF_ELV))
> -		plug->has_elevator = true;
> -	rq->rq_next = NULL;
> -	rq_list_add(&plug->mq_list, rq);
> -	plug->rq_count++;
> -}
> -
>  /**
>   * blk_mq_request_bypass_insert - Insert a request at dispatch list.
>   * @rq: Pointer to request to be inserted.
> @@ -2387,12 +2399,7 @@ void blk_mq_request_bypass_insert(struct request *rq, bool at_head,
>  				  bool run_queue)
>  {
>  	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> -	struct blk_plug *plug = current->plug;
>  
> -	if (plug) {
> -		blk_add_rq_to_plug(plug, rq);
> -		return;
> -	}
>  	spin_lock(&hctx->lock);
>  	if (at_head)
>  		list_add(&rq->queuelist, &hctx->dispatch);
> 
> 
> Thanks,
> Ming
> 
> 

------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_67a5b_
Content-Type: text/plain; charset="utf-8"


------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_67a5b_--
