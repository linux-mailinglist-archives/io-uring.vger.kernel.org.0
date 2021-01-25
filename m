Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843593033F7
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 06:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbhAZFKX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:23 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:39364 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727874AbhAYMPh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:15:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UMqjSkl_1611576821;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UMqjSkl_1611576821)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 20:13:41 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v2 1/6] block: move definition of blk_qc_t to types.h
Date:   Mon, 25 Jan 2021 20:13:35 +0800
Message-Id: <20210125121340.70459-2-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
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
index 866f74261b3b..2e05244fc16d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -532,7 +532,7 @@ static inline int op_stat_group(unsigned int op)
 	return op_is_write(op);
 }
 
-typedef unsigned int blk_qc_t;
+/* Macros for blk_qc_t */
 #define BLK_QC_T_NONE		-1U
 #define BLK_QC_T_SHIFT		16
 #define BLK_QC_T_INTERNAL	(1U << 31)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fd47deea7c17..04b687150736 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -330,7 +330,7 @@ struct kiocb {
 	u16			ki_hint;
 	u16			ki_ioprio; /* See linux/ioprio.h */
 	union {
-		unsigned int		ki_cookie; /* for ->iopoll */
+		blk_qc_t		ki_cookie; /* for ->iopoll */
 		struct wait_page_queue	*ki_waitq; /* for async buffered IO */
 	};
 
diff --git a/include/linux/types.h b/include/linux/types.h
index a147977602b5..da5ca7e1bea9 100644
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

