Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C95A22746C
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 03:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgGUBPW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 21:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgGUBPW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 21:15:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93ECC061794;
        Mon, 20 Jul 2020 18:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rfyhcPl9yATKYlIzjLr+e3/ETCiHE9A88WTd3Cfuwq8=; b=pQbISmCeuLOm33gOVjUe/3XMwu
        8+fp6sISGUaQcuvvJXy4HS2N48WBarQc00tX4EiqDW8QgmyQNmiQh9kcUR3ufwoakx5eucXfY4pOd
        hK1gjZSdwBcskY8uYqIagekeMC0NBgreIhonxrpxcY8k3RO1iJVbcjW6O3fSA/F6UPnypXVqZYrvw
        mqAjLRgnT9OJ+kqj13qR7ec3qEpahCVR66trvmMPc9u+pbd0dp5WV9/tFMU8hQhGRXgA7WhfwUuwG
        TkQcp5afvKaM3YszjZSaf1nnOWdtjVjag02kFjbdDYA/elF42KHNPDZsLhkBWxMclmq8iMSrcHfFe
        FpdPfKow==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxgs9-0007nN-Ny; Tue, 21 Jul 2020 01:15:10 +0000
Date:   Tue, 21 Jul 2020 02:15:09 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Matias Bj??rling <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200721011509.GB15516@casper.infradead.org>
References: <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
 <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org>
 <20200710135119.GL12769@casper.infradead.org>
 <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
 <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com>
 <20200720171416.GY12769@casper.infradead.org>
 <CA+1E3rLNo5sFH3RPFAM4_SYXSmyWTCdbC3k3-6jeaj3FRPYLkQ@mail.gmail.com>
 <CY4PR04MB37513C3424E81955EE7BFDA4E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB37513C3424E81955EE7BFDA4E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 21, 2020 at 12:59:59AM +0000, Damien Le Moal wrote:
> On 2020/07/21 5:17, Kanchan Joshi wrote:
> > On Mon, Jul 20, 2020 at 10:44 PM Matthew Wilcox <willy@infradead.org> wrote:
> >>  struct io_uring_cqe {
> >>         __u64   user_data;      /* sqe->data submission passed back */
> >> -       __s32   res;            /* result code for this event */
> >> -       __u32   flags;
> >> +       union {
> >> +               struct {
> >> +                       __s32   res;    /* result code for this event */
> >> +                       __u32   flags;
> >> +               };
> >> +               __s64           res64;
> >> +       };
> >>  };
> >>
> >> Return the value in bytes in res64, or a negative errno.  Done.
> > 
> > I concur. Can do away with bytes-copied. It's either in its entirety
> > or not at all.
> > 
> 
> SAS SMR drives may return a partial completion. So the size written may be less
> than requested, but not necessarily 0, which would be an error anyway since any
> condition that would lead to 0B being written will cause the drive to fail the
> command with an error.

Why might it return a short write?  And, given how assiduous programmers
are about checking for exceptional conditions, is it useful to tell
userspace "only the first 512 bytes of your 2kB write made it to storage"?
Or would we rather just tell userspace "you got an error" and _not_
tell them that the first N bytes made it to storage?

> Also, the completed size should be in res in the first cqe to follow io_uring
> current interface, no ?. The second cqe would use the res64 field to return the
> written offset. Wasn't that the plan ?

two cqes for one sqe seems like a bad idea to me.
