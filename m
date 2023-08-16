Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2377E4C7
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 17:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344038AbjHPPMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 11:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344066AbjHPPMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 11:12:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B2726A5
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 08:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BwcfAds/xhqZWiqRvjYyKhMdZCr8x2s3ljtlneKBAzo=; b=eMVhuX7hG9c7mw95dVUC5g5w4t
        hY8TCVDL86DD/XbzNDAA4HQBlF/etzuazHCgmR7BNO+kWirnhhiSbT3bCKya7lLe6DZpzkuFdhkM6
        +7HRmMgUwUaiFX3yDvVdVFil0NVo/CYS2jUu2YP5lJ4+dTilOgLgpOgmGyptMGHz5caPfvauvbX+R
        aFbVRLbczS/xXGM6RV3PCLjq0i+S7tEGZmj941zqJ2dgzErrqNyMKHGvhwNexx6b6hP3HBOI14FP5
        6j5fnndwE7Y1tn0OBzq8AMmXOee1K1U9CDHkTxYSNy7njUxf0o/RU3ySF7d88ogszL/qnvCtod59V
        FhKohhCA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qWIBu-00FL90-UO; Wed, 16 Aug 2023 15:12:10 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v2 12/13] mm: Add tail private fields to struct folio
Date:   Wed, 16 Aug 2023 16:12:00 +0100
Message-Id: <20230816151201.3655946-13-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230816151201.3655946-1-willy@infradead.org>
References: <20230816151201.3655946-1-willy@infradead.org>
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

Because THP_SWAP uses page->private for each page, we must not use
the space which overlaps that field for anything which would conflict
with that.  We avoid the conflict on 32-bit systems by disallowing
THP_SWAP on 32-bit.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 659c7b84726c..3880b3f2e321 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -340,8 +340,11 @@ struct folio {
 			atomic_t _pincount;
 #ifdef CONFIG_64BIT
 			unsigned int _folio_nr_pages;
-#endif
+			/* 4 byte gap here */
 	/* private: the union with struct page is transitional */
+			/* Fix THP_SWAP to not use tail->private */
+			unsigned long _private_1;
+#endif
 		};
 		struct page __page_1;
 	};
@@ -362,6 +365,9 @@ struct folio {
 	/* public: */
 			struct list_head _deferred_list;
 	/* private: the union with struct page is transitional */
+			unsigned long _avail_2a;
+			/* Fix THP_SWAP to not use tail->private */
+			unsigned long _private_2a;
 		};
 		struct page __page_2;
 	};
@@ -386,12 +392,18 @@ FOLIO_MATCH(memcg_data, memcg_data);
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
 FOLIO_MATCH(compound_head, _head_1);
+#ifdef CONFIG_64BIT
+FOLIO_MATCH(private, _private_1);
+#endif
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct folio, fl) ==			\
 			offsetof(struct page, pg) + 2 * sizeof(struct page))
 FOLIO_MATCH(flags, _flags_2);
 FOLIO_MATCH(compound_head, _head_2);
+FOLIO_MATCH(flags, _flags_2a);
+FOLIO_MATCH(compound_head, _head_2a);
+FOLIO_MATCH(private, _private_2a);
 #undef FOLIO_MATCH
 
 /*
-- 
2.40.1

