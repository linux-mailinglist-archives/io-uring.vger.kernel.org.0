Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F7A530180
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 09:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiEVHRy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 03:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiEVHRy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 03:17:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FD43C498;
        Sun, 22 May 2022 00:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FYdUNpYTCKI9E//psNaQ4qfwx/AZlbpXMSBjSm3xLAI=; b=jfnCuOiWUTnVFCUfR715RoX543
        ALG2snduf5sX62r4QAYIZQJY3+3FI7aWgxv5kcf4/cA+XT6g4VHAFGePDnHXOlKJTBVVepKTaVPgr
        kzZKGBxQBr6Wx4FJKE/CEurvvAv+v0oKlGFLCMiHMn8sQxJwz+r1f0+hQicjHp/YskSQ7ElO5Iwl/
        KPvhZ8OAfCKA1DT4B99UW7w9kHwJkPIQWcyIbpRyQJRqWjcUGGQ3lnLoqkzUtBjSeKmzSY22NL686
        nP4tD70Y8sGdLrSEtUfVx/nmgBYb/swPIM8GgtHgb2xQIEJMAIEkogcaKs101kMCo+vvV+v/BtmZX
        8Hhp4HHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsfqW-000m5s-Rj; Sun, 22 May 2022 07:17:48 +0000
Date:   Sun, 22 May 2022 00:17:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 03/17] mm: Prepare balance_dirty_pages() for async
 buffered writes
Message-ID: <YonjnENVHY0/s1dg@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-4-shr@fb.com>
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

On Fri, May 20, 2022 at 11:36:32AM -0700, Stefan Roesch wrote:
> From: Jan Kara <jack@suse.cz>
> 
> If balance_dirty_pages() gets called for async buffered write, we don't
> want to wait. Instead we need to indicate to the caller that throttling
> is needed so that it can stop writing and offload the rest of the write
> to a context that can block.

I don't tink this really makes sense without the next patch, so I'd
suggest to merge the two.
