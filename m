Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FF121592F
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgGFOKN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFOKN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:10:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BF9C061755;
        Mon,  6 Jul 2020 07:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jr5pej1wSJwvDermowQo12UoHtgzyC4iW6ylZEO386k=; b=Q7louwU7AJBdH4Ne2fjJUP4uJO
        Gp34JEslK4c8hczFMpZByibgLIInVpBTt5Ng3f+MnJ5OmanRP6hil92vM8VT1pFNB10CdyGNtfeRy
        fBSY1nh4ok1c1gq4A2OXkz4CGNte1TCLB+M2G6moP7j12OPiCWwFHYM6ULoYLAH6fnraGwF5WB6bs
        cClfugBzi22sYLcItDMJ5oG804iPek4AxSRt4ArnyI9oOacegAY99AcWkZ4ZnDi8C+/barbkcPCkE
        TwsnDkeIRp60jXXom3TfHeNwKAfv81W/nSWwQ6T2Ptyu4VNdjnIcyiSz4scwe4XrmT4sEKbS/aYx/
        HHiqqJYg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsRoo-0003s1-56; Mon, 06 Jul 2020 14:10:02 +0000
Date:   Mon, 6 Jul 2020 15:10:02 +0100
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
Message-ID: <20200706141002.GZ25523@casper.infradead.org>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
 <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 05, 2020 at 03:12:50PM -0600, Jens Axboe wrote:
> On 7/5/20 3:09 PM, Matthew Wilcox wrote:
> > On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
> >> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
> >>> From: Selvakumar S <selvakuma.s1@samsung.com>
> >>>
> >>> For zone-append, block-layer will return zone-relative offset via ret2
> >>> of ki_complete interface. Make changes to collect it, and send to
> >>> user-space using cqe->flags.

> > I'm surprised you aren't more upset by the abuse of cqe->flags for the
> > address.
> 
> Yeah, it's not great either, but we have less leeway there in terms of
> how much space is available to pass back extra data.
> 
> > What do you think to my idea of interpreting the user_data as being a
> > pointer to somewhere to store the address?  Obviously other things
> > can be stored after the address in the user_data.
> 
> I don't like that at all, as all other commands just pass user_data
> through. This means the application would have to treat this very
> differently, and potentially not have a way to store any data for
> locating the original command on the user side.

I think you misunderstood me.  You seem to have thought I meant
"use the user_data field to return the address" when I actually meant
"interpret the user_data field as a pointer to where userspace
wants the address stored".

