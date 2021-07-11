Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2D3C3D86
	for <lists+io-uring@lfdr.de>; Sun, 11 Jul 2021 17:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhGKPMh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 11:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbhGKPMh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 11:12:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F61DC0613DD;
        Sun, 11 Jul 2021 08:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=mFET4wlpyMvzyMW7HkmA29k1HmKwX0U1eDivwHbrr+U=; b=VCr2df8yqu2zVRqOpJTbARGRit
        m1hfTIschAfZdFGQu4LnvIcIUO3N5p0BFwvwWzKBk3Ly/j3XXlqG7HATwEgY42F+Vg5rtXhntewAq
        C9BQ+Yc3jOcSzXPjMmnXGoobEDiv/zJHVDzisf6wupdsDXfSn5aCKN6Wd0MO0RTiLb6VIE8TAcJWt
        FOgklAIb1p/IF5boPz5DC0CWvGQI5rieNHcJA8SON1BvfnOu/rtUXsmqBduX0x2W+L/cUI9WZBRE7
        lUjLHF/q31ydFwtmatpKVtOeiUI2sruVWuk9n1XOnpldVDnSpPjrT10wM4brR4ZhyR6YnDLEHN6+g
        f827VVMA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2b5G-00GMAD-Sr; Sun, 11 Jul 2021 15:09:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        io-uring@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: [PATCH 0/2] Close a hole where IOCB_NOWAIT reads could sleep
Date:   Sun, 11 Jul 2021 16:09:25 +0100
Message-Id: <20210711150927.3898403-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I noticed a theoretical case where an IOCB_NOWAIT read could sleep:

filemap_get_pages
  filemap_get_read_batch
  page_cache_sync_readahead
    page_cache_sync_ra
      ondemand_readahead
        do_page_cache_ra
        page_cache_ra_unbounded
          gfp_t gfp_mask = readahead_gfp_mask(mapping);
          memalloc_nofs_save()
          __page_cache_alloc(gfp_mask);

We're in a nofs context, so we're not going to start new IO, but we might
wait for writeback to complete.  We generally don't want to sleep for IO,
particularly not for IO that isn't related to us.

Jens, can you run this through your test rig and see if it makes any
practical difference?

Matthew Wilcox (Oracle) (2):
  mm/readahead: Add gfp_flags to ractl
  mm/filemap: Prevent waiting for memory for NOWAIT reads

 include/linux/pagemap.h |  3 +++
 mm/filemap.c            | 31 +++++++++++++++++++------------
 mm/readahead.c          | 16 ++++++++--------
 3 files changed, 30 insertions(+), 20 deletions(-)

-- 
2.30.2

