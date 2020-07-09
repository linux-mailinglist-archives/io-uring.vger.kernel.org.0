Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCBA21A0CB
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 15:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgGIN0P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 09:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGIN0P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 09:26:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56479C08C5CE;
        Thu,  9 Jul 2020 06:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3VK0PPpTgajPRvu6w9TsxcWut69QO/23qhJyuACRUe8=; b=CrTKomocywcnC625URQttrWyQp
        jrEY1kIYXkOyUapLoHnqwuPYHbKVdz++upCTeYPIEJy8v+GPCC+5TFVDhoa+uKNSJfsENZ6eb0bU9
        mWSNsbCasQsNFI7wkb2H9mGlIv5LYNU/aWzcDv7dqTPjxALYgHvNRjbBFWSV2Tv43861WpKM1+DSU
        jtGt2vhR99n0OXwoCLR95+xhHxWUVM5RiXBFHPGh0vT4Mss0uN1prqQ8XPvJCU0NQlu+echRWZ08m
        /pcLaJc0eoBlMJX5vsHAl8y7ReqBYLdkrGA9PqDdnGHGu+iWvLsJjTuliiA0E7jn8Mf3a1KcOyfO0
        Q+RfNpDw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWZ1-0000Xj-FX; Thu, 09 Jul 2020 13:26:11 +0000
Date:   Thu, 9 Jul 2020 14:26:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
Message-ID: <20200709132611.GA1382@infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200709101705.GA2095@infradead.org>
 <20200709111036.GA12769@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709111036.GA12769@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 09, 2020 at 12:10:36PM +0100, Matthew Wilcox wrote:
> On Thu, Jul 09, 2020 at 11:17:05AM +0100, Christoph Hellwig wrote:
> > I really don't like this series at all.  If saves a single pointer
> > but introduces a complicated machinery that just doesn't follow any
> > natural flow.  And there doesn't seem to be any good reason for it to
> > start with.
> 
> Jens doesn't want the kiocb to grow beyond a single cacheline, and we
> want the ability to set the loff_t in userspace for an appending write,
> so the plan was to replace the ki_complete member in kiocb with an
> loff_t __user *ki_posp.
> 
> I don't think it's worth worrying about growing kiocb, personally,
> but this seemed like the easiest way to make room for a new pointer.

The user offset pointer has absolutely no business in the the kiocb
itself - it is a io_uring concept which needs to go into the io_kiocb,
which has 14 bytes left in the last cache line in my build.  It would
fit in very well there right next to the result and user pointer.
