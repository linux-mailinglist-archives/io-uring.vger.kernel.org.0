Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E067331089
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 15:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhCHON2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 09:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhCHONM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 09:13:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37DC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 06:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lEa6sOqXU1xjq2GGcZCKj55LzOS2QAiBraHkTm82Bco=; b=cLLYxY/Lfvev+hiKas2OaPeP5T
        bI6WZ9m9pmHu9aV5ESBMs6r9Xf2AEOXRnFVgODm4xsfmwKCxYT+YuKwVbbHM96cciKJOqCRyNeK25
        +n+R9521Hs4av30xShsrfRLJMJEgclVyKg+S3LbpXsm8M69AHaj/X0ez5OJKB46jxHkYbTbIRkObX
        8iLvoz0zxXC9KqQbKE+gyAavLTLGQIb6XK68UwGNmF+iIvC9HBjVQLX/ppmNJ6pS9tiOk0Itzoatr
        LBq+6LkNEnQ3O4wvHcmxVNMWznabBzy4uCu3fdzQUfMvlOJ06Iq1NCUuiLNqImw10Ez6irVsYWI/7
        lVfakNhw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJGch-00FZ6e-R3; Mon, 08 Mar 2021 14:12:44 +0000
Date:   Mon, 8 Mar 2021 14:12:39 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH 1/2] io_uring: fix UAF for personality_idr
Message-ID: <20210308141239.GB3479805@casper.infradead.org>
References: <20210308065903.2228332-1-yangerkun@huawei.com>
 <e4b79f4d-c777-103d-e87e-d72dc49cb440@gmail.com>
 <20210308132001.GA3479805@casper.infradead.org>
 <787b9f90-71c7-83dd-3826-0d7172be185a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b9f90-71c7-83dd-3826-0d7172be185a@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 08, 2021 at 01:54:14PM +0000, Pavel Begunkov wrote:
> > +	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
> > +			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
> 
> ids are >=1, because 0 is kind of a reserved value for io_uring, so I guess
> 
> XA_LIMIT(1, USHRT_MAX)

+       xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);

takes care of not being able to allocate ID 0.
