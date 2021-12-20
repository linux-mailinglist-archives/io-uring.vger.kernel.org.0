Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35B47B46C
	for <lists+io-uring@lfdr.de>; Mon, 20 Dec 2021 21:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhLTUgz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 15:36:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39864 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhLTUgy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 15:36:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35466B80EAF
        for <io-uring@vger.kernel.org>; Mon, 20 Dec 2021 20:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82B0C36AE7;
        Mon, 20 Dec 2021 20:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640032612;
        bh=cmt8iiwTichM0pX39LXzYDIDjPQN0t91l/bFA5y8vi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mz0dxk2BnvHicDHS5vDYj86dticCxGR65TVAlnkz3wnwRL3xoaZviYw0oxOCs6bBf
         AZXpdOjoFLCWRboI5gA5cBenw0V5FbFBj5xN86ePuk75d2gZnt+aev6E5VYWHupQOJ
         Gsvb2+4xux+lwoWwuhWl1xFMLKCV95TQ4y0nLRhIBHOoUiXkeBBPFjR1zrPVzr0e+x
         T3+J2hSJbV14QqO++TPs8UBcidIaFKSlyJnoBWaxOrxuF4KAA5x4JulHPkdF53GSJb
         1nQeA9sQPGYE0V0y1YxHniA3/an2QXq7H04mAd+HkNsLzvQJQalWt7/5Aa69gtbEne
         N7hudojBRPrNA==
Date:   Mon, 20 Dec 2021 12:36:49 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/4] block: add mq_ops->queue_rqs hook
Message-ID: <20211220203649.GA4170598@dhcp-10-100-145-180.wdc.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215162421.14896-2-axboe@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 15, 2021 at 09:24:18AM -0700, Jens Axboe wrote:
> +		/*
> +		 * Peek first request and see if we have a ->queue_rqs() hook.
> +		 * If we do, we can dispatch the whole plug list in one go. We
> +		 * already know at this point that all requests belong to the
> +		 * same queue, caller must ensure that's the case.
> +		 *
> +		 * Since we pass off the full list to the driver at this point,
> +		 * we do not increment the active request count for the queue.
> +		 * Bypass shared tags for now because of that.
> +		 */
> +		if (q->mq_ops->queue_rqs &&
> +		    !(rq->mq_hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
> +			blk_mq_run_dispatch_ops(q,
> +				q->mq_ops->queue_rqs(&plug->mq_list));

I think we still need to verify the queue isn't quiesced within
blk_mq_run_dispatch_ops()'s rcu protected area, prior to calling
.queue_rqs(). Something like below. Or is this supposed to be the
low-level drivers responsibility now?

---
+void __blk_mq_flush_plug_list(struct request_queue *q, struct blk_plug *plug)
+{
+	if (blk_queue_quiesced(q))
+		return;
+	q->mq_ops->queue_rqs(&plug->mq_list);
+}
+
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct blk_mq_hw_ctx *this_hctx;
@@ -2580,7 +2587,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		if (q->mq_ops->queue_rqs &&
 		    !(rq->mq_hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
 			blk_mq_run_dispatch_ops(q,
-				q->mq_ops->queue_rqs(&plug->mq_list));
+				__blk_mq_flush_plug_list(q, plug));
 			if (rq_list_empty(plug->mq_list))
 				return;
 		}
--
