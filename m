Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2A03EA876
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 18:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhHLQWO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 12:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhHLQWN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 12:22:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B21C0613D9;
        Thu, 12 Aug 2021 09:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GWh5pqEqpirmx4dApDAZ/sjyVFKTTJw8QZ1jZ5bMGH4=; b=DViOZLkvN/UhlfvUH+bvFP//TN
        bXR1R9unxuRpPWvkM6+hvSEEVjWZ011nb6srYU6f4WnP0lWHMHQvgmKtpDohdhiJxIaiI9WzB/bsj
        //MKDH2W5A0Ibf06pv9WLQ4mQC8GP/O8fOi+CokfkNPlfER06jLqQ3Yr7dGS/qyts5OL41abvh/sr
        IIH+8QJJ6JP+G5FRH/zHuBxKWl6f/rcr1gt7qXlsqCwKFuCZINLsbM7vzdJgOU3SRPxFW4SpZkk9R
        gLDbIvy0jH7EEujlV3BZPCIsAdsbRWs6Asd7/xASgNa8pDVTZcLjzP9IHrZFWlWB9w6Os7HJIGRcW
        z5Uy/u6w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEDRT-00Ekrx-Uq; Thu, 12 Aug 2021 16:20:44 +0000
Date:   Thu, 12 Aug 2021 17:20:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 2/6] fs: add kiocb alloc cache flag
Message-ID: <YRVKS7koMNN8/ceN@infradead.org>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812154149.1061502-3-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 12, 2021 at 09:41:45AM -0600, Jens Axboe wrote:
> If this kiocb can safely use the polled bio allocation cache, then this
> flag must be set. Generally this can be set for polled IO, where we will
> not see IRQ completions of the request.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
