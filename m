Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9987F244953
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 14:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgHNMEb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Aug 2020 08:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgHNMEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Aug 2020 08:04:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23294C061384;
        Fri, 14 Aug 2020 05:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zcIN3o7nFZcsDHO6slakDMVz6rP7Gh3OIOKHo+4Ripk=; b=o7pOkJqix8h4n8IfLn2Y+C4bnN
        NAS93wz3etTRWKWCkhPZYrKM0H+6XReBTPxs5I4XvfRTP7YqjYOZOz/5feL4W/hwVbHSG+Nc3sQba
        aBdx4NgUvbBWjQhL+bVVSLe21m6KKY3iPx7/UXWq2LqsDkLGKQHuQKIM/aVwmOPvuNqbk9ecxon/A
        KHTdlymSifqJv36Rwv5TrG7pfDzsJd7y7e/ZwawtyOmoUr6+r7Yi2OQuZfk9Wg+6M/9cqQJ7S0x2Z
        jK9oog66MXYCVHaRUkfEphDoX8dVWOshqKi0CMQQmaXY2P2yIeQ7o5bNyCqJoR2cap9BEYD7gLNsE
        osXH/Fcg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6YRa-0000ck-NZ; Fri, 14 Aug 2020 12:04:22 +0000
Date:   Fri, 14 Aug 2020 13:04:22 +0100
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
Message-ID: <20200814120422.GA1872@infradead.org>
References: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org>
 <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org>
 <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org>
 <CY4PR04MB37517D633920E4D31AC6EA0DE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200814081411.GA16943@infradead.org>
 <CY4PR04MB3751DE1ECCA4099902AABAA6E7400@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB3751DE1ECCA4099902AABAA6E7400@CY4PR04MB3751.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 14, 2020 at 08:27:13AM +0000, Damien Le Moal wrote:
> > 
> > O_APPEND pretty much implies out of order, as there is no way for an
> > application to know which thread wins the race to write the next chunk.
> 
> Yes and no. If the application threads do not synchronize their calls to
> io_submit(), then yes indeed, things can get out of order. But if the
> application threads are synchronized, then the offset set for each append AIO
> will be in sequence of submission, so the user will not see its writes
> completing at different write offsets than this implied offsets.

Nothing gurantees any kind of ordering for two separate io_submit calls.
The kernel may delay one of them for any reason.

Now if you are doing two fully synchronous write calls on an
O_APPEND fd, yes they are serialized.  But using Zone Append won't
change that.
