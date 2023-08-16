Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D1877E4CB
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344048AbjHPPMe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344090AbjHPPMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D194D1BE8
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QJooS26uR2KUhhJJzszQM39UcDPRD5O6ibO340Z+plU=; b=oo33NpDmV1uyySnVX3EhQkC5gw
        /zr9PrIt1kiO1DsX5I3hSTS17l+fNnONiu11xiIJdoT1pd3ThuUaTv4P/RGpMjFzxD+QuQXI7Vse0
        Dq8w0UXI/EA0O8dTqmMzPpy1F180J2lnMOAuDaVMJY8NZfuTJtcX4N8hVO+/PqlCqf0K7yhsIrf1N
        U5VxbQtZmHWxPDi21RKOTU9VWW5CKhe3KPbV2/bRUNhevnHfow1tIJXzw6dpqAExegFxGgZnE6SE6
        lobx0qoXgmJs6xShKlFtP3PGc/O1ifdc0jsx4Uvfo7Bv1g+b2oYWWZS4uvrQ+J7BQBl745i/JWyIv
        EQm3yd+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBt-00FL8N-Rr; Wed, 16 Aug 2023 15:12:09 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 00/13] Remove _folio_dtor and _folio_order
Date:   Wed, 16 Aug 2023 16:11:48 +0100
Message-Id: <20230816151201.3655946-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Well, this patch series has got completely out of hand.  What started
out as "Let's try to optimise the freeing path a bit" turned into
"Hey, I can free up an entire word in the first tail page", and
grew "Oh, while we're here, let's rename a bunch of things".

No detailed changelog from v1 because _so much_ changed.

Matthew Wilcox (Oracle) (13):
  io_uring: Stop calling free_compound_page()
  mm: Call free_huge_page() directly
  mm: Convert free_huge_page() to free_huge_folio()
  mm: Convert free_transhuge_folio() to folio_undo_large_rmappable()
  mm; Convert prep_transhuge_page() to folio_prep_large_rmappable()
  mm: Remove free_compound_page() and the compound_page_dtors array
  mm: Remove HUGETLB_PAGE_DTOR
  mm: Add large_rmappable page flag
  mm: Rearrange page flags
  mm: Free up a word in the first tail page
  mm: Remove folio_test_transhuge()
  mm: Add tail private fields to struct folio
  mm: Convert split_huge_pages_pid() to use a folio

 .../admin-guide/kdump/vmcoreinfo.rst          | 14 +--
 Documentation/mm/hugetlbfs_reserv.rst         | 14 +--
 .../zh_CN/mm/hugetlbfs_reserv.rst             |  4 +-
 include/linux/huge_mm.h                       |  6 +-
 include/linux/hugetlb.h                       |  3 +-
 include/linux/mm.h                            | 39 +-------
 include/linux/mm_types.h                      | 19 +++-
 include/linux/page-flags.h                    | 60 ++++++++----
 io_uring/io_uring.c                           |  6 +-
 io_uring/kbuf.c                               |  6 +-
 kernel/crash_core.c                           |  4 +-
 mm/huge_memory.c                              | 51 +++++-----
 mm/hugetlb.c                                  | 97 ++++++-------------
 mm/internal.h                                 |  5 +-
 mm/khugepaged.c                               |  2 +-
 mm/memcontrol.c                               |  2 +-
 mm/mempolicy.c                                | 15 +--
 mm/page_alloc.c                               | 41 +++-----
 18 files changed, 161 insertions(+), 227 deletions(-)

-- 
2.40.1

