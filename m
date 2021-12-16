Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0717C476CDB
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 10:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhLPJIO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 04:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhLPJIO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 04:08:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFA3C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 01:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h/AKyVJpvvulYpJylUQM8JxzavXlAuaKFGs3SV1295k=; b=z0O3QlTZdJTYDngsSiBDhIGbiE
        YB6GfPgXvPa0Qi2GOBaa/9oMhQJ2OGp/A76kJ/q0MVVmXcNizPPfh4V6rkqdqEfmfhpktRvRjKjvl
        TPkzw7sO8FwJ+mz9G6QePavZ6bOUoi64CsplpeALOyNjZBCi84JPQj5NWziUGXxQ3n+Rbyi6S4asp
        qiRGAoNhMQDAWAihmvoGoK4wfDM+4CETek93y7vveSpXafc5Ny0CIVwFoas+eeMiVwV85PqClu7H7
        F1OxBLgYpOY/jOGGzk/FwekYGFnQQo0Y77JaLyJXz6VmSlPqRQIUg6M/qv+QjH7CWr9VLygAFU4UG
        Y0s/l1Fg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxmkH-004JLF-Ck; Thu, 16 Dec 2021 09:08:13 +0000
Date:   Thu, 16 Dec 2021 01:08:13 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Message-ID: <YbsB/W/1Uwok4i0u@infradead.org>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215162421.14896-5-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
> +	spin_lock(&nvmeq->sq_lock);
> +	while (!rq_list_empty(*rqlist)) {
> +		struct request *req = rq_list_pop(rqlist);
> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> +
> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
> +			nvmeq->sq_tail = 0;

So this doesn't even use the new helper added in patch 2?  I think this
should call nvme_sq_copy_cmd().

The rest looks identical to the incremental patch I posted, so I guess
the performance degration measured on the first try was a measurement
error?
