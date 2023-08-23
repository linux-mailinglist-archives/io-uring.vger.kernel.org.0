Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5651C784DCD
	for <lists+io-uring@lfdr.de>; Wed, 23 Aug 2023 02:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjHWAaC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Aug 2023 20:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjHWAaC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Aug 2023 20:30:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42041CE8
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 17:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gtdI4NouFHTVO3xitz42/cKcGZ9fu+9t/UX8IQpydgs=; b=ohQHJJLus8Lgd5uGfuy+Dryxa3
        XNpXfNlIWp/Mkf5CrgyLXv2dfAAsYeKaDWIyE2ZiY3/0lt+GBuQ7clV3MkMqIskYzHqarH+S4lVMk
        +m9L0m0s19MjArQXLJqmwWgP+JNdxFMOJemrfGsGMiaxP5zTFghNhhMuDzj7xMiD2hKnh54o2bisb
        pKX29PMdzg03P08hVHf7Y93qB2x+2kIzLR83K4whdftsUVck4m+Z7Lhx2jzSVhWnsy8tYi7wrXy+H
        Kla7MFtdtJc/apuhWhqVo7bnrCQa+JvYg+mJvKzFvee8/Je3lz9NRWhoYh/SBMNTpuqgbLaRLdA3A
        nCSzQ19A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qYbkx-001lhU-49; Wed, 23 Aug 2023 00:29:55 +0000
Date:   Wed, 23 Aug 2023 01:29:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 10/13] mm: Free up a word in the first tail page
Message-ID: <ZOVTAxzuzzOpCy2q@casper.infradead.org>
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-11-willy@infradead.org>
 <20230822231741.GC4509@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822231741.GC4509@monkey>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 22, 2023 at 04:17:41PM -0700, Mike Kravetz wrote:
> On 08/16/23 16:11, Matthew Wilcox (Oracle) wrote:
> > Store the folio order in the low byte of the flags word in the first
> > tail page.  This frees up the word that was being used to store the
> > order and dtor bytes previously.
> 
> hugetlb manually creates and destroys compound pages.  As such it makes
> assumptions about struct page layout.  This breaks hugetlb.  The following
> will allow fix the breakage.
> 
> The hugetlb code is quite fragile when changes like this are made.  I am
> open to suggestions on how we can make this more robust.  Perhaps start
> with a simple set of APIs to create_folio from a set of contiguous pages
> and destroy a folio?

Thanks; those changes look good to me.

I don't have any _immediate_ plans to make your life easier.  When
we get to a memdesc world, it'll all get much easier.
