Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC7A21A198
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 16:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGIOBF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 10:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgGIOBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 10:01:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC42C08C5CE;
        Thu,  9 Jul 2020 07:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8BdzvvCQChcoyPduiw4KhysB+zV+RDrYHG6HeNNq//Y=; b=XcWQ1feDKs5bIcC33paWFhHHwW
        FhzrjFS2oOEa31/gZFhJoNnZg7IFldF6tMdSUP/T30/XL6TIu3zNcFEzFNX2JT9t2kPCeqd6h4RJw
        hMEnyKmGu3lZQrxVzo19yuvBhd3PtzMnVyCrrVX+HLLQuLk8DoVi82pcWbVHHCVebHyumCu7BBMUI
        BT57lkc8aWZtHdNnE2rmbjov0UiOIyFpyrpUuX+79UTfEq22Z4vqts4ZSIhXscPkm0Mkl79egMU0p
        BCxDadKtxqm9MhIHF6BEGOLNiYvGGylIO8HaHbzLn2KSK+wZ59VvRokqJwnb4YBz3ZVcUpyLbxeN0
        fQWHIVIQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtX6b-0002AL-MO; Thu, 09 Jul 2020 14:00:53 +0000
Date:   Thu, 9 Jul 2020 15:00:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200709140053.GA7528@infradead.org>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 09, 2020 at 07:58:04AM -0600, Jens Axboe wrote:
> > We don't actually need any new field at all.  By the time the write
> > returned ki_pos contains the offset after the write, and the res
> > argument to ->ki_complete contains the amount of bytes written, which
> > allow us to trivially derive the starting position.
> 
> Then let's just do that instead of jumping through hoops either
> justifying growing io_rw/io_kiocb or turning kiocb into a global
> completion thing.

Unfortunately that is a totally separate issue - the in-kernel offset
can be trivially calculated.  But we still need to figure out a way to
pass it on to userspace.  The current patchset does that by abusing
the flags, which doesn't really work as the flags are way too small.
So we somewhere need to have an address to do the put_user to.
