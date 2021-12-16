Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20704777CD
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbhLPQQB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239275AbhLPQP7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:15:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E3FC061756
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WlhizxSLgT5efNt7Y+j1gKxLFWAt+hl7g1lx9qTqfFg=; b=R/LazvOyi5epj/R9kIwviusyEX
        tobitCSu1L2Q/FRd0vYSX0fBN+OYOMBSpzk3qIwll8f9zMoiCHoRc8EHn7w77smt0OG5ikw1R/nD2
        8Y2muc7xufsS2lO86S8EtaByvIjbuuoeZENzs554R/G2v37iR2DKLUi8JM6o/TCpHp+5eKWA2YSw6
        TO9lEOhtbdsZtmuOdsAyOYpQiA3EH2xt+4S7QvoB1Zm9B8unFEWP6Rq0lqITAzxSkq1aEJ4s0A3h4
        l6/yY6lhVgSA3r03jS2aE0xKW9ePv/+kL55kuYEPmCR6QbUeqLNYnJvhw2bHoNQzoLHsJtrRxPqsK
        XyR9jGSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxtQE-006Xq4-Qi; Thu, 16 Dec 2021 16:15:58 +0000
Date:   Thu, 16 Dec 2021 08:15:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Message-ID: <YbtmPjisO5RIAnby@infradead.org>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk>
 <YbsB/W/1Uwok4i0u@infradead.org>
 <83aa4715-7bf8-4ed1-6945-3910cb13f233@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83aa4715-7bf8-4ed1-6945-3910cb13f233@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 16, 2021 at 08:45:46AM -0700, Jens Axboe wrote:
> On 12/16/21 2:08 AM, Christoph Hellwig wrote:
> > On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
> >> +	spin_lock(&nvmeq->sq_lock);
> >> +	while (!rq_list_empty(*rqlist)) {
> >> +		struct request *req = rq_list_pop(rqlist);
> >> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> >> +
> >> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
> >> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
> >> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
> >> +			nvmeq->sq_tail = 0;
> > 
> > So this doesn't even use the new helper added in patch 2?  I think this
> > should call nvme_sq_copy_cmd().
> 
> But you NAK'ed that one? It definitely should use that helper, so I take it
> you are fine with it then if we do it here too? That would make 3 call sites,
> and I still do think the helper makes sense...

I explained two times that the new helpers is fine as long as you open
code nvme_submit_cmd in its two callers as it now is a trivial wrapper.
