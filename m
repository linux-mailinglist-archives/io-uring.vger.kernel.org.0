Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6EC477B1C
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 18:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhLPRxn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 12:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhLPRxn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 12:53:43 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F161CC061574;
        Thu, 16 Dec 2021 09:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=PgqV9qLRip3EdzVCov4eBDh/UA
        JLfqa9Y+vId5eXl3enUMHo+FF+SEY4Eo5TAzU5Dpn5ccfhmLezJIsrTNuACCVpwVbKywZiHvxGX28
        sbyRX5K6asueGs2gRpV1Lpst7zzAtAagz1J7eARtTrel/gQ91yQ6DhmRtn4T/z8FyiYdmCgmnQ7jY
        RXzIBFww5EIlKhq9opme2GB6axDZvMk2kVoG8FDDWGJLeqyW0tRd/OCtA9UoJfd9bU6K4riIoWSHu
        xEt9A12YjkNoUSA1HUtb74kB0U6upBTz/IQp9xnF1risoljIJs9DOMa5+B2oBBXAp0+QCsWG2zS+g
        mwiCx9JA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxuwo-0072Tu-AU; Thu, 16 Dec 2021 17:53:42 +0000
Date:   Thu, 16 Dec 2021 09:53:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Message-ID: <Ybt9JuvfNNQFt09w@infradead.org>
References: <20211216163901.81845-1-axboe@kernel.dk>
 <20211216163901.81845-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216163901.81845-5-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
