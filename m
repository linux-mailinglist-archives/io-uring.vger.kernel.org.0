Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE1577CF4B
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 17:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbjHOPhN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbjHOPhH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 11:37:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45701987
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 08:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dhoNRTbE8KQSwud8rLuSMmzGtsfUaSQNBP+y+CbJZrQ=; b=usmNcF6cZGPZXeCDLQsrRKaYYN
        C8iJ8SuSfY1vygojI8QLzMfLd/+GuAh4BUD3x+AHG9cexsT1Ian2EVyCQK7UUgMrFVHbFDRahAALn
        AIJMRYoGiHaL8zhgO0L2qjV08zUmm3n1LdDVT3tmKL09RrBGArJD5R+F9yFLbPIUn5XiZBbu06JWs
        uPpZbk+lb7+15xLA8ikr47TGTacwN8gcHeF+43Xu9TzOZB4qJ3HJcg7AA/01XNELCQrG3jGZPow0C
        ww806I7kyTgGtGvE5mk9ZD+wW+p+ZxR4weppGJWfPLq7x1GgycQe+HZnXLtXv3+ZgNgY3REUhEzID
        UtZdzcqw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVw69-008zzA-5L; Tue, 15 Aug 2023 15:36:45 +0000
Date:   Tue, 15 Aug 2023 16:36:45 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        io-uring@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] io_uring: Stop calling free_compound_page()
Message-ID: <ZNubjS5Ni5L6YqpP@casper.infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
 <20230815032645.1393700-2-willy@infradead.org>
 <c7b0f98c-d4c9-42a6-8671-43947bd7a63b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7b0f98c-d4c9-42a6-8671-43947bd7a63b@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 09:00:24AM -0600, Jens Axboe wrote:
> On 8/14/23 9:26 PM, Matthew Wilcox (Oracle) wrote:
> > folio_put() is the standard way to write this, and it's not
> > appreciably slower.  This is an enabling patch for removing
> > free_compound_page() entirely.
> 
> Looks fine to me, nice cleanup too. Please use 72-74 char line breaks
> though in the commit message, this looks like ~60? With that fixed:

Eh, I just pipe it throught fmt, and that's what it did.  Probably
it has rules about widows/orphans?

> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 
> -- 
> Jens Axboe
> 
