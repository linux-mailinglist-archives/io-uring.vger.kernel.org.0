Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02B32EBF7
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCENR3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:17:29 -0500
Received: from verein.lst.de ([213.95.11.211]:46663 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCENRO (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 5 Mar 2021 08:17:14 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E6C3368B05; Fri,  5 Mar 2021 14:17:11 +0100 (CET)
Date:   Fri, 5 Mar 2021 14:17:11 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
Message-ID: <20210305131711.GA9557@lst.de>
References: <20210302160734.99610-1-joshi.k@samsung.com> <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com> <20210302160734.99610-4-joshi.k@samsung.com> <BYAPR04MB496501DAED24CC28347A283086989@BYAPR04MB4965.namprd04.prod.outlook.com> <CA+1E3rLvrC4s2o3qDgHfRWN0JhnB5ZacHK572kjP+-5NmOPBhw@mail.gmail.com> <20210305024133.GD32558@redsun51.ssa.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305024133.GD32558@redsun51.ssa.fujisawa.hgst.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 05, 2021 at 11:41:33AM +0900, Keith Busch wrote:
> I'll need to think on this to consider if the memory cost is worth it
> (8b to 64b), but you could replace nvme_request's 'struct nvme_command'
> pointer with the struct itself and not have to allocate anything per IO.
> An added bonus is that sync and async handling become more the same.

This would solve a lot of mess with the async passthrough, and also
more closely match what is done in SCSI.  In theory we could use a
cut down version without the data and metadata pointers (just 40 bytes),
but I'm not sure that is really worth it given that we then need to
rearrange things in the I/O path.
