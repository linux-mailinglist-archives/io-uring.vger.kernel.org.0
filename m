Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1102D3BAE
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 07:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgLIGvZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 01:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbgLIGvZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 01:51:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDA4C0613CF;
        Tue,  8 Dec 2020 22:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p3OfvBVBtRAqDDRF6jH5uPYTH91JIUpZ9ujYw2CtzVk=; b=g9JtDQAysQXn5mU2ddEzM0Yz5X
        P0zL8DTzb0K6qveIRiZOvKGrPalspGEXG5XQvVJFn1HUW8Xbc82Z4Eih/aVBu92sIDrYNyKwElnMj
        C30/WIr2b5j+YXLZhuo9wLDMX+5Rtopo8rbf+4+QlewnIsTrzzHXRIqe3Bkx3lqWfef9Ngn/NwPDI
        Q6Z63bXV4xlz46pj18EXMDR2z6K3sr9RSj7Mnf/Nvtk9TqcX/Ef3mGgdvfxg+KmWDVNgVXOzq6sA1
        d3p0rvFQdNOF0cyN5mPJt+B7iY+6Dkv1RqNBayBOb4fgELniBnPEWNN6ldEYGeTaZcnfoUzU/gCVQ
        zR3SN0AA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmtJA-0007Oz-Ky; Wed, 09 Dec 2020 06:50:40 +0000
Date:   Wed, 9 Dec 2020 06:50:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/2] nocopy bvec for direct IO
Message-ID: <20201209065040.GA27959@infradead.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1607477897.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 09, 2020 at 02:19:50AM +0000, Pavel Begunkov wrote:
> A benchmark got me 430KIOPS vs 540KIOPS, or +25% on bare metal. And perf
> shows that bio_iov_iter_get_pages() was taking ~20%. The test is pretty
> silly, but still imposing. I'll redo it closer to reality for next
> iteration, anyway need to double check some cases.

That is pretty impressive.  But I only got this cover letter, not the
actual patches..
