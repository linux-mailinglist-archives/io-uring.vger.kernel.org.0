Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A7218AAE
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgGHPDe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 11:03:34 -0400
Received: from casper.infradead.org ([90.155.50.34]:36686 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbgGHPDd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 11:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zBHCkuCe5RFCedmEBx2CZK7LS4k3WZ+7jOD5fQ9ed9Y=; b=djVZpEIBtWMWxRw3CqqH/NFd4i
        a4zr7rIrC8/W8xunIZNCpi+Zb8uXFFQqUTfV6c/TR/p3OJCbxCExyLnKLGPBTSyChk2zmQz7wrGYL
        4W/89zj8RJAInOQYr0SpZry7v5ixoHyXs33qzoOQGhaMjKrQbPpSfHZIfkbY0F+cVsQ/BINFM/fdA
        TO4zabYCHmemwCzKTU1ar+3trAsn7gMAR5EhPjkoHY3j17LHzQm/prWRt+QM97WXA11zcpZQrTq61
        MvfXv5S2HGPsOJsW6NmTFLhSFetX+7cit4zXSnl0v8cg9gdsruyvn/+T0AhY5meP7ZEYT3F/OnRnc
        yfBttG4g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtBat-00014u-JD; Wed, 08 Jul 2020 15:02:45 +0000
Date:   Wed, 8 Jul 2020 16:02:40 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200708150240.GT25523@casper.infradead.org>
References: <20200707155237.GM25523@casper.infradead.org>
 <20200707202342.GA28364@test-zns>
 <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
 <20200707221812.GN25523@casper.infradead.org>
 <CGME20200707223803epcas5p41814360c764d6b5f67fdbf173a8ba64e@epcas5p4.samsung.com>
 <145cc0ad-af86-2d6a-78b3-9ade007aae52@kernel.dk>
 <20200708125805.GA16495@test-zns>
 <2962cd68-de34-89be-0464-8b102a3f1d0e@kernel.dk>
 <20200708145826.GS25523@casper.infradead.org>
 <b1c58211-496a-ed85-a9bb-0d0cc56e250c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1c58211-496a-ed85-a9bb-0d0cc56e250c@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 08, 2020 at 08:59:50AM -0600, Jens Axboe wrote:
> On 7/8/20 8:58 AM, Matthew Wilcox wrote:
> > On Wed, Jul 08, 2020 at 08:54:07AM -0600, Jens Axboe wrote:
> >> On 7/8/20 6:58 AM, Kanchan Joshi wrote:
> >>>>> +#define IOCB_NO_CMPL		(15 << 28)
> >>>>>
> >>>>>  struct kiocb {
> >>>>> [...]
> >>>>> -	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
> >>>>> +	loff_t __user *ki_uposp;
> >>>>> -	int			ki_flags;
> >>>>> +	unsigned int		ki_flags;
> >>>>>
> >>>>> +typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
> >>>>> +static ki_cmpl * const ki_cmpls[15];
> >>>>>
> >>>>> +void ki_complete(struct kiocb *iocb, long ret, long ret2)
> >>>>> +{
> >>>>> +	unsigned int id = iocb->ki_flags >> 28;
> >>>>> +
> >>>>> +	if (id < 15)
> >>>>> +		ki_cmpls[id](iocb, ret, ret2);
> >>>>> +}
> >>>>>
> >>>>> +int kiocb_cmpl_register(void (*cb)(struct kiocb *, long, long))
> >>>>> +{
> >>>>> +	for (i = 0; i < 15; i++) {
> >>>>> +		if (ki_cmpls[id])
> >>>>> +			continue;
> >>>>> +		ki_cmpls[id] = cb;
> >>>>> +		return id;
> >>>>> +	}
> >>>>> +	WARN();
> >>>>> +	return -1;
> >>>>> +}
> >>>>
> >>>> That could work, we don't really have a lot of different completion
> >>>> types in the kernel.
> >>>
> >>> Thanks, this looks sorted.
> >>
> >> Not really, someone still needs to do that work. I took a quick look, and
> >> most of it looks straight forward. The only potential complication is
> >> ocfs2, which does a swap of the completion for the kiocb. That would just
> >> turn into an upper flag swap. And potential sync kiocb with NULL
> >> ki_complete. The latter should be fine, I think we just need to reserve
> >> completion nr 0 for being that.
> > 
> > I was reserving completion 15 for that ;-)
> > 
> > +#define IOCB_NO_CMPL		(15 << 28)
> > ...
> > +	if (id < 15)
> > +		ki_cmpls[id](iocb, ret, ret2);
> > 
> > Saves us one pointer in the array ...
> 
> That works. Are you going to turn this into an actual series of patches,
> adding the functionality and converting users?

I was under the impression Kanchan was going to do that, but I can run it
off quickly ...
