Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA47453975
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 19:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbhKPSjb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 13:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239526AbhKPSja (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 13:39:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E89DC061570;
        Tue, 16 Nov 2021 10:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JEcbbh/dVkVptbrXWN3GozTnEzbwvPLEPedTKPD53aQ=; b=mA5jxu3sy0X3+aUkFrrjpR47Fj
        yYqwQI9T6Ct8fWvCTg/mhpbbeRlReFVm5x70No48tHenfs0ppYqqxUB0OhHKJ2vhlKysqZ57QFdfB
        58s/AbXaqmJ66Nqmz4ZAe6ail5OntA13nZguCvb42BNFXbXJ8vU/HeSKif5EpDd7f2KrVMTEmc8SH
        ekTDgTEbWUOsUI1ao1wB3XtqxrvQaNz9Ko3z62Djdav9mdd1Jf/ePybJZaQiKedJ0YViBu+Rz12ej
        qXQp9Rg0Dno9l6+/WqIfA4k+z5gtTWG5hydwvXQrySsfqFjlfiym9+S2/SpXu2lk4LngSb+8Un1Ne
        McvVQPgQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mn3Jd-006zsT-HT; Tue, 16 Nov 2021 18:36:21 +0000
Date:   Tue, 16 Nov 2021 18:36:21 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <YZP6JSd4h45cyvsy@casper.infradead.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 15, 2021 at 08:35:30PM -0800, Andrew Morton wrote:
> I'd also be interested in seeing feedback from the MM developers.
[...]
> Subject: Increase default MLOCK_LIMIT to 8 MiB

On the one hand, processes can already allocate at least this much
memory that is non-swappable, just by doing things like opening a lot of
files (allocating struct file & fdtable), using a lot of address space
(allocating page tables), so I don't have a problem with it per se.

On the other hand, 64kB is available on anything larger than an IBM XT.
Linux will still boot on machines with 4MB of RAM (eg routers).  For
someone with a machine with only, say, 32MB of memory, this allows a
process to make a quarter of the memory unswappable, and maybe that's
not a good idea.  So perhaps this should scale over a certain range?

Is 8MB a generally useful amount of memory for an iouring user anyway?
If you're just playing with it, sure, but if you have, oh i don't know,
a database, don't you want to pin the entire cache and allow IO to the
whole thing?

