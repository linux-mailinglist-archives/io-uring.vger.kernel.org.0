Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6F432DFB4
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 03:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCECll (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 21:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhCEClk (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 4 Mar 2021 21:41:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989E164E60;
        Fri,  5 Mar 2021 02:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614912100;
        bh=/QEGuxfeeJwVQ4+wJNG01FIJ8rIgGUTLLqLGkiNk8oI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oysxvrKXDM+SuUP8U5j5MGhDDXc8I2AXtXURaBzC6rv1F6PAYe6+P2h40Xy0GEZ51
         VfcvQW8IV3OuqCyykXR69i4EqInAdtkir8Sz9bk6fv4h9U+PPKi3I30/hrZRzt8e7r
         yHyUGdSIwnwASjK/6vRws/9lzPTItDirb+bZ4BqcRPH6iTiHBNJYZlJT/Hfh0Q/6FG
         JJLCf+bPeHWLnbAVQ3MeD9UQvxoq8zSnKWBn2E/LfskASxtdooKPAnGMdCE40MPH4W
         37pZBXxSEKqLrwpKk8XNSTEigCbqSkv5EZ9UdbrUY9h6dvt23DrwuzH/GsB28d2bbj
         NmoYBv3xTBmZg==
Date:   Fri, 5 Mar 2021 11:41:33 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
Message-ID: <20210305024133.GD32558@redsun51.ssa.fujisawa.hgst.com>
References: <20210302160734.99610-1-joshi.k@samsung.com>
 <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com>
 <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com>
 <CA+1E3rLvrC4s2o3qDgHfRWN0JhnB5ZacHK572kjP+-5NmOPBhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rLvrC4s2o3qDgHfRWN0JhnB5ZacHK572kjP+-5NmOPBhw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 04, 2021 at 04:31:11PM +0530, Kanchan Joshi wrote:
> On Thu, Mar 4, 2021 at 3:14 AM Chaitanya Kulkarni
> <Chaitanya.Kulkarni@wdc.com> wrote:
> >
> > On 3/2/21 23:22, Kanchan Joshi wrote:
> > > +     if (!ioucmd)
> > > +             cptr = &c;
> > > +     else {
> > > +             /*for async - allocate cmd dynamically */
> > > +             cptr = kmalloc(sizeof(struct nvme_command), GFP_KERNEL);
> > > +             if (!cptr)
> > > +                     return -ENOMEM;
> > > +     }
> > > +
> > > +     memset(cptr, 0, sizeof(c));
> > Why not kzalloc and remove memset() ?
> 
> Yes sure. Ideally I want to get rid of the allocation cost. Perhaps
> employing kmem_cache/mempool can help. Do you think there is a better
> way?

I'll need to think on this to consider if the memory cost is worth it
(8b to 64b), but you could replace nvme_request's 'struct nvme_command'
pointer with the struct itself and not have to allocate anything per IO.
An added bonus is that sync and async handling become more the same.
