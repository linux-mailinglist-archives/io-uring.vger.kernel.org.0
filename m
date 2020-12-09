Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0222D4867
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 18:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgLIR4h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Dec 2020 12:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgLIR4g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Dec 2020 12:56:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAACC0613CF;
        Wed,  9 Dec 2020 09:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=27coJ+xuFsPylYqvsaEZqGgnrAN/OROcayLBy9qgN+Q=; b=FhY89HvUIehspwu7SOG5Jmh7Ci
        2Tx/O5qD/ESnIS+tV98/gFnLahvg8f+EP7557LDroDsLzYXZD6C7lvpQQtAO9IfcFA4n9XegeVCiP
        0I8KX8s9etepGTQP04Pugfq8Ayy5ZrYQH1qG2Y0CFGVl8Z3HGaJBHZqnPrgU5KebF5N8GXVgUhHK8
        lRTq/2V1zaFE/6INC1HvjICnKP1NGz8+aHB8r+P3nCZIk/fmbbcNA7KBGBgJxwaasNRCuvveIReAR
        skPWpyFcPLaqbnIx782YOvjSiSISlOKihKi64pJ8VQpV8tkCCF4niSnqRJ2oM/kuSQQr5VjXbcQDy
        7Ds3ZbCA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn3gv-0006zu-On; Wed, 09 Dec 2020 17:55:53 +0000
Date:   Wed, 9 Dec 2020 17:55:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Message-ID: <20201209175553.GA26252@infradead.org>
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
 <20201209083645.GB21968@infradead.org>
 <20201209130723.GL3579531@ZenIV.linux.org.uk>
 <b6cd4108-dbfe-5753-768f-92f55f38d6cd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6cd4108-dbfe-5753-768f-92f55f38d6cd@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 09, 2020 at 01:37:05PM +0000, Pavel Begunkov wrote:
> Yeah, I had troubles to put comments around, and it's still open.
> 
> For current cases it can be bound to kiocb, e.g. "if an bvec iter passed
> "together" with kiocb then the vector should stay intact up to 
> ->ki_complete()". But that "together" is rather full of holes.

What about: "For bvec based iters the bvec must not be freed until the
I/O has completed.  For asynchronous I/O that means it must be freed
no earlier than from ->ki_complete."
