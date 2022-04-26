Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965645108AB
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 21:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354033AbiDZTKU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 15:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353914AbiDZTKT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 15:10:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE75533E8F;
        Tue, 26 Apr 2022 12:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B1SlxgZnhDUv62Meok/Uu1ZlEfn1sYvml/husNq9EFk=; b=Rg9I6iE7iBm2gZ0pnunKbQuLph
        3W2laBbrkE61WD0EcujIQ+3x+7XcZN4aoaGo1ULY5exrjuA48m375e6lP4e0i87fAE/mg2hPlNM2t
        zlMGyshYnDTWiKUQwOvtUOKmIXt1RrdiqbbLwv04wcWZOIBQVWksH4zIvBG2a9JtlzUlgwoiMS1oh
        4KHtc6IMkwAH7sdlElErNI0FFYOhvvlRNa2jSTafq+fFXnMaQH+vy6D0tsjmgL2yMMKOpSegxVqAQ
        7hbv+h2LKx4UZQy9zU9yg0C4Rjl4bK3l0WU57AhabP0aCt54SHvIPKWC6fDARGRHid0HzClMr218b
        594TbfeA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1njQWQ-009vVJ-E3; Tue, 26 Apr 2022 19:06:50 +0000
Date:   Tue, 26 Apr 2022 20:06:50 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [RFC PATCH v1 02/18] mm: add FGP_ATOMIC flag to
 __filemap_get_folio()
Message-ID: <YmhCylsmrdSvXaUq@casper.infradead.org>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426174335.4004987-3-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 26, 2022 at 10:43:19AM -0700, Stefan Roesch wrote:
> Define FGP_ATOMIC flag and add support for the new flag in the function
> __filemap_get_folio().

No.  You don't get to use the emergency memory pools for doing writes.
That completely screws up the MM.
