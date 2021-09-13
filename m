Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE714097B2
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 17:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243926AbhIMPpx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 11:45:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245662AbhIMPpl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 11:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631547865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=V7twJwM4PhCAu/6IhOjA346MNvtqV4r43Qxb7zI62kA=;
        b=PoCbcXbQZybksU0X0fG91fxwRARz3XOo9KjoI4JH8FCrmkQMGDRO1vnAbBtMEv+NBqhJ44
        eJT39T8Vr2p9Ixay95cpiSZy4SxJu7XvSTNgA7HL29dS4d9vU7/Fk2WTVzLBNMgo/RRYmR
        4CX6lykbpsemJD4YeI3IsYq0EXp4CsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-1VMFl39vNV2EE0DCDLLoEA-1; Mon, 13 Sep 2021 11:44:21 -0400
X-MC-Unique: 1VMFl39vNV2EE0DCDLLoEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A4111006AA2;
        Mon, 13 Sep 2021 15:44:20 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A2C25D9CA;
        Mon, 13 Sep 2021 15:44:17 +0000 (UTC)
Date:   Mon, 13 Sep 2021 17:44:15 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@strace.io>, linux-api@vger.kernel.org
Subject: [PATCH v3] io-wq: provide IO_WQ_* constants for
 IORING_REGISTER_IOWQ_MAX_WORKERS arg items
Message-ID: <20210913154415.GA12890@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The items passed in the array pointed by the arg parameter
of IORING_REGISTER_IOWQ_MAX_WORKERS io_uring_register operation
carry certain semantics: they refer to different io-wq worker categories;
provide IO_WQ_* constants in the UAPI, so these categories can be referenced
in the user space code.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Complements: 2e480058ddc21ec5 ("io-wq: provide a way to limit max number of workers")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
v3:
 - Constants are named in accordance with the suggestion, the internal enum
   is no longer touched, BUILD_BUG_ON checks are added.

v2: https://lore.kernel.org/lkml/20210913104101.GA29616@asgard.redhat.com/
 - IO_WQ_ACCT_NR is no longer exposed directly in UAPI, per Jens Axboe's
    suggestion.

v1: https://lore.kernel.org/lkml/20210912122411.GA27679@asgard.redhat.com/
---
 fs/io-wq.c                    | 5 +++++
 include/uapi/linux/io_uring.h | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 6c55362..3d21568 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -14,6 +14,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
 #include <linux/tracehook.h>
+#include <uapi/linux/io_uring.h>
 
 #include "io-wq.h"
 
@@ -1287,6 +1288,10 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 {
 	int i, node, prev = 0;
 
+	BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
+	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
+
 	for (i = 0; i < 2; i++) {
 		if (new_count[i] > task_rlimit(current, RLIMIT_NPROC))
 			new_count[i] = task_rlimit(current, RLIMIT_NPROC);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 59ef351..b270a07 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -317,13 +317,19 @@ enum {
 	IORING_REGISTER_IOWQ_AFF		= 17,
 	IORING_UNREGISTER_IOWQ_AFF		= 18,
 
-	/* set/get max number of workers */
+	/* set/get max number of io-wq workers */
 	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
 
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
 
+/* io-wq worker categories */
+enum {
+	IO_WQ_BOUND,
+	IO_WQ_UNBOUND,
+};
+
 /* deprecated, see struct io_uring_rsrc_update */
 struct io_uring_files_update {
 	__u32 offset;
-- 
2.1.4

