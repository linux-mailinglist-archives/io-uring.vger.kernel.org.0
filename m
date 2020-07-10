Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41421B5F1
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgGJNLI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgGJNLG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:11:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D4C08C5DC;
        Fri, 10 Jul 2020 06:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Cbpe7zSMdSUcQMT3p8w0i4/fAKowGRHHeGZ5ArJiJPA=; b=guOL/xNZYChy5mK9TQkICadN1w
        G0xB8bU5w3TVfNTItcn2mdcu47Pg2WeF1uslEx8kYC4w0HdOVjuEJ/C76Va6eeTdyLZw1uAZZX7rp
        ZrY8oPeIbpf3nZzqzPk4pYoem+9nTFcTyRu/vq/8M2vHE0L68qTGWBdVYn61ixUhaTMhnMk7K4mWq
        X+BzUXvtWCVyrHIV+6qaqfcRkWKMp1JGJL/l1l96rGBeoGDp0CtbCo1eY5tZfQEntDMaIRDTNfnm2
        +JSJAEvKhnLErSiNGy3D2P7x0dZQujCoGEhL12ieHVjv0qgS/ZRDJ+Dvu6Azvb7bgnFNyrNwsL3uA
        eAO+Q3ZQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtsnm-0002DE-8H; Fri, 10 Jul 2020 13:10:54 +0000
Date:   Fri, 10 Jul 2020 14:10:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <20200710131054.GB7491@infradead.org>
References: <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
 <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 12:35:43AM +0530, Kanchan Joshi wrote:
> Append required special treatment (conversion for sector to bytes) for io_uring.
> And we were planning a user-space wrapper to abstract that.
> 
> But good part (as it seems now) was: append result went along with cflags at
> virtually no additional cost. And uring code changes became super clean/minimal
> with further revisions.
> While indirect-offset requires doing allocation/mgmt in application,
> io-uring submission
> and in completion path (which seems trickier), and those CQE flags
> still get written
> user-space and serve no purpose for append-write.

I have to say that storing the results in the CQE generally make
so much more sense.  I wonder if we need a per-fd "large CGE" flag
that adds two extra u64s to the CQE, and some ops just require this
version.
