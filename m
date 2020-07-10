Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F0C21B6C7
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGJNoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgGJNn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:43:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE07C08C5CE;
        Fri, 10 Jul 2020 06:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LfLVLxxOmlmDOlDinFk/aMFA2Uwys7/Mharys896vzk=; b=FEgCX43ahzk8VgsN48BnOirVa7
        hR9txw/NB9mjn/87qH2UYTdR7rgygcTR8Nz5Xi+P49yt4q22U5C+OCtwUZ4lVWaRURRJzMEpM9auM
        xqw0wfdltzcTKQbC4y9XP1pqoy0oXSmVnO9VmBHNW1J160FmEfPLZzyTHRoDLJRf+V1ThAln6JKTz
        Z9YKVNj9tayvMraarD0G5EyLOl9+XyFCYHd/D3pMN6k7tkoOedBy5MXaNSDf5v0SOFeuBsbYqHVZq
        DCCcOi3foi91pfuXUlGUl3WILL3+u14o2OtbLS5q0nuBh8B7e1mVJnw/qmuRy6ykVaqa8imrURarn
        VeNQz3yw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jttJe-0003qg-Co; Fri, 10 Jul 2020 13:43:50 +0000
Date:   Fri, 10 Jul 2020 14:43:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, Matias Bj??rling <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200710134350.GA14704@infradead.org>
References: <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
 <20200710130912.GA7491@infradead.org>
 <CA+1E3rJSiS58TE=hHv5wVv-umJ19_7zKv-JqZTNzD=xi3MoX1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJSiS58TE=hHv5wVv-umJ19_7zKv-JqZTNzD=xi3MoX1g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 06:59:45PM +0530, Kanchan Joshi wrote:
> > block doesn't work for the case of writes to files that don't have
> > to be aligned in any way.  And that I think is the more broadly
> > applicable use case than zone append on block devices.
> 
> But when can it happen that we do zone-append on a file (zonefs I
> asssume), and device returns a location (write-pointer essentially)
> which is not in multiple of 512b?

All the time.  You open a file with O_APPEND.  You write a record to
it of any kind of size, then the next write will return the position
it got written at, which can be anything.
