Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C29B41142B
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 14:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhITMUv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 08:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbhITMUu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Sep 2021 08:20:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374F7C061574;
        Mon, 20 Sep 2021 05:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wfXs9/qwoOMAzXZ/BK5m1l64BNcgy6HZMP06a/9fWyo=; b=KEf6nwYE0AAFd9pXs8mIm7zPgb
        8PHeG4jyD5P4I87ypOPZEJ28jd5ulMXi5EJLxviysHEuCCNkY9KAbTMt3ZFx9J+uI4II3IaMvwRWB
        GRfKN0OuJ6Qz5O0x3OQW2Wz9H4GeLpxQJMCfcyILzaZsiAgV7HwVXB931TjBIuZ6ncr4BufWGhNS+
        9gSszMGMTZ+81P9crYXHenanXpsk0OmZRGpWTtyyOlx4S4/REry7AzOC7znzWD+jeqa9V1BC4zdPY
        Fs/EmjE0sMsuU+FCL9wY1p4DDrnsciq54WlYT7n4aatHZb/+WukBh9Muqk9lRqVRkEiIJKBVjUFIT
        5JTSYCkQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSIGA-002e3G-CM; Mon, 20 Sep 2021 12:19:03 +0000
Date:   Mon, 20 Sep 2021 13:18:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] io_uring: warning about unused-but-set parameter
Message-ID: <YUh8Mj59BtyBdTRH@infradead.org>
References: <20210920121352.93063-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920121352.93063-1-arnd@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 20, 2021 at 02:13:44PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When enabling -Wunused warnings by building with W=1, I get an
> instance of the -Wunused-but-set-parameter warning in the io_uring code:
> 
> fs/io_uring.c: In function 'io_queue_async_work':
> fs/io_uring.c:1445:61: error: parameter 'locked' set but not used [-Werror=unused-but-set-parameter]
>  1445 | static void io_queue_async_work(struct io_kiocb *req, bool *locked)
>       |                                                       ~~~~~~^~~~~~
> 
> There are very few warnings of this type, so it would be nice to enable
> this by default and fix all the existing instances. I was almost
> done, but this was added recently as a precaution to prevent code
> from using the parameter, which could be done by either removing
> the initialization, or by adding a (fake) use of the variable, which
> I do here with the cast to void.

Please don't.  These warning are utterly stupid and should not be
enabled.  For anything that is a "method" of sorts (that is assigned
to a function pointer), unused argument are perfectly normal.
