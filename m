Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A52425EF67
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 19:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgIFRzi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 13:55:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21847 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729094AbgIFRzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 13:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599414933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lbP4q6DciQ+aJpWWYEQncynQ2RWi+yThhJeCyFUHzpo=;
        b=cMAEopuoTA7UXuT4al1VlFUZtiINyDTE8ZT/j+8KJxYov1WbFNo6q2Dhrui5p61mARTP5o
        x87cHkR0jW+9sm1eNmadqJA6/taUpvDt+KmQVlhojGbcFhgrZXFiJERr0YkWfkgJvy87QD
        8sUA6xzJrZy+t/ZxUI55zAKKAc/xaPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-XSpnbYD5NKW5EGd-mczBww-1; Sun, 06 Sep 2020 13:55:31 -0400
X-MC-Unique: XSpnbYD5NKW5EGd-mczBww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0B29802B5C;
        Sun,  6 Sep 2020 17:55:30 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 582DB9CBA;
        Sun,  6 Sep 2020 17:55:29 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     bfoster@redhat.com, io-uring@vger.kernel.org
Subject: [PATCH v4 3/5] fsstress: fix memory leak in do_aio_rw
Date:   Mon,  7 Sep 2020 01:55:11 +0800
Message-Id: <20200906175513.17595-4-zlang@redhat.com>
In-Reply-To: <20200906175513.17595-1-zlang@redhat.com>
References: <20200906175513.17595-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If io_submit or io_getevents fails, the do_aio_rw() won't free the
"buf" and cause memory leak.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 ltp/fsstress.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b4a51376..c0e587a3 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2078,11 +2078,11 @@ void
 do_aio_rw(int opno, long r, int flags)
 {
 	int64_t		align;
-	char		*buf;
+	char		*buf = NULL;
 	struct dioattr	diob;
 	int		e;
 	pathname_t	f;
-	int		fd;
+	int		fd = -1;
 	size_t		len;
 	int64_t		lr;
 	off64_t		off;
@@ -2099,8 +2099,7 @@ do_aio_rw(int opno, long r, int flags)
 	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
 		if (v)
 			printf("%d/%d: do_aio_rw - no filename\n", procid, opno);
-		free_pathname(&f);
-		return;
+		goto aio_out;
 	}
 	fd = open_path(&f, flags|O_DIRECT);
 	e = fd < 0 ? errno : 0;
@@ -2109,25 +2108,20 @@ do_aio_rw(int opno, long r, int flags)
 		if (v)
 			printf("%d/%d: do_aio_rw - open %s failed %d\n",
 			       procid, opno, f.path, e);
-		free_pathname(&f);
-		return;
+		goto aio_out;
 	}
 	if (fstat64(fd, &stb) < 0) {
 		if (v)
 			printf("%d/%d: do_aio_rw - fstat64 %s failed %d\n",
 			       procid, opno, f.path, errno);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto aio_out;
 	}
 	inode_info(st, sizeof(st), &stb, v);
 	if (!iswrite && stb.st_size == 0) {
 		if (v)
 			printf("%d/%d: do_aio_rw - %s%s zero size\n", procid, opno,
 			       f.path, st);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto aio_out;
 	}
 	if (xfsctl(f.path, fd, XFS_IOC_DIOINFO, &diob) < 0) {
 		if (v)
@@ -2150,6 +2144,12 @@ do_aio_rw(int opno, long r, int flags)
 	else if (len > diob.d_maxiosz)
 		len = diob.d_maxiosz;
 	buf = memalign(diob.d_mem, len);
+	if (!buf) {
+		if (v)
+			printf("%d/%d: do_aio_rw - memalign failed\n",
+			       procid, opno);
+		goto aio_out;
+	}
 
 	if (iswrite) {
 		off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
@@ -2166,27 +2166,26 @@ do_aio_rw(int opno, long r, int flags)
 		if (v)
 			printf("%d/%d: %s - io_submit failed %d\n",
 			       procid, opno, iswrite ? "awrite" : "aread", e);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto aio_out;
 	}
 	if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
 		if (v)
 			printf("%d/%d: %s - io_getevents failed %d\n",
 			       procid, opno, iswrite ? "awrite" : "aread", e);
-		free_pathname(&f);
-		close(fd);
-		return;
+		goto aio_out;
 	}
 
 	e = event.res != len ? event.res2 : 0;
-	free(buf);
 	if (v)
 		printf("%d/%d: %s %s%s [%lld,%d] %d\n",
 		       procid, opno, iswrite ? "awrite" : "aread",
 		       f.path, st, (long long)off, (int)len, e);
+ aio_out:
+	if (buf)
+		free(buf);
+	if (fd > 0)
+		close(fd);
 	free_pathname(&f);
-	close(fd);
 }
 #endif
 
-- 
2.20.1

