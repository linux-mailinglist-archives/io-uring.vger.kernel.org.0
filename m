Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E435532EBFD
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCENWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:22:51 -0500
Received: from verein.lst.de ([213.95.11.211]:46681 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCENWX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 5 Mar 2021 08:22:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E699D68B05; Fri,  5 Mar 2021 14:22:20 +0100 (CET)
Date:   Fri, 5 Mar 2021 14:22:20 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
Message-ID: <20210305132220.GA10000@lst.de>
References: <20210302160734.99610-1-joshi.k@samsung.com> <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com> <20210302160734.99610-4-joshi.k@samsung.com> <BYAPR04MB4965E07D8D106CE6565DFB7386989@BYAPR04MB4965.namprd04.prod.outlook.com> <CA+1E3rJZWkOw+ZfDGduQhdhTh+=JVe5CcFEZtfQ1Jmq6mKhbSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJZWkOw+ZfDGduQhdhTh+=JVe5CcFEZtfQ1Jmq6mKhbSA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 04, 2021 at 04:25:41PM +0530, Kanchan Joshi wrote:
> On Thu, Mar 4, 2021 at 12:22 AM Chaitanya Kulkarni
> <Chaitanya.Kulkarni@wdc.com> wrote:
> >
> > On 3/2/21 23:22, Kanchan Joshi wrote:
> > > +     switch (bcmd->ioctl_cmd) {
> > > +     case NVME_IOCTL_IO_CMD:
> > > +             ret = nvme_user_cmd(ns->ctrl, ns, argp, ioucmd);
> > > +             break;
> > > +     default:
> > > +             ret = -ENOTTY;
> > > +     }
> > Switch for one case ? why not use if else ?
> 
> Indeed, I should have used that. I had started off with more than one,
> and retracted later.

I have to say I really do like the switch for ioctl handlers, as they
are designed as a multiplexer, and nothing screams multiplexer more
than a switch statement.
