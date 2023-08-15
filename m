Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE74077CBDB
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 13:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjHOLkZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 07:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbjHOLkS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 07:40:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB1919BC
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 04:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3B/M2uyHkMdPyF8ZjHkIPlCLWEVdAZpIp8tEFrLdXSA=; b=Nl94hS+KEyW5VSnqOCFb2qDKLo
        uZvpK03fRT6g8ryv2rn1B3lkk0GZPHMdURHFVtjFg6ew7hQGZ6at2ZsgkbjfcCHGY/AJrYHrkI5Aq
        HIZgD7qDbKJhbjLzGLQcM1AzDuIdXYlo/R22mndDjRhjBvC/WsLO/6/2VSMTdPrQ+WQXiM2i0G+T4
        eDD+my5OP12Uuoq+zjfioGu7gaKV7ZBzzzeuovDOdey9u/AbfNuv0jMFvDIZSMw11/5YlJUjgksjZ
        HGUT8/8H0Ww1fAo8hmSTio5kYcLo7DA5u8iO257Xn3yJKWqi93aSUMLYI1kr/PBEKOyq06ROyhenT
        zmYJH3xA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVsP0-007xF4-Th; Tue, 15 Aug 2023 11:39:58 +0000
Date:   Tue, 15 Aug 2023 12:39:58 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 9/9] mm: Free up a word in the first tail page
Message-ID: <ZNtkDnjofzKpvM/6@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-10-willy@infradead.org>
 <86579ba0-057e-37bd-e2ec-bd705026daa5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86579ba0-057e-37bd-e2ec-bd705026daa5@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 09:59:08AM +0200, David Hildenbrand wrote:
> On 15.08.23 05:26, Matthew Wilcox (Oracle) wrote:
> > Store the folio order in the low byte of the flags word in the first
> > tail page.  This frees up the word that was being used to store the
> > order and dtor bytes previously.
> > 
> 
> Is there still a free flag in page[1] after this change? I need one, at
> least for a prototype I'm working on. (could fallback to page[2], though
> eventually, though)

There are only ~13 flags used in page[1] at this point.  Plenty of
space.
