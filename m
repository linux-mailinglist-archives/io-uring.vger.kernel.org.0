Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F566407D41
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 14:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhILMZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 08:25:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234934AbhILMZe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 08:25:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631449459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=kSMQ7FcWTca/lDUFvTPr19EeuC6JIanruPuX/Ww0Ws0=;
        b=F3bc8i5HJS7Yh2sExHshwILgxeCinIvHPUYuZfnaR7/klZQjvERyo2HUzRVJuf+0Vj6wWx
        FBmK/si0/YAtk3kN/tNP2fupYKPPmYw/dClxidsHy6Dnd4Xclt3fMAxwDwqgGcFgpV3Qgj
        VOPKshl95MqZgPnPuugBNA3C6Ij0dpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-dO_fRsVFP2avHZvo_C71Uw-1; Sun, 12 Sep 2021 08:24:18 -0400
X-MC-Unique: dO_fRsVFP2avHZvo_C71Uw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 783C3801B3D;
        Sun, 12 Sep 2021 12:24:17 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 086EB5C23A;
        Sun, 12 Sep 2021 12:24:14 +0000 (UTC)
Date:   Sun, 12 Sep 2021 14:24:11 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@strace.io>, linux-api@vger.kernel.org
Subject: [PATCH] io-wq: expose IO_WQ_ACCT_* enumeration items to UAPI
Message-ID: <20210912122411.GA27679@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These are used to index aargument of IORING_REGISTER_IOWQ_MAX_WORKERS
io_uring_register command, so they are to be exposed in UAPI.

Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 fs/io-wq.c                    | 7 +------
 include/uapi/linux/io_uring.h | 8 ++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 6c55362..5e7cd7c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -14,6 +14,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
 #include <linux/tracehook.h>
+#include <uapi/linux/io_uring.h>
 
 #include "io-wq.h"
 
@@ -77,12 +78,6 @@ struct io_wqe_acct {
 	unsigned long flags;
 };
 
-enum {
-	IO_WQ_ACCT_BOUND,
-	IO_WQ_ACCT_UNBOUND,
-	IO_WQ_ACCT_NR,
-};
-
 /*
  * Per-node worker thread pool
  */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 59ef351..d67a3cc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -324,6 +324,14 @@ enum {
 	IORING_REGISTER_LAST
 };
 
+/* io-wq worker limit categories */
+enum {
+	IO_WQ_ACCT_BOUND,
+	IO_WQ_ACCT_UNBOUND,
+
+	IO_WQ_ACCT_NR /* Non-UAPI */
+};
+
 /* deprecated, see struct io_uring_rsrc_update */
 struct io_uring_files_update {
 	__u32 offset;
-- 
2.1.4

