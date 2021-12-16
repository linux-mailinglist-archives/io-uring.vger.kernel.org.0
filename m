Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBF74774B5
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 15:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbhLPOdI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 09:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhLPOdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 09:33:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14057C061574;
        Thu, 16 Dec 2021 06:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=foz6dy1ECdcmAJmBbiUNLfCBWvq99F8FjH6VIB+KgRE=; b=teYpovxEayYy4rigPnetUtCN42
        XN68VU1P0NcV3ItbIehL7awC8l+d6xdIycCRyOHGR/nwT7fj/LCKGoBmzA8SfQWh+BWg9aamzIqqN
        rCVL6POwOSLUkd/dRZy/FMRaLnZvmnZNXhthSNQpoGn2c7C/7sMjV0owjDHxlZjXv19Gg7vXmGHRE
        RBGvrNN5EDsm1OOnB02XAF/g6Y8j4UoZb02RjZqNDH5uwDai8WZ+tCZ5aL9ZGLo5Xma0xeLcW+OtR
        EAoNMvcrDhEVxuX8ax0rRn8YJy19FkONCSHGzjXxb0Y4MWMx2yU7HlQNcBwGWBRnFJ5eKkp2uzifD
        NOGQqYyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxroe-006BWV-P4; Thu, 16 Dec 2021 14:33:04 +0000
Date:   Thu, 16 Dec 2021 06:33:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] block: enable bio allocation cache for IRQ driven IO
Message-ID: <YbtOIA7eI0nyh8rb@infradead.org>
References: <20211215163009.15269-1-axboe@kernel.dk>
 <20211215163009.15269-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215163009.15269-4-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 15, 2021 at 09:30:09AM -0700, Jens Axboe wrote:
> We currently cannot use the bio recycling allocation cache for IRQ driven
> IO, as the cache isn't IRQ safe (by design).
> 
> Add a way for the completion side to pass back a bio that needs freeing,
> so we can do it from the io_uring side. io_uring completions always
> run in task context.
> 
> This is good for about a 13% improvement in IRQ driven IO, taking us from
> around 6.3M/core to 7.1M/core IOPS.

The numbers looks great, but I really hate how it ties the caller into
using a bio.  I'll have to think hard about a better structure.

Just curious:  are the numbers with retpolines or without?  Do you care
about the cost of indirect calls with retpolines for these benchmarks?
