Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E02530189
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 09:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiEVHVF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 03:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbiEVHVC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 03:21:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99978A1B4;
        Sun, 22 May 2022 00:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D+RDuGkgTlHyJXa032TQ7h0GInwRwZsNBFKCU/Zvtvc=; b=03wQAC1gq+rOa7vWkwjrzM+uvN
        aFGC+2ySanLPWTuEL5u7KrkNjp25bUz0AGByM7zjwQwQOFpTQ/f63h1OvLQk74LskO35RxU5SiZ60
        m7asYXHbtWzIP6znoRU8LA424coozk2OesIYJxoyRoQdoi9FTkjhL6F9C3Bnrg/671gT/naKuzOSF
        DNYpEHW3ObBpaUcBNOFHmOYMNnK7JExjMU7Ch/pZYbu+gEqt6wum03/Qhxz23P0QgkzswTUYEr3+N
        lLVV+JeJwDk+ZStRV/qCNHXfQ7hGx2HsJUi0Jo6CjbRoWuBbDhADDL6y9JG5/l3phdr9itMrPQN8j
        vV3tUQjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsftd-000mYo-4u; Sun, 22 May 2022 07:21:01 +0000
Date:   Sun, 22 May 2022 00:21:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 05/17] iomap: Add gfp parameter to
 iomap_page_create()
Message-ID: <YonkXRZtj7sKWTdx@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-6-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, May 20, 2022 at 11:36:34AM -0700, Stefan Roesch wrote:
> -	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)),
> -			GFP_NOFS | __GFP_NOFAIL);
> +	iop = kzalloc(struct_size(iop, uptodate, BITS_TO_LONGS(nr_blocks)), gfp);

Please avoid the overly long line.

Looking at this I also thnk my second suggestion of just passing the
flags to iomap_page_create and let iomap_page_create itself pick the
gfp_t might be the better option here.
