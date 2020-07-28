Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707EE231195
	for <lists+io-uring@lfdr.de>; Tue, 28 Jul 2020 20:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbgG1SYB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jul 2020 14:24:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732329AbgG1SYA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jul 2020 14:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595960639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BvLLniNma7qFXHVXKr+V0FVyWHhRwlayjCU6NK0NUYE=;
        b=E1BaYpe7mh1ugv+opRAgV7OGyqZDp5hQ2DHppcNSKX1nW/k6Oe+mWFhhx7mqJdUgdbug9/
        fgnWNQg5FpupIPB05jYjpoOmH0DyYI01fkpu+HGVySDqQd6PaCYgirLPD96qdCMpjRSKDf
        67oqGqkfH6OtsP0w9vzwaOe7cFFyhUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-lOKCOXTaOaqf6U_dPFiXHg-1; Tue, 28 Jul 2020 14:23:55 -0400
X-MC-Unique: lOKCOXTaOaqf6U_dPFiXHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B75028017FB;
        Tue, 28 Jul 2020 18:23:54 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-108.pek2.redhat.com [10.72.12.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33BAA5DA33;
        Tue, 28 Jul 2020 18:23:52 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCH 3/4] fsstress: fix memory leak in do_aio_rw
Date:   Wed, 29 Jul 2020 02:23:19 +0800
Message-Id: <20200728182320.8762-4-zlang@redhat.com>
In-Reply-To: <20200728182320.8762-1-zlang@redhat.com>
References: <20200728182320.8762-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_submit or io_getevents fails, the do_aio_rw() won't free the
"buf" and cause memory leak.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 ltp/fsstress.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index a11206d4..410a2437 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2099,8 +2099,7 @@ do_aio_rw(int opno, long r, int flags)
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: do_aio_rw - no filename\n", procid, opno);
-		free_pathname(&f);
-		return;
+		goto aio_out3;
 	}
 	fd = open_path(&f, flags|O_DIRECT);
 	e = fd < 0 ? errno : 0;
@@ -2109,16 +2108,13 @@ do_aio_rw(int opno, long r, int flags)
 		if (v)
 			printf("%d/%d: do_aio_rw - open %s failed %d\n",
 			       procid, opno, f.path, e);
-		free_pathname(&f);
-		return;
+		goto aio_out3;
 	}
 	if (fstat64(fd, &stb) < 0) {
 		if (v)
 			printf("%d/%d: do_aio_rw - fstat64 %s failed %d\n",
 			       procid, opno, f.path, errno);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto aio_out2;
 	}
 	inode_info(st, sizeof(st), &stb, v);
 	if (!iswrite && stb.st_size == 0) {
@@ -2150,6 +2146,12 @@ do_aio_rw(int opno, long r, int flags)
 	else if (len > diob.d_maxiosz)
 		len = diob.d_maxiosz;
 	buf = memalign(diob.d_mem, len);
+	if (!buf) {
+		if (v)
+			printf("%d/%d: do_aio_rw - memalign failed\n",
+			       procid, opno);
+		goto aio_out2;
+	}
 
 	if (iswrite) {
 		off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
@@ -2166,27 +2168,26 @@ do_aio_rw(int opno, long r, int flags)
 		if (v)
 			printf("%d/%d: %s - io_submit failed %d\n",
 			       procid, opno, iswrite ? "awrite" : "aread", e);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto aio_out1;
 	}
 	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
 		if (v)
 			printf("%d/%d: %s - io_getevents failed %d\n",
 			       procid, opno, iswrite ? "awrite" : "aread", e);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto aio_out1;
 	}
 
 	e = event.res != len ? event.res2 : 0;
-	free(buf);
 	if (v)
 		printf("%d/%d: %s %s%s [%lld,%d] %d\n",
 		       procid, opno, iswrite ? "awrite" : "aread",
 		       f.path, st, (long long)off, (int)len, e);
-	free_pathname(&f);
+ aio_out1:
+	free(buf);
+ aio_out2:
 	close(fd);
+ aio_out3:
+	free_pathname(&f);
 }
 #endif
 
-- 
2.20.1

