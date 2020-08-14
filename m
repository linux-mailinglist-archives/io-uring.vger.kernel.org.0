Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6470F244643
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 10:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgHNIOW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Aug 2020 04:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgHNIOW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Aug 2020 04:14:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF850C061383;
        Fri, 14 Aug 2020 01:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O4ePLcpRGoDo0O/rzXsIf8bGgZ7ERrg5VoASl6NkmpI=; b=gRZbAEl0QMe7sTmXwITLyqDLLW
        86HhdIPkEJZ2AU5dluHodxWdRr+v5G7M7fNtcCNAFXSfAjRf9svixEVUbJUJUzlKhl7pIhucxGnq5
        oX4Wwdhc3cpKaMD42w7anOCqmhokigU4FEIHUX8uJX4KJUqW3trKTscwO2zJPDPVsnyHJfiBrsb4r
        b0LZ7Powl7iAIzQiUM4CI1vqvApLDqieTEpd+E7KVW9BY5vABIH7pRpwrjO0dvuToc6zsZi7VL8/6
        pkHymJChFtuOnKgNuTg4Y6VngcpIverT6gkDp5fQyz6Ytt0k+Vny4BYJxnNzcWx/DpoEQm8TFlAvE
        vyGXmEqA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6Uqp-0004Wc-Dj; Fri, 14 Aug 2020 08:14:11 +0000
Date:   Fri, 14 Aug 2020 09:14:11 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Kanchan Joshi <joshiiitr@gmail.com>,
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
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20200814081411.GA16943@infradead.org>
References: <20200731064526.GA25674@infradead.org>
 <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 05, 2020 at 07:35:28AM +0000, Damien Le Moal wrote:
> > the write pointer.  The only interesting addition is that we also want
> > to report where we wrote.  So I'd rather have RWF_REPORT_OFFSET or so.
> 
> That works for me. But that rules out having the same interface for raw block
> devices since O_APPEND has no meaning in that case. So for raw block devices, it
> will have to be through zonefs. That works for me, and I think it was your idea
> all along. Can you confirm please ?

Yes.  I don't think think raw syscall level access to the zone append
primitive makes sense.  Either use zonefs for a file-like API, or
use the NVMe pass through interface for 100% raw access.

> >  - take the exclusive per-inode (zone) lock and just issue either normal
> >    writes or zone append at your choice, relying on the lock to
> >    serialize other writers.  For the async case this means we need a
> >    lock than can be release in a different context than it was acquired,
> >    which is a little ugly but can be done.
> 
> Yes, that would be possible. But likely, this will also need calls to
> inode_dio_wait() to avoid ending up with a mix of regular write and zone append
> writes in flight (which likely would result in the regular write failing as the
> zone append writes would go straight to the device without waiting for the zone
> write lock like regular writes do).

inode_dio_wait is a really bad implementation of almost a lock.  I've
started some work that I need to finish to just replace it with proper
non-owner rwsems (or even the range locks Dave has been looking into).

> 
> This all sound sensible to me. One last point though, specific to zonefs: if the
> user opens a zone file with O_APPEND, I do want to have that necessarily mean
> "use zone append". And same for the "RWF_REPORT_OFFSET". The point here is that
> both O_APPEND and RWF_REPORT_OFFSET can be used with both regular writes and
> zone append writes, but none of them actually clearly specify if the
> application/user tolerates writing data to disk in a different order than the
> issuing order... So another flag to indicate "atomic out-of-order writes" (==
> zone append) ?

O_APPEND pretty much implies out of order, as there is no way for an
application to know which thread wins the race to write the next chunk.
