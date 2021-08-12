Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B013E3E9EFD
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 08:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhHLGz3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 02:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhHLGz3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 02:55:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A006CC061765;
        Wed, 11 Aug 2021 23:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6LfU+GqQO+88RtfboxgAba8JBTOeXEYqxWLd6CIebTo=; b=fwAHdYwqNWolCxAtsymlWfUwzu
        RX326i8/F4uelq4wtoXF/JhUnJv/74ZQpCEewebukfZMcFqDJDYOuMKk1BBPjL1/BlKLhTIBU/sGl
        A2ZwgiBlDUMqniTS6qnJwQhJr3rBYUfo6QoLakpEA19T5odTpVbJ8yOWsawTZ1igxGEWovLRvqI0f
        8fhB+xpjv4h4DINcndLjI+2BkpVrZ1PX7dFrgvvBRqQ/HtV2YUh2XQfIeubLcyoLoMQkWeXhjNPql
        b7eFw6/gvGqIyJkIxzg7AFx/nsR88slo9pqWSXJ+UiLB849qAn0a8zY9wWKN9/cpJLgrl8v7ihQCW
        f+SzEj8A==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE4ZJ-00EG01-6I; Thu, 12 Aug 2021 06:52:39 +0000
Date:   Thu, 12 Aug 2021 08:51:56 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/6] bio: optimize initialization of a bio
Message-ID: <YRTFDLv7R4ltlvpa@infradead.org>
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811193533.766613-2-axboe@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 11, 2021 at 01:35:28PM -0600, Jens Axboe wrote:
> The memset() used is measurably slower in targeted benchmarks. Get rid
> of it and fill in the bio manually, in a separate helper.

If you have some numbers if would be great to throw them in here.

> +static inline void __bio_init(struct bio *bio)

Why is this split from bio_init and what are the criteria where an
initialization goes?

> +	bio->bi_flags = bio->bi_ioprio = bio->bi_write_hint = 0;

Please keep each initialization on a separate line.
