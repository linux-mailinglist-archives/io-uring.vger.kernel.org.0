Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46451403422
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 08:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347675AbhIHGRm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 02:17:42 -0400
Received: from verein.lst.de ([213.95.11.211]:38054 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232146AbhIHGRl (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 8 Sep 2021 02:17:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6D92F67373; Wed,  8 Sep 2021 08:16:32 +0200 (CEST)
Date:   Wed, 8 Sep 2021 08:16:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        hare@suse.de
Subject: Re: [RFC PATCH 6/6] nvme: enable passthrough with fixed-buffer
Message-ID: <20210908061631.GB28505@lst.de>
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125937epcas5p15667b460e28d87bd40400f69005aafe3@epcas5p1.samsung.com> <20210805125539.66958-7-joshi.k@samsung.com> <20210907075055.GE29874@lst.de> <CA+1E3rJsrBjpS8mNTg3jk2VWDCZ54OsbB4LC8zZaVeaN0dr2dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJsrBjpS8mNTg3jk2VWDCZ54OsbB4LC8zZaVeaN0dr2dA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 07, 2021 at 10:17:53PM +0530, Kanchan Joshi wrote:
> I'll do away with that comment. But sorry, what part do you think
> should rather move to io_uring. Is that for the whole helper
> "nvme_rq_map_user_fixed"?

Yes.  Nothing nvme-specific in it.  Given that it only makes sense
to be used for io_uring support moving it to io_uring.c might make
sense. Or conditionally to block/blk-map.c.
