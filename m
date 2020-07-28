Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60C123040F
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 09:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgG1H1D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 03:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG1H1D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 03:27:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59150C0619D2;
        Tue, 28 Jul 2020 00:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LU6ubMhxoMZxbRhB714UcvhK+c/a9pge6LKHQm1rV4k=; b=It9D1lGADaBD3zUi8UXVMROSCs
        ka/c2195kw4ZiNSK0LPX7wnlWjDwHCwtLeaIWqEVJgVC5GJFMKjeN2W8ZjiiAfFO/1GyDP7GhV6/S
        oHcQJl+TkHad5Yu6ag0HsKX6IMqetGdWRdzVbav91OW8RSYHHFNY692Q+I9llGeDke+AMZDxcKsvA
        6BnoJas2rZG6GyN3JuWrf1vmV5W6E2sMbhJMe041IabnJOXUROHHA23A5KuZXi1Dho40YPgd/403S
        E6Vj6cB7YQf/5RjnRnyQkd5PDKEvtOJcdQ6o1TRR5lbLBLOBTwFMaeuwQG2fnSwWSJ065mHvdRGHz
        ujhrbMng==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0K0d-0001Dx-6V; Tue, 28 Jul 2020 07:26:47 +0000
Date:   Tue, 28 Jul 2020 08:26:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: introduce FMODE_ZONE_APPEND and
 IOCB_ZONE_APPEND
Message-ID: <20200728072647.GA4476@infradead.org>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155258epcas5p1a75b926950a18cd1e6c8e7a047e6c589@epcas5p1.samsung.com>
 <1595605762-17010-2-git-send-email-joshi.k@samsung.com>
 <20200726151810.GA25328@infradead.org>
 <20200728014959.GO23808@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728014959.GO23808@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 28, 2020 at 02:49:59AM +0100, Matthew Wilcox wrote:
> On Sun, Jul 26, 2020 at 04:18:10PM +0100, Christoph Hellwig wrote:
> > Zone append is a protocol context that ha not business showing up
> > in a file system interface.  The right interface is a generic way
> > to report the written offset for an append write for any kind of file.
> > So we should pick a better name like FMODE_REPORT_APPEND_OFFSET
> > (not that I particularly like that name, but it is the best I could
> > quickly come up with).
> 
> Is it necessarily *append*?  There were a spate of papers about ten
> years ago for APIs that were "write anywhere and I'll tell you where it
> ended up".  So FMODE_ANONYMOUS_WRITE perhaps?

But that really is not the semantics I had in mind - both the semantics
for the proposed Linux file API and the NVMe Zone Append command say
write exactly at the write pointer (NVMe) or end of the file (file API).
