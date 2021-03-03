Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9032C5B0
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359272AbhCDAYD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:03 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:35497 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442100AbhCCL60 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 06:58:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UQGMHlb_1614772661;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQGMHlb_1614772661)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 19:57:41 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     msnitzer@redhat.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, mpatocka@redhat.com,
        caspar@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: [PATCH v5 01/12] block: move definition of blk_qc_t to types.h
Date:   Wed,  3 Mar 2021 19:57:29 +0800
Message-Id: <20210303115740.127001-2-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So that kiocb.ki_cookie can be defined as blk_qc_t, which will enforce
the encapsulation.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blk_types.h | 2 +-
 include/linux/fs.h        | 2 +-
 include/linux/types.h     | 3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..fb429daaa909 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -505,7 +505,7 @@ static inline int op_stat_group(unsigned int op)
 	return op_is_write(op);
 }
 
-typedef unsigned int blk_qc_t;
+/* Macros for blk_qc_t */
 #define BLK_QC_T_NONE		-1U
 #define BLK_QC_T_SHIFT		16
 #define BLK_QC_T_INTERNAL	(1U << 31)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ec8f3ddf4a6a..8b14dacf618d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -332,7 +332,7 @@ struct kiocb {
 	u16			ki_hint;
 	u16			ki_ioprio; /* See linux/ioprio.h */
 	union {
-		unsigned int		ki_cookie; /* for ->iopoll */
+		blk_qc_t		ki_cookie; /* for ->iopoll */
 		struct wait_page_queue	*ki_waitq; /* for async buffered IO */
 	};
 
diff --git a/include/linux/types.h b/include/linux/types.h
index ac825ad90e44..52a54ed6ffac 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -125,6 +125,9 @@ typedef s64			int64_t;
 typedef u64 sector_t;
 typedef u64 blkcnt_t;
 
+/* cookie used for IO polling */
+typedef unsigned int blk_qc_t;
+
 /*
  * The type of an index into the pagecache.
  */
-- 
2.27.0

