Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB88E14E8E7
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 07:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgAaGmc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 01:42:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgAaGmb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 01:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4RziqBNwPU1PXyuUYR4uTQ9MUQMUjgsmxUEvgGf8uVg=; b=mbwTRV+JFE7kOQ/Zc1q7EWWLo
        b/r6VaG5PA2zFHi4pvVcHg00QQM2cM663Xq1D41XOwf0UQdQdBNI2xvUvvuRWZc0z3F9LIYg5uvSB
        Od2BHuooTiRfcTGuydXKRdUSEgl6XNVJsSYSUM37WQMbf/wb7XNSVQDdHWL3GqkwTsluhlPKhw6S/
        EP3EB4/pADxjzTK6JdQpS2tIBSbJEw8Ly4vzgw/v+FJrXluZhHIuqgyn0eOfaxQ3TI9XX6banLZW8
        zNWG9hIz5ggAbgKPzcd24gpk7VbDWT32ozJTEJsOQql+384AXzT7RsS4uJWfpkFJ7BZl+lVgNVI5k
        PbQlk0vAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixQ0c-0000EL-Oy; Fri, 31 Jan 2020 06:42:30 +0000
Date:   Thu, 30 Jan 2020 22:42:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Manage bio references so the bio persists
 until necessary
Message-ID: <20200131064230.GA28151@infradead.org>
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 30, 2020 at 07:23:42PM -0800, Bijan Mottahedeh wrote:
> Get a reference to a bio, so it won't be freed if end_io() gets to
> it before submit_io() returns.  Defer the release of the first bio
> in a mult-bio request until the last end_io() since the first bio is
> embedded in the dio structure and must therefore persist through an
> entire multi-bio request.

Can you explain the issue a little more?

The initial bio is embedded into the dio, and will have a reference
until the bio_put call at the end of the function, so we can't have
a race for that one and won't ever need the refcount for the single
bio case.  Avoiding the atomic is pretty important for aio/uring
performance.
