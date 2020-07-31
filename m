Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DB4234220
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 11:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732068AbgGaJO3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 05:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgGaJO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 05:14:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E0BC061574;
        Fri, 31 Jul 2020 02:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DyRuVZfVmZ9wXsAnKUw/UMKGK/DVEVi7XnnFZ86g4Ac=; b=Wb69ooOnWGz7Vx9BWYBwagnAEF
        9ZX96XA6F1W/DYv23WaUXijf6RhwSHjXkuLLG27H4Kd0LUGp2F7fhzVAfT/KghFYl9DqMzWW3Vjz/
        DJaMvACKZoFV1EQ/IOxctYvT10DOg7B13E8M0MUmNguWSWijUjPcS5xQZ+USsTsitqFm94eArPrG/
        3q5G7bV7qwQkMDBFLJ3gzyEqCL3I+w8WwIGzwEErIZimbW7yZTHTFegeVHL4hoJOk+BgIlupPihjY
        qUBxwTDiVss3ydUiqnqSFrzEZOJPhZI5ANFelzxIy/efJEzfAIP4g8gaR3Db+UUBb0+4kaZi+grI6
        2oADgoQg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1R7I-0007uO-GQ; Fri, 31 Jul 2020 09:14:16 +0000
Date:   Fri, 31 Jul 2020 10:14:16 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20200731091416.GA29634@infradead.org>
References: <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 08:14:22AM +0000, Damien Le Moal wrote:
> 
> > This was one of the reason why we chose to isolate the operation by a
> > different IOCB flag and not by IOCB_APPEND alone.
> 
> For zonefs, the plan is:
> * For the sync write case, zone append is always used.
> * For the async write case, if we see IOCB_APPEND, then zone append BIOs are
> used. If not, regular write BIOs are used.
> 
> Simple enough I think. No need for a new flag.

Simple, but wrong.  Sync vs async really doesn't matter, even sync
writes will have problems if there are other writers.  We need a flag
for "report the actual offset for appending writes", and based on that
flag we need to not allow short writes (or split extents for real
file systems).  We also need a fcntl or ioctl to report this max atomic
write size so that applications can rely on it.
