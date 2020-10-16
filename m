Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED64290911
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409137AbgJPQCc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410483AbgJPQCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423DCC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so1704066pgf.9
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NEE/697mkfmi/kyqcq8RKiN2D6Cp0twEjPOeqWdh2Dc=;
        b=oKvgiNFGxPnY2kBRAlQGQJNvyTqqUzCTSsJP/M8DxHzu1IYVrPCv/vamdrqqqwNjpS
         2b5GMasXHKOvCnEg9y3XpxNzur2H2F3zQ9MlP1BpA/JYcWOqyRZMisQpqWl8Dk0REkG6
         PF8cBYIeM+VD6GkungNWlpmJT+rPlfR+crV5n2aEDQarTCRLxI0iUUm70zk4ETTu52bV
         Z6NSJZwf54QeJ4eRpuOuDKsyEgNQekCaeyyXBgqlo1jRGd2D7LInGmX5yyN62WPfC1me
         xwM4U25u1bj95UIldrz/fWWl18lUnmslY4tHIrEJdzNVdPFg70JOuXs3F9YhX5A1C5d4
         /MxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NEE/697mkfmi/kyqcq8RKiN2D6Cp0twEjPOeqWdh2Dc=;
        b=DYe1z3W1A//qlh5ZJlkAsW1PIxSteObGuoIGQElsa3fN69nM9YZpGgASjGnGbFDt7e
         In0XkRIlp+tk/tyJkBZJnUQnOSXIYkiTyc/68TtheFbanzL9q1AKk0oz/DBvowH6ymcI
         2PqNsYdTERyrq1CBhXiNTVwpBuHvWY5f8csBpitlfVI1YFkgB1DFliQCKgP9yu52l3yZ
         yxSp2sVDG13AmULKLxhzJTbTo/B1N7C+UMS0y/GEv3KtxuwULNcZLzGXSwI4u7tCmCSD
         WJlUGAdZmlEITDWEPYFkAFrNgaxhao7/JBY+sqKhzidUOqlfEcDB2/tLbEGi4xOkzwNS
         x8Ow==
X-Gm-Message-State: AOAM531g4oDFRorq3A8Bwt+SRsUbs92cLAMzn/R196SaKmkpJoxv5+gl
        tpSJLySE17k8Eh2ZeBE+I3Ob5eqO8mapz+9R
X-Google-Smtp-Source: ABdhPJxB1SvtZgMmJeTl/kUCkTsR0kpr54OYNtY+R1+veLiVnL3QlqEi/vM9XvQGgGOBDKbwDKsAdg==
X-Received: by 2002:a62:2a94:0:b029:155:3225:6fd0 with SMTP id q142-20020a622a940000b029015532256fd0mr4467893pfq.64.1602864150791;
        Fri, 16 Oct 2020 09:02:30 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 02/18] readahead: use limited read-ahead to satisfy read
Date:   Fri, 16 Oct 2020 10:02:08 -0600
Message-Id: <20201016160224.1575329-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Willy reports that there's a case where async buffered reads will be
blocking, and that's due to not using read-ahead to generate the reads
when read-ahead is disabled. io_uring relies on read-ahead triggering
the reads, if not, it needs to fallback to threaded helpers.

For the case where read-ahead is disabled on the file, or if the cgroup
is congested, ensure that we can at least do 1 page of read-ahead to
make progress on the read in an async fashion. This could potentially be
larger, but it's not needed in terms of functionality, so let's error on
the side of caution as larger counts of pages may run into reclaim
issues (particularly if we're congested).

Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/readahead.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 3c9a8dd7c56c..b014d122e656 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -568,15 +568,23 @@ void page_cache_sync_readahead(struct address_space *mapping,
 			       struct file_ra_state *ra, struct file *filp,
 			       pgoff_t index, unsigned long req_count)
 {
-	/* no read-ahead */
-	if (!ra->ra_pages)
-		return;
+	bool do_forced_ra = filp && (filp->f_mode & FMODE_RANDOM);
 
-	if (blk_cgroup_congested())
-		return;
+	/*
+	 * Even if read-ahead is disabled, start this request as read-ahead.
+	 * This makes regular read-ahead disabled use the same path as normal
+	 * reads, instead of having to punt to ->readpage() manually. We limit
+	 * ourselves to 1 page for this case, to avoid causing problems if
+	 * we're congested or tight on memory.
+	 */
+	if (!ra->ra_pages || blk_cgroup_congested()) {
+		if (!filp)
+			return;
+		req_count = 1;
+		do_forced_ra = true;
+	}
 
-	/* be dumb */
-	if (filp && (filp->f_mode & FMODE_RANDOM)) {
+	if (do_forced_ra) {
 		force_page_cache_readahead(mapping, filp, index, req_count);
 		return;
 	}
-- 
2.28.0

