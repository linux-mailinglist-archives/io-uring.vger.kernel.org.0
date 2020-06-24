Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC56207959
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 18:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405156AbgFXQlq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 12:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404160AbgFXQlq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 12:41:46 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448A1C061573;
        Wed, 24 Jun 2020 09:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3Etw+K+6vqw9KKAT/39I8buBhiRfi5hNZ+5u7BKhPD4=; b=cvmnF7vn1ntzO5VbxZbl+Utgf0
        mpk9G0MYcK7vr7ci/NRGgSneoMnuk59gLm3YYAiv/JRes+kLGAgRy0wm66oc9gO+7OpzdJ+2udx8A
        tqRrdNVtb/Fh7vD2uISBCKPFEq3BzKKnuXrd2/neFwWqiSp7S7Fs3s3Wxc/asz/lHMUTSryPdrd3v
        /ASFRsu87FCoqnT+aAhYgzHtmnP+QBV3tOdXxO+gDr6Sl0u5JL03O1fuzP4Faa5MfEmZOKWBuRd/e
        K6UhTxLzMFpnVf0AgK7SGfdDxL1syq+Lw1VKrJ1eql9UEcpCYqz5aXV4EFr6BZ0VsQsFEkpxt3Mre
        slXoaTEw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jo8Sl-0007VG-Sk; Wed, 24 Jun 2020 16:41:27 +0000
Date:   Wed, 24 Jun 2020 17:41:27 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
Message-ID: <20200624164127.GP21350@casper.infradead.org>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
 <20200624010253.GB5369@dread.disaster.area>
 <20200624014645.GJ21350@casper.infradead.org>
 <bad52be9-ae44-171b-8dbf-0d98eedcadc0@kernel.dk>
 <70b0427c-7303-8f45-48bd-caa0562a2951@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70b0427c-7303-8f45-48bd-caa0562a2951@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 24, 2020 at 09:35:19AM -0600, Jens Axboe wrote:
> On 6/24/20 9:00 AM, Jens Axboe wrote:
> > On 6/23/20 7:46 PM, Matthew Wilcox wrote:
> >> I'd be quite happy to add a gfp_t to struct readahead_control.
> >> The other thing I've been looking into for other reasons is adding
> >> a memalloc_nowait_{save,restore}, which would avoid passing down
> >> the gfp_t.
> > 
> > That was my first thought, having the memalloc_foo_save/restore for
> > this. I don't think adding a gfp_t to readahead_control is going
> > to be super useful, seems like the kind of thing that should be
> > non-blocking by default.
> 
> We're already doing memalloc_nofs_save/restore in
> page_cache_readahead_unbounded(), so I think all we need is to just do a
> noio dance in generic_file_buffered_read() and that should be enough.

I think we can still sleep though, right?  I was thinking more
like this:

http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc
