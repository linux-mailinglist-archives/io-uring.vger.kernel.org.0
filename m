Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1A821B5E4
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGJNJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgGJNJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:09:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3EEC08C5CE;
        Fri, 10 Jul 2020 06:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NZEm5kzXLSFX2uBu54Q0aqlOoQJepX9jlZjRW+QQTkw=; b=tr6Eaqfm9KyxXHuJMhAte2ZWyv
        aVsZJEWGYxlDflnFN4o7pToRfOf2n3IgeEy9QK+jOxSUH0v6L9rNedztx5aw2zYTrGcRzPrR4eROj
        Ek+Ub/VhMABoNVTenSTaf524sNeUiWS5MiA7EqjQw6ppbOyfc7fzB2KorQNu3s5+wgF1dP6JCSlHY
        bjDNfOO6JS4T4XL8+yUwKU3Oxuy2mASVyYxVouUPt4VPpz6L1J4bMtMOCl4ejE/e061xHf7G4aOi5
        yA/koxNGruZrjBLNKp4qg2UDUelZV9PpNAzuyUK2O6rtoG0L4HV3D6Z2na03mPGQRKQQq99yry4Bf
        jDHufJqg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtsm8-000266-Hp; Fri, 10 Jul 2020 13:09:12 +0000
Date:   Fri, 10 Jul 2020 14:09:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, Matias Bj??rling <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200710130912.GA7491@infradead.org>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 09, 2020 at 12:50:27PM -0600, Jens Axboe wrote:
> It might, if you have IRQ context for the completion. task_work isn't
> expensive, however. It's not like a thread offload.
> 
> > Using flags have not been liked here, but given the upheaval involved so
> > far I have begun to feel - it was keeping things simple. Should it be
> > reconsidered?
> 
> It's definitely worth considering, especially since we can use cflags
> like Pavel suggested upfront and not need any extra storage. But it
> brings us back to the 32-bit vs 64-bit discussion, and then using blocks
> instead of bytes. Which isn't exactly super pretty.

block doesn't work for the case of writes to files that don't have
to be aligned in any way.  And that I think is the more broadly
applicable use case than zone append on block devices.
