Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063DB77CDC7
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 16:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbjHOOGc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237487AbjHOOGJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 10:06:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98FC1B2
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 07:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AMvj1+q682nwi561FShRzvYJdbTTAxJUunJmgAL6vjU=; b=cWQseILwo4RGrokfU7vAptDG4f
        F4VkkZnzLmKkV/fgIM/hfoaJA4W37LRum2lkQ1+926ZdxGx1KNXZ5E62b9gdP671q5uNfmOc8X2Hj
        xZQFYE5pSws3J1tM8eSYICWxOb+WSgkO02MoAZhjAvawX7iafRQ8kTmfotsNhk0i4GFiop65TLK40
        7QGJ6jHpUeCo633VADjVNEPRYRc3XX0ph7YutLQeGpOViaaTS7FTP2ltOLxsFUbzifLo62H4KK/h1
        fUagx+xuP4J/cgfZrmWfwh4Tjy2DrenoR8AtwkuPN6s9yixJVyKP2V70Lt+9L+OpsGwyeiOfosL+1
        emajPx+A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVugN-008cZI-Bb; Tue, 15 Aug 2023 14:06:03 +0000
Date:   Tue, 15 Aug 2023 15:06:03 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mm: Call free_transhuge_folio() directly from
 destroy_large_folio()
Message-ID: <ZNuGS4b7c402uon1@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-4-willy@infradead.org>
 <075a00b7-1e92-1709-5ac6-371eec9b1459@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <075a00b7-1e92-1709-5ac6-371eec9b1459@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 09:40:58AM +0200, David Hildenbrand wrote:
> > @@ -624,6 +621,11 @@ void destroy_large_folio(struct folio *folio)
> >   		return;
> >   	}
> > +	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR) {
> > +		free_transhuge_folio(folio);
> 
> I really wonder if folio_test_transhuge() should be written similar to
> folio_test_hugetlb() instead, such that the dtor check is implicit.
> 
> Any good reasons not to do that?

Actually, we should probably delete folio_test_transhuge().  I'll tack
a patch onto the end of this series to do that.  I want to avoid a
reference to free_transhuge_folio() if !CONFIG_TRANSPARENT_HUGEPAGE and
folio_test_transhuge() accomplishes that by way of TESTPAGEFLAG_FALSE
in page-flags.  But so does folio_test_deferred_list() which is what
we're getting to by the end of this series.

So I'll leave this patch alone for now (other than fixing up the
buildbot errors).
