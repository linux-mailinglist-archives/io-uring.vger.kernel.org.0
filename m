Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEAC6E814D
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjDSSfl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDSSfk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:35:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49570122;
        Wed, 19 Apr 2023 11:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J+e8Y5sVsLCpZ8zZrbcZwsxzd3npeKq9qMhgQw1OPbQ=; b=qxsnrLgHRIvUBWqr4Xx3LZq7P6
        Qp2XXU3fs8HrlrJE75NHo8J7K7fgbknc7DTc+5kGyxGo+D+HA/mGPbeT1JDcmspnMAkjd/gzijwOj
        307c16xkj+f4elD7HuC0BcNyenFEn17uElUnGKpzcIdbHsIzCepVXlP6wcc97bhWMZQqdfosWNmeb
        gyCApIopSpMvac+SgmQ1p836Mm2qihQPhcRJvUXfdXvZPNylPDIZM3t/bICFZFYkIRV3SmJy8gg5s
        6ZNi5XEKsRj1i3fh5bczWib8ADNLcoBWb4l5mR9xuISTnkLA2pj1RfdGuk3nilkvWwg8ohyBbH6tV
        32Pt1ZIw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ppCeT-00DUSu-7J; Wed, 19 Apr 2023 18:35:33 +0000
Date:   Wed, 19 Apr 2023 19:35:33 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Message-ID: <ZEA0dbV+qIBSD0mG@casper.infradead.org>
References: <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org>
 <ZEAx90C2lDMJIux1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEAx90C2lDMJIux1@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 19, 2023 at 03:24:55PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 19, 2023 at 07:23:00PM +0100, Matthew Wilcox wrote:
> > On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
> > > So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
> > > would still need to come along and delete a bunch of your code
> > > afterwards. And unfortunately Pavel's recent change which insists on not
> > > having different vm_file's across VMAs for the buffer would have to be
> > > reverted so I expect it might not be entirely without discussion.
> > 
> > I don't even understand why Pavel wanted to make this change.  The
> > commit log really doesn't say.
> > 
> > commit edd478269640
> > Author: Pavel Begunkov <asml.silence@gmail.com>
> > Date:   Wed Feb 22 14:36:48 2023 +0000
> > 
> >     io_uring/rsrc: disallow multi-source reg buffers
> > 
> >     If two or more mappings go back to back to each other they can be passed
> >     into io_uring to be registered as a single registered buffer. That would
> >     even work if mappings came from different sources, e.g. it's possible to
> >     mix in this way anon pages and pages from shmem or hugetlb. That is not
> >     a problem but it'd rather be less prone if we forbid such mixing.
> > 
> >     Cc: <stable@vger.kernel.org>
> >     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > 
> > It even says "That is not a problem"!  So why was this patch merged
> > if it's not fixing a problem?
> > 
> > It's now standing in the way of an actual cleanup.  So why don't we
> > revert it?  There must be more to it than this ...
> 
> https://lore.kernel.org/all/61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com/

So um, it's disallowed because Pavel couldn't understand why it
should be allowed?  This gets less and less convincing.

FWIW, what I was suggesting was that we should have a FOLL_SINGLE_VMA
flag, which would use our shiny new VMA lock infrastructure to look
up and lock _one_ VMA instead of having the caller take the mmap_lock.
Passing that flag would be a tighter restriction that Pavel implemented,
but would certainly relieve some of his mental load.

By the way, even if all pages are from the same VMA, they may still be a
mixture of anon and file pages; think a MAP_PRIVATE of a file when
only some pages have been written to.  Or an anon MAP_SHARED which is
accessible by a child process.
