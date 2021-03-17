Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676B333F62A
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 18:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhCQRAd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 13:00:33 -0400
Received: from verein.lst.de ([213.95.11.211]:38058 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232000AbhCQRAC (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Mar 2021 13:00:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6215468BEB; Wed, 17 Mar 2021 17:59:59 +0100 (CET)
Date:   Wed, 17 Mar 2021 17:59:59 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
Message-ID: <20210317165959.GA25097@lst.de>
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com> <20210316140126.24900-4-joshi.k@samsung.com> <20210317085258.GA19580@lst.de> <149d2bc7-ec80-2e51-7db1-15765f35a27f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149d2bc7-ec80-2e51-7db1-15765f35a27f@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 10:49:28AM -0600, Jens Axboe wrote:
> I will post it soon, only reason I haven't reposted is that I'm not that
> happy with how the sqe split is done (and that it's done in the first
> place). But I'll probably just post the current version for comments,
> and hopefully we can get it to where it needs to be soon.

Yes, I don't like that at all either.  I almost wonder if we should
use an entirely different format after opcode and flags, although
I suspect fd would be nice to have in the same spot as well.

On a related note: I think it really should have a generic cmd
dispatching mechanism like ioctls have, preferably even enforcing
the _IO* mechanism.
