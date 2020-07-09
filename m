Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D2421A141
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 15:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGINxP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 09:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgGINxO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 09:53:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B84C08C5CE;
        Thu,  9 Jul 2020 06:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A/4siLHon92g4IOHLdSOiY5MlPCIQuEMtRpmzy/+J/I=; b=AMhB8lMO9DpZKRSAYhyqyttzvO
        a/0wM1b8Ov//ozcY3BygrjpbYmqBPNdgi3ZiYAWwL3guA7HmKceFaKhd2qDFCfJ4O1AEcy1yIYhjR
        oshVp6hIfda+9XXUqf4KXVYTQ2p8TKorY7cEVCFwoSj1TSNEXUaqU5yCJH+ZuyBOiTfJuKT71Ag55
        w75JXXYfdkFAwbEuhwq6BFXRjK+RRW+Vbo90lHx7tW9v0tXuynUjPF/67NcvjBugprhv5RvvMIvvo
        4ry1lJxFdxY+PC84qOZbLEjWowNY6R2YMZiZUh+Vpjew1tmA1HEez2zSa7nTPp0JTMYaShf4rHOQi
        u2GZzv2g==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWz9-0001fO-J6; Thu, 09 Jul 2020 13:53:11 +0000
Date:   Thu, 9 Jul 2020 14:53:11 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
Message-ID: <20200709135311.GE12769@casper.infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200709101705.GA2095@infradead.org>
 <20200709111036.GA12769@casper.infradead.org>
 <20200709132611.GA1382@infradead.org>
 <ffbd272c-32f3-8c8c-6395-5eab47725929@gmail.com>
 <20200709134319.GD12769@casper.infradead.org>
 <ce7d999e-1629-c70d-8bb9-59d7db41a11e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce7d999e-1629-c70d-8bb9-59d7db41a11e@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 09, 2020 at 04:49:51PM +0300, Pavel Begunkov wrote:
> On 09/07/2020 16:43, Matthew Wilcox wrote:
> > On Thu, Jul 09, 2020 at 04:37:59PM +0300, Pavel Begunkov wrote:
> >> Kanchan, could you take a look if you can hide it in req->cflags?
> > 
> > No, that's not what cflags are for.  And besides, there's only 32 bits
> > there.
> 
> It's there to temporarily store cqe->cflags, if a request can't completed
> right away. And req->{result,user_data,cflags} are basically an CQE inside
> io_kiocb.
> 
> So, it is there exactly for that reason, and whatever way it's going to be
> encoded in an CQE, io_kiocb can fit it. That was my point.

But it's not going to be encoded in the CQE.  Perhaps you should go back to
the older thread and read the arguments there.
