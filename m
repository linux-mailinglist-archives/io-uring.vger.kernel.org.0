Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EEA3C5B7D
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 13:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhGLLha (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 07:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhGLLha (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 07:37:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DCBC0613DD;
        Mon, 12 Jul 2021 04:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Nyp5QtyWvgSaxX6QcYvHcVd8PYTJFQ9djhzXeIBYfvk=; b=Q0MJVrgX1K/L21RKm04jXk5ehp
        7Mco119wFA9kHR2lVhC23RoT0AMqrr9VIxszWDKBxGFIZuYrxr1OBwN1HsQTXiPJBtP96uOK0WKvb
        GRdtvM503qLkIItvYkTORx9iI9qdDxBNVKKCNToOv9UeJc2o0TlqX0zdbzbBZr1YRT5vw0GY1+oSo
        fgDmcVsjQ0OqU6teaRsVHt3+qqlFkmjmro0SgRp4FwlAvEve90LSAW5owp2rbu7ajJtuYdNIiTmoM
        2Tjq+tYRF2zLFz51Df2U3dnwaqqRTgs+t1k+wjPP074qDuvZGM+Er0v4PARodzTWwM7H2klLH2406
        5+JfWJQA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2uCd-00HYHN-IS; Mon, 12 Jul 2021 11:34:28 +0000
Date:   Mon, 12 Jul 2021 12:34:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: [PATCH 1/2] mm/readahead: Add gfp_flags to ractl
Message-ID: <YOwov+dVx5RxIyFw@infradead.org>
References: <20210711150927.3898403-1-willy@infradead.org>
 <20210711150927.3898403-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210711150927.3898403-2-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 11, 2021 at 04:09:26PM +0100, Matthew Wilcox (Oracle) wrote:
> It is currently possible for an I/O request that specifies IOCB_NOWAIT
> to sleep waiting for I/O to complete in order to allocate pages for
> readahead.  In order to fix that, we need the caller to be able to
> specify the GFP flags to use for memory allocation in the rest of the
> readahead path.

The file systems also need to respect it for their bio or private
data allocation.  And be able to cope with failure, which they currently
don't have to for sleeping bio allocations.
