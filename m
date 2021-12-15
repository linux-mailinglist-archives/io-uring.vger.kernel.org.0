Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1C4475F5A
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhLORax (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 12:30:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49532 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbhLOR3v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 12:29:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E9861A0A
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 17:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE16DC36AE2;
        Wed, 15 Dec 2021 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639589390;
        bh=Oq36IKLRKTieTX3kamPtv/WXJ0MMVlcCdINBXZEfdqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RrIAW7vTfPkrHs/Y1/uZ4YStT5dr1Oi0tmNY+i23WG8OV1h79RHesXA1Gy2s9Sn6h
         Fa0+APuuW22Nlwgih4hWDTDMPe2z1aliqgYzzLwR50rkHdyTo7tbTW7r0vljP9Gf1F
         vUCvXcnqXEC1YE9hOhJCNaZGddpOFHTzs3TFlXP/jp5RxFlKlhkZw8XZxv0sZSUwqP
         tJrcBDdgFHLXDWT5KL4bKhfXncXdGgdECqAeKF6OYWEMxsCBKEk9gePBK1wwMxrg8B
         cUyj7dgDBfmsNnljW1tfF7txwC+e2HtctbUsSksXBzM7PKSETT2mCotDKHF9rgu7Mj
         RSOzXlHRA3/MA==
Date:   Wed, 15 Dec 2021 09:29:47 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Message-ID: <20211215172947.GB4164278@dhcp-10-100-145-180.wdc.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215162421.14896-5-axboe@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
> +static bool nvme_prep_rq_batch(struct nvme_queue *nvmeq, struct request *req)
> +{
> +	/*
> +	 * We should not need to do this, but we're still using this to
> +	 * ensure we can drain requests on a dying queue.
> +	 */
> +	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
> +		return false;

The patch looks good:

Reviewed-by: Keith Busch <kbusch@kernel.org>

Now a side comment on the above snippet:

I was going to mention in v2 that you shouldn't need to do this for each
request since the queue enabling/disabling only happens while quiesced,
so the state doesn't change once you start a batch. But I realized
multiple hctx's can be in a single batch, so we have to check each of
them instead of just once. :(

I tried to remove this check entirely ("We should not need to do this",
after all), but that's not looking readily possible without just
creating an equivalent check in blk-mq: we can't end a particular
request in failure without draining whatever list it may be linked
within, and we don't know what list it's in when iterating allocated
hctx tags.

Do you happen to have any thoughts on how we could remove this check?
The API I was thinking of is something like "blk_mq_hctx_dead()" in
order to fail pending requests on that hctx without sending them to the
low-level driver so that it wouldn't need these kinds of per-IO checks.
