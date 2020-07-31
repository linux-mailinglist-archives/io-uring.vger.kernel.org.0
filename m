Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9B1233F57
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 08:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgGaGpg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 02:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731400AbgGaGpf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 02:45:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96164C061574;
        Thu, 30 Jul 2020 23:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CiTqN18GYkJ0DtGuKf9NcwAeEt5aTI378Nv1sTLU35Y=; b=mJaTjZNDewq742QUSYLrjjRET4
        xTTZk9J5FunTcSiatX6+U2iuryJoqeQm3I/nYZI7fgmIMjsODPXUxPr6CZAjOFHQEDy7lrzSJnVR5
        3vo2tdegUmTszhEnmuqCsTq9hZ+oVD3yKUawaeMEhrcjWN/D7iizAwRTizMLVeEj9sgTT4J6VZfnM
        BxxyH4MG+MucQGMM0PnjgpkivxqXeVLMROK/5Bgd1s2ZPSbXkw6QdZEkkJmszF/GsBtzlbXU+Nmqm
        IsaNNWp4T5dgVye9hb9t/a4biSDzFlm443++WqbsMBC+z6Luj/2IOc7kgPuAS6CYb16Hm9j1aEs0s
        QNA/mihQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1OnG-0006tY-AI; Fri, 31 Jul 2020 06:45:26 +0000
Date:   Fri, 31 Jul 2020 07:45:26 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <20200731064526.GA25674@infradead.org>
References: <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
 <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
 <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
 <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 06:42:10AM +0000, Damien Le Moal wrote:
> > - We may not be able to use RWF_APPEND, and need exposing a new
> > type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this
> > sounds outrageous, but is it OK to have uring-only flag which can be
> > combined with RWF_APPEND?
> 
> Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningless for
> raw block device accesses. We could certainly define a meaning for these in the
> context of zoned block devices.

We can't just add a meaning for O_APPEND on block devices now,
as it was previously silently ignored.  I also really don't think any
of these semantics even fit the block device to start with.  If you
want to work on raw zones use zonefs, that's what is exists for.
