Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166DE23FD03
	for <lists+io-uring@lfdr.de>; Sun,  9 Aug 2020 08:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgHIGbA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 Aug 2020 02:31:00 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbgHIGbA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 Aug 2020 02:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596954659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7WZddFwwKHu/gIcw1qCLu59BphJ+2feFSV3X2iMviU=;
        b=aftQdf+GbJmgYi/ovYA1Vrdmq3NwY0Y6m7V5RfnvFDZECBoK4D61/HEcORBb33NIFV/XIK
        1HCDYlKCiiw0a7zcaCKj2IF4AOlU0HjtI48WP98rQPQb59L/Vk3oU2W7L/ZVhm3/FUSj80
        iRH16CugY3owMCKEVAZZGPYYAbwV8M8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-zdRvRjmNMbynuK3VCKnpuQ-1; Sun, 09 Aug 2020 02:30:57 -0400
X-MC-Unique: zdRvRjmNMbynuK3VCKnpuQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35EE58015CE;
        Sun,  9 Aug 2020 06:30:56 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9C9F5F9DC;
        Sun,  9 Aug 2020 06:30:54 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCH v2 3/4] fsstress: fix memory leak in do_aio_rw
Date:   Sun,  9 Aug 2020 14:30:39 +0800
Message-Id: <20200809063040.15521-4-zlang@redhat.com>
In-Reply-To: <20200809063040.15521-1-zlang@redhat.com>
References: <20200809063040.15521-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 0e7be6bb..4b255bf6 100644
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

