Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967A477C661
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 05:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbjHODbt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Aug 2023 23:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbjHOD3n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Aug 2023 23:29:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1991FEC
        for <io-uring@vger.kernel.org>; Mon, 14 Aug 2023 20:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9TGxu02Zdrue3buZphZr1o0ZlYN5TBIdyw14ApHva+w=; b=XGGquuzkKlPlaPg5Kj620RMtNL
        wJlRYlv2SOYquRt/UO44pwc0Kxd+sofv+wwr+9IY2kWMhuMuQjkOOnOs3mIHfU1zlzJDNWC/U7k9g
        gFLBcqCXKvz/SN3ggNZWOFB+FcA13nj6oogxs6K7R97+MWgJixPSB3EpF4PyGnu6RPZHEyAeKk6/7
        Qg4Pcq+yJE+xsb3RLlA4qQrL0SS6kFwjlqx+xj8bFps/NhfGtdnUx9cOAxrbQM/s02adcHyoS+v6i
        vQ7PmanJpRAdAVFHN/x8eHflCkJLeBZETAceSujqZDGcsDaa4tFMSkdUf6GChrorsPCS4bDn8pBQm
        gFYqTYuw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qVkhm-005qaZ-I5; Tue, 15 Aug 2023 03:26:50 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 5/9] mm: Remove free_compound_page()
Date:   Tue, 15 Aug 2023 04:26:41 +0100
Message-Id: <20230815032645.1393700-6-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230815032645.1393700-1-willy@infradead.org>
References: <20230815032645.1393700-1-willy@infradead.org>
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

Inline it into its one caller.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/page_alloc.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 804982faba4e..21af71aea6eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -589,12 +589,6 @@ static inline void free_the_page(struct page *page, unsigned int order)
  * This usage means that zero-order pages may not be compound.
  */
 
-static void free_compound_page(struct folio *folio)
-{
-	mem_cgroup_uncharge(folio);
-	free_the_page(&folio->page, folio_order(folio));
-}
-
 void prep_compound_page(struct page *page, unsigned int order)
 {
 	int i;
@@ -618,7 +612,8 @@ void destroy_large_folio(struct folio *folio)
 
 	if (folio_test_transhuge(folio) && dtor == TRANSHUGE_PAGE_DTOR)
 		free_transhuge_folio(folio);
-	free_compound_page(folio);
+	mem_cgroup_uncharge(folio);
+	free_the_page(&folio->page, folio_order(folio));
 }
 
 static inline void set_buddy_order(struct page *page, unsigned int order)
-- 
2.40.1

