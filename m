Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E91825EF68
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 19:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgIFRzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 13:55:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46910 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725841AbgIFRzi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 13:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599414936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2ESFoDScRqkNFgfiA5qP2YEUqKxlI9y9v1FiMMt9OM=;
        b=C/QGYjQIj3TMRJhIkqQs3MYhRQIo2nx+o1DnpMQgszyUd4/sfdgO1ovw6ze4TRkHYInYIo
        +fvhZNQ686iI8sIztm/I9Stbq3UZBGtUXn+CqCwYS2w3Mm/cUtBA7d4TDAoxvyspCvvdHF
        LCh1TooaF3SQc9Xuhc+eXOEDTpgytnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-mmj_-QyhP0ShL1zzQKJrqw-1; Sun, 06 Sep 2020 13:55:35 -0400
X-MC-Unique: mmj_-QyhP0ShL1zzQKJrqw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C776802B5C;
        Sun,  6 Sep 2020 17:55:34 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7785F7E410;
        Sun,  6 Sep 2020 17:55:32 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     bfoster@redhat.com, io-uring@vger.kernel.org
Subject: [PATCH v4 4/5] fsx: introduce fsx_rw to combine aio_rw with general read and write
Date:   Mon,  7 Sep 2020 01:55:12 +0800
Message-Id: <20200906175513.17595-5-zlang@redhat.com>
In-Reply-To: <20200906175513.17595-1-zlang@redhat.com>
References: <20200906175513.17595-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The fsx contains different read and write operations, especially the
AIO and general IO read/write. The fsx chooses one kind of read/write
from AIO and general IO to run. To make the logic clear, use a common
fsx_rw() function to swith between these two kinds of read/write.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 ltp/fsx.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 7c76655a..92f506ba 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -181,16 +181,11 @@ int	mark_nr = 0;
 int page_size;
 int page_mask;
 int mmap_mask;
-#ifdef AIO
-int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
+int fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset);
 #define READ 0
 #define WRITE 1
-#define fsxread(a,b,c,d)	aio_rw(READ, a,b,c,d)
-#define fsxwrite(a,b,c,d)	aio_rw(WRITE, a,b,c,d)
-#else
-#define fsxread(a,b,c,d)	read(a,b,c)
-#define fsxwrite(a,b,c,d)	write(a,b,c)
-#endif
+#define fsxread(a,b,c,d)	fsx_rw(READ, a,b,c,d)
+#define fsxwrite(a,b,c,d)	fsx_rw(WRITE, a,b,c,d)
 
 const char *replayops = NULL;
 const char *recordops = NULL;
@@ -2347,7 +2342,8 @@ getnum(char *s, char **e)
 io_context_t	io_ctx;
 struct iocb 	iocb;
 
-int aio_setup()
+int
+aio_setup()
 {
 	int ret;
 	ret = io_queue_init(QSZ, &io_ctx);
@@ -2360,7 +2356,7 @@ int aio_setup()
 }
 
 int
-__aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
+aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 {
 	struct io_event event;
 	static struct timespec ts;
@@ -2425,13 +2421,21 @@ out_error:
 	errno = -ret;
 	return -1;
 }
+#else
+aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
+{
+	fprintf(stderr, "io_rw: need AIO support!\n");
+	exit(111);
+}
+#endif
 
-int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
+int
+fsx_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 {
 	int ret;
 
 	if (aio) {
-		ret = __aio_rw(rw, fd, buf, len, offset);
+		ret = aio_rw(rw, fd, buf, len, offset);
 	} else {
 		if (rw == READ)
 			ret = read(fd, buf, len);
@@ -2441,8 +2445,6 @@ int aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
 	return ret;
 }
 
-#endif
-
 #define test_fallocate(mode) __test_fallocate(mode, #mode)
 
 int
@@ -2602,7 +2604,7 @@ main(int argc, char **argv)
 			do_fsync = 1;
 			break;
 		case 'A':
-		        aio = 1;
+			aio = 1;
 			break;
 		case 'D':
 			debugstart = getnum(optarg, &endp);
-- 
2.20.1

