Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D75591C1
	for <lists+io-uring@lfdr.de>; Fri, 24 Jun 2022 07:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiFXFOi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jun 2022 01:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXFOf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jun 2022 01:14:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1570A517DD;
        Thu, 23 Jun 2022 22:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/BWfLUbaygxVhWpTPcuT9qk8bF/C0RWpUSO5JRefTcA=; b=sN1PpiI/NviAqXHkj1Tw9RNbL1
        GTSjnxN5WIV3Xk+tTwA1y0koSkkShfPvbpy6by2YO7aCe4/BZ6J3GkS/ZPIOiPf8viFIUHbAdl9VC
        MwN2tQWMMw1BcffgCXYVDH+Qb5DrN98bhLo4T972eB5HDH1Jxuz7yF4YkcXec6oEQ1pJl5IQZl44o
        JGvj2F2sLUSBw59+xU2SljNLHC3u6F9rmOChvhjErT72/pnxU7YnBSekY0oDF463yGXQATXcRmgYp
        CRKhGKGOEEb8rg2bC0fZCbKQiCMXsVLUGIi5c94GMWcp0xUYm4X1pC9dIgBa22bPXexarRCzEElOa
        t7JJ7EGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4beI-000XEy-Is; Fri, 24 Jun 2022 05:14:30 +0000
Date:   Thu, 23 Jun 2022 22:14:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz,
        hch@infradead.org, axboe@kernel.dk, willy@infradead.org
Subject: Re: [RESEND PATCH v9 00/14] io-uring/xfs: support async buffered
 writes
Message-ID: <YrVINrRNy9cI+dg7@infradead.org>
References: <20220623175157.1715274-1-shr@fb.com>
 <YrTNku0AC80eheSP@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrTNku0AC80eheSP@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 23, 2022 at 01:31:14PM -0700, Darrick J. Wong wrote:
> Hmm, well, vger and lore are still having stomach problems, so even the
> resend didn't result in #5 ending up in my mailbox. :(

I can see a all here.  Sometimes it helps to just wait a bit.
