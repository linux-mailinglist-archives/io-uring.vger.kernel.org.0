Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC6218D02
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 18:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgGHQeP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 12:34:15 -0400
Received: from casper.infradead.org ([90.155.50.34]:38610 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730093AbgGHQeP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 12:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=qY6qQtV+RgCEurwG2BoPG2eey7E6vwCZ+tcxz+4mtsc=; b=vIphRYn3Ms8Y+PgK1VbYORSeEX
        9aTR+bTeOo54fy0z9g5RofAfva+jdv8BbHmdp2rPvhk19vWT/NkkyeiTFLcX5ppvOC/1jrqgUpOHh
        0RGGbtAlP3g2r3ZDfk1eMTgBODeHpMUikcErc4HIbvDjkg44oRHFrifRJ1VCoubjnJmOMrgjlUFZ9
        9MW5r/tqirI8P8OC79dRYWg0/o5bh6tdOC1YKXncmbXe2s/+cJpQkt1SAWAyWieQNiiH4mLnyfHap
        BraJtjc+LQGRCNIeTjoMGkDbZKWxVVyHnWb4+/iDv3Tx3X+cSFLTqlY9PJjCxrOIhJ5imOpuOxlYj
        NiYBIn4A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtD0i-0005Xc-AF; Wed, 08 Jul 2020 16:33:34 +0000
Date:   Wed, 8 Jul 2020 17:33:27 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@infradead.org,
        damien.lemoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200708163327.GU25523@casper.infradead.org>
References: <33b9887b-eaba-c7be-5dfd-fc7e7d416f48@kernel.dk>
 <36C0AD99-0D75-40D4-B704-507A222AEB81@javigon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36C0AD99-0D75-40D4-B704-507A222AEB81@javigon.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 08, 2020 at 06:08:12PM +0200, Javier González wrote:
> > I just wanted to get clarification there, because to me it sounded like
> > you expected Kanchan to do it, and Kanchan assuming it "was sorted". I'd
> > consider that a prerequisite for the append series as far as io_uring is
> > concerned, hence _someone_ needs to actually do it ;-)

I don't know that it's a prerequisite in terms of the patches actually
depend on it.  I appreciate you want it first to ensure that we don't bloat
the kiocb.

> I believe Kanchan meant that now the trade-off we were asking to clear out is sorted. 
> 
> We will send a new version shortly for the current functionality - we can see what we are missing on when the uring interface is clear. 

I've started work on a patch series for this.  Mostly just waiting for
compilation now ... should be done in the next few hours.

