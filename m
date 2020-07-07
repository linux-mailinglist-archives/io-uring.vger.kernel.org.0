Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C838821732A
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 18:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgGGQA2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 12:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgGGQA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 12:00:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AC6C061755;
        Tue,  7 Jul 2020 09:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CP3gYZf2kjid72TDwJavn73cb81r67oVs6dPbA5sJrs=; b=TbRHDWpqod5158cU9VcuMxtMl0
        Z3G0xtpcqzLIuDWWIIcnh9C2kh7CSkV4JSSIDwUSlxfQPTygt0gA5KxoHykWQL/VPT4vSar/6D1cN
        PMcSCdozGP0IE5ZVMVpYGkR977gY7lsrqkoMBm9jaMYhaXJARQRMx1rid9CVnNEfJUj1vQzKN4wTX
        7y3w/+jqw3v9t7nHICdR7mfHK4r0EP1k76le37z5fmFaacVj7SkSAzzQt+zdxOGgLowaUoqsgP5gF
        H75mhPzCgNzP6m6muIchhmbWsuB2N9uFrb53OUci0eYLguPFPhNq0038c46l9d5VckBbvuMQ3n6kU
        jSLu7JTw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsq10-0006dx-SQ; Tue, 07 Jul 2020 16:00:14 +0000
Date:   Tue, 7 Jul 2020 17:00:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@infradead.org,
        Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
Message-ID: <20200707160014.GA25189@infradead.org>
References: <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
 <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
 <20200706141002.GZ25523@casper.infradead.org>
 <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
 <20200706143208.GA25523@casper.infradead.org>
 <20200707151105.GA23395@test-zns>
 <20200707155237.GM25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707155237.GM25523@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 07, 2020 at 04:52:37PM +0100, Matthew Wilcox wrote:
> But userspace has to _do_ something with that information anyway.  So
> it must already have somewhere to put that information.
> 
> I do think that interpretation of that field should be a separate flag
> from WRITE_APPEND so apps which genuinely don't care about where the I/O
> ended up don't have to allocate some temporary storage.  eg a logging
> application which just needs to know that it managed to append to the
> end of the log and doesn't need to do anything if it's successful.

I agree with the concept of a flag for just returning the write
location.  Because if you don't need that O_APPEND is all you need
anyway.
