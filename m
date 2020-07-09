Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CECD21A116
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 15:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGINnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 09:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgGINnW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 09:43:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401B4C08C5CE;
        Thu,  9 Jul 2020 06:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7rOYKU4XztveD5i31wb3QbJ+1+S+S7EVYyvxSdJ1iFM=; b=NFgYwB4AfSfixGSTDV5fwWhcoX
        DO23STOr9Z3uquozmLEMTByMzstm5nYsixXwt7Y/NCLJqsAXLxmWiSerp+pMIiMnxPII+HB3CACGp
        oXJb3/YWxiPidACkUAcynOQ+moJc4SH4SCAhYL0wiMY38IzGb3po79KWdr4BNs44B6jJyJazldxS5
        mr7FD6hblNBolK+BSxnnLsy5jJmhxXtZyK4lcmRfsXtDsce6hc+NjEE6Jsbd8t+ltZv6zCUjrBX3t
        xENvTNVLNh8fzy7IQM48Tu/JXAgrM1uWSGfTQYBNN4BWECFb+fiRFQ6oVzWrGIh8c07Vsz1/K97et
        1e0VhbWQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtWpb-0001Gb-5I; Thu, 09 Jul 2020 13:43:19 +0000
Date:   Thu, 9 Jul 2020 14:43:19 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
Message-ID: <20200709134319.GD12769@casper.infradead.org>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200709101705.GA2095@infradead.org>
 <20200709111036.GA12769@casper.infradead.org>
 <20200709132611.GA1382@infradead.org>
 <ffbd272c-32f3-8c8c-6395-5eab47725929@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffbd272c-32f3-8c8c-6395-5eab47725929@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 09, 2020 at 04:37:59PM +0300, Pavel Begunkov wrote:
> On 09/07/2020 16:26, Christoph Hellwig wrote:
> > On Thu, Jul 09, 2020 at 12:10:36PM +0100, Matthew Wilcox wrote:
> >> On Thu, Jul 09, 2020 at 11:17:05AM +0100, Christoph Hellwig wrote:
> >>> I really don't like this series at all.  If saves a single pointer
> >>> but introduces a complicated machinery that just doesn't follow any
> >>> natural flow.  And there doesn't seem to be any good reason for it to
> >>> start with.
> >>
> >> Jens doesn't want the kiocb to grow beyond a single cacheline, and we
> >> want the ability to set the loff_t in userspace for an appending write,
> >> so the plan was to replace the ki_complete member in kiocb with an
> >> loff_t __user *ki_posp.
> >>
> >> I don't think it's worth worrying about growing kiocb, personally,
> >> but this seemed like the easiest way to make room for a new pointer.
> > 
> > The user offset pointer has absolutely no business in the the kiocb
> > itself - it is a io_uring concept which needs to go into the io_kiocb,
> > which has 14 bytes left in the last cache line in my build.  It would
> > fit in very well there right next to the result and user pointer.
> 
> After getting a valid offset, io_uring shouldn't do anything but
> complete the request. And as io_kiocb implicitly contains a CQE entry,
> not sure we need @append_offset in the first place.
> 
> Kanchan, could you take a look if you can hide it in req->cflags?

No, that's not what cflags are for.  And besides, there's only 32 bits
there.
