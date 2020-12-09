Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478042D3DA1
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 09:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgLIIks (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 03:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgLIIks (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 03:40:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0D9C0613CF;
        Wed,  9 Dec 2020 00:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yQKPtpXCASkE2tUo7CFKOoPdXuOQe2z1SqQtIjAyMlE=; b=AcdhD7xYdQ9N6uRgqFgFDm1ma+
        8im5Py0culOZnMkJaqIt1VWNAqmGBvF6IpOh/bNOhVmhrQi4HjTDGDGVcech4VWQmRgQgiwgn0K2U
        nAobRvRF0H/zry9vV0HYDA0q5z07rymIO3XlvIt3FzNCWQoOTjrO+8LysWexJ0psADmKULChmGSfI
        EG5FhpuC4O0tUCafbiA61hqTA/drvaEvvvpGxNLC5p3fsnSQhf5u2rO1Ivw9+gZZA0tIeiHaot6Rj
        WoGki88wkgRts60nR6RvLCYFaw+dlGNkzpQJH0r3a8qEZp1cja8OsdVCxS1lwr+5mxKY514XoVcKg
        hNfdYEmQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmv13-0006Ij-Ig; Wed, 09 Dec 2020 08:40:05 +0000
Date:   Wed, 9 Dec 2020 08:40:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] block: no-copy bvec for direct IO
Message-ID: <20201209084005.GC21968@infradead.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	/*
> +	 * In practice groups of pages tend to be accessed/reclaimed/refaulted
> +	 * together. To not go over bvec for those who didn't set BIO_WORKINGSET
> +	 * approximate it by looking at the first page and inducing it to the
> +	 * whole bio
> +	 */
> +	if (unlikely(PageWorkingset(iter->bvec->bv_page)))
> +		bio_set_flag(bio, BIO_WORKINGSET);

IIRC the feedback was that we do not need to deal with BIO_WORKINGSET
at all for direct I/O.

> +	bio_set_flag(bio, BIO_NO_PAGE_REF);
> +
> +	iter->count = 0;
> +	return 0;
> +}

This helper should go into bio.c, next to bio_iov_iter_get_pages.
And please convert the other callers of bio_iov_iter_get_pages to this
scheme as well.
