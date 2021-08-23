Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B583F4987
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 13:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbhHWLST (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 07:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbhHWLST (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 07:18:19 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DBCC061575
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 04:17:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id f5so25665232wrm.13
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 04:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6nmvnxgjdb/POH/JG2a/FNStbF9ujZHJNEV63j7T/nA=;
        b=Gc91liKwv+UcWK51rOz+xL1xPNS9cvf6no8YM2d1S/zNxrJXTtA08e3VI9asxQmB1X
         MW930Y9Jvu3e6A/JXLTCKqMdMzWbrNsqt8iwFIVFnVqed6mJa+0GYl9gMwgs5LjLxajN
         VXCRW80QVxSd8r7DZFnd7fSTg6NH9uWVr8Q3uLtCIOBZObHhhdoN/3orz2DTl4P2mhOy
         MRgTbIA6lY2/NgsULnzoTjtZjQ8nl2dly2e3Vl6G3ksPFBu4LeNHEojSdTgxeANR9tzk
         jdoTWtgz4aenwKYqz2WJQJhHQo9SskXNwKHEBdTal3p58TsAkR19C9KPqI9m1S2yIzyl
         H8tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6nmvnxgjdb/POH/JG2a/FNStbF9ujZHJNEV63j7T/nA=;
        b=Jcr0XRJ3UZlzRnztpskQxFLuzQ8DV3z4TkUhIgmWYr1gZX5UascBn5aZct1MMHPU/j
         2IfKKpwiOrxifC3Bu1WQ94h1o5vQAjxvRcV1z5KLRSSZABsDNoB5Q3witMGI+IBk9+5M
         D4U66zw1iG8IDCUg+T0SxER5R6dvAz6aYErjuRWEo+zcewjRscPT8kQtbbHdRlaD4mun
         7olHaNw5aofJ5hdE2kXKXputhoie+g4ByDHqxNMwuiUcaTkb33wWQwAI6TvzZhBy/W4I
         24rTvvnLGeEZkw9cVG+M1S1DCThkt55UocVwEmwdDPiT+NRAWMzV50Zm6razVl3SYLkD
         axUw==
X-Gm-Message-State: AOAM532/EOCwbZcXt2iABlZs1Jffi6dXT0NAnXWQTakOw8huYoFtsXMF
        Cbm0pgFObZwzvmiGqsxz/mA=
X-Google-Smtp-Source: ABdhPJyvfLlVOmwgVYiTSSb7tHcPvqE33S6nCXit1SVgaQNdmhz2AyDf+SQjGuSBkIl32TYsYTJtkg==
X-Received: by 2002:a5d:65cd:: with SMTP id e13mr12955523wrw.368.1629717455401;
        Mon, 23 Aug 2021 04:17:35 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id w18sm15718107wrg.68.2021.08.23.04.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 04:17:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: add IOSQE_ASYNC cancel testing
Date:   Mon, 23 Aug 2021 12:16:56 +0100
Message-Id: <b5dada6cba71207dd8b282a805714a4fe8db2258.1629717388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We miss tests for IORING_OP_ASYNC_CANCEL requests issued with
IOSQE_ASYNC, so add it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io-cancel.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index a4cc361..63d2f7d 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -115,7 +115,7 @@ static int do_io(struct io_uring *ring, int fd, int do_write)
 	return 0;
 }
 
-static int start_cancel(struct io_uring *ring, int do_partial)
+static int start_cancel(struct io_uring *ring, int do_partial, int async_cancel)
 {
 	struct io_uring_sqe *sqe;
 	int i, ret, submitted = 0;
@@ -129,6 +129,8 @@ static int start_cancel(struct io_uring *ring, int do_partial)
 			goto err;
 		}
 		io_uring_prep_cancel(sqe, (void *) (unsigned long) i + 1, 0);
+		if (async_cancel)
+			sqe->flags |= IOSQE_ASYNC;
 		sqe->user_data = 0;
 		submitted++;
 	}
@@ -148,7 +150,8 @@ err:
  * the submitted IO. This is done to verify that cancelling one piece of IO doesn't
  * impact others.
  */
-static int test_io_cancel(const char *file, int do_write, int do_partial)
+static int test_io_cancel(const char *file, int do_write, int do_partial,
+			  int async_cancel)
 {
 	struct io_uring ring;
 	struct timeval start_tv;
@@ -179,7 +182,7 @@ static int test_io_cancel(const char *file, int do_write, int do_partial)
 		goto err;
 	/* sleep for 1/3 of the total time, to allow some to start/complete */
 	usleep(usecs / 3);
-	if (start_cancel(&ring, do_partial))
+	if (start_cancel(&ring, do_partial, async_cancel))
 		goto err;
 	to_wait = BUFFERS;
 	if (do_partial)
@@ -512,13 +515,15 @@ int main(int argc, char *argv[])
 
 	vecs = t_create_buffers(BUFFERS, BS);
 
-	for (i = 0; i < 4; i++) {
-		int v1 = (i & 1) != 0;
-		int v2 = (i & 2) != 0;
+	for (i = 0; i < 8; i++) {
+		int write = (i & 1) != 0;
+		int partial = (i & 2) != 0;
+		int async = (i & 4) != 0;
 
-		ret = test_io_cancel(".basic-rw", v1, v2);
+		ret = test_io_cancel(".basic-rw", write, partial, async);
 		if (ret) {
-			fprintf(stderr, "test_io_cancel %d %d failed\n", v1, v2);
+			fprintf(stderr, "test_io_cancel %d %d %d failed\n",
+				write, partial, async);
 			goto err;
 		}
 	}
-- 
2.32.0

