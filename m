Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3802211F7
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 18:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGOQIw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 12:08:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726907AbgGOQIr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 12:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594829298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BvLLniNma7qFXHVXKr+V0FVyWHhRwlayjCU6NK0NUYE=;
        b=DOiQ7MLUIje3p1oWz/ilpQ/Og1/f9DDDVy+MvbU4FKPBqXaaok6qpxKo4HLtsly71uHV79
        1YP5kQaOpgRXMltE8aIfcCzhtemHfKVmUWxNh3ljMMAZEEQtJU3HN74ZFiivkbf3R+BGH8
        G5ETXnY61QkwdBJ3nHGidBg2T7MU/Oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-orQPS7gsM5uj0AkVb_lqTg-1; Wed, 15 Jul 2020 12:08:14 -0400
X-MC-Unique: orQPS7gsM5uj0AkVb_lqTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F11118FF66A;
        Wed, 15 Jul 2020 16:08:12 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-13-249.pek2.redhat.com [10.72.13.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EFA16FDD1;
        Wed, 15 Jul 2020 16:08:10 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] fsstress: fix memory leak in do_aio_rw
Date:   Thu, 16 Jul 2020 00:07:55 +0800
Message-Id: <20200715160755.14392-4-zlang@redhat.com>
In-Reply-To: <20200715160755.14392-1-zlang@redhat.com>
References: <20200715160755.14392-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

