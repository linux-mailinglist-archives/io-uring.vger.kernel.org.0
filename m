Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243DB3071D4
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 09:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhA1ImC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 03:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhA1Ilk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 03:41:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86356C061573;
        Thu, 28 Jan 2021 00:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mgoB+i+Auh++1htuEFoAkzFwUIwzArtUbMqdLzdMRFA=; b=XD2Ymn9xzss6bgJBjakru6YpEv
        +aQKprD1jaNuWqi0E0lBJL+lFxRGXpjVkCH7RyT0saCj6GulNNAoWxvrINgBa7EdIIj9sIi0tyDnP
        4P9nkVFfVUPjyGMfsSkFVJJ12PxH96irOGCLdpI9K42Mb3yk+lSiBUoVBC66JNws7LDeUDQrjdu7b
        7+bR0tss4MDb+ybdVvFlUVX9MvopZvp96VUcb1QKPsM+OA/Gyzdr5+CYlURVaaqFplj2SSUrqjXfG
        vxXrBvJ7l7lFb0pE13O85pIl08NldGvOXAl69MaEOJGNdOTt5uKdm7D1t617ZTVNAzHxgqZEWUbTW
        mmSvOEVA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l52qe-008CXK-O3; Thu, 28 Jan 2021 08:40:17 +0000
Date:   Thu, 28 Jan 2021 08:40:16 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     snitzer@redhat.com, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v2 3/6] block: add iopoll method to support bio-based IO
 polling
Message-ID: <20210128084016.GA1951639@infradead.org>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
 <20210125121340.70459-4-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125121340.70459-4-jefflexu@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 25, 2021 at 08:13:37PM +0800, Jeffle Xu wrote:
> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)

Can you split the guts of this function into two separate helpers
for the mq vs non-mq case?  As is is is a little hard to read and
introduced extra branches in the fast path.
