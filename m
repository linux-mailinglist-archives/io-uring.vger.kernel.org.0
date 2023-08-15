Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5032377C665
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbjHODcQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbjHOD3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10931FF1
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=woamUMUNIK5HdnapTnYhYX9EDeSRN8D18S/wD2N6OZU=; b=gNrXRLkr4wET0rhCYVE+FJs4b5
        QFoH6Cu6xcJleijFYdTkM7dmCgTa4XfoBytk6MpDxIyz08o2A/8RkZH3gryu3nlbwOLZ26DYIneIl
        Ua7Tjmx8OwFTKSEwWFq9X8TGP69WA8TZ7zggU2dHpke4M25+6x4L6L6sEnvC8spUrXQUFd4F+HznJ
        dDspLp8Z0n9VRNRzz4fAzr1IfWHZeXiLVItSYmu0YnFA/Zo7YqUcmOAuaL0yV8HxUjaVVLEgiM4kD
        smkOaI2oD/jLJ/jrbRqjBbTG2M0IXrYagiHv2JM4jLwuRAzwVDIf9lohaVPWGr8vyP3i69dBlanq/
        /BY1MD2g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qaP-1g; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 0/9] Remove _folio_dtor and _folio_order
Date:   Tue, 15 Aug 2023 04:26:36 +0100
Message-Id: <20230815032645.1393700-1-willy@infradead.org>
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

This started out as "I should remove the indirect function call from
freeing compound pages" and turned into "I can free up some space in
struct folio".  So ... what am I bid for the new contents of this word
in the first tail page?

Matthew Wilcox (Oracle) (9):
  io_uring: Stop calling free_compound_page()
  mm: Call the hugetlb destructor directly
  mm: Call free_transhuge_folio() directly from destroy_large_folio()
  mm: Make free_compound_page() static
  mm: Remove free_compound_page()
  mm: Remove HUGETLB_PAGE_DTOR
  mm: Add deferred_list page flag
  mm: Rearrange page flags
  mm: Free up a word in the first tail page

 .../admin-guide/kdump/vmcoreinfo.rst          | 14 +---
 include/linux/huge_mm.h                       |  2 +-
 include/linux/hugetlb.h                       |  3 +-
 include/linux/mm.h                            | 39 ++--------
 include/linux/mm_types.h                      |  5 +-
 include/linux/page-flags.h                    | 41 +++++++---
 io_uring/io_uring.c                           |  6 +-
 io_uring/kbuf.c                               |  6 +-
 kernel/crash_core.c                           |  4 +-
 mm/huge_memory.c                              |  8 +-
 mm/hugetlb.c                                  | 75 +++++--------------
 mm/internal.h                                 |  3 +-
 mm/page_alloc.c                               | 35 +++------
 13 files changed, 81 insertions(+), 160 deletions(-)

-- 
2.40.1

