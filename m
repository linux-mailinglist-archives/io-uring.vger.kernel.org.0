Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F98578388E
	for <lists+io-uring@lfdr.de>; Tue, 22 Aug 2023 05:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjHVDcm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Aug 2023 23:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjHVDcl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Aug 2023 23:32:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642F613D
        for <io-uring@vger.kernel.org>; Mon, 21 Aug 2023 20:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CgRqGdZVg9uPMZY4ZUetbHIkeELaVfdtXUzsN9Brwl4=; b=emcGPZJOVPgvmumOP1Cd8faRhi
        /aMXlBOP6ZHbO3wYE5EwGJCHdm6Xu4wTMy1ckxPkip8b8XBjSrNNFYKAbHFOxjyddcFSRl2g+esNo
        GWLEf1zq4oYwNk+mpKPcZqYcaF5TRprctgfvwE8lMBxcWgwT+lAVX/K0SBKTSQP85D9PHbUL7+YOu
        XrD1BzNY1QBTlcpYV4QMxOeWALSpeiwgr9DcAMc8Sjp7GSsyhh6AXGUk2MtJoXBeSlbNDrGE1L+gd
        //Chu2bTxEKd20kWyRarn+3UImiymOpXIhlG5X95gtqcAHLU+kcfjRwxbKUUJhwO+CK2PBuiENJ79
        o/kHMSzg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qYI89-00E1mP-L4; Tue, 22 Aug 2023 03:32:33 +0000
Date:   Tue, 22 Aug 2023 04:32:33 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 07/13] mm: Remove HUGETLB_PAGE_DTOR
Message-ID: <ZOQsUaUA2JnY22Nw@casper.infradead.org>
References: <20230816151201.3655946-1-willy@infradead.org>
 <20230816151201.3655946-8-willy@infradead.org>
 <20230822031300.GA82632@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822031300.GA82632@monkey>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 21, 2023 at 08:13:00PM -0700, Mike Kravetz wrote:
> On 08/16/23 16:11, Matthew Wilcox (Oracle) wrote:
> > We can use a bit in page[1].flags to indicate that this folio belongs
> > to hugetlb instead of using a value in page[1].dtors.  That lets
> > folio_test_hugetlb() become an inline function like it should be.
> > We can also get rid of NULL_COMPOUND_DTOR.
> 
> Not 100% sure yet, but I suspect this patch/series causes the following
> BUG in today's linux-next.  I can do a deeper dive tomorrow.
> 
> # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> # echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> 
> [  352.631099] page:ffffea0007a30000 refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1e8c00
> [  352.633674] head:ffffea0007a30000 order:8 entire_mapcount:0 nr_pages_mapped:0 pincount:0

order 8?  Well, that's exciting.  This is clearly x86, so it should be
order 9.  Did we mistakenly clear bit 0 of tail->flags?

Oh.  Oh yes, we do.

__update_and_free_hugetlb_folio:

        for (i = 0; i < pages_per_huge_page(h); i++) {
                subpage = folio_page(folio, i);
                subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
                                1 << PG_referenced | 1 << PG_dirty |
                                1 << PG_active | 1 << PG_private |
                                1 << PG_writeback);
        }

locked		PF_NO_TAIL
error		PF_NO_TAIL
referenced	PF_HEAD
dirty		PF_HEAD
active		PF_HEAD
private		PF_ANY
writeback	PF_NO_TAIL

So it seems to me there's no way to set any of these bits other than
PG_private.  And, well, you control PG_private in hugetlbfs.  Do you
ever set it on tail pages?

I think you can remove this entire loop and be happy?

